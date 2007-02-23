Return-Path: <linux-kernel-owner+w=401wt.eu-S1750730AbXBWCuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750730AbXBWCuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 21:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750773AbXBWCuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 21:50:18 -0500
Received: from main.gmane.org ([80.91.229.2]:60700 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbXBWCuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 21:50:16 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Piet Delaney <piet@bluelane.com>
Subject: Re: [stable][PATCH < 2.6.19] Fix data corruption with dm-crypt over RAID5
Followup-To: gmane.linux.kernel.device-mapper.dm-crypt
Date: Thu, 22 Feb 2007 18:49:14 -0800
Organization: BlueLane Tech
Message-ID: <erlknb$khn$1@sea.gmane.org>
References: <456B732F.6080906@lelik.org> <20061129145208.GQ4409@agk.surrey.redhat.com> <456F46E3.6030702@lelik.org> <1164983209.24524.20.camel@leto.intern.saout.de> <20061201152143.GE4409@agk.surrey.redhat.com> <45704B95.3020308@lelik.org> <1165026116.29307.18.camel@leto.intern.saout.de> <1165026476.29307.23.camel@leto.intern.saout.de>
Reply-To: piet@bluelane.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 64.95.123.130
Mail-Copies-To: piet@bluelane.com
User-Agent: KNode/0.9.1
Cc: dm-crypt@saout.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christophe Saout wrote:

> Fix corruption issue with dm-crypt on top of software raid5. Cancelled
> readahead bio's that report no error, just have BIO_UPTODATE cleared
> were reported as successful reads to the higher layers (and leaving
> random content in the buffer cache). Already fixed in 2.6.19.
> 
> Signed-off-by: Christophe Saout <christophe@saout.de>
> 
> 
> --- linux-2.6.18.orig/drivers/md/dm-crypt.c   2006-09-20 05:42:06.000000000
> +0200
> +++ linux-2.6.18/drivers/md/dm-crypt.c        2006-12-02 03:03:36.000000000 +0100
> @@ -717,13 +717,15 @@
>  if (bio->bi_size)
>  return 1;
>  
> +     if (!bio_flagged(bio, BIO_UPTODATE) && !error)
> +             error = -EIO;
> +
>  bio_put(bio);
>  
>  /*
>  * successful reads are decrypted by the worker thread
>  */
> -     if ((bio_data_dir(bio) == READ)
> -         && bio_flagged(bio, BIO_UPTODATE)) {
> +     if (bio_data_dir(io->bio) == READ && !error) {
>  kcryptd_queue_io(io);

Why doesn't kcryptd_queue_io() check the return value from queue_work()?


    476 static void kcryptd_queue_io(struct crypt_io *io)
    477 {
    478         INIT_WORK(&io->work, kcryptd_do_work, io);
    479         queue_work(_kcryptd_workqueue, &io->work);
    480 }

-piet

>  return 0;
>  }


