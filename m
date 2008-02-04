Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbYBDUZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbYBDUZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 15:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758685AbYBDUZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 15:25:28 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:59354 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758668AbYBDUZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 15:25:25 -0500
Date: Mon, 4 Feb 2008 21:25:23 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: michael <trimarchi@gandalf.sssup.it>
Cc: Remy Bohmer <linux@bohmer.net>, fabio@gandalf.sssup.it,
       Andrew Victor <linux@maxim.org.za>, Chip Coldwell <coldwell@redhat.com>,
       Marc Pignat <marc.pignat@hevs.ch>, David Brownell <david-b@pacbell.net>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -mm v4 6/9] atmel_serial: Split the interrupt handler
Message-ID: <20080204212523.07a6da9e@siona>
In-Reply-To: <47A76106.3000103@gandalf.sssup.it>
References: <20080129224316.GA23155@gandalf.sssup.it>
	<479FB2D7.4020804@gandalf.sssup.it>
	<20080130104113.48ec376f@dhcp-252-066.norway.atmel.com>
	<47A051A7.7030004@gandalf.sssup.it>
	<20080130133659.55ebd828@dhcp-252-066.norway.atmel.com>
	<47A09723.7020000@gandalf.sssup.it>
	<20080130164631.7de4f6bd@dhcp-252-066.norway.atmel.com>
	<47A12A2E.5040309@gandalf.sssup.it>
	<20080131160721.6dddf30e@dhcp-252-066.norway.atmel.com>
	<47A76106.3000103@gandalf.sssup.it>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Feb 2008 20:01:26 +0100
michael <trimarchi@gandalf.sssup.it> wrote:

> I think the the atmel_interrupt handler 
> must check the
> pass_counter before return IRQ_HANDLED.

I'm not sure if it helps in this particular case but yeah, since the
interrupt may be shared, it's definitely wrong to always return
IRQ_HANDLED.

Nice catch. Could you try the patch below?

Haavard

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index cb70cc5..f310a80 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -552,7 +552,7 @@ static irqreturn_t atmel_interrupt(int irq, void *dev_id)
 		atmel_handle_transmit(port, pending);
 	} while (pass_counter++ < ATMEL_ISR_PASS_LIMIT);
 
-	return IRQ_HANDLED;
+	return pass_counter ? IRQ_HANDLED : IRQ_NONE;
 }
 
 /*
