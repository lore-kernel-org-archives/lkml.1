Return-Path: <linux-kernel-owner+w=401wt.eu-S933843AbYAaQ3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933843AbYAaQ3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759723AbYAaQ33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:29:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52207 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760704AbYAaQ32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:29:28 -0500
Date: Thu, 31 Jan 2008 08:29:06 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Pekka Paalanen <pq@iki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Paalanen <pq@iki.fi>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH v2] x86: mmiotrace - trace memory mapped IO
Message-ID: <20080131082906.6a1befba@laptopd505.fenrus.org>
In-Reply-To: <20080131181630.10cb1eac@daedalus.pq.iki.fi>
References: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
	<1201660102.8837.9.camel@brick>
	<1201660453.8837.13.camel@brick>
	<20080130200827.322c4f7d@daedalus.pq.iki.fi>
	<20080131150746.GB11996@elte.hu>
	<20080131180253.6c007852@daedalus.pq.iki.fi>
	<20080131181630.10cb1eac@daedalus.pq.iki.fi>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008 18:16:30 +0200
Pekka Paalanen <pq@iki.fi> wrote:

> > > could you please send us a patch for the whole mmiotrace
> > > kernel-side feature, so that we can have a look at the general
> > > structure of this? (and the interaction with change_page_attr(),
> > > etc.) Even if it's not functional (and wont even build/boot) at
> > > the moment. Thanks,
> 
> And here's mmiotrace. This works for me (amd64), but not for a test
> user who has 32-bit x86. We have not had the chance to debug it yet.
> The symptom is "everything locked up" after insmodding
> testmmiotrace.ko, targeting the mid-point of his VRAM. And there's
> the "undefined symbol init_mm" problem on 32-bit, but we just put the
> export back in (not included in these patches).
> 
> No-one has tried this on SMP. I have a Core 2 Duo laptop where I will
> test this when I get the chance.

 +static void print_pte(unsigned long address)
> +{
> +	pgd_t *pgd = pgd_offset_k(address);
> +	pud_t *pud = pud_offset(pgd, address);
> +	pmd_t *pmd = pmd_offset(pud, address);
> +	if (pmd_large(*pmd)) {
> +		printk(KERN_EMERG MODULE_NAME ": 4MB pages are not "
> +						"currently
> supported: %lx\n",
> +						address);
> +		BUG();
> +	}
> +	printk(KERN_DEBUG MODULE_NAME ": pte for 0x%lx: 0x%lx
> 0x%lx\n",
> +		address,
> +		pte_val(*pte_offset_kernel(pmd, address)),
> +		pte_val(*pte_offset_kernel(pmd, address)) &
> _PAGE_PRESENT); +}

ok this wants to use some of the page_address() and other helpers from pageattr.c;
that should be easy to solve during integration
(I can even see a more generic version of this function moving there)


> +/* file_create() callback.  Creates relay file in debugfs. */
> +static struct dentry *create_buf_file_handler(const char *filename,
> +						struct dentry
> *parent,
> +						int mode,
> +						struct rchan_buf
> *buf,
> +						int *is_global)
> +{
> +	struct dentry *buf_file;
> +
> +	mmio_fops.read = relay_file_operations.read;
> +	mmio_fops.open = relay_file_operations.open;
> +	mmio_fops.poll = relay_file_operations.poll;
> +	mmio_fops.mmap = relay_file_operations.mmap;
> +	mmio_fops.release = relay_file_operations.release;
> +	mmio_fops.splice_read = relay_file_operations.splice_read;

can't we do this at compile time?


> +
> +void __iomem *ioremap_cache_trace(unsigned long offset, unsigned
> long size) +{
> +	void __iomem *p = ioremap_cache(offset, size);
> +	printk(KERN_DEBUG MODULE_NAME ": ioremap_cache(0x%lx, 0x%lx)
> = %p\n",
> +							offset,
> size, p);
> +	ioremap_trace_core(offset, size, p);
> +	return p;
> +}
> +EXPORT_SYMBOL(ioremap_cache_trace);
> +
> +void __iomem *ioremap_nocache_trace(unsigned long offset, unsigned
> long size) +{
> +	void __iomem *p = ioremap_nocache(offset, size);
> +	printk(KERN_DEBUG MODULE_NAME ": ioremap_nocache(0x%lx,
> 0x%lx) = %p\n",
> +							offset,
> size, p);
> +	ioremap_trace_core(offset, size, p);
> +	return p;
> +}
> +EXPORT_SYMBOL(ioremap_nocache_trace);

I would rather keep the split I think and make the trace call explicit

or.. even nicer, we could go fancy and allow the mmio tracer to "subscribe"
to, say, a PCI bar, and auto-enable tracing when the bar gets ioremap'd



about the isntruction decoding.. would be nice if we can share that with kvm
so that we can debug that stuff once ;-)


other than that I think the code is quite nice already, seems getting this merge
ready isn't going to be an enormous deal in terms of complexity
