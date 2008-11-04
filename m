Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbYKDPrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbYKDPrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:47:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbYKDPrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 10:47:43 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:45254 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753549AbYKDPrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 10:47:42 -0500
Message-Id: <1225813659.22738.1282932197@webmail.messagingengine.com>
X-Sasl-Enc: 54mKIBdZy71tszO4LkKndz5FdsHM802Tzjaa+Las5jrN 1225813659
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>,
       "Alexander van Heukelum" <heukelum@mailshack.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, lguest@ozlabs.org,
       jeremy@xensource.com, "Steven Rostedt" <srostedt@redhat.com>,
       "Mike Travis" <travis@sgi.com>, "Andi Kleen" <andi@firstfloor.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20081104122839.GA22864@mailshack.com>
 <20081104150729.GC21470@localhost>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
In-Reply-To: <20081104150729.GC21470@localhost>
Date: Tue, 04 Nov 2008 16:47:39 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 4 Nov 2008 18:07:29 +0300, "Cyrill Gorcunov"
<gorcunov@gmail.com> said:
> [Alexander van Heukelum - Tue, Nov 04, 2008 at 01:28:39PM +0100]
> | Hi all,
> | 
> | An x86 processor handles an interrupt (from an external
> | source, software generated or due to an exception),
> | depending on the contents if the IDT. Normally the IDT
> | contains mostly interrupt gates. Linux points each
> | interrupt gate to a unique function. Some are specific
> | to some task (handling traps, IPI's, ...), the others
> | are stubs that push the interrupt number to the stack
> | and jump to 'common_interrupt'.
> | 
> | This patch removes the need for the stubs.
> | 
> | An interrupt gate contains a FAR pointer to the interrupt
> | handler, meaning that the code segment of the interrupt
> | handler is also reloaded. Instead of pointing each (non-
> | specific) interrupt gate to a unique handler, we set a
> | unique code segment and use a common handler. When the
> | handler finishes the code segment is restored to the
> | 'normal'/previous one.
> | 
> | In order to have a unique code segment for each interrupt
> | vector, the GDT is extended to 512 entries (1 full page),
> | and the last half of the page describes identical code
> | segments (identical, except for the number in the cs
> | register), which are refered to by the 256 interrupt
> | gates.
> | 
> | In this version, even the specialized handlers get run
> | with their code segment switched. This is not necessary,
> | but I like the fact that in a register dump one can now
> | see from the code segment that the code is ran due to
> | a (hard) interrupt. The exception I made is the int 0x80
> | (syscall), which runs with the normal kernel code segment.
> | 
> | 
> | Concluding: changing interrupt handling to this way
> | removes quite a bit of source code. It also removes the
> | need for the interrupt stubs and, on i386, pointers to
> | them. This saves a few kilobytes of code. The page
> | reserved for the GDT is now fully used. The cs register
> | indicating directly that code is executed on behalf of
> | a (hardware) interrupt is a nice debugging aid. This way
> | of handling interrupts also leads to cleaner code: this
> | patch already gets rid of some 'ugly' macro magic in
> | entry_32.S and irqinit_64.c.
> | 
> | More cleanup is certainly possible, but I have tried to
> | keep the changes local and small. If switching code
> | segments is too expensive for some paths, that can be
> | fixed by not doing that ;).
> | 
> | I'ld welcome some numbers on a few benchmarks on real
> | hardware (I only tested on qemu: debian runs without
> | noticable differences before/after this patch).
> | 
> | Greetings,
> |     Alexander
> | 
> | P.S. Just in case someone thinks this is a great idea and
> | testing and benchmarking goes well...
> |
> ...
> 
> Hi Alexander, great done!
> 
> not taking into account the cost of cs reading (which I
> don't suspect to be that expensive apart from writting,
> on the other hand I guess walking on GDT entries could
> be not that cheap especially with new segments you propose,
> I guess cpu internally check for segment to be the same
> and do not reload it again even if it's described as FAR
> pointer but I could be wrong so Andi CC'ed :)

Thanks! And indeed Andi might know more about this.

I wonder how the time needed for reading the GDT segments
balances against the time needed due to the extra redirection
due to running the stubs. I'ld be interested if the difference
can be measured with the current implementation. (I really
need to highjack a machine to do some measurements; I hoped
someone would do it before I got to it ;) )

Even if some CPU's have some internal optimization for the case
where the gate segment is the same as the current one, I wonder
if it is really important... Interrupts that occur while the
processor is running userspace already cause changing segments.
They are more likely to be in cache, maybe.

Greetings,
    Alexander

> A small nit in implementation:
> 
> entry_32.S:
> +	push %eax
> +	push %eax
> +	mov %cs,%eax
> +	shr $3,%eax
> +	and $0xff,%eax
> +	not %eax
> +	mov %eax,4(%esp)
> +	pop %eax
> 
> CFI_ADJUST_CFA_OFFSET missed?

Sure, I did just enough to make it work for me ;).

> 		- Cyrill -
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - IMAP accessible web-mail

