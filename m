Return-Path: <linux-kernel-owner+w=401wt.eu-S1758507AbYKVPIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507AbYKVPIA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 10:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758204AbYKVPHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 10:07:50 -0500
Received: from harold.telenet-ops.be ([195.130.133.65]:40604 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758201AbYKVPHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 10:07:49 -0500
Date: Sat, 22 Nov 2008 16:07:46 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: vme_scc.c breakage (was: Re: linux-next: Tree for November 21)
In-Reply-To: <20081121181948.ee771502.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0811221558340.30025@anakin>
References: <20081121181948.ee771502.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Alan,

drivers/char/vme_scc.c no longer compiles in linux-next:
http://kisskb.ellerman.id.au/kisskb/buildresult/56964/

I get a slightly different error message, though:

| drivers/char/vme_scc.c: In function 'scc_carrier_raised':
| drivers/char/vme_scc.c:634: error: expected identifier or '(' before 'volatile'
| drivers/char/vme_scc.c:634: error: expected ')' before '(' token
| drivers/char/vme_scc.c:634: error: expected statement before ')' token
| drivers/char/vme_scc.c:635: error: 'struct tty_port' has no member named 'channel'

The problem seems to be introduced by commit
e21405cbbaa859c68119b260c0fe43afdb86a385 ("tty-port-extract-cd"). The relevant
part is below:

| diff --git a/drivers/char/vme_scc.c b/drivers/char/vme_scc.c
| index 1718b3c..d4e1534 100644
| --- a/drivers/char/vme_scc.c
| +++ b/drivers/char/vme_scc.c
| @@ -624,9 +629,9 @@ static void scc_enable_rx_interrupts(void *ptr)
|  }
|  
|  
| -static int scc_get_CD(void *ptr)
| +static int scc_carrier_raised(struct tty_port *port)
|  {
| -	struct scc_port *port = ptr;
| +	struct scc_port *scc = container_of(port, struct scc_port, gs.port);
|  	unsigned channel = port->channel;
|  
|  	return !!(scc_last_status_reg[channel] & SR_DCD);

Issues:
  1. When Atari support is enabled, `scc' is defined in
     include/asm-m68k/atari.h as:

	# define scc ((*(volatile struct SCC*)SCC_BAS))

     However, renaming the variable `scc' doesn't help, as

  2. the variable `scc' is not used in scc_carrier_raised(),

  3. `port->channel' on line 635 still fails as `port' is not longer `struct
     scc_port', but a 'struct tty_port', which has no member named 'channel'.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
