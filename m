Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbZL3QHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbZL3QHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 11:07:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZL3QHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 11:07:04 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:54592 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbZL3QHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 11:07:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=IBruhAmxYZiprt4DRKyPDJOobsfW95ERDLQVOC+Ort/MVj43Uz9NpqqAMuCId71Gr1
         QVmMDXuETyYhePSGLfJWqKeObMXWrqkG5Rq+RWdeu6r35yiKooDLOK9g4rzxLofijeBY
         3gvdsCQ2T7ylId1rmj8w5eBz1dJR+jCDZNIG4=
Date: Wed, 30 Dec 2009 18:06:45 +0200
From: Dan Carpenter <error27@gmail.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch] USB: serial: fix DMA buffers on stack for io_edgeport.c
Message-ID: <20091230160645.GC29476@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Johan Hovold <jhovold@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original code did DMA on a stack variable, so I made it an allocated 
pointer.

Compile tested only.

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/usb/serial/io_edgeport.c	2009-12-30 16:20:35.000000000 +0200
+++ devel/drivers/usb/serial/io_edgeport.c	2009-12-30 16:25:27.000000000 +0200
@@ -372,21 +372,24 @@ static void update_edgeport_E2PROM(struc
  ************************************************************************/
 static int get_string(struct usb_device *dev, int Id, char *string, int buflen)
 {
-	struct usb_string_descriptor StringDesc;
+	struct usb_string_descriptor *StringDesc;
 	struct usb_string_descriptor *pStringDesc;
 
 	dbg("%s - USB String ID = %d", __func__, Id);
 
+	StringDesc = kmalloc(sizeof(*StringDesc), GFP_KERNEL);
+	if (!StringDesc)
+		return 0;
 	if (!usb_get_descriptor(dev, USB_DT_STRING, Id,
-					&StringDesc, sizeof(StringDesc)))
+					StringDesc, sizeof(*StringDesc)))
 		return 0;
 
-	pStringDesc = kmalloc(StringDesc.bLength, GFP_KERNEL);
+	pStringDesc = kmalloc(StringDesc->bLength, GFP_KERNEL);
 	if (!pStringDesc)
 		return 0;
 
 	if (!usb_get_descriptor(dev, USB_DT_STRING, Id,
-					pStringDesc, StringDesc.bLength)) {
+					pStringDesc, StringDesc->bLength)) {
 		kfree(pStringDesc);
 		return 0;
 	}
