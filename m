Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbXEEQRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbXEEQRW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755589AbXEEQRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:17:21 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:58751
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580AbXEEQRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:17:18 -0400
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial
	possible bug]
From: Paul Fulghum <paulkf@microgate.com>
To: Antonino Ingargiola <tritemio@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <1178381287.3379.8.camel@x2>
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	 <1178299247.3769.0.camel@amdx2.microgate.com>
	 <5486cca80705041025k46ccf716t8dcd1e6f29e2376e@mail.gmail.com>
	 <1178300493.3619.1.camel@amdx2.microgate.com>
	 <5486cca80705041146x5c5bda70s96ce74e389cc1635@mail.gmail.com>
	 <5486cca80705041206q3a077dedyedb5ac2fbf434ba8@mail.gmail.com>
	 <1178308173.3743.14.camel@amdx2.microgate.com>
	 <5486cca80705041421y4fcaec01l7acafed1cea4b509@mail.gmail.com>
	 <463BC223.2040304@microgate.com> <1178353618.3472.1.camel@x2>
	 <5486cca80705050811k2903710y2bf9054434d8da4b@mail.gmail.com>
	 <463CB429.6050201@microgate.com>  <1178381287.3379.8.camel@x2>
Content-Type: text/plain
Date: Sat, 05 May 2007 11:15:39 -0500
Message-Id: <1178381739.3379.11.camel@x2>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-05 at 11:08 -0500, Paul Fulghum wrote:
> I would argue that cdc-acm should do the same as the serial driver.

Try this patch for the usb ports. (I don't have that hardware)

--- a/drivers/usb/class/cdc-acm.c	2007-04-25 22:08:32.000000000 -0500
+++ b/drivers/usb/class/cdc-acm.c	2007-05-05 11:12:10.000000000 -0500
@@ -355,18 +355,9 @@ next_buffer:
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


