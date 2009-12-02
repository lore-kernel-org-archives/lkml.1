Return-Path: <linux-kernel-owner+w=401wt.eu-S1755311AbZLBR7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbZLBR7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 12:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbZLBR7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 12:59:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47500 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbZLBR7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 12:59:20 -0500
Message-ID: <4B16AAD1.7090900@zytor.com>
Date: Wed, 02 Dec 2009 09:58:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jan Beulich <JBeulich@novell.com>, a.p.zijlstra@chello.nl, mingo@elte.hu,
       tglx@linutronix.de, mingo@redhat.com, npiggin@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [tip:core/locking] locking, x86: Slightly shorten  __ticket_spin_trylock()
References: <4B0FF9AC0200007800022713@vpn.id2.novell.com> <tip-133ec7a235160dd44cbd4d82fff65a9983331df9@git.kernel.org> <alpine.LFD.2.00.0912020714420.2872@localhost.localdomain> <4B16A2CC020000780002313A@vpn.id2.novell.com> <alpine.LFD.2.00.0912020853240.2872@localhost.localdomain> <alpine.LFD.2.00.0912020857270.2872@localhost.localdomain> <4B16A2A5.2030307@zytor.com> <alpine.LFD.2.00.0912020938330.2872@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912020938330.2872@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2009 09:48 AM, Linus Torvalds wrote:
> 
> Hmm. Odd. I just checked:
> 
> 	_Bool myfunction(char val)
> 	{
> 		return val;
> 	}
> 
> and compiling it with
> 
> 	gcc -O2 -S -m32 -mregparm=3 -fomit-frame-pointer t.c
> 
> I get
> 
> 	myfunction:
> 		testb	%al, %al
> 		setne	%al
> 		ret
> 
> which only sets the low 8 bits. So my gcc actually seems to think that 
> _Bool is just 8 bits, at least for return values, and then upper 24 bits 
> are undefined. It also generates 'testb' for a test of a return value.
> 

Damn.  I stand corrected :-/  I just tested it on x86-64, and gcc 4.4.1
actually *violates the documented ABI* for x86-64.

> So it so happens that I think Jan's patch would have worked - except for 
> the PV_OPS mess. _Bool does act like a 'char' on x86 at least with gcc. I 
> still think that it's fundamentally wrong to use 'bool' because of how 
> subtly it can act.

I personally think using "bool" for C values is a good thing -- people
have a very nasty tendency to come up with the clever idea of "oh, there
is this flag which is 'int'... well, in this special case let's set it
to -1 or 2", and of course there is absolutely no way to know, globally,
that this value once in a blue moon gets set to a bizarre value.  I have
seen this a number of times in the kernel.  It doesn't mean one should
pass it to assembly code.

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

