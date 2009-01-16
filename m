Return-Path: <linux-kernel-owner+w=401wt.eu-S1763087AbZAPGIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763087AbZAPGIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 01:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbZAPGIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 01:08:38 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:57031 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbZAPGIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 01:08:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OvmR0ncQ6hjB42DG7KeUIVOEx/CNjGJ/HyI9awEKnhuheaMEm+kw4NEti/PLCfys3w
         7NwbM5sPZPuSthWJvvKUzgWQSp+vIthANTBAUhuEnXa79ooyeif7KLU71d4wvkw6SG5/
         PYMs9DObVoeDO387ZwGK/94pNmiHJ+/Lp/o1A=
Date: Fri, 16 Jan 2009 15:08:30 +0900
From: MinChan Kim <minchan.kim@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, npiggin@suse.de,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Remove needless flush_dcache_page call
Message-ID: <20090116060830.GB6515@barrios-desktop>
References: <20090116052804.GA18737@barrios-desktop> <20090116053338.GC31013@parisc-linux.org> <20090116055119.GA6515@barrios-desktop> <20090116055729.GF31013@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090116055729.GF31013@parisc-linux.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 10:57:30PM -0700, Matthew Wilcox wrote:
> On Fri, Jan 16, 2009 at 02:51:19PM +0900, MinChan Kim wrote:
> > On Thu, Jan 15, 2009 at 10:33:38PM -0700, Matthew Wilcox wrote:
> > > Sorry, no.  You have to call fluch_dcache_page() in two situations --
> > > when the kernel is going to read some data that userspace wrote, *and*
> > > when userspace is going to read some data that the kernel wrote.  From a
> > > quick look at the patch, this seems to be the second case.  The kernel
> > > wrote data to a pagecache page, and userspace should be able to read it.
> > > 
> > > To understand why this is necessary, consider a processor which is
> > > virtually indexed and has a writeback cache.  The kernel writes to a
> > > page, then a user process reads from the same page through a different
> > > address.  The cache doesn't find the data the kernel wrote because it
> > > has a different virtual index, so userspace reads stale data.
> > 
> > I see. :)
> > 
> > Thanks for quick reponse and good explaination.
> > Hmm,.. one more question. 
> > 
> > I can't find flush_dcache_page call in mpage_readpage which is 
> > generic read function. In case of ext fs, it use mpage_readpage 
> > with readpage.
> > 
> > who and where call flush_dcache_page in mpage_readpage call path?
> 
> Most I/O devices will do DMA to the page in question and thus the kernel
> hasn't written to it and the CPU won't have the data in cache.  For the
> few devices which can't do DMA, it's the responsibility of the device
> driver to call flush_dcache_page() (or some other flushing primitive).

Hmm.. Now I am confusing. 
If devicer driver or with DMA makes sure cache consistency,
Why filesystem code have to handle it ?

> See the gdth driver for an example:
> 
>             address = kmap_atomic(sg_page(sl), KM_BIO_SRC_IRQ) + sl->offset;
>             memcpy(address, buffer, cpnow);
>             flush_dcache_page(sg_page(sl));
>             kunmap_atomic(address, KM_BIO_SRC_IRQ);
> 
> -- 
> Matthew Wilcox				Intel Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."

--
Kinds regards,
MinChan Kim

