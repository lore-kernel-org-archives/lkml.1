Return-Path: <linux-kernel-owner+w=401wt.eu-S1753689AbYKDNvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbYKDNvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 08:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYKDNvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 08:51:05 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:56809 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752105AbYKDNvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 08:51:04 -0500
X-Greylist: delayed 1262 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Nov 2008 08:51:04 EST
Message-Id: <1225805399.25337.1282903253@webmail.messagingengine.com>
X-Sasl-Enc: doz4H7jakyqOMDmx0aJLnImyhopE4sWB4Wcj4m0mziF/ 1225805399
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Ingo Molnar" <mingo@elte.hu>,
       "Alexander van Heukelum" <heukelum@mailshack.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, lguest@ozlabs.org,
       jeremy@xensource.com, "Steven Rostedt" <srostedt@redhat.com>,
       "Cyrill Gorcunov" <gorcunov@gmail.com>, "Mike Travis" <travis@sgi.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20081104122839.GA22864@mailshack.com> <20081104124242.GA6795@elte.hu>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
In-Reply-To: <20081104124242.GA6795@elte.hu>
Date: Tue, 04 Nov 2008 14:29:59 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008 13:42:42 +0100, "Ingo Molnar" <mingo@elte.hu> said:
> 
> * Alexander van Heukelum <heukelum@mailshack.com> wrote:
> 
> > Hi all,
> > 
> > An x86 processor handles an interrupt (from an external source, 
> > software generated or due to an exception), depending on the 
> > contents if the IDT. Normally the IDT contains mostly interrupt 
> > gates. Linux points each interrupt gate to a unique function. Some 
> > are specific to some task (handling traps, IPI's, ...), the others 
> > are stubs that push the interrupt number to the stack and jump to 
> > 'common_interrupt'.
> > 
> > This patch removes the need for the stubs.
> 
> hm, the cost would be this new code:
> 
> > +.p2align
> > +ENTRY(maininterrupt)
> >  	RING0_INT_FRAME
> > -vector=0
> > -.rept NR_VECTORS
> > -	ALIGN
> > - .if vector
> > -	CFI_ADJUST_CFA_OFFSET -4
> > - .endif
> > -1:	pushl $~(vector)
> > -	CFI_ADJUST_CFA_OFFSET 4
> > +	push %eax
> > +	push %eax
> > +	mov %cs,%eax
> > +	shr $3,%eax
> > +	and $0xff,%eax
> > +	not %eax
> > +	mov %eax,4(%esp)
> > +	pop %eax
> >  	jmp common_interrupt
> 
> .. which we were able to avoid before. A couple of segment register 
> accesses, shifts, etc to calculate the vector - each of which can be 
> quite costly (especially the segment register access - this is a 
> relatively rare instruction pattern).

The way it is written now is just so I did not have to change
common_interrupt (to keep changes small). All those accesses
so close together will cost some cycles, but much can be avoided
if it is integrated. If the precise content of the stack can be
changed, this could be as simple as "push %cs". Even that can be
delayed, because the content of the cs register will still be
there.

Note that the specialized interrupts (including page fault, etc.)
will not go via this path. As far as I understand now, it is only
the interrupts from external devices that normally go via
common_interrupt. There I think the overhead is really tiny
compared to the rest of the handling of the interrupt.

> I'm not unconvicable, but we need to be conservative here: could you 
> try to measure the full before/after cost of IRQ entry, to the cycle 
> level? I'm curious what the performance impact is.
> 
> Also, this makes life probably a bit harder for Xen, which assumes 
> that the GDT of the guest OS is small-ish. (Jeremy Cc:-ed)

I already had jeremy@xensource.com for exactly this reason ;). 

Greetings,
    Alexander

> 	Ingo
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - A no graphics, no pop-ups email service

