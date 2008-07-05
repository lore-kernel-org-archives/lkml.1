Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbYGEASV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbYGEASV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 20:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbYGEASO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 20:18:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:61588 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbYGEASN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 20:18:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:mime-version
         :content-type:message-id;
        b=Wpo9WqD+gENNgsuXpDETigUZZFZVWGOY7510zIUYOGuvozg8Linv8KJuXLj5ESJ8b1
         YVfHmsvlUxDfXZpQqf+rpHnWri5YVJXEJD5izMDzGBjGqwp5rU3X4ubQJgrJH83YaQKu
         NlSBNX9RMJaQhoORtv3bpFEvk97bHaNcQfAlA=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix misalignment in pxamci
Date: Sat, 5 Jul 2008 02:19:52 +0200
User-Agent: KMail/1.9.9
Cc: drzeus-mmc@drzeus.cx
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_o4rbIEEDDOD0/xe"
Message-Id: <200807050219.52218.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_o4rbIEEDDOD0/xe
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
Philipp Zabel finally made the pxamci issue clear. It turned out, that pxamci 
needs the DMA destination address to be aligned to 8 bytes. In some cases it 
happened, that the address was aligned to 4 bytes causing controller to 
incorrectly transfer data (and resulting into error like "mmc0: unrecognised 
SCR structure version 1"). The following patch allows to debug this issue and 
moreover fixes it by moving one 4 byte entry of mmc_card structure, aligning 
the DMA destination back to 8 bytes.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>

--Boundary-00=_o4rbIEEDDOD0/xe
Content-Type: text/x-diff;
  charset="us-ascii";
  name="pxamci-lkml.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="pxamci-lkml.patch"

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 65210fc..75b2810 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -153,6 +153,13 @@ static void pxamci_setup_data(struct pxamci_host *host, struct mmc_data *data)
 		if (length & 31 && !(data->flags & MMC_DATA_READ))
 			host->sg_cpu[i].dcmd |= DCMD_ENDIRQEN;
 		if (data->flags & MMC_DATA_READ) {
+#ifdef CONFIG_MMC_DEBUG
+			/* we need destination address to be aligned to 8 bytes
+			   here, if it isn't, we have serious problem */
+			if (sg_dma_address(&data->sg[i]) % 8)
+				pr_debug("%s:%i Misaligned DMA destination\n",
+					__FILE__, __LINE__);
+#endif
 			host->sg_cpu[i].dsadr = host->res->start + MMC_RXFIFO;
 			host->sg_cpu[i].dtadr = sg_dma_address(&data->sg[i]);
 		} else {
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 0d508ac..cb76462 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -89,6 +89,7 @@ struct mmc_card {
 #define MMC_TYPE_MMC		0		/* MMC card */
 #define MMC_TYPE_SD		1		/* SD card */
 #define MMC_TYPE_SDIO		2		/* SDIO card */
+	unsigned int		sdio_funcs;	/* number of SDIO functions */
 	unsigned int		state;		/* (our) card state */
 #define MMC_STATE_PRESENT	(1<<0)		/* present in sysfs */
 #define MMC_STATE_READONLY	(1<<1)		/* card is read-only */
@@ -104,7 +105,6 @@ struct mmc_card {
 	struct sd_scr		scr;		/* extra SD information */
 	struct sd_switch_caps	sw_caps;	/* switch (CMD6) caps */
 
-	unsigned int		sdio_funcs;	/* number of SDIO functions */
 	struct sdio_cccr	cccr;		/* common card info */
 	struct sdio_cis		cis;		/* common tuple info */
 	struct sdio_func	*sdio_func[SDIO_MAX_FUNCS]; /* SDIO functions (devices) */

--Boundary-00=_o4rbIEEDDOD0/xe--
