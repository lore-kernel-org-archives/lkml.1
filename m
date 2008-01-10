Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbYAJCGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbYAJCGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 21:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbYAJCGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 21:06:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:56782 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbYAJCGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 21:06:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,264,1196668800"; 
   d="scan'208";a="320117754"
Subject: Re: [PATCH -mm 1/2] kexec/i386: kexec page table code clean up -
	add arch_kimage
From: "Huang, Ying" <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080110011423.GB23143@redhat.com>
References: <1199847467.8126.15.camel@caritas-dev.intel.com>
	 <20080110011423.GB23143@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 10 Jan 2008 10:06:11 +0800
Message-Id: <1199930771.8752.4.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 10 Jan 2008 02:05:18.0607 (UTC) FILETIME=[3F9EE1F0:01C8532D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-09 at 20:14 -0500, Vivek Goyal wrote:
[...]
> >  
> > +static void alloc_page_tables(struct kimage *image)
> > +{
> 
> This is too generic a name. How about something like
> arch_alloc_kexec_page_tables()

OK, I will change it.

> > +	image->arch_kimage.pgd = (pgd_t *)get_zeroed_page(GFP_KERNEL);
> > +#ifdef CONFIG_X86_PAE
> > +	image->arch_kimage.pmd0 = (pmd_t *)get_zeroed_page(GFP_KERNEL);
> > +	image->arch_kimage.pmd1 = (pmd_t *)get_zeroed_page(GFP_KERNEL);
> > +#endif
> > +	image->arch_kimage.pte0 = (pte_t *)get_zeroed_page(GFP_KERNEL);
> > +	image->arch_kimage.pte1 = (pte_t *)get_zeroed_page(GFP_KERNEL);
> > +}
> > +
> > +static void free_page_tables(struct kimage *image)
> > +{
> 
> How about arch_free_kexec_page_tables()

OK, I will change it.

> > +	free_page((unsigned long)image->arch_kimage.pgd);
> > +#ifdef CONFIG_X86_PAE
> > +	free_page((unsigned long)image->arch_kimage.pmd0);
> > +	free_page((unsigned long)image->arch_kimage.pmd1);
> > +#endif
> > +	free_page((unsigned long)image->arch_kimage.pte0);
> > +	free_page((unsigned long)image->arch_kimage.pte1);
> > +}
> > +
> >  /*
> >   * A architecture hook called to validate the
> >   * proposed image and prepare the control pages
> > @@ -83,10 +97,21 @@ static void load_segments(void)
> >   * reboot code buffer to allow us to avoid allocations
> >   * later.
> >   *
> > - * Currently nothing.
> > + * - Allocate page tables
> >   */
> >  int machine_kexec_prepare(struct kimage *image)
> >  {
> > +	alloc_page_tables(image);
> > +	if (!image->arch_kimage.pgd ||
> > +#ifdef CONFIG_X86_PAE
> > +	    !image->arch_kimage.pmd0 ||
> > +	    !image->arch_kimage.pmd1 ||
> > +#endif
> > +	    !image->arch_kimage.pte0 ||
> > +	    !image->arch_kimage.pte1) {
> > +		free_page_tables(image);
> > +		return -ENOMEM;
> 
> I think this error handling can be done in alloc_page_tables() itself and
> following will look neater.

OK, I will change it.

Best Regards,
Huang Ying

