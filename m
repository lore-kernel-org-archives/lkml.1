Return-Path: <linux-kernel-owner+w=401wt.eu-S1760195AbZEFPlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195AbZEFPlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbZEFPlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 11:41:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46128 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753306AbZEFPlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 11:41:05 -0400
Date: Wed, 6 May 2009 16:41:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jason Wessel <jason.wessel@windriver.com>, greg@kroah.com,
       <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] usb_debug: EXPERIMENTAL - poll hcd device to force
 writes
Message-ID: <20090506164141.55c8978c@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.0905061058230.3227-100000@iolanthe.rowland.org>
References: <1241575205-12199-6-git-send-email-jason.wessel@windriver.com>
	<Pine.LNX.4.44L0.0905061058230.3227-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The question is what is the right way to force the controller to catch
> > up, and ideally let the kernel do some other things in the mean time?
> 
> What do standard serial port drivers do?

Stuff data into the chip and if need be maintain an internal buffer. One
of the problems with the serial stuff is that the buffering algorithms
you need to packetize serial streams without poor behaviour or overruns
are non trivial and the USB serial layer doesn't provide anything
remotely resembling sanity.

Secondly most USB serial drivers lie about their write room which causes
overruns.

What should happen is something like this

	foo_write_room()
	{
		if(no_urbs_left) return 0;
		if(one_urb_left) return bytes_in_urb_left;
		else return size_of_one_urb;
	}

	foo_write()
	{
		stuff bytes into urb
		if (urbs_left > 1 &&
		some_function_of_bytes_queued_and_speed())
			send_urb_now();
	}

In other words never lie in the write_room method. Try to send data as
early as possible, but don't queue data inefficiently when the port has
plenty left to send.

The rules for write_room are simple

	If you say you have space for X bytes you can't say you have room
	for less bytes unless those bytes have actually been written - no
	window shrinking so to speak.

If your write_room method works properly, and you fix the buffering logic
then the rest will work. Probably we need usb/serial/buffer.c which has a
generic implementation in then that can be used to replace the completely
bogus hacks in most of the drivers.

Alan
