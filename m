Return-Path: <linux-kernel-owner+w=401wt.eu-S932275AbYBAMLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275AbYBAMLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 07:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764482AbYBAMK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 07:10:28 -0500
Received: from relay1.sgi.com ([192.48.171.29]:55010 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764355AbYBAMK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 07:10:26 -0500
Date: Fri, 1 Feb 2008 06:10:25 -0600
From: Robin Holt <holt@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: Extending mmu_notifiers to handle __xip_unmap in a sleepable
	context?
Message-ID: <20080201121024.GN26420@sgi.com>
References: <20080201050439.009441434@sgi.com> <20080201115841.GM26420@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201115841.GM26420@sgi.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argh,

Here is the correct one.  Sorry

On Fri, Feb 01, 2008 at 05:58:41AM -0600, Robin Holt wrote:
> With this set of patches, I think we have enough to get xpmem working
> with most types of mappings.  In the past, we operated without any of
> these callouts by significantly restricting why types of mappings could
> remotely fault and what types of operations the user could do.  With
> this set, I am certain we can continue to meet the above assumptions.
> 
> That said, I would like to discuss __xip_unmap in more detail.
> 
> Currently, it is calling mmu_notifier _begin and _end under the
> i_mmap_lock.  I _THINK_ the following will make it so we could support
> __xip_unmap (although I don't recall ever seeing that done on ia64 and
> don't even know what the circumstances are for its use).

Index: mmu_notifiers-cl-v5/mm/filemap_xip.c
===================================================================
--- mmu_notifiers-cl-v5.orig/mm/filemap_xip.c	2008-02-01 05:38:32.000000000 -0600
+++ mmu_notifiers-cl-v5/mm/filemap_xip.c	2008-02-01 06:09:09.000000000 -0600
@@ -184,6 +184,10 @@ __xip_unmap (struct address_space * mapp
 	if (!page)
 		return;
 
+	if (unlikely(PageExternalRmap(page))) {
+		mmu_rmap_notifier(invalidate_page, page);
+		ClearPageExternalRmap(page);
+	}
 	spin_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		mm = vma->vm_mm;
