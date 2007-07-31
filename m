Return-Path: <linux-kernel-owner+w=401wt.eu-S1762356AbXGaURl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762356AbXGaURl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 16:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbXGaURd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 16:17:33 -0400
Received: from ccerelbas02.cce.hp.com ([161.114.21.105]:54289 "EHLO
	ccerelbas02.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbXGaURb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 16:17:31 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 10] drivers/block/cpqarray.c: better error handling and kmalloc + memset conversion to k[cz]alloc
Date: Tue, 31 Jul 2007 20:16:50 -0000
Message-ID: <226E1C65E4F6164E8EA5FD3CC913AE8C01A3F187@G3W0639.americas.hpqcorp.net>
In-Reply-To: <200707311912.19298.m.kozlowski@tuxland.pl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 10] drivers/block/cpqarray.c: better error handling and kmalloc + memset conversion to k[cz]alloc
Thread-Index: AcfTlgHPflM50sH/QAWjUTX/TitW4AAGaqdw
References: <200707311845.48807.m.kozlowski@tuxland.pl> <200707311912.19298.m.kozlowski@tuxland.pl>
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>,
       <linux-kernel@vger.kernel.org>
Cc: <kernel-janitors@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "ISS StorageDev" <iss_storagedev@hp.com>, <axboe@kernel.dk>
X-OriginalArrivalTime: 31 Jul 2007 20:16:51.0666 (UTC) FILETIME=[BB315B20:01C7D3AF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Mariusz Kozlowski [mailto:m.kozlowski@tuxland.pl] 
> Sent: Tuesday, July 31, 2007 12:12 PM
> To: linux-kernel@vger.kernel.org
> Cc: kernel-janitors@vger.kernel.org; Andrew Morton; ISS 
> StorageDev; axboe@kernel.dk
> Subject: [PATCH 10] drivers/block/cpqarray.c: better error 
> handling and kmalloc + memset conversion to k[cz]alloc
> 
> This patch removes some redundant casts, does the kmalloc + 
> memset to k[cz]alloc conversion and it changes the error path 
> to use goto (to avoid code duplication).
> 
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Acked-by: Mike Miller <mike.miller@hp.com>

> 
>  drivers/block/cpqarray.c | 49567 -> 48623 (-944 bytes)  
> drivers/block/cpqarray.o | 178820 -> 178288 (-532 bytes)
> 
>  drivers/block/cpqarray.c |   78 ++++++++++++-------------------------
>  1 file changed, 26 insertions(+), 52 deletions(-)
> 
> --- linux-2.6.23-rc1-mm1-a/drivers/block/cpqarray.c	
> 2007-07-26 13:07:41.000000000 +0200
> +++ linux-2.6.23-rc1-mm1-b/drivers/block/cpqarray.c	
> 2007-07-31 12:59:54.000000000 +0200
> @@ -420,18 +420,17 @@ static int __init cpqarray_register_ctlr
>  			goto Enomem2;
>  	}
> 
> -	hba[i]->cmd_pool = (cmdlist_t *)pci_alloc_consistent(
> +	hba[i]->cmd_pool = pci_alloc_consistent(
>  		hba[i]->pci_dev, NR_CMDS * sizeof(cmdlist_t),
>  		&(hba[i]->cmd_pool_dhandle));
> -	hba[i]->cmd_pool_bits = kmalloc(
> -		
> ((NR_CMDS+BITS_PER_LONG-1)/BITS_PER_LONG)*sizeof(unsigned long),
> +	hba[i]->cmd_pool_bits = kcalloc(
> +		(NR_CMDS+BITS_PER_LONG-1)/BITS_PER_LONG, 
> sizeof(unsigned long),
>  		GFP_KERNEL);
> 
>  	if (!hba[i]->cmd_pool_bits || !hba[i]->cmd_pool)
>  			goto Enomem1;
> 
>  	memset(hba[i]->cmd_pool, 0, NR_CMDS * sizeof(cmdlist_t));
> -	memset(hba[i]->cmd_pool_bits, 0, 
> ((NR_CMDS+BITS_PER_LONG-1)/BITS_PER_LONG)*sizeof(unsigned long));
>  	printk(KERN_INFO "cpqarray: Finding drives on %s",
>  		hba[i]->devname);
> 
> @@ -1660,45 +1659,30 @@ static void getgeometry(int ctlr)
> 
>  	info_p->log_drv_map = 0;
> 
> -	id_ldrive = kmalloc(sizeof(id_log_drv_t), GFP_KERNEL);
> -	if(id_ldrive == NULL)
> -	{
> +	id_ldrive = kzalloc(sizeof(id_log_drv_t), GFP_KERNEL);
> +	if (!id_ldrive)	{
>  		printk( KERN_ERR "cpqarray:  out of memory.\n");
> -		return;
> +		goto err_0;
>  	}
> 
> -	id_ctlr_buf = kmalloc(sizeof(id_ctlr_t), GFP_KERNEL);
> -	if(id_ctlr_buf == NULL)
> -	{
> -		kfree(id_ldrive);
> +	id_ctlr_buf = kzalloc(sizeof(id_ctlr_t), GFP_KERNEL);
> +	if (!id_ctlr_buf) {
>  		printk( KERN_ERR "cpqarray:  out of memory.\n");
> -		return;
> +		goto err_1;
>  	}
> 
> -	id_lstatus_buf = kmalloc(sizeof(sense_log_drv_stat_t), 
> GFP_KERNEL);
> -	if(id_lstatus_buf == NULL)
> -	{
> -		kfree(id_ctlr_buf);
> -		kfree(id_ldrive);
> +	id_lstatus_buf = kzalloc(sizeof(sense_log_drv_stat_t), 
> GFP_KERNEL);
> +	if (!id_lstatus_buf) {
>  		printk( KERN_ERR "cpqarray:  out of memory.\n");
> -		return;
> +		goto err_2;
>  	}
> 
> -	sense_config_buf = kmalloc(sizeof(config_t), GFP_KERNEL);
> -	if(sense_config_buf == NULL)
> -	{
> -		kfree(id_lstatus_buf);
> -		kfree(id_ctlr_buf);
> -		kfree(id_ldrive);
> +	sense_config_buf = kzalloc(sizeof(config_t), GFP_KERNEL);
> +	if (!sense_config_buf) {
>  		printk( KERN_ERR "cpqarray:  out of memory.\n");
> -		return;
> +		goto err_3;
>  	}
> 
> -	memset(id_ldrive, 0, sizeof(id_log_drv_t));
> -	memset(id_ctlr_buf, 0, sizeof(id_ctlr_t));
> -	memset(id_lstatus_buf, 0, sizeof(sense_log_drv_stat_t));
> -	memset(sense_config_buf, 0, sizeof(config_t));
> -
>  	info_p->phys_drives = 0;
>  	info_p->log_drv_map = 0;
>  	info_p->drv_assign_map = 0;
> @@ -1712,13 +1696,8 @@ static void getgeometry(int ctlr)
>  		 * so the idastubopen will fail on all logical drives
>  		 * on the controller.
>  		 */
> -		 /* Free all the buffers and return */
>  		printk(KERN_ERR "cpqarray: error sending ID 
> controller\n");
> -		kfree(sense_config_buf);
> -                kfree(id_lstatus_buf);
> -                kfree(id_ctlr_buf);
> -                kfree(id_ldrive);
> -                return;
> +                goto err_4;
>          }
> 
>  	info_p->log_drives = id_ctlr_buf->nr_drvs; @@ -1764,12 
> +1743,7 @@ static void getgeometry(int ctlr)
>  				" failed to report status of 
> logical drive %d\n"
>  			 "Access to this controller has been 
> disabled\n",
>  				ctlr, log_unit);
> -			/* Free all the buffers and return */
> -                	kfree(sense_config_buf);
> -                	kfree(id_lstatus_buf);
> -                	kfree(id_ctlr_buf);
> -                	kfree(id_ldrive);
> -                	return;
> +                	goto err_4;
>  		}
>  		/*
>  		   Make sure the logical drive is configured @@ 
> -1798,14 +1772,8 @@ static void getgeometry(int ctlr)
>  				 sizeof(config_t), 0, 0, log_unit);
>  				if (ret_code == IO_ERROR) {
>  					info_p->log_drv_map = 0;
> -					/* Free all the buffers 
> and return */
>                  			printk(KERN_ERR 
> "cpqarray: error sending sense config\n");
> -                			kfree(sense_config_buf);
> -                			kfree(id_lstatus_buf);
> -                			kfree(id_ctlr_buf);
> -                			kfree(id_ldrive);
> -                			return;
> -
> +                			goto err_4;
>  				}
> 
>  				info_p->phys_drives =
> @@ -1820,12 +1788,18 @@ static void getgeometry(int ctlr)
>  			log_index = log_index + 1;
>  		}		/* end of if logical drive configured */
>  	}			/* end of for log_unit */
> +
> +	/* Free all the buffers and return */
> +err_4:
>  	kfree(sense_config_buf);
> -  	kfree(id_ldrive);
> +err_3:
>    	kfree(id_lstatus_buf);
> +err_2:
>  	kfree(id_ctlr_buf);
> +err_1:
> +  	kfree(id_ldrive);
> +err_0:
>  	return;
> -
>  }
> 
>  static void __exit cpqarray_exit(void)
> 
