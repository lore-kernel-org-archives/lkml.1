Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab0BIPzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 10:55:08 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:50535 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab0BIPzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 10:55:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OLjFkaZUcBYIx9NeFCi1UQAtHfavpmYYHrKzgFCxufqWedeRYVhZgvQZDgO/7YcMAT
         wKpzYGoyS5QAi4wG9M02K4leYCCL8m1i6hherH8f3yoAhbQI1CI4Vk/dUrihD3uyg18z
         Dy7K2ITKY1VfqzhRqRmX4ZPcGOHT8hwGV6v5o=
Message-ID: <4B7186F1.808@gmail.com>
Date: Tue, 09 Feb 2010 17:01:53 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@suse.de>, sarah.a.sharp@linux.intel.com,
       linux-usb@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: don't read past config->interface[] if usb_control_msg()
 fails in usb_reset_configuration()
References: <Pine.LNX.4.44L0.1002091010100.1665-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1002091010100.1665-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the loop `for (i = 0; i < config->desc.bNumInterfaces; i++)' if no
break occurred, i equals config->desc.bNumInterfaces. so if
usb_control_msg() failed then after goto reset_old_alts we read from
config->interface[config->desc.bNumInterfaces].
We can safely decrement i as well if the break occurred.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---

> You correctly identified a problem, but your fix is wrong -- or at 
> least, it is much too complicated.

Ok,

 drivers/usb/core/message.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
 
