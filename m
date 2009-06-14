Return-Path: <linux-kernel-owner+w=401wt.eu-S1752212AbZFNGAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbZFNGAh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 02:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbZFNGAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 02:00:13 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:55580 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbZFNGAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 02:00:12 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] asm-generic: uaccess: add missing access_ok() check to strnlen_user()
Date: Sun, 14 Jun 2009 02:00:02 -0400
Message-Id: <1244959204-11269-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244959204-11269-1-git-send-email-vapier@gentoo.org>
References: <1244959204-11269-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The strnlen_user() function was missing a access_ok() check on the pointer
given.  We've had cases on Blackfin systems where test programs caused
kernel crashes here because userspace passed up a NULL/-1 pointer and the
kernel gladly attempted to run strlen() on it.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/asm-generic/uaccess.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
index cf3cb73..d299557 100644
--- a/include/asm-generic/uaccess.h
+++ b/include/asm-generic/uaccess.h
@@ -296,6 +296,8 @@ strncpy_from_user(char *dst, const char __user *src, long count)
 #ifndef strnlen_user
 static inline long strnlen_user(const char __user *src, long n)
 {
+	if (!access_ok(VERIFY_READ, src, 1))
+		return 0;
 	return strlen((void * __force)src) + 1;
 }
 #endif
-- 
1.6.3.1

