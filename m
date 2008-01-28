Return-Path: <linux-kernel-owner+w=401wt.eu-S1762790AbYA1Wnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762790AbYA1Wnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755617AbYA1WnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:43:23 -0500
Received: from mail.gmx.net ([213.165.64.20]:51897 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751684AbYA1WnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:43:22 -0500
X-Authenticated: #2283611
X-Provags-ID: V01U2FsdGVkX1/eVCEzBwreyGLUcOlrhSDLTmBs6tmD6YyAk9jNLG
	Tqz1QrlMuXENXo
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] radio-si470x.c: check-after-use
Date: Mon, 28 Jan 2008 23:43:13 +0100
User-Agent: KMail/1.9.7
Cc: Adrian Bunk <bunk@kernel.org>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
References: <20080128221300.GH8767@does.not.exist>
In-Reply-To: <20080128221300.GH8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801282343.13589.tobias.lorenz@gmx.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,
Hi Adrian,

Adrian used the coverity checker against radio-si470x and found this:

> The Coverity checker spotted the following check-after-use in 
> drivers/media/radio/radio-si470x.c:
> 
> <--  snip  -->
> static void si470x_usb_driver_disconnect(struct usb_interface *intf)
> {
>         struct si470x_device *radio = usb_get_intfdata(intf);
> 
>         del_timer_sync(&radio->timer);    <------------------
>         flush_scheduled_work();
> 
>         usb_set_intfdata(intf, NULL);
>         if (radio) {                      <------------------
>                 video_unregister_device(radio->videodev);
>                 kfree(radio->buffer);
>                 kfree(radio);
>         }
> }
> <--  snip  -->
> 
> Either "radio" can be NULL and this case has to be properly handled or 
> the NULL check is not required.

These two lines should indeed better be inside the if statement. The patch for this is below.

Thanks,
  Toby

Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
--- linux-2.6.23/drivers/media/radio/radio-si470x.c     2008-01-23 00:01:07.000000000 +0100
+++ linux-2.6.23.new/drivers/media/radio/radio-si470x.c 2008-01-27 15:31:42.000000000 +0100
@@ -1440,11 +1440,10 @@ static void si470x_usb_driver_disconnect
 {
        struct si470x_device *radio = usb_get_intfdata(intf);

-       del_timer_sync(&radio->timer);
-       flush_scheduled_work();
-
        usb_set_intfdata(intf, NULL);
        if (radio) {
+               del_timer_sync(&radio->timer);
+               flush_scheduled_work();
                video_unregister_device(radio->videodev);
                kfree(radio->buffer);
                kfree(radio);
