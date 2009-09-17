Return-Path: <linux-kernel-owner+w=401wt.eu-S1759253AbZIQCai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbZIQCai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 22:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757171AbZIQCai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 22:30:38 -0400
Received: from senator.holtmann.net ([87.106.208.187]:60801 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588AbZIQCah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 22:30:37 -0400
Subject: Re: [GIT] HID patches for 2.6.32 merge window
From: Marcel Holtmann <marcel@holtmann.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.0909151630180.17028@wotan.suse.de>
References: <alpine.LNX.2.00.0909132014310.17028@wotan.suse.de>
	 <1252922794.3421.3.camel@localhost.localdomain>
	 <alpine.LNX.2.00.0909141210590.17028@wotan.suse.de>
	 <1252926408.3421.7.camel@localhost.localdomain>
	 <alpine.LNX.2.00.0909151630180.17028@wotan.suse.de>
Content-Type: text/plain
Date: Wed, 16 Sep 2009 19:30:29 -0700
Message-Id: <1253154629.28416.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> > you need to redo it against the net-next-2.6 tree or wait until Linus 
> > merged that one. Otherwise it will clash with a temporary solution that 
> > I already pushed some time ago.
> 
> OK, I now have this in my tree (which applies on top of 364f63519d9, which 
> I believe is the temporary solution you have been talking about). I'd 
> appreciate your Acked-by: for the bluetooth part, so that I could push it 
> during the next round.
> Thanks!
> 
> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] HID: consolidate connect and disconnect into core code
> 
> HID core registers input, hidraw and hiddev devices, but leaves
> unregistering it up to the individual driver, which is not really nice.
> Let's move all the logic to the core.
> 
> Reported-by: Marcel Holtmann <marcel@holtmann.org>
> Reported-by: Brian Rogers <brian@xyzw.org>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  drivers/hid/hid-core.c        |   11 +++++++++++
>  drivers/hid/usbhid/hid-core.c |   16 +++++-----------
>  include/linux/hid.h           |    3 +++
>  net/bluetooth/hidp/core.c     |   11 +----------
>  4 files changed, 20 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index ca9bb26..be34d32 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1237,6 +1237,17 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
>  }
>  EXPORT_SYMBOL_GPL(hid_connect);
>  
> +void hid_disconnect(struct hid_device *hdev)
> +{
> +	if (hdev->claimed & HID_CLAIMED_INPUT)
> +		hidinput_disconnect(hdev);
> +	if (hdev->claimed & HID_CLAIMED_HIDDEV)
> +		hdev->hiddev_disconnect(hdev);
> +	if (hdev->claimed & HID_CLAIMED_HIDRAW)
> +		hidraw_disconnect(hdev);
> +}
> +EXPORT_SYMBOL_GPL(hid_disconnect);
> +
>  /* a list of devices for which there is a specialized driver on HID bus */
>  static const struct hid_device_id hid_blacklist[] = {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_WCP32PU) },
> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index 1b0e07a..03bd703 100644
> --- a/drivers/hid/usbhid/hid-core.c
> +++ b/drivers/hid/usbhid/hid-core.c
> @@ -1041,13 +1041,6 @@ static void usbhid_stop(struct hid_device *hid)
>  
>  	hid_cancel_delayed_stuff(usbhid);
>  
> -	if (hid->claimed & HID_CLAIMED_INPUT)
> -		hidinput_disconnect(hid);
> -	if (hid->claimed & HID_CLAIMED_HIDDEV)
> -		hiddev_disconnect(hid);
> -	if (hid->claimed & HID_CLAIMED_HIDRAW)
> -		hidraw_disconnect(hid);
> -
>  	hid->claimed = 0;
>  
>  	usb_free_urb(usbhid->urbin);
> @@ -1085,7 +1078,7 @@ static struct hid_ll_driver usb_hid_driver = {
>  	.hidinput_input_event = usb_hidinput_input_event,
>  };
>  
> -static int hid_probe(struct usb_interface *intf, const struct usb_device_id *id)
> +static int usbhid_probe(struct usb_interface *intf, const struct usb_device_id *id)
>  {
>  	struct usb_host_interface *interface = intf->cur_altsetting;
>  	struct usb_device *dev = interface_to_usbdev(intf);
> @@ -1117,6 +1110,7 @@ static int hid_probe(struct usb_interface *intf, const struct usb_device_id *id)
>  	hid->ff_init = hid_pidff_init;
>  #ifdef CONFIG_USB_HIDDEV
>  	hid->hiddev_connect = hiddev_connect;
> +	hid->hiddev_disconnect = hiddev_disconnect;
>  	hid->hiddev_hid_event = hiddev_hid_event;
>  	hid->hiddev_report_event = hiddev_report_event;
>  #endif
> @@ -1177,7 +1171,7 @@ err:
>  	return ret;
>  }
>  
> -static void hid_disconnect(struct usb_interface *intf)
> +static void usbhid_disconnect(struct usb_interface *intf)
>  {
>  	struct hid_device *hid = usb_get_intfdata(intf);
>  	struct usbhid_device *usbhid;
> @@ -1359,8 +1353,8 @@ MODULE_DEVICE_TABLE (usb, hid_usb_ids);
>  
>  static struct usb_driver hid_driver = {
>  	.name =		"usbhid",
> -	.probe =	hid_probe,
> -	.disconnect =	hid_disconnect,
> +	.probe =	usbhid_probe,
> +	.disconnect =	usbhid_disconnect,
>  #ifdef CONFIG_PM
>  	.suspend =	hid_suspend,
>  	.resume =	hid_resume,
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index a0ebdac..10f6284 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -494,6 +494,7 @@ struct hid_device {							/* device report descriptor */
>  
>  	/* hiddev event handler */
>  	int (*hiddev_connect)(struct hid_device *, unsigned int);
> +	void (*hiddev_disconnect)(struct hid_device *);
>  	void (*hiddev_hid_event) (struct hid_device *, struct hid_field *field,
>  				  struct hid_usage *, __s32);
>  	void (*hiddev_report_event) (struct hid_device *, struct hid_report *);
> @@ -691,6 +692,7 @@ struct hid_device *hid_allocate_device(void);
>  int hid_parse_report(struct hid_device *hid, __u8 *start, unsigned size);
>  int hid_check_keys_pressed(struct hid_device *hid);
>  int hid_connect(struct hid_device *hid, unsigned int connect_mask);
> +void hid_disconnect(struct hid_device *hid);
>  
>  /**
>   * hid_map_usage - map usage input bits
> @@ -800,6 +802,7 @@ static inline int __must_check hid_hw_start(struct hid_device *hdev,
>   */
>  static inline void hid_hw_stop(struct hid_device *hdev)
>  {
> +	hid_disconnect(hdev);
>  	hdev->ll_driver->stop(hdev);
>  }
>  
> diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
> index 09bedeb..75df1e1 100644
> --- a/net/bluetooth/hidp/core.c
> +++ b/net/bluetooth/hidp/core.c
> @@ -576,15 +576,8 @@ static int hidp_session(void *arg)
>  		session->input = NULL;
>  	}
>  
> -	if (session->hid) {
> -		if (session->hid->claimed & HID_CLAIMED_INPUT)
> -			hidinput_disconnect(session->hid);
> -		if (session->hid->claimed & HID_CLAIMED_HIDRAW)
> -			hidraw_disconnect(session->hid);
> -
> +	if (session->hid)
>  		hid_destroy_device(session->hid);
> -		session->hid = NULL;
> -	}

can you please leave the session->hid = NULL part inside the code. It is
important that it stays. Other than that

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


