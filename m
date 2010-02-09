Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab0BIWBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 17:01:24 -0500
Received: from mga07.intel.com ([143.182.124.22]:62238 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751881Ab0BIWBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 17:01:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,438,1262592000"; 
   d="scan'208";a="242275547"
Date: Tue, 9 Feb 2010 14:01:20 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: don't read past config->interface[] if
 usb_control_msg() fails in usb_reset_configuration()
Message-ID: <20100209220120.GB4607@xanatos>
References: <Pine.LNX.4.44L0.1002091010100.1665-100000@iolanthe.rowland.org>
 <4B7186F1.808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7186F1.808@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 09, 2010 at 05:01:53PM +0100, Roel Kluin wrote:
> After the loop `for (i = 0; i < config->desc.bNumInterfaces; i++)' if no
> break occurred, i equals config->desc.bNumInterfaces. so if
> usb_control_msg() failed then after goto reset_old_alts we read from
> config->interface[config->desc.bNumInterfaces].
> We can safely decrement i as well if the break occurred.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Bah, yes, you're right. :)  Good catch.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>

> ---
> 
> > You correctly identified a problem, but your fix is wrong -- or at 
> > least, it is much too complicated.
> 
> Ok,
> 
>  drivers/usb/core/message.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
> index 9bc95fe..1a48aac 100644
> --- a/drivers/usb/core/message.c
> +++ b/drivers/usb/core/message.c
> @@ -1471,7 +1471,7 @@ int usb_reset_configuration(struct usb_device *dev)
>  	/* If not, reinstate the old alternate settings */
>  	if (retval < 0) {
>  reset_old_alts:
> -		for (; i >= 0; i--) {
> +		for (i--; i >= 0; i--) {
>  			struct usb_interface *intf = config->interface[i];
>  			struct usb_host_interface *alt;
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
