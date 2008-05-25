Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbYEYOOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbYEYOOi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 10:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbYEYOO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 10:14:28 -0400
Received: from mail.hauppauge.com ([167.206.143.4]:1898 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbYEYOOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 10:14:24 -0400
Message-ID: <48397436.8040102@linuxtv.org>
Date: Sun, 25 May 2008 10:14:14 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel@vger.kernel.org, sam@ravnborg.org, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org,
       Patrick Boettcher <patrick.boettcher@desy.de>,
       Chris Pascoe <c.pascoe@itee.uq.edu.au>
Subject: Re: [PATCHv2 22/28] cxusb: treat firmware data as const
References: <1211708969@pmac.infradead.org> <E1K0DOK-0007EC-6q@shinybook.infradead.org>
In-Reply-To: <E1K0DOK-0007EC-6q@shinybook.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

It's broken...  Please see fix, below:

David Woodhouse wrote:
> ...which means allocating our own copy when we want to modify it.
>
> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> ---
>  drivers/media/dvb/dvb-usb/cxusb.c |   21 ++++++++++++++++++---
>  1 files changed, 18 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/dvb/dvb-usb/cxusb.c b/drivers/media/dvb/dvb-usb/cxusb.c
> index 720fcd1..94bb482 100644
> --- a/drivers/media/dvb/dvb-usb/cxusb.c
> +++ b/drivers/media/dvb/dvb-usb/cxusb.c
> @@ -24,6 +24,7 @@
>   * see Documentation/dvb/README.dvb-usb for more information
>   */
>  #include <media/tuner.h>
> +#include <linux/vmalloc.h>
>  
>  #include "cxusb.h"
>  
> @@ -700,12 +701,26 @@ static int bluebird_patch_dvico_firmware_download(struct usb_device *udev,
>  
>  		if (fw->data[idoff] == (USB_VID_DVICO & 0xff) &&
>  		    fw->data[idoff + 1] == USB_VID_DVICO >> 8) {
> -			fw->data[idoff + 2] =
> +			struct firmware new_fw;
> +			u8 *new_fw_data = vmalloc(fw->size);
> +			int ret;
> +
> +			if (!new_fw_data)
> +				return -ENOMEM;
> +
> +			memcpy(new_fw_data, fw->data, fw->size);
> +			new_fw.size = fw->size;
> +			new_fw.data = fw->data;
> +
> +			new_fw_data[idoff + 2] =
>  				le16_to_cpu(udev->descriptor.idProduct) + 1;
> -			fw->data[idoff + 3] =
> +			new_fw_data[idoff + 3] =
>  				le16_to_cpu(udev->descriptor.idProduct) >> 8;
>  
> -			return usb_cypress_load_firmware(udev, fw, CYPRESS_FX2);
> +			ret = usb_cypress_load_firmware(udev, &new_fw,
> +							CYPRESS_FX2);
> +			vfree(new_fw_data);
> +			return ret;
>  		}
>  	}
>  
>   
The unmodified firmware was being uploaded to the device, instead of the patched firmware :-(

After making this additional one-line change, the patch works fine.

Please feel free to fold this into your own patch.

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>

---
 linux/drivers/media/dvb/dvb-usb/cxusb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/dvb/dvb-usb/cxusb.c
+++ b/drivers/media/dvb/dvb-usb/cxusb.c
@@ -710,7 +710,7 @@
 
 			memcpy(new_fw_data, fw->data, fw->size);
 			new_fw.size = fw->size;
-			new_fw.data = fw->data;
+			new_fw.data = new_fw_data;
 
 			new_fw_data[idoff + 2] =
 				le16_to_cpu(udev->descriptor.idProduct) + 1;






