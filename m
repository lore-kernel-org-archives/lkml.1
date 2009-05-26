Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbZEZJWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbZEZJWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 05:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbZEZJV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 05:21:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50852 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbZEZJV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 05:21:56 -0400
Date: Tue, 26 May 2009 05:21:57 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, jdike@addtoit.com, mingo@elte.hu
Subject: Re: [Patch 2/4] x86 module: merge the rest functions with macros
Message-ID: <20090526092157.GA25759@infradead.org>
References: <20090526083717.5050.32719.sendpatchset@localhost.localdomain> <20090526083734.5050.25473.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526083734.5050.25473.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 04:35:22AM -0400, Amerigo Wang wrote:
> +#if defined(CONFIG_UML) || defined(CONFIG_X86_32)
> +void *module_alloc(unsigned long size)
> +{
> +	if (size == 0)
> +		return NULL;
> +	return vmalloc_exec(size);
> +}
> +#else /*X86_64*/
> +void *module_alloc(unsigned long size)
> +{
> +	struct vm_struct *area;
> +
> +	if (!size)
> +		return NULL;
> +	size = PAGE_ALIGN(size);
> +	if (size > MODULES_LEN)
> +		return NULL;
> +
> +	area = __get_vm_area(size, VM_ALLOC, MODULES_VADDR, MODULES_END);
> +	if (!area)
> +		return NULL;
> +
> +	return __vmalloc_area(area, GFP_KERNEL, PAGE_KERNEL_EXEC);
> +}
> +#endif

vmalloc_exec basically expands to the x86-64 version of that code, just
using VMALLOC_START/VMALLOC_END instead of MODULES_VADDR/MODULES_END.

So instead of having two variants it would be better to use the x86-64
unconditionally and define MODULES_VADDR/MODULES_END to
VMALLOC_START/VMALLOC_END to 32bit and uml.

And that part should be a patch of it's own, not mixed with others.

