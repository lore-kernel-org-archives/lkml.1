Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab0BRB2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 20:28:53 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:43642 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab0BRB2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 20:28:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SonKTEaio8wuh0lipKgyH+OFj47tgykhrm9i1nMwIekEKd4TZLhyAfF6NuJ9GO29D8
         pgWbMyKoUCt4ySO1zPvQRqps7R6C3jSUZdhhtBBw8jaKq5JWBjGNi9JPf8LXKPudA4gf
         8Jp9Pnf1BjyRoMxL9KxjYD5x2Aemz3ZPviZYw=
Message-ID: <4B7C9997.2020401@gmail.com>
Date: Thu, 18 Feb 2010 02:36:23 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: don't read past config->interface[] if usb_control_msg()
 fails in usb_reset_configuration()
References: <Pine.LNX.4.44L0.1002091010100.1665-100000@iolanthe.rowland.org> <4B7186F1.808@gmail.com> <20100209220120.GB4607@xanatos> <25e057c01002091409l83a7d7fwd2f7762725f83e50@mail.gmail.com> <20100217234002.GE12197@kroah.com>
In-Reply-To: <20100217234002.GE12197@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looping over the interfaces, if usb_hcd_alloc_bandwidth() fails it calls
hcd->driver->reset_bandwidth(), so there was no need to reinstate the interface
again.

If no break occurred, the index equals config->desc.bNumInterfaces. A
subsequent usb_control_msg() failure resulted in a read from
config->interface[config->desc.bNumInterfaces] at label reset_old_alts.

In either case the last interface should be skipped.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
---
>> Could you please confirm whether this patch is the better or the
>> other (in this same thread)?
> 
> Can someone tell me which one is the correct one to apply, but resending
> it to me?

This is the one as Sarah kindly explained to me.

Thanks, Roel

diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 9bc95fe..1a48aac 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1471,7 +1471,7 @@ int usb_reset_configuration(struct usb_device *dev)
 	/* If not, reinstate the old alternate settings */
 	if (retval < 0) {
 reset_old_alts:
-		for (; i >= 0; i--) {
+		for (i--; i >= 0; i--) {
 			struct usb_interface *intf = config->interface[i];
 			struct usb_host_interface *alt;
 
