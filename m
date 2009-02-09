Return-Path: <linux-kernel-owner+w=401wt.eu-S1757708AbZBITh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708AbZBITh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757241AbZBITgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:36:00 -0500
Received: from kroah.org ([198.145.64.141]:34766 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757275AbZBITfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:35:43 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/6] Staging: android: ram_console: Disable ECC when early init is enabled and validate buffer size
Date: Mon,  9 Feb 2009 11:34:04 -0800
Message-Id: <1234208046-2295-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.1.2
In-Reply-To: <20090209193201.GB2194@kroah.com>
References: <20090209193201.GB2194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.6.0.2

