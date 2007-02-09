Return-Path: <linux-kernel-owner+w=401wt.eu-S1946283AbXBIJwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946283AbXBIJwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 04:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946284AbXBIJwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 04:52:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:17549 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946283AbXBIJwf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 04:52:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,304,1167638400"; 
   d="scan'208"; a="44797616:sNHT25848513"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] aio: fix kernel bug when page is  temporally busy
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Fri, 9 Feb 2007 12:52:27 +0300
Message-ID: <B41635854730A14CA71C92B36EC22AAC804976@mssmsx411>
In-Reply-To: <20070209071600.GA21276@in.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] aio: fix kernel bug when page is  temporally busy
Thread-Index: AcdMGXvUapKqcOb2RfmbfhjKN6VqHgABAw2w
From: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
To: <suparna@in.ibm.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "linux-aio" <linux-aio@kvack.org>,
       "Zach Brown" <zach.brown@oracle.com>,
       "Chris Mason" <chris.mason@oracle.com>,
       "Badari Pulavarty" <pbadari@us.ibm.com>
X-OriginalArrivalTime: 09 Feb 2007 09:52:34.0791 (UTC) FILETIME=[061ACF70:01C74C30]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have used EIOCBRETRY in the patch to minimize source code modification
only.
It is notable that EIOCBRETRY is never set in kernel, but tested only.

EAGAIN - means that you may want to recall the same function with the
same argument. But user have not to recall it just now. He may want to
free or process some other his resources before recall for success.
EIOCBRETRY - means that you may not recall the same function with the
same argument because an argument has no sense already in cuurnt
context. The result is in processing already. You may want to recall
much higher level or external function to get the common result. It is
means that inernal caller should ignore or let through errno to its
caller but do not recall the function which has returned this errno.

A lot of errno's have different meaning in different functions or
contexts. EAGAIN could be used instated of EIOCBRETRY for irredundant
set.

Leonid

-----Original Message-----
From: Suparna Bhattacharya [mailto:suparna@in.ibm.com] 
Sent: Friday, February 09, 2007 10:16 AM
To: Ananiev, Leonid I
Cc: Andrew Morton; linux-kernel@vger.kernel.org; linux-aio; Zach Brown;
Chris Mason; Badari Pulavarty
Subject: Re: [PATCH] aio: fix kernel bug when page is temporally busy

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

EIOCBRETRY isn't the same as EAGAIN or "try again later". EIOCBRETRY
means
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
> --- linux-2.6.20/mm/truncate.c	2007-02-04 10:44:54.000000000
-0800
> +++ linux-2.6.20p/mm/truncate.c	2007-02-08 11:38:11.000000000
-0800
> @@ -366,7 +366,7 @@ static int do_launder_page(struct addres
>   * Any pages which are found to be mapped into pagetables are
unmapped
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
>   * Any pages which are found to be mapped into pagetables are
unmapped
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
