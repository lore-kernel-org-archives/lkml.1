Return-Path: <linux-kernel-owner+w=401wt.eu-S932366AbZHJRSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366AbZHJRSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 13:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932220AbZHJRSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 13:18:04 -0400
Received: from vena.lwn.net ([206.168.112.25]:54704 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932139AbZHJRSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 13:18:03 -0400
Date: Mon, 10 Aug 2009 11:15:23 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Eric.Moore@lsi.com, jeff@garzik.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 2/3] libata: add support for blk-iopoll
Message-ID: <20090810111523.035e0d20@bike.lwn.net>
In-Reply-To: <1249588685-4662-3-git-send-email-jens.axboe@oracle.com>
References: <1249588685-4662-1-git-send-email-jens.axboe@oracle.com>
	<1249588685-4662-3-git-send-email-jens.axboe@oracle.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Jens,

I'm a little slow in looking at this, hopefully it's not completely
noise...

> @@ -2157,7 +2194,12 @@ static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
>  
>  		ap = host->ports[i];
>  		if (ap) {
> -			ahci_port_intr(ap);
> +			if (!blk_iopoll_enabled)
> +				ahci_port_intr(ap);
> +			else if (blk_iopoll_sched_prep(&ap->iopoll)) {
> +				ap_irq_disable(ap);
> +				blk_iopoll_sched(&ap->iopoll);
> +			}
>  			VPRINTK("port %u\n", i);
>  		} else {
>  			VPRINTK("port %u (no irq)\n", i);

It seems to me that, if blk_iopoll_sched_prep() fails, the interrupt
will be dropped on the floor; would you not need an explicit
ahci_port_intr() call in that case too?  Unless I've misunderstood as
usual...

Documenting the "zero means failure" nature of blk_iopoll_sched_prep()
might also be a good idea; I predict confusion otherwise.

jon
