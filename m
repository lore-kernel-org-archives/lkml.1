Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbZEQWsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbZEQWsK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 18:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbZEQWry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 18:47:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752404AbZEQWry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 18:47:54 -0400
Date: Sun, 17 May 2009 15:47:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Miller <davem@davemloft.net>
cc: hugh@veritas.com, ak@linux.intel.com, ian.campbell@citrix.com,
       jakub@redhat.com, linux-kernel@vger.kernel.org, jesper.nilsson@axis.com,
       hannes@cmpxchg.org, arjan@linux.intel.com, akpm@linux-foundation.org
Subject: Re: [PATCH] Fix print out of function which called WARN_ON()
In-Reply-To: <20090517.152454.91703958.davem@davemloft.net>
Message-ID: <alpine.LFD.2.01.0905171529500.3301@localhost.localdomain>
References: <alpine.LFD.2.01.0905161342150.3301@localhost.localdomain> <Pine.LNX.4.64.0905171536470.23834@blonde.anvils> <alpine.LFD.2.01.0905171502160.3301@localhost.localdomain> <20090517.152454.91703958.davem@davemloft.net>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 17 May 2009, David Miller wrote:
> 
> There is some strageness wrt. varargs in that it seems that the opaque
> object used to reference varargs is effectively an array which
> includes first the arguments passed in registers and then the
> non-register stack args.

I forget what the exact details were, but I _think_ it boiled down to the 
varargs save area is always large enough for the maximum number of 
register arguments. Fair enough. It used to be that that means something 
like 216 bytes of stack-space with SSE registers (8*16 bytes for just 
that unused SSE register save).

So I reported that, and my fix got merged (or rather, I think somebody 
improved on my hacky one and that improved fix got merged).

But now it still generates a 88 byte stack frame, and only about half that 
seems to be used (six integer registers, but the "..." part can only be 
five, so you have 5*8=40 bytes save-space, and an additional pointer to 
the frame that contains the rest).

So the stack frame _should_ be just 48 bytes, but gcc always seems to 
generate either 80 or 88 bytes. I never bothered to try to chase it down, 
the code is rather obscure. I suspect it has some "current pointer" too 
etc, and there is probably some alignment as well. But I'm sure that there 
are entries on the stack frame that simply aren't filled in.

At least with the XMM fix, there's now just a _couple_ of such entries. 

> I never got down to the details yet, but on sparc64 currently we
> always eat that extra space

Ouch. On x86-64, it at least _only_ happens in the functions that do 
va_start().

				Linus
