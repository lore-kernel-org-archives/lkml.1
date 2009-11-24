Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492AbZKXAhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbZKXAhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 19:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757450AbZKXAht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 19:37:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757410AbZKXAhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 19:37:48 -0500
Date: Mon, 23 Nov 2009 16:37:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: David Vrabel <david.vrabel@csr.com>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wusb: Use sizeof struct rather than pointer
Message-Id: <20091123163745.60c719c7.akpm@linux-foundation.org>
In-Reply-To: <4B0836A2.1000805@gmail.com>
References: <4B0836A2.1000805@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Nov 2009 19:51:14 +0100
Roel Kluin <roel.kluin@gmail.com> wrote:

> The sizeof the struct should be used rather than sizeof the pointer
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/usb/wusbcore/security.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Unless I am mistaken?
> 
> diff --git a/drivers/usb/wusbcore/security.c b/drivers/usb/wusbcore/security.c
> index 4516c36..857f6e9 100644
> --- a/drivers/usb/wusbcore/security.c
> +++ b/drivers/usb/wusbcore/security.c
> @@ -213,7 +213,7 @@ int wusb_dev_sec_add(struct wusbhc *wusbhc,
>  
>  	result = usb_get_descriptor(usb_dev, USB_DT_SECURITY,
>  				    0, secd, sizeof(struct usb_security_descriptor));
> -	if (result < sizeof(secd)) {
> +	if (result < sizeof(*secd)) {
>  		dev_err(dev, "Can't read security descriptor or "
>  			"not enough data: %d\n", result);
>  		goto out;

ick, code's a bit of a mess.

This:

--- a/drivers/usb/wusbcore/security.c~wusb-use-sizeof-struct-rather-than-pointer
+++ a/drivers/usb/wusbcore/security.c
@@ -205,15 +205,15 @@ int wusb_dev_sec_add(struct wusbhc *wusb
 	const void *itr, *top;
 	char buf[64];
 
-	secd = kmalloc(sizeof(struct usb_security_descriptor), GFP_KERNEL);
+	secd = kmalloc(sizeof(*secd), GFP_KERNEL);
 	if (secd == NULL) {
 		result = -ENOMEM;
 		goto out;
 	}
 
-	result = usb_get_descriptor(usb_dev, USB_DT_SECURITY,
-				    0, secd, sizeof(struct usb_security_descriptor));
-	if (result < sizeof(secd)) {
+	result = usb_get_descriptor(usb_dev, USB_DT_SECURITY, 0, secd,
+					sizeof(*secd));
+	if (result < sizeof(*secd)) {
 		dev_err(dev, "Can't read security descriptor or "
 			"not enough data: %d\n", result);
 		goto out;
_

at least makes things consistent.

But I wonder if the code will still work.  Because we then go on to do

        secd_size = le16_to_cpu(secd->wTotalLength);
        secd = krealloc(secd, secd_size, GFP_KERNEL);

which implies (to me) that the thing we read from the device might
indeed have been smaller than we expected, in which case the
newly-fixed check will cause a failure.

That's probably not the case, but it needs checking by someone who
knows what's going on here, please


