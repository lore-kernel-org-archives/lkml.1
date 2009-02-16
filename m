Return-Path: <linux-kernel-owner+w=401wt.eu-S1752690AbZBPR35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbZBPR35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 12:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbZBPR3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 12:29:47 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:51825 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752340AbZBPR3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 12:29:46 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhcFAP8vmUlMQWt2/2dsb2JhbACBbs9rhBwG
Date: Mon, 16 Feb 2009 12:24:42 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Nick Piggin <npiggin@suse.de>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, akpm <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: irq-disabled vs vmap vs text_poke
Message-ID: <20090216172441.GA12576@Krystal>
References: <1234529407.6519.28.camel@twins> <20090213141839.GA31922@Krystal> <4995A0B7.1030705@redhat.com> <20090213165555.GA4684@Krystal> <4995B88C.2090900@redhat.com> <20090213185725.GC7124@Krystal> <4995E925.3080506@redhat.com> <4999808B.5080505@redhat.com> <20090216153145.GB19182@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090216153145.GB19182@wotan.suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:22:45 up 46 days, 17:20,  5 users,  load average: 0.20, 0.30,
	0.28
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nick Piggin (npiggin@suse.de) wrote:
> On Mon, Feb 16, 2009 at 10:04:43AM -0500, Masami Hiramatsu wrote:
> > >>>>>BTW, what about using map_vm_area() in text_poke() instead of vmap()?
> > >>>>>Since text_poke() just maps text pages to alias pages temporarily,
> > >>>>>I think we don't need to use delayed vunmap().
> 
> [...] 
> 
> > Here is the patch which replace v(un)map with (un)map_vm_area.
> 
> I don't quite understand the point of this... delayed vunmap() is
> just an implementation detail of vmap subsystem. Callers should not
> have to care.
> 

AFAIK, map_vm_area/unmap_vm_area is faster than vmap/vunmap.  This is
the point of this patch. Masami, could you provide a quick benchmark of
text_poke()/seconds before and after this optimization is applied to
confirm this ?

Thanks,

Mathieu

>  
> > Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> > ---
> >  arch/x86/include/asm/alternative.h |    1 +
> >  arch/x86/kernel/alternative.c      |   25 ++++++++++++++++++++-----
> >  init/main.c                        |    3 +++
> >  3 files changed, 24 insertions(+), 5 deletions(-)
> > 
> > Index: linux-2.6/arch/x86/include/asm/alternative.h
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/include/asm/alternative.h
> > +++ linux-2.6/arch/x86/include/asm/alternative.h
> > @@ -177,6 +177,7 @@ extern void add_nops(void *insns, unsign
> >   * The _early version expects the memory to already be RW.
> >   */
> > 
> > +extern void text_poke_init(void);
> >  extern void *text_poke(void *addr, const void *opcode, size_t len);
> >  extern void *text_poke_early(void *addr, const void *opcode, size_t len);
> > 
> > Index: linux-2.6/arch/x86/kernel/alternative.c
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/kernel/alternative.c
> > +++ linux-2.6/arch/x86/kernel/alternative.c
> > @@ -485,6 +485,16 @@ void *text_poke_early(void *addr, const
> >  	return addr;
> >  }
> > 
> > +static struct vm_struct *text_poke_area[2];
> > +static DEFINE_SPINLOCK(text_poke_lock);
> > +
> > +void __init text_poke_init(void)
> > +{
> > +	text_poke_area[0] = get_vm_area(PAGE_SIZE, VM_ALLOC);
> > +	text_poke_area[1] = get_vm_area(2 * PAGE_SIZE, VM_ALLOC);
> > +	BUG_ON(!text_poke_area[0] || !text_poke_area[1]);
> > +}
> > +
> >  /**
> >   * text_poke - Update instructions on a live kernel
> >   * @addr: address to modify
> > @@ -501,8 +511,9 @@ void *__kprobes text_poke(void *addr, co
> >  	unsigned long flags;
> >  	char *vaddr;
> >  	int nr_pages = 2;
> > -	struct page *pages[2];
> > -	int i;
> > +	struct page *pages[2], **pgp = pages;
> > +	int i, ret;
> > +	struct vm_struct *vma;
> > 
> >  	if (!core_kernel_text((unsigned long)addr)) {
> >  		pages[0] = vmalloc_to_page(addr);
> > @@ -515,12 +526,16 @@ void *__kprobes text_poke(void *addr, co
> >  	BUG_ON(!pages[0]);
> >  	if (!pages[1])
> >  		nr_pages = 1;
> > -	vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
> > -	BUG_ON(!vaddr);
> > +	spin_lock(&text_poke_lock);
> > +	vma = text_poke_area[nr_pages-1];
> > +	ret = map_vm_area(vma, PAGE_KERNEL, &pgp);
> > +	BUG_ON(ret);
> > +	vaddr = vma->addr;
> >  	local_irq_save(flags);
> >  	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
> >  	local_irq_restore(flags);
> > -	vunmap(vaddr);
> > +	unmap_kernel_range((unsigned long)vma->addr, (unsigned 
> > long)vma->size);
> > +	spin_unlock(&text_poke_lock);
> >  	sync_core();
> >  	/* Could also do a CLFLUSH here to speed up CPU recovery; but
> >  	   that causes hangs on some VIA CPUs. */
> > Index: linux-2.6/init/main.c
> > ===================================================================
> > --- linux-2.6.orig/init/main.c
> > +++ linux-2.6/init/main.c
> > @@ -676,6 +676,9 @@ asmlinkage void __init start_kernel(void
> >  	taskstats_init_early();
> >  	delayacct_init();
> > 
> > +#ifdef CONFIG_X86
> > +	text_poke_init();
> > +#endif
> >  	check_bugs();
> > 
> >  	acpi_early_init(); /* before LAPIC and SMP init */
> > 
> > -- 
> > Masami Hiramatsu
> > 
> > Software Engineer
> > Hitachi Computer Products (America) Inc.
> > Software Solutions Division
> > 
> > e-mail: mhiramat@redhat.com

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
