Return-Path: <linux-kernel-owner+w=401wt.eu-S1757071AbYFDONv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071AbYFDONv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 10:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYFDONl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 10:13:41 -0400
Received: from styx.suse.cz ([82.119.242.94]:42124 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752659AbYFDONi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 10:13:38 -0400
Date: Wed, 4 Jun 2008 16:13:37 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       marcel@holtmann.org, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 08/10] HID: move apple quirks
In-Reply-To: <1210931362-18422-8-git-send-email-jirislaby@gmail.com>
Message-ID: <Pine.LNX.4.64.0806041610240.10085@jikos.suse.cz>
References: <1210931362-18422-1-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-2-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-3-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-4-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-5-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-6-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-7-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-8-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008, Jiri Slaby wrote:


> +static int apple_probe(struct hid_device *hdev,
> +		const struct hid_device_id *id)
> +{
> +	unsigned long quirks = id->driver_data;
> +	struct apple_sc *asc;
> +	int ret;
> +
> +	/* return something else or move to hid layer? device will reside
> +	   allocated */
> +	if (id->bus == BUS_USB && (id->driver_data & APPLE_IGNORE_MOUSE) &&
> +			to_usb_interface(hdev->dev.parent)->cur_altsetting->
> +			desc.bInterfaceProtocol == USB_INTERFACE_PROTOCOL_MOUSE)
> +		return -ENODEV;
> +
> +	asc = kzalloc(sizeof(*asc), GFP_KERNEL);
> +	if (asc == NULL) {
> +		dev_err(&hdev->dev, "can't alloc apple descriptor\n");
> +		return -ENOMEM;
> +	}
> +
> +	hid_set_drvdata(hdev, asc);
> +
> +	if (quirks & APPLE_HIDDEV)
> +		hdev->quirks |= HID_QUIRK_HIDDEV;
> +	if (quirks & APPLE_IGNORE_HIDINPUT)
> +		hdev->quirks |= HID_QUIRK_IGNORE_HIDINPUT;
> +
> +	ret = hid_parse(hdev);
> +	if (ret) {
> +		dev_err(&hdev->dev, "parse failed\n");
> +		goto err_free;
> +	}
> +
> +	ret = hid_hw_start(hdev);
> +	if (ret) {
> +		dev_err(&hdev->dev, "hw start failed\n");
> +		goto err_free;
> +	}
> +
> +	return 0;
> +err_free:
> +	kfree(asc);
> +	return ret;
> +}

Hi Jiri,

you don't seem to set asc->quirks anywhere, but the rest of the code is 
testing this flag. Is something like

	asc->quirks = id->driver_data;

missing in the _probe routine?

Or am I just horribly overlooking something?

Thanks,

-- 
Jiri Kosina
SUSE Labs
