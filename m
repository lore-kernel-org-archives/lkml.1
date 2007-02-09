Return-Path: <linux-kernel-owner+w=401wt.eu-S1946466AbXBIN5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946466AbXBIN5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 08:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946467AbXBIN5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 08:57:42 -0500
Received: from colin.muc.de ([193.149.48.1]:1383 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946466AbXBIN5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 08:57:41 -0500
Date: 9 Feb 2007 14:57:39 +0100
Date: Fri, 9 Feb 2007 14:57:39 +0100
From: Andi Kleen <ak@muc.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.osdl.org,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 6/10] lguest code: the little linux hypervisor.
Message-ID: <20070209135739.GB18080@muc.de>
References: <1171012296.2718.26.camel@localhost.localdomain> <1171012761.2718.40.camel@localhost.localdomain> <1171012827.2718.42.camel@localhost.localdomain> <200702091109.20061.ak@muc.de> <1171024771.2718.129.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171024771.2718.129.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09, 2007 at 11:39:31PM +1100, Rusty Russell wrote:
> On Fri, 2007-02-09 at 11:09 +0100, Andi Kleen wrote:
> > > +# This links the hypervisor in the right place and turns it into a C array.
> > > +$(obj)/hypervisor-raw: $(obj)/hypervisor.o
> > > +	@$(LD) -static -Tdata=`printf %#x $$(($(HYPE_ADDR)))` -Ttext=`printf %#x $$(($(HYPE_ADDR)+$(HYPE_DATA_SIZE)))` -o $@ $< && $(OBJCOPY) -O binary $@
> > > +$(obj)/hypervisor-blob.c: $(obj)/hypervisor-raw
> > > +	@od -tx1 -An -v $< | sed -e 's/^ /0x/' -e 's/$$/,/' -e 's/ /,0x/g' > $@
> > 
> > an .S file with .incbin is more efficient and simpler
> > (note it has to be an separate .S file, otherwise icecream/distcc break) 
> > 
> > It won't allow to show off any sed skills, but I guess we can live with that ;-)
> 
> Good idea, except I currently use sizeof(hypervisor_blob): I'd have to
> extract the size separately and hand it in the CFLAGS 8(

hypervisor_start:
	.incbin "hypervisor"
hypervisor_end:

...
	extern char hypervisor_start[], hypervisor_end[];

	size = hypervisor_end - hypervisor_start;

	


> > > +static int cpu_had_pge;
> > > +static struct {
> > > +	unsigned long offset;
> > > +	unsigned short segment;
> > > +} lguest_entry;
> > > +struct page *hype_pages; /* Contiguous pages. */
> > 
> > Statics? looks funky.  Why only a single hypervisor_vma?
> 
> We only have one switcher: it contains an array of "struct
> lguest_state"; one for each guest.  (This is host code we're looking at
> here).

This means it is not SMP safe? 

> No, the guest should not be able to evoke a printk from the host kernel.

This means nobody will know why it failed.

> > > +	else if (i < FIRST_EXTERNAL_VECTOR || i == SYSCALL_VECTOR)
> > > +		setup_idt(lg, i, &d);
> > > +	/* A virtual interrupt */
> > > +	else if (i < FIRST_EXTERNAL_VECTOR + LGUEST_IRQS)
> > > +		copy_trap(lg, &lg->interrupt[i-FIRST_EXTERNAL_VECTOR], &d);\
> > 
> > switch is not cool enough anymore?
> 
> It would have to be a switch then gunk at the bottom, because those last
> two tests don't switch-ify.  IIRC I changed back from a switch because
> of that.

gcc has a handy extension for this: 

case 0...FIRST_EXTERNAL_VECTOR-1:
case SYSCALL_VECTOR:
case FIRST_EXTERNAL_VECTOR...FIRST_EXTERNAL_VECTOR+LGUEST_IRQS:


Re: the loops; e.g. we used to have possible loop cases
when a page fault does read instructions and then causes another
page fault etc.etc. I haven't seen any immediate danger of this,
but it might be worth double checking.

-Andi
