Return-Path: <linux-kernel-owner+w=401wt.eu-S1765996AbYBNUuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765996AbYBNUuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:50:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYBNUty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:49:54 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53102 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbYBNUtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:49:53 -0500
Date: Thu, 14 Feb 2008 12:47:44 -0800
From: Greg KH <greg@kroah.com>
To: David Newall <davidn@davidnewall.com>
Cc: linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Handshaking on USB serial devices
Message-ID: <20080214204744.GB17277@kroah.com>
References: <47B30291.2040905@davidnewall.com> <20080214050211.GB1432@kroah.com> <47B40918.20206@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B40918.20206@davidnewall.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 07:55:44PM +1030, David Newall wrote:
> The current 2.6 driver maintains it's own buffer.  I think that's a bad
> thing: usbserial already buffers writes, and the extra buffer copy seems
> unnecessary, however it does solve the putchar problem.  Buffered (i.e.
> by the 2.6 series pl2303 driver) data is written as soon as practicable,
> regardless of CTS/DTR.  The same general workaround, but placed in
> pl2303_send seems correct to me; that is, stop submitting write urbs
> when the remote end lowers CTS/DTR, and trigger the resume from the
> interrupt callback (specifically in update_line_status.)

Where does the usbserial core buffer writes on 2.6?  The serial_write()
function just passes the data straight down to the usb-serial child
driver directly, no copying or buffering happens that I can see.

> To make it clear: Even aside from the buffer in 2.6's pl2303.c, there's
> a race: An in-flight write URB can fill all hardware buffers, making
> unsafe what previously appeared to be a safe write.  I think it's
> essential to delay submission of the URB on a stop-transmit condition.

It's up to the individual driver to know when their buffers are filled
up.  The big problem is, a lot of these cheap usb-serial devices (like
the pl2303) don't have a way to report the uart queue filled-state back
to the host, so things can easily get over-run as you have found out.

If you really want to use a usb-serial device in an environment where
such kinds of flow control are essential, then you have to buy the more
expensive ones.  The I/O networks devices handle this kind of thing very
well, and have done so since the 2.3 days, but they cost much more than
the cheap pl2303-based devices.

thanks,

greg k-h
