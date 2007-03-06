Return-Path: <linux-kernel-owner+w=401wt.eu-S965369AbXCFR2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965369AbXCFR2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:28:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965371AbXCFR2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:28:04 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:42289 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965369AbXCFR2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:28:02 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch v2] epoll use a single inode ...
Date: Tue, 6 Mar 2007 18:28:00 +0100
User-Agent: KMail/1.9.5
Cc: "H. Peter Anvin" <hpa@zytor.com>, Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com> <200703061812.28478.dada1@cosmosbay.com> <Pine.LNX.4.64.0703060917500.5963@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703060917500.5963@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703061828.00253.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 March 2007 18:19, Linus Torvalds wrote:
> On Tue, 6 Mar 2007, Eric Dumazet wrote:
> > Something like :
> >
> > [PATCH] : Use reciprocal divides in sprintf()
>
> Try this on Core 2, and I suspect that you'll find that the hardware is
> actually *faster* than doing the shift/test, function call and the
> two multiplies.
>

Where do you see a function call ?

     448:       44 89 d0                mov    %r10d,%eax
     44b:       44 89 ea                mov    %r13d,%edx
     44e:       48 0f af c1             imul   %rcx,%rax
     452:       48 c1 e8 20             shr    $0x20,%rax
     456:       0f af d0                imul   %eax,%edx
     459:       49 29 d2                sub    %rdx,%r10
     45c:       43 0f b6 14 16          movzbl (%r14,%r10,1),%edx
     461:       41 89 c2                mov    %eax,%r10d
     464:       41 88 13                mov    %dl,(%r11)
     467:       49 ff c3                inc    %r11
     46a:       85 c0                   test   %eax,%eax
     46c:       75 da                   jne    448 <number+0x138>



> > Using reciprocal divides permits to change each divide by two multiplies,
> > less expensive on current CPUS.
>
> Are you sure?

I am going to test this, but at least on Opterons, the reciprocal divide I 
added into mm/slab.c gave me a nice speedup.

I am going to bench some stupid loop :

for (i = 0 ; i < 1000*1000 ; i++) {
	pipe(fds); close(fds[0]); close(fds[1]);
}

