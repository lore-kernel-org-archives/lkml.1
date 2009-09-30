Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbZI3Pam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbZI3Pam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbZI3Pam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:30:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:38729 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbZI3Pal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:30:41 -0400
Date: Wed, 30 Sep 2009 17:31:02 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.32-rc1
Message-ID: <20090930173102.2d54534c@infradead.org>
In-Reply-To: <4AC378C9.5050507@gmail.com>
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain>
	<4AC060AE.1090401@gmail.com>
	<alpine.LFD.2.01.0909280829100.3349@localhost.localdomain>
	<20090928191506.40b61793@mschwide.boeblingen.de.ibm.com>
	<4AC10365.7090802@gmail.com>
	<4AC2712C.4080901@gmail.com>
	<alpine.LFD.2.01.0909291410440.6996@localhost.localdomain>
	<20090929232248.735bf4df@infradead.org>
	<alpine.LFD.2.01.0909291429570.6996@localhost.localdomain>
	<20090930170754.0886ff2e@infradead.org>
	<4AC378C9.5050507@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Sep 2009 17:27:05 +0200
Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> > +	pop %edi
> Why do you pop flags in edi, to later re-push them ?
> 
> > +	cli

because here I disable interrupts

(basically this is local_irq_save() )
> 
> 
> > +	xchg (%esi), %ebx
> > +	xchg 4(%esi), %ecx
> How this sequence is guaranteed to be atomic with other cpus ?

it is not. this is the 486 implementation which is !SMP
(just like the current cmpxchg64() fallback)

> 
> If it is a !SMP implementation, then you could replace xchg by mov
> instructions.

that is not equivalent. I need to also store the old values
and return them....


> 
> So I suggest :
> 
> 
> ENTRY(cmpxchg8b_emu)
> 	CFI_STARTPROC
> 
> 	/* disable interrupts */
> 	pushf
> 	cli
> 
> 	cmpl  %eax,(%esi)
> 	jne   1f
> 	cmpl  %edx,4(%esi)
> 	jne   2f
> 
> 	mov   %ebx,(%esi)
> 	mov   %ecx,4(%esi)

this is not equivalent since you don't return the "prev" value.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
