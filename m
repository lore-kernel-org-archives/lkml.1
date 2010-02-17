Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934184Ab0BQOMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 09:12:47 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:57959 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509Ab0BQOMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 09:12:45 -0500
Message-ID: <4B7BF8DC.7080403@ru.mvista.com>
Date: Wed, 17 Feb 2010 17:10:36 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: jeff@garzik.org.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [RFC 3/4] libata: Remove excess command issue delays
References: <20100217130847.16338.55586.stgit@localhost.localdomain> <20100217131145.16338.70473.stgit@localhost.localdomain>
In-Reply-To: <20100217131145.16338.70473.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alan Cox wrote:

> We don't need to pause before a command issue for PIO (it's posted) or for
>   

   I thought you're eliminating the pause *after* command issue, no?

> most MMIO devices (internally managed delay) so provide a routine for the
> normal "sane" hardware
>   

   Wouldn't it make sense then to handle the "insane" hardware as an 
exception, not vice versa?

> As a side effect it also means that those devices using PIO don't end up
> generating ATA bus cycles in strange places which confuses some hardware.
>   

   I thought that's mostly a problem with DMA commands...

> Saves us about 1mS on a dumb controller,

   1 ms per command?! Or per what?

> a fair bit less (uSecs on smarter
> ones). ata_pause() is very very slow on controllers where it goes all the way
>
> [For those counting thats another mS saved once we turn this stuff on]
>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
>   
[...]
> diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
> index 3558ca8..fa18482 100644
> --- a/drivers/ata/libata-sff.c
> +++ b/drivers/ata/libata-sff.c
> @@ -674,11 +674,34 @@ void ata_sff_exec_command(struct ata_port *ap, const struct ata_taskfile *tf)
>  	DPRINTK("ata%u: cmd 0x%X\n", ap->print_id, tf->command);
>  
>  	iowrite8(tf->command, ap->ioaddr.command_addr);
> -	ata_sff_pause(ap);
> +	/* Slow */
> +        ata_sff_pause(ap);
>   

   Spaces instead of tab here...

> diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
> index 147de2f..67a2964 100644
> --- a/drivers/ata/pata_pcmcia.c
> +++ b/drivers/ata/pata_pcmcia.c
> @@ -163,18 +163,19 @@ static struct scsi_host_template pcmcia_sht = {
>  };
>  
>  static struct ata_port_operations pcmcia_port_ops = {
> -	.inherits	= &ata_sff_port_ops,
> -	.sff_data_xfer	= ata_sff_data_xfer_noirq,
> -	.cable_detect	= ata_cable_40wire,
> -	.set_mode	= pcmcia_set_mode,
> +	.inherits		= &ata_sff_port_ops,
> +	.sff_exec_command	= ata_sff_exec_command_nopost,
> +	.sff_data_xfer		= ata_sff_data_xfer_noirq,
> +	.cable_detect		= ata_cable_40wire,
> +	.set_mode		= pcmcia_set_mode,
>  };
>  
>  static struct ata_port_operations pcmcia_8bit_port_ops = {
> -	.inherits	= &ata_sff_port_ops,
> -	.sff_data_xfer	= ata_data_xfer_8bit,
> -	.cable_detect	= ata_cable_40wire,
> -	.set_mode	= pcmcia_set_mode_8bit,
> -	.drain_fifo	= pcmcia_8bit_drain_fifo,
> +	.inherits		= &ata_sff_port_ops,
> +	.sff_data_xfer		= ata_data_xfer_8bit,
>   

   No sff_exec_command() method override here?

> +	.cable_detect		= ata_cable_40wire,
> +	.set_mode		= pcmcia_set_mode_8bit,
> +	.drain_fifo		= pcmcia_8bit_drain_fifo,
>  };
>  
>  
> diff --git a/drivers/ata/pata_qdi.c b/drivers/ata/pata_qdi.c
> index 45879dc..c9a468c 100644
> --- a/drivers/ata/pata_qdi.c
> +++ b/drivers/ata/pata_qdi.c
> @@ -158,16 +158,17 @@ static struct scsi_host_template qdi_sht = {
>  };
>  
>  static struct ata_port_operations qdi6500_port_ops = {
> -	.inherits	= &ata_sff_port_ops,
> -	.qc_issue	= qdi_qc_issue,
> -	.sff_data_xfer	= qdi_data_xfer,
> -	.cable_detect	= ata_cable_40wire,
> -	.set_piomode	= qdi6500_set_piomode,
> +	.inherits	= 	&ata_sff_port_ops,
> +	.sff_exec_command	= ata_sff_exec_command_nopost,
> +	.qc_issue	= 	qdi_qc_issue,
> +	.sff_data_xfer	= 	qdi_data_xfer,
> +	.cable_detect	= 	ata_cable_40wire,
> +	.set_piomode	= 	qdi6500_set_piomode,
>  };
>  
>  static struct ata_port_operations qdi6580_port_ops = {
> -	.inherits	= &qdi6500_port_ops,
> -	.set_piomode	= qdi6580_set_piomode,
> +	.inherits	= 	&qdi6500_port_ops,
> +	.set_piomode	= 	qdi6580_set_piomode,
>  };
>  
>  /**
>   
[...]
> diff --git a/drivers/ata/pata_winbond.c b/drivers/ata/pata_winbond.c
> index 6d8619b..066deea 100644
> --- a/drivers/ata/pata_winbond.c
> +++ b/drivers/ata/pata_winbond.c
> @@ -126,10 +126,11 @@ static struct scsi_host_template winbond_sht = {
>  };
>  
>  static struct ata_port_operations winbond_port_ops = {
> -	.inherits	= &ata_sff_port_ops,
> -	.sff_data_xfer	= winbond_data_xfer,
> -	.cable_detect	= ata_cable_40wire,
> -	.set_piomode	= winbond_set_piomode,
> +	.inherits	= 	&ata_sff_port_ops,
> +	.sff_exec_command	= ata_sff_exec_command_nopost,
> +	.sff_data_xfer	= 	winbond_data_xfer,
> +	.cable_detect	= 	ata_cable_40wire,
> +	.set_piomode	= 	winbond_set_piomode,
>   

   What's up with the alignment here, why it's different from the rest 
of drivers?

MBR, Sergei

