Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434Ab0AUBKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434Ab0AUBKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 20:10:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638Ab0AUBKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 20:10:10 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38922 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab0AUBKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 20:10:07 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: anfei <anfei.zhou@gmail.com>
Subject: Re: cache alias in mmap + write
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux@arm.linux.org.uk, jamie@shareable.org
In-Reply-To: <20100120095242.GA5672@desktop>
References: <20100120174630.4071.A69D9226@jp.fujitsu.com> <20100120095242.GA5672@desktop>
Message-Id: <20100121094733.3778.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 21 Jan 2010 10:10:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Jan 20, 2010 at 06:10:11PM +0900, KOSAKI Motohiro wrote:
> > Hello,
> > 
> > > diff --git a/mm/filemap.c b/mm/filemap.c
> > > index 96ac6b0..07056fb 100644
> > > --- a/mm/filemap.c
> > > +++ b/mm/filemap.c
> > > @@ -2196,6 +2196,9 @@ again:
> > >  		if (unlikely(status))
> > >  			break;
> > >  
> > > +		if (mapping_writably_mapped(mapping))
> > > +			flush_dcache_page(page);
> > > +
> > >  		pagefault_disable();
> > >  		copied = iov_iter_copy_from_user_atomic(page, i, offset, bytes);
> > >  		pagefault_enable();
> > 
> > I'm not sure ARM cache coherency model. but I guess correct patch is here.
> > 
> > +		if (mapping_writably_mapped(mapping))
> > +			flush_dcache_page(page);
> > +
> >  		pagefault_disable();
> >  		copied = iov_iter_copy_from_user_atomic(page, i, offset, bytes);
> >  		pagefault_enable();
> > -		flush_dcache_page(page);
> > 
> > Why do we need to call flush_dcache_page() twice?
> > 
> The latter flush_dcache_page is used to flush the kernel changes
> (iov_iter_copy_from_user_atomic), which makes the userspace to see the
> write,  and the one I added is used to flush the userspace changes.
> And I think it's better to split this function into two:
> 	flush_dcache_user_page(page);
> 	kmap_atomic(page);
> 	write to  page;
> 	kunmap_atomic(page);
> 	flush_dcache_kern_page(page);
> But currently there is no such API.

Why can't we create new api? this your pseudo code looks very fine to me.


note: if you don't like to create new api. I can agree your current patch.
but I have three requests.
 1. Move flush_dcache_page() into iov_iter_copy_from_user_atomic().
    Your above explanation indicate it is real intention. plus, change
    iov_iter_copy_from_user_atomic() fixes fuse too.
 2. Add some commnet. almost developer only have x86 machine. so, arm
    specific trick need additional explicit explanation. otherwise anybody
    might break this code in the future.
 3. Resend the patch. original mail isn't good patch format. please consider
    to reduce akpm suffer.



