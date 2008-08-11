Return-Path: <linux-kernel-owner+w=401wt.eu-S1757321AbYHKT4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbYHKT4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbYHKT4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:56:07 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:35004 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbYHKT4E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:56:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=EgXSJ47axAWkJ7sN6teTRID7dH3o3nWBmfHu32dJrrtjuO3Jg1DQiCwV5IGR0eP04F
         oBMC0vrr6viQkxF0wDuXKfPqGo7ogpX5Dr269Z/PN5QgwJSMq651FSTsYmbcDnj+FgRJ
         kyCC05DciSSB/d/vBpA4sFk8rOvMfNnDn/0xU=
From: Oliver Pinter <oliver.pntr@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC, 2.6.26.3-rc1]  i2c: Fix NULL pointer dereference in i2c_new_probed_device
Date: Mon, 11 Aug 2008 22:07:53 +0200
User-Agent: KMail/1.9.9
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Jean Delvare <khali@linux-fr.org>,
       Oliver Pinter <oliver.pntr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808112207.53563.oliver.pntr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From b25b791b13aaa336b56c4f9bd417ff126363f80b Mon Sep 17 00:00:00 2001
It is an RFC for sending this patch for stable, when this patch needed, then send ACK and CC stable,
 if not then send NAK.

---

From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 10 Aug 2008 22:56:15 +0200
Subject: [PATCH] i2c: Fix NULL pointer dereference in i2c_new_probed_device

Fix a NULL pointer dereference that happened when calling
i2c_new_probed_device on one of the addresses for which we use byte
reads instead of quick write for detection purpose (that is: 0x30-0x37
and 0x50-0x5f).

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 7bf38c4..c16dcad 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1451,9 +1451,11 @@ i2c_new_probed_device(struct i2c_adapter *adap,
 		if ((addr_list[i] & ~0x07) == 0x30
 		 || (addr_list[i] & ~0x0f) == 0x50
 		 || !i2c_check_functionality(adap, I2C_FUNC_SMBUS_QUICK)) {
+			union i2c_smbus_data data;
+
 			if (i2c_smbus_xfer(adap, addr_list[i], 0,
 					   I2C_SMBUS_READ, 0,
-					   I2C_SMBUS_BYTE, NULL) >= 0)
+					   I2C_SMBUS_BYTE, &data) >= 0)
 				break;
 		} else {
 			if (i2c_smbus_xfer(adap, addr_list[i], 0,

