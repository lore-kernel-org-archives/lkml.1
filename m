Return-Path: <linux-kernel-owner+w=401wt.eu-S1755825AbZANS66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbZANS66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 13:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbZANS6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 13:58:50 -0500
Received: from mout1.freenet.de ([195.4.92.91]:53496 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbZANS6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 13:58:49 -0500
From: "Christian Eggers" <ceggers@gmx.de>
To: linux-kernel@vger.kernel.org
Date: Wed, 14 Jan 2009 19:58:44 +0100
MIME-Version: 1.0
Subject: Buffer allocation for USB transfers
Message-ID: <496E43F4.24792.158F9B@ceggers.gmx.de>
X-mailer: Pegasus Mail for Windows (4.41, DE v4.41 R1)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In different drivers I've found several methods for allocating buffers 
transfered with usb_control_msg() or usb_submit_urb():

- usb_stor_msg_common() in "drivers/usb/storage/transport.c" uses buffers 
allocated with usb_buffer_alloc(). These buffers are used with 
URB_NO_xxx_DMA_MAP in urb->transfer_flags.

- asix_read_cmd() in "drivers/net/usb/asix.c" uses kmalloc(GFP_KERNEL).

- mcs7830_get_reg() in "drivers/net/usb/mcs7830.c" uses buffers from 
the stack.

At least the latter does not work on my SH-4 platform. It seems that other 
variables on the stack are overwritten after calling usb_control_msg(), probably as 
result of incorrect alignment.

For some reason the second example (kmalloc()) doesn't seem to cause problems (on 
my platform) but is there are guarantee that kmalloc() 
without GFP_DMA does always return a DMA capable buffer?

Shall all buffers used for usb_control_msg() and usb_submit_urb() be 
allocated with usb_buffer_alloc()? It seems that usb_control_msg() doesn't 
offer a way to set the URB_NO_xxx_DMA_MAP in urb->transfer_flags so that 
usb_buffer_alloc() can not be used here???

regards
Christian Eggers

Please CC to ceggers@gmx.de

