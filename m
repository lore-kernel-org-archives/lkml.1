Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbZIWQGC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbZIWQGC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 12:06:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZIWQF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 12:05:59 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:30004 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750965AbZIWQF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 12:05:58 -0400
X-Trace: 265168558/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.86.193/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.86.193
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As0AAIPkuUpPRVbB/2dsb2JhbAAI106EGwU
X-IronPort-AV: E=Sophos;i="4.44,439,1249254000"; 
   d="scan'208";a="265168558"
Date: Wed, 23 Sep 2009 17:05:53 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Michal Simek <michal.simek@petalogix.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       John Williams <john.williams@petalogix.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: Re: Microblaze noMMU break - mm/nommu.h
In-Reply-To: <e6a72e5f0909230313j7ea0f232led2b7899dd555af0@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0909231645360.18774@sister.anvils>
References: <e6a72e5f0909230313j7ea0f232led2b7899dd555af0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Wed, 23 Sep 2009, Michal Simek wrote:
> 
> Your commit 58fa879e1e640a1856f736b418984ebeccee1c95 break noMMU Microblaze
> kernel.
> 
> should contain different change in mm/internal.h. - patch is below

I would swear that I testbuilt that for nommu, but clearly I did not:
one fix to nommu.c in the patch below...

> Please fix it. If someone reported it, please ignore my email

Yours is the first I've heard: thanks a lot for your quick report,
and my apologies for the nuisance - I seem to have fallen into a
nasty habit of breaking one config or another with my patches.

> 
> Your commit 03f6462a3ae78f36eb1f0ee8b4d5ae2f7859c1d5 moves
> highest_memmap_pfn from page_alloc.c to memory.c but memory.c is not
> compiled for noMMU kernels - which caused fault too.

And that one I just didn't think of nommu, more's the shame:
another fix to nommu.c in the patch below...

> 
> I haven't seen that patches in linux-next which I test too. :-(

Thank you for testing linux-next, but these kind of inadvertent
breaks to CONFIG_NOMMU are probably most often caused by changes
coming in via Andrew's mmotm - where most (liable to break nomm)
mm development occurs.

linux-next was started really as a service to make Andrew's life
with mmotm slightly easier, but now, yes, he would like to move
over to getting his mm series into linux-next... but it's not a
trivial task to turn that around.

If it's possible for you to test mmotms, your input on breakages
would be much appreciated; but I can quite understand that linux-next
is enough work for you, and that I appear to be bleating at you to
do something different, when it's me who needs to learn to be more
careful and build more configs.

The patch below fixes both for me: if you're able to check it on
Microblaze now, please let us know if they're good for you; but
if not, I'll send direct to Linus in a few hours time, better
to have as narrow a gap of build breakage there as we can.

Thanks, and sorry,
Hugh


[PATCH] nommu: fix two build breakages

My 58fa879e1e640a1856f736b418984ebeccee1c95 "mm: FOLL flags for GUP flags"
broke CONFIG_NOMMU build by forgetting to update nommu.c foll_flags type:
mm/nommu.c:171: error: conflicting types for `__get_user_pages'
mm/internal.h:254: error: previous declaration of `__get_user_pages' was here
make[1]: *** [mm/nommu.o] Error 1

My 03f6462a3ae78f36eb1f0ee8b4d5ae2f7859c1d5 "mm: move highest_memmap_pfn"
broke CONFIG_NOMMU build by forgetting to add a nommu.c highest_memmap_pfn:
mm/built-in.o: In function `memmap_init_zone':
(.meminit.text+0x326): undefined reference to `highest_memmap_pfn'
mm/built-in.o: In function `memmap_init_zone':
(.meminit.text+0x32d): undefined reference to `highest_memmap_pfn'

Fix both breakages, and give myself 30 lashes (ouch!)

Reported-by: Michal Simek <michal.simek@petalogix.com>
Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 mm/nommu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- 2.6.31-git/mm/nommu.c	2009-09-23 09:22:36.000000000 +0100
+++ linux/mm/nommu.c	2009-09-23 16:25:30.000000000 +0100
@@ -61,6 +61,7 @@ void *high_memory;
 struct page *mem_map;
 unsigned long max_mapnr;
 unsigned long num_physpages;
+unsigned long highest_memmap_pfn;
 struct percpu_counter vm_committed_as;
 int sysctl_overcommit_memory = OVERCOMMIT_GUESS; /* heuristic overcommit */
 int sysctl_overcommit_ratio = 50; /* default is 50% */
@@ -169,7 +170,7 @@ unsigned int kobjsize(const void *objp)
 }
 
 int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-		     unsigned long start, int nr_pages, int foll_flags,
+		     unsigned long start, int nr_pages, unsigned int foll_flags,
 		     struct page **pages, struct vm_area_struct **vmas)
 {
 	struct vm_area_struct *vma;
