Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbZLOXYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbZLOXYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759981AbZLOW61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:58:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:37581 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759979AbZLOW6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:58:22 -0500
Date: Tue, 15 Dec 2009 22:58:08 GMT
From: tip-bot for Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: linux-kernel@vger.kernel.org, phillip@lougher.demon.co.uk, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, phillip@lougher.demon.co.uk,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <4b26b1ef.0+ZWxT6886olqcSc%phillip@lougher.demon.co.uk>
References: <4b26b1ef.0+ZWxT6886olqcSc%phillip@lougher.demon.co.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] initramfs: add missing decompressor error check
Message-ID: <tip-54291362d2a5738e1b0495df2abcb9e6b0563a3f@git.kernel.org>
Git-Commit-ID: 54291362d2a5738e1b0495df2abcb9e6b0563a3f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  54291362d2a5738e1b0495df2abcb9e6b0563a3f
Gitweb:     http://git.kernel.org/tip/54291362d2a5738e1b0495df2abcb9e6b0563a3f
Author:     Phillip Lougher <phillip@lougher.demon.co.uk>
AuthorDate: Mon, 14 Dec 2009 21:45:19 +0000
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 15 Dec 2009 14:04:24 -0800

initramfs: add missing decompressor error check

The decompressors return error by calling a supplied error function, and/or
by returning an error return value.  The initramfs code, however, fails to
check the exit code returned by the decompressor, and only checks the error
status set by calling the error function.

This patch adds a return code check and calls the error function.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
LKML-Reference: <4b26b1ef.0+ZWxT6886olqcSc%phillip@lougher.demon.co.uk>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
