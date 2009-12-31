Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbZLaPnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbZLaPnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 10:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZLaPnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 10:43:24 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:58390 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbZLaPnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 10:43:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=wDMcFXhtCyWUhf5WhuG9VPN57xhHUWbukxMH8DgV8DL5d0e2yoIRPMghNZYgEXckqH
         Uye4yv88wv78F9wqGHCEr4+LqI/JpUoUVYsptpvtCLEuAn50wPNPZ9k6BZpaFynj5Kd2
         OcVc7Mlh0f0w4BlYEVlBZcCv0mP05D1xnHF5Y=
Date: Thu, 31 Dec 2009 17:42:55 +0200
From: Dan Carpenter <error27@gmail.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch v2] USB: serial: fix DMA buffers on stack for io_edgeport.c
Message-ID: <20091231154255.GC21362@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Johan Hovold <jhovold@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com> <20091230160645.GC29476@bicker> <20091230171457.GA15063@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091230171457.GA15063@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original code was passing a stack variable as a dma buffer, so I 
made it an allocated variable.  Instead of adding a bunch of kfree()
calls, I changed all the error return paths to gotos.

Also I noticed that the error checking wasn't correct because
usb_get_descriptor() can return negative values.

While I was at it, I made an unrelated white space change by moving
the unicode_to_ascii() on to one line.

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/usb/serial/io_edgeport.c	2009-12-30 16:20:35.000000000 +0200
+++ devel/drivers/usb/serial/io_edgeport.c	2009-12-30 23:48:53.000000000 +0200
@@ -372,31 +372,32 @@ static void update_edgeport_E2PROM(struc
  ************************************************************************/
 static int get_string(struct usb_device *dev, int Id, char *string, int buflen)
 {
-	struct usb_string_descriptor StringDesc;
-	struct usb_string_descriptor *pStringDesc;
+	struct usb_string_descriptor *StringDesc = NULL;
+	struct usb_string_descriptor *pStringDesc = NULL;
+	int ret = 0;
 
 	dbg("%s - USB String ID = %d", __func__, Id);
 
-	if (!usb_get_descriptor(dev, USB_DT_STRING, Id,
-					&StringDesc, sizeof(StringDesc)))
-		return 0;
+	StringDesc = kmalloc(sizeof(*StringDesc), GFP_KERNEL);
+	if (!StringDesc)
+		goto free;
+	if (usb_get_descriptor(dev, USB_DT_STRING, Id, StringDesc, sizeof(*StringDesc)) <= 0)
+		goto free;
 
-	pStringDesc = kmalloc(StringDesc.bLength, GFP_KERNEL);
+	pStringDesc = kmalloc(StringDesc->bLength, GFP_KERNEL);
 	if (!pStringDesc)
-		return 0;
+		goto free;
 
-	if (!usb_get_descriptor(dev, USB_DT_STRING, Id,
-					pStringDesc, StringDesc.bLength)) {
-		kfree(pStringDesc);
-		return 0;
-	}
-
-	unicode_to_ascii(string, buflen,
-				pStringDesc->wData, pStringDesc->bLength/2);
+	if (usb_get_descriptor(dev, USB_DT_STRING, Id, pStringDesc, StringDesc->bLength) <= 0)
+		goto free;
 
-	kfree(pStringDesc);
+	unicode_to_ascii(string, buflen, pStringDesc->wData, pStringDesc->bLength/2);
+	ret = strlen(string);
 	dbg("%s - USB String %s", __func__, string);
-	return strlen(string);
+free:
+	kfree(StringDesc);
+	kfree(pStringDesc);
+	return ret;
 }
 
 
