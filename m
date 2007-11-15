Return-Path: <linux-kernel-owner+w=401wt.eu-S932980AbXKOVGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980AbXKOVGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:06:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763585AbXKOVGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:06:38 -0500
Received: from billgribble.com ([65.99.215.30]:50760 "EHLO
	server.billgribble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019AbXKOVGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:06:37 -0500
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2 libertas_sdio fails to initialize Marvell SD8686
References: <87bq9x264q.fsf@serrano.home.billgribble.com>
	<20071114190247.4f42aa05@poseidon.drzeus.cx>
From: Bill Gribble <grib@billgribble.com>
Date: Thu, 15 Nov 2007 16:06:23 -0500
In-Reply-To: <20071114190247.4f42aa05@poseidon.drzeus.cx> (Pierre Ossman's message of "Wed\, 14 Nov 2007 19\:02\:47 +0100")
Message-ID: <87ejernrqo.fsf@serrano.home.billgribble.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Thu Nov 15 15:06:31 2007
X-DSPAM-Confidence: 1.0000
X-DSPAM-Probability: 0.0023
X-DSPAM-Signature: 473cb4d712631010016558
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman <drzeus-mmc@drzeus.cx> writes:
>
>> Nov 13 14:40:09 pequin kernel: mmc0: starting CMD53 arg 9a000002 flags 000001b5
>> Nov 13 14:40:09 pequin kernel: mmc0:     blksz 32 blocks 2 flags 00000100 tsac 1000 ms nsac 0
>> Nov 13 14:40:09 pequin kernel: sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000001
>> Nov 13 14:40:11 pequin kernel: sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00108000
>> Nov 13 14:40:11 pequin kernel: mmc0: req done (CMD53): 0: 00002000 00000000 00000000 00000000
>> Nov 13 14:40:11 pequin kernel: mmc0:     32 bytes transferred: -110
>
> Your problem is here. The card chokes for some reason and times out when it's supposed to receive a chunk of the firmware. Odd, as the loading loop first queries the card if it is ready for more data.
>
> You could try adding a delay to the helper firmware loading loop (if_sdio_prog_helper() in if_sdio.c). Add an msleep(100); in there and see if that gets things further. Loading will be slow as hell though.

OK, that seems to at least change the failure a little :) I added an
msleep after line 466 of if_sdio.c (at the very bottom of the loop).

Now I don't get the final "32 bytes transferred: -110" error:

Nov 15 11:52:31 pequin kernel: mmc0: req done (CMD53): 0: 00002000 00000000 00000000 00000000
Nov 15 11:52:31 pequin kernel: mmc0:     64 bytes transferred: 0
Nov 15 11:52:31 pequin kernel: mmc0: starting CMD53 arg 9a000002 flags 000001b5
Nov 15 11:52:31 pequin kernel: mmc0:     blksz 32 blocks 2 flags 00000100 tsac 1000 ms nsac 0
Nov 15 11:52:31 pequin kernel: sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000001
Nov 15 11:52:31 pequin kernel: sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000002
Nov 15 11:52:31 pequin kernel: mmc0: req done (CMD53): 0: 00002000 00000000 00000000 00000000
Nov 15 11:52:31 pequin kernel: mmc0:     64 bytes transferred: 0
Nov 15 11:52:31 pequin kernel: mmc0: starting CMD52 arg 10002000 flags 00000195
Nov 15 11:52:31 pequin kernel: sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000001
Nov 15 11:52:31 pequin kernel: mmc0: req done (CMD52): 0: 00001000 00000000 00000000 00000000
Nov 15 11:52:31 pequin kernel: mmc0: starting CMD52 arg 10002200 flags 00000195
Nov 15 11:52:31 pequin kernel: sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000001
Nov 15 11:52:31 pequin kernel: mmc0: req done (CMD52): 0: 00001000 00000000 00000000 00000000
Nov 15 11:52:31 pequin kernel: mmc0: starting CMD52 arg 10002000 flags 00000195
Nov 15 11:52:31 pequin kernel: sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000001
Nov 15 11:52:31 pequin kernel: mmc0: req done (CMD52): 0: 00001000 00000000 00000000 00000000
Nov 15 11:52:31 pequin kernel: mmc0: starting CMD52 arg 10002200 flags 00000195


This block gets repeated about 200 times: 

Nov 15 11:52:31 pequin kernel: sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000001
Nov 15 11:52:31 pequin kernel: mmc0: req done (CMD52): 0: 00001000 00000000 00000000 00000000
Nov 15 11:52:31 pequin kernel: mmc0: starting CMD52 arg 10002000 flags 00000195

Then:

Nov 15 11:52:32 pequin kernel: sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000001
Nov 15 11:52:32 pequin kernel: mmc0: req done (CMD52): 0: 00001000 00000000 00000000 00000000
Nov 15 11:52:32 pequin kernel: mmc0: starting CMD52 arg 80022201 flags 00000195
Nov 15 11:52:32 pequin kernel: sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000001
Nov 15 11:52:32 pequin kernel: mmc0: req done (CMD52): 0: 00001001 00000000 00000000 00000000
Nov 15 11:52:32 pequin kernel: libertas: failed to load helper firmware
Nov 15 11:52:32 pequin kernel: SDIO: Disabling IRQ for mmc0:0001:1...
Nov 15 11:52:32 pequin kernel: mmc0: IRQ thread exiting with code 0
Nov 15 11:52:32 pequin kernel: mmc0: starting CMD52 arg 00000800 flags 00000195
Nov 15 11:52:32 pequin kernel: sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000001
Nov 15 11:52:32 pequin kernel: mmc0: req done (CMD52): 0: 00001003 00000000 00000000 00000000
Nov 15 11:52:32 pequin kernel: mmc0: starting CMD52 arg 80000800 flags 00000195
Nov 15 11:52:32 pequin kernel: sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000001
Nov 15 11:52:32 pequin kernel: mmc0: req done (CMD52): 0: 00001000 00000000 00000000 00000000
Nov 15 11:52:32 pequin kernel: SDIO: Disabling device mmc0:0001:1...
Nov 15 11:52:32 pequin kernel: mmc0: starting CMD52 arg 00000400 flags 00000195
Nov 15 11:52:32 pequin kernel: sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000001
Nov 15 11:52:32 pequin kernel: mmc0: req done (CMD52): 0: 00001002 00000000 00000000 00000000
Nov 15 11:52:32 pequin kernel: mmc0: starting CMD52 arg 80000400 flags 00000195
Nov 15 11:52:32 pequin kernel: sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000001
Nov 15 11:52:32 pequin kernel: mmc0: req done (CMD52): 0: 00001000 00000000 00000000 00000000
Nov 15 11:52:32 pequin kernel: SDIO: Disabled device mmc0:0001:1
Nov 15 11:52:32 pequin kernel: libertas_sdio: probe of mmc0:0001:1 failed with error -110

Does that make any sense?  

Thanks,
Bill Gribble

!DSPAM:473cb4d712631010016558!


