Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab0BIVyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 16:54:36 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:53620 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab0BIVye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 16:54:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=p7ww4HD9R/fcW6cEMuYqTxmWrc1EQKZ4tScxLLfc8c07IXTclbnhzUN/bB5crR4x+v
         SrAJDHET6BU0wJMHSiWJjdhMiKYB2zX1lDT818JjWaLkIAHqk8doBg2A/d8s2pUw+kJb
         vdHlZJwPgtIAuHqAyhsNadfNYdwDiLiotA0Lk=
Message-ID: <4B71DB34.5090708@gmail.com>
Date: Tue, 09 Feb 2010 23:01:24 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, sarah.a.sharp@linux.intel.com,
       linux-usb@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: don't read past config->interface[] if usb_control_msg()
 fails in usb_reset_configuration()
References: <Pine.LNX.4.44L0.1002091010100.1665-100000@iolanthe.rowland.org> <4B7186F1.808@gmail.com>
In-Reply-To: <4B7186F1.808@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the loop `for (i = 0; i < config->desc.bNumInterfaces; i++)' if no
break occurred, i equals config->desc.bNumInterfaces. so if
usb_control_msg() failed then after goto reset_old_alts we read from
config->interface[config->desc.bNumInterfaces].

Reported-by: "Juha Leppanen" <juha_motorsportcom@luukku.com>
Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---

>> You correctly identified a problem, but your fix is wrong -- or at 
>> least, it is much too complicated. The proper fix goes like this:
> 
>  	/* If not, reinstate the old alternate settings */
>  	if (retval < 0) {
>  reset_old_alts:
> -		for (; i >= 0; i--) {
> +		for (i--; i >= 0; i--) {
>  			struct usb_interface *intf = config->interface[i];
>  			struct usb_host_interface *alt;


Are you really sure this is better? If usb_hcd_alloc_bandwidth() fails,
in the loop _before_ the reset_old_alts label, don't we still have to
reinstate the old alternate settings for that usb_interface
config->interface[i]? This was what my initial patch tried to do.

Alternatively usb_hcd_alloc_bandwidth() could undo what it does if an
error occurs there, then I think i could be decremented.

IOW isn't this the proper fix?

Roel

diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 9bc95fe..4327eab 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1489,8 +1489,10 @@ reset_old_alts:
 			USB_REQ_SET_CONFIGURATION, 0,
 			config->desc.bConfigurationValue, 0,
 			NULL, 0, USB_CTRL_SET_TIMEOUT);
-	if (retval < 0)
+	if (retval < 0) {
+		i--;
 		goto reset_old_alts;
+	}
 	mutex_unlock(&hcd->bandwidth_mutex);
 
 	/* re-init hc/hcd interface/endpoint state */
