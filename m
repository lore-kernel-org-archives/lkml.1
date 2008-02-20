Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbYBTMYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbYBTMYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 07:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbYBTMY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 07:24:27 -0500
Received: from relay2.sgi.com ([192.48.171.30]:33168 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751306AbYBTMY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 07:24:26 -0500
Date: Wed, 20 Feb 2008 06:24:24 -0600
From: Robin Holt <holt@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Robin Holt <holt@sgi.com>, Nick Piggin <npiggin@suse.de>,
       akpm@linux-foundation.org, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] mmu notifiers #v6
Message-ID: <20080220122424.GE11364@sgi.com>
References: <20080219084357.GA22249@wotan.suse.de> <20080219135851.GI7128@v2.random> <20080219231157.GC18912@wotan.suse.de> <20080220010941.GR7128@v2.random> <20080220103942.GU7128@v2.random> <20080220113313.GD11364@sgi.com> <20080220120324.GW7128@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220120324.GW7128@v2.random>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 01:03:24PM +0100, Andrea Arcangeli wrote:
> I'm unconvinced both the main linux VM and the mmu notifier should be
> changed like this just to support xpmem. All non-sleeping users don't
> need that. Nevertheless I'm fully welcome to support xpmem (and it's
> not my call nor my interest to comment if allocating skbs in
> try_to_unmap in order to unpin pages is workable, let's assume it's
> workable for the sake of this discussion) with a new config option
> that will also alter how the core VM works, in order to fully support
> the sleeping users for filebacked mappings.

We do not need to do any allocation in the messaging layer, all
structures used for messaging are allocated at module load time.
The allocation discussions we had early on were about trying to
rearrange you notifiers to allow a seperate worker thread to do the
invalidate and then the main thread would spin waiting for the worker to
complete.  That was canned by the moving your notifier to before the
lock was grabbed which led us to the point of needing a _begin and _end.

> This will also create less confusion in the registration. With
> Christoph's one-config-option-fits-all you had to half register into
> the mmu notifier (the sleeping calls, so not invalidate_page) and full
> register in the external rmap notifier, and I had to only half
> register into the mmu notifier (not range_begin) and not register in
> the rmap external notifier.
> 
> With two separate config options for sleeping and non sleeping users,
> I'll 100% register in the mmu notifier methods, and the non-sleeping
> users will 100% register the xpmem methods. You won't have to have
> designed the mmu notifier patches to understand how to use it.

So, fundamentally, how would they be different?  Would we be required to
add another notifier list to the mm and have two seperate callout
points?  Reduction would end up with the same half-registered
half-not-registered situation you point out above.  Then further
reduction would lead to the elimination of the callouts you have just
proposed and using the _begin/_end callouts and we are back to
Christoph's current patch.

Robin
