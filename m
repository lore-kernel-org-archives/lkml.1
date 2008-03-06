Return-Path: <linux-kernel-owner+w=401wt.eu-S1763920AbYCFRZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763920AbYCFRZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 12:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbYCFRZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 12:25:16 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:51602 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751660AbYCFRZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 12:25:13 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CALy3z0dMQWoK/2dsb2JhbACBVqp6
Date: Thu, 6 Mar 2008 12:25:09 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: pageexec@freemail.hu
Cc: Ingo Molnar <mingo@elte.hu>, Srinivasa DS <srinivasa@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ananth@in.ibm.com, Jim Keniston <jkenisto@us.ibm.com>,
       srikar@linux.vnet.ibm.com, SystemTAP <systemtap@sources.redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86 - Enhance DEBUG_RODATA support - alternatives
Message-ID: <20080306172509.GA14284@Krystal>
References: <20080306140105.GC28438@elte.hu> <47D014E1.30964.22A9390F@pageexec.freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <47D014E1.30964.22A9390F@pageexec.freemail.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:19:39 up 6 days, 13:30,  6 users,  load average: 2.27, 1.28,
	0.73
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* pageexec@freemail.hu (pageexec@freemail.hu) wrote:
> On 6 Mar 2008 at 15:01, Ingo Molnar wrote:
> 
> > +/**
> > + * text_poke - Update instructions on a live kernel
> > + * @addr: address to modify
> > + * @opcode: source of the copy
> > + * @len: length to copy
> > + *
> > + * Only atomic text poke/set should be allowed when not doing early patching.
> > + * It means the size must be writable atomically and the address must be aligned
> > + * in a way that permits an atomic write. It also makes sure we fit on a single
> > + * page.
> > + */
> > +void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
> > +{
> > +	unsigned long flags;
> > +	char *vaddr;
> > +	int nr_pages = 2;
> > +
> > +	BUG_ON(len > sizeof(long));
> > +	BUG_ON((((long)addr + len - 1) & ~(sizeof(long) - 1))
> > +		- ((long)addr & ~(sizeof(long) - 1)));
> > +	{
> > +		struct page *pages[2] = { virt_to_page(addr),
> > +			virt_to_page(addr + PAGE_SIZE) };

I just want to ask for confirmation about two things :

First, that calling this text_poke implementation to modify text in a
module won't fail. Is virt_to_page(addr) ok if addr is in a vmalloc'ed
area ?

Second, that calling virt_to_page(addr + PAGE_SIZE) won't have
undesirable side-effects if addr happens to be in the last page of an
allocated range. It should be ok for the core kernel text, because it is
followed by the kernel rodata, but I am not certain for modules.

If any of these two are not true, then we should add a test for

if (kernel_text_address(addr)) {

around the vmap() allocation and fallback on 

} else
  vaddr = addr;

in the cases where text_poke is called to modify module code.

Mathieu

> > +		if (!pages[1])
> > +			nr_pages = 1;
> > +		vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
> > +		WARN_ON(!vaddr);
> > +		local_irq_save(flags);
> > +		memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
> > +		local_irq_restore(flags);
> 
> you probably want a BUG_ON instead (or some graceful recovery) else
> the NULL deref will trigger with IRQs off...
> 
> > +		vunmap(vaddr);
> > +	}
> >  	sync_core();
> >  	/* Could also do a CLFLUSH here to speed up CPU recovery; but
> >  	   that causes hangs on some VIA CPUs. */
> > +	return addr;
> >  }
> 
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
