Return-Path: <linux-kernel-owner+w=401wt.eu-S1761102AbYFXQkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761102AbYFXQkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 12:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbYFXQkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 12:40:10 -0400
Received: from mail.gmx.net ([213.165.64.20]:41795 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751072AbYFXQkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 12:40:08 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/8tvAsstP88pazku4rP4O8576fWxh8KaRUdnlj2V
	Yo9CqcJSSyBtaQ
Date: Tue, 24 Jun 2008 18:40:28 +0200 (CEST)
From: Guennadi Liakhovetski <lg@denx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: David Brownell <david-b@pacbell.net>
Subject: SD card on an SPI bitbang interface (ppc4xx) not working
Message-ID: <Pine.LNX.4.64.0806241816010.18748@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to use an SPI bitbang driver for PPC4xx [1] to talk to an 
SD-card, and it doesn't work. Enabling debugging in the mmc-spi driver I 
first saw, that the mmc layer sends MMC_GO_IDLE_STATE several times during 
initialization, after which the card enters the idle state and needs time 
to recover, however, the driver doesn't wait and keeps sending further 
commands. I am not quite sure this is bad, because queries do get answered 
(with R1_SPI_IDLE bit set), still I somehow fixed that so, that the driver 
now always repeats sending SD_APP_OP_COND until the card leaves the idle 
state, and then the driver proceeds. I know this is probably not a correct 
fix - I don't have the MMC/SD spec, I only found [2], still now I see that 
indeed the card is given a chance to initialize before any further 
commands are attempted. But then I come to the next problem: when the 
driver requests the card ID with MMC_SEND_CID I get an error back:

mmc0: starting CMD59 arg 00000001 flags 00000080
mmc_spi spi0.51:   mmc_spi: CMD59, resp R1
mmc_spi spi0.51: spi_ppc4xx_setup: mode 0, 8 bpw, 400000 hz
mmc0: req done (CMD59): 0: 00000000 00000000 00000000 00000000
mmc_sd_init_card[376]
mmc0: starting CMD10 arg 00000000 flags 000000b5
mmc0:     blksz 16 blocks 1 flags 00000200 tsac 0 ms nsac 0
mmc_spi spi0.51:   mmc_spi: CMD10, resp R1
mmc_spi spi0.51:     mmc_spi: read block, 16 bytes
mmc_spi spi0.51: read error ffffff92 (-110)
mmc_spi spi0.51: read status -110
mmc_spi spi0.51: spi_ppc4xx_setup: mode 0, 8 bpw, 400000 hz
mmc0: req done (CMD10): 0: 00000000 00000000 00000000 00000000
mmc0:     0 bytes transferred: -110
mmc_send_cxd_data[259] data err -110, cmd err 0

Any idea? Unfortunately, I do not have another platform where I could 
verify spi-mmc. Maybe someone could send me a debug log of an SD-card 
initialization in such a host? David?

Thanks
Guennadi

[1] http://article.gmane.org/gmane.linux.kernel.mentors/638 (an earlier version)
[2] http://elm-chan.org/docs/mmc/mmc_e.html
---
Guennadi Liakhovetski, Ph.D.

DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
