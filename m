Return-Path: <linux-kernel-owner+w=401wt.eu-S1761567AbXGXQAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567AbXGXQAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 12:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbXGXQAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 12:00:08 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:17120 "EHLO
	outbound3-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754270AbXGXQAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 12:00:05 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Tue, 24 Jul 2007 09:59:52 -0600
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: bunk@stusta.de
cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: drivers/ide/pci/cs5535.c: array overrun
Message-ID: <20070724155952.GA13874@cosmic.amd.com>
References: <06FDA0246543E443ABBB36B1FCD5CC0603CF3360@SAUSEXMB2.amd.com>
MIME-Version: 1.0
In-Reply-To: <20070724124524.GA6019@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 24 Jul 2007 15:59:44.0864 (UTC)
 FILETIME=[A735EE00:01C7CE0B]
X-WSS-ID: 6AB8FE7A0X82388140-14-01
Content-Type: multipart/mixed;
 boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

> The Coverity checker spotted the following array overrun in 
> drivers/ide/pci/cs5535.c:

<-- snip -->

>	if (speed >= XFER_UDMA_0 && speed <= XFER_UDMA_7)
>		reg |= cs5535_udma_timings[speed - XFER_UDMA_0];

Fix is attached.  Somebody got overzealous - the 5535 only supports
up to UDMA4, which matches the array.

Jordan
-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.

--PEIAKu/WMn1b1Hv9
Content-Type: text/x-diff;
 charset=us-ascii
Content-Disposition: inline;
 filename=5535-fix-overrun.patch
Content-Transfer-Encoding: 7bit

[PATCH] Fix an ovverun found in the 5535 IDE driver

From: Jordan Crouse <jordan.crouse@amd.com>

As found by the Coverity checker, and reported by Adrian Bunk, this
fixes a overrun error in the 5535 IDE driver.  Somebody got a little
excited with the if() statement - the 5535 only supports UDMA 0-4.

Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
---

 drivers/ide/pci/cs5535.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/pci/cs5535.c b/drivers/ide/pci/cs5535.c
index ce44e38..9bd526d 100644
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -116,7 +116,7 @@ static void cs5535_set_speed(ide_drive_t *drive, u8 speed)
 
 		reg &= 0x80000000UL;  /* Preserve the PIO format bit */
 
-		if (speed >= XFER_UDMA_0 && speed <= XFER_UDMA_7)
+		if (speed >= XFER_UDMA_0 && speed <= XFER_UDMA_4)
 			reg |= cs5535_udma_timings[speed - XFER_UDMA_0];
 		else if (speed >= XFER_MW_DMA_0 && speed <= XFER_MW_DMA_2)
 			reg |= cs5535_mwdma_timings[speed - XFER_MW_DMA_0];

--PEIAKu/WMn1b1Hv9--


