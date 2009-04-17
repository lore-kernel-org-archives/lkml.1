Return-Path: <linux-kernel-owner+w=401wt.eu-S1761634AbZDQQMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761634AbZDQQMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761490AbZDQQMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:12:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761567AbZDQQMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:12:02 -0400
Date: Fri, 17 Apr 2009 09:00:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
cc: Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13058] First hibernation attempt fails
In-Reply-To: <49E85DFD.9030306@tuffmail.co.uk>
Message-ID: <alpine.LFD.2.00.0904170856460.4042@localhost.localdomain>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <20090417063007.GB4593@kernel.dk> <49E83DC4.8040207@tuffmail.co.uk> <20090417091321.GP4593@kernel.dk> <20090417093359.GQ4593@kernel.dk> <49E84DF8.7030802@tuffmail.co.uk>
 <20090417094558.GR4593@kernel.dk> <49E85DFD.9030306@tuffmail.co.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Apr 2009, Alan Jenkins wrote:
> 
> As another datapoint:  I tried blindly applying the commit to 2.6.29. 
> The resulting kernel was able to hibernate fine the first time.

Yeah, so it's not that commit per se that causes it. I bet it needs all 
the IO scheduler changes too - and even when it does that, the end result 
probably is really just a timing change.

> I'm going to be annoying and try something slightly different.  In
> theory, I should be able to find the "first bad commit" where
> cherry-picking 1faa16d22 causes a problem.

Just for fun, try this one first and see if it makes any difference.

Maybe the whole "swappiness=0" part was intentional. And maybe it wasn't. 
This is one trivial patch. Maybe it makes your machine blow up. Who knows?

There are other differences in the shrink_all_memory() path wrt the normal 
memory freeing paths, but they are way more subtle. So I'm suggesting 
tryign this not becasue I think it's "The Bug(tm)", but because it's an 
easy test to make, and maybe it makes a difference.

		Linus
---
 mm/vmscan.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 39fdfb1..d3595ed 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2113,6 +2113,8 @@ unsigned long shrink_all_memory(unsigned long nr_pages)
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
 		.may_unmap = 0,
+		.swap_cluster_max = SWAP_CLUSTER_MAX,
+		.swappiness = vm_swappiness,
 		.may_writepage = 1,
 		.isolate_pages = isolate_pages_global,
 	};
