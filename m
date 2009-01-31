Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbZAaEV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbZAaEV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 23:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751025AbZAaEVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 23:21:18 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:55582 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbZAaEVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 23:21:18 -0500
From: =?utf-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, wferi@niif.hu, akpm@linux-foundation.org,
       =?utf-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH] ram_console: Disable ECC when early init is enabled and validate buffer size
Date: Fri, 30 Jan 2009 20:21:09 -0800
Message-Id: <1233375669-13517-1-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <20090131034002.GD2947@kroah.com>
References: <20090131034002.GD2947@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 drivers/staging/android/Kconfig       |    1 +
 drivers/staging/android/ram_console.c |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
index 6b996db..604bd1e 100644
--- a/drivers/staging/android/Kconfig
+++ b/drivers/staging/android/Kconfig
@@ -27,6 +27,7 @@ menuconfig ANDROID_RAM_CONSOLE_ERROR_CORRECTION
 	bool "Android RAM Console Enable error correction"
 	default n
 	depends on ANDROID_RAM_CONSOLE
+	depends on !ANDROID_RAM_CONSOLE_EARLY_INIT
 	select REED_SOLOMON
 	select REED_SOLOMON_ENC8
 	select REED_SOLOMON_DEC8
diff --git a/drivers/staging/android/ram_console.c b/drivers/staging/android/ram_console.c
index bf00685..643ac5c 100644
--- a/drivers/staging/android/ram_console.c
+++ b/drivers/staging/android/ram_console.c
@@ -224,9 +224,23 @@ static int __init ram_console_init(struct ram_console_buffer *buffer,
 	ram_console_buffer_size =
 		buffer_size - sizeof(struct ram_console_buffer);
 
+	if (ram_console_buffer_size > buffer_size) {
+		pr_err("ram_console: buffer %p, invalid size %d, datasize %d\n",
+		       buffer, buffer_size, ram_console_buffer_size);
+		return 0;
+	}
+
 #ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
 	ram_console_buffer_size -= (DIV_ROUND_UP(ram_console_buffer_size,
 						ECC_BLOCK_SIZE) + 1) * ECC_SIZE;
+
+	if (ram_console_buffer_size > buffer_size) {
+		pr_err("ram_console: buffer %p, invalid size %d, "
+		       "non-ecc datasize %d\n",
+		       buffer, buffer_size, ram_console_buffer_size);
+		return 0;
+	}
+
 	ram_console_par_buffer = buffer->data + ram_console_buffer_size;
 
 
-- 
1.6.1

