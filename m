Return-Path: <linux-kernel-owner+w=401wt.eu-S1752733AbZLaPtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbZLaPtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 10:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbZLaPs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 10:48:57 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41339 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbZLaPsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 10:48:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZECFdTgFWcuLkjDCncioH20pO5EZUE6DsD0yXe1KeA7J1RFh6ONq293toCZT9/bWqB
         JMTwEz0FmU/GFXQWZOxOJwKxc42QYqAZO876Of+F+s4qvf1k/F1mbI9czlb7x3QPnYRp
         8YAoqwJNePqmMJKV1yrRt3bTCcQsJ6odMcxR8=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>, Lonnie Mendez <dignome@gmail.com>
Subject: [PATCH 05/13] USB: cypress_m8: fix endianess bug and alignment
Date: Thu, 31 Dec 2009 16:48:01 +0100
Message-Id: <1262274489-12447-6-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Lonnie Mendez <dignome@gmail.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/cypress_m8.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index 1ce1a3a..b19e16a 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -66,6 +66,7 @@
 #include <linux/serial.h>
 #include <linux/delay.h>
 #include <linux/uaccess.h>
+#include <asm/unaligned.h>
 
 #include "cypress_m8.h"
 
@@ -376,7 +377,7 @@ static int cypress_serial_control(struct tty_struct *tty,
 					__func__, new_baudrate);
 
 		/* fill the feature_buffer with new configuration */
-		*((u_int32_t *)feature_buffer) = new_baudrate;
+		put_unaligned_le32(new_baudrate, feature_buffer);
 		feature_buffer[4] |= data_bits;   /* assign data bits in 2 bit space ( max 3 ) */
 		/* 1 bit gap */
 		feature_buffer[4] |= (stop_bits << 3);   /* assign stop bits in 1 bit space */
@@ -453,7 +454,7 @@ static int cypress_serial_control(struct tty_struct *tty,
 			/* store the config in one byte, and later
 			   use bit masks to check values */
 			priv->current_config = feature_buffer[4];
-			priv->baud_rate = *((u_int32_t *)feature_buffer);
+			priv->baud_rate = get_unaligned_le32(feature_buffer);
 			spin_unlock_irqrestore(&priv->lock, flags);
 		}
 	}
-- 
1.6.6

