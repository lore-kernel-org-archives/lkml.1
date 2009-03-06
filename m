Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbZCFD2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbZCFD2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 22:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZCFD2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 22:28:23 -0500
Received: from rv-out-0506.google.com ([209.85.198.236]:13805 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbZCFD2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 22:28:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BiQCzOBcPivkYrcOY9eWcoRetGCZHsYOBJD+mngahJv2fR7dwVqv4tRF2Qq/RJfo2K
         9ueBk++aHgucmuo/2u9I+oskAHaL/01+yMWtvGIoCCJ1fYU/hAsz+iqJEBvTKbYydBM9
         gQ8oGpfildH5bppEjh8jAcCYA/0dY6FL6UNq8=
Date: Fri, 6 Mar 2009 12:28:14 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-mm@kvack.org, mingo@elte.hu, jirislaby@gmail.com,
       rmk+lkml@arm.linux.org.uk
Subject: Re: [PATCH] generic debug pagealloc (-v2)
Message-ID: <20090306032814.GA9874@localhost.localdomain>
References: <20090305145926.GA27015@localhost.localdomain> <20090305143150.136e2708.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305143150.136e2708.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 02:31:50PM -0800, Andrew Morton wrote:
> > +#include <linux/kernel.h>
> > +#include <linux/mm.h>
> > +
> > +static void poison_page(struct page *page)
> > +{
> > +	void *addr;
> > +
> > +	if (PageHighMem(page))
> > +		return; /* i goofed */
> 
> heh.  A more complete comment would be needed here.
> 
> Also, as this is a kernel bug, perhaps some sort of runtime warning?

It just skips the poisoning for highmem pages.
Any page poisoning can be skipped safely if it doesn't set the page->poison
flag. So I'm going to put

/*
 * skipping the page poisoning for highmem pages
 */

> > +	page->poison = true;
> > +	addr = page_address(page);
> > +	memset(addr, PAGE_POISON, PAGE_SIZE);
> > +}

...

> > +static void unpoison_page(struct page *page)
> > +{
> > +	void *addr;
> > +
> 
> Shouldn't we check PageHighmem() here also?

It should not happen because page->poison flag is not set for highmem pages.
But it's good for sanity checking. So I'll have a BUG_ON here.

> > +	if (!page->poison)
> > +		return;
> > +

	BUG_ON(PageHighMem(page));

> > +	addr = page_address(page);
> > +	check_poison_mem(addr, PAGE_SIZE);
> > +	page->poison = false;
> > +}
