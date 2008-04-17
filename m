Return-Path: <linux-kernel-owner+w=401wt.eu-S933179AbYDQQIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179AbYDQQIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 12:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761815AbYDQQHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 12:07:55 -0400
Received: from ns2.gothnet.se ([82.193.160.251]:8333 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760472AbYDQQHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 12:07:54 -0400
From: Thomas Hellstrom <thomas@tungstengraphics.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Hellstrom <thomas@tungstengraphics.com>
Subject: [PATCH][Resend] Fix loading of large firmware files
Date: Thu, 17 Apr 2008 19:07:39 +0200
Message-Id: <1208452059-31415-1-git-send-email-thomas@tungstengraphics.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <12084421001860-git-send-email-thomas@tungstengraphics.com>
References: <12084421001860-git-send-email-thomas@tungstengraphics.com>
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Firmware loading has a memory allocation complexity of
O(size * size), which makes loads of very large firmware files
stall and fail. This patch fixes that problem by making the
allocation complexity O(size * ln(size)).
Signed-off-by: Thomas Hellstrom <thomas@tungstengraphics.com>
---
 drivers/base/firmware_class.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 4a1b9bf..4215cbf 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -206,7 +206,9 @@ fw_realloc_buffer(struct firmware_priv *
 	if (min_size <= fw_priv->alloc_size)
 		return 0;
 
-	new_size = ALIGN(min_size, PAGE_SIZE);
+	new_size = 2 * new_size;
+	new_size = (min_size > new_size) ? min_size : new_size;
+	new_size = ALIGN(new_size, PAGE_SIZE);
 	new_data = vmalloc(new_size);
 	if (!new_data) {
 		printk(KERN_ERR "%s: unable to alloc buffer\n", __FUNCTION__);
-- 
1.4.1



