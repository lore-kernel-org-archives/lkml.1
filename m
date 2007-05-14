Return-Path: <linux-kernel-owner+w=401wt.eu-S1760172AbXENW1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172AbXENW1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 18:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755155AbXENW1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 18:27:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbXENW1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 18:27:09 -0400
Date: Mon, 14 May 2007 15:19:43 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Kevin Lloyd <klloyd@sierrawireless.com>
Cc: gregkh@suse.de, mdharm-usb@one-eyed-alien.net,
       usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org,
       linux-usb-users@lists.sourceforge.net
Subject: Re: [PATCH] usb-storage: Add support for unusual device by Sierra
 Wireless
Message-Id: <20070514151943.fb035b4d.zaitcev@redhat.com>
In-Reply-To: <4648D851.2030500@sierrawireless.com>
References: <4648D851.2030500@sierrawireless.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007 14:44:49 -0700, Kevin Lloyd <klloyd@sierrawireless.com> wrote:

> +		schedule_timeout_uninterruptible(delay_t*HZ);
> +		retval = sierra_ms_change_mode(us, SWIMS_SET_MODE_Modem);
> +		if (retval == -ETIMEDOUT || retval == -ETIME) {
> +			US_DEBUGP("sierra_ms: Command timed out.\n");
> +			retries--;

This is strange. The two values should not typically be mixed this way.

ETIMEOUT happens when we (host) sent the setup packet, device took it,
and then posted NAKs for all data-in that we did, so eventually (after 5s),
we unlinked the URB. This means that the device works, just doesn't
want to perform the command in time. The bus itself functions fine.

ETIME means that something has violated the bus protocol. It's like
-EBUS for MMIO on PCI. Usually it means that the firmware in the device
is completely dead. You can call this a timeout in some sense, but
in reality it's no different from EILSEQ. We just report a different
code for finer shades of debugging. It happens in less than a millisecond.

I think you just need to test for ETIMEDOUT for that message.

> +	int result;
> +	unsigned char *blankArray;
> +	blankArray = kmalloc(0, GFP_KERNEL);

> +	result = usb_stor_control_msg(us, us->send_ctrl_pipe,
> +				SWIMS_USB_REQUEST_SetMode,
> +				SWIMS_USB_REQUEST_TYPE_SetMode,
> +				eSocMode,
> +				SWIMS_USB_INDEX_SetMode,
> +				blankArray,
> +				0,
> +				5*HZ);

The blankArray is completely unnecessary here. If something hits
a NULL despite the zero transfer size, it has to be fixed.

-- Pete
