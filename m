Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbYHaQLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbYHaQLk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 12:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbYHaQLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 12:11:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:32362 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYHaQLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 12:11:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=u7Vi1ySWY3XB1Q0O5MyFjuRbXWhBi1SU1KovMj0hZQLA73SxxQc7r7Tgy3cnL9hoXK
         ObGDf4z0YVgsCEZXj7PMNfnWu3hZSTdJ4s3YV/aqhxIwGO43sB4bUwKo337JFz3fdXpO
         ASTqOXKZhE6TpHTVcyYGobmHdPzllDWi4a+IA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH] ide: Two fixes regarding memory allocation
Date: Sun, 31 Aug 2008 18:05:56 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080829213217.4826.43132.stgit@denkblock.local>
In-Reply-To: <20080829213217.4826.43132.stgit@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808311805.57395.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 August 2008, Elias Oltmanns wrote:
> In function ide_devset_execute() we should use __GFP_WAIT rather than
> GFP_KERNEL. Also, the allocation cannot possibly fail at that point.
> More importantly, there is a potential memory leak in the device probing
> code. The infrastructure seems rather complex and I hope I haven't messed
> anything up by trying to fix this.
> 
> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>

thanks, applied

> @@ -972,12 +972,21 @@ static void ide_port_setup_devices(ide_hwif_t *hwif)
>  		if (ide_init_queue(drive)) {
>  			printk(KERN_ERR "ide: failed to init %s\n",
>  					drive->name);
> +			spin_lock_irq(&ide_lock);
> +			kfree(drive->id);
> +			drive->id = NULL;
> +			drive->dev_flags &= ~IDE_DFLAG_PRESENT;
> +			spin_unlock_irq(&ide_lock);
>  			continue;

ide_lock taking is superfluous here, I removed it while merging the patch
