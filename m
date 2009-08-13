Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbZHMTrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbZHMTrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbZHMTrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:47:43 -0400
Received: from kroah.org ([198.145.64.141]:36685 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755512AbZHMTrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:47:41 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:43:35 2009
Message-Id: <20090813194335.721431880@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:40:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>, Juerg Haefliger <juergh@gmail.com>,
       Hans de Goede <hdegoede@redhat.com>
Subject: [patch 02/28] hwmon: (smsc47m1) Differentiate between LPC47M233 and LPC47M292
References: <20090813194021.446758568@mini.kroah.org>
Content-Disposition: inline; filename=hwmon-differentiate-between-lpc47m233-and-lpc47m292.patch
In-Reply-To: <20090813194554.GA13947@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit 1b54ab450b180eaeeb0eee6f0f64349246a22c14 upstream.

The SMSC LPC47M233 and LPC47M292 chips have the same device ID but
are not compatible.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Juerg Haefliger <juergh@gmail.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/smsc47m1.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/hwmon/smsc47m1.c
+++ b/drivers/hwmon/smsc47m1.c
@@ -85,6 +85,7 @@ superio_exit(void)
 #define SUPERIO_REG_ACT		0x30
 #define SUPERIO_REG_BASE	0x60
 #define SUPERIO_REG_DEVID	0x20
+#define SUPERIO_REG_DEVREV	0x21
 
 /* Logical device registers */
 
@@ -428,6 +429,9 @@ static int __init smsc47m1_find(unsigned
 	 * The LPC47M292 (device id 0x6B) is somewhat compatible, but it
 	 * supports a 3rd fan, and the pin configuration registers are
 	 * unfortunately different.
+	 * The LPC47M233 has the same device id (0x6B) but is not compatible.
+	 * We check the high bit of the device revision register to
+	 * differentiate them.
 	 */
 	switch (val) {
 	case 0x51:
@@ -447,6 +451,13 @@ static int __init smsc47m1_find(unsigned
 		sio_data->type = smsc47m1;
 		break;
 	case 0x6B:
+		if (superio_inb(SUPERIO_REG_DEVREV) & 0x80) {
+			pr_debug(DRVNAME ": "
+				 "Found SMSC LPC47M233, unsupported\n");
+			superio_exit();
+			return -ENODEV;
+		}
+
 		pr_info(DRVNAME ": Found SMSC LPC47M292\n");
 		sio_data->type = smsc47m2;
 		break;


