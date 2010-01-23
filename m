Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123Ab0AWASu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab0AWASu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614Ab0AWASn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:18:43 -0500
Received: from kroah.org ([198.145.64.141]:35008 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab0AWASl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:18:41 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jan 22 16:11:10 2010
Message-Id: <20100123001110.617642203@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 16:09:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eugeni Dodonov <eugeni@mandriva.com>
Subject: [03/29] Staging: asus_oled: fix oops in 2.6.32.2
In-Reply-To: <20100123001145.GA7391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eugeni Dodonov <eugeni@mandriva.com>

commit 20633bf0141c5e93e3396770d5eb7d200ee4068a upstream.

After updating to 2.6.32 kernel, I started experiencing Oopses caused by
the asus_oled module. After quick investigation, I wrapped this simple
patch which fixes an Oops in by asus_oled module on 2.6.32.2 kernel,
caused by incorrect usage of strict_strtoul function call within
set_enabled and set_disabled functions. This can be triggered by simple
running the userspace client for asus_old (e.g., 'asusoled -e' or
'asusoled -d').

Signed-off-by: Eugeni Dodonov <eugeni@mandriva.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/asus_oled/asus_oled.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -194,9 +194,11 @@ static ssize_t set_enabled(struct device
 {
 	struct usb_interface *intf = to_usb_interface(dev);
 	struct asus_oled_dev *odev = usb_get_intfdata(intf);
-	int temp = strict_strtoul(buf, 10, NULL);
+	unsigned long value;
+	if (strict_strtoul(buf, 10, &value))
+		return -EINVAL;
 
-	enable_oled(odev, temp);
+	enable_oled(odev, value);
 
 	return count;
 }
@@ -207,10 +209,12 @@ static ssize_t class_set_enabled(struct 
 {
 	struct asus_oled_dev *odev =
 		(struct asus_oled_dev *) dev_get_drvdata(device);
+	unsigned long value;
 
-	int temp = strict_strtoul(buf, 10, NULL);
+	if (strict_strtoul(buf, 10, &value))
+		return -EINVAL;
 
-	enable_oled(odev, temp);
+	enable_oled(odev, value);
 
 	return count;
 }


