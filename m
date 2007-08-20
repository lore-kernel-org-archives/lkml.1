Return-Path: <linux-kernel-owner+w=401wt.eu-S1761925AbXHTRLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761925AbXHTRLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 13:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756023AbXHTRLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 13:11:35 -0400
Received: from tayrelbas01.tay.hp.com ([161.114.80.244]:46329 "EHLO
	tayrelbas01.tay.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722AbXHTRLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 13:11:34 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [2.6.23-rc3 possible regression] 8250 claims nonexisting device blocking IO port
Date: Mon, 20 Aug 2007 11:11:18 -0600
User-Agent: KMail/1.9.6
Cc: linux-serial@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
References: <200708181107.56087.arvidjaar@mail.ru> <200708192147.47433.bjorn.helgaas@hp.com> <200708202028.22806.arvidjaar@mail.ru>
In-Reply-To: <200708202028.22806.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708201111.19023.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 August 2007 10:28:22 am Andrey Borzenkov wrote:
> This worked in 2.6.22 with the same quirks. I will test without later but I 
> fail to see how they are related.

OK, let me know what happens.  The way it's related is that the quirk
fiddles with the IRDA device, and it probably changes the SIR config
so that it starts responding at the ttyS3 address.  In your 2.6.23
log, I see this:

[  512.476243] pnp: Device 00:0a activated.
[  512.476301]  00:0a: SMCf010 not responding at SIR 0x100, FIR 0x2e8; auto-configuring
[  512.477861] pnp: Device 00:0a disabled.
[  512.483492] pnp: Device 00:0a activated.
[  512.483520]  00:0a: not responding at SIR 0x100, FIR 0x2e8; swapping SIR/FIR and reconfiguring
[  512.485056] pnp: Device 00:0a disabled.
[  512.491652] pnp: Device 00:0a activated.
[  512.491679]  00:0a: responds at SIR 0x2e8, FIR 0x100

After the quirk, the FIR part is enabled at 0x100 and we assume (the
quirk doesn't actually check) the SIR part is enabled at 0x2e8.  The
8250 driver will claim a SIR device at 0x2e8 as ttyS3.

Without the quirk, the SIR device seems to be either at 0x100 (where
the 8250 driver will not look) or is not enabled at all.

Bjorn
