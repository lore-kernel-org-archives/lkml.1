Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbYFNVf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbYFNVf3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 17:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbYFNVfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 17:35:13 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:52827 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796AbYFNVfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 17:35:11 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug 10819] Fatal DMA error with b43 driver since 2.6.26
Date: Sat, 14 Jun 2008 23:34:22 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Christian Casteyde" <casteyde.christian@free.fr>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik> <Jn7irxIunJK.A.jVE.kJDVIB@albercik>
In-Reply-To: <Jn7irxIunJK.A.jVE.kJDVIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806142334.22693.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 June 2008 22:12:03 Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10819
> Subject		: Fatal DMA error with b43 driver since 2.6.26
> Submitter	: Christian Casteyde <casteyde.christian@free.fr>
> Date		: 2008-05-29 13:16 (17 days old)


This regression is fixed by
21691a38db9d465a109c5ec25cd3956a18cfcf5d

Author: Michael Buesch <mb@bu3sch.de>  2008-06-12 15:33:13
Committer: John W. Linville <linville@tuxdriver.com>  2008-06-14 01:18:58
Parent: 9983f35f12b8be71d13b8aca6dbf781d3342c7aa (rt2x00: LEDS build failure)
Child:  33593dbf334869456167bc66511bc54c4ba39dc5 (mac80211 : fix for iwconfig in ad-hoc mode)
Branches: master, remotes/origin/master
Follows: merge-2008-06-14
Precedes: master-2008-06-14

    ssb: Fix coherent DMA mask for PCI devices
    
    This fixes setting the coherent DMA mask for PCI devices.
    
    Signed-off-by: Michael Buesch <mb@bu3sch.de>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

------------------------------ drivers/ssb/main.c ------------------------------
index 7cf8851..d184f2a 100644
@@ -1168,15 +1168,21 @@ EXPORT_SYMBOL(ssb_dma_translation);
 int ssb_dma_set_mask(struct ssb_device *ssb_dev, u64 mask)
 {
 	struct device *dma_dev = ssb_dev->dma_dev;
+	int err = 0;
 
 #ifdef CONFIG_SSB_PCIHOST
-	if (ssb_dev->bus->bustype == SSB_BUSTYPE_PCI)
-		return dma_set_mask(dma_dev, mask);
+	if (ssb_dev->bus->bustype == SSB_BUSTYPE_PCI) {
+		err = pci_set_dma_mask(ssb_dev->bus->host_pci, mask);
+		if (err)
+			return err;
+		err = pci_set_consistent_dma_mask(ssb_dev->bus->host_pci, mask);
+		return err;
+	}
 #endif
 	dma_dev->coherent_dma_mask = mask;
 	dma_dev->dma_mask = &dma_dev->coherent_dma_mask;
 
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL(ssb_dma_set_mask);
 



-- 
Greetings Michael.
