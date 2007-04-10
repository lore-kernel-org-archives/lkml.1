Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbXDJVPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbXDJVPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbXDJVPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:15:08 -0400
Received: from ccerelbas04.cce.hp.com ([161.114.21.107]:38101 "EHLO
	ccerelbas04.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbXDJVPE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:15:04 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch] cciss: unregister from SCSI before tearing down device resources
Date: Tue, 10 Apr 2007 22:13:39 +0100
Message-ID: <226E1C65E4F6164E8EA5FD3CC913AE8CDD5DA3@G3W0639.americas.hpqcorp.net>
In-reply-to: <200704101206.41287.bjorn.helgaas@hp.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] cciss: unregister from SCSI before tearing down device resources
Thread-Index: Acd7mwYtXjfHMejvToadE6LWwJBSIAAGf20g
References: <200704101206.41287.bjorn.helgaas@hp.com>
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: "Helgaas, Bjorn" <bjorn.helgaas@hp.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "ISS StorageDev" <iss_storagedev@hp.com>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Apr 2007 21:14:15.0882 (UTC) FILETIME=[31D702A0:01C77BB5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Helgaas, Bjorn 
> Sent: Tuesday, April 10, 2007 1:07 PM
> To: Helgaas, Bjorn; Miller, Mike (OS Dev)
> Cc: Andrew Morton; ISS StorageDev; linux-kernel@vger.kernel.org
> Subject: [patch] cciss: unregister from SCSI before tearing 
> down device resources
> 
> We must unregister from SCSI before we unmap device resources 
> and unhook the IRQ handler.  Otherwise, SCSI may send us more 
> requests, and we won't be able to handle them.
> 
> I'd like to see this patch in 2.6.21.  In 2.6.21-rc6, I see 
> the following oops during every reboot of my HP DL360:
> 
>     ...
>     Unmounting local filesystems...done.
>     Rebooting... Completed flushing cache on controller 0
>     BUG: unable to handle kernel paging request at virtual 
> address f8808040
>      printing eip:
>     c02dc72b
>     *pde = 02120067
>     *pte = 00000000
>     Oops: 0002 [#1]
>     SMP 
>     Modules linked in:
>     CPU:    1
>     EIP:    0060:[<c02dc72b>]    Not tainted VLI
>     EFLAGS: 00010046   (2.6.21-rc6 #1)
>     EIP is at SA5_submit_command+0xb/0x20
>     eax: f8808000   ebx: f7a00000   ecx: f79f0000   edx: 37a00000
>     esi: f79f0000   edi: 00000000   ebp: 00000000   esp: dd717a44
>     ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
>     Process khelper (pid: 1427, ti=dd716000 task=c2260a70 
> task.ti=dd716000)
>     Stack: c02df2c0 f7a00000 f7a00000 00d41008 c02df691 
> 00000000 00000010 00000002 
> 	   00000001 f79f0000 f7fff844 c1398420 00000000 
> 00000000 00001000 230a3020 
> 	   69666564 5420656e 50434f49 465f544b 4853554c 
> 44414552 0a312009 66656423 
>     Call Trace:
>      [<c02df2c0>] start_io+0x80/0x120
>      [<c02df691>] do_cciss_request+0x331/0x350
>      [<c014242a>] mempool_alloc+0x2a/0xe0
>      [<c020ad71>] blk_alloc_request+0x61/0x80
>      [<c020b02e>] get_request+0x15e/0x1e0
>      [<c01595e0>] cache_alloc_refill+0xb0/0x1e0
>      [<c021049d>] as_update_rq+0x2d/0x80
>      [<c0210d28>] as_add_request+0x68/0x90
>      [<c0207f99>] elv_insert+0x119/0x160
>      [<c020bd0b>] __make_request+0xcb/0x320
>      [<c0122ee0>] lock_timer_base+0x20/0x50
>      [<c0123096>] del_timer+0x56/0x60
>      [<c020a7b8>] blk_remove_plug+0x38/0x70
>      [<c020a815>] __generic_unplug_device+0x25/0x30
>      [<c020a835>] generic_unplug_device+0x15/0x30
>     ...
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

ACKed-by: Mike Miller <mike.miller@hp.com>


> 
> Index: cciss/drivers/block/cciss.c
> ===================================================================
> --- cciss.orig/drivers/block/cciss.c	2007-04-10 
> 09:46:09.000000000 -0600
> +++ cciss/drivers/block/cciss.c	2007-04-10 
> 10:11:06.000000000 -0600
> @@ -3423,6 +3423,25 @@
>  		       "already be removed \n");
>  		return;
>  	}
> +
> +	remove_proc_entry(hba[i]->devname, proc_cciss);
> +	unregister_blkdev(hba[i]->major, hba[i]->devname);
> +
> +	/* remove it from the disk list */
> +	for (j = 0; j < CISS_MAX_LUN; j++) {
> +		struct gendisk *disk = hba[i]->gendisk[j];
> +		if (disk) {
> +			request_queue_t *q = disk->queue;
> +
> +			if (disk->flags & GENHD_FL_UP)
> +				del_gendisk(disk);
> +			if (q)
> +				blk_cleanup_queue(q);
> +		}
> +	}
> +
> +	cciss_unregister_scsi(i);	/* unhook from SCSI subsystem */
> +
>  	/* Turn board interrupts off  and send the flush cache 
> command */
>  	/* sendcmd will turn off interrupt, and send the flush...
>  	 * To write all data in the battery backed cache to 
> disks */ @@ -3444,22 +3463,6 @@
>  #endif				/* CONFIG_PCI_MSI */
>  
>  	iounmap(hba[i]->vaddr);
> -	cciss_unregister_scsi(i);	/* unhook from SCSI subsystem */
> -	unregister_blkdev(hba[i]->major, hba[i]->devname);
> -	remove_proc_entry(hba[i]->devname, proc_cciss);
> -
> -	/* remove it from the disk list */
> -	for (j = 0; j < CISS_MAX_LUN; j++) {
> -		struct gendisk *disk = hba[i]->gendisk[j];
> -		if (disk) {
> -			request_queue_t *q = disk->queue;
> -
> -			if (disk->flags & GENHD_FL_UP)
> -				del_gendisk(disk);
> -			if (q)
> -				blk_cleanup_queue(q);
> -		}
> -	}
>  
>  	pci_free_consistent(hba[i]->pdev, hba[i]->nr_cmds * 
> sizeof(CommandList_struct),
>  			    hba[i]->cmd_pool, hba[i]->cmd_pool_dhandle);
> 
