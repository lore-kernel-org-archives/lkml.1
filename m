Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbXLSQyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbXLSQyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 11:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbXLSQyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 11:54:39 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:38746 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbXLSQyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 11:54:38 -0500
Date: Wed, 19 Dec 2007 17:54:33 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Harald Welte <laforge@openmoko.org>
Cc: linux-kernel@vger.kernel.org, tk@maintech.de, ben-linux@fluff.org
Subject: Re: [PATCH] Samsung S3C24xx SD/MMC driver
Message-ID: <20071219175433.1ca7cd79@poseidon.drzeus.cx>
In-Reply-To: <20071219142213.GD29882@prithivi.gnumonks.org>
References: <20071219142213.GD29882@prithivi.gnumonks.org>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_hera.drzeus.cx-12515-1198083276-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-12515-1198083276-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, 19 Dec 2007 15:22:13 +0100
Harald Welte <laforge@openmoko.org> wrote:

> Hi!
> 
> This is a MMC/SD driver for the Samsung S3C24xx SD/MMC controller, originally
> developed years ago by Thomas Kleffel <tk@maintech.de>.
> 
> Due to time constraints, he had no time to further maintain the driver
> and follow the mainline Linux changes in the SD/MMC stack.
> 
> With his authorization, I have taken over the task of making it
> compliant to the current mainline SD/MMC API and take care of the
> mainline kernel merge.
> 
> So please advise on whatever changes you deem neccessary and I'll try to
> do my best to incorporate them for a hopefully not-too-distant mainline
> merge.
> 
> After a potential kernel inclusion, we would co-maintain the driver.
> 
> Acked-by: Thomas Kleffel <tk@maintech.de>
> Signed-off-by: Harald Welte <laforge@openmoko.org>
> 
> ---

Well, my biggest beef with this driver is the excessive debug code. I did a cleanup in an older version of the driver, but it shouldn't be to difficult to do the same for this one. I've included my patch for reference.

> Index: linux-2.6/drivers/mmc/host/s3cmci.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/drivers/mmc/host/s3cmci.c

> +#include <linux/mmc/mmc.h>

This is always a warning sign. It should never be needed in a host driver.


