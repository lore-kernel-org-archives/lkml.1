Return-Path: <linux-kernel-owner+w=401wt.eu-S932328AbZKMT6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328AbZKMT6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932288AbZKMT5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:57:54 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:37303 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260AbZKMT5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:57:52 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, gregkh@suse.de, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/3] setup: Store the boot cursor state
Date: Fri, 13 Nov 2009 14:57:00 -0500
Message-Id: <1258142222-16092-1-git-send-email-mjg@redhat.com>
X-Mailer: git-send-email 1.6.5.2
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a field to store the boot cursor state and implement this for VGA on
x86. This can then be used to set the default policy for the boot console.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 arch/x86/boot/video.c       |    6 ++++++
 include/linux/screen_info.h |    5 ++++-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/video.c b/arch/x86/boot/video.c
index d42da38..f767164 100644
--- a/arch/x86/boot/video.c
+++ b/arch/x86/boot/video.c
@@ -27,6 +27,12 @@ static void store_cursor_position(void)
 
 	boot_params.screen_info.orig_x = oreg.dl;
 	boot_params.screen_info.orig_y = oreg.dh;
+
+	if (oreg.ch & 0x20)
+		boot_params.screen_info.flags |= VIDEO_FLAGS_NOCURSOR;
+
+	if ((oreg.ch & 0x1f) > (oreg.cl & 0x1f))
+		boot_params.screen_info.flags |= VIDEO_FLAGS_NOCURSOR;
 }
 
 static void store_video_mode(void)
diff --git a/include/linux/screen_info.h b/include/linux/screen_info.h
index 1ee2c05..899fbb4 100644
--- a/include/linux/screen_info.h
+++ b/include/linux/screen_info.h
@@ -14,7 +14,8 @@ struct screen_info {
 	__u16 orig_video_page;	/* 0x04 */
 	__u8  orig_video_mode;	/* 0x06 */
 	__u8  orig_video_cols;	/* 0x07 */
-	__u16 unused2;		/* 0x08 */
+	__u8  flags;		/* 0x08 */
+	__u8  unused2;		/* 0x09 */
 	__u16 orig_video_ega_bx;/* 0x0a */
 	__u16 unused3;		/* 0x0c */
 	__u8  orig_video_lines;	/* 0x0e */
@@ -65,6 +66,8 @@ struct screen_info {
 
 #define VIDEO_TYPE_EFI		0x70	/* EFI graphic mode		*/
 
+#define VIDEO_FLAGS_NOCURSOR	(1 << 0) /* The video mode has no cursor set */
+
 #ifdef __KERNEL__
 extern struct screen_info screen_info;
 
-- 
1.6.5.2

