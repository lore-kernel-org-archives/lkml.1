Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbZCGQsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbZCGQsN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 11:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333AbZCGQr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 11:47:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:44944 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265AbZCGQr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 11:47:56 -0500
Date: Sat, 7 Mar 2009 08:48:05 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, adobriyan@gmail.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -v2] memdup_user(): introduce
Message-ID: <20090307084805.7cf3d574@infradead.org>
In-Reply-To: <20090306150335.c512c1b6.akpm@linux-foundation.org>
References: <49B0CAEC.80801@cn.fujitsu.com>
	<20090306082056.GB3450@x200.localdomain>
	<49B0DE89.9000401@cn.fujitsu.com>
	<20090306003900.a031a914.akpm@linux-foundation.org>
	<49B0E67C.2090404@cn.fujitsu.com>
	<20090306011548.ffdf9cbc.akpm@linux-foundation.org>
	<49B0F1B9.1080903@cn.fujitsu.com>
	<20090306150335.c512c1b6.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Mar 2009 15:03:35 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> >  
> >  /**
> > + * memdup_user - duplicate memory region from user space
> > + *
> > + * @src: source address in user space
> > + * @len: number of bytes to copy
> > + * @gfp: GFP mask to use
> > + *
> > + * Returns an ERR_PTR() on failure.
> > + */
> > +void *memdup_user(const void __user *src, size_t len, gfp_t gfp)
> > +{
> > +	void *p;
> > +
> > +	p = kmalloc_track_caller(len, gfp);
> > +	if (!p)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	if (copy_from_user(p, src, len)) {
> > +		kfree(p);
> > +		return ERR_PTR(-EFAULT);
> > +	}
> > +
> > +	return p;
> > +}
> > +EXPORT_SYMBOL(memdup_user);

Hi,

I like the general idea of this a lot; it will make things much less
error prone (and we can add some sanity checks on "len" to catch the
standard security holes around copy_from_user usage). I'd even also
want a memdup_array() like thing in the style of calloc().

However, I have two questions/suggestions for improvement:

I would like to question the use of the gfp argument here;
copy_from_user sleeps, so you can't use GFP_ATOMIC anyway.
You can't use GFP_NOFS etc, because the pagefault path will happily do
things that are equivalent, if not identical, to GFP_KERNEL.

So the only value you can pass in correctly, as far as I can see, is
GFP_KERNEL. Am I wrong?

A second thing.. I'd like to have this function return NULL on failure;
error checking a pointer for NULL is so much easier than testing for
anything else; the only distinction is -ENOMEM versus -EFAULT, and I'm
not sure that that is worth the complexity on all callers.





-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
