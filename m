Return-Path: <linux-kernel-owner+w=401wt.eu-S1946092AbXBIEfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946092AbXBIEfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 23:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946097AbXBIEfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 23:35:30 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54701 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946092AbXBIEf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 23:35:28 -0500
Date: Thu, 8 Feb 2007 20:35:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
Cc: <linux-kernel@vger.kernel.org>, "linux-aio" <linux-aio@kvack.org>,
       "Zach Brown" <zach.brown@oracle.com>, <suparna@in.ibm.com>,
       "Chris Mason" <chris.mason@oracle.com>,
       "Badari Pulavarty" <pbadari@us.ibm.com>
Subject: Re: [PATCH] aio: fix kernel bug when page is  temporally busy
Message-Id: <20070208203507.347cff98.akpm@linux-foundation.org>
In-Reply-To: <B41635854730A14CA71C92B36EC22AAC8048C3@mssmsx411>
References: <B41635854730A14CA71C92B36EC22AAC8048C3@mssmsx411>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Feb 2007 07:29:31 +0300 "Ananiev, Leonid I" <leonid.i.ananiev@intel.com> wrote:

> >From Leonid Ananiev
> 
> Fix "Kernel BUG at fs/aio.c:509". Return EIOCBRETRY but not  EIO if page
> is busy.
> 
> Signed-off-by: Leonid Ananiev <leonid.i.ananiev@intel.com>
> 
> "Kernel BUG at fs/aio.c:509"
> http://marc.theaimsgroup.com/?l=linux-kernel&m=117031052517746&w=2 
> is present in 2.6.20 as well as 2.6.19.
> The investigation shows that the bug's panic occurs when aio_complete()
> is called with argument ret=EIO which is returned from
> invalidate_inode_pages2_range() because the page is temporally busy.
> Call Trace:
>  [<ffffffff802573c3>] invalidate_inode_pages2_range+0x236/0x26b
>  [<ffffffff802af77b>] ext3_direct_IO+0x16c/0x19e
>  [<ffffffff802adc1d>] ext3_get_block+0x0/0xe2
>  [<ffffffff802518c0>] generic_file_direct_IO+0xb9/0xcf
>  [<ffffffff8025193d>] generic_file_direct_write+0x67/0x10e
>  [<ffffffff80252308>] __generic_file_aio_write_nolock+0x2d6/0x3fe
>  [<ffffffff802082c0>] __switch_to+0x26f/0x27e
>  [<ffffffff8047b8e9>] thread_return+0x0/0xd8
>  [<ffffffff80252497>] generic_file_aio_write+0x67/0xc7
>  [<ffffffff802ab2cc>] ext3_file_write+0x0/0x8f
>  [<ffffffff802ab2e2>] ext3_file_write+0x16/0x8f
>  [<ffffffff802ab2cc>] ext3_file_write+0x0/0x8f
>  [<ffffffff80283f61>] aio_rw_vect_retry+0x72/0x14f
>  [<ffffffff80284ad9>] aio_run_iocb+0xe6/0x187
>  [<ffffffff802853e2>] io_submit_one+0x296/0x2e3
>  [<ffffffff80285979>] sys_io_submit+0x9b/0x108
>  [<ffffffff80229b49>] default_wake_function+0x0/0xe
>  [<ffffffff8020983e>] system_call+0x7e/0x83
> 
> As a result aio_complete() is called while it should not be.
> When IO is finished  aio_complete() is called once more
> and iocb->ki_users becomes negative.
> 
> Taking into account aio.c lines in aio_run_iocb()
>         if (ret != -EIOCBRETRY && ret != -EIOCBQUEUED) {
>                 aio_complete(iocb, ret, 0);
> 
> proposed patch makes function invalidate_inode_pages2_range()
> to return EIOCBRETRY but not  EIO if page is busy.
> The patch is tested on 2.6.20.
> 
> --- linux-2.6.20/mm/truncate.c  2007-02-04 10:44:54.000000000 -0800
> +++ linux-2.6.20p/mm/truncate.c 2007-02-08 11:38:11.000000000 -0800
> @@ -366,7 +366,7 @@ static int do_launder_page(struct addres
>   * Any pages which are found to be mapped into pagetables are unmapped
> prior to
>   * invalidation.
>   *
> - * Returns -EIO if any pages could not be invalidated.
> + * Returns -EIOCBRETRY if any pages could not be invalidated.
>   */
>  int invalidate_inode_pages2_range(struct address_space *mapping,
>                                   pgoff_t start, pgoff_t end)
> @@ -423,7 +423,7 @@ int invalidate_inode_pages2_range(struct
>                         }
>                         ret = do_launder_page(mapping, page);
>                         if (ret == 0 &&
> !invalidate_complete_page2(mapping, page))
> -                               ret = -EIO;
> +                               ret = -EIOCBRETRY;
>                         unlock_page(page);
>                 }
>                 pagevec_release(&pvec);
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

The patch is wildly wordwrapped and has had it tabs replaced with spaces.

invalidate_inode_pages2() has other callers.  I suspect with this change
we'll end up leaking EIOCBRETRY back to userspace.

