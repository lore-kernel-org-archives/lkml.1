Return-Path: <linux-kernel-owner+w=401wt.eu-S1758388AbYA3TfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388AbYA3TfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 14:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbYA3TfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 14:35:10 -0500
Received: from relay2.sgi.com ([192.48.171.30]:49796 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752837AbYA3TfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:35:08 -0500
Date: Wed, 30 Jan 2008 11:35:06 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Robin Holt <holt@sgi.com>
cc: Andrea Arcangeli <andrea@qumranet.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address ranges
In-Reply-To: <20080130161123.GS26420@sgi.com>
Message-ID: <Pine.LNX.4.64.0801301129260.30568@schroedinger.engr.sgi.com>
References: <20080128202840.974253868@sgi.com> <20080128202923.849058104@sgi.com>
 <20080129162004.GL7233@v2.random> <Pine.LNX.4.64.0801291153520.25300@schroedinger.engr.sgi.com>
 <20080129211759.GV7233@v2.random> <Pine.LNX.4.64.0801291327330.26649@schroedinger.engr.sgi.com>
 <20080129220212.GX7233@v2.random> <Pine.LNX.4.64.0801291407380.27104@schroedinger.engr.sgi.com>
 <20080130000039.GA7233@v2.random> <20080130161123.GS26420@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008, Robin Holt wrote:

> I think I need to straighten this discussion out in my head a little bit.
> Am I correct in assuming Andrea's original patch set did not have any SMP
> race conditions for KVM?  If so, then we need to start looking at how to
> implement Christoph's and my changes in a safe fashion.  Andrea, I agree
> complete that our introduction of the range callouts have introduced
> SMP races.

The original patch drew the clearing of the sptes into ptep_clear_flush(). 
So the invalidate_page was called for each page regardless if we had been 
doing an invalidate range before or not. It seems that the the 
invalidate_range() was just there for optimization.
 
> The three issues we need to simultaneously solve is revoking the remote
> page table/tlb information while still in a sleepable context and not
> having the remote faulters become out of sync with the granting process.
> Currently, I don't see a way to do that cleanly with a single callout.

You could use the invalidate_page callouts to set a flag that no 
additional rmap entries may be added until the invalidate_range has 
occurred? We could add back all the original invalidate_pages() and pass
a flag that specifies that an invalidate range will follow. The notifier 
can then decide what to do with that information. If its okay to defer 
then do nothing and wait for the range_invalidate. XPmem could stop 
allowing external references to be established until the invalidate_range 
was successful.

Jack had a concern that multiple callouts for the same pte could cause 
problems.

