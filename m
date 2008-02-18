Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbYBRNq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbYBRNq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbYBRNqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:46:49 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34908 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751246AbYBRNqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:46:48 -0500
Date: Mon, 18 Feb 2008 14:38:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, jikos@suse.cz,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andrew Morton <akpm@osdl.org>
Subject: tsc breaks atkbd suspend
Message-ID: <20080218133852.GA1573@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm trying to use the "sleepy test" here, unfortunately it locks for
10-or-so seconds.

Problem is in wait_event_timeout: timeouts take about 100x as long as
they should. Code in drivers/input/serio/libps2.c:

+       printk("ps2_command waiting event: %d\n", timeout);
        timeout = wait_event_timeout(ps2dev->wait,
                                     !(ps2dev->flags & PS2_FLAG_CMD1),timeout);

        if (ps2dev->cmdcnt && timeout > 0) {
+               printk("wait_event returned: %d\n", timeout);

                timeout = ps2_adjust_timeout(ps2dev, command, timeout);
+
+               printk("ps2_command adjust timeout: %d\n", timeout);
                wait_event_timeout(ps2dev->wait,
                                   !(ps2dev->flags & PS2_FLAG_CMD), timeout);
        }

+       printk("ps2_command receiving\n");


...and I get hang after "ps2_command adjust timeout" for 10 seconds,
while it should  wait 10msec or so.

I even tried adding:

+       printk("ps2: testing timeouts\n");
+       timeout = wait_event_timeout(ps2dev->wait, 0, 10);
+       printk("ps2: testing timeouts\n");
+       timeout = wait_event_timeout(ps2dev->wait, 0, 10);
+       printk("ps2: testing timeouts\n");
+       timeout = wait_event_timeout(ps2dev->wait, 0, 10);
+       printk("ps2: testing timeouts\n");
+       timeout = wait_event_timeout(ps2dev->wait, 0, 10);
+       printk("ps2: testing timeouts\n");
+       timeout = wait_event_timeout(ps2dev->wait, 0, 10);
+       printk("ps2: timeouts ok?\n");

before that, and yes, those wait too long, too... (but only during
suspend, they work ok during boot).

nohz=off fixes that.

notsc fixes that, too... On my system (thinkpad x60 in UP mode) tsc is
normally marked unstable very shortly after boot, so only sleepy test
can trigger this.

I believe it is very bad idea to use tsc, it does not work on 90%+ of
machines. Yes, we do detect it is broken during runtime, but that's
too late.

I believe fix is very simple:

Signed-off-by: Pavel Machek <pavel@suse.cz>
									Pavel

diff --git a/arch/x86/kernel/tsc_32.c b/arch/x86/kernel/tsc_32.c
index 43517e3..fafd9dc 100644
--- a/arch/x86/kernel/tsc_32.c
+++ b/arch/x86/kernel/tsc_32.c
@@ -298,7 +298,7 @@ static cycle_t read_tsc(void)
 
 static struct clocksource clocksource_tsc = {
 	.name			= "tsc",
-	.rating			= 300,
+	.rating			= 0,
 	.read			= read_tsc,
 	.mask			= CLOCKSOURCE_MASK(64),
 	.mult			= 0, /* to be set */
diff --git a/arch/x86/kernel/tsc_64.c b/arch/x86/kernel/tsc_64.c
index 947554d..b0148d3 100644
--- a/arch/x86/kernel/tsc_64.c
+++ b/arch/x86/kernel/tsc_64.c
@@ -306,7 +306,7 @@ static cycle_t __vsyscall_fn vread_tsc(v
 
 static struct clocksource clocksource_tsc = {
 	.name			= "tsc",
-	.rating			= 300,
+	.rating			= 0,
 	.read			= read_tsc,
 	.mask			= CLOCKSOURCE_MASK(64),
 	.shift			= 22,

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
