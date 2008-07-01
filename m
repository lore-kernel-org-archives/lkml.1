Return-Path: <linux-kernel-owner+w=401wt.eu-S1760348AbYGAVYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760348AbYGAVYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 17:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759478AbYGAVYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 17:24:11 -0400
Received: from mx0.cs.man.ac.uk ([130.88.193.5]:55933 "EHLO mx0.cs.man.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758148AbYGAVYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 17:24:07 -0400
X-Greylist: delayed 1912 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jul 2008 17:24:07 EDT
Message-ID: <486A98EC.1090502@brej.org>
Date: Tue, 01 Jul 2008 21:51:56 +0100
From: Charlie Brej <linux-kernel@brej.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] pcspkr/vt_ioctl: PC speaker volume control
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (mx0.cs.man.ac.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The attached patch allows the system to control the volume of the system bell.
It adds a new ioctl code (KDSETVOLUME at 0x4B2E) to the set in terminals. This
ioctl takes an argument which specifies the new volume level. It also adds a
new event (SND_VOLUME) into the EV_SND set (the parameter is the new volume).

The bell itself is controlled by switching the output of the i8253 between 0, 1
or a high frequency toggle between 1 and 0 which due to capacitance gives rough
analogue levels. It uses hrtimer to trigger the changes. If volume is set to
maximum then the original code is used. If volume is set to 0 then no noise is
generated.

Comments desired.

To test:
--------
#include <stdio.h>
#include <linux/kd.h>
#include <sys/ioctl.h>
#include <fcntl.h>
int main(int argc, char **argv)
{
   long  volume, pitch, ms;
   int   fd;
   fd  = open("/dev/tty0", O_RDONLY);
   pitch     = 400;
   volume    = 10;
   ms        = 100;
   if (pitch) pitch       = 1193180 / pitch;
   ioctl(fd, KDSETVOLUME, volume);
   ioctl(fd, KDMKTONE, (ms<<16)|pitch);
}




PATCH:
---------
  drivers/char/keyboard.c     |   12 +++
  drivers/char/vt_ioctl.c     |    9 +++
  drivers/input/misc/pcspkr.c |  166 ++++++++++++++++++++++++++++++++++--------
  include/linux/input.h       |    1 +
  include/linux/kd.h          |    1 +
  include/linux/vt_kern.h     |    1 +
  6 files changed, 158 insertions(+), 32 deletions(-)

diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index d9a0a53..c7648e5 100644
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -220,6 +220,18 @@ int setkeycode(unsigned int scancode, unsigned int keycode)
  /*
   * Making beeps and bells.
   */
+void kd_set_volume(unsigned int volume)
+{
+	struct input_handle *handle;
+
+	list_for_each_entry(handle, &kbd_handler.h_list, h_node) {
+	if (test_bit(EV_SND, handle->dev->evbit)) {
+		if (test_bit(SND_VOLUME, handle->dev->sndbit))
+			input_inject_event(handle, EV_SND, SND_VOLUME, volume);
+		}
+	}
+}
+
  static void kd_nosound(unsigned long ignored)
  {
  	struct input_handle *handle;
diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index 3211afd..cd74ff4 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -421,6 +421,15 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
  		break;
  	}

+	case KDSETVOLUME:
+		if (!perm)
+			goto eperm;
+		/*
+		 * Set the system beep/tone volume
+		*/
+		kd_set_volume(arg);
+		break;
+
  	case KDGKBTYPE:
  		/*
  		 * this is naive.
diff --git a/drivers/input/misc/pcspkr.c b/drivers/input/misc/pcspkr.c
index 43aaa5c..4219485 100644
--- a/drivers/input/misc/pcspkr.c
+++ b/drivers/input/misc/pcspkr.c
@@ -18,6 +18,7 @@
  #include <linux/input.h>
  #include <linux/platform_device.h>
  #include <asm/io.h>
+#include <linux/hrtimer.h>

  MODULE_AUTHOR("Vojtech Pavlik <vojtech@ucw.cz>");
  MODULE_DESCRIPTION("PC Speaker beeper driver");
@@ -32,40 +33,125 @@ MODULE_ALIAS("platform:pcspkr");
  static DEFINE_SPINLOCK(i8253_lock);
  #endif

-static int pcspkr_event(struct input_dev *dev, unsigned int type, unsigned int code, int value)
+
+#define MAX_VOL 100
+
+struct pcspkr_state {
+	int     delay;
+	unsigned int     value_low;
+	unsigned int     value_high;
+	int     high;
+	struct  hrtimer timer;
+	struct  input_dev   *pcspkr_dev;
+};
+
+
+enum hrtimer_restart pcspkr_do_timer(struct hrtimer *handle)
  {
-	unsigned int count = 0;
+	struct pcspkr_state *spkr_state =
+        container_of(handle, struct pcspkr_state, timer);
+	int value;
  	unsigned long flags;
+
+
+
+
+	if (spkr_state->high) {
+		value = spkr_state->value_high-1;;
+		spkr_state->high=0;
+	} else {
+		value = spkr_state->value_low-1;
+		spkr_state->high=1;
+	}
+	
+	
+	spin_lock_irqsave(&i8253_lock, flags);
+	if (value){
+		if (value>=50){
+			outb_p(inb_p(0x61) | 3, 0x61);
+			outb_p(0xB4, 0x43);
+			outb_p(0xFF, 0x42);
+			outb(0xFF, 0x42);
+		}
+		else{
+		outb_p(inb_p(0x61) | 3, 0x61);
+		outb_p(0xB4, 0x43);
+		outb_p(value & 0xFF, 0x42);
+		outb((value>>8)& 0xFF, 0x42);
+		}
+	}
+	else{
+		outb(inb_p(0x61) & 0xFC, 0x61);
+	}
+	spin_unlock_irqrestore(&i8253_lock, flags);
+
+	hrtimer_forward_now(&spkr_state->timer, ktime_set(0, spkr_state->delay));
+	return HRTIMER_RESTART;
+}

+
+
+static int pcspkr_event(struct input_dev *dev, unsigned int type,
+			unsigned int code, int value)
+{
+	struct pcspkr_state *spkr_state = input_get_drvdata(dev);
+	unsigned long flags;
+
  	if (type != EV_SND)
  		return -1;
-
+	if (code == SND_VOLUME){
+		if (value <=0) {
+			spkr_state->value_low = 1;
+			spkr_state->value_high = 1;
+		}
+		else{
+			if (value>MAX_VOL) value = MAX_VOL;
+			spkr_state->value_low = MAX_VOL/value;
+			value = (MAX_VOL/spkr_state->value_low)-value;
+			if (value)
+				spkr_state->value_high = MAX_VOL/value;
+			else
+				spkr_state->value_high = MAX_VOL;
+		}
+		return 0;
+	}
+
  	switch (code) {
  		case SND_BELL: if (value) value = 1000;
  		case SND_TONE: break;
  		default: return -1;
  	}
-
-	if (value > 20 && value < 32767)
-		count = PIT_TICK_RATE / value;
-
-	spin_lock_irqsave(&i8253_lock, flags);
-
-	if (count) {
-		/* enable counter 2 */
-		outb_p(inb_p(0x61) | 3, 0x61);
-		/* set command for counter 2, 2 byte write */
-		outb_p(0xB6, 0x43);
-		/* select desired HZ */
-		outb_p(count & 0xff, 0x42);
-		outb((count >> 8) & 0xff, 0x42);
-	} else {
-		/* disable counter 2 */
-		outb(inb_p(0x61) & 0xFC, 0x61);
+
+	if (value){
+		unsigned int delay;
+		if(value<20) value=20;
+		else if(value>32767) value=32767;
+		if (spkr_state->value_low == 1){
+			if (spkr_state->value_high == 1) return 0;
+			if (spkr_state->value_high == MAX_VOL){
+                        	unsigned int count = PIT_TICK_RATE / value;
+				/* enable counter 2 */
+				outb_p(inb_p(0x61) | 3, 0x61);
+				/* set command for counter 2, 2 byte write */
+				outb_p(0xB6, 0x43);
+				/* select desired HZ */
+				outb_p(count & 0xff, 0x42);
+        			outb((count >> 8) & 0xff, 0x42);
+				return 0;
+			}
+		}
+		delay = 1000000000/value;
+		spkr_state->delay = delay/2;
+		spkr_state->high = 0;
+		hrtimer_start(&spkr_state->timer, ktime_set(0, 0),
+				HRTIMER_MODE_REL);
  	}
-
-	spin_unlock_irqrestore(&i8253_lock, flags);
-
+    	else{
+		hrtimer_cancel(&spkr_state->timer);
+		spin_lock_irqsave(&i8253_lock, flags);
+		outb(inb_p(0x61) & 0xFC, 0x61);
+		spin_unlock_irqrestore(&i8253_lock, flags);
+        }
  	return 0;
  }

