Return-Path: <linux-kernel-owner+w=401wt.eu-S1762583AbXIXQg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762583AbXIXQg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760793AbXIXQ1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:27:16 -0400
Received: from mga07.intel.com ([143.182.124.22]:44815 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760282AbXIXQ1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:27:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,292,1186383600"; 
   d="scan'208";a="285538169"
Date: Mon, 24 Sep 2007 09:26:52 -0700
From: Mark Gross <mgross@linux.intel.com>
To: lkml <linux-kernel@vger.kernel.org>,
       usbdev <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [patch] usb-skeleton leaking locks on open.
Message-ID: <20070924162652.GA5227@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20070924161822.GA4525@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924161822.GA4525@linux.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

forgot to CC greg ...


On Mon, Sep 24, 2007 at 09:18:22AM -0700, Mark Gross wrote:
> This weekend I was hacking around with a trivial USB driver for talking
> to the boot load firmware of a USB Bit Whacker.  It's running the
> MicroChip Pic18 boot loader firmware and I'm putting together a flash
> program for writing new FW to the thing.
> 
> Anyway in my use of the usb-skeleton.c as my starting point I discovered
> my test program was getting hung up after attempting to write a buffer.
> The application and driver where hung in a way that required me to
> reboot to get it to clean up so I could try again.
> 
> It turned out the code path through skel_open can grap the driver's
> io_mutex lock and forget to release it.
> 
> The following patch fixes the problem for me.
> 
> --mgross
> 
> Signed-off-by: Mark Gross <mgross@linux.intel.com>
> 
> diff -urN -X linux-2.6.23-rc7/Documentation/dontdiff linux-2.6.23-rc7/drivers/usb/usb-skeleton.c linux-2.6.23-rc7-bugfix/drivers/usb/usb-skeleton.c
> --- linux-2.6.23-rc7/drivers/usb/usb-skeleton.c	2007-09-24 08:57:54.000000000 -0700
> +++ linux-2.6.23-rc7-bugfix/drivers/usb/usb-skeleton.c	2007-09-24 09:01:43.000000000 -0700
> @@ -125,6 +125,7 @@
>  
>  	/* save our object in the file's private structure */
>  	file->private_data = dev;
> +	mutex_unlock(&dev->io_mutex);
>  
>  exit:
>  	return retval;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
