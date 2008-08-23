Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbYHWNhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbYHWNhx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 09:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbYHWNhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 09:37:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51366 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbYHWNhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 09:37:41 -0400
Date: Sat, 23 Aug 2008 15:36:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Witbrodt <dawitbro@sbcglobal.net>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
       Bill Fink <billfink@mindspring.com>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       netdev <netdev@vger.kernel.org>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user
	with the same regression
Message-ID: <20080823133643.GA23766@elte.hu>
References: <825188.80277.qm@web82105.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <825188.80277.qm@web82105.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


David,

could you try the debug patch below ontop of latest tip/master:

  http://people.redhat.com/mingo/tip.git/README

the patch forcibly ignores resource conflicts and reports them. This 
will likely break some system - but if your hpet troubles are due to 
resource conflicts then this patch would make the kernel boot up fine on 
your system by default, with a working hpet.

You should also be getting a printout and a warning in the dmesg in that 
case.

	Ingo

------------>
>From 092990e259a462d39f1d8e9cd542898632b95fde Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 23 Aug 2008 15:33:51 +0200
Subject: [PATCH] debug hack: ignore resource conflicts

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/resource.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index f5b518e..8419d56 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -156,6 +156,7 @@ static struct resource * __request_resource(struct resource *root, struct resour
 	for (;;) {
 		tmp = *p;
 		if (!tmp || tmp->start > end) {
+insert:
 			new->sibling = tmp;
 			*p = new;
 			new->parent = root;
@@ -164,7 +165,9 @@ static struct resource * __request_resource(struct resource *root, struct resour
 		p = &tmp->sibling;
 		if (tmp->end < start)
 			continue;
-		return tmp;
+		printk("ignoring resource conflict between %s/{%p..%p} and %s/{%p..%p}\n", new->name, (void *)new->start, (void *)new->end, tmp->name, (void *)tmp->start, (void *)tmp->end);
+		WARN_ON(1);
+		goto insert;
 	}
 }
 
