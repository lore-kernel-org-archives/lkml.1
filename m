Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbXGITQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbXGITQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 15:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbXGITQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 15:16:29 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2490 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbXGITQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 15:16:28 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 9 Jul 2007 12:16:26 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Nick Piggin <npiggin@suse.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: queued spinlock code and results
In-Reply-To: <Pine.LNX.4.64.0707091140440.15898@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0707091210510.15898@alien.or.mcafeemobile.com>
References: <20070708043228.GB22397@wotan.suse.de>
 <Pine.LNX.4.64.0707091140440.15898@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007, Davide Libenzi wrote:

> #define ZLOCK_INIT(l) (l)[0] = 0, (l)[1] = 0
> static inline void zlock(short *lock)
> {
> 	__asm__ __volatile__ ("lock ; xaddl %%eax, %0\n\t"
> 			      "mov %%eax, %%ebx\n\t"
> 			      "shr $16, %%ebx\n\t"
> 			      "1:\n\t"
> 			      "cmpw %%ax, %%bx\n\t"
> 			      "je 2f\n\t"
> 			      "rep ; nop\n\t"
- 			      "movw %1, %%bx\n\t"
+ 			      "movw %1, %%ax\n\t"
> 			      "lfence\n\t"
> 			      "jmp 1b\n\t"
> 			      "2:\n\t"
> 			    : "+m" (*(int *) lock)
> 			    : "m" (lock[0]), "a" (0x10000) : "ebx", "memory");
> }

Erm, modulo that bugger ;) that'd never should up in the non-contended 
case (and that does not change numbers):

inc-lock in cache takes 7.28ns
xadd-lock in cache takes 8.93ns
vadd-lock in cache takes 10.34ns
zadd-lock in cache takes 8.43ns
inc-lock out of cache takes 87.98ns
xadd-lock out of cache takes 88.89ns
vadd-lock out of cache takes 89.59ns
zadd-lock out of cache takes 89.86ns



- Davide


