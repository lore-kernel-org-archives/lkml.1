Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbYHML6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbYHML6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 07:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbYHML6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 07:58:35 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:52106 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751565AbYHML6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 07:58:34 -0400
Date: Wed, 13 Aug 2008 13:58:21 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: David Woodhouse <dwmw2@infradead.org>
cc: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ric Wheeler <ricwheeler@gmail.com>, linux-fsdevel@vger.kernel.org,
       gilad@codefidence.com, matthew@wil.cx,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/7] Kill REQ_TYPE_FLUSH
In-Reply-To: <1218627594.2977.273.camel@pmac.infradead.org>
Message-ID: <Pine.LNX.4.64.0808131355170.27994@vixen.sonytel.be>
References: <1218299181.26926.88.camel@pmac.infradead.org>
 <1218627594.2977.273.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1749162943-1218628701=:27994"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1749162943-1218628701=:27994
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 13 Aug 2008, David Woodhouse wrote:
> It was only used by ps3disk, and it should probably have been
> REQ_TYPE_LINUX_BLOCK + REQ_LB_OP_FLUSH.

I used REQ_TYPE_FLUSH after discussing with the block experts.

Note that REQ_LB_OP_FLUSH is also never used. Actually its definition in
include/linux/blkdev.h has:

| enum {
| 	/*
| 	 * just examples for now
           ^^^^^^^^^^^^^^^^^^^^^
| 	 */
| 	REQ_LB_OP_EJECT	= 0x40,		/* eject request */
| 	REQ_LB_OP_FLUSH = 0x41,		/* flush device */
| };

which makes me a bit reluctant to make this change.

BTW, how to test all this flushing behavior, if there are no real users?

> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> ---
>  drivers/block/ps3disk.c |    9 ++++++---
>  include/linux/blkdev.h  |    1 -
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
> index d797e20..4b0d6c7 100644
> --- a/drivers/block/ps3disk.c
> +++ b/drivers/block/ps3disk.c
> @@ -199,7 +199,8 @@ static void ps3disk_do_request(struct ps3_storage_device *dev,
>  		if (blk_fs_request(req)) {
>  			if (ps3disk_submit_request_sg(dev, req))
>  				break;
> -		} else if (req->cmd_type == REQ_TYPE_FLUSH) {
> +		} else if (req->cmd_type == REQ_TYPE_LINUX_BLOCK &&
> +			   req->cmd[0] == REQ_LB_OP_FLUSH) {
>  			if (ps3disk_submit_flush_request(dev, req))
>  				break;
>  		} else {
> @@ -257,7 +258,8 @@ static irqreturn_t ps3disk_interrupt(int irq, void *data)
>  		return IRQ_HANDLED;
>  	}
>  
> -	if (req->cmd_type == REQ_TYPE_FLUSH) {
> +	if (req->cmd_type == REQ_TYPE_LINUX_BLOCK &&
> +	    req->cmd[0] == REQ_LB_OP_FLUSH) {
>  		read = 0;
>  		num_sectors = req->hard_cur_sectors;
>  		op = "flush";
> @@ -405,7 +407,8 @@ static void ps3disk_prepare_flush(struct request_queue *q, struct request *req)
>  
>  	dev_dbg(&dev->sbd.core, "%s:%u\n", __func__, __LINE__);
>  
> -	req->cmd_type = REQ_TYPE_FLUSH;
> +	req->cmd_type = REQ_TYPE_LINUX_BLOCK;
> +	req->cmd[0] = REQ_LB_OP_FLUSH;
>  }
>  
>  static unsigned long ps3disk_mask;
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 293a71a..a0fa413 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -54,7 +54,6 @@ enum rq_cmd_type_bits {
>  	REQ_TYPE_PM_SUSPEND,		/* suspend request */
>  	REQ_TYPE_PM_RESUME,		/* resume request */
>  	REQ_TYPE_PM_SHUTDOWN,		/* shutdown request */
> -	REQ_TYPE_FLUSH,			/* flush request */
>  	REQ_TYPE_SPECIAL,		/* driver defined type */
>  	REQ_TYPE_LINUX_BLOCK,		/* generic block layer message */
>  	/*

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis 293-0376800-10 GEBA-BE-BB
---584349381-1749162943-1218628701=:27994--
