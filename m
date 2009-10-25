Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbZJYRxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbZJYRxj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 13:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbZJYRxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 13:53:32 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:57168 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbZJYRxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 13:53:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=soDXwe5dz4yIqplUT40SEyATYgUHjDwVdcz0ztFnUOlwbgYgopSdEnaGFOZudMcAiz
         eqGFTFyPBHxNmCY7tyWl9OP+3nKU3T6ERjYFcZYOYQEwuaFbeyCivc+16kUT9SAf9uoh
         Truh+xtXbdQS1OpEXn3aK+Tvvj4+Gp3qzvisg=
Message-Id: <20091025175323.594610803@gmail.com>
References: <20091025175057.270011110@gmail.com>
User-Agent: quilt/0.46-1
Date: Sun, 25 Oct 2009 18:51:01 +0100
From: bart.hartgers@gmail.com
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bart Hartgers <bart.hartgers@gmail.com>
Subject: [PATCH 4/7] ark3116: (3rd try) Add atomic set-and-clear function
Content-Disposition: inline; filename=0024_ark3116_atomic_set_clear.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bart Hartgers <bart.hartgers@gmail.com>
---
Index: linux-2.6.32-rc4/drivers/usb/serial/ark3116.c
===================================================================
--- linux-2.6.32-rc4.orig/drivers/usb/serial/ark3116.c	2009-10-18 16:20:13.000000000 +0200
+++ linux-2.6.32-rc4/drivers/usb/serial/ark3116.c	2009-10-18 16:20:17.000000000 +0200
@@ -151,6 +151,33 @@ static inline void ARK3116_RCV_QUIET(str
 			buf, 0x0000001, 1000);
 }
 
+static inline void ark3116_atomic_set_clear(unsigned set,
+					    unsigned clear, atomic_t *at)
+{
+	if ((clear == 0) && (set == 0))
+		return;
+#if defined(atomic_set_mask)
+	if (clear == 0) {
+		atomic_set_mask(set, at);
+		return;
+	}
+#endif
+#if defined(atomic_clear_mask)
+	if (set == 0) {
+		atomic_clear_mask(clear, at);
+		return;
+	}
+#endif
+	/* operation needs to be atomic */
+	for (;;) {
+		register unsigned old = atomic_read(at);
+		register unsigned prev = atomic_cmpxchg(at, old,
+							(old|set)&(~clear));
+		if (likely(prev == old))
+			break;
+	}
+}
+
 static inline int calc_divisor(int bps)
 {
 	/* Original ark3116 made some exceptions in rounding here

-- 
