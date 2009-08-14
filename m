Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbZHNVTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbZHNVTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 17:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755447AbZHNVTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 17:19:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55319 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752419AbZHNVTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 17:19:39 -0400
Date: Fri, 14 Aug 2009 22:20:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David VomLehn <dvomlehn@cisco.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, greg@kroah.com
Subject: Re: [PATCH 1/2] Use kfifo to buffer USB generic serial writes
Message-ID: <20090814222039.0cc29713@lxorguk.ukuu.org.uk>
In-Reply-To: <20090814200251.GA26258@cuplxvomd02.corp.sa.net>
References: <20090814200251.GA26258@cuplxvomd02.corp.sa.net>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The first part of patch uses the kfifo infrastructure to implement a write
> FIFO that accurately returns the amount of space available in the buffer. The
> second makes a minor change to kfifo_put() and __kfifo_put() to add the "const"
> attribute to their input buffer pointers.

Nice, fixes the bug, uses the proper infrastructure and comes out as
loads less code and far easier to read


> +	/* TODO: Much of the time there won't be a write pending and won't be
> +	 * any data ahead of the current chunk. In those cases, we could save
> +	 * a copy by putting the data directly into the URB transfer buffer.
> +	 * This adds some complexity, is it worth it for serial I/O? */
> +	count = kfifo_put(port->write_fifo, buf, count);

If your device has a single transmit URB and isn't doing 2-3MBit the
answer will be no - its in cache anyway and the real hit will be the
writeout for the USB controller to DMA it.


> +		spin_lock_irqsave(&port->write_fifo_lock, flags);
> +		chars = __kfifo_len(port->write_fifo);
> +		spin_unlock_irqrestore(&port->write_fifo_lock, flags);

Any reason for not using kfifo_len() ?

Alan
