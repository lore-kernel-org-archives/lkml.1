Return-Path: <linux-kernel-owner+w=401wt.eu-S1762873AbYCCT2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762873AbYCCT2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 14:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762783AbYCCT2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 14:28:24 -0500
Received: from relay2.sgi.com ([192.48.171.30]:41837 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762775AbYCCT2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 14:28:22 -0500
Date: Mon, 3 Mar 2008 11:28:21 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: akpm@linux-foundation.org, Andrea Arcangeli <andrea@qumranet.com>,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address ranges
In-Reply-To: <200803031611.10275.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0803031124001.7275@schroedinger.engr.sgi.com>
References: <20080215064859.384203497@sgi.com> <200802201008.49933.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0802271424390.13186@schroedinger.engr.sgi.com>
 <200803031611.10275.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Nick Piggin wrote:

> Your skeleton is just registering notifiers and saying
> 
> /* you fill the hard part in */
> 
> If somebody needs a skeleton in order just to register the notifiers,
> then almost by definition they are unqualified to write the hard
> part ;)

Its also providing a locking scheme.

> OK, there are ways to solve it or hack around it. But this is exactly
> why I think the implementations should be kept seperate. Andrea's
> notifiers are coherent, work on all types of mappings, and will
> hopefully match closely the regular TLB invalidation sequence in the
> Linux VM (at the moment it is quite close, but I hope to make it a
> bit closer) so that it requires almost no changes to the mm.

Then put it into the arch code for TLB invalidation. Paravirt ops gives 
good examples on how to do that.

> What about a completely different approach... XPmem runs over NUMAlink,
> right? Why not provide some non-sleeping way to basically IPI remote
> nodes over the NUMAlink where they can process the invalidation? If you
> intra-node cache coherency has to run over this link anyway, then
> presumably it is capable.

There is another Linux instance at the remote end that first has to 
remove its own ptes. Also would not work for Inifiniband and other 
solutions. All the approaches that require evictions in an atomic context 
are limiting the approach and do not allow the generic functionality that 
we want in order to not add alternate APIs for this.

> Or another idea, why don't you LD_PRELOAD in the MPT library to also
> intercept munmap, mprotect, mremap etc as well as just fork()? That
> would give you similarly "good enough" coherency as the mmu notifier
> patches except that you can't swap (which Robin said was not a big
> problem).

The good enough solution right now is to pin pages by elevating 
refcounts.

