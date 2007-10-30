Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbXJ3Scv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbXJ3Scv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 14:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbXJ3Scl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 14:32:41 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56339 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753952AbXJ3Scl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 14:32:41 -0400
Date: Tue, 30 Oct 2007 11:32:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Matthew Wilcox <matthew@wil.cx>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [patch 09/10] SLUB: Do our own locking via slab_lock and
 slab_unlock.
In-Reply-To: <200710301550.55199.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0710301124520.11531@schroedinger.engr.sgi.com>
References: <20071028033156.022983073@sgi.com> <20071028033300.479692380@sgi.com>
 <200710301550.55199.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007, Nick Piggin wrote:

> Is this actually a speedup on any architecture to roll your own locking
> rather than using bit spinlock?

It avoids one load from memory when allocating and the release is simply 
writing the page->flags back. Less instructions.

> I am not exactly convinced that smp_wmb() is a good idea to have in your
> unlock, rather than the normally required smp_mb() that every other open
> coded lock in the kernel is using today. If you comment every code path
> where a load leaking out of the critical section would not be a problem,
> then OK it may be correct, but I still don't think it is worth the
> maintenance overhead.

I thought you agreed that release semantics only require a write barrier? 
The issue here is that other processors see the updates before the 
updates to page-flags.

A load leaking out of a critical section would require that the result of 
the load is not used to update other information before the slab_unlock 
and that the source of the load is not overwritten in the critical 
section. That does not happen in sluib.

