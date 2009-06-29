Return-Path: <linux-kernel-owner+w=401wt.eu-S1760975AbZF2QLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760975AbZF2QLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759961AbZF2QLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:11:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:19356 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243AbZF2QLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:11:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AqJhxJ1+4e7Ofrsu0WWw23ShYNCGs/xjmtpEFr+RGZdRbAGXtDg3qJqwJChy69RO70
         jmx4tmH3I1JguKeIbMbsbRQLFhbXjoR/3R2wib5etOiqKL5vNxLE6QN8YUE4mFTaFqbD
         WOeD+cq8FaXAbp9zdZqm8GjJD7s+8ZM6j3Iho=
Subject: Re: [PATCH]highmem_32.c: add argument pointer checking
From: "Figo.zhang" <figo1802@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <20090629040954.GA13117@elte.hu>
References: <1246244906.5759.5.camel@myhost>
	 <20090629040954.GA13117@elte.hu>
Content-Type: text/plain
Date: Tue, 30 Jun 2009 00:11:03 +0800
Message-Id: <1246291864.2500.19.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-29 at 06:09 +0200, Ingo Molnar wrote:
> * Figo.zhang <figo1802@gmail.com> wrote:
> 
> > It had better add argument pointer checking.
> > 
> > If any guys write driver want to alloc hightmem and pass a no-initial pointer,
> > it would be crashed.
> > 
> > Signed-off-by: Figo.zhang <figo1802@gmail.com>
> > ---  
> > arch/x86/mm/highmem_32.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
> > index 58f621e..e52e1a9 100644
> > --- a/arch/x86/mm/highmem_32.c
> > +++ b/arch/x86/mm/highmem_32.c
> > @@ -31,6 +31,7 @@ void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
> >  {
> >  	enum fixed_addresses idx;
> >  	unsigned long vaddr;
> > +	BUG_ON(!page);
> >  
> >  	/* even !CONFIG_PREEMPT needs this, for in_atomic in do_page_fault */
> >  	pagefault_disable();
> > @@ -58,6 +59,9 @@ void kunmap_atomic(void *kvaddr, enum km_type type)
> >  	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
> >  	enum fixed_addresses idx = type + KM_TYPE_NR*smp_processor_id();
> >  
> > +	if(!kvaddr)
> > +		return;
> > +
> 
> (Please run patches through scripts/checkpatch.pl before 
> submission.)
> 
> Also, what's the improvement here? Before the patch we'd crash on a 
> NULL dereference ... after the patch we'd crash on a BUG_ON().

why it would be crash on BUG_ON()?
I motify it and test on my computer, it would not crash.

Best Regards,
Figo.zhang

> 
> Furthermore, he kunmap_atomic() change is outright wrong - it will 
> now allow NULL kunmaps, which can hide bugs in drivers.
> 
> 	Ingo

