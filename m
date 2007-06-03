Return-Path: <linux-kernel-owner+w=401wt.eu-S1751429AbXFCSWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbXFCSWx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 14:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbXFCSWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 14:22:46 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3310 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbXFCSWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 14:22:46 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 3 Jun 2007 11:22:40 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 2/2] ufd v1 - use unsequential O(1) fdmap
In-Reply-To: <20070603064322.GA12576@elte.hu>
Message-ID: <Pine.LNX.4.64.0706031105460.13247@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.24319.1180825146.2>
 <20070603064322.GA12576@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2007, Ingo Molnar wrote:

> > #define FD_UNSEQ_BASE	(1U << 28)
> > #define FD_UNSEQ_ALLOC  (1U << 30)
> 
> i'm wondering, why not use (1 << 30) both as the base and as the flag? 
> That would make integration of the new fd space 'seemless' in terms of 
> dup2() use.

There are two behaviours to handle. One is the standard dup2() one, where 
you pass a "newfd" by saying that you want "oldfd" exactly on top of 
"newfd". With the new sys_dup2() you can pass an fd inside the 
unsequential area, and have the same behviour of the legacy dup2().
The other one, unique to unsequential fds, is asking the kernel to just 
allocate a free one from the unsequential map, whatever it is.
So we need a flag, that is "far enough" from the unsequential map 
allocation space. I was actually thinking of moving FD_UNSEQ_BASE down to
(1 << 27) or (1 << 26), and leave some more space for flags.
128M or 64M of descriptors should be enough for the legacy, sequential fd 
allocator ;)



> > It'd be possible to add a new O_UNSEQFD flag to open(2) and make 
> > sys_open() to allocate the new descriptor inside the unsequential map.
> 
> yeah, please do that now - lets not leave any incomplete areas. We've 
> too often made the mistake of not pushing through new APIs consistently 
> enough.

Will do today.



> I'd also suggest a new sys_socket2() call that takes a 'flags' parameter 
> as well - because one primary user of this facility will be networking 
> servers. (O_UNSEQFD would make sense for it and O_NDELAY - currently 
> network apps that want to set O_NDELAY need to do it with an extra 
> fcntl() - while they could already indicate this in the sys_socket() 
> call, if it were closer to sys_open() semantics)

Makes sense for me, since sys_socket() is the primary source of fds 
wherever you have fd-crowded applications. And those definitely aren't 
using select() ;)
I seem to remember, that either you or Uli, talked about task-private fds, 
although I do not remember the context. A close-on-fork flag?



- Davide


