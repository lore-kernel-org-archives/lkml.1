Return-Path: <linux-kernel-owner+w=401wt.eu-S965850AbXCPS7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965850AbXCPS7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 14:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965871AbXCPS7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 14:59:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34482 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965850AbXCPS7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 14:59:39 -0400
Date: Fri, 16 Mar 2007 18:59:23 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 00/26] Xen-paravirt_ops: Xen guest implementation for paravirt_ops interface
Message-ID: <20070316185923.GA15209@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
	Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
	xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
	Zachary Amsden <zach@vmware.com>,
	Rusty Russell <rusty@rustcorp.com.au>
References: <20070301232443.195603797@goop.org> <20070316092137.GL23174@elte.hu> <45FAD35F.8040404@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45FAD35F.8040404@goop.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2007 at 10:26:55AM -0700, Jeremy Fitzhardinge wrote:
> +#ifdef CONFIG_HIGHPTE
> +	.kmap_atomic_pte = native_kmap_atomic_pte,
> +#else
> +	.kmap_atomic_pte = paravirt_nop,
> +#endif

This is ifdefing is quite ugly.  Shouldn't native_kmap_atomic_pte
just be a noop in the !CONFIG_HIGHPTE case?

> -void *kmap_atomic(struct page *page, enum km_type type)
> +void *_kmap_atomic(struct page *page, enum km_type type, pgprot_t prot)

We normally call our "secial" function __foo, not _foo.  But in this
case it really should have a more meaningfull name like
kmap_atomic_prot anyway.

> +void *kmap_atomic(struct page *page, enum km_type type)
> +{
> +	return _kmap_atomic(page, type, kmap_prot);

And this one should probably be an inline.

> +static inline void *native_kmap_atomic_pte(struct page *page, enum km_type type)
> +{
> +	return kmap_atomic(page, type);
> +}
> +
> +#ifndef CONFIG_PARAVIRT
> +#define kmap_atomic_pte(page, type)	kmap_atomic(page, type)
> +#endif

This is all getting rather ugly just for your pagetable hackery.

