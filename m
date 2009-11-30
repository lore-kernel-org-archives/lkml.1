Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbZK3JPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbZK3JPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbZK3JPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:15:42 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47755 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZK3JPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:15:41 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/9] ksm: let shared pages be swappable
Cc: kosaki.motohiro@jp.fujitsu.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Chris Wright <chrisw@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20091130094616.8f3d94a7.kamezawa.hiroyu@jp.fujitsu.com>
References: <Pine.LNX.4.64.0911241640590.25288@sister.anvils> <20091130094616.8f3d94a7.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20091130180452.5BF6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 30 Nov 2009 18:15:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 24 Nov 2009 16:42:15 +0000 (GMT)
> Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> > +int page_referenced_ksm(struct page *page, struct mem_cgroup *memcg,
> > +			unsigned long *vm_flags)
> > +{
> > +	struct stable_node *stable_node;
> > +	struct rmap_item *rmap_item;
> > +	struct hlist_node *hlist;
> > +	unsigned int mapcount = page_mapcount(page);
> > +	int referenced = 0;
> > +	struct vm_area_struct *vma;
> > +
> > +	VM_BUG_ON(!PageKsm(page));
> > +	VM_BUG_ON(!PageLocked(page));
> > +
> > +	stable_node = page_stable_node(page);
> > +	if (!stable_node)
> > +		return 0;
> > +
> 
> Hmm. I'm not sure how many pages are shared in a system but
> can't we add some threshold for avoidng too much scan against shared pages ?
> (in vmscan.c)
> like..
>       
>        if (page_mapcount(page) > (XXXX >> scan_priority))
> 		return 1;
> 
> I saw terrible slow downs in shmem-swap-out in old RHELs (at user support).
> (Added kosaki to CC.)
> 
> After this patch, the number of shared swappable page will be unlimited.

Probably, it doesn't matter. I mean

  - KSM sharing and Shmem sharing are almost same performance characteristics.
  - if memroy pressure is low, SplitLRU VM doesn't scan anon list so much.

if ksm swap is too costly, we need to improve anon list scanning generically.


btw, I'm not sure why bellow kmem_cache_zalloc() is necessary. Why can't we
use stack?

----------------------------
+	/*
+	 * Temporary hack: really we need anon_vma in rmap_item, to
+	 * provide the correct vma, and to find recently forked instances.
+	 * Use zalloc to avoid weirdness if any other fields are involved.
+	 */
+	vma = kmem_cache_zalloc(vm_area_cachep, GFP_ATOMIC);
+	if (!vma) {
+		spin_lock(&ksm_fallback_vma_lock);
+		vma = &ksm_fallback_vma;
+	}


