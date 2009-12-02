Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbZLBRs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbZLBRs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 12:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754897AbZLBRsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 12:48:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36981 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754881AbZLBRsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 12:48:54 -0500
Date: Wed, 2 Dec 2009 09:48:15 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Jan Beulich <JBeulich@novell.com>, a.p.zijlstra@chello.nl, mingo@elte.hu,
       tglx@linutronix.de, mingo@redhat.com, npiggin@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [tip:core/locking] locking, x86: Slightly shorten 
 __ticket_spin_trylock()
In-Reply-To: <4B16A2A5.2030307@zytor.com>
Message-ID: <alpine.LFD.2.00.0912020938330.2872@localhost.localdomain>
References: <4B0FF9AC0200007800022713@vpn.id2.novell.com> <tip-133ec7a235160dd44cbd4d82fff65a9983331df9@git.kernel.org> <alpine.LFD.2.00.0912020714420.2872@localhost.localdomain> <4B16A2CC020000780002313A@vpn.id2.novell.com> <alpine.LFD.2.00.0912020853240.2872@localhost.localdomain>
 <alpine.LFD.2.00.0912020857270.2872@localhost.localdomain> <4B16A2A5.2030307@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Dec 2009, H. Peter Anvin wrote:
> 
> For what it's worth, the gcc ABI for i386-Linux treats _Bool (bool) as
> follows:
> 
> When in memory, except stack slots:
> 
> 	sizeof(_Bool) = 1
> 	0 is false, 1 is true, any other value is *undefined behavior*.
> 
> When in registers, or in a stack slot:
> 
> 	Registers, and stack slots, are always 4 bytes
> 	0 is false, 1 is true, any other value is *undefined behavior*.

Hmm. Odd. I just checked:

	_Bool myfunction(char val)
	{
		return val;
	}

and compiling it with

	gcc -O2 -S -m32 -mregparm=3 -fomit-frame-pointer t.c

I get

	myfunction:
		testb	%al, %al
		setne	%al
		ret

which only sets the low 8 bits. So my gcc actually seems to think that 
_Bool is just 8 bits, at least for return values, and then upper 24 bits 
are undefined. It also generates 'testb' for a test of a return value.

So it so happens that I think Jan's patch would have worked - except for 
the PV_OPS mess. _Bool does act like a 'char' on x86 at least with gcc. I 
still think that it's fundamentally wrong to use 'bool' because of how 
subtly it can act.

			Linus
