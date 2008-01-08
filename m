Return-Path: <linux-kernel-owner+w=401wt.eu-S1756494AbYAHWUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbYAHWUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:20:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbYAHWTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:19:20 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:13444 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155AbYAHWTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:19:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding:from;
        b=LknqCVDFrJ/1aDeGt5hpTJhSzMuFkny3HmsxTVWCFKXxPCKAhAnDuMftK5G1rTOKesiyMZdQfLaonOfYDFMYGcfDCouAP4lZ6p+pIvbz/AdRaBDUlbF3INjC8rnl5WdapFDt2IFTso5ext/JE4t0BxR/7NXMJMmd4azVGRncy8c=
Subject: [PATCH] Fix 2.6.24-rc7 regression in asix.c
To: linux-kernel@vger.kernel.org
Cc: linux-net@vget.kernel.org
Content-Type: text/plain
Date: Tue, 08 Jan 2008 15:17:27 -0700
Message-Id: <1199830647.30986.1.camel@russ-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.4 
Content-Transfer-Encoding: 7bit
From: Russ Dill <russ.dill@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

51bf2976 caused a regression in the asix usbnet driver. usb_control_msg
returns the number of bytes read on success, not 0. Tested with NETGEAR
FA120.

Signed-off-by: Russ Dill <Russ.Dill@gmail.com>
---
 drivers/net/usb/asix.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/asix.c b/drivers/net/usb/asix.c
index 1249f44..569028b 100644
--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -202,10 +202,10 @@ static int asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 		buf,
 		size,
 		USB_CTRL_GET_TIMEOUT);
-	if (err >= 0 && err < size)
-		err = -EINVAL;
-	if (!err)
+	if (err == size)
 		memcpy(data, buf, size);
+	else if (err >= 0)
+		err = -EINVAL;
 	kfree(buf);
 
 out:
-- 
1.5.3.7



