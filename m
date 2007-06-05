Return-Path: <linux-kernel-owner+w=401wt.eu-S1764516AbXFELXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764516AbXFELXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 07:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762970AbXFELXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 07:23:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:63376 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408AbXFELXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 07:23:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=qG4eTMRVs4m9NGtylXRIqVD4+9PamGMptdJtu0d6Jhu7j52fm9cunzbnvfJgIIKlHEiuusFNhJiV3102JBvMb2d7u6N2gH+hu344aiFFAqLUwTZU6zMfqwcs/Z76PGQHrr4Muz2Gx0jWcnJ90sS5ZKcBAxKkFoov5FmuTjbiOQU=
Message-ID: <46654796.3060800@gmail.com>
Date: Tue, 05 Jun 2007 22:23:02 +1100
From: Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20061107)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.21.3] ppp_mppe: account for osize too small errors in
 mppe_decompress()
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent mppe_decompress() from generating "osize too small" errors when checking
for output buffer size. When receiving a packet of mru size the output buffer
for decrypted data is 1 byte too small since mppe_decompress() tries to account
for possible PFC, however later in code it is assumed no PFC.

Adjusting the check prevented there errors from occurring.

Signed-off-by: Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com>
---
--- linux-2.6.21.3/drivers/net/ppp_mppe.c.orig	2007-06-01 20:57:04.000000000 +1100
+++ linux-2.6.21.3/drivers/net/ppp_mppe.c	2007-06-05 21:46:30.000000000 +1100
@@ -493,14 +493,14 @@ mppe_decompress(void *arg, unsigned char

 	/*
 	 * Make sure we have enough room to decrypt the packet.
-	 * Note that for our test we only subtract 1 byte whereas in
-	 * mppe_compress() we added 2 bytes (+MPPE_OVHD);
-	 * this is to account for possible PFC.
+	 * To account for possible PFC we should only subtract 1
+	 * byte whereas in mppe_compress() we added 2 bytes (+MPPE_OVHD);
+	 * However, we assume no PFC, thus subtracting 2 bytes.
 	 */
-	if (osize < isize - MPPE_OVHD - 1) {
+	if (osize < isize - MPPE_OVHD - 2) {
 		printk(KERN_DEBUG "mppe_decompress[%d]: osize too small! "
 		       "(have: %d need: %d)\n", state->unit,
-		       osize, isize - MPPE_OVHD - 1);
+		       osize, isize - MPPE_OVHD - 2);
 		return DECOMP_ERROR;
 	}
 	osize = isize - MPPE_OVHD - 2;	/* assume no PFC */
