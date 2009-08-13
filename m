Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbZHMTqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbZHMTqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbZHMTqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:46:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33698 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751600AbZHMTqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:46:14 -0400
Date: Thu, 13 Aug 2009 20:47:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David VomLehn <dvomlehn@cisco.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] Combine two one-character CR-LF writes into one
 two-character write for O_ONLCR
Message-ID: <20090813204719.6c91eaf2@lxorguk.ukuu.org.uk>
In-Reply-To: <20090813184218.GA12832@cuplxvomd02.corp.sa.net>
References: <20090813175430.GA8769@cuplxvomd02.corp.sa.net>
	<20090813181521.GB28172@kroah.com>
	<20090813184218.GA12832@cuplxvomd02.corp.sa.net>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Good question. Right now, there are a number of USB serial devices that don't
> use the generic USB serial framework, but they generally seem to use the
> write_urb_busy flag the same way the generic code does. This makes it easier

They all suck, they all misimplement the interfaces. The proper way to do
this is to use a FIFO (kfifo makes it tiny amounts of code) and then
either fire off a new URB whenever one completes or if you are
constrained on urb counts but have over one implement Nagle on it.

> to mix and match generic and non-generic code. Going to a FIFO approach and
> doing away with the write_urb_busy flag seemed like a lot of change for very
> little benefit. In addition, I would argue that doing one two-character write()
> of two one-character writes() is a more logical way to output two characters,
> anyway.

The tty layer requires you can provide some buffering and that your
write_room function doesn't reduce by more than the bytes offered without
them being written. The sane way to do that is to use the kfifo API.

The ONLCR stuff is just a corner case example of where the USB serial
code breaks so the real bug wants fixing.
