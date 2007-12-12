Return-Path: <linux-kernel-owner+w=401wt.eu-S1759150AbXLLTKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150AbXLLTKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759834AbXLLTJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:09:49 -0500
Received: from ccerelbas03.cce.hp.com ([161.114.21.106]:55841 "EHLO
	ccerelbas03.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759832AbXLLTJr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:09:47 -0500
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
Date: Wed, 12 Dec 2007 19:06:29 +0000
Subject: RE: [PATCH 21/30] blk_end_request: changing cciss (take 4)
Thread-Topic: [PATCH 21/30] blk_end_request: changing cciss (take 4)
Thread-Index: Acg8SCzQBUxdBTDwQ8+JlcyjUndtcAAqclVQ
Message-ID: <DEE40752C8AF224BB890E455C7B8E0FE15718F11@G6W0268.americas.hpqcorp.net>
References: <20071211.175003.10249786.k-ueda@ct.jp.nec.com>
In-Reply-To: <20071211.175003.10249786.k-ueda@ct.jp.nec.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Kiyoshi Ueda [mailto:k-ueda@ct.jp.nec.com]
> Sent: Tuesday, December 11, 2007 4:50 PM
> To: jens.axboe@oracle.com
> Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org;
> linux-ide@vger.kernel.org; dm-devel@redhat.com;
> j-nomura@ce.jp.nec.com; k-ueda@ct.jp.nec.com; Miller, Mike (OS Dev)
> Subject: [PATCH 21/30] blk_end_request: changing cciss (take 4)
>
> This patch converts cciss to use blk_end_request interfaces.
> Related 'uptodate' arguments are converted to 'error'.
>
> cciss is a little bit different from "normal" drivers.
> cciss directly calls bio_endio() and disk_stat_add() when
> completing request.  But those can be replaced with
> __end_that_request_first().
> After the replacement, request completion procedures of those
> drivers become like the following:
>     o end_that_request_first()
>     o add_disk_randomness()
>     o end_that_request_last()
> This can be converted to blk_end_request() by following the
> rule (a) mentioned in the patch subject "[PATCH 01/30]
> blk_end_request: add new request completion interface".
>
> Cc: Mike Miller <mike.miller@hp.com>
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

Acked-by: Mike Miller <mike.miller@hp.com>

> ---
>  drivers/block/cciss.c |   25 +++----------------------
>  1 files changed, 3 insertions(+), 22 deletions(-)
>
> Index: 2.6.24-rc4/drivers/block/cciss.c
> ===================================================================
> --- 2.6.24-rc4.orig/drivers/block/cciss.c
> +++ 2.6.24-rc4/drivers/block/cciss.c
> @@ -1187,17 +1187,6 @@ static int cciss_ioctl(struct inode *ino
>         }
>  }
>
> -static inline void complete_buffers(struct bio *bio, int status) -{
> -       while (bio) {
> -               struct bio *xbh = bio->bi_next;
> -
> -               bio->bi_next = NULL;
> -               bio_endio(bio, status ? 0 : -EIO);
> -               bio = xbh;
> -       }
> -}
> -
>  static void cciss_check_queues(ctlr_info_t *h)  {
>         int start_queue = h->next_to_run; @@ -1263,21
> +1252,14 @@ static void cciss_softirq_done(struct re
>                 pci_unmap_page(h->pdev, temp64.val,
> cmd->SG[i].Len, ddir);
>         }
>
> -       complete_buffers(rq->bio, (rq->errors == 0));
> -
> -       if (blk_fs_request(rq)) {
> -               const int rw = rq_data_dir(rq);
> -
> -               disk_stat_add(rq->rq_disk, sectors[rw],
> rq->nr_sectors);
> -       }
> -
>  #ifdef CCISS_DEBUG
>         printk("Done with %p\n", rq);
>  #endif                         /* CCISS_DEBUG */
>
> -       add_disk_randomness(rq->rq_disk);
> +       if (blk_end_request(rq, (rq->errors == 0) ? 0 : -EIO,
> blk_rq_bytes(rq)))
> +               BUG();
> +
>         spin_lock_irqsave(&h->lock, flags);
> -       end_that_request_last(rq, (rq->errors == 0));
>         cmd_free(h, cmd, 1);
>         cciss_check_queues(h);
>         spin_unlock_irqrestore(&h->lock, flags); @@ -2544,7
> +2526,6 @@ after_error_processing:
>         }
>         cmd->rq->data_len = 0;
>         cmd->rq->completion_data = cmd;
> -       blk_add_trace_rq(cmd->rq->q, cmd->rq, BLK_TA_COMPLETE);
>         blk_complete_request(cmd->rq);
>  }
>
>
