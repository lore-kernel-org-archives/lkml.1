Return-Path: <linux-kernel-owner+w=401wt.eu-S1752481AbZFDIho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbZFDIho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbZFDIhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:37:37 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:35894 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbZFDIhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:37:35 -0400
Date: Thu, 4 Jun 2009 10:37:27 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console: make blank timeout value a boot option
Message-ID: <20090604083726.GZ26148@buzzloop.caiaq.de>
References: <1243953993-18608-1-git-send-email-daniel@caiaq.de> <20090604002325.5b1284de.akpm@linux-foundation.org> <20090604074407.GX26148@buzzloop.caiaq.de> <20090604011740.5879732c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604011740.5879732c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 01:17:40AM -0700, Andrew Morton wrote:
> > That's already possible - there is an ioctl for that. It's just not
> > configurable at boot time, and that occured to be very annoying when
> > developing systems that won't fully boot up for >10mins. You have no way
> > to wake up the console then.
> 
> Oh.  Your changelog sucked :)
> 
> > Is there any concern why that shouldn't be a kernel option?
> 
> I suppose it makes sense.  You really have systems which take more than
> ten minutes to start running initscripts?  Poor you.

This happens during development only. Assume the system tries to mount
an NFS volume for its rootfs and fails due to a broken NIC driver; you
might be interessted in some debug output. Assume the kernel crashes
at boot time and you happen to miss that and come back to the machine
10 minutes later; you would still like to see the Oops. Or think about
situations where you forgot to add a userspace application to disable
the screen saver and you still want to see kernel messages and no input
device is attached to wake up the console. All possible scenarios where
this option would make sense.

I'm not saying it's the most important thing to have, but it's still
handy :)

> Please resend with a more complete description?

Attached. Better now?

Thanks,
Daniel


>From 9a77004367e49d41b58b81fb6a4882d0906a4743 Mon Sep 17 00:00:00 2001
From: Daniel Mack <daniel@caiaq.de>
Date: Tue, 2 Jun 2009 16:38:44 +0200
Subject: [PATCH] console: make blank timeout value a boot option

The console blank timer is currently hardcoded to 10*60 seconds which
might be annoying on systems with no input devices attached to wake up
the console again. Especially during development, disabling the screen
saver can be handy - for example when debugging the root fs mount
mechanism or other scenarios where no userspace program could be started
to do that at runtime from userspace.

This patch defines a core_param for the variable in charge which allows
users to entirely disable the blank feature at boot time by setting it
0. The value can still be overwritten at runtime using the standard
ioctl call - this just allows to conditionally change the default.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
---
 Documentation/kernel-parameters.txt |    4 ++++
 drivers/char/vt.c                   |   13 +++++++------
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e87bdbf..67331e8 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -545,6 +545,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			console=brl,ttyS0
 		For now, only VisioBraille is supported.
 
+	consoleblank=	[KNL] The console blank (screen saver) timeout in
+			seconds. Defaults to 10*60 = 10mins. A value of 0
+			disables the blank timer.
+
 	coredump_filter=
 			[KNL] Change the default value for
 			/proc/<pid>/coredump_filter.
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 08151d4..85efe81 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -172,8 +172,9 @@ int do_poke_blanked_console;
 int console_blanked;
 
 static int vesa_blank_mode; /* 0:none 1:suspendV 2:suspendH 3:powerdown */
-static int blankinterval = 10*60*HZ;
 static int vesa_off_interval;
+static int blankinterval = 10*60;
+core_param(consoleblank, blankinterval, int, 0444);
 
 static DECLARE_WORK(console_work, console_callback);
 
@@ -1486,7 +1487,7 @@ static void setterm_command(struct vc_data *vc)
 			update_attr(vc);
 			break;
 		case 9:	/* set blanking interval */
-			blankinterval = ((vc->vc_par[1] < 60) ? vc->vc_par[1] : 60) * 60 * HZ;
+			blankinterval = ((vc->vc_par[1] < 60) ? vc->vc_par[1] : 60) * 60;
 			poke_blanked_console();
 			break;
 		case 10: /* set bell frequency in Hz */
@@ -2872,7 +2873,7 @@ static int __init con_init(void)
 
 	if (blankinterval) {
 		blank_state = blank_normal_wait;
-		mod_timer(&console_timer, jiffies + blankinterval);
+		mod_timer(&console_timer, jiffies + (blankinterval * HZ));
 	}
 
 	/*
@@ -3681,7 +3682,7 @@ void do_unblank_screen(int leaving_gfx)
 		return; /* but leave console_blanked != 0 */
 
 	if (blankinterval) {
-		mod_timer(&console_timer, jiffies + blankinterval);
+		mod_timer(&console_timer, jiffies + (blankinterval * HZ));
 		blank_state = blank_normal_wait;
 	}
 
@@ -3715,7 +3716,7 @@ void unblank_screen(void)
 static void blank_screen_t(unsigned long dummy)
 {
 	if (unlikely(!keventd_up())) {
-		mod_timer(&console_timer, jiffies + blankinterval);
+		mod_timer(&console_timer, jiffies + (blankinterval * HZ));
 		return;
 	}
 	blank_timer_expired = 1;
@@ -3745,7 +3746,7 @@ void poke_blanked_console(void)
 	if (console_blanked)
 		unblank_screen();
 	else if (blankinterval) {
-		mod_timer(&console_timer, jiffies + blankinterval);
+		mod_timer(&console_timer, jiffies + (blankinterval * HZ));
 		blank_state = blank_normal_wait;
 	}
 }
-- 
1.6.3.1

