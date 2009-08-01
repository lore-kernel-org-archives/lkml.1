Return-Path: <linux-kernel-owner+w=401wt.eu-S1751978AbZHAQOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbZHAQOP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 12:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZHAQOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 12:14:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751649AbZHAQOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 12:14:14 -0400
Date: Sat, 1 Aug 2009 09:13:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jakub Jelinek <jakub@redhat.com>
cc: Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Richard Guenther <rguenther@suse.de>
Subject: Re: [PATCH] information leak in sigaltstack
In-Reply-To: <20090801072238.GV4462@tyan-ft48-01.lab.bos.redhat.com>
Message-ID: <alpine.LFD.2.01.0908010856080.3304@localhost.localdomain>
References: <200907311948.n6VJm5Gf010118@hs20-bc2-1.build.redhat.com> <alpine.LFD.2.01.0907311407040.24841@localhost.localdomain> <alpine.LFD.2.01.0907311428370.3304@localhost.localdomain> <4A73641C.7070404@redhat.com> <alpine.LFD.2.01.0907311716220.3304@localhost.localdomain>
 <20090801072238.GV4462@tyan-ft48-01.lab.bos.redhat.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 1 Aug 2009, Jakub Jelinek wrote:
> 
> yes, it is because of -Os, rep stosq is longer than rep stosl.  For -O2 it
> generates:
>         movq    $0, 8(%rdi)
>         movq    %rsi, (%rdi)
>         movl    $6, 8(%rdi)
>         movq    $2, 16(%rdi)

Ok, so -Os actually generates _larger_ code due to this silly one-byte 
micro-optimization that then disables other optimizations.

I suspect that the "rep stosl" choice is _particularly_ bad, since doing a 
32-bit write actually is much more likely to cause subsequent stalls on 
the store buffer if any of the latter accesses are 64-bit reads. It tends 
to be much better to create larger stores (and equal or smaller loads) if 
there are any overlapping accesses.

I think a lot of micro-architectures will stall if they try to do a read 
that crosses multiple stores in the store buffer. If the load hits in the 
store buffer and is entirely contained within one store, you have a much 
better chance of just bypassing the cache entirely.

> which still isn't perfect, but is much better.

Yes. It would have been nice if gcc optimized the overlapping accesses 
too, but it's already much better.

> At -O2 when GCC decides to do the memset piecewise it is easier to kill 
> dead stores from the memset

On 32-bit, we do memcpy() by hand because gcc is/was so bad at this (we do 
it for memset too, but only for really small areas, so it wouldn't 
trigger).

On x86-64, we've trusted that gcc is better. Sadly, it's clearly not very 
good. I bet that for anything that is just a couple of stores (three, in 
this case), you'd almost always be better off using regular stores. The 
"rep stosl" may be small, but the register constraints and the inability 
to combine memory accesses are a big downer.

> At -Os when GCC decides during the expand to use arch specific pattern 
> for the memset it would be much harder to handle it at the RTL level.  
> So the above should be ideally optimized already at the tree level.

Yes. Or perhaps by just saying that for -Os you'd still expand it for a 
really _small_ number of accesses (just make it smaller than for -O2).

> I'd say the test you want to do is
> if (sizeof (oss.ss_sp) + sizeof (oss.ss_size) + sizeof (oss.ss_flags)
>     != sizeof oss)
>   memset (&oss, 0, sizeof oss);
> (i.e. check whether the struct has any padding in it or not).

Yeah, that sounds logical. I'd still like to figure out how to get gcc to 
generate better code in this case, though. 

Explicit padding bytes would do it, of course, but then we're talking 
changs to every single 64-bit architecture. Grr.

			Linus
