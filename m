Return-Path: <linux-kernel-owner+w=401wt.eu-S1759034AbYBYVph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034AbYBYVph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 16:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756850AbYBYVp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 16:45:29 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:27835 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbYBYVp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 16:45:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=UNShAUbmh0hicrFSdpFrfzUMCJ7u4vulYN4HINQNtKSkLDtdJ/L2MaxLPzYA18qhGldSRNG6I+XGDY7utvPyVZf0UMt0jYw7AqwKVZ9JWIuxKXKVCeqr0hAKek79hz1SjN+v79NOBmOBZl99wDyJW3zOClBVZrWOrhqmE+TVDMQ=
Date: Tue, 26 Feb 2008 00:24:26 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Matt Reimer <mreimer@vpop.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] [W1] ds1wm: should check for IS_ERR(clk) instead of
	NULL
Message-ID: <20080225212426.GA29891@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the error condition clk_get() returns ERR_PTR(..), so checking
for NULL doesn't work. ds1wm module causes a kernel oops when ds1wm
clock isn't registered.

This patch converts NULL check to IS_ERR(), plus uses PTR_ERR()
for the return code.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 drivers/w1/masters/ds1wm.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index 688e435..78a14da 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -17,6 +17,7 @@
 #include <linux/pm.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
+#include <linux/err.h>
 #include <linux/delay.h>
 #include <linux/ds1wm.h>
 
@@ -374,8 +375,8 @@ static int ds1wm_probe(struct platform_device *pdev)
 		goto err1;
 
 	ds1wm_data->clk = clk_get(&pdev->dev, "ds1wm");
-	if (!ds1wm_data->clk) {
-		ret = -ENOENT;
+	if (IS_ERR(ds1wm_data->clk)) {
+		ret = PTR_ERR(ds1wm_data->clk);
 		goto err2;
 	}
 
-- 
1.5.4.3

