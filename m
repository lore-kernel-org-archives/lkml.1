Return-Path: <linux-kernel-owner+w=401wt.eu-S1760383AbXF0GGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760383AbXF0GGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 02:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757067AbXF0GGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 02:06:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53607 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756953AbXF0GGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 02:06:37 -0400
Date: Tue, 26 Jun 2007 23:04:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Eric Dumazet <dada1@cosmosbay.com>, Chuck Ebbert <cebbert@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Jarek Poplawski <jarkao2@o2.pl>,
       Miklos Szeredi <miklos@szeredi.hu>, chris@atlee.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
In-Reply-To: <4681F448.3040201@yahoo.com.au>
Message-ID: <alpine.LFD.0.98.0706262249590.8675@woody.linux-foundation.org>
References: <20070620093612.GA1626@ff.dom.local>
 <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org>
 <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org>
 <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com>
 <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org>
 <20070621202917.a2bfbfc7.dada1@cosmosbay.com>
 <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org>
 <4680D162.9050603@yahoo.com.au> <alpine.LFD.0.98.0706261016200.8675@woody.linux-foundation.org>
 <4681F448.3040201@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Jun 2007, Nick Piggin wrote:
> 
> I don't know why my unlock sequence should be that much slower? Unlocked
> mov vs unlocked add? Definitely in dumb micro-benchmark testing it wasn't
> twice as slow (IIRC).

Oh, that releasing "add" can be unlocked, and only the holder of the lock 
ever touches that field?

I must not have looked closely enough. In that case, I withdraw that 
objection, and the sequence-number-based spinlock sounds like a perfectly 
fine one.

Yes, the add will be slightly slower than the plain byte move, and the 
locked xadd will be slightly slower than a regular locked add, but 
compared to the serialization cost, that should be small. For some reason 
I thought you needed a locked instruction for the unlock too.

So try it with just a byte counter, and test some stupid micro-benchmark 
on both a P4 and a Core 2 Duo, and if it's in the noise, maybe we can make 
it the normal spinlock sequence just because it isn't noticeably slower.

In fact, I think a "incb <mem>" instruction is even a byte shorter than 
"movb $1,mem", and with "unlock" being inlined, that could actually be a 
slight _win_.

			Linus
