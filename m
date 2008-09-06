Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbYIFU13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbYIFU13 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 16:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbYIFU1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 16:27:19 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2413 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752084AbYIFU1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 16:27:19 -0400
Date: Sat, 6 Sep 2008 16:27:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: sangsu <sangsu@gmail.com>
cc: dbrownell@users.sourceforge.net, <gregkh@suse.de>,
       <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: g_file_storage: fix handling zero-length packet 
In-Reply-To: <48C20C3E.20306@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0809061615340.30019-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Sep 2008, sangsu wrote:

> According to "CH 5.5.3. Control Transfer Packet Size Constraints",
> Zero-length packet should be sent when the last data payload size
> is equal to the endpoint's MaxPacketSize.

Not so.  5.5.3 actually says this:

	The Data stage of a control transfer from an endpoint to the
	host is complete when the endpoint does one of the following:

	 - Has transferred exactly the amount of data specified during 
	the Setup stage

	 - Transfers a packet with a payload size less than
	wMaxPacketSize or transfers a zero-length packet

This clearly indicates that if the amount of data specified in the
Setup stage is a multiple of the wMaxPacketSize then there should not
be a zero-length packet, because the transfer ends as soon as the last 
wMaxPacketSize packet is sent.

> This patch helps
> g_file_storage send zero-length packet properly.
> 
> This is tested in s3c2440/s5c7329 architectures and works well.
> 
> Signed-off-by: SangSu Park<sangsu@gmail.com>
> ---
> driver/usb/gadget/file_storage.c | 3++-
> 1 files changed, 2 insertion(+), 1 deletions(-)
> 
> --- a/drivers/usb/gadget/file_storage.c	2008-09-01 11:13:03.000000000 -0400
> +++ b/drivers/usb/gadget/file_storage.c	2008-09-01 11:16:41.000000000 -0400
> @@ -1463,7 +1463,8 @@
> 	if (rc >= 0 && rc != DELAYED_STATUS) {
> 		rc = min(rc, w_length);
> 		fsg->ep0req->length = rc;
> -		fsg->ep0req->zero = rc < w_length;
> +		fsg->ep0req->zero = rc < w_length
> +			&& (rc % gadget->ep0->maxpacket) == 0;
> 		fsg->ep0req_name = (ctrl->bRequestType & USB_DIR_IN ?
> 				"ep0-in" : "ep0-out");
> 		rc = ep0_queue(fsg);

Firstly, this patch does not do what your description says it does.

Secondly, the patch is not needed.  g_file_storage doesn't have to 
check whether the data size is a multiple of MaxPacketSize because the 
device controller driver already is supposed to make that check.

Alan Stern

