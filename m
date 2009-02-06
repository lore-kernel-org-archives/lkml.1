Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbZBFSiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbZBFSiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbZBFSir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:38:47 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33883 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbZBFSiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:38:46 -0500
Date: Fri, 6 Feb 2009 19:38:33 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       mtk.manpages@gmail.com, linux-man@vger.kernel.org,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Izik Eidus <ieidus@redhat.com>, Hugh Dickins <hugh@veritas.com>
Subject: Re: open(2) says O_DIRECT works on 512 byte boundries?
Message-ID: <20090206183833.GU14011@random.random>
References: <20090128213322.GA15789@kroah.com> <20090129141338.34e44a1f.kamezawa.hiroyu@jp.fujitsu.com> <20090129160826.701E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090130061714.GC31209@kroah.com> <20090202220856.GY20323@random.random> <20090204234153.GA32244@kroah.com> <20090206175414.GQ14011@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206175414.GQ14011@random.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 06:54:14PM +0100, Andrea Arcangeli wrote:
> +	if (is_cow_mapping(vm_flags)) {
> +		if (pte_write(pte)) {
> +			ptep_set_wrprotect(src_mm, addr, src_pte);
> +			pte = pte_wrprotect(pte);
> +		}

While working on the mainline version that will definitely require a
tlb flush here if forcecow/PageGUP is set, I just realized to provide
an atomic per-page copy in the fork_pre_cow an explicit tlb flush is
needed in the pre-gup-fast version too.

	if (is_cow_mapping(vm_flags)) {
		if (pte_write(pte)) {
			ptep_set_wrprotect(src_mm, addr, src_pte);
			pte = pte_wrprotect(pte);
			if (forcecow)
				flush_tlb_page(src_vma, addr);
		}
	}

However to flush the 'src_mm' I feel I can't pass the 'dst_vma' that
fork is passing to copy_page_range. OTOH the dst_vma is needed to be
passed to the fork_pre_cow which is why fork.c was changed in the
patch to pass dst_vma instead of src_vma.

So I think I want to avoid all further confusion if the 'vma' belongs
to the src_mm or the dst_mm by passing both src_vma, and dst_vma from
fork to copy_page_tables. In the pre-gup-fast version the tlb flush is
mostly a nitpick and it would never lead to any practical issue, but
for mostly theoretical reasons it may be good idea to have the
per-page atomic copy there too, comments?
