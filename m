Return-Path: <linux-kernel-owner+w=401wt.eu-S933017AbYFFVOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017AbYFFVOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 17:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760798AbYFFVO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 17:14:29 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:39901 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759101AbYFFVO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 17:14:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fDT/v6fM04IXyG3Yi1R4fLCiBWaDM0/LQg6DKReTBc/YjNE5ImspCqKVmaIdoanRLn
         5HH6PXail7c1rjUI0FLVQKgDAE37VSLpwRHkLJYT2prPsrKwK0EchdHeod8lgS/AOFhI
         jwIY2bwqD62k4kAdjhqtRFcAGQa3S08SHBxS4=
Message-ID: <dd18b0c30806061414k6b7a2f04g87e7594066f0f015@mail.gmail.com>
Date: Fri, 6 Jun 2008 21:14:27 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] isight_firmware: Avoid crash on loading invalid firmware
Cc: "Andrew Morton" <akpm@linux-foundation.org>, greg@kroah.com,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <20080606194856.GA17708@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30806041213x45b7efdfo42de9b214a7ce9df@mail.gmail.com>
	 <dd18b0c30806060137j7edc751se364ff21cfc8911b@mail.gmail.com>
	 <20080606121136.GA9087@srcf.ucam.org>
	 <20080606110711.a9a6a4f6.akpm@linux-foundation.org>
	 <dd18b0c30806061110qd3100b4p1ee9f8ef493a56c6@mail.gmail.com>
	 <dd18b0c30806061138h69c87d6am898a4eb409d379e1@mail.gmail.com>
	 <20080606185548.GB8576@kroah.com>
	 <20080606192135.GA16727@srcf.ucam.org>
	 <20080606123511.38ffbdde.akpm@linux-foundation.org>
	 <20080606194856.GA17708@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2008 at 7:48 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> Different tools generate slightly different formats of the isight
> firmware. Ensure that the firmware buffer is not overrun, while still
> ensuring that the correct amount of data is written if trailing data is
> preseent. Fixes crash reported by Justin Mattock.
>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
>
> ---
>
> Identical to the previous patch, just acknowledges Justin Mattock's (not
> Maddock, Andrew :p) report in the changelog.
>
> diff --git a/drivers/usb/misc/isight_firmware.c b/drivers/usb/misc/isight_firmware.c
> index 390e048..9f30aa1 100644
> --- a/drivers/usb/misc/isight_firmware.c
> +++ b/drivers/usb/misc/isight_firmware.c
> @@ -39,9 +39,12 @@ static int isight_firmware_load(struct usb_interface *intf,
>        struct usb_device *dev = interface_to_usbdev(intf);
>        int llen, len, req, ret = 0;
>        const struct firmware *firmware;
> -       unsigned char *buf;
> +       unsigned char *buf = kmalloc(50, GFP_KERNEL);
>        unsigned char data[4];
> -       char *ptr;
> +       u8 *ptr;
> +
> +       if (!buf)
> +               return -ENOMEM;
>
>        if (request_firmware(&firmware, "isight.fw", &dev->dev) != 0) {
>                printk(KERN_ERR "Unable to load isight firmware\n");
> @@ -59,7 +62,7 @@ static int isight_firmware_load(struct usb_interface *intf,
>                goto out;
>        }
>
> -       while (1) {
> +       while (ptr+4 <= firmware->data+firmware->size) {
>                memcpy(data, ptr, 4);
>                len = (data[0] << 8 | data[1]);
>                req = (data[2] << 8 | data[3]);
> @@ -71,10 +74,14 @@ static int isight_firmware_load(struct usb_interface *intf,
>                        continue;
>
>                for (; len > 0; req += 50) {
> -                       llen = len > 50 ? 50 : len;
> +                       llen = min(len, 50);
>                        len -= llen;
> -
> -                       buf = kmalloc(llen, GFP_KERNEL);
> +                       if (ptr+llen > firmware->data+firmware->size) {
> +                               printk(KERN_ERR
> +                                      "Malformed isight firmware");
> +                               ret = -ENODEV;
> +                               goto out;
> +                       }
>                        memcpy(buf, ptr, llen);
>
>                        ptr += llen;
> @@ -89,16 +96,18 @@ static int isight_firmware_load(struct usb_interface *intf,
>                                goto out;
>                        }
>
> -                       kfree(buf);
>                }
>        }
> +
>        if (usb_control_msg
>            (dev, usb_sndctrlpipe(dev, 0), 0xa0, 0x40, 0xe600, 0, "\0", 1,
>             300) != 1) {
>                printk(KERN_ERR "isight firmware loading completion failed\n");
>                ret = -ENODEV;
>        }
> +
>  out:
> +       kfree(buf);
>        release_firmware(firmware);
>        return ret;
>  }
>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
>

Also not matlock(not the T.V. show). Now onto the status:  I think
there might be something going on with this patch, or the module
itself I keep getting ACPI EC: GPE storm
detected(http://bugzilla.kernel.org/show_bug.cgi?id=10724) , yesterday
I modified drivers/acpi/ec.c and was not receiving this message the
rest of the day, after applying the patch to isight_firmware and
loading, I'm receiving this message probably within 20 minutes of
being up. Now I'm not sure If it's because I modified ec.c, or not
that's causing this. I'll have to run a couple of experiments to see.
has anybody seen the same message?
regards;

-- 
Justin P. Mattock
