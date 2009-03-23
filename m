Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbZCWIUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbZCWIUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756625AbZCWIUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:20:09 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58225 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289AbZCWIUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:20:08 -0400
Subject: Re: w35und driver unusable
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: luoyi <luoyi.ly@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <e9e614960903180722h49f3719fp3a947fd194066233@mail.gmail.com>
References: <e9e614960903162141g2f272f82jee434fc6fc748544@mail.gmail.com>
	 <84144f020903162307x3d164432m4132b0dd1487bae@mail.gmail.com>
	 <20090317090322.GA24133@elf.ucw.cz>
	 <e9e614960903170543p6117ce22qd0773d5a7cdd9977@mail.gmail.com>
	 <84144f020903170940nf76d905t43bfa497bd5fe6d5@mail.gmail.com>
	 <e9e614960903180722h49f3719fp3a947fd194066233@mail.gmail.com>
Date: Mon, 23 Mar 2009 10:20:04 +0200
Message-Id: <1237796404.6313.32.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Wed, 2009-03-18 at 22:22 +0800, luoyi wrote:
> just rmmod and modprobe it will trigger the oops.
> 
> I've just upload a oops snapshot picture onto flickr:
> 
> http://www.flickr.com/photos/21260339@N03/3364812089/
> 
> hope it will help for you.

Can you try this patch, please?

>From 727c633f7ac374261752b269ee77c007bd55a527 Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Mon, 23 Mar 2009 10:17:36 +0200
Subject: [PATCH] w35und: unregister device from the ieee80211 stack upon ->disconnect()

This patch fixes an oops when the w35und module is removed from the kernel and
added back.

Reported-by: luoyi <luoyi.ly@gmail.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/wbusb.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index f716b2e..7a7aa9a 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -386,7 +386,7 @@ static int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id
 	if (err)
 		goto error_free_hw;
 
-	usb_set_intfdata(intf, priv);
+	usb_set_intfdata(intf, dev);
 
 	return 0;
 
@@ -415,10 +415,15 @@ static void wb35_hw_halt(struct wbsoft_priv *adapter)
 
 static void wb35_disconnect(struct usb_interface *intf)
 {
-	struct wbsoft_priv *priv = usb_get_intfdata(intf);
+	struct ieee80211_hw *hw = usb_get_intfdata(intf);
+	struct wbsoft_priv *priv = hw->priv;
 
 	wb35_hw_halt(priv);
 
+	ieee80211_stop_queues(hw);
+	ieee80211_unregister_hw(hw);
+	ieee80211_free_hw(hw);
+
 	usb_set_intfdata(intf, NULL);
 	usb_put_dev(interface_to_usbdev(intf));
 }
-- 
1.5.4.3



