Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbZBZTBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbZBZTBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 14:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbZBZS7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 13:59:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40636 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbZBZS7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 13:59:05 -0500
Message-Id: <20090226185901.320018313@goodmis.org>
References: <20090226185419.371469287@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 26 Feb 2009 13:54:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v3 3/6] uaccess: add copy_strtok_from_user
Content-Disposition: inline; filename=0003-uaccess-add-copy_strtok_from_user.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The ftrace utility reads delimited tokens from user space.
Andrew Morton did not like how ftrace open coded this. He had
a good point since more than one location performed this feature.

This patch creates a copy_strtok_from_user function that can copy
a delimited token from user space. This puts the code in  the
lib/uaccess.c file. This keeps the code in a single location
and may be optimized in the future.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/uaccess.h |    4 +
 lib/uaccess.c           |  152 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 155 insertions(+), 1 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 6b58367..0a3faf5 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -106,4 +106,8 @@ extern long probe_kernel_read(void *dst, void *src, size_t size);
  */
 extern long probe_kernel_write(void *dst, void *src, size_t size);
 
+extern int copy_strtok_from_user(void *to, const void __user *from,
+				 unsigned int copy, unsigned int read,
+				 unsigned int *copied, const char *delim);
+
 #endif		/* __LINUX_UACCESS_H__ */
diff --git a/lib/uaccess.c b/lib/uaccess.c
index ac40796..a55db23 100644
--- a/lib/uaccess.c
+++ b/lib/uaccess.c
@@ -1,8 +1,19 @@
 /*
- * Access kernel memory without faulting.
+ * lib/uaccess.c
+ *   Generic memory access without faulting.
+ *
+ *  Copyright (C) 2008 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
+ *
+ *  Added copy_strtok_from_user -
+ *     Copyright (C) 2009 Red Hat, Inc., Steven Rostedt <srostedt@redhat.com>
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+ *
  */
 #include <linux/uaccess.h>
 #include <linux/module.h>
+#include <linux/ctype.h>
 #include <linux/mm.h>
 
 /**
@@ -53,3 +64,142 @@ long probe_kernel_write(void *dst, void *src, size_t size)
 	return ret ? -EFAULT : 0;
 }
 EXPORT_SYMBOL_GPL(probe_kernel_write);
+
+#define USER_BUF_SIZE	127
+
+/**
+ * copy_strtok_from_user - copy a delimited token from user space
+ * @to:	     The location to copy to
+ * @from:    The location to copy from
+ * @copy:    The number of bytes to copy
+ * @read:    The number of bytes to read
+ * @copied:  The number of bytes actually written to @to
+ * @delim:   NULL terminated string of character delimiters
+ *
+ * This reads from a user buffer, a delimited token.
+ * It places the token into @to if one is found, up to the number of
+ * bytes specified by @copy. It adds a "\0" terminating character
+ * into @to if a delimiter is found after the token. Otherwise the
+ * @to does not end with a \0 delimiter.
+ * If only delimiters are found, @to is not modified and
+ * @copied will be zero.
+ *
+ * It reads at most @read bytes from the user @from buffer, and
+ * will copy at most @copy bytes into the kernel @to buffer.
+ *
+ * Example of use:
+ *
+ *  in user space a write(fd, "foo  bar zot", 12) is done. We want to
+ *  read three words.
+ *
+ *  len = 12;  - length of user buffer
+ *  ret = copy_strtok_from_user(buf, ubuf, 100, len, @copied, " ");
+ *    ret will equal 3 ("foo" read - " " is also read but not counted.)
+ *    buf will contain "foo\0"
+ *    copied will equal 4 ("foo\0" written)
+ *
+ *  len -= ret;  - 3 bytes was read
+ *  read = ret;
+ *  ret = copy_strtok_from_user(buf, ubuf+read, 100, len, @copied, " ");
+ *    ret will equal 5 ("  bar" read, notice the double space between
+ *                       foo and bar in the original write.)
+ *    buf will contain "bar\0"
+ *    copied will equal 4 ("bar\0" written)
+ *
+ *  len -= ret; - 5 bytes read
+ *  read += ret;
+ *  ret = copy_strtok_from_user(buf, ubuf+read, 100, len, @copied, " ");
+ *   ret = 4 (" zot" read)
+ *   buf will contain "zot" (notice that it does not contain \0)
+ *   copied will equal 3 ("zot" written)
+ *   The buf only has "zot" because no terminating delimiter was
+ *   encountered.
+ *
+ * Returns:
+ *  The number of bytes read from user space (@from). This may or may not
+ *  be the same as what was copied into @to.
+ *
+ *  if (@to[*@copied - 1] == '\0')
+ *        token ended with a delimiter
+ *  else
+ *        token in @from was not followed by a delimiter
+ *
+ *  @copied will contain the number of bytes written into @to.
+ *
+ *  Note, if the token that was found was bigger than @to,
+ *  @copied will equal copy, and @to[*@copied - 1] will not be '\0'
+ *
+ *  -EFAULT, if we faulted during any part of the copy.
+ *     @copied will be undefined.
+ */
+int copy_strtok_from_user(void *to, const void __user *from,
+			  unsigned int copy, unsigned int read,
+			  unsigned int *copied,  const char *delim)
+{
+	unsigned int have_read = 0;
+	unsigned int have_copied = 0;
+	char user[USER_BUF_SIZE + 1];
+	char *token, *ptr;
+	int ret, cnt;
+
+	do {
+		cnt = USER_BUF_SIZE;
+
+		if (cnt > read - have_read)
+			cnt = read - have_read;
+
+		ret = copy_from_user(user, from + have_read, cnt);
+		if (ret)
+			return ret;
+
+		user[cnt] = 0;
+		ptr = user;
+		have_read += cnt;
+
+		token = strtok_r(ptr, delim, &ptr);
+		if (token) {
+			strncpy(to + have_copied, token, copy - have_copied);
+			have_copied += strlen(token);
+
+			/*
+			 * We do not want to report that we read past the
+			 * token.
+			 */
+			have_read -= cnt - (ptr - user);
+
+			/*
+			 * Check if the token was larger than the supplied
+			 * buffer.
+			 */
+			if (have_copied >= copy) {
+				/* do not report the part not copied */
+				have_read -= have_copied - copy;
+				/* account for the delim read by ptr */
+				if (ptr[-1] == '\0')
+					have_read--;
+				have_copied = copy;
+				break;
+			}
+
+			/*
+			 * Now the tricky part. We must determine if the token
+			 * was split between two reads from userspace.
+			 * If strtok_r found a delimiter after the token, then
+			 * the previous character to ptr would be NULL.
+			 * Note: if strtok_r returned a token, ptr must be
+			 * greater than user.
+			 */
+			if (!ptr[-1]) {
+				/* add '\0' */
+				have_copied++;
+				break;
+			}
+		}
+
+	} while (have_read < read && have_copied < copy);
+
+	*copied = have_copied;
+
+	return have_read;
+}
+EXPORT_SYMBOL_GPL(copy_strtok_from_user);
-- 
1.5.6.5

-- 