@@ -73,6 +159,7 @@ static int __devinit pcspkr_probe(struct platform_device *dev)
  {
  	struct input_dev *pcspkr_dev;
  	int err;
+	struct pcspkr_state *spkr_state;

  	pcspkr_dev = input_allocate_device();
  	if (!pcspkr_dev)
@@ -87,7 +174,8 @@ static int __devinit pcspkr_probe(struct platform_device *dev)
  	pcspkr_dev->dev.parent = &dev->dev;

  	pcspkr_dev->evbit[0] = BIT_MASK(EV_SND);
-	pcspkr_dev->sndbit[0] = BIT_MASK(SND_BELL) | BIT_MASK(SND_TONE);
+	pcspkr_dev->sndbit[0] = BIT_MASK(SND_BELL) | BIT_MASK(SND_TONE)|
+        			BIT_MASK(SND_VOLUME);
  	pcspkr_dev->event = pcspkr_event;

  	err = input_register_device(pcspkr_dev);
@@ -95,27 +183,40 @@ static int __devinit pcspkr_probe(struct platform_device *dev)
  		input_free_device(pcspkr_dev);
  		return err;
  	}
-
-	platform_set_drvdata(dev, pcspkr_dev);
+
+	spkr_state = kzalloc(sizeof(*spkr_state), GFP_KERNEL);
+	if (!spkr_state)
+		return -ENOMEM;
+
+	spkr_state->pcspkr_dev = pcspkr_dev;
+	spkr_state->value_high = MAX_VOL;
+	spkr_state->value_low = 1;
+
+	hrtimer_init(&spkr_state->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	spkr_state->timer.function = pcspkr_do_timer;
+	platform_set_drvdata(dev, spkr_state);
+	input_set_drvdata(pcspkr_dev, spkr_state);

  	return 0;
  }

  static int __devexit pcspkr_remove(struct platform_device *dev)
  {
-	struct input_dev *pcspkr_dev = platform_get_drvdata(dev);
+	struct pcspkr_state *spkr_state = platform_get_drvdata(dev);

-	input_unregister_device(pcspkr_dev);
-	platform_set_drvdata(dev, NULL);
  	/* turn off the speaker */
-	pcspkr_event(NULL, EV_SND, SND_BELL, 0);
+	pcspkr_event(spkr_state->pcspkr_dev, EV_SND, SND_BELL, 0);
+	input_unregister_device(spkr_state->pcspkr_dev);
+	platform_set_drvdata(dev, NULL);
+	kfree(spkr_state);

  	return 0;
  }

  static int pcspkr_suspend(struct platform_device *dev, pm_message_t state)
  {
-	pcspkr_event(NULL, EV_SND, SND_BELL, 0);
+	struct pcspkr_state *spkr_state = platform_get_drvdata(dev);
+	pcspkr_event(spkr_state->pcspkr_dev, EV_SND, SND_BELL, 0);

  	return 0;
  }
