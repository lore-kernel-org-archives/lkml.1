Return-Path: <linux-kernel-owner+w=401wt.eu-S1758490AbZLNVtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490AbZLNVtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:49:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758368AbZLNVsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:48:07 -0500
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:47307 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758353AbZLNVsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:48:05 -0500
Date: Mon, 14 Dec 2009 21:45:19 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       akpm@linux-foundation.org
Cc: phillip@lougher.demon.co.uk, mingo@elte.hu,
       albin.tonnerre@free-electrons.com
Subject: [PATCH 3/3] initramfs: add missing decompressor error check
Message-ID: <4b26b1ef.0+ZWxT6886olqcSc%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The decompressors return error by calling a supplied error function, and/or
by returning an error return value.  The initramfs code, however, fails to
check the exit code returned by the decompressor, and only checks the error
status set by calling the error function.

This patch adds a return code check and calls the error function.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 init/initramfs.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index 4c00edc..b37d34b 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -413,7 +413,7 @@ static unsigned my_inptr;   /* index of next byte to be processed in inbuf */
 
 static char * __init unpack_to_rootfs(char *buf, unsigned len)
 {
-	int written;
+	int written, res;
 	decompress_fn decompress;
 	const char *compress_name;
 	static __initdata char msg_buf[64];
@@ -445,10 +445,12 @@ static char * __init unpack_to_rootfs(char *buf, unsigned len)
 		}
 		this_header = 0;
 		decompress = decompress_method(buf, len, &compress_name);
-		if (decompress)
-			decompress(buf, len, NULL, flush_buffer, NULL,
+		if (decompress) {
+			res = decompress(buf, len, NULL, flush_buffer, NULL,
 				   &my_inptr, error);
-		else if (compress_name) {
+			if (res)
+				error("decompressor failed");
+		} else if (compress_name) {
 			if (!message) {
 				snprintf(msg_buf, sizeof msg_buf,
 					 "compression method %s not configured",
-- 
1.6.3.3

