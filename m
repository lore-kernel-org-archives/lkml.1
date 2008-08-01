Return-Path: <linux-kernel-owner+w=401wt.eu-S1758307AbYHATNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307AbYHATNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 15:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYHATM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 15:12:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135AbYHATM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 15:12:57 -0400
Date: Fri, 1 Aug 2008 12:12:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: linux-next: Tree for July 30
In-Reply-To: <20080731194207.GA12233@anvil.corenet.prv>
Message-ID: <alpine.LFD.1.10.0808011201480.3277@nehalem.linux-foundation.org>
References: <20080730170635.f737ffe9.sfr@canb.auug.org.au> <20080731104437.5e5669bc.akpm@linux-foundation.org> <20080731141302.ZZRA012@mailhub.coreip.homeip.net> <200807312048.57575.rjw@sisk.pl> <20080731145023.ZZRA012@mailhub.coreip.homeip.net>
 <alpine.LFD.1.10.0807311207000.3277@nehalem.linux-foundation.org> <20080731151625.ZZRA012@mailhub.coreip.homeip.net> <20080731194207.GA12233@anvil.corenet.prv>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, I apparently missed this whole subthread yesterday, only getting back 
to it when going over my old queues.

On Thu, 31 Jul 2008, Dmitry Torokhov wrote:
> 
> Input: paper over a bug in Synaptics X driver

Yeah, it's not pretty, but how about moving that EV_KEY thing into the 
switch() statement? Also, the printk could certainly be a bit more useful.

But before doing _any_ of that, the first thing to do should be to not 
have that four-deep indentation by just splitting that horrible function 
up a bit.

IOW, start off with a patch like the appended, and _then_ add the special 
case handling to the EV_KEY thing. It would probably be most easily done 
by just literally limiting "len" to OLD_KEY_MAX. Something like

   #define OLD_KEY_MAX 0x1ff
   ...
	case EV_KEY:
		bits = dev->keybit;
		len = KEY_MAX;
		/* Hacky workaround for old bug in Xorg */
		if (buf_len == OLD_KEY_MAX) 
			len = OLD_KEY_MAX;
		break;
  ...

or similar.

Yeah, it's not pretty, but pragmatism before beauty.

		Linus
---
 drivers/input/evdev.c |   44 ++++++++++++++++++++++++--------------------
 1 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 2d65411..ef8c2ed 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -647,6 +647,28 @@ static int str_to_user(const char *str, unsigned int maxlen, void __user *p)
 	return copy_to_user(p, str, len) ? -EFAULT : len;
 }
 
+static int handle_eviocgbit(struct input_dev *dev, unsigned int cmd, void __user *p, int compat_mode)
+{
+	unsigned long *bits;
+	int len;
+
+	switch (_IOC_NR(cmd) & EV_MAX) {
+
+	case      0: bits = dev->evbit;  len = EV_MAX;  break;
+	case EV_KEY: bits = dev->keybit; len = KEY_MAX; break;
+	case EV_REL: bits = dev->relbit; len = REL_MAX; break;
+	case EV_ABS: bits = dev->absbit; len = ABS_MAX; break;
+	case EV_MSC: bits = dev->mscbit; len = MSC_MAX; break;
+	case EV_LED: bits = dev->ledbit; len = LED_MAX; break;
+	case EV_SND: bits = dev->sndbit; len = SND_MAX; break;
+	case EV_FF:  bits = dev->ffbit;  len = FF_MAX;  break;
+	case EV_SW:  bits = dev->swbit;  len = SW_MAX;  break;
+	default: return -EINVAL;
+	}
+	return bits_to_user(bits, len, _IOC_SIZE(cmd), p, compat_mode);
+}
+
+
 static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 			   void __user *p, int compat_mode)
 {
@@ -733,26 +755,8 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 
 		if (_IOC_DIR(cmd) == _IOC_READ) {
 
-			if ((_IOC_NR(cmd) & ~EV_MAX) == _IOC_NR(EVIOCGBIT(0, 0))) {
-
-				unsigned long *bits;
-				int len;
-
-				switch (_IOC_NR(cmd) & EV_MAX) {
-
-				case      0: bits = dev->evbit;  len = EV_MAX;  break;
-				case EV_KEY: bits = dev->keybit; len = KEY_MAX; break;
-				case EV_REL: bits = dev->relbit; len = REL_MAX; break;
-				case EV_ABS: bits = dev->absbit; len = ABS_MAX; break;
-				case EV_MSC: bits = dev->mscbit; len = MSC_MAX; break;
-				case EV_LED: bits = dev->ledbit; len = LED_MAX; break;
-				case EV_SND: bits = dev->sndbit; len = SND_MAX; break;
-				case EV_FF:  bits = dev->ffbit;  len = FF_MAX;  break;
-				case EV_SW:  bits = dev->swbit;  len = SW_MAX;  break;
-				default: return -EINVAL;
-				}
-				return bits_to_user(bits, len, _IOC_SIZE(cmd), p, compat_mode);
-			}
+			if ((_IOC_NR(cmd) & ~EV_MAX) == _IOC_NR(EVIOCGBIT(0, 0)))
+				return handle_eviocgbit(dev, cmd, p, compat_mode);
 
 			if (_IOC_NR(cmd) == _IOC_NR(EVIOCGKEY(0)))
 				return bits_to_user(dev->key, KEY_MAX, _IOC_SIZE(cmd),
