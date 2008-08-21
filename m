Return-Path: <linux-kernel-owner+w=401wt.eu-S1758104AbYHUSCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104AbYHUSCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbYHUSB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:01:59 -0400
Received: from h155.mvista.com ([63.81.120.155]:62796 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752883AbYHUSB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:01:58 -0400
Message-ID: <48ADADA3.9060805@ru.mvista.com>
Date: Thu, 21 Aug 2008 22:02:11 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       khilman@deeprootsystems.com
Subject: Re: [PATCH 1/7] ide: add ide_host_add() helper
References: <20080628214355.21345.94835.sendpatchset@localhost.localdomain>
In-Reply-To: <20080628214355.21345.94835.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Add ide_host_add() helper which does ide_host_alloc()+ide_host_register(),
> then convert ide_setup_pci_device[s](), ide_legacy_device_add() and some
> host drivers to use it.

> While at it:

> * Fix ide_setup_pci_device[s](), ide_arm.c, gayle.c, ide-4drives.c,
>   macide.c, q40ide.c, cmd640.c and cs5520.c to return correct error value.

> * -ENOENT -> -ENOMEM in rapide.c, ide-h8300.c, ide-generic.c, au1xxx-ide.c
>   and pmac.c

> * -ENODEV -> -ENOMEM in palm_bk3710.c, ide_platform.c and delkin_cb.c

> * -1 -> -ENOMEM in ide-pnp.c

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Index: b/drivers/ide/arm/palm_bk3710.c
> ===================================================================
> --- a/drivers/ide/arm/palm_bk3710.c
> +++ b/drivers/ide/arm/palm_bk3710.c
> @@ -351,7 +351,7 @@ static int __devinit palm_bk3710_probe(s
>  	struct resource *mem, *irq;
>  	struct ide_host *host;

    You forgot to remove this variable which caused the warning:

drivers/ide/arm/palm_bk3710.c: In the fucntion ‘palm_bk3710_probe’
drivers/ide/arm/palm_bk3710.c:350: warning: unused variable ‘host’

>  	unsigned long base;
> -	int i;
> +	int i, rc;
>  	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
>  
>  	clkp = clk_get(NULL, "IDECLK");
> @@ -394,16 +394,14 @@ static int __devinit palm_bk3710_probe(s
>  	hw.irq = irq->start;
>  	hw.chipset = ide_palm3710;
>  
> -	host = ide_host_alloc(&palm_bk3710_port_info, hws);
> -	if (host == NULL)
> +	rc = ide_host_add(&palm_bk3710_port_info, hws, NULL);
> +	if (rc)
>  		goto out;
>  
> -	ide_host_register(host, &palm_bk3710_port_info, hws);
> -
>  	return 0;
>  out:
>  	printk(KERN_WARNING "Palm Chip BK3710 IDE Register Fail\n");
> -	return -ENODEV;
> +	return rc;
>  }
>  
>  /* work with hotplug and coldplug */

MBR, Sergei
