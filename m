Return-Path: <linux-kernel-owner+w=401wt.eu-S1756416AbZFXGte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416AbZFXGte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 02:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756258AbZFXGt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 02:49:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54483
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753154AbZFXGtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 02:49:25 -0400
Date: Tue, 23 Jun 2009 23:49:29 -0700 (PDT)
Message-Id: <20090623.234929.32348223.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       petkovbb@gmail.com, htejun@gmail.com
Subject: Re: [patch 2/6] ide: fix ide_kill_rq() for special
 ide-{floppy,tape} driver requests
From: David Miller <davem@davemloft.net>
In-Reply-To: <200906232326.06830.bzolnier@gmail.com>
References: <200906232326.06830.bzolnier@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Tue, 23 Jun 2009 23:26:06 +0200

> @@ -152,7 +152,7 @@ void ide_kill_rq(ide_drive_t *drive, str
>  
>  	if ((media == ide_floppy || media == ide_tape) && drv_req) {
>  		rq->errors = 0;
> -		ide_complete_rq(drive, 0, blk_rq_bytes(rq));
> +		ide_complete_rq(drive, -EIO, blk_rq_bytes(rq));
>  	} else {
>  		if (media == ide_tape)
>  			rq->errors = IDE_DRV_ERROR_GENERAL;

I've done some research and this logic of returning "0" appears to be
intentional.

It keeps the block layer from printing the "I/O error" kernel log
message during completion of the request.

IDE tape as one example, seems to have it's own system of passing
errors back up to the special command completion, via rq->errors
and IDE_DRV_ERROR_GENERAL.

See idetape_queue_rw_tail() and ide_tape_callback() for example.

IDE floppy has similar pieces of logic, and possibly similar desires
wrt. emission of the block layer I/O error log message during
special requests.

When something sticks out like an eyesore (as this -EIO thing does)
and seems to make no sense at all, there often is some obscure
reason.
