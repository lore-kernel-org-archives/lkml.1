Return-Path: <linux-kernel-owner+w=401wt.eu-S933630AbXEERGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933630AbXEERGR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 13:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933631AbXEERGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 13:06:17 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:40897
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933630AbXEERGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 13:06:16 -0400
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial
	possible bug]
From: Paul Fulghum <paulkf@microgate.com>
To: Antonino Ingargiola <tritemio@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <5486cca80705050958g397db6fepbe1e62b7e190a3f@mail.gmail.com>
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	 <1178308173.3743.14.camel@amdx2.microgate.com>
	 <5486cca80705041421y4fcaec01l7acafed1cea4b509@mail.gmail.com>
	 <463BC223.2040304@microgate.com> <1178353618.3472.1.camel@x2>
	 <5486cca80705050811k2903710y2bf9054434d8da4b@mail.gmail.com>
	 <463CB429.6050201@microgate.com> <1178381287.3379.8.camel@x2>
	 <1178381739.3379.11.camel@x2>
	 <5486cca80705050926j5c33eaf3m8723b76d4759fc5a@mail.gmail.com>
	 <5486cca80705050958g397db6fepbe1e62b7e190a3f@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 05 May 2007 12:04:35 -0500
Message-Id: <1178384675.3379.26.camel@x2>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-05 at 18:58 +0200, Antonino Ingargiola wrote:
> This patch does not solve the problem with the cdc_acd driver. I still
> need to flush two times to really flush the input. And the "secondary
> buffer" still seems 26 bytes (as before).

I missed a bit, try this.

--- a/drivers/usb/class/cdc-acm.c	2007-04-25 22:08:32.000000000 -0500
+++ b/drivers/usb/class/cdc-acm.c	2007-05-05 12:03:19.000000000 -0500
@@ -335,8 +335,6 @@ static void acm_rx_tasklet(unsigned long
 	spin_lock_irqsave(&acm->throttle_lock, flags);
 	throttled = acm->throttle;
 	spin_unlock_irqrestore(&acm->throttle_lock, flags);
-	if (throttled)
-		return;
 
 next_buffer:
 	spin_lock_irqsave(&acm->read_lock, flags);
@@ -355,18 +353,9 @@ next_buffer:
 	spin_lock_irqsave(&acm->throttle_lock, flags);
 	throttled = acm->throttle;
 	spin_unlock_irqrestore(&acm->throttle_lock, flags);
-	if (!throttled)
-		tty_insert_flip_string(tty, buf->base, buf->size);
+	tty_insert_flip_string(tty, buf->base, buf->size);
 	tty_flip_buffer_push(tty);
 
-	if (throttled) {
-		dbg("Throttling noticed");
-		spin_lock_irqsave(&acm->read_lock, flags);
-		list_add(&buf->list, &acm->filled_read_bufs);
-		spin_unlock_irqrestore(&acm->read_lock, flags);
-		return;
-	}
-
 	spin_lock_irqsave(&acm->read_lock, flags);
 	list_add(&buf->list, &acm->spare_read_bufs);
 	spin_unlock_irqrestore(&acm->read_lock, flags);


