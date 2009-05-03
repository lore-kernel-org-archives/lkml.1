Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbZECQBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbZECQBR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 12:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbZECQA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 12:00:58 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:9273 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbZECQA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 12:00:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=q+gBdHDVILLjwSmU7IiYt9zs77BATHytfQv7HuTu2vxHTFHVK8VO5YGGsocCgoNM2j
         NzHEQOPnv4yjKyMJj8jA6vBnMt6LMcYJ7rCsppC7MlgHcGBb0xNMiMXr6E/0jsPNInuj
         xBsJhr7I/xftT8DSwel6AO3bhzjQDd+JoiNP0=
MIME-Version: 1.0
Date: Mon, 4 May 2009 00:00:56 +0800
Message-ID: <3a3680030905030900x672af596mc2ebc3c38f119c92@mail.gmail.com>
Subject: [PATCH] usb: use memdup_user()
From: Li Hong <lihong.hi@gmail.com>
To: oliver@neukum.name, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a combination call of kmalloc() and copy_from_user() with memdup_user().

Signed-off-by: Li Hong <lihong.hi@gmail.com>
---
 drivers/usb/class/cdc-wdm.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 0fe4345..326ecf3 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -324,18 +324,11 @@ static ssize_t wdm_write
                goto out;
        }

-       desc->outbuf = buf = kmalloc(count, GFP_KERNEL);
-       if (!buf) {
-               rv = -ENOMEM;
+       desc->outbuf = buf = memdup_user(buffer, count);
+       if (IS_ERR(buf)) {
+               rv = PTR_ERR(buf);
                goto out;
-       }
-
-       r = copy_from_user(buf, buffer, count);
-       if (r > 0) {
-               kfree(buf);
-               rv = -EFAULT;
-               goto out;
-       }
+       }

        req = desc->orq;
        usb_fill_control_urb(
-- 
1.6.2.GIT
