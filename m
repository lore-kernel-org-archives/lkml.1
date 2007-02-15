Return-Path: <linux-kernel-owner+w=401wt.eu-S932219AbXBOF01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbXBOF01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 00:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932221AbXBOF01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 00:26:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:38803 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219AbXBOF00 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 00:26:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,173,1170662400"; 
   d="scan'208"; a="46696573:sNHT28753803"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] aio: fix kernel bug when page is temporally busy
Date: Thu, 15 Feb 2007 08:26:05 +0300
Message-ID: <B41635854730A14CA71C92B36EC22AAC83A715@mssmsx411>
In-Reply-To: <20070214193051.4b008d61.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] aio: fix kernel bug when page is temporally busy
Thread-Index: AcdQseVn7HFoadpiSjiHzR3MKAaoswABQ+Wg
From: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 15 Feb 2007 05:26:22.0554 (UTC) FILETIME=[D4635BA0:01C750C1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Please, tell us what problem this is fixing so that we can look into
> alternative solutions.
This patch fixes a kernel panic "Kernel BUG at fs/aio.c:509"
http://marc.theaimsgroup.com/?l=linux-kernel&m=117031052517746&w=2
First of all it was found that the kernel panic happens after
IO error reporting. But later it was found that the actual
reason is not in real IO error but in a busy page.
EIO is returned if page has unstable state while IO completion
result is processing.
If aio_run_iocb() as well as in do_sync_read/write() get EIO result
it is considered as IO is finished and IO control block
could be free; result is reported to caller.
I suppose that aio_run_iocb() as well as in do_sync_read/write()
should have a chance to differ real EIO and EIO which is actually
means EAGAYN. That functions test for EIOCBRETRY meaning EAGAYN purpose.
do_sync_read/write() retries IO as well as aio:
        for (;;) {
                ret = filp->f_op->aio_read(&kiocb, &iov, 1,
kiocb.ki_pos);
                if (ret != -EIOCBRETRY)
                        break;
                wait_on_retry_sync_kiocb(&kiocb);
        }
By the way EIOCBRETRY is never actually set in the kernel. So what is
the
purpose of previous lines?

More details about EIO returning:
aio_complete: res=-5 iocb=ffff81002b38f080 ki_users=2 
[<ffffffff802573c3>] invalidate_inode_pages2_range+0x236/0x26b
[<ffffffff802af77b>] ext3_direct_IO+0x16c/0x19e
[<ffffffff802adc1d>] ext3_get_block+0x0/0xe2
[<ffffffff802518c0>] generic_file_direct_IO+0xb9/0xcf
[<ffffffff8025193d>] generic_file_direct_write+0x67/0x10e
[<ffffffff80252308>] __generic_file_aio_write_nolock+0x2d6/0x3fe
[<ffffffff802082c0>] __switch_to+0x26f/0x27e
[<ffffffff8047b8e9>] thread_return+0x0/0xd8
[<ffffffff80252497>] generic_file_aio_write+0x67/0xc7
[<ffffffff802ab2cc>] ext3_file_write+0x0/0x8f
[<ffffffff802ab2e2>] ext3_file_write+0x16/0x8f
[<ffffffff802ab2cc>] ext3_file_write+0x0/0x8f
[<ffffffff80283f61>] aio_rw_vect_retry+0x72/0x14f
[<ffffffff80284ad9>] aio_run_iocb+0xe6/0x187
[<ffffffff802853e2>] io_submit_one+0x296/0x2e3
[<ffffffff80285979>] sys_io_submit+0x9b/0x108
[<ffffffff80229b49>] default_wake_function+0x0/0xe
[<ffffffff8020983e>] system_call+0x7e/0x83
Call Trace:
<IRQ> [<ffffffff802848c3>] aio_complete+0x5c/0x18c
[<ffffffff80290f1a>] finished_one_bio+0xac/0xf3
[<ffffffff80290ff6>] dio_bio_complete+0x95/0xaa
[<ffffffff80291131>] dio_bio_end_aio+0x20/0x25
[<ffffffff80306fb7>] __end_that_request_first+0x10e/0x3fd
[<ffffffff803b0798>] scsi_end_request+0x27/0xc9
[<ffffffff803b092a>] scsi_io_completion+0xf0/0x2c5
[<ffffffff803d0407>] ahd_done+0x537/0x580
[<ffffffff803d40f2>] sd_rw_intr+0x182/0x1ad
[<ffffffff80308db7>] blk_done_softirq+0x5c/0x6a
[<ffffffff80234d56>] __do_softirq+0x55/0xc3
[<ffffffff80219ebc>] ack_apic_level+0x37/0x4b
[<ffffffff8020a96c>] call_softirq+0x1c/0x28
[<ffffffff8020c5bf>] do_softirq+0x2c/0x7d
[<ffffffff8020c6b8>] do_IRQ+0xa8/0xc8
[<ffffffff80208031>] mwait_idle+0x0/0x20
[<ffffffff80209d61>] ret_from_intr+0x0/0xa
<EOI> [<ffffffff80208030>] mwait_idle_with_hints+0x44/0x45
[<ffffffff8020803d>] mwait_idle+0xc/0x20
[<ffffffff80208bc3>] cpu_idle+0x8b/0xb0
[<ffffffff802178e3>] start_secondary+0x462/0x471


-----Original Message-----
From: Andrew Morton [mailto:akpm@linux-foundation.org] 
Sent: Thursday, February 15, 2007 6:31 AM
To: Ananiev, Leonid I
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aio: fix kernel bug when page is temporally busy

On Wed, 14 Feb 2007 20:51:33 +0300 "Ananiev, Leonid I"
<leonid.i.ananiev@intel.com> wrote:

> Fix kernel bug when IO page is temporally busy:
> invalidate_inode_pages2_range() returns EIOCBRETRY but not  EIO.
> invalidate_inode_pages2() returns EIO as earlier.
> 
> Signed-off-by: Leonid Ananiev <leonid.i.ananiev@intel.com>
> ---
> --- linux-2.6.20/mm/truncate.c  2007-02-04 10:44:54.000000000 -0800
> +++ linux-2.6.20p/mm/truncate.c 2007-02-08 22:56:52.000000000 -0800
> @@ -366,7 +366,7 @@ static int do_launder_page(struct addres
>   * Any pages which are found to be mapped into pagetables are
unmapped prior to
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
!invalidate_complete_page2(mapping, page))
> -                               ret = -EIO;
> +                               ret = -EIOCBRETRY;
>                         unlock_page(page);
>                 }
>                 pagevec_release(&pvec);
> @@ -444,6 +444,7 @@ EXPORT_SYMBOL_GPL(invalidate_inode_pages
>   */
>  int invalidate_inode_pages2(struct address_space *mapping)
>  {
> -       return invalidate_inode_pages2_range(mapping, 0, -1);
> +       int ret =  invalidate_inode_pages2_range(mapping, 0, -1);
> +       return (ret < 0)?-EIO:ret;
>  }
>  EXPORT_SYMBOL_GPL(invalidate_inode_pages2);

If someone later uses invalidate_inode_pages2_range() elsewhere, they're
going to need to know to convert -EIOCBRETRY into -EIO, if they weren't
called by aio.  Or something.

Please, tell us what problem this is fixing so that we can look into
alternative solutions.

For example, one acceptable-but-ugly solution might be to do:

static inline int invalidate_inode_pages2_range(struct address_space
*mapping,
				pgoff_t start, pgoff_t end)
{
	return __invalidate_inode_pages2_range(mapping, start, end, 0);
}

static inline int invalidate_inode_pages2_range_for_aio(struct
address_space *mapping,
				pgoff_t start, pgoff_t end)
{
	return __invalidate_inode_pages2_range(mapping, start, end, 1);
}

and to then use invalidate_inode_pages2_range_for_aio() from the
appropriate callsite.

But without a complete description of the bug which this is fixing, it's
hard to say how practical such an approach would be.
