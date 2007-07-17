Return-Path: <linux-kernel-owner+w=401wt.eu-S1765059AbXGQLpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765059AbXGQLpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 07:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbXGQLpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 07:45:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54247 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbXGQLpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 07:45:10 -0400
Date: Tue, 17 Jul 2007 13:44:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch] softlockup watchdog: fix Xen bogosity
Message-ID: <20070717114453.GA8212@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: softlockup: fix Xen bogosity
From: Ingo Molnar <mingo@elte.hu>

this Xen related commit:

   commit 966812dc98e6a7fcdf759cbfa0efab77500a8868
   Author: Jeremy Fitzhardinge <jeremy@goop.org>
   Date:   Tue May 8 00:28:02 2007 -0700

       Ignore stolen time in the softlockup watchdog

broke the softlockup watchdog to never report any lockups. (!)

print_timestamp defaults to 0, this makes the following condition
always true:

	if (print_timestamp < (touch_timestamp + 1) ||

and we'll never report soft lockups.

apparently the functionality of the soft lockup watchdog was never 
actually tested with that patch applied ...

[ this is -stable material too. ]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/softlockup.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux/kernel/softlockup.c
===================================================================
--- linux.orig/kernel/softlockup.c
+++ linux/kernel/softlockup.c
@@ -79,10 +79,11 @@ void softlockup_tick(void)
 	print_timestamp = per_cpu(print_timestamp, this_cpu);
 
 	/* report at most once a second */
-	if (print_timestamp < (touch_timestamp + 1) ||
-		did_panic ||
-			!per_cpu(watchdog_task, this_cpu))
+	if ((print_timestamp >= touch_timestamp &&
+			print_timestamp < (touch_timestamp + 1)) ||
+			did_panic || !per_cpu(watchdog_task, this_cpu)) {
 		return;
+	}
 
 	/* do not print during early bootup: */
 	if (unlikely(system_state != SYSTEM_RUNNING)) {
