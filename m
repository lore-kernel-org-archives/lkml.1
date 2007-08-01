Return-Path: <linux-kernel-owner+w=401wt.eu-S932095AbXHAKYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbXHAKYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 06:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758992AbXHAKYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 06:24:34 -0400
Received: from twin.jikos.cz ([213.151.79.26]:42360 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757737AbXHAKYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 06:24:33 -0400
Date: Wed, 1 Aug 2007 12:23:24 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>
cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       Greg KH <gregkh@suse.de>
Subject: Re: 2.6.23-rc1-mm2
In-Reply-To: <20070801011323.6e8d8259.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708011221430.26230@twin.jikos.cz>
References: <20070731230932.a9459617.akpm@linux-foundation.org>
 <200708011002.30962.m.kozlowski@tuxland.pl> <20070801011323.6e8d8259.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(CCs adjusted)

On Wed, 1 Aug 2007, Andrew Morton wrote:

> > usb 2-1: USB disconnect, address 2
> > BUG: atomic counter underflow at:
> >  [<c010456a>] show_trace_log_lvl+0x1a/0x30
> >  [<c010508d>] show_trace+0x12/0x14
> >  [<c01051e0>] dump_stack+0x15/0x17
> >  [<c01418cf>] __free_pages+0x50/0x52
> >  [<c01418f0>] free_pages+0x1f/0x21
> >  [<c010783d>] dma_free_coherent+0x43/0x9c
> >  [<c0315067>] hcd_buffer_free+0x43/0x6a
> >  [<c030b2b4>] usb_buffer_free+0x23/0x29
> >  [<c0346db4>] hid_free_buffers+0x23/0x71
> >  [<c0346eb2>] hid_disconnect+0xb0/0xc8
> >  [<c0313676>] usb_unbind_interface+0x30/0x72
> >  [<c02c6df0>] __device_release_driver+0x6a/0x92
> >  [<c02c71c3>] device_release_driver+0x20/0x36
> >  [<c02c6736>] bus_remove_device+0x62/0x85
> >  [<c02c49f8>] device_del+0x16d/0x27c
> >  [<c0310f25>] usb_disable_device+0x7a/0xe2
> >  [<c030d0bc>] usb_disconnect+0x94/0xde
> >  [<c030e030>] hub_thread+0x2fe/0xc1b
> >  [<c0128aee>] kthread+0x36/0x58
> >  [<c0104233>] kernel_thread_helper+0x7/0x14
> >  =======================
> > uhci_hcd 0000:00:0c.0: dma_pool_free buffer-32, 6b6b6b6b/6b6b6b6b (bad dma)

Mariusz,

I guess the patch below (which I have just added to my tree) fixes that, 
right? Thanks.

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 6e73934..0a1f2b5 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -877,9 +877,9 @@ fail:
 	usb_free_urb(usbhid->urbin);
 	usb_free_urb(usbhid->urbout);
 	usb_free_urb(usbhid->urbctrl);
+	hid_free_buffers(dev, hid);
 	kfree(usbhid);
 fail_no_usbhid:
-	hid_free_buffers(dev, hid);
 	hid_free_device(hid);
 
 	return NULL;
@@ -913,9 +913,9 @@ static void hid_disconnect(struct usb_interface *intf)
 	usb_free_urb(usbhid->urbin);
 	usb_free_urb(usbhid->urbctrl);
 	usb_free_urb(usbhid->urbout);
-	kfree(usbhid);
 
 	hid_free_buffers(hid_to_usb_dev(hid), hid);
+	kfree(usbhid);
 	hid_free_device(hid);
 }
 
