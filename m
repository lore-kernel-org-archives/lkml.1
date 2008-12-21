Return-Path: <linux-kernel-owner+w=401wt.eu-S1752465AbYLUXqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbYLUXqm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 18:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYLUXqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 18:46:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435AbYLUXqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 18:46:32 -0500
Date: Sun, 21 Dec 2008 15:46:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Brownell <david-b@pacbell.net>
cc: Andrew Morton <akpm@linux-foundation.org>,
       spi-devel-general@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>,
       Vernon Sauder <vernoninhand@gmail.com>
Subject: Re: [patch 2.6.28-rc9] spi: spi_write_then_read() regression fix
In-Reply-To: <200812202332.36281.david-b@pacbell.net>
Message-ID: <alpine.LFD.2.00.0812211545520.24883@localhost.localdomain>
References: <200812202332.36281.david-b@pacbell.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 20 Dec 2008, David Brownell wrote:
> 
> All SPI transfers are full duplex, and are packaged as half duplex
> by either discarding the data that's read ("write only"), or else
> by writing zeroes ("read only").  That patch wasn't ensuring that
> zeroes were getting written out during the "half duplex read" part
> of the transaction; instead, old RX bits were getting sent.

Hmm. In addition, isn't this broken (in that same function):

        memcpy(local_buf, txbuf, n_tx);
        x.tx_buf = local_buf;
        x.rx_buf = local_buf;

        /* do the i/o */
        status = spi_sync(spi, &message);
        if (status == 0)
                memcpy(rxbuf, x.rx_buf + n_tx, n_rx);

shouldn't that 'rx_buf' setup be

	x.rx_buf = local_buf + n_tx;

since the whole point was that we allocated a buffer that can hold _both_ 
the rx and tx parts? Especially as that final copy into the resulting 
"rxbuf" thing uses that "+ n_tx" addition?

			Linus
