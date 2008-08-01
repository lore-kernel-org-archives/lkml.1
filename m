Return-Path: <linux-kernel-owner+w=401wt.eu-S1760922AbYHAWmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760922AbYHAWmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756649AbYHAWlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:41:46 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:52108 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbYHAWlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:41:45 -0400
Date: Fri, 1 Aug 2008 18:41:25 -0400
From: Jeff Dike <jdike@addtoit.com>
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       WANG Cong <xiyou.wangcong@gmail.com>
Subject: [PATCH 2/14] uml: fix bad NTP interaction with clock
Message-ID: <20080801224125.GA13729@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2b95eda726d565d4abe3cac045022d3141a11b23 Mon Sep 17 00:00:00 2001

UML's supposed nanosecond clock interacts badly with NTP when NTP
decides that the clock has drifted ahead and needs to be slowed down.
Slowing down the clock is done by decrementing the cycle-to-nanosecond
multiplier, which is 1.  Decrementing that gives you 0 and time is
stopped.

This is fixed by switching to a microsecond clock, with a multiplier
of 1000.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/um/kernel/time.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/kernel/time.c b/arch/um/kernel/time.c
index e066e84..5036c81 100644
--- a/arch/um/kernel/time.c
+++ b/arch/um/kernel/time.c
@@ -74,7 +74,7 @@ static irqreturn_t um_timer(int irq, void *dev)
 
 static cycle_t itimer_read(void)
 {
-	return os_nsecs();
+	return os_nsecs() / 1000;
 }
 
 static struct clocksource itimer_clocksource = {
@@ -82,7 +82,7 @@ static struct clocksource itimer_clocksource = {
 	.rating		= 300,
 	.read		= itimer_read,
 	.mask		= CLOCKSOURCE_MASK(64),
-	.mult		= 1,
+	.mult		= 1000,
 	.shift		= 0,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
-- 
1.5.5.1

