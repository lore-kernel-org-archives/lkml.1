Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbYGFOUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbYGFOUG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 10:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756643AbYGFOTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 10:19:55 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:52753 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441AbYGFOTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 10:19:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=I4eENkXFLEVK8i/XJKFV2HkiazJJRH56469CRRUC1drVotaffUHnuP24epE7bxKpHY
         wf0hhOjDzdMSiCsu7/3cpHj99BleYOOjwDeBOncVeAp+fdV4ls15dLiOczC0OBAd1hsw
         VVofL2TUg8c4kBJoRsntFlsatzTh2Ikq3tQqc=
Message-ID: <4870D46C.7000604@gmail.com>
Date: Sun, 06 Jul 2008 23:19:24 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Komuro <komurojun-mbn@nifty.com>
CC: Jeff Garzik <jeff@garzik.org>,
       linux-pcmcia <linux-pcmcia@lists.infradead.org>,
       linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-ide@vger.kernel.org,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>, jgarzik@redhat.com,
       rjw@sisk.pl
Subject: Re: [KERNEL 2.6.26-rc4]  bugreport : pata_pcmcia with Sandisk Extreme
 III 8GB
References: <20080528225049.9a134e0d.Kristoffer.Ericson@Gmail.com>	<20080528222740.GB20893@isilmar.linta.de>	<20080530135728.be02d3dc.Kristoffer.Ericson@Gmail.com>	<20080607223716.7d142072.komurojun-mbn@nifty.com>	<20080611072029.GB28692@comet.dominikbrodowski.net>	<20080614120055.ad8fbee0.komurojun-mbn@nifty.com>	<48537149.4040102@garzik.org>	<20080614213612.96873c25.komurojun-mbn@nifty.com>	<4855D8E2.10409@gmail.com>	<20080616221145.e3b069b9.komurojun-mbn@nifty.com>	<485669A0.6000404@gmail.com>	<20080617212345.c452d8c5.komurojun-mbn@nifty.com> <20080706103752.13935ffd.komurojun-mbn@nifty.com>
In-Reply-To: <20080706103752.13935ffd.komurojun-mbn@nifty.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Komuro.

Komuro wrote:
> Hi, Tejun
> 
> The patch below fixes the pata_pcmcia problem.
> 
> I think the ap->lock points to bogus address.
> 
> Any comment?
> 
> --- linux-2.6.26-rc8/drivers/ata/libata-core.c.orig	2008-07-06 10:05:46.000000000 +0900
> +++ linux-2.6.26-rc8/drivers/ata/libata-core.c	2008-07-06 10:09:16.000000000 +0900
> @@ -5304,6 +5304,8 @@ struct ata_host *ata_host_alloc(struct d
>  			goto err_out;
>  
>  		ap->port_no = i;
> +		ap->lock = &ap->__lock;
> +		spin_lock_init(ap->lock);
>  		host->ports[i] = ap;
>  	}
>  
> --- linux-2.6.26-rc8/include/linux/libata.h.orig	2008-07-06 10:03:54.000000000 +0900
> +++ linux-2.6.26-rc8/include/linux/libata.h	2008-07-06 10:04:35.000000000 +0900
> @@ -639,6 +639,7 @@ struct ata_port {
>  	struct Scsi_Host	*scsi_host; /* our co-allocated scsi host */
>  	struct ata_port_operations *ops;
>  	spinlock_t		*lock;
> +	spinlock_t		__lock;
>  	unsigned long		flags;	/* ATA_FLAG_xxx */
>  	unsigned int		pflags; /* ATA_PFLAG_xxx */
>  	unsigned int		print_id; /* user visible unique port ID */

Hmmm... Strange.  From ata_port_alloc(),

struct ata_port *ata_port_alloc(struct ata_host *host)
{
	struct ata_port *ap;

	DPRINTK("ENTER\n");

	ap = kzalloc(sizeof(*ap), GFP_KERNEL);
	if (!ap)
		return NULL;

	ap->pflags |= ATA_PFLAG_INITIALIZING;
	ap->lock = &host->lock;
	^^^^^^^^^^^^^^^^^^^^^^^

How come ap->lock can get set to bogus address?  Can you please printk
&host->lock and ap->lock after ata_host_alloc() without the patch?

Thanks.

-- 
tejun
