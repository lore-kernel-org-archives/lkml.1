Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbYCMTpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbYCMTpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 15:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbYCMTpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 15:45:10 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:57713
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbYCMTpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 15:45:09 -0400
Date: Thu, 13 Mar 2008 20:45:07 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Zachary Amsden <zach@vmware.com>
Cc: Hugh Dickins <hugh@veritas.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       virtualization@lists.osdl.org, akpm@linux-foundation.org,
       nickpiggin@yahoo.com.au, frankeh@watson.ibm.com, rusty@rustcorp.com.au,
       jeremy@goop.org, clameter@sgi.com, a.p.zijlstra@chello.nl
Subject: Re: [patch 0/6] Guest page hinting version 6.
Message-ID: <20080313194507.GJ7365@v2.random>
References: <20080312132132.520833247@de.ibm.com> <Pine.LNX.4.64.0803131627450.17244@blonde.site> <1205430307.18433.20.camel@bodhitayantram.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205430307.18433.20.camel@bodhitayantram.eng.vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 10:45:07AM -0700, Zachary Amsden wrote:
> What doesn't appear to be useful however, is support for this under
> VMware.  It can be done, even without the writable pte support (yes,
> really).  But due to us exploiting optimizations at lower layers, it
> doesn't appear that it will gain us any performance - and we must
> already have the complex working set algorithms to support
> non-paravirtualized guests.

With non-paravirt all you can do is to swap the guest physical memory
(mmu notifiers allows linux to do that) or share memory (mmu notifiers
+ ksm allows linux to do that too). We also have complex working set
algorithms that we use to finds which parts of the guest physical
address space are best to swap first: the core linux VM.

What paravirt allows us to do (and that's the whole point of the paper
I guess), is to go one step further than just guest swapping and to
ask the guest if the page really need to be swapped or if it can be
freed right away. So this would be an extension of the mmu notifiers
(this also shows how EMM API is too restrictive, while MMU notifiers
will allow that extension in the future) to avoid I/O sometime if
guest tells us it's not necessary to swap through paravirt ops.

When talking with friends about ballooning I already once suggested to
auto inflate the balloon with pages in the freelist.

Now this paper goes well beyond the pages in the freelist (called
U/unused in the paper), this also covers cache and mapped-clean cache
in the guest. That would have been the next step.

Anyway plain ballooning remains useful as rss limiting or numa
compartments in the linux hypervisor, to provide unfariness to certain
guests.

I didn't read the patch yet, but I think paravirt knowledge about
U/unused pages is needed to avoid guest swapping. The cache and mapped
cache in the guest is a gray area, because linux as hypervisor will be
extremely efficient at swapping out and swapping in the guest cache
(host swapping guest cache, may be faster than re-issuing a read-I/O
to refill the cache by itself, clearly with guest using
paravirt). Let's say I'm mostly interested about page-hinting for the
U pages initially.

I'm currently busy with other two features and trying to get mmu
notifier #v9 into mainline which is orders of magnitude more important
than avoiding a few swapouts sometime (without mmu notifiers
everything else is irrelevant, including guest page hinting and
including ballooning too cause madvise(don't need) won't clear sptes
and invalidate guest tlbs).