> +
> +static inline int get_data_buffer(struct s3cmci_host *host,
> +				  u32 *words, u32 **pointer)
> +{
> +	struct scatterlist *sg;
> +
> +	if (host->pio_active == XFER_NONE)
> +		return -EINVAL;
> +
> +	if ((!host->mrq) || (!host->mrq->data))
> +		return -EINVAL;
> +
> +	if (host->pio_sgptr >= host->mrq->data->sg_len) {
> +		dbg(host, dbg_debug, "no more buffers (%i/%i)\n",
> +		      host->pio_sgptr, host->mrq->data->sg_len);
> +		return -EBUSY;
> +	}
> +	sg = &host->mrq->data->sg[host->pio_sgptr];
> +
> +	*words = sg->length >> 2;
> +	*pointer = page_address(sg_page(sg)) + sg->offset;
> +

The length might not be a multiple of four. And it might also be completely unaligned. Make sure you can either handle such requests, or fail them with -EINVAL.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

--=_hera.drzeus.cx-12515-1198083276-0001-2
Content-Type: text/x-patch; name="s3c-dbg.patch"; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=s3c-dbg.patch

commit 4e47c91b7ca45940af384d3c9919a0eb160a2fb9
Author: Pierre Ossman <drzeus@drzeus.cx>
Date:   Fri Jun 1 08:19:15 2007 +0200

    s3mci: remove extra debug info
    
    Remove excessive and unmaintained debug strings. This kind of debug
    info should also be in the MMC layer, not drivers.
    
    Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>

diff --git a/drivers/mmc/Makefile b/drivers/mmc/Makefile
index 7c2eb45..42fa90f 100644
--- a/drivers/mmc/Makefile
+++ b/drivers/mmc/Makefile
@@ -30,6 +30,5 @@ mmc_core-y := mmc.o mmc_sysfs.o
 mmc_core-$(CONFIG_BLOCK) += mmc_queue.o
 
 ifeq ($(CONFIG_MMC_DEBUG),y)
-obj-$(CONFIG_MMC)		+= mmc_debug.o
 EXTRA_CFLAGS += -DDEBUG
 endif
diff --git a/drivers/mmc/mmc_debug.c b/drivers/mmc/mmc_debug.c
deleted file mode 100644
index f13e223..0000000
--- a/drivers/mmc/mmc_debug.c
+++ /dev/null
@@ -1,59 +0,0 @@
-/*
- *  linux/drivers/mmc/mmc_debug.c
- *
- *  Copyright (C) 2003 maintech GmbH, Thomas Kleffel <tk@maintech.de>
- *
- * This file contains debug helper functions for the MMC/SD stack
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-
-#include <linux/mmc/mmc.h>
-#include "mmc_debug.h"
-
-char *mmc_cmd2str(int cmd)
-{
-	switch(cmd) {
-		case  0: return "GO_IDLE_STATE";
-		case  1: return "ALL_SEND_OCR";
-		case  2: return "ALL_SEND_CID";
-		case  3: return "ALL_SEND_RELATIVE_ADD";
-		case  6: return "ACMD: SD_SET_BUSWIDTH";
-		case  7: return "SEL_DESEL_CARD";
-		case  9: return "SEND_CSD";
-		case 10: return "SEND_CID";
-		case 11: return "READ_UNTIL_STOP";
-		case 12: return "STOP_TRANSMISSION";
-		case 13: return "SEND_STATUS";
-		case 15: return "GO_INACTIVE_STATE";
-		case 16: return "SET_BLOCKLEN";
-		case 17: return "READ_SINGLE_BLOCK";
-		case 18: return "READ_MULTIPLE_BLOCK";
-		case 24: return "WRITE_SINGLE_BLOCK";
-		case 25: return "WRITE_MULTIPLE_BLOCK";
-		case 41: return "ACMD: SD_APP_OP_COND";
-		case 55: return "APP_CMD";
-		default: return "UNKNOWN";
-	}
-}
-EXPORT_SYMBOL(mmc_cmd2str);
-
-char *mmc_err2str(int err)
-{
-	switch(err) {
-		case MMC_ERR_NONE:	return "OK";
-		case MMC_ERR_TIMEOUT:	return "TIMEOUT";
-		case MMC_ERR_BADCRC: 	return "BADCRC";
-		case MMC_ERR_FIFO: 	return "FIFO";
-		case MMC_ERR_FAILED: 	return "FAILED";
-		case MMC_ERR_INVALID: 	return "INVALID";
-		case MMC_ERR_BUSY:	return "BUSY";
-		case MMC_ERR_DMA:	return "DMA";
-		case MMC_ERR_CANCELED:	return "CANCELED";
-		default: return "UNKNOWN";
-	}
-}
-EXPORT_SYMBOL(mmc_err2str);
diff --git a/drivers/mmc/mmc_debug.h b/drivers/mmc/mmc_debug.h
deleted file mode 100644
index 5a84852..0000000
--- a/drivers/mmc/mmc_debug.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef MMC_DEBUG_H
-#define MMC_DEBUG_H
-
-char *mmc_cmd2str(int err);
-char *mmc_err2str(int err);
-
-#endif /* MMC_DEBUG_H */
diff --git a/drivers/mmc/s3cmci.c b/drivers/mmc/s3cmci.c
index 9b15310..4069f50 100644
--- a/drivers/mmc/s3cmci.c
+++ b/drivers/mmc/s3cmci.c
@@ -24,7 +24,6 @@
 #include <asm/arch/regs-gpio.h>
 #include <asm/arch/mci.h>
 
-#include "mmc_debug.h"
 #include "s3cmci.h"
 
 #define DRIVER_NAME "s3c-mci"
@@ -106,8 +105,8 @@ static void prepare_dbgmsg(struct s3cmci_host *host, struct mmc_command *cmd,
 								int stop)
 {
  	snprintf(host->dbgmsg_cmd, 300,
-		"#%u%s op:%s(%i) arg:0x%08x flags:0x08%x retries:%u",
-		host->ccnt, (stop?" (STOP)":""), mmc_cmd2str(cmd->opcode),
+		"#%u%s op:CMD%d arg:0x%08x flags:0x08%x retries:%u",
+		host->ccnt, (stop?" (STOP)":""),
 		cmd->opcode, cmd->arg, cmd->flags, cmd->retries);
 
 	if (cmd->data) {
@@ -134,20 +133,18 @@ static void dbg_dumpcmd(struct s3cmci_host *host, struct mmc_command *cmd,
 		dbg(host, dbglvl, "CMD[OK] %s R0:0x%08x\n",
 			host->dbgmsg_cmd, cmd->resp[0]);
 	} else {
-		dbg(host, dbglvl, "CMD[%s] %s Status:%s\n",
-			mmc_err2str(cmd->error), host->dbgmsg_cmd,
-			host->status);
+		dbg(host, dbglvl, "CMD[FAIL(%d)] %s Status:%s\n",
+			cmd->error, host->dbgmsg_cmd, host->status);
 	}
 
 	if (!cmd->data)
 		return;
 
 	if (cmd->data->error == MMC_ERR_NONE) {
-		dbg(host, dbglvl, "DAT[%s] %s\n",
-			mmc_err2str(cmd->data->error), host->dbgmsg_dat);
+		dbg(host, dbglvl, "DAT[OK] %s\n", host->dbgmsg_dat);
 	} else {
-		dbg(host, dbglvl, "DAT[%s] %s DCNT:0x%08x\n",
-			mmc_err2str(cmd->data->error), host->dbgmsg_dat,
+		dbg(host, dbglvl, "DAT[FAIL(%d)] %s DCNT:0x%08x\n",
+			cmd->data->error, host->dbgmsg_dat,
 			readl(host->base + S3C2410_SDIDCNT));
 	}
 }

--=_hera.drzeus.cx-12515-1198083276-0001-2--
