Return-Path: <linux-kernel-owner+w=401wt.eu-S1762753AbZDBP6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762753AbZDBP6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbZDBP6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 11:58:30 -0400
Received: from h155.mvista.com ([63.81.120.155]:9556 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753417AbZDBP63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 11:58:29 -0400
Message-ID: <49D4E0C3.7080808@ru.mvista.com>
Date: Thu, 02 Apr 2009 19:58:59 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       jgarzik@redhat.com, David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [PATCH 4/5] ide: Add support for TRIM
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <1238683047-13588-2-git-send-email-willy@linux.intel.com> <1238683047-13588-3-git-send-email-willy@linux.intel.com> <1238683047-13588-4-git-send-email-willy@linux.intel.com>
In-Reply-To: <1238683047-13588-4-git-send-email-willy@linux.intel.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Matthew Wilcox wrote:

> From: David Woodhouse <David.Woodhouse@intel.com>

> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> [modified to reduce amount of special casing needed for discard]
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>



> diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
> index c998cf8..ed34bd3 100644
> --- a/drivers/ide/ide-disk.c
> +++ b/drivers/ide/ide-disk.c
> @@ -404,6 +404,52 @@ static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
>  	rq->special = cmd;
>  }
>  
> +static int idedisk_prepare_discard(struct request_queue *q, struct request *rq,
> +							struct bio *bio)

    Weird indentation.

> +{
> +	ide_task_t *task;

    This patch is already obsolete as 'ide_task_t' is gone. Use 'struct 
ide_cmd' instead.

> +	unsigned size;
> +	struct page *page = alloc_page(GFP_KERNEL);

    Missing empty line after the declaration block...

> +	if (!page)
> +		goto error;

    Unneeded goto -- why not just return?

> +
> +	/* FIXME: map struct ide_taskfile on rq->cmd[] */
> +	task = kzalloc(sizeof(*task), GFP_KERNEL);
> +	if (!task)
> +		goto free_page;
> +
> +	size = ata_set_lba_range_entries(page_address(page), PAGE_SIZE,
> +					bio->bi_sector, bio_sectors(bio));
> +	bio->bi_size = 0;
> +	if (bio_add_pc_page(q, bio, page, size, 0) < size)
> +		goto free_task;
> +
> +	task->tf.command = ATA_CMD_DSM;
> +	task->tf.feature = ATA_DSM_TRIM;
> +	task->tf.hob_feature = 0x00;
> +	task->tf.nsect = size / 512;
> +	task->tf.hob_nsect = (size / 512) >> 8;
> +
> +	task->tf_flags   = IDE_TFLAG_LBA48 | IDE_TFLAG_OUT_HOB |
> +			   IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE |

    The last 3 flags are going to be obsoleted too...

MBR, Sergei