@@ -123,7 +224,8 @@ static int pcspkr_suspend(struct platform_device *dev, pm_message_t state)
  static void pcspkr_shutdown(struct platform_device *dev)
  {
  	/* turn off the speaker */
-	pcspkr_event(NULL, EV_SND, SND_BELL, 0);
+	struct pcspkr_state *spkr_state = platform_get_drvdata(dev);
+	pcspkr_event(spkr_state->pcspkr_dev, EV_SND, SND_BELL, 0);
  }

  static struct platform_driver pcspkr_platform_driver = {
diff --git a/include/linux/input.h b/include/linux/input.h
index d150c57..69a2366 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -688,6 +688,7 @@ struct input_absinfo {
  #define SND_CLICK		0x00
  #define SND_BELL		0x01
  #define SND_TONE		0x02
+#define SND_VOLUME		0x03
  #define SND_MAX			0x07
  #define SND_CNT			(SND_MAX+1)

diff --git a/include/linux/kd.h b/include/linux/kd.h
index 15f2853..01fb9f8 100644
--- a/include/linux/kd.h
+++ b/include/linux/kd.h
@@ -21,6 +21,7 @@ struct consolefontdesc {
  #define GIO_CMAP	0x4B70	/* gets colour palette on VGA+ */
  #define PIO_CMAP	0x4B71	/* sets colour palette on VGA+ */

+#define KDSETVOLUME	0x4B2E	/* set system beep/tone volume */
  #define KIOCSOUND	0x4B2F	/* start sound generation (0 for off) */
  #define KDMKTONE	0x4B30	/* generate tone */

diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index 9448ffb..0910b26 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -25,6 +25,7 @@
  #define BROKEN_GRAPHICS_PROGRAMS 1
  #endif

+extern void kd_set_volume(unsigned int volume);
  extern void kd_mksound(unsigned int hz, unsigned int ticks);
  extern int kbd_rate(struct kbd_repeat *rep);
  extern int fg_console, last_console, want_console;

