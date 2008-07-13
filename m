Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbYGMShm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbYGMShm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 14:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbYGMShg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 14:37:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753427AbYGMShf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 14:37:35 -0400
Date: Sun, 13 Jul 2008 11:36:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Denys Vlasenko <vda.linux@googlemail.com>,
       T?r?k Edwin <edwintorok@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Elias Oltmanns <eo@nebensachen.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: <20080713104617.GA79@tv-sign.ru>
Message-ID: <alpine.LFD.1.10.0807131121430.2959@woody.linux-foundation.org>
References: <20080710215039.2A143154218@magilla.localdomain> <alpine.LFD.1.10.0807121011470.2875@woody.linux-foundation.org> <48791393.1020107@gmail.com> <200807122257.59047.vda.linux@googlemail.com> <20080713104617.GA79@tv-sign.ru>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 13 Jul 2008, Oleg Nesterov wrote:
> 
> SETFL_MASK doesn't have O_RDWR, and in any case setfl() changes ->f_flags,
> not ->f_mode.

I think you can still read a write-only file descriptor on some systems: 
doing a mmap( PROT_WRITE ) on it can sometimes do it.

The reason - PROT_WRITE often implies PROT_READ (because on many CPU's you 
have to do unaligned writes with a read-modify-write cycle - on some like 
old alphas you have to do even normal byte and word writes that way).

So if the OS checks just the asked-for protections against the file 
descriptor protections, you'll essentially get read access for free when 
you do the mmap.

At least current versions of Linux won't ever allow a file mapping of a 
non-readable fd, but I won't guarantee we always did that, nor that other 
OS's always do it.

Anyway, I misunderstood Edwins idea to actually throw away the writes if 
the file isn't linked anywhere and is only open for writing. I guess we 
could optimize that, but it's such an unrealistic specialc case that it 
really isn't worth it except for some benchmark-gaming kind of thing 
(which I don't like doing anyway).

				Linus
