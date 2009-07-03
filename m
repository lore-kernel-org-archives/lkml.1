Return-Path: <linux-kernel-owner+w=401wt.eu-S1756453AbZGCBu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbZGCBu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 21:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbZGCBuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 21:50:17 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:51419 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbZGCBuQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 21:50:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mCEuROSn9aU7SGUj4/nD5UN/LdGaQYrvF0b8j9knRzCfv0iFjYbMPOslNhccriNhY5
         /g8dEAnwiwnR+Iq+DTiD+C9V65MZZTw7oxIZwv1fWS5t8H9zT4y0n3CU6e+xjIHteoGi
         66M/Xs/F9Rklel+n/XywJIyEUl2FUb9rqdBXI=
MIME-Version: 1.0
In-Reply-To: <200906282015.00854.bzolnier@gmail.com>
References: <200906282015.00854.bzolnier@gmail.com>
Date: Fri, 3 Jul 2009 10:50:19 +0900
Message-ID: <57afda040907021850w107d7734u962e4d86efb2b266@mail.gmail.com>
Subject: Re: [PATCH][RESEND] mg_disk: fix issue with data integrity on error 
	in mg_write()
From: unsik Kim <donari75@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/29 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] mg_disk: fix issue with data integrity on error in mg_write()
>
> We cannot acknowledge the sector write before checking its status
> (which is done on the next loop iteration) and we also need to do
> the final status register check after writing the last sector.

Right. Current mg_disk polling driver doesn't check status register
(should be ready status) after writing last sector. Thanks.


>  static void mg_write(struct request *req)
>  {
> -       u32 j;
>        struct mg_host *host = req->rq_disk->private_data;
> +       bool rem;
>
>        if (mg_out(host, blk_rq_pos(req), blk_rq_sectors(req),
>                   MG_CMD_WR, NULL) != MG_ERR_NONE) {
> @@ -512,27 +527,37 @@ static void mg_write(struct request *req
>        MG_DBG("requested %d sects (from %ld), buffer=0x%p\n",
>               blk_rq_sectors(req), blk_rq_pos(req), req->buffer);
>
> -       do {
> -               u16 *buff = (u16 *)req->buffer;
> +       if (mg_wait(host, ATA_DRQ,
> +                   MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
> +               mg_bad_rw_intr(host);
> +               return;
> +       }
> +
> +       mg_write_one(host, req);
> +
> +       outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base + MG_REG_COMMAND);
>
> -       if (mg_wait(host, ATA_DRQ, MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
> +       do {
> +               if (blk_rq_sectors(req) > 1 &&
> +                    mg_wait(host, ATA_DRQ,
> +                            MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
>                        mg_bad_rw_intr(host);
>                        return;
>                }
> -               for (j = 0; j < MG_SECTOR_SIZE >> 1; j++)
> -                       outw(*buff++, (unsigned long)host->dev_base +
> -                                     MG_BUFF_OFFSET + (j << 1));
>
> -               outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base +
> -                               MG_REG_COMMAND);
> -       } while (mg_end_request(host, 0, MG_SECTOR_SIZE));
> +               rem = mg_end_request(host, 0, MG_SECTOR_SIZE);
> +               if (rem)
> +                       mg_write_one(host, req);
> +
> +               outb(MG_CMD_WR_CONF,
> +                    (unsigned long)host->dev_base + MG_REG_COMMAND);
> +       } while (rem);
>  }

I think checking ready status after do-while loop is enough.

static void mg_write(struct request *req)
{
	u32 j;
	struct mg_host *host = req->rq_disk->private_data;

	if (mg_out(host, blk_rq_pos(req), blk_rq_sectors(req),
		   MG_CMD_WR, NULL) != MG_ERR_NONE) {
		mg_bad_rw_intr(host);
		return;
	}

	MG_DBG("requested %d sects (from %ld), buffer=0x%p\n",
	       blk_rq_sectors(req), blk_rq_pos(req), req->buffer);

	do {
		u16 *buff = (u16 *)req->buffer;

		if (mg_wait(host, ATA_DRQ, MG_TMAX_WAIT_WR_DRQ) !=
				MG_ERR_NONE) {
			mg_bad_rw_intr(host);
			return;
		}
		for (j = 0; j < MG_SECTOR_SIZE >> 1; j++)
			outw(*buff++, (unsigned long)host->dev_base +
				      MG_BUFF_OFFSET + (j << 1));

		outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base +
				MG_REG_COMMAND);
	} while (mg_end_request(host, 0, MG_SECTOR_SIZE));

+	if (mg_wait(host, MG_STAT_READY, MG_TMAX_WAIT_WR_DRQ) !=
+			MG_ERR_NONE)
+		mg_bad_rw_intr(host);
}

---
Regards,
unsik Kim <donari75@gmail.com>
