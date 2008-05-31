Return-Path: <linux-kernel-owner+w=401wt.eu-S1753009AbYEaE6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbYEaE6y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 00:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbYEaE6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 00:58:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750749AbYEaE6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 00:58:44 -0400
Date: Fri, 30 May 2008 21:58:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: Re: [PATCH 0/3] 64-bit futexes: Intro
In-Reply-To: <4840D63F.2090407@redhat.com>
Message-ID: <alpine.LFD.1.10.0805302144170.3141@woody.linux-foundation.org>
References: <200805310127.m4V1RLR4013808@devserv.devel.redhat.com> <alpine.LFD.1.10.0805301846530.3141@woody.linux-foundation.org> <4840C29B.6030507@redhat.com> <alpine.LFD.1.10.0805302044310.3141@woody.linux-foundation.org> <4840CE51.9060109@redhat.com>
 <alpine.LFD.1.10.0805302109370.3141@woody.linux-foundation.org> <alpine.LFD.1.10.0805302116440.3141@woody.linux-foundation.org> <4840D63F.2090407@redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 May 2008, Ulrich Drepper wrote:
> 
> Linus Torvalds wrote:
> > Is it possible? I dunno.
> 
> Once again not without limitations which are too low.  The main problem
> is that there is far more information needed on the reader side.  There
> are two counters and a number of bits for state information.  Which
> means the counters can be at most 14 bits in size.

Uli, you're NOT EVEN READING!

Go back and read it, dammit! How many times have I said that you can even 
have more than 32 bits of data? 

There's nothing wrong with using 64-bit atomics to update the words. All 
I've *ever* questioned is whether you need more than 32 bits for the 
FUTEX part.

For example, let's say that you need 4 bits of "state" information (ie 
"next woken-up one is a reader"). And yes, you need counts for readers and 
writers. Maybe we can make those counts be 30 bits each. 64 bits total 
space. But does the FUTEX_OP things actually need to access all 64 bits?

So imagine that you bave a 64-bit atomic op, and bits 0-1 are the reader 
state bits, with bits 2-31 being the reader count. Bits 32-33 are the 
writer state bits, and bits 34-63 are the writer count.

Now you can use 64-bit atomic ops to update them, but perhaps just use a 
32-bit FUTEX op to actually wait as a reader on the low 32 bits that are 
the reader state bits. See?

THIS is what I've been trying to tell you. It's quite possible that the 
algorithm you already have could work with just moving the bits around so 
that each FUTEX op can be done on just one of the words.

And notice my use of the word "possible". 

The kernel uses a 32-bit count word, but has various other state too that 
it maintains under a separate locking setup. Same basic idea: the 32-bit 
word is "special" (because it's the one that has to have the right format 
for the 'xadd' op that we use for the fast path), but it's not the _only_ 
data in the thing. The other data is also accessed, it's just accessed 
according to different principles.

			Linus
