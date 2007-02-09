Return-Path: <linux-kernel-owner+w=401wt.eu-S1946487AbXBIPCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946487AbXBIPCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946500AbXBIPCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:02:44 -0500
Received: from ozlabs.org ([203.10.76.45]:47075 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946497AbXBIPCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:02:43 -0500
Subject: Re: [PATCH 6/10] lguest code: the little linux hypervisor.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@muc.de>
Cc: virtualization@lists.osdl.org,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <20070209135739.GB18080@muc.de>
References: <1171012296.2718.26.camel@localhost.localdomain>
	 <1171012761.2718.40.camel@localhost.localdomain>
	 <1171012827.2718.42.camel@localhost.localdomain>
	 <200702091109.20061.ak@muc.de>
	 <1171024771.2718.129.camel@localhost.localdomain>
	 <20070209135739.GB18080@muc.de>
Content-Type: text/plain
Date: Sat, 10 Feb 2007 02:01:57 +1100
Message-Id: <1171033317.2718.161.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-09 at 14:57 +0100, Andi Kleen wrote:
> On Fri, Feb 09, 2007 at 11:39:31PM +1100, Rusty Russell wrote:
> > On Fri, 2007-02-09 at 11:09 +0100, Andi Kleen wrote:
> > > > +# This links the hypervisor in the right place and turns it into a C array.
> > > > +$(obj)/hypervisor-raw: $(obj)/hypervisor.o
> > > > +	@$(LD) -static -Tdata=`printf %#x $$(($(HYPE_ADDR)))` -Ttext=`printf %#x $$(($(HYPE_ADDR)+$(HYPE_DATA_SIZE)))` -o $@ $< && $(OBJCOPY) -O binary $@
> > > > +$(obj)/hypervisor-blob.c: $(obj)/hypervisor-raw
> > > > +	@od -tx1 -An -v $< | sed -e 's/^ /0x/' -e 's/$$/,/' -e 's/ /,0x/g' > $@
> > > 
> > > an .S file with .incbin is more efficient and simpler
> > > (note it has to be an separate .S file, otherwise icecream/distcc break) 
> > > 
> > > It won't allow to show off any sed skills, but I guess we can live with that ;-)
> > 
> > Good idea, except I currently use sizeof(hypervisor_blob): I'd have to
> > extract the size separately and hand it in the CFLAGS 8(
> 
> hypervisor_start:
> 	.incbin "hypervisor"
> hypervisor_end:
> 
> ...
> 	extern char hypervisor_start[], hypervisor_end[];
> 
> 	size = hypervisor_end - hypervisor_start;

#define MAX_LGUEST_GUESTS \
	((HYPERVISOR_SIZE-sizeof(hypervisor_blob))/sizeof(struct lguest_state))
struct lguest lguests[MAX_LGUEST_GUESTS];

I could kmalloc that array, of course, but is it worth it to get rid of
one line in a Makefile?

> > > Statics? looks funky.  Why only a single hypervisor_vma?
> > 
> > We only have one switcher: it contains an array of "struct
> > lguest_state"; one for each guest.  (This is host code we're looking at
> > here).
> 
> This means it is not SMP safe? 

No, it's host-SMP safe.  There's no guest SMP support though, which
keeps things nice and simple.

> > No, the guest should not be able to evoke a printk from the host kernel.
> 
> This means nobody will know why it failed.

No, that's why the lguest process gets the error string (and prints it
out).  Biggest usability improvement I made in a while.

The kernel log is the absolute worst place to report errors; iptables
and module code both do that and the #1 FAQ is "What happened?"

I didn't make the same mistake this (third) time!  Here's lguest when
the guest crashes:

        # lguest 64m bzImage ...
        ...
        lguest: CRASH: Attempted to kill init!
        # 

> > It would have to be a switch then gunk at the bottom, because those last
> > two tests don't switch-ify.  IIRC I changed back from a switch because
> > of that.
> 
> gcc has a handy extension for this: 
> 
> case 0...FIRST_EXTERNAL_VECTOR-1:
> case SYSCALL_VECTOR:
> case FIRST_EXTERNAL_VECTOR...FIRST_EXTERNAL_VECTOR+LGUEST_IRQS:

Indeed, and I really wanted to use it, but it still doesn't allow
overlapping ranges.  The first cases are in the middle of 0 ...
FIRST_EXTERNAL_VECTOR-1, and if LGUEST_IRQS is large enough, 
SYSCALL_VECTOR is in the middle of FIRST_EXTERNAL_VECTOR ...
FIRST_EXTERNAL_VECTOR+LGUEST_IRQS 8(

Nonetheless, I switchified what I could in my update (testing now).

> Re: the loops; e.g. we used to have possible loop cases
> when a page fault does read instructions and then causes another
> page fault etc.etc. I haven't seen any immediate danger of this,
> but it might be worth double checking.

OK, I'll run some tests here.  There shouldn't be any danger here
though....

Thanks!
Rusty.

