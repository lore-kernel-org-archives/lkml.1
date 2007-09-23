Return-Path: <linux-kernel-owner+w=401wt.eu-S1758194AbXIWS73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194AbXIWS73 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 14:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755546AbXIWS7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 14:59:21 -0400
Received: from 1wt.eu ([62.212.114.60]:2648 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077AbXIWS7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 14:59:21 -0400
Date: Sun, 23 Sep 2007 20:46:39 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Dave Jones <davej@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: memset as memzero
Message-ID: <20070923184639.GI10199@1wt.eu>
References: <20070922083355.GA7226@cvg> <20070922124659.741cca42@laptopd505.fenrus.org> <alpine.LFD.0.999.0709221149480.16478@woody.linux-foundation.org> <20070923153243.GE8127@redhat.com> <20070923160750.GO4887@ghostprotocols.net> <alpine.LFD.0.999.0709230956040.16478@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709230956040.16478@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 23, 2007 at 10:05:05AM -0700, Linus Torvalds wrote:
> 
> 
> On Sun, 23 Sep 2007, Arnaldo Carvalho de Melo wrote:
> > 
> > bzero! That is it, its nothing new, just a sane name to something [..]
> 
> No, please no!
> 
> The BSD memory functions are nasty. If you do bzero, you logically should 
> do the others too, and they are way inferior to the standard ones. Let's 
> not go there.
> 
> Besides, if we want to avoid mistakes, I would suggest going to a much 
> higher level. Ie more along the lines of also fixing the size and 
> alignment, and using something like
> 
> 	#define memclear(p) memset(p, 0, sizeof(*(p)))

I don't like it when macros magically do sizeof(*p), because people often
think that the macro is smarter than it really is, and you commonly end
up with code looking like this :

     char *p;
     ...
     p = kmalloc(n);
     ...
     memclear(p);

This can happen for instance when replacing a stack-allocated buffer
with a malloc because it became too big for the stack. Such a mistake
is *very hard* to detect by human eye, while having "sizeof(*p)" in
the same function as "char *p" will trigger some automatisms in most
readers' brains.

> because if you actually do something like
> 
> 	git grep 'memset.*,[ 	]*0[ 	]*,'
> 
> (those [..] things contatain a space and a tab), you'll see that a *lot* 
> of them share that pattern. 

At least current code is still greppable for such usages. Doing too
much magics with macros often harms debugging. I could agree with
having a macro to force the pattern to '0', but not to force the size.

> Not that I think it's really worth it.

I don't think either.

Willy

