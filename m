Return-Path: <linux-kernel-owner+w=401wt.eu-S1757533AbZKNAJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbZKNAJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 19:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757252AbZKNAJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 19:09:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:43102 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756918AbZKNAJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 19:09:48 -0500
Date: Sat, 14 Nov 2009 00:09:40 GMT
From: tip-bot for Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1258142222-16092-1-git-send-email-mjg@redhat.com>
References: <1258142222-16092-1-git-send-email-mjg@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/setup] x86, setup: Store the boot cursor state
Message-ID: <tip-d9b263528e01bfbaf716b51f38606b3dfe5ac1e9@git.kernel.org>
Git-Commit-ID: d9b263528e01bfbaf716b51f38606b3dfe5ac1e9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d9b263528e01bfbaf716b51f38606b3dfe5ac1e9
Gitweb:     http://git.kernel.org/tip/d9b263528e01bfbaf716b51f38606b3dfe5ac1e9
Author:     Matthew Garrett <mjg@redhat.com>
AuthorDate: Fri, 13 Nov 2009 14:57:00 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 13 Nov 2009 14:23:11 -0800

x86, setup: Store the boot cursor state

Add a field to store the boot cursor state and implement this for VGA on
x86. This can then be used to set the default policy for the boot console.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
LKML-Reference: <1258142222-16092-1-git-send-email-mjg@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
 
