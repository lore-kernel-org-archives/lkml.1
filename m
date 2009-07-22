Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbZGVPTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbZGVPTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbZGVPTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:19:41 -0400
Received: from www.tglx.de ([62.245.132.106]:57106 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbZGVPTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:19:40 -0400
Date: Wed, 22 Jul 2009 17:19:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] timer fixes for 2.6.31
Message-ID: <alpine.LFD.2.00.0907221718410.2813@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

Thanks,

	tglx

------------------>
Pavel Roskin (1):
      timer: Avoid reading uninitialized data

Thomas Gleixner (1):
      clocksource: Prevent NULL pointer dereference


 kernel/time/clocksource.c |    2 +-
 kernel/timer.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 592bf58..7466cb8 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -513,7 +513,7 @@ static ssize_t sysfs_override_clocksource(struct sys_device *dev,
 	 * Check to make sure we don't switch to a non-highres capable
 	 * clocksource if the tick code is in oneshot mode (highres or nohz)
 	 */
-	if (tick_oneshot_mode_active() &&
+	if (tick_oneshot_mode_active() && ovr &&
 	    !(ovr->flags & CLOCK_SOURCE_VALID_FOR_HRES)) {
 		printk(KERN_WARNING "%s clocksource is not HRT compatible. "
 			"Cannot switch while in HRT/NOHZ mode\n", ovr->name);
diff --git a/kernel/timer.c b/kernel/timer.c
index 0b36b9e..a7f07d5 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -714,7 +714,7 @@ int mod_timer(struct timer_list *timer, unsigned long expires)
 	 * networking code - if the timer is re-modified
 	 * to be the same thing then just return:
 	 */
-	if (timer->expires == expires && timer_pending(timer))
+	if (timer_pending(timer) && timer->expires == expires)
 		return 1;
 
 	return __mod_timer(timer, expires, false, TIMER_NOT_PINNED);
