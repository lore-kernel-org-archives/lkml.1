Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088Ab0ASJsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab0ASJsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 04:48:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755673Ab0ASJsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 04:48:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46202
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755358Ab0ASJsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 04:48:01 -0500
Date: Tue, 19 Jan 2010 01:48:10 -0800 (PST)
Message-Id: <20100119.014810.05382307.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 50/64] ide-timings: use ->pio_mode value to determine
 fastest PIO speed
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100118172058.14623.81306.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
	<20100118172058.14623.81306.sendpatchset@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Mon, 18 Jan 2010 18:20:58 +0100

> @@ -189,8 +189,7 @@ int ide_timing_compute(ide_drive_t *driv
>  	 * DMA cycle timing is slower/equal than the fastest PIO timing.
>  	 */
>  	if (speed >= XFER_SW_DMA_0) {
> -		u8 pio = ide_get_best_pio_mode(drive, 255, 5);
> -		ide_timing_compute(drive, XFER_PIO_0 + pio, &p, T, UT);
> +		ide_timing_compute(drive, drive->pio_mode, &p, T, UT);
>  		ide_timing_merge(&p, t, t, IDE_TIMING_ALL);
>  	}
>  

The comment above this code should be changed to match
the new behavior.

I've done that for you when checking this in, as follows:

ide-timings: use ->pio_mode value to determine fastest PIO speed

Use the current PIO mode value instead of the physical maximum one
to determine the fastest allowed PIO for shared PIO/DMA timings.

Affected host drivers: amd74xx and via82cxxx.

[ Update comment to match -DaveM ]

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/ide/ide-timings.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/ide-timings.c b/drivers/ide/ide-timings.c
index c6053ab..c7a65ee 100644
--- a/drivers/ide/ide-timings.c
+++ b/drivers/ide/ide-timings.c
@@ -186,11 +186,10 @@ int ide_timing_compute(ide_drive_t *drive, u8 speed,
 	/*
 	 * Even in DMA/UDMA modes we still use PIO access for IDENTIFY,
 	 * S.M.A.R.T and some other commands. We have to ensure that the
-	 * DMA cycle timing is slower/equal than the fastest PIO timing.
+	 * DMA cycle timing is slower/equal than the current PIO timing.
 	 */
 	if (speed >= XFER_SW_DMA_0) {
-		u8 pio = ide_get_best_pio_mode(drive, 255, 5);
-		ide_timing_compute(drive, XFER_PIO_0 + pio, &p, T, UT);
+		ide_timing_compute(drive, drive->pio_mode, &p, T, UT);
 		ide_timing_merge(&p, t, t, IDE_TIMING_ALL);
 	}
 
-- 
1.6.5

