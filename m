Return-Path: <linux-kernel-owner+w=401wt.eu-S1761845AbYBZOlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761845AbYBZOlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 09:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbYBZOlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 09:41:04 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:40692 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbYBZOlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 09:41:02 -0500
Date: Tue, 26 Feb 2008 08:41:56 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] sata_nv: fix nmi intr or system hanging in rhel4u6 adma.
In-reply-to: <15F501D1A78BD343BE8F4D8DB854566B1BFE2AE5@hkemmail01.nvidia.com>
To: Kuan Luo <kluo@nvidia.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Peer Chen <pchen@nvidia.com>
Message-id: <47C42534.1090107@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <15F501D1A78BD343BE8F4D8DB854566B1BFE2AE5@hkemmail01.nvidia.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Kuan Luo wrote:
> Hi, robert 
> 
> One customer reported that their system received a nmi interrupt after
> issuing "dd if=/dev/sdb of=/dev/null" on a defective disk in rhel4u6.
> I tested it and found  that my system hung both in rhel4u6(2.6.9-67) and
> 2.6.24-rc7.
> The patch can work well,  but I am not sure if the patch has other
> potential effect on adma.
> I attached a  file in case of lines breaked.
> 
> The below info comes from Gunther Mayer to reproduce the issue.
> "
> used a Seagate ST3500841NS 3.AE for my test; probably other 
> seagate drives are also capable of creating media errors with 
> the new hdparm-8.1: 
> 
> - compile hdparm-8.1 
> - hdparm -- yes-i-know-what-i-am-doing --make-bad-sector 60000 /dev/sdb 
> 
> Unfortunately this does not succeed for nvidia sata controller (timeouts
> et al.), but it worked fine on AHCI machine (e.g. FSC R640). 
> 
> When I insert this newly created defective disk in Ultra 20, 
> it reboots within seconds after issueing "dd if=/dev/sdb of=/dev/null". 
> "
> 
> Signed-off-by: kluo@nvidia.com
> 
> ---
>  
> drivers/ata/sata_nv.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
> index ed5473b..e824260 100644
> --- a/drivers/ata/sata_nv.c
> +++ b/drivers/ata/sata_nv.c
> @@ -837,9 +837,10 @@ static void nv_adma_tf_read(struct ata_port *ap,
> struct ata_taskfile *tf)
>  	   all shortly be aborted anyway. We assume that NCQ commands
> are not
>  	   issued via passthrough, which is the only way that switching
> into
>  	   ADMA mode could abort outstanding commands. */
> -	nv_adma_register_mode(ap);
> +	struct nv_adma_port_priv *pp = ap->private_data;
>  
> -	ata_tf_read(ap, tf);
> +	if (pp->flags & NV_ADMA_PORT_REGISTER_MODE)
> +		ata_tf_read(ap, tf);
>  }
>  
>  static unsigned int nv_adma_tf_to_cpb(struct ata_taskfile *tf, __le16
> *cpb)

This is basically avoiding switching into register mode, right? I don't 
think this is a very good solution as the point of the tf_read function 
is that it's supposed to read the taskfile provided by the drive to 
diagnose the error, so not doing this isn't a good thing.

Is there a reason why going into register mode should cause a lockup in 
this case?
