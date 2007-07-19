Return-Path: <linux-kernel-owner+w=401wt.eu-S937922AbXGSJ3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937922AbXGSJ3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935245AbXGSJ3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:29:00 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:35855 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933539AbXGSJ27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:28:59 -0400
Date: Thu, 19 Jul 2007 09:51:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch] fix the softlockup watchdog to actually work
Message-ID: <20070719075152.GB12760@elte.hu>
References: <20070717114453.GA8212@elte.hu> <469CCF8F.4010107@goop.org> <20070717154934.GA24231@elte.hu> <20070719002231.069ebbdd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719002231.069ebbdd.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> But I'll sit on this patch for a while until this gets sorted out. 
> Meanwhile, please double-check the elapsed-time arithmetic in there, 
> maybe do a bit of runtime testing?

btw., could you apply the patch below as well? Maybe sched_clock() is 
misbehaving on your box? (with this i have 5 softlockup patches in my 
tree - and they are working fine so far.)

	Ingo

---------------->
Subject: [patch] softlockup: use a reliable global time source
From: Ingo Molnar <mingo@elte.hu>

using sched_clock() for the soft-lockups was a bad idea, sched_clock()
is not a reliable global time-source.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/softlockup.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux/kernel/softlockup.c
===================================================================
--- linux.orig/kernel/softlockup.c
+++ linux/kernel/softlockup.c
@@ -37,13 +37,11 @@ static struct notifier_block panic_block
 };
 
 /*
- * Returns seconds, approximately.  We don't need nanosecond
- * resolution, and we don't need to waste time with a big divide when
- * 2^30ns == 1.074s.
+ * Returns seconds.
  */
 static unsigned long get_timestamp(void)
 {
-	return sched_clock() >> 30;  /* 2^30 ~= 10^9 */
+	return jiffies / HZ;
 }
 
 void touch_softlockup_watchdog(void)
