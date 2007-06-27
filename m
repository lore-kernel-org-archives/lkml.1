Return-Path: <linux-kernel-owner+w=401wt.eu-S1762172AbXF0URv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762172AbXF0URv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 16:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbXF0URm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 16:17:42 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2186 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbXF0URl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 16:17:41 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 27 Jun 2007 13:17:38 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Eric Dumazet <dada1@cosmosbay.com>,
       Chuck Ebbert <cebbert@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jarek Poplawski <jarkao2@o2.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       chris@atlee.ca,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] long freezes on thinkpad t60
In-Reply-To: <alpine.LFD.0.98.0706271233300.8675@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706271310550.5219@alien.or.mcafeemobile.com>
References: <20070620093612.GA1626@ff.dom.local>
 <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org>
 <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org>
 <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com>
 <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org>
 <20070621202917.a2bfbfc7.dada1@cosmosbay.com>
 <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org>
 <4680D162.9050603@yahoo.com.au> <alpine.LFD.0.98.0706261016200.8675@woody.linux-foundation.org>
 <4681F448.3040201@yahoo.com.au> <alpine.LFD.0.98.0706262249590.8675@woody.linux-foundation.org>
 <alpine.LFD.0.98.0706271233300.8675@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007, Linus Torvalds wrote:

> On Tue, 26 Jun 2007, Linus Torvalds wrote:
> > 
> > So try it with just a byte counter, and test some stupid micro-benchmark 
> > on both a P4 and a Core 2 Duo, and if it's in the noise, maybe we can make 
> > it the normal spinlock sequence just because it isn't noticeably slower.
> 
> So I thought about this a bit more, and I like your sequence counter 
> approach, but it still worried me.
> 
> In the current spinlock code, we have a very simple setup for a 
> successful grab of the spinlock:
> 
> 	CPU#0					CPU#1
> 
> 	A (= code before the spinlock)
> 						lock release
> 
> 	lock decb mem	(serializing instruction)
> 
> 	B (= code after the spinlock)
> 
> and there is no question that memory operations in B cannot leak into A.
> 
> With the sequence counters, the situation is more complex:
> 
> 	CPU #0					CPU #1
> 
> 	A (= code before the spinlock)
> 
> 	lock xadd mem	(serializing instruction)
> 
> 	B (= code afte xadd, but not inside lock)
> 
> 						lock release
> 
> 	cmp head, tail
> 
> 	C (= code inside the lock)
> 
> Now, B is basically the empty set, but that's not the issue I worry about. 
> The thing is, I can guarantee by the Intel memory ordering rules that 
> neither B nor C will ever have memops that leak past the "xadd", but I'm 
> not at all as sure that we cannot have memops in C that leak into B!
> 
> And B really isn't protected by the lock - it may run while another CPU 
> still holds the lock, and we know the other CPU released it only as part 
> of the compare. But that compare isn't a serializing instruction!
> 
> IOW, I could imagine a load inside C being speculated, and being moved 
> *ahead* of the load that compares the spinlock head with the tail! IOW, 
> the load that is _inside_ the spinlock has effectively moved to outside 
> the protected region, and the spinlock isn't really a reliable mutual 
> exclusion barrier any more!
> 
> (Yes, there is a data-dependency on the compare, but it is only used for a 
> conditional branch, and conditional branches are control dependencies and 
> can be speculated, so CPU speculation can easily break that apparent 
> dependency chain and do later loads *before* the spinlock load completes!)
> 
> Now, I have good reason to believe that all Intel and AMD CPU's have a 
> stricter-than-documented memory ordering, and that your spinlock may 
> actually work perfectly well. But it still worries me. As far as I can 
> tell, there's a theoretical problem with your spinlock implementation.

Nice catch ;) But wasn't Intel suggesting in not relying on the old 
"strict" ordering rules? IOW shouldn't an mfence always be there? Not only 
loads could leak up into the wait phase, but stores too, if they have no 
dependency with the "head" and "tail" loads.



- Davide


