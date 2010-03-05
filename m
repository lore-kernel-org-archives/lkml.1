Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab0CEG47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 01:56:59 -0500
Received: from mail.perches.com ([173.55.12.10]:1411 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095Ab0CEG45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 01:56:57 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] vsprintf: Recursive vsnprintf: Add "%pV", struct va_format
Date: Thu,  4 Mar 2010 22:56:52 -0800
Message-Id: <a4e5d0b0d545049872b305083aa0ef6c5b087cf4.1267771398.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <cover.1267771398.git.joe@perches.com>
References: <cover.1267771398.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the ability to print a format and va_list from a structure pointer

Allows __dev_printk to be implemented as a single printk while
minimizing string space duplication.

%pV should not be used without some mechanism to verify the
format and argument use ala __attribute__(format (printf(...))).

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h |    5 +++++
 lib/vsprintf.c         |    9 +++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 7f07074..0eae8e9 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -169,6 +169,11 @@ static inline void might_fault(void)
 }
 #endif
 
+struct va_format {
+	const char *fmt;
+	va_list *va;
+};
+
 extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(long time);
 NORET_TYPE void panic(const char * fmt, ...)
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index af4aaa6..0fd7f8b 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -950,6 +950,11 @@ static char *uuid_string(char *buf, char *end, const u8 *addr,
  *             [0][1][2][3]-[4][5]-[6][7]-[8][9]-[10][11][12][13][14][15]
  *           little endian output byte order is:
  *             [3][2][1][0]-[5][4]-[7][6]-[8][9]-[10][11][12][13][14][15]
+ * - 'V' For a struct va_format which contains a format string * and va_list *,
+ *       call vsnprintf(->format, *->va_list).
+ *       Implements a "recursive vsnprintf".
+ *       Do not use this feature without some mechanism to verify the
+ *       correctness of the format string and va_list arguments.
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
@@ -994,6 +999,10 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		break;
 	case 'U':
 		return uuid_string(buf, end, ptr, spec, fmt);
+	case 'V':
+		return buf + vsnprintf(buf, end - buf,
+				       ((struct va_format *)ptr)->fmt,
+				       *(((struct va_format *)ptr)->va));
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
-- 
1.7.0.14.g7e948

