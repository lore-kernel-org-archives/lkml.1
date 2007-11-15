Return-Path: <linux-kernel-owner+w=401wt.eu-S1765233AbXKOLcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765233AbXKOLcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 06:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757336AbXKOLcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 06:32:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37299 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759167AbXKOLcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 06:32:32 -0500
Date: Thu, 15 Nov 2007 12:32:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Miller <davem@davemloft.net>, mpm@selenic.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch] slob: fix memory corruption
Message-ID: <20071115113204.GA24463@elte.hu>
References: <20071114225335.GV19691@waste.org> <20071114.154143.112110604.davem@davemloft.net> <20071115104331.GA11390@elte.hu> <200711152157.59409.nickpiggin@yahoo.com.au> <20071115112820.GA18228@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115112820.GA18228@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > I had implemented SLOB in userspace, so I resynched and think I 
> > found your problem. Sorry for the attachment format -- this mailer 
> > isn't the best. I'm really computer illiterate when it comes to 
> > userspace...
> 
> thx, i'll try your fix in a minute.

that did the trick! Nick, find an updated patch below. (reference to the 
bugzilla added.)

	Ingo

-------------------->
Subject: slob: fix memory corruption
From: Nick Piggin <npiggin@suse.de>

Previously, it would be possible for prev->next to point to
&free_slob_pages, and thus we would try to move a list onto itself, and
bad things would happen.

It seems a bit hairy to be doing list operations with the list marker as
an entry, rather than a head, but...

this resolves the following crash:

  http://bugzilla.kernel.org/show_bug.cgi?id=9379

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 mm/slob.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/mm/slob.c
===================================================================
--- linux.orig/mm/slob.c
+++ linux/mm/slob.c
@@ -321,7 +321,8 @@ static void *slob_alloc(size_t size, gfp
 		/* Improve fragment distribution and reduce our average
 		 * search time by starting our next search here. (see
 		 * Knuth vol 1, sec 2.5, pg 449) */
-		if (free_slob_pages.next != prev->next)
+		if (prev != free_slob_pages.prev &&
+				free_slob_pages.next != prev->next)
 			list_move_tail(&free_slob_pages, prev->next);
 		break;
 	}
