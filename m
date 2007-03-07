Return-Path: <linux-kernel-owner+w=401wt.eu-S965715AbXCGW63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965715AbXCGW63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965714AbXCGW62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:58:28 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36363 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965291AbXCGW61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:58:27 -0500
Date: Wed, 7 Mar 2007 14:57:27 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anton Blanchard <anton@samba.org>
cc: Eric Dumazet <dada1@cosmosbay.com>,
       Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch] epoll use a single inode ...
In-Reply-To: <20070307221401.GA16938@kryten>
Message-ID: <Pine.LNX.4.64.0703071453080.5963@woody.linux-foundation.org>
References: <45ED1A3C.6030707@argo.co.il> <200703071906.58405.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0703071022390.5963@woody.linux-foundation.org>
 <200703071952.13219.dada1@cosmosbay.com> <20070307221401.GA16938@kryten>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Mar 2007, Anton Blanchard wrote:
> 
> Funny you mention this. We found some noticeable ppc64 regressions when
> moving the dcache to standard list macros and had to do this to fix it
> up:
> 
> static inline void prefetch(const void *x)
> {
>         if (unlikely(!x))
>                 return;
> 
>         __asm__ __volatile__ ("dcbt 0,%0" : : "r" (x));
> }
> 
> Urgh :)

Yeah, I'm not at all surprised. Any implementation of "prefetch" that 
doesn't just turn into a no-op if the TLB entry doesn't exist (which makes 
them weaker for *actual* prefetching) will generally have a hard time with 
a NULL pointer. Exactly because it will try to do a totally unnecessary 
TLB fill - and since most CPU's will not cache negative TLB entries, that 
unnecessary TLB fill will be done over and over and over again..

In general, using software prefetching is just a stupid idea, unless

 - the prefetch really is very strict (ie for a linked list you do exactly 
   the above kinds of things to make sure that you don't try to prefetch 
   the non-existent end entry)
AND
 - the CPU is stupid (in-order in particular).

I think Intel even suggests in their optimization manuals to *not* do 
software prefetching, because hw can usually simply do better without it.

		Linus
