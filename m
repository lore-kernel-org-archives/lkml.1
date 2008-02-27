Return-Path: <linux-kernel-owner+w=401wt.eu-S1762093AbYB0Xc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762093AbYB0Xc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbYB0XcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:32:18 -0500
Received: from relay2.sgi.com ([192.48.171.30]:46115 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751192AbYB0XcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:32:17 -0500
Date: Wed, 27 Feb 2008 15:32:16 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc2
In-Reply-To: <20080219172739.55c341b5.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0802271522540.14380@schroedinger.engr.sgi.com>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
 <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com>
 <20080219061107.GA23229@elte.hu> <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com>
 <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com>
 <20080219140230.GA32236@Krystal> <20080219172739.55c341b5.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008, Eric Dumazet wrote:

> I wonder how SLUB_FASTPATH is supposed to work, since it is affected by
> a classical ABA problem of lockless algo.
> 
> cmpxchg_local(&c->freelist, object, object[c->offset]) can succeed,
> while an interrupt came (on this cpu), and several allocations were done,
> and one free was performed at the end of this interruption, so 'object'
> was recycled.
> c->freelist can then contain the previous value (object), but
> object[c->offset] was changed by IRQ.
> 
> We then put back in freelist an already allocated object.

Right. The alloc fastpath assumes that the object is not modified while it 
is allocated...

Du! This shoots my nice scheme in the foot and there does not seem to be 
an easy way to fix it.  This means we also need to revert the 
page->end patch. Useless if we do not have the cmpxchg_local.



