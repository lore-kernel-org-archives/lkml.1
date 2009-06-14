Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbZFNGA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbZFNGA6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 02:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZFNGAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 02:00:16 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:55588 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbZFNGAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 02:00:14 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/4] asm-generic: uaccess: fix access_ok() prototype
Date: Sun, 14 Jun 2009 02:00:04 -0400
Message-Id: <1244959204-11269-4-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244959204-11269-1-git-send-email-vapier@gentoo.org>
References: <1244959204-11269-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The access_ok() function operates on a pointer, not unsigned long.
Otherwise builds result in a crazy amount of warnings such as:

 CC [M]  fs/smbfs/request.o
In file included from
/usr/local/src/linux/linux-2.6/arch/blackfin/include/asm/uaccess.h:17,
                from include/net/checksum.h:26,
                from include/linux/skbuff.h:28,
                from include/linux/ip.h:109,
                from include/net/ip.h:27,
                from fs/smbfs/smbiod.c:23:
include/asm-generic/uaccess.h: In function ‘copy_from_user’:
include/asm-generic/uaccess.h:247: warning: passing argument 1 of
	‘_access_ok’ makes integer from pointer without a cast
include/asm-generic/uaccess.h: In function ‘copy_to_user’:
include/asm-generic/uaccess.h:257: warning: passing argument 1 of
	‘_access_ok’ makes integer from pointer without a cast
include/asm-generic/uaccess.h: In function ‘strncpy_from_user’:
include/asm-generic/uaccess.h:281: warning: passing argument 1 of
	‘_access_ok’ makes integer from pointer without a cast
include/asm-generic/uaccess.h: In function ‘clear_user’:
include/asm-generic/uaccess.h:319: warning: passing argument 1 of
	‘_access_ok’ makes integer from pointer without a cast

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/asm-generic/uaccess.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
index d3a9519..4b32dab 100644
--- a/include/asm-generic/uaccess.h
+++ b/include/asm-generic/uaccess.h
@@ -37,14 +37,14 @@ static inline void set_fs(mm_segment_t fs)
 #define VERIFY_READ	0
 #define VERIFY_WRITE	1
 
-#define access_ok(type, addr, size) __access_ok((unsigned long)(addr),(size))
+#define access_ok(type, addr, size) __access_ok((addr), (size))
 
 /*
  * The architecture should really override this if possible, at least
  * doing a check on the get_fs()
  */
 #ifndef __access_ok
-static inline int __access_ok(unsigned long addr, unsigned long size)
+static inline int __access_ok(void __user *ptr, unsigned long size)
 {
 	return 1;
 }
-- 
1.6.3.1

