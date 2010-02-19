Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab0BSUHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 15:07:10 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:45327 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab0BSUHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 15:07:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=c6EgigEWth0Oxm+PJvZCwnTq4g6OJY8egW2d/QJmKJMNjPq27PsFDswnGjunQ3d2wt
         9ksttMOpb2IBZK/DgH+sIeWKP7ez+yHQkG8X6aqwAKDS20o8MUCKk+J+7b2aH+zu3IRd
         bvJyMBs6Ljv98dOda1mDirZNXUa+Pzac9M6Sc=
Message-ID: <4B7EF13C.80009@gmail.com>
Date: Fri, 19 Feb 2010 21:14:52 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>, linux-i2c@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] i2c: dereference of NULL if request_irq() failsin sh_mobile_i2c_hook_irqs()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the last iteration k equals 0, so we call platform_get_resource() with
-1 as a third argument. Since platform_get_resource() uses an unsigned it
is converted to 0xffffffff. platform_get_resource() fails for every index
and returns NULL. A test is lacking and we dereference NULL.

Also the variable q was assigned but not used.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/i2c/busses/i2c-sh_mobile.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-sh_mobile.c b/drivers/i2c/busses/i2c-sh_mobile.c
index ccc4641..5871335 100644
--- a/drivers/i2c/busses/i2c-sh_mobile.c
+++ b/drivers/i2c/busses/i2c-sh_mobile.c
@@ -496,7 +496,7 @@ static int sh_mobile_i2c_hook_irqs(struct platform_device *dev, int hook)
 {
 	struct resource *res;
 	int ret = -ENXIO;
-	int q, m;
+	int m;
 	int k = 0;
 	int n = 0;
 
@@ -516,12 +516,16 @@ static int sh_mobile_i2c_hook_irqs(struct platform_device *dev, int hook)
 	ret = 0;
 
  rollback:
-	for (q = k; k >= 0; k--) {
-		for (m = n; m >= res->start; m--)
-			free_irq(m, dev);
+	for (m = n; m >= res->start; m--)
+		free_irq(m, dev);
 
+	while (k--) {
 		res = platform_get_resource(dev, IORESOURCE_IRQ, k - 1);
-		m = res->end;
+		if (res == NULL)
+			break;
+
+		for (m = res->end; m >= res->start; m--)
+			free_irq(m, dev);
 	}
 
 	return ret;
