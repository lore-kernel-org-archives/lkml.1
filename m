Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbZI3UZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbZI3UZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 16:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbZI3UZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 16:25:43 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:56516 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbZI3UZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 16:25:43 -0400
Message-ID: <4AC3BE89.3040708@gmail.com>
Date: Wed, 30 Sep 2009 22:24:41 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arjan van de Ven <arjan@infradead.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.32-rc1
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain> <4AC060AE.1090401@gmail.com> <alpine.LFD.2.01.0909280829100.3349@localhost.localdomain> <20090928191506.40b61793@mschwide.boeblingen.de.ibm.com> <4AC10365.7090802@gmail.com> <4AC2712C.4080901@gmail.com> <alpine.LFD.2.01.0909291410440.6996@localhost.localdomain> <20090929232248.735bf4df@infradead.org> <alpine.LFD.2.01.0909291429570.6996@localhost.localdomain> <20090930170754.0886ff2e@infradead.org> <alpine.LFD.2.01.0909301304310.6996@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0909301304310.6996@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 30 Sep 2009 22:24:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds a écrit :
> 
> On Wed, 30 Sep 2009, Arjan van de Ven wrote:
>> +ENTRY(cmpxchg8b_emu)
>> +	CFI_STARTPROC
>> +
>> +	push %edi
>> +	push %ebx
>> +	push %ecx
>> +	/* disable interrupts */
>> +	pushf
>> +	pop %edi
>> +	cli
>> +
>> +	cmpl %edx, 4(%esi)
>> +	jne 1f
>> +	cmpl %eax, (%esi)
>> +	jne 1f
>> +
>> +	xchg (%esi), %ebx
>> +	xchg 4(%esi), %ecx
>> +	mov %ebx, %eax
>> +	mov %ecx, %edx
> 
> Ok, so why do you do this? You've just checked that the 8 bytes at esi are 
> the same as edx:eax, why do you do that odd xchg?
> 
> Why isn't this part just
> 
> 	mov %ebx,(%esi)
> 	mov %ecx,4(%esi)
> 
> and leave ebx/ecx alone?
> 
> I also don't see why you play games with eflags and %edi. Just leave the 
> flags on the stack. So it all would look like
> 
> 	#
> 	# Emulate 'cmpxchg8b (%esi)' except we don't
> 	# set the whole ZF thing (caller will just
> 	# compare eax:edx with the expected value)
> 	#
> 	cmpxchg8b_emu:
> 		pushfl
> 		cli
> 		cmpl (%esi),%eax
> 		jne not_same
> 		cmpl 4(%esi),%edx
> 		jne not_same
> 		movl %ebx,(%esi)
> 		movl %ecx,4(%esi)
> 		popfl
> 		ret
> 	not_same:
> 		movl (%esi),%eax
> 		movl 4(%esi),%edx
> 		popfl
> 		ret
> 
> I dunno. You _could_ use edi/ebp as a temporary for 'dest' to only do the 
> load once (and add push/pop to save the registers), but it's not like the 
> above is really atomic anyway, and it very much depends on 'cli' just 
> making sure that nothing else happens. So the above seems to be the 
> simplest emulation, considering the interfaces..
> 
> UNTESTED! I wrote this in an email editor. I haven't assembled it or 
> verified the semantics or workingness in any way, shape or form.
> 
> 			Linus

Yes, I provided following version in my first answer but apparently it was too complex :)

ENTRY(cmpxchg8b_emu)
	CFI_STARTPROC

	/* disable interrupts */
	pushf
	cli

	cmpl  %eax,(%esi)
	jne   1f
	cmpl  %edx,4(%esi)
	jne   2f

	mov   %ebx,(%esi)
	mov   %ecx,4(%esi)

	/* restore interrupts */
	popf
	ret
1:
	mov (%esi), %eax
2:
	mov 4(%esi), %edx
	popf
	ret
	CFI_ENDPROC
ENDPROC(cmpxchg8b_emu)

