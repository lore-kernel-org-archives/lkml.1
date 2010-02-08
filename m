Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab0BHUZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 15:25:11 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56490 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754397Ab0BHUZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 15:25:09 -0500
Date: Mon, 8 Feb 2010 15:25:06 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
cc: Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oliver@neukum.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Marcel Holtmann <marcel@holtmann.org>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       <linux-usb@vger.kernel.org>, <linux-input@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: S2R resume crash in 2.6.33-rc7 - NULL pointer dereference in
 dev_get_drvdata() for usbhid
In-Reply-To: <20100208190649.0ceea556@neptune.home>
Message-ID: <Pine.LNX.4.44L0.1002081505220.1316-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Feb 2010, Bruno [UTF-8] Prémont wrote:

> On Mon, 08 February 2010 Bruno Prémont <bonbons@linux-vserver.org> wrote:
> > 2.6.33-rc7 (don't know if any previous version resumes properly)
> > crashes during resume from S2Ram when my USB keyboard is connected but
> > resumes properly (viafb corruption put apart) when the USB keyboard is
> > not connected.
> 
> The patch below works around the crash though the WARN_ON() in
> usbhid_restart_out_queue() triggers in place.
> 
> Bruno
> 
> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index e2997a8..d2f8eef 100644
> --- a/drivers/hid/usbhid/hid-core.c
> +++ b/drivers/hid/usbhid/hid-core.c
> @@ -196,7 +196,7 @@ static void usbhid_mark_busy(struct usbhid_device *usbhid)
>  
>  static int usbhid_restart_out_queue(struct usbhid_device *usbhid)
>  {
> -	struct hid_device *hid = usb_get_intfdata(usbhid->intf);
> +	struct hid_device *hid = usbhid->intf ? usb_get_intfdata(usbhid->intf) : NULL;
>  	int kicked;
>  
>  	if (!hid)
> @@ -214,7 +214,7 @@ static int usbhid_restart_out_queue(struct usbhid_device *usbhid)
>  
>  static int usbhid_restart_ctrl_queue(struct usbhid_device *usbhid)
>  {
> -	struct hid_device *hid = usb_get_intfdata(usbhid->intf);
> +	struct hid_device *hid = usbhid->intf ? usb_get_intfdata(usbhid->intf) : NULL;
>  	int kicked;
>  
>  	WARN_ON(hid == NULL);

Clearly something is setting usbhid->intf to NULL.  But I don't see any
code that would do it.  You may have to resort to putting printk()  
statements at various strategic places to find out where it happens.  
You could start with the beginnings and ends of hid_suspend,
hid_resume, and hid_reset_resume.  Maybe also usbhid_disconnect(), just
in case.

Alan Stern

