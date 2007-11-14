Return-Path: <linux-kernel-owner+w=401wt.eu-S1758181AbXKNSDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbXKNSDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 13:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759330AbXKNSCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 13:02:51 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:57376 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758181AbXKNSCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 13:02:50 -0500
Date: Wed, 14 Nov 2007 19:02:47 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Bill Gribble <grib@billgribble.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2 libertas_sdio fails to initialize Marvell SD8686
Message-ID: <20071114190247.4f42aa05@poseidon.drzeus.cx>
In-Reply-To: <87bq9x264q.fsf@serrano.home.billgribble.com>
References: <87bq9x264q.fsf@serrano.home.billgribble.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 16:21:57 -0500
Bill Gribble <grib@billgribble.com> wrote:

> 
> After the first time I saw the line "Failed to load helper firmware" I
> downloaded fresh copies of the firmware from Marvell and installed
> them in /lib/firmware to paths as indicated in the module source:
> 
> -rwxr-xr-x 1 root root 120716 Nov 12 12:35 sd8686.bin
> -rwxr-xr-x 1 root root   2140 Nov 12 12:36 sd8686_helper.bin
> 
> Having those there doesn't seem to change anything.
> 

Marvell tend to not have a one true firmware, but one for each device, so you might end up having to dig out the ones shipped with the device.

Still, my understanding is that the device won't boot the helper firmware until it is entirely loaded, so that shouldn't be the problem.

> Nov 13 14:40:09 pequin kernel: mmc0: starting CMD53 arg 9a000002 flags 000001b5
> Nov 13 14:40:09 pequin kernel: mmc0:     blksz 32 blocks 2 flags 00000100 tsac 1000 ms nsac 0
> Nov 13 14:40:09 pequin kernel: sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000001
> Nov 13 14:40:11 pequin kernel: sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00108000
> Nov 13 14:40:11 pequin kernel: mmc0: req done (CMD53): 0: 00002000 00000000 00000000 00000000
> Nov 13 14:40:11 pequin kernel: mmc0:     32 bytes transferred: -110

Your problem is here. The card chokes for some reason and times out when it's supposed to receive a chunk of the firmware. Odd, as the loading loop first queries the card if it is ready for more data.

You could try adding a delay to the helper firmware loading loop (if_sdio_prog_helper() in if_sdio.c). Add an msleep(100); in there and see if that gets things further. Loading will be slow as hell though.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
