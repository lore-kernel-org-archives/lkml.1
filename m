Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbZGCNKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbZGCNKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 09:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbZGCNKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 09:10:47 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:45459 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbZGCNKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 09:10:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=k2BUYaqywBo+pMPA5C2b6F7L+RM7N1/wrA08DelrGv+Xtn9rq3PBwm8m0TE5DOzwSm
         jIuaAFrO97TNVDhT+kndCiQuWQ44i9ydoFNinFQpl+K7KI4b0x5pTsLhKhGoJnJ3KNns
         BMKJgOH/vEs5HrrxpcC1Cz4mQeo1ogKs/qA8k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: unsik Kim <donari75@gmail.com>
Subject: Re: [PATCH][RESEND] mg_disk: fix issue with data integrity on error in mg_write()
Date: Fri, 3 Jul 2009 15:16:51 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc1-next-20090703-03460-gb01c1b8; KDE/4.2.4; i686; ; )
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
References: <200906282015.00854.bzolnier@gmail.com> <57afda040907021850w107d7734u962e4d86efb2b266@mail.gmail.com>
In-Reply-To: <57afda040907021850w107d7734u962e4d86efb2b266@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907031516.51893.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 July 2009 03:50:19 unsik Kim wrote:
> 2009/6/29 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] mg_disk: fix issue with data integrity on error in mg_write()
> >
> > We cannot acknowledge the sector write before checking its status
> > (which is done on the next loop iteration) and we also need to do
> > the final status register check after writing the last sector.
> 
> Right. Current mg_disk polling driver doesn't check status register
> (should be ready status) after writing last sector. Thanks.
> 
> 
> >  static void mg_write(struct request *req)
> >  {
> > -       u32 j;
> >        struct mg_host *host = req->rq_disk->private_data;
> > +       bool rem;
> >
> >        if (mg_out(host, blk_rq_pos(req), blk_rq_sectors(req),
> >                   MG_CMD_WR, NULL) != MG_ERR_NONE) {
> > @@ -512,27 +527,37 @@ static void mg_write(struct request *req
> >        MG_DBG("requested %d sects (from %ld), buffer=0x%p\n",
> >               blk_rq_sectors(req), blk_rq_pos(req), req->buffer);
> >
> > -       do {
> > -               u16 *buff = (u16 *)req->buffer;
> > +       if (mg_wait(host, ATA_DRQ,
> > +                   MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
> > +               mg_bad_rw_intr(host);
> > +               return;
> > +       }
> > +
> > +       mg_write_one(host, req);
> > +
> > +       outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base + MG_REG_COMMAND);
> >
> > -       if (mg_wait(host, ATA_DRQ, MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
> > +       do {
> > +               if (blk_rq_sectors(req) > 1 &&
> > +                    mg_wait(host, ATA_DRQ,
> > +                            MG_TMAX_WAIT_WR_DRQ) != MG_ERR_NONE) {
> >                        mg_bad_rw_intr(host);
> >                        return;
> >                }
> > -               for (j = 0; j < MG_SECTOR_SIZE >> 1; j++)
> > -                       outw(*buff++, (unsigned long)host->dev_base +
> > -                                     MG_BUFF_OFFSET + (j << 1));
> >
> > -               outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base +
> > -                               MG_REG_COMMAND);
> > -       } while (mg_end_request(host, 0, MG_SECTOR_SIZE));
> > +               rem = mg_end_request(host, 0, MG_SECTOR_SIZE);
> > +               if (rem)
> > +                       mg_write_one(host, req);
> > +
> > +               outb(MG_CMD_WR_CONF,
> > +                    (unsigned long)host->dev_base + MG_REG_COMMAND);
> > +       } while (rem);
> >  }
> 
> I think checking ready status after do-while loop is enough.
> 
> static void mg_write(struct request *req)
> {
> 	u32 j;
> 	struct mg_host *host = req->rq_disk->private_data;
> 
> 	if (mg_out(host, blk_rq_pos(req), blk_rq_sectors(req),
> 		   MG_CMD_WR, NULL) != MG_ERR_NONE) {
> 		mg_bad_rw_intr(host);
> 		return;
> 	}
> 
> 	MG_DBG("requested %d sects (from %ld), buffer=0x%p\n",
> 	       blk_rq_sectors(req), blk_rq_pos(req), req->buffer);
> 
> 	do {
> 		u16 *buff = (u16 *)req->buffer;
> 
> 		if (mg_wait(host, ATA_DRQ, MG_TMAX_WAIT_WR_DRQ) !=
> 				MG_ERR_NONE) {
> 			mg_bad_rw_intr(host);
> 			return;
> 		}
> 		for (j = 0; j < MG_SECTOR_SIZE >> 1; j++)
> 			outw(*buff++, (unsigned long)host->dev_base +
> 				      MG_BUFF_OFFSET + (j << 1));
> 
> 		outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base +
> 				MG_REG_COMMAND);
> 	} while (mg_end_request(host, 0, MG_SECTOR_SIZE));
> 
> +	if (mg_wait(host, MG_STAT_READY, MG_TMAX_WAIT_WR_DRQ) !=
> +			MG_ERR_NONE)
> +		mg_bad_rw_intr(host);
> }

I'm not sure about this -- I chose more invasive way cause it seems that
mg_end_request() may already complete the request (marking it as successful
and making block layer pass the data to upper layers) _before_ we really
check the status _after_ transferring the last sector of the command..
