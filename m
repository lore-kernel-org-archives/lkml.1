Return-Path: <linux-kernel-owner+w=401wt.eu-S1758331AbZD2Jkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331AbZD2Jkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757992AbZD2JkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:40:13 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:33960 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755061AbZD2JkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:40:11 -0400
Date: Wed, 29 Apr 2009 11:40:04 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Tejun Heo <tj@kernel.org>
cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com,
       sshtylyov@ru.mvista.com, mike.miller@hp.com, chirag.kantharia@hp.com,
       Eric.Moore@lsi.com, stern@rowland.harvard.edu,
       fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, sfr@canb.auug.org.au,
       grant.likely@secretlab.ca, paul.clements@steeleye.com,
       jesper.juhl@gmail.com, tim@cyberelk.net, jeremy@xensource.com,
       adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org,
       schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net,
       rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com,
       bharrosh@panasas.com, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 05/10] block: convert to pos and nr_sectors accessors
In-Reply-To: <1240996428-10159-6-git-send-email-tj@kernel.org>
Message-ID: <alpine.LRH.2.00.0904291136160.3531@vixen.sonytel.be>
References: <1240996428-10159-1-git-send-email-tj@kernel.org> <1240996428-10159-6-git-send-email-tj@kernel.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009, Tejun Heo wrote:
> With recent cleanups, there is no place where low level driver
> directly manipulates request fields.  This means that the 'hard'
> request fields always equal the !hard fields.  Convert all
> rq->sectors, nr_sectors and current_nr_sectors references to
> accessors.
> 
> [ Impact: use pos and nr_sectors accessors ]
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

>  drivers/block/amiflop.c             |    6 ++--
>  drivers/block/ataflop.c             |   10 +++---
>  drivers/block/ps3disk.c             |    9 ++---
>  drivers/block/swim3.c               |   34 ++++++++++++----------
>  drivers/block/z2ram.c               |    6 ++--

Looks OK, so
Acked-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

> diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
> index b66ad58..d4e6b71 100644
> --- a/drivers/block/z2ram.c
> +++ b/drivers/block/z2ram.c
> @@ -71,12 +71,12 @@ static void do_z2_request(struct request_queue *q)
>  {
>  	struct request *req;
>  	while ((req = elv_next_request(q)) != NULL) {
> -		unsigned long start = req->sector << 9;
> -		unsigned long len  = req->current_nr_sectors << 9;
> +		unsigned long start = blk_rq_pos(req) << 9;
> +		unsigned long len  = blk_rq_cur_sectors(req) << 9;
                ^^^^^^^^^^^^^
I guess this one can become `unsigned int' now, as:

static inline unsigned int blk_rq_cur_sectors(struct request *rq)
{
	return blk_rq_cur_bytes(rq) >> 9;
}

and blk_rq_cur_bytes(rq) returns `int', so it must fit in an `int' anyway?

With kind regards,

Geert Uytterhoeven
Software Architect
Techsoft Centre

Technology and Software Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
