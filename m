Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbZKBHrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbZKBHrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 02:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbZKBHrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 02:47:41 -0500
Received: from mail-px0-f179.google.com ([209.85.216.179]:47951 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbZKBHrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 02:47:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TSKTm6UAhEvpUvFz8yXoDvYz0wexM1AM985R9qyURbeVKigW/k/yJ6cqDaOGgCGmsH
         uHmXpvTK3senFZfNBFv5YKbWVzu581v/ArEWTMLXIrYjZAK3yrmmL9OwsIyj3U0qwphK
         9YH/CuaGoAyj8AB15yt0wJNZve0peEUH3A4sk=
Date: Sun, 1 Nov 2009 23:47:37 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Vojtech Pavlik <vojtech@suse.cz>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH][RFC] input: remove bios I8042_CTR_XLATE check to make
	keyboard usable
Message-ID: <20091102074737.GA3063@core.coreip.homeip.net>
References: <20091027053404.GA2241@darkstar.vlan7> <20091028054309.GA2368@core.coreip.homeip.net> <20091028100318.GA4861@suse.cz> <20091028104211.GA2207@darkstar.vlan7> <20091029003325.GA2739@darkstar.vlan7> <20091029032633.GA7959@core.coreip.homeip.net> <20091029071544.GA2220@darkstar.vlan7> <a8e1da0911010133u57bd85cfj6cdcb789edc4d522@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0911010133u57bd85cfj6cdcb789edc4d522@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Sun, Nov 01, 2009 at 04:33:05PM +0800, Dave Young wrote:
> On Thu, Oct 29, 2009 at 3:15 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> > On Wed, Oct 28, 2009 at 08:26:33PM -0700, Dmitry Torokhov wrote:
> >> On Thu, Oct 29, 2009 at 08:33:26AM +0800, Dave Young wrote:
> >> > On Wed, Oct 28, 2009 at 06:42:12PM +0800, Dave Young wrote:
> >> > > On Wed, Oct 28, 2009 at 11:03:18AM +0100, Vojtech Pavlik wrote:
> >> > > > On Tue, Oct 27, 2009 at 10:43:10PM -0700, Dmitry Torokhov wrote:
> >> > > > > Hi Dave,
> >> > > > >
> >> > > > > On Tue, Oct 27, 2009 at 01:34:04PM +0800, Dave Young wrote:
> >> > > > > >
> >> > > > > > Pressing somekey at early booting phase cause keyboard to be not usable
> >> > > > > > (The hardware is DELL latitude e5400):
> >> > > >
> >> > > > Does early booting mean while the BIOS is coming up? Does the keyboard
> >> > > > work in GRUB then? Or is it during the early init of the Linux kernel?
> >> > >
> >> > > Keyboard work under lilo.
> >> > > For the early booting I means the early init of the linux kernel
> >> > >
> >> > > >
> >> > > > > > atkbd.c: Unknown key pressed (raw set 2, code 0xd3 on isa0060/serio0).
> >> > > > > > atkbd.c: Use 'setkeycodes e053 <keycode>' to make it known.
> >> > > > > > atkbd.c: Unknown key pressed (raw set 2, code 0x1d3 on isa0060/serio0).
> >> > > > > > atkbd.c: Use 'setkeycodes e053 <keycode>' to make it known.
> >> > > > > >
> >> > > > > > i8042.c set i8042_direct to true when the controller init. But the result
> >> > > > > > is keyboard not usable, The only option is press the power button to shutdown.
> >> > > > > >
> >> > > > > > So here remove the bios check to fix it.
> >> > > >
> >> > > > My question would be: Why this happens? Could it be that the probe is
> >> > > > confused by the keypress and reads the CTR incorrectly? Or is it just
> >> > > > that the keyboard controller is in fact in translating mode, yet the CTR
> >> > > > indicates otherwise?
> >> > > >
> >> > > > A i8042.debug=1 log of the bad init would be good.
> >> > >
> >> > > Here it is (retrieve from syslog):
> >> >
> >> > Syslog redirect the debug info to another log file, sorry, post again:
> >> >
> >>
> >> Any chance of reconfiguring syslog so debug is captured in the same
> >> file? It is easier to see what is happening with the rest of context
> >> present...
> >
> > Sure, here it is:
> >

Does the patch below help by any chance?

Thanks.

-- 
Dmitry


Input: i8042 - try to get stable CTR value when initializing

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

If user presses keys while i8042 is being initialized there is a chance
that keyboard data will be mistaken for results of Read Control Register
command causing futher troubles. Work around this issue by reading CTR
several times and stop when we get matching results.

Reported-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/serio/i8042.c |   35 ++++++++++++++++++++++++++++-------
 1 files changed, 28 insertions(+), 7 deletions(-)


diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index a315781..43f2b19 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -836,17 +836,32 @@ static int i8042_controller_selftest(void)
 static int i8042_controller_init(void)
 {
 	unsigned long flags;
+	int n = 0;
+	unsigned char ctr[2];
 
 /*
- * Save the CTR for restoral on unload / reboot.
+ * Save the CTR for restore on unload / reboot.
  */
 
-	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_RCTR)) {
-		printk(KERN_ERR "i8042.c: Can't read CTR while initializing i8042.\n");
-		return -EIO;
-	}
+	do {
+		if (n >= 10) {
+			printk(KERN_ERR
+				"i8042.c: Unable to get stable CTR read.\n");
+			return -EIO;
+		}
+
+		if (n != 0)
+			udelay(50);
+
+		if (i8042_command(&ctr[n++ % 2], I8042_CMD_CTL_RCTR)) {
+			printk(KERN_ERR
+				"i8042.c: Can't read CTR while initializing i8042.\n");
+			return -EIO;
+		}
 
-	i8042_initial_ctr = i8042_ctr;
+	} while (n < 2 || ctr[0] != ctr[1]);
+
+	i8042_initial_ctr = i8042_ctr = ctr[0];
 
 /*
  * Disable the keyboard interface and interrupt.
@@ -895,6 +910,12 @@ static int i8042_controller_init(void)
 		return -EIO;
 	}
 
+/*
+ * Flush whatever accumulated while we were disabling keyboard port
+ */
+
+	i8042_flush();
+
 	return 0;
 }
 
@@ -914,7 +935,7 @@ static void i8042_controller_reset(void)
 	i8042_ctr |= I8042_CTR_KBDDIS | I8042_CTR_AUXDIS;
 	i8042_ctr &= ~(I8042_CTR_KBDINT | I8042_CTR_AUXINT);
 
-	if (i8042_command(&i8042_initial_ctr, I8042_CMD_CTL_WCTR))
+	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR))
 		printk(KERN_WARNING "i8042.c: Can't write CTR while resetting.\n");
 
 /*
