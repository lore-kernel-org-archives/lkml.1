Return-Path: <linux-kernel-owner+w=401wt.eu-S1757632AbZJLScH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632AbZJLScH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757618AbZJLScG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:32:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757615AbZJLScF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:32:05 -0400
Date: Mon, 12 Oct 2009 11:30:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       David Howells <dhowells@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>
Subject: Re: [RFC][PATCH] kmap_atomic_push
In-Reply-To: <87ws30fppe.fsf@basil.nowhere.org>
Message-ID: <alpine.LFD.2.01.0910121124590.3438@localhost.localdomain>
References: <1255016123.17055.17.camel@laptop> <87ws30fppe.fsf@basil.nowhere.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Oct 2009, Andi Kleen wrote:

> Peter Zijlstra <peterz@infradead.org> writes:
> > -
> > -static inline void debug_kmap_atomic(enum km_type type)
> > +static inline int kmap_atomic_push_idx(void)
> >  {
> > +	int idx = __get_cpu_var(__kmap_atomic_depth)++;
> 
> The counter needs to be of local atomic type. Otherwise kmap_atomic cannot
> be done from interrupts/nmis, which is unfortunately occasionally needed.

I thought so too on lookin gat it initially, but it's not actually true.

It's both IRQ and NMI safe as-is, for a very simple reason: any interrupts 
that happen will always undo whatever changes they did. So even with a 
totally non-atomic "load + increment + store" model, it really doesn't 
matter if you get an interrupt or an NMI anywhere in the sequence, because 
by the time the interrupt returns, it will have undone any changes it did.

So as long as it's per-cpu (which it is) and non-preemptible (which it 
also is, thanks to kmap_atomic() doing the whole "disable_mm_fault()" 
thing or whatever), it's all fine.

Btw, this is not some new thing. It's exactly the same logic we rely on 
for other counts like the preempt-count etc.

			Linus
