Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbYIWVZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbYIWVZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755749AbYIWVZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:25:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:49541 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329AbYIWVZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:25:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=XwKrbtOj0OwXNJlYN99hMlvv+gfAw/Y+NtQjW1qrcRukUurJmL9yxe9X6LL8pDYFRl
         MuiEKva5ZDTZAqbJi2CvqZm9i/iBvYb74aAZKGCRvc78RdaftbFYvB4O2zBHl6nNo4UZ
         9HBzrBOq4fWmf5OUWUNdPpHl0BgKc8Dgy2xtY=
Date: Tue, 23 Sep 2008 23:24:59 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx
Subject: SDHCI: timeout during data transfer
Message-ID: <20080923212459.GA13888@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I'm seeing timeout errors when transfering "big" (over 1MB or so) files to a SD
card (small files are ok):

[  251.956666] mmcblk0: error -110 transferring data
[  251.979810] end_request: I/O error, dev mmcblk0, sector 1572758
[  251.981477] Buffer I/O error on device mmcblk0p1, logical block 1572742
[  251.983198] lost page write due to I/O error on mmcblk0p1
[  251.983788] end_request: I/O error, dev mmcblk0, sector 1572759
[  251.983788] Buffer I/O error on device mmcblk0p1, logical block 1572743
[  251.983788] lost page write due to I/O error on mmcblk0p1
[  251.983788] end_request: I/O error, dev mmcblk0, sector 1572760
[  251.983788] Buffer I/O error on device mmcblk0p1, logical block 1572744
[  251.983788] lost page write due to I/O error on mmcblk0p1
[  251.983788] end_request: I/O error, dev mmcblk0, sector 1572761
[  251.983788] Buffer I/O error on device mmcblk0p1, logical block 1572745
[  251.983788] lost page write due to I/O error on mmcblk0p1
[  253.513336] mmcblk0: error -110 transferring data
(trashed FS here)

kernel in use is 2.6.27-rc6, and this is the controller:

09:01.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 22)
09:01.2 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev 12)
09:01.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 12)
09:01.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 12)

Googling around I found a patch[1] that introduced a quirk to address an
off-by-one issue for the timeout value in certain controllers.

With this patch:

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index e3a8133..46899ee 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -575,7 +575,7 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
 	host->data = data;
 	host->data_early = 0;
 
-	count = sdhci_calc_timeout(host, data);
+	count = sdhci_calc_timeout(host, data) + 1;
 	writeb(count, host->ioaddr + SDHCI_TIMEOUT_CONTROL);
 
 	if (host->flags & SDHCI_USE_DMA)

I don't see timeouts anymore (just for reference, I'm not suggesting to apply it
as-is).

Luca
[1] http://www.gossamer-threads.com/lists/linux/kernel/937056
-- 
Dicono che  il cane sia  il miglior  amico dell'uomo. Secondo me  non e`
vero. Quanti dei vostri amici avete fatto castrare, recentemente?
