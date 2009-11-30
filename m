Return-Path: <linux-kernel-owner+w=401wt.eu-S1752871AbZK3AtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbZK3AtL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 19:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbZK3AtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 19:49:10 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33781 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbZK3AtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 19:49:09 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 30 Nov 2009 09:46:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Chris Wright <chrisw@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/9] ksm: let shared pages be swappable
Message-Id: <20091130094616.8f3d94a7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0911241640590.25288@sister.anvils>
References: <Pine.LNX.4.64.0911241634170.24427@sister.anvils>
	<Pine.LNX.4.64.0911241640590.25288@sister.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 16:42:15 +0000 (GMT)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
> +int page_referenced_ksm(struct page *page, struct mem_cgroup *memcg,
> +			unsigned long *vm_flags)
> +{
> +	struct stable_node *stable_node;
> +	struct rmap_item *rmap_item;
> +	struct hlist_node *hlist;
> +	unsigned int mapcount = page_mapcount(page);
> +	int referenced = 0;
> +	struct vm_area_struct *vma;
> +
> +	VM_BUG_ON(!PageKsm(page));
> +	VM_BUG_ON(!PageLocked(page));
> +
> +	stable_node = page_stable_node(page);
> +	if (!stable_node)
> +		return 0;
> +

Hmm. I'm not sure how many pages are shared in a system but
can't we add some threshold for avoidng too much scan against shared pages ?
(in vmscan.c)
like..
      
       if (page_mapcount(page) > (XXXX >> scan_priority))
		return 1;

I saw terrible slow downs in shmem-swap-out in old RHELs (at user support).
(Added kosaki to CC.)

After this patch, the number of shared swappable page will be unlimited.

Thanks,
-Kame


