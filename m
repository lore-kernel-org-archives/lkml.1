Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbZDQU7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbZDQU7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 16:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbZDQU7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 16:59:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42820 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930AbZDQU7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 16:59:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [Bug #13058] First hibernation attempt fails
Date: Fri, 17 Apr 2009 22:58:58 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <alpine.LFD.2.00.0904170856460.4042@localhost.localdomain> <49E8C06A.5080605@tuffmail.co.uk>
In-Reply-To: <49E8C06A.5080605@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904172258.58783.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 April 2009, Alan Jenkins wrote:
> Linus Torvalds wrote:
> > On Fri, 17 Apr 2009, Alan Jenkins wrote:
> >   
> >> As another datapoint:  I tried blindly applying the commit to 2.6.29. 
> >> The resulting kernel was able to hibernate fine the first time.
> >>     
> >
> > Yeah, so it's not that commit per se that causes it. I bet it needs all 
> > the IO scheduler changes too - and even when it does that, the end result 
> > probably is really just a timing change.
> >
> >   
> >> I'm going to be annoying and try something slightly different.  In
> >> theory, I should be able to find the "first bad commit" where
> >> cherry-picking 1faa16d22 causes a problem.
> >>     
> >
> > Just for fun, try this one first and see if it makes any difference.
> >
> > Maybe the whole "swappiness=0" part was intentional. And maybe it wasn't. 
> > This is one trivial patch. Maybe it makes your machine blow up. Who knows?
> >
> > There are other differences in the shrink_all_memory() path wrt the normal 
> > memory freeing paths, but they are way more subtle. So I'm suggesting 
> > tryign this not becasue I think it's "The Bug(tm)", but because it's an 
> > easy test to make, and maybe it makes a difference.
> >
> > 		Linus
> > ---
> >  mm/vmscan.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 39fdfb1..d3595ed 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2113,6 +2113,8 @@ unsigned long shrink_all_memory(unsigned long nr_pages)
> >  	struct scan_control sc = {
> >  		.gfp_mask = GFP_KERNEL,
> >  		.may_unmap = 0,
> > +		.swap_cluster_max = SWAP_CLUSTER_MAX,
> > +		.swappiness = vm_swappiness,
> >  		.may_writepage = 1,
> >  		.isolate_pages = isolate_pages_global,
> >  	};
> >   
> 
> 
> No, that doesn't seem to affect it.

Can you please try to reproduce the problem with the appended debug patch
applied and send the output of dmesg to me?

Rafael

---
 mm/vmscan.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6/mm/vmscan.c
===================================================================
--- linux-2.6.orig/mm/vmscan.c
+++ linux-2.6/mm/vmscan.c
@@ -2115,6 +2115,7 @@ unsigned long shrink_all_memory(unsigned
 		.may_unmap = 0,
 		.may_writepage = 1,
 		.isolate_pages = isolate_pages_global,
+		.nr_reclaimed = 0,
 	};
 
 	current->reclaim_state = &reclaim_state;
@@ -2135,6 +2136,8 @@ unsigned long shrink_all_memory(unsigned
 		nr_slab -= reclaim_state.reclaimed_slab;
 	}
 
+	printk(KERN_INFO "before: sc.nr_reclaimed = %lu\n", sc.nr_reclaimed);
+
 	/*
 	 * We try to shrink LRUs in 5 passes:
 	 * 0 = Reclaim from inactive_list only
@@ -2168,6 +2171,10 @@ unsigned long shrink_all_memory(unsigned
 
 			if (sc.nr_scanned && prio < DEF_PRIORITY - 2)
 				congestion_wait(WRITE, HZ / 10);
+
+			printk(KERN_INFO "pass = %d, prio = %d, "
+				"sc.nr_reclaimed = %lu\n", pass, prio,
+				sc.nr_reclaimed);
 		}
 	}
 
@@ -2184,6 +2191,7 @@ unsigned long shrink_all_memory(unsigned
 				reclaim_state.reclaimed_slab > 0);
 	}
 
+	printk(KERN_INFO "after: sc.nr_reclaimed = %lu\n", sc.nr_reclaimed);
 
 out:
 	current->reclaim_state = NULL;
