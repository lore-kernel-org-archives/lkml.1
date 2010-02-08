Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab0BHSHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 13:07:21 -0500
Received: from ppp-156-198.adsl.restena.lu ([158.64.156.198]:59362 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab0BHSHT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 13:07:19 -0500
Date: Mon, 8 Feb 2010 19:06:49 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oliver@neukum.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Marcel Holtmann <marcel@holtmann.org>,
       H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: S2R resume crash in 2.6.33-rc7 - NULL pointer dereference in
 dev_get_drvdata() for usbhid
Message-ID: <20100208190649.0ceea556@neptune.home>
In-Reply-To: <20100208175145.606ca761@neptune.home>
References: <20100208175145.606ca761@neptune.home>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 February 2010 Bruno Prémont <bonbons@linux-vserver.org> wrote:
> 2.6.33-rc7 (don't know if any previous version resumes properly)
> crashes during resume from S2Ram when my USB keyboard is connected but
> resumes properly (viafb corruption put apart) when the USB keyboard is
> not connected.

The patch below works around the crash though the WARN_ON() in
usbhid_restart_out_queue() triggers in place.

Bruno

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index e2997a8..d2f8eef 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -196,7 +196,7 @@ static void usbhid_mark_busy(struct usbhid_device *usbhid)
 
 static int usbhid_restart_out_queue(struct usbhid_device *usbhid)
 {
-	struct hid_device *hid = usb_get_intfdata(usbhid->intf);
+	struct hid_device *hid = usbhid->intf ? usb_get_intfdata(usbhid->intf) : NULL;
 	int kicked;
 
 	if (!hid)
@@ -214,7 +214,7 @@ static int usbhid_restart_out_queue(struct usbhid_device *usbhid)
 
 static int usbhid_restart_ctrl_queue(struct usbhid_device *usbhid)
 {
-	struct hid_device *hid = usb_get_intfdata(usbhid->intf);
+	struct hid_device *hid = usbhid->intf ? usb_get_intfdata(usbhid->intf) : NULL;
 	int kicked;
 
 	WARN_ON(hid == NULL);
