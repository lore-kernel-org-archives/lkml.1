Return-Path: <linux-kernel-owner+w=401wt.eu-S1161363AbXBHCLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161363AbXBHCLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 21:11:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161507AbXBHCLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 21:11:08 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50486 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161363AbXBHCLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 21:11:07 -0500
Date: Wed, 7 Feb 2007 18:11:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitriy Monakhov <dmonakhov@openvz.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: nobh_truncate_page question
Message-Id: <20070207181103.b24923f5.akpm@linux-foundation.org>
In-Reply-To: <87iredh9jd.fsf@sw.ru>
References: <87iredh9jd.fsf@sw.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Feb 2007 01:45:10 +0300
Dmitriy Monakhov <dmonakhov@openvz.org> wrote:

> Could some one please explain me what's happens with nobh_truncate_page?
> 
> int nobh_truncate_page(struct address_space *mapping, loff_t from)
> {
> ........
>  if ((offset & (blocksize - 1)) == 0)
>                 goto out;
> 
>         ret = -ENOMEM;
>         page = grab_cache_page(mapping, index);
>         if (!page)
>                 goto out;
> 
>         to = (offset + blocksize) & ~(blocksize - 1);
>         ret = a_ops->prepare_write(NULL, page, offset, to);
> <<<<< This prepare_write() not balanced by appropriate commit_write()
> <<<<< Currently this not is fatal because this function used only
> <<<<< by ext2 and jfs witch  unbalanced prepare/commit operations
> <<<<< not painful.  

See that comment at the top of nobh_truncate_page()?

>         if (ret == 0) {
>                 kaddr = kmap_atomic(page, KM_USER0);
>                 memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
>                 flush_dcache_page(page);
>                 kunmap_atomic(kaddr, KM_USER0);
>                 set_page_dirty(page);
>         }
>         unlock_page(page);
>         page_cache_release(page);
> out:
>         return ret;
> }
> 
> But we can't just call commit_write after all job done because this result in
> i_size increasing till block end. Where are two possible solutions:
> a) Call ->commit_write() and then restore i_size to old value.
> b) Leave code as it is now, but add warning comment about prepare/commit
>    balance violation.

It just happens that nobh_prepare_write() does all the things which
nobh_truncate_page() wants done.

If you need to change nobh_prepare_write(), you'll need to change
nobh_truncate_page().

Or something.  You haven't told us what you're trying to do.
