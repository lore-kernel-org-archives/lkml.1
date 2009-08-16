Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbZHPL3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbZHPL3m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 07:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbZHPL3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 07:29:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:30801 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbZHPL3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 07:29:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,389,1246863600"; 
   d="scan'208";a="176292624"
Date: Sun, 16 Aug 2009 19:29:10 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Rik van Riel <riel@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>, Avi Kivity <avi@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
Message-ID: <20090816112910.GA3208@localhost>
References: <20090806100824.GO23385@random.random> <4A7AAE07.1010202@redhat.com> <20090806102057.GQ23385@random.random> <20090806105932.GA1569@localhost> <4A7AC201.4010202@redhat.com> <20090806130631.GB6162@localhost> <20090806210955.GA14201@c2.user-mode-linux.org> <20090816031827.GA6888@localhost> <4A87829C.4090908@redhat.com> <20090816051502.GB13740@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090816051502.GB13740@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 16, 2009 at 01:15:02PM +0800, Wu Fengguang wrote:
> On Sun, Aug 16, 2009 at 11:53:00AM +0800, Rik van Riel wrote:
> > Wu Fengguang wrote:
> > > On Fri, Aug 07, 2009 at 05:09:55AM +0800, Jeff Dike wrote:
> > >> Side question -
> > >> 	Is there a good reason for this to be in shrink_active_list()
> > >> as opposed to __isolate_lru_page?
> > >>
> > >> 		if (unlikely(!page_evictable(page, NULL))) {
> > >> 			putback_lru_page(page);
> > >> 			continue;
> > >> 		}
> > >>
> > >> Maybe we want to minimize the amount of code under the lru lock or
> > >> avoid duplicate logic in the isolate_page functions.
> > > 
> > > I guess the quick test means to avoid the expensive page_referenced()
> > > call that follows it. But that should be mostly one shot cost - the
> > > unevictable pages are unlikely to cycle in active/inactive list again
> > > and again.
> > 
> > Please read what putback_lru_page does.
> > 
> > It moves the page onto the unevictable list, so that
> > it will not end up in this scan again.
> 
> Yes it does. I said 'mostly' because there is a small hole that an
> unevictable page may be scanned but still not moved to unevictable
> list: when a page is mapped in two places, the first pte has the
> referenced bit set, the _second_ VMA has VM_LOCKED bit set, then
> page_referenced() will return 1 and shrink_page_list() will move it
> into active list instead of unevictable list. Shall we fix this rare
> case?

How about this fix?

---
mm: stop circulating of referenced mlocked pages

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---

--- linux.orig/mm/rmap.c	2009-08-16 19:11:13.000000000 +0800
+++ linux/mm/rmap.c	2009-08-16 19:22:46.000000000 +0800
@@ -358,6 +358,7 @@ static int page_referenced_one(struct pa
 	 */
 	if (vma->vm_flags & VM_LOCKED) {
 		*mapcount = 1;	/* break early from loop */
+		*vm_flags |= VM_LOCKED;
 		goto out_unmap;
 	}
 
@@ -482,6 +483,8 @@ static int page_referenced_file(struct p
 	}
 
 	spin_unlock(&mapping->i_mmap_lock);
+	if (*vm_flags & VM_LOCKED)
+		referenced = 0;
 	return referenced;
 }
 
