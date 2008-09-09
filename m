Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbYIIUdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbYIIUdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 16:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbYIIUdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 16:33:08 -0400
Received: from www.tglx.de ([62.245.132.106]:46016 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594AbYIIUdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 16:33:06 -0400
Date: Tue, 9 Sep 2008 22:32:39 +0200 (CEST)
From: Thomas Gleixner <tglx@tglx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] timer updates for 2.6.27
Message-ID: <alpine.LFD.1.10.0809092213010.13819@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

This removes a WARN_ON which I (ab)used to gather information about
the HPET reprogramming issue. It served it's purpose and can be
removed now.

Thanks,

	tglx

------------------>
Thomas Gleixner (1):
      clockevents: remove WARN_ON which was used to gather information


 kernel/time/tick-oneshot.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
index 2e35501..2e8de67 100644
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -43,19 +43,17 @@ int tick_dev_program_event(struct clock_event_device *dev, ktime_t expires,
 		 * and emit a warning.
 		 */
 		if (++i > 2) {
-			printk(KERN_WARNING "CE: __tick_program_event of %s is "
-			       "stuck %llx %llx\n", dev->name ? dev->name : "?",
-			       now.tv64, expires.tv64);
-			printk(KERN_WARNING
-			       "CE: increasing min_delta_ns %ld to %ld nsec\n",
-			       dev->min_delta_ns, dev->min_delta_ns << 1);
-			WARN_ON(1);
-
-			/* Double the min. delta and try again */
+			/* Increase the min. delta and try again */
 			if (!dev->min_delta_ns)
 				dev->min_delta_ns = 5000;
 			else
-				dev->min_delta_ns <<= 1;
+				dev->min_delta_ns += dev->min_delta_ns >> 1;
+
+			printk(KERN_WARNING
+			       "CE: %s increasing min_delta_ns to %lu nsec\n",
+			       dev->name ? dev->name : "?",
+			       dev->min_delta_ns << 1);
+
 			i = 0;
 		}
 
