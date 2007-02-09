Return-Path: <linux-kernel-owner+w=401wt.eu-S1946161AbXBIHKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946161AbXBIHKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 02:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946162AbXBIHKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 02:10:42 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58976 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946161AbXBIHKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 02:10:41 -0500
Date: Fri, 9 Feb 2007 12:46:00 +0530
From: Suparna Bhattacharya <suparna@in.ibm.com>
To: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "linux-aio" <linux-aio@kvack.org>,
       "Zach Brown" <zach.brown@oracle.com>,
       "Chris Mason" <chris.mason@oracle.com>,
       "Badari Pulavarty" <pbadari@us.ibm.com>
Subject: Re: [PATCH] aio: fix kernel bug when page is  temporally busy
Message-ID: <20070209071600.GA21276@in.ibm.com>
Reply-To: suparna@in.ibm.com
References: <20070208203507.347cff98.akpm@linux-foundation.org> <B41635854730A14CA71C92B36EC22AAC8048E2@mssmsx411>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B41635854730A14CA71C92B36EC22AAC8048E2@mssmsx411>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09, 2007 at 08:41:41AM +0300, Ananiev, Leonid I wrote:
> > invalidate_inode_pages2() has other callers.  I suspect with this
> change
> > we'll end up leaking EIOCBRETRY back to userspace.
>  
> EIOCBRETRY is used and caught already in do_sync_read() and
> do_sync_readv_writev().
>  
> Below fixed patch against kernel 2.6.20.

I agree with Andrew, this doesn't look like the right solution.

EIOCBRETRY isn't the same as EAGAIN or "try again later". EIOCBRETRY means
"I have queued up an action to notify (wakeup) the callback to retry the
operation once data is ready".

Regards
Suparna

>  
> >From Leonid Ananiev
>  
> Fix kernel bug when IO page is temporally busy:
> invalidate_inode_pages2() returns EIOCBRETRY but not  EIO..
>  
> Signed-off-by: Leonid Ananiev <leonid.i.ananiev@intel.com>
> ---
> --- linux-2.6.20/mm/truncate.c	2007-02-04 10:44:54.000000000 -0800
> +++ linux-2.6.20p/mm/truncate.c	2007-02-08 11:38:11.000000000 -0800
> @@ -366,7 +366,7 @@ static int do_launder_page(struct addres
>   * Any pages which are found to be mapped into pagetables are unmapped
> prior to
>   * invalidation.
>   *
> - * Returns -EIO if any pages could not be invalidated.
> + * Returns -EIOCBRETRY if any pages could not be invalidated.
>   */
>  int invalidate_inode_pages2_range(struct address_space *mapping,
>  				  pgoff_t start, pgoff_t end)
> @@ -423,7 +423,7 @@ int invalidate_inode_pages2_range(struct
>  			}
>  			ret = do_launder_page(mapping, page);
>  			if (ret == 0 &&
> !invalidate_complete_page2(mapping, page))
> -				ret = -EIO;
> +				ret = -EIOCBRETRY;
>  			unlock_page(page);
>  		}
>  		pagevec_release(&pvec);
> @@ -440,7 +440,7 @@ EXPORT_SYMBOL_GPL(invalidate_inode_pages
>   * Any pages which are found to be mapped into pagetables are unmapped
> prior to
>   * invalidation.
>   *
> - * Returns -EIO if any pages could not be invalidated.
> + * Returns -EIOCBRETRY if any pages could not be invalidated.
>   */
>  int invalidate_inode_pages2(struct address_space *mapping)
>  {
>  
> --
> To unsubscribe, send a message with 'unsubscribe linux-aio' in
> the body to majordomo@kvack.org.  For more info on Linux AIO,
> see: http://www.kvack.org/aio/
> Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>

-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India

