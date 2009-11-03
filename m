Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbZKCMEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbZKCMEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 07:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbZKCMEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 07:04:48 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39759 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753621AbZKCMEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 07:04:46 -0500
Date: Tue, 3 Nov 2009 12:06:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Alan Cox <alan@linux.intel.com>, linux-mmc@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, dhowells@redhat.com
Subject: Re: [PATCH 0/6] Clean up the sdio_uart driver and fix the tty code
Message-ID: <20091103120618.26b669be@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0911021542520.13333@xanadu.home>
References: <20091102164039.11877.88825.stgit@localhost.localdomain>
	<alpine.LFD.2.00.0911021243040.13333@xanadu.home>
	<20091102191604.010acbc9@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.0911021542520.13333@xanadu.home>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> With this folded in, the card does work with the full series applied.  
> However the kernel is now crashing when the card is pulled out while 
> some process is reading from the device.  This used to behave well 
> before. I don't have time to investigate that one right now though.

Going through it I found one assumption in the tty_port code that wanted
fixing. We would release the port and then try to change the modem lines.

The dtr_rts method didn't claim the function which in conjunction with
that made it crash.

Also the hangup checked your old port->opened which now never got set.

I am scratching my head over some of the other stuff I found however. In
particular port->func can be set to NULL when the device is removed.

The claim method takes the mutex, checks if it is NULL and acts
accordingly but it releases the mutex, which makes it useless as the code
then uses port->func. If I move the release of the mutex to the
release_func method then that fixes almost all cases.

The one I'm stuck on is this


		CPU1				CPU2


	sdio_uart_irq
					sdio_uart_port_remove
					port->func = NULL;
	sdio_in
	BUG_ON


I'm not sure what the required rules on the irq disable/remove are meant
to be here ?

Alan
