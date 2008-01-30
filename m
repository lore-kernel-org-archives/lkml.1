Return-Path: <linux-kernel-owner+w=401wt.eu-S1758666AbYA3ABA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbYA3ABA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 19:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbYA3AAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 19:00:53 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:36647
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbYA3AAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 19:00:52 -0500
Date: Wed, 30 Jan 2008 01:00:39 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address
	ranges
Message-ID: <20080130000039.GA7233@v2.random>
References: <20080128202840.974253868@sgi.com> <20080128202923.849058104@sgi.com> <20080129162004.GL7233@v2.random> <Pine.LNX.4.64.0801291153520.25300@schroedinger.engr.sgi.com> <20080129211759.GV7233@v2.random> <Pine.LNX.4.64.0801291327330.26649@schroedinger.engr.sgi.com> <20080129220212.GX7233@v2.random> <Pine.LNX.4.64.0801291407380.27104@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801291407380.27104@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 02:39:00PM -0800, Christoph Lameter wrote:
> If it does not run in write mode then concurrent faults are permissible 
> while we remap pages. Weird. Maybe we better handle this like individual
> page operations? Put the invalidate_page back into zap_pte. But then there 
> would be no callback w/o lock as required by Robin. Doing the 

The Robin requirements and the need to schedule are the source of the
complications indeed.

I posted all the KVM patches using mmu notifiers, today I reposted the
ones to work with your V2 (which crashes my host unlike my last
simpler mmu notifier patch but I also changed a few other variable
besides your mmu notifier changes, so I can't yet be sure it's a bug
in your V2, and the SMP regressions I fixed so far sure can't explain
the crashes because my KVM setup could never run in do_wp_page nor
remap_file_pages so it's something else I need to find ASAP).

Robin, if you don't mind, could you please post or upload somewhere
your GPLv2 code that registers itself in Christoph's V2 notifiers? Or
is it top secret? I wouldn't mind to have a look so I can better
understand what's the exact reason you're sleeping besides attempting
GFP_KERNEL allocations. Thanks!

> invalidate_range after populate allows access to memory for which ptes 
> were zapped and the refcount was released.

The last refcount is released by the invalidate_range itself.
 
> > All pins are gone by the time invalidate_page/range returns. But there
> > is no critical section between invalidate_page and the _later_
> > ptep_clear_flush. So get_user_pages is free to run and take the PT
> > lock before the ptep_clear_flush, find the linux pte still
> > instantiated, and to create a new spte, before ptep_clear_flush runs.
> 
> Hmmm... Right. Did not consider get_user_pages. A write to the page that 
> is not marked dirty would typically require a fault that will serialize.

The pte is already marked dirty (and this is the case only for
get_user_pages, regular linux writes don't fault unless it's
explicitly writeprotect, which is mandatory in a few archs, x86 not).
