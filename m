Return-Path: <linux-kernel-owner+w=401wt.eu-S1758748AbYFIWEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748AbYFIWEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbYFIWEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:04:45 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:35616 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbYFIWEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:04:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=P6KxYHpR6s/lP9N6ML5sec+Eb8cVm5tU7oj60sPG2K6pG3asH43yR7rIixz4ItCx+f
         JJTp9CEmMgDK5mKRC8T+QfYt+P3Sif5LAiM14MGUSi4OfAEoU9y15g4REwXRUFtNmPzp
         P9J8dCZeAN2634oeY1SlNitYXbF1+HSNFO6J0=
Message-ID: <dd18b0c30806091504u43e0e901jb786e57f5cbf47cd@mail.gmail.com>
Date: Mon, 9 Jun 2008 22:04:44 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: [Bug #10825] appletouch after wakeup
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200806092316.56459.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
	 <200806092231.32190.oliver@neukum.org>
	 <dd18b0c30806091352g390b1e5dj11118bce07942ef6@mail.gmail.com>
	 <200806092316.56459.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2008 at 9:16 PM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Montag 09 Juni 2008 22:52:21 schrieb Justin Mattock:
>> On Mon, Jun 9, 2008 at 8:31 PM, Oliver Neukum <oliver@neukum.org> wrote:
>> > Am Montag 09 Juni 2008 22:29:05 schrieb Justin Mattock:
>> >> On Mon, Jun 9, 2008 at 7:53 PM, Oliver Neukum <oliver@neukum.org> wrote:
>> >> > Am Montag 09 Juni 2008 18:18:19 schrieb Justin Mattock:
>> >
>> >> >> Cool; just an update, I've suspended the system numerous times it
>> >> >> seems appletouch is behaving correctly, in fact
>> >> >> I think better, why: when I start the system I have two finger scroll
>> >> >> functionality, then when suspending the system
>> >> >> after waking up the two finger scroll is still functional.
>> >> >> regards;
>> >> >>
>> >> >
>> >> > With last week's patch or today's patch?
>> >> >
>> >> >        Regards
>> >> >                Oliver
>> >> >
>> >> >
>> >>
>> >> Last weeks patch.
>> >> regards;
>> >>
>> >
>> > Could you also try today's patch?
>> >
>> >        Regards
>> >                Oliver
>> >
>> >
>>
>> Sure, where is it located.
>> regards;
>>
>
> Didn't I mail it to you? Anyway, here it is.
>
>        Regards
>                Oliver
>
> ----
>
> --- linux-2.6.26-rc5/drivers/usb/core/quirks.c  2008-06-05 13:45:57.000000000 +0200
> +++ linux-2.6.26-rc5-btusb/drivers/usb/core/quirks.c    2008-06-06 08:12:10.000000000 +0200
> @@ -47,6 +47,9 @@ static const struct usb_device_id usb_qu
>        /* Edirol SD-20 */
>        { USB_DEVICE(0x0582, 0x0027), .driver_info = USB_QUIRK_RESET_RESUME },
>
> +       /* appletouch */
> +       { USB_DEVICE(0x05ac, 0x021a), .driver_info = USB_QUIRK_RESET_RESUME },
> +
>        /* Avision AV600U */
>        { USB_DEVICE(0x0638, 0x0a13), .driver_info =
>          USB_QUIRK_STRING_FETCH_255 },
> --- linux-2.6.26-rc5-btusb/drivers/input/mouse/appletouch.c.alt 2008-06-09 10:40:00.000000000 +0200
> +++ linux-2.6.26-rc5-btusb/drivers/input/mouse/appletouch.c     2008-06-09 10:40:03.000000000 +0200
> @@ -589,6 +589,20 @@ static void atp_close(struct input_dev *
>        dev->open = 0;
>  }
>
> +static int handle_geyser(struct atp *dev)
> +{
> +       struct usb_device *udev = dev->udev;
> +
> +       if (!atp_is_fountain(dev)) {
> +               /* switch to raw sensor mode */
> +               if (atp_geyser_init(udev))
> +                       return -EIO;
> +
> +               printk(KERN_INFO "appletouch: Geyser mode initialized.\n");
> +       }
> +       return 0;
> +}
> +
>  static int atp_probe(struct usb_interface *iface, const struct usb_device_id *id)
>  {
>        struct atp *dev;
> @@ -744,6 +758,20 @@ static void atp_disconnect(struct usb_in
>        printk(KERN_INFO "input: appletouch disconnected\n");
>  }
>
> +static int recover_dev(struct atp *dev)
> +{
> +       int rv;
> +
> +       rv = handle_geyser(dev);
> +       if (rv < 0)
> +               return rv;
> +
> +       if (dev->open && usb_submit_urb(dev->urb, GFP_NOIO))
> +               return -EIO;
> +
> +       return 0;
> +}
> +
>  static int atp_suspend(struct usb_interface *iface, pm_message_t message)
>  {
>        struct atp *dev = usb_get_intfdata(iface);
> @@ -764,12 +792,20 @@ static int atp_resume(struct usb_interfa
>        return 0;
>  }
>
> +static int atp_reset_resume(struct usb_interface *iface)
> +{
> +       struct atp *dev = usb_get_intfdata(iface);
> +
> +       return recover_dev(dev);
> +}
> +
>  static struct usb_driver atp_driver = {
>        .name           = "appletouch",
>        .probe          = atp_probe,
>        .disconnect     = atp_disconnect,
>        .suspend        = atp_suspend,
>        .resume         = atp_resume,
> +       .reset_resume   = atp_reset_resume,
>        .id_table       = atp_table,
>  };
>
>
>

You probably did,  I'll apply this and let you know.
regards;

-- 
Justin P. Mattock
