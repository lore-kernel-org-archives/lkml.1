Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbXLFMEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbXLFMEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbXLFMEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:04:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50624 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbXLFMEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:04:30 -0500
Date: Thu, 6 Dec 2007 13:04:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: suspend-related lockdep warning
Message-ID: <20071206120409.GB26686@elte.hu>
References: <20071128024355.5931c6ec.akpm@linux-foundation.org> <200712032334.27088.rjw@sisk.pl> <20071203174505.c5ea84c4.akpm@linux-foundation.org> <200712060121.24837.rjw@sisk.pl> <1196937088.6788.56.camel@twins> <20071206040102.c6b8e9b0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071206040102.c6b8e9b0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> It would be nice to make that warning tell us that - we've hit it a 
> few times and I never knew this was the reason.

i'm a mind-reader and a time-traveler as well, so i've got the patch 
below lined up in my sched.git queue already :-)

	Ingo

-------------->
Subject: lockdep: make cli/sti annotation warnings clearer
From: Ingo Molnar <mingo@elte.hu>

make cli/sti annotation warnings easier to interpret.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

Index: linux/kernel/lockdep.c
===================================================================
--- linux.orig/kernel/lockdep.c
+++ linux/kernel/lockdep.c
@@ -2654,10 +2654,15 @@ static void check_flags(unsigned long fl
 	if (!debug_locks)
 		return;
 
-	if (irqs_disabled_flags(flags))
-		DEBUG_LOCKS_WARN_ON(current->hardirqs_enabled);
-	else
-		DEBUG_LOCKS_WARN_ON(!current->hardirqs_enabled);
+	if (irqs_disabled_flags(flags)) {
+		if (DEBUG_LOCKS_WARN_ON(current->hardirqs_enabled)) {
+			printk("possible reason: unannotated irqs-off.\n");
+		}
+	} else {
+		if (DEBUG_LOCKS_WARN_ON(!current->hardirqs_enabled)) {
+			printk("possible reason: unannotated irqs-on.\n");
+		}
+	}
 
 	/*
 	 * We dont accurately track softirq state in e.g.
