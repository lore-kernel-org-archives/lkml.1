Return-Path: <linux-kernel-owner+w=401wt.eu-S1758622AbZGCTLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622AbZGCTLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 15:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757278AbZGCTLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 15:11:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59668 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756998AbZGCTLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 15:11:03 -0400
Date: Fri, 3 Jul 2009 12:10:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Eric Dumazet <eric.dumazet@gmail.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: atomic64: inline atomic64_read()
In-Reply-To: <20090703180450.GB3405@elte.hu>
Message-ID: <alpine.LFD.2.01.0907031207030.3210@localhost.localdomain>
References: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain> <tip-9103cab145a93cef13378632b332a824758a2f6f@git.kernel.org> <4A4E1AA2.30002@gmail.com> <20090703180450.GB3405@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 3 Jul 2009, Ingo Molnar wrote:
> > +
> > +	asm volatile(
> > +		"mov %%ebx, %%eax\n\t"
> > +		"mov %%ecx, %%edx\n\t"
> > +		LOCK_PREFIX "cmpxchg8b %1\n"
> > +			: "=&A" (res)
> > +			: "m" (*ptr) 
> > +		);
> 
> That clobbers or affects eax, ebx, ecx, edx. The only registers it 
> does not clobber is esi, edi and rbp.

No, it only clobbers eax/edx. Yes, it touches ebx/ecx, but that's kind of 
incidental, and read-only, and doesn't matter.

> Linus, what's your preference in this case?

I think it's kind of subtle to do that thing, but it _is_ very much a 
special case. It's odd to use a cmpxchg8b to just do a read in the first 
place, so the fact that we then play other games with it is kind of 
immaterial.

Adding a comment about the magic "we don't care about the initial values 
in eax/edx and ebx/ecx, but they have to match in case we end up doing a 
writeback" might be a good idea.

		Linus
