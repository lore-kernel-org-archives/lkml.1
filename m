Return-Path: <linux-kernel-owner+w=401wt.eu-S1423428AbXD3PnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423428AbXD3PnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423430AbXD3PnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:43:06 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:51679 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423428AbXD3PnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:43:02 -0400
Date: Mon, 30 Apr 2007 08:44:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Neela Kolli <Neela.Kolli@engenio.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] megaraid: fix CONFIG_PROC_FS compile errors
Message-Id: <20070430084414.be98e552.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0704291658140.1822@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0704291658140.1822@chino.kir.corp.google.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007 07:35:00 -0700 (PDT) David Rientjes wrote:

> Only declare mega_proc_dir_entry() in CONFIG_PROC_FS.  We should call
> mega_create_proc_entry() only in this configuration so make sure it's defined
> if we call it.
> 
> Only define mega_adapinq() in CONFIG_PROC_FS.  mega_internal_dev_inquiry()
> and mega_print_inquiry() were never declared without CONFIG_PROC_FS so
> make sure we don't have prototypes for them if we aren't going to define
> them.
> 
> Move the declaration of 'buf' in mega_remove_one() because we only use it
> in the CONFIG_PROC_FS case.

Just noting the presence of:
  http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/broken-out/megaraid-fix-warnings-when-config_proc_fs=n.patch


Oh, and that SCSI patches need to go to the linux-scsi mailing list.


> Cc: Neela Kolli <Neela.Kolli@engenio.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  drivers/scsi/megaraid.c |   10 +++++++++-
>  drivers/scsi/megaraid.h |    5 +++--
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
> --- a/drivers/scsi/megaraid.c
> +++ b/drivers/scsi/megaraid.c
> @@ -84,7 +84,10 @@ MODULE_PARM_DESC(max_mbox_busy_wait, "Maximum wait for mailbox in microseconds i
>  
>  static int hba_count;
>  static adapter_t *hba_soft_state[MAX_CONTROLLERS];
> +
> +#ifdef CONFIG_PROC_FS
>  static struct proc_dir_entry *mega_proc_dir_entry;
> +#endif
>  
>  /* For controller re-ordering */
>  static struct mega_hbas mega_hbas[MAX_CONTROLLERS];
> @@ -4342,6 +4345,7 @@ mega_support_cluster(adapter_t *adapter)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PROC_FS
>  
>  /**
>   * mega_adapinq()
> @@ -4448,6 +4452,7 @@ mega_internal_dev_inquiry(adapter_t *adapter, u8 ch, u8 tgt,
>  	return rval;
>  }
>  
> +#endif
>  
>  /**
>   * mega_internal_command()
> @@ -4890,7 +4895,9 @@ megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>  
>  	pci_set_drvdata(pdev, host);
>  
> +#ifdef CONFIG_PROC_FS
>  	mega_create_proc_entry(hba_count, mega_proc_dir_entry);
> +#endif
>  
>  	error = scsi_add_host(host, &pdev->dev);
>  	if (error)
> @@ -4965,7 +4972,6 @@ megaraid_remove_one(struct pci_dev *pdev)
>  {
>  	struct Scsi_Host *host = pci_get_drvdata(pdev);
>  	adapter_t *adapter = (adapter_t *)host->hostdata;
> -	char	buf[12] = { 0 };
>  
>  	scsi_remove_host(host);
>  
> @@ -4982,6 +4988,8 @@ megaraid_remove_one(struct pci_dev *pdev)
>  
>  #ifdef CONFIG_PROC_FS
>  	if (adapter->controller_proc_dir_entry) {
> +		char buf[12] = { 0 };
> +
>  		remove_proc_entry("stat", adapter->controller_proc_dir_entry);
>  		remove_proc_entry("config",
>  				adapter->controller_proc_dir_entry);
> diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
> --- a/drivers/scsi/megaraid.h
> +++ b/drivers/scsi/megaraid.h
> @@ -1002,7 +1002,9 @@ static int megaraid_reset(Scsi_Cmnd *);
>  static int megaraid_abort_and_reset(adapter_t *, Scsi_Cmnd *, int);
>  static int megaraid_biosparam(struct scsi_device *, struct block_device *,
>  		sector_t, int []);
> +#ifdef CONFIG_PROC_FS
>  static int mega_print_inquiry(char *, char *);
> +#endif
>  
>  static int mega_build_sglist (adapter_t *adapter, scb_t *scb,
>  			      u32 *buffer, u32 *length);
> @@ -1040,10 +1042,9 @@ static int proc_rdrv_20(char *, char **, off_t, int, int *, void *);
>  static int proc_rdrv_30(char *, char **, off_t, int, int *, void *);
>  static int proc_rdrv_40(char *, char **, off_t, int, int *, void *);
>  static int proc_rdrv(adapter_t *, char *, int, int);
> -#endif
> -
>  static int mega_adapinq(adapter_t *, dma_addr_t);
>  static int mega_internal_dev_inquiry(adapter_t *, u8, u8, dma_addr_t);
> +#endif
>  
>  static int mega_support_ext_cdb(adapter_t *);
>  static mega_passthru* mega_prepare_passthru(adapter_t *, scb_t *,
> -


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
