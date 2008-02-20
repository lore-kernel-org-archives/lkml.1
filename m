Return-Path: <linux-kernel-owner+w=401wt.eu-S1761859AbYBTBB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761859AbYBTBB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 20:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763679AbYBTBAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 20:00:46 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:45640
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761187AbYBTBAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 20:00:42 -0500
Date: Wed, 20 Feb 2008 02:00:38 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address
	ranges
Message-ID: <20080220010038.GQ7128@v2.random>
References: <20080215064859.384203497@sgi.com> <20080215064932.620773824@sgi.com> <200802201008.49933.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802201008.49933.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 10:08:49AM +1100, Nick Piggin wrote:
> You can't sleep inside rcu_read_lock()!
> 
> I must say that for a patch that is up to v8 or whatever and is
> posted twice a week to such a big cc list, it is kind of slack to
> not even test it and expect other people to review it.

Well, xpmem requirements are complex. As as side effect of the
simplicity of my approach, my patch is 100% safe since #v1. Now it
also works for GRU and it cluster invalidates.

> Also, what we are going to need here are not skeleton drivers
> that just do all the *easy* bits (of registering their callbacks),
> but actual fully working examples that do everything that any
> real driver will need to do. If not for the sanity of the driver

I've a fully working scenario for my patch, infact I didn't post the
mmu notifier patch until I got KVM to swap 100% reliably to be sure I
would post something that works well. mmu notifiers are already used
in KVM for:

1) 100% reliable and efficient swapping of guest physical memory
2) copy-on-writes of writeprotect faults after ksm page sharing of guest
   physical memory
3) ballooning using madvise to give the guest memory back to the host

My implementation is the most handy because it requires zero changes
to the ksm code too (no explicit mmu notifier calls after
ptep_clear_flush) and it's also 100% safe (no mess with schedules over
rcu_read_lock), no "atomic" parameters, and it doesn't open a window
where sptes have a view on older pages and linux pte has view on newer
pages (this can happen with remap_file_pages with my KVM swapping
patch to use V8 Christoph's patch).

> Also, how to you resolve the case where you are not allowed to sleep?
> I would have thought either you have to handle it, in which case nobody
> needs to sleep; or you can't handle it, in which case the code is
> broken.

I also asked exactly this, glad you reasked this too.
