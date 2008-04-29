Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbYD2B2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbYD2B2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbYD2B2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:28:11 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36875 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751526AbYD2B2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:28:10 -0400
Date: Mon, 28 Apr 2008 18:28:06 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 01 of 12] Core of mmu notifiers
In-Reply-To: <20080429001052.GA8315@duo.random>
Message-ID: <Pine.LNX.4.64.0804281819020.2502@schroedinger.engr.sgi.com>
References: <20080423002848.GA32618@sgi.com> <20080423163713.GC24536@duo.random>
 <20080423221928.GV24536@duo.random> <20080424064753.GH24536@duo.random>
 <20080424095112.GC30298@sgi.com> <20080424153943.GJ24536@duo.random>
 <20080424174145.GM24536@duo.random> <20080426131734.GB19717@sgi.com>
 <20080427122727.GO9514@duo.random> <Pine.LNX.4.64.0804281332030.31163@schroedinger.engr.sgi.com>
 <20080429001052.GA8315@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008, Andrea Arcangeli wrote:

> Frankly I've absolutely no idea why rcu is needed in all rmap code
> when walking the page->mapping. Definitely the PG_locked is taken so
> there's no way page->mapping could possibly go away under the rmap
> code, hence the anon_vma can't go away as it's queued in the vma, and
> the vma has to go away before the page is zapped out of the pte.

zap_pte_range can race with the rmap code and it does not take the page 
lock. The page may not go away since a refcount was taken but the mapping 
can go away. Without RCU you have no guarantee that the anon_vma is 
existing when you take the lock. 

How long were you away from VM development?

> Now the double atomic op may not be horrible when not contented, as it
> works on the same cacheline but with cacheline bouncing with
> contention it sounds doubly horrible than a single cacheline bounce
> and I don't see the point of it as you can't use rcu anyways, so you
> can't possibly take advantage of whatever microoptimization done over
> the original locking.

Cachelines are acquired for exclusive use for a mininum duration. 
Multiple atomic operations can be performed after a cacheline becomes 
exclusive without danger of bouncing.
