Return-Path: <linux-kernel-owner+w=401wt.eu-S1760274AbZBZFjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760274AbZBZFjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 00:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZBZFig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 00:38:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51414 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbZBZFie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 00:38:34 -0500
Message-Id: <20090226053832.039095057@goodmis.org>
References: <20090226053240.607719846@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 26 Feb 2009 00:32:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v2 2/5] uaccess: add copy_strtok_from_user
Content-Disposition: inline; filename=0002-uaccess-add-copy_strtok_from_user.patch
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
 include/linux/uaccess.h |    5 ++
 lib/uaccess.c           |  176 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 180 insertions(+), 1 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 6b58367..08769ad 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -106,4 +106,9 @@ extern long probe_kernel_read(void *dst, void *src, size_t size);
  */
 extern long probe_kernel_write(void *dst, void *src, size_t size);
 
+extern int copy_strtok_from_user(void *to, const void __user *from,
+				 unsigned int copy, unsigned int read,
+				 unsigned int *copied, int skip,
+				 const char *delim);
+
 #endif		/* __LINUX_UACCESS_H__ */
diff --git a/lib/uaccess.c b/lib/uaccess.c
index ac40796..0c12360 100644
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
@@ -53,3 +64,166 @@ long probe_kernel_write(void *dst, void *src, size_t size)
 	return ret ? -EFAULT : 0;
 }
 EXPORT_SYMBOL_GPL(probe_kernel_write);
+
+/**
+ * copy_strtok_from_user - copy a delimited token from user space
+ * @to:	     The location to copy to
+ * @from:    The location to copy from
+ * @copy:    The number of bytes to copy
+ * @read:    The number of bytes to read
+ * @copied:  The number of bytes actually copied to @to
+ * @skip:    If other than zero, will skip leading white space
+ * @delim:   NULL terminated string of character delimiters
+ *
+ * This reads from a user buffer, a delimited toke.
+ * If skip is set, then it will trim all leading delimiters.
+ * Then it will copy thet token (non delimiter characters) until
+ * @copy bytes have been copied, @read bytes have been read from
+ * the user buffer, or more delimiters have been encountered.
+ *
+ * Note, if skip is not set, and a dilmiter exists at the beginning
+ *  it will return immediately.
+ *
+ * Example of use:
+ *
+ *  in user space a write(fd, "foo  bar zot", 12) is done. We want to
+ *  read three words.
+ *
+ *  len = 12;  - length of user buffer
+ *  ret = copy_strtok_from_user(buf, ubuf, 100, len, @copied, 1, " ");
+ *    ret will equal 4 ("foo " read)
+ *    buf will contain "foo"
+ *    copied will equal 3 ("foo" copied)
+ *    Note, @skip could be 1 or zero and the same would have happened
+ *          since there was no leading space.
+ *
+ *  len -= ret;  - 4 bytes was read
+ *  read = ret;
+ *  ret = copy_strtok_from_user(buf, ubuf+read, 100, len, @copied, 1, " ");
+ *    ret will equal 5 (" bar " read, notice the double space between
+ *                       foo and bar in the original write.)
+ *    buf will contain "bar"
+ *    copied will equal 3 ("bar" copied)
+ *    Note, @skip is 1, if it was zero the results would be different.
+ *          (see below)
+ *
+ *  len -= ret; - 5 bytes read
+ *  read += ret;
+ *  ret = copy_strtok_from_user(buf, ubuf+read, 100, len, @copied, 1, " ");
+ *   ret = -EAGAIN (no space after "zot")
+ *   buf will contain "zot"
+ *   copied will equal 3 ("zot" copied)
+ *
+ * If the second copy_strtok_from_user above had 0 for @skip, where we
+ * did not want to skip leading space (" bar zot")
+ *   ret will equal 1 (" " read)
+ *   buf will not be modified
+ *   copied will equal 0 (nothing copied).
+ *
+ * Returns:
+ *  The number of bytes read from user space (@from). This may or may not
+ *  be the same as what was copied into @to.
+ *
+ *  -EAGAIN, if we copied a token successfully, but never hit an
+ *    ending delimiter. The number of bytes copied will be the same
+ *    as @read. Note, if skip is set, and all we hit were delimiters
+ *    then we will also returne -EAGAIN with @copied = 0.
+ *
+ *  @copied will contain the number of bytes copied into @to
+ *
+ *  -EFAULT, if we faulted during any part of the copy.
+ *     @copied will be undefined.
+ *
+ *  -EINVAL, if we fill up @from before hitting a single delimiter.
+ *    @copy must be bigger than the expected token to read.
+ */
+int copy_strtok_from_user(void *to, const void __user *from,
+			  unsigned int copy, unsigned int read,
+			  unsigned int *copied, int skip,
+			  const char *delim)
+{
+	unsigned int have_read = 0;
+	unsigned int have_copied = 0;
+	const char __user *user = from;
+	char *kern = to;
+	int ret, len;
+	char ch;
+
+	/* get the first character */
+	ret = get_user(ch, user++);
+	if (ret)
+		return ret;
+	have_read++;
+
+	len = strlen(delim);
+
+	/*
+	 * If skip is set, and the first character is a delimiter
+	 * then we will continue to read until we find a non delimiter.
+	 */
+	if (skip) {
+		while (have_read < read && memchr(delim, ch, len)) {
+			ret = get_user(ch, user++);
+			if (ret)
+				return ret;
+			have_read++;
+		}
+
+		/*
+		 * If ch is still a delimiter, then have_read == read.
+		 * We successfully copied zero bytes. But this is
+		 * still valid. Just let the caller try again.
+		 */
+		if (memchr(delim, ch, len)) {
+			ret = -EAGAIN;
+			goto out;
+		}
+	} else if (memchr(delim, ch, len)) {
+		/*
+		 * If skip was not set and the first character was
+		 * a delimiter, then we return immediately.
+		 */
+		ret = have_read;
+		goto out;
+	}
+
+
+	/* Now read the actual token */
+	while (have_read < read &&
+	       have_copied < copy && !memchr(delim, ch, len)) {
+
+		kern[have_copied++] = ch;
+
+		ret = get_user(ch, user++);
+		if (ret)
+			return ret;
+
+		have_read++;
+	}
+
+	/*
+	 * If we ended with a delimiter then we have successfully
+	 * read in a full token.
+	 *
+	 * If ch is not a delimiter, and we have filled up @from,
+	 * then this was an invalid token.
+	 *
+	 * If ch is not white space, and we still have room in @from
+	 * then we let the caller know we have split a token.
+	 *  (have_read == read)
+	 */
+	if (memchr(delim, ch, len))
+		ret = have_read;
+	else if (have_copied == copy)
+		ret = -EINVAL;
+	else {
+		WARN_ON(have_read != read);
+		ret = -EAGAIN;
+	}
+
+ out:
+	*copied = have_copied;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(copy_strtok_from_user);
-- 
1.5.6.5

-- 
