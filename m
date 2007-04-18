Return-Path: <linux-kernel-owner+w=401wt.eu-S2993045AbXDRTIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993045AbXDRTIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 15:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993048AbXDRTIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 15:08:44 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54357 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993045AbXDRTIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 15:08:43 -0400
Date: Wed, 18 Apr 2007 20:12:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Corey Minyard <minyard@acm.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org
Subject: Re: [PATCH] Provide better abstraction for the serial drivers to
 xmit buf and tty
Message-ID: <20070418201205.60afc606@the-village.bc.nu>
In-Reply-To: <4626442B.5050708@acm.org>
References: <20070418045423.GA12136@localdomain>
	<20070418102027.0e1edb2b@the-village.bc.nu>
	<4626442B.5050708@acm.org>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Currently the uart_info structure is allocated on an open, so it's not
> available until that point in time.  The trouble is that console_init() is
> called before memory is set up, so you can't allocate the uart_info
> until it's too late for the console or a debugger that wants to work
> early, though it's ok for IPMI.

A debugger can provide a pre-existing uart_info and buffer. The
initialisation is only done if the uart_state->info pointer is NULL.

> The uart_info struct is not very big, maybe it would be best to pull that
> into uart_port?  But the circ buffer might still be a problem, since it
> would need to be dynamically allocated and it might need to be
> checked instead.

How about this (untested idea in the finest Linux tradition)

Add

uart_console_prepare(struct uart_port *port, struct uart_info
*info, void *buffer)
{
	port->info = info;
	info->xmit.buf = buffer;
	... etc ...
	info->flags |= UPF_BOOTALLOCATED;
}


in uart_shutdown() check UPF_BOOTALLOCATED and don't free xmit.buf if so.

ditto in uart_remove_one_port for info itself


