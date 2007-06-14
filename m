Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbXFNJ43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbXFNJ43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 05:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbXFNJ4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 05:56:04 -0400
Received: from ms1.nttdata.co.jp ([163.135.193.232]:40475 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbXFNJz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 05:55:59 -0400
Message-ID: <4670F01D.3010205@nttdata.co.jp>
Date: Thu, 14 Jun 2007 16:37:01 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [TOMOYO 6/9] Utility functions and /proc interface for policy manipulation.
References: <5fb14edc0706140030x4a906178ofd35df06dfa5c192@mail.gmail.com>
In-Reply-To: <5fb14edc0706140030x4a906178ofd35df06dfa5c192@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jun 2007 07:37:01.0866 (UTC) FILETIME=[CC23B0A0:01C7AE56]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This file contains utility functions for TOMOYO.

Any string data in TOMOYO Linux consists with ASCII printable characters (0x21 to 0x7E)
so that userland application can separate monotonically using whitespaces and carrige returns.
Any wildcard character consists with "\" + one ASCII printable character,
so that wildcard characters can be expanded without changing existing names.

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

---------------
 security/tomoyo/common.c | 1576 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 1576 insertions(+)

diff -ubBpErN linux-2.6.21.5/security/tomoyo/common.c linux-2.6.21.5-tomoyo/security/tomoyo/common.c
--- linux-2.6.21.5/security/tomoyo/common.c	1970-01-01 09:00:00.000000000 +0900
+++ linux-2.6.21.5-tomoyo/security/tomoyo/common.c	2007-06-05 00:00:00.000000000 +0900
@@ -0,0 +1,1576 @@
+/*
+ * security/tomoyo/common.c
+ *
+ * Common functions for TOMOYO Linux.
+ *
+ * Copyright (C) 2005-2007  NTT DATA CORPORATION
+ *
+ * Version: 2.0   2007/06/05
+ */
+
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/utime.h>
+#include <linux/file.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <asm/uaccess.h>
+#include <stdarg.h>
+#include <linux/namei.h>
+#include <linux/mount.h>
+#include <linux/proc_fs.h>
+#include "realpath.h"
+#include "tomoyo.h"
+
+#if defined (CONFIG_TOMOYO_MAX_ACCEPT_ENTRY)
+#define MAX_ACCEPT_ENTRY (CONFIG_TOMOYO_MAX_ACCEPT_ENTRY)
+#else
+#define MAX_ACCEPT_ENTRY 2048
+#endif
+
+static int tomoyo_read_control(struct file *file, char __user *buffer, const int buffer_len);
+
+/*************************  VARIABLES  *************************/
+
+/* /sbin/init started? */
+int sbin_init_started = 0;
+
+const char *ccs_log_level = KERN_DEBUG;
+
+static struct {
+	const char *keyword;
+	unsigned int current_value;
+	const unsigned int max_value;
+} ccs_control_array[TOMOYO_MAX_CONTROL_INDEX] = {
+	[TOMOYO_PROFILE_COMMENT]     = { "COMMENT",             0, 0 }, /* Reserved for string. */
+	[TOMOYO_MAC_FOR_FILE]        = { "MAC_FOR_FILE",        0, 3 },
+	[TOMOYO_MAX_ACCEPT_ENTRY]    = { "MAX_ACCEPT_ENTRY",    MAX_ACCEPT_ENTRY, INT_MAX },
+	[TOMOYO_VERBOSE]             = { "TOMOYO_VERBOSE",      1, 1 },
+	[TOMOYO_ALLOW_ENFORCE_GRACE] = { "ALLOW_ENFORCE_GRACE", 0, 1 },
+};
+
+struct profile {
+	unsigned int value[TOMOYO_MAX_CONTROL_INDEX];
+	const struct path_info *comment;
+};
+
+static struct profile *profile_ptr[TOMOYO_MAX_PROFILES];
+
+/*************************  UTILITY FUNCTIONS  *************************/
+
+static int  tomoyo_quiet_setup(char *str)
+{
+	ccs_control_array[TOMOYO_VERBOSE].current_value = 0;
+	return 0;
+}
+
+__setup("TOMOYO_QUIET", tomoyo_quiet_setup);
+
+/* Am I root? */
+static int tomoyo_is_root(void)
+{
+	return !current->uid && !current->euid;
+}
+
+/*
+ * Format string.
+ * Leading and trailing whitespaces are removed.
+ * Multiple whitespaces are packed into single space.
+ */
+static void tomoyo_normalize_line(unsigned char *buffer)
+{
+	unsigned char *sp = buffer, *dp = buffer;
+	int first = 1;
+	while (*sp && (*sp <= ' ' || *sp >= 127)) sp++;
+	while (*sp) {
+		if (!first) *dp++ = ' ';
+		first = 0;
+		while (*sp > ' ' && *sp < 127) *dp++ = *sp++;
+		while (*sp && (*sp <= ' ' || *sp >= 127)) sp++;
+	}
+	*dp = '\0';
+}
+
+/*
+ *  Check whether the given filename follows the naming rules.
+ *  Returns nonzero if follows, zero otherwise.
+ */
+int tomoyo_is_correct_path(const char *filename,
+                           const int start_type,
+                           const int pattern_type,
+                           const int end_type,
+                           const char *function)
+{
+	int contains_pattern = 0;
+	char c, d, e;
+	const char *original_filename = filename;
+	if (!filename) goto out;
+	c = *filename;
+	if (start_type == 1) { /* Must start with '/' */
+		if (c != '/') goto out;
+	} else if (start_type == -1) { /* Must not start with '/' */
+		if (c == '/') goto out;
+	}
+	if (c) c = * (strchr(filename, '\0') - 1);
+	if (end_type == 1) { /* Must end with '/' */
+		if (c != '/') goto out;
+	} else if (end_type == -1) { /* Must not end with '/' */
+		if (c == '/') goto out;
+	}
+	while ((c = *filename++) != '\0') {
+		if (c == '\\') {
+			switch ((c = *filename++)) {
+			case '\\':  /* "\\" */
+				continue;
+			case '$':   /* "\$" */
+			case '+':   /* "\+" */
+			case '?':   /* "\?" */
+			case '*':   /* "\*" */
+			case '@':   /* "\@" */
+			case 'x':   /* "\x" */
+			case 'X':   /* "\X" */
+			case 'a':   /* "\a" */
+			case 'A':   /* "\A" */
+			case '-':   /* "\-" */
+				if (pattern_type == -1) break; /* Must not contain pattern */
+				contains_pattern = 1;
+				continue;
+			case '0':   /* "\ooo" */
+			case '1':
+			case '2':
+			case '3':
+				if ((d = *filename++) >= '0' &&
+				    d <= '7' &&
+				    (e = *filename++) >= '0' &&
+				    e <= '7') {
+					const unsigned char f =
+						(((unsigned char) (c - '0')) << 6) +
+						(((unsigned char) (d - '0')) << 3) +
+						(((unsigned char) (e - '0')));
+					if (f && (f <= ' ' || f >= 127))
+						continue; /* pattern is not \000 */
+				}
+			}
+			goto out;
+		} else if (c <= ' ' || c >= 127) {
+			goto out;
+		}
+	}
+	if (pattern_type == 1) { /* Must contain pattern */
+		if (!contains_pattern) goto out;
+	}
+	return 1;
+ out:
+	printk(KERN_DEBUG "%s: Invalid pathname '%s'\n", function, original_filename);
+	return 0;
+}
+
+/*
+ *  Check whether the given domainname follows the naming rules.
+ *  Returns nonzero if follows, zero otherwise.
+ */
+int tomoyo_is_correct_domain(const unsigned char *domainname, const char *function)
+{
+	unsigned char c, d, e;
+	const char *org_domainname = domainname;
+	if (!domainname || strncmp(domainname, TOMOYO_ROOT_NAME, TOMOYO_ROOT_NAME_LEN)) goto out;
+	domainname += TOMOYO_ROOT_NAME_LEN;
+	if (!*domainname) return 1;
+	do {
+		if (*domainname++ != ' ') goto out;
+		if (*domainname++ != '/') goto out;
+		while ((c = *domainname) != '\0' && c != ' ') {
+			domainname++;
+			if (c == '\\') {
+				switch ((c = *domainname++)) {
+				case '\\':  /* "\\" */
+					continue;
+				case '0':   /* "\ooo" */
+				case '1':
+				case '2':
+				case '3':
+					if ((d = *domainname++) >= '0' &&
+					    d <= '7' &&
+					    (e = *domainname++) >= '0' &&
+					    e <= '7') {
+						const unsigned char f =
+							(((unsigned char) (c - '0')) << 6) +
+							(((unsigned char) (d - '0')) << 3) +
+							(((unsigned char) (e - '0')));
+						if (f && (f <= ' ' || f >= 127))
+							continue; /* pattern is not \000 */
+					}
+				}
+				goto out;
+			} else if (c < ' ' || c >= 127) {
+				goto out;
+			}
+		}
+	} while (*domainname);
+	return 1;
+ out:
+	printk(KERN_DEBUG "%s: Invalid domainname '%s'\n", function, org_domainname);
+	return 0;
+}
+
+static int tomoyo_path_depth(const char *pathname)
+{
+	int i = 0;
+	if (pathname) {
+		char *ep = strchr(pathname, '\0');
+		if (pathname < ep--) {
+			if (*ep != '/') i++;
+			while (pathname <= ep) if (*ep-- == '/') i += 2;
+		}
+	}
+	return i;
+}
+
+static int tomoyo_const_part_length(const char *filename)
+{
+	int len = 0;
+	if (filename) {
+		char c;
+		while ((c = *filename++) != '\0') {
+			if (c != '\\') {
+				len++;
+				continue;
+			}
+			switch (c = *filename++) {
+			case '\\':  /* "\\" */
+				len += 2;
+				continue;
+			case '0':   /* "\ooo" */
+			case '1':
+			case '2':
+			case '3':
+				if ((c = *filename++) >= '0' &&
+				    c <= '7' &&
+				    (c = *filename++) >= '0' &&
+				    c <= '7') {
+					len += 4;
+					continue;
+				}
+			}
+			break;
+		}
+	}
+	return len;
+}
+
+void tomoyo_fill_path_info(struct path_info *ptr)
+{
+	const char *name = ptr->name;
+	const int len = strlen(name);
+	ptr->total_len = len;
+	ptr->const_len = tomoyo_const_part_length(name);
+	ptr->is_dir = len && (name[len - 1] == '/');
+	ptr->is_patterned = (ptr->const_len < len);
+	ptr->hash = full_name_hash(name, len);
+	ptr->depth = tomoyo_path_depth(name);
+}
+
+static int tomoyo_file_matches_to_pattern2(const char *filename,
+                                           const char *filename_end,
+                                           const char *pattern,
+                                           const char *pattern_end)
+{
+	while (filename < filename_end && pattern < pattern_end) {
+		if (*pattern != '\\') {
+			if (*filename++ != *pattern++) return 0;
+		} else {
+			char c = *filename;
+			pattern++;
+			switch (*pattern) {
+			case '?':
+				if (c == '/') {
+					return 0;
+				} else if (c == '\\') {
+					if ((c = filename[1]) == '\\') {
+						filename++; /* safe because filename is \\ */
+					} else if (c >= '0' &&
+					           c <= '3' &&
+					           (c = filename[2]) >= '0' &&
+					           c <= '7' &&
+					           (c = filename[3]) >= '0' &&
+					           c <= '7') {
+						filename += 3; /* safe because filename is \ooo */
+					} else {
+						return 0;
+					}
+				}
+				break;
+			case '\\':
+				if (c != '\\') return 0;
+				if (*++filename != '\\') return 0; /* safe because *filename != '\0' */
+				break;
+			case '+':
+				if (c < '0' || c > '9') return 0;
+				break;
+			case 'x':
+				if (!((c >= '0' && c <= '9') ||
+				    (c >= 'A' && c <= 'F') ||
+				    (c >= 'a' && c <= 'f')))
+					return 0;
+				break;
+			case 'a':
+				if (!((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z'))) return 0;
+				break;
+			case '0':
+			case '1':
+			case '2':
+			case '3':
+				if (c == '\\' &&
+				    (c = filename[1]) >= '0' &&
+				    c <= '3' &&
+				    c == *pattern &&
+				    (c = filename[2]) >= '0' &&
+				    c <= '7' &&
+				    c == pattern[1] &&
+				    (c = filename[3]) >= '0' &&
+				    c <= '7' &&
+				    c == pattern[2]) {
+					filename += 3; /* safe because filename is \ooo */
+					pattern += 2; /* safe because pattern is \ooo  */
+					break;
+				}
+				return 0; /* Not matched. */
+			case '*':
+			case '@':
+				{
+					int i;
+					for (i = 0; i <= filename_end - filename; i++) {
+						if (tomoyo_file_matches_to_pattern2(filename + i,
+						                                    filename_end,
+						                                    pattern + 1,
+						                                    pattern_end))
+							return 1;
+						if ((c = filename[i]) == '.' && *pattern == '@')
+							break;
+						if (c == '\\') {
+							if ((c = filename[i + 1]) == '\\') {
+								/* safe because filename is \\ */
+								i++;
+							} else if (c >= '0' &&
+							           c <= '3' &&
+							           (c = filename[i + 2]) >= '0' &&
+							           c <= '7' &&
+							           (c = filename[i + 3]) >= '0' &&
+							           c <= '7') {
+								/* safe because filename is \ooo */
+								i += 3;
+							} else {
+								break; /* Bad pattern. */
+							}
+						}
+					}
+					return 0; /* Not matched. */
+				}
+			default:
+				{
+					int i, j = 0;
+					if ((c = *pattern) == '$') {
+						while ((c = filename[j]) >= '0' && c <= '9') j++;
+					} else if (c == 'X') {
+						while (((c = filename[j]) >= '0' && c <= '9') ||
+						       (c >= 'A' && c <= 'F') ||
+						       (c >= 'a' && c <= 'f'))
+							j++;
+					} else if (c == 'A') {
+						while (((c = filename[j]) >= 'A' && c <= 'Z') ||
+						       (c >= 'a' && c <= 'z'))
+							j++;
+					}
+					for (i = 1; i <= j; i++) {
+						if (tomoyo_file_matches_to_pattern2(filename + i,
+						                                    filename_end,
+						                                    pattern + 1,
+						                                    pattern_end))
+							return 1;
+					}
+				}
+				return 0; /* Not matched or bad pattern. */
+			}
+			filename++; /* safe because *filename != '\0' */
+			pattern++; /* safe because *pattern != '\0' */
+		}
+	}
+	while (*pattern == '\\' && (*(pattern + 1) == '*' || *(pattern + 1) == '@')) pattern += 2;
+	return (filename == filename_end && pattern == pattern_end);
+}
+
+static int tomoyo_file_matches_to_pattern(const char *filename,
+                                          const char *filename_end,
+                                          const char *pattern,
+                                          const char *pattern_end)
+{
+	const char *pattern_start = pattern;
+	int first = 1;
+	int result;
+	while (pattern < pattern_end - 1) {
+		if (*pattern++ != '\\' || *pattern++ != '-') continue;
+		result = tomoyo_file_matches_to_pattern2(filename,
+		                                         filename_end,
+		                                         pattern_start,
+		                                         pattern - 2);
+		if (first) result = !result;
+		if (result) return 0;
+		first = 0;
+		pattern_start = pattern;
+	}
+	result = tomoyo_file_matches_to_pattern2(filename, filename_end, pattern_start, pattern_end);
+	return first ? result : !result;
+}
+
+/*
+ *  Check whether the given pathname matches to the given pattern.
+ *  Returns nonzero if matches, zero otherwise.
+ *
+ *  The following patterns are available.
+ *    \\     \ itself.
+ *    \ooo   Octal representation of a byte.
+ *    \*     More than or equals to 0 character other than '/'.
+ *    \@     More than or equals to 0 character other than '/' or '.'.
+ *    \?     1 byte character other than '/'.
+ *    \$     More than or equals to 1 decimal digit.
+ *    \+     1 decimal digit.
+ *    \X     More than or equals to 1 hexadecimal digit.
+ *    \x     1 hexadecimal digit.
+ *    \A     More than or equals to 1 alphabet character.
+ *    \a     1 alphabet character.
+ *    \-     Subtraction operator.
+ */
+
+int tomoyo_path_matches_to_pattern(const struct path_info *pathname0,
+                                   const struct path_info *pattern0)
+{
+	const char *pathname = pathname0->name, *pattern = pattern0->name;
+	const int len = pattern0->const_len;
+	if (!pattern0->is_patterned) return !tomoyo_pathcmp(pathname0, pattern0);
+	if (pathname0->depth != pattern0->depth) return 0;
+	if (strncmp(pathname, pattern, len)) return 0;
+	pathname += len;
+	pattern += len;
+	while (*pathname && *pattern) {
+		const char *pathname_delimiter =
+			strchr(pathname, '/'), *pattern_delimiter = strchr(pattern, '/');
+		if (!pathname_delimiter) pathname_delimiter = strchr(pathname, '\0');
+		if (!pattern_delimiter) pattern_delimiter = strchr(pattern, '\0');
+		if (!tomoyo_file_matches_to_pattern(pathname,
+		                                    pathname_delimiter,
+		                                    pattern,
+		                                    pattern_delimiter))
+			return 0;
+		pathname = *pathname_delimiter ? pathname_delimiter + 1 : pathname_delimiter;
+		pattern = *pattern_delimiter ? pattern_delimiter + 1 : pattern_delimiter;
+	}
+	while (*pattern == '\\' && (*(pattern + 1) == '*' || *(pattern + 1) == '@')) pattern += 2;
+	return (!*pathname && !*pattern);
+}
+
+/*
+ *  Transactional printf() to struct io_buffer structure.
+ *  snprintf() will truncate, but tomoyo_io_printf() won't.
+ *  Returns zero on success, nonzero otherwise.
+ */
+int tomoyo_io_printf(struct io_buffer *head, const char *fmt, ...)
+{
+	va_list args;
+	int len, pos = head->read_avail, size = head->readbuf_size - pos;
+	if (size <= 0) return -ENOMEM;
+	va_start(args, fmt);
+	len = vsnprintf(head->read_buf + pos, size, fmt, args);
+	va_end(args);
+	if (pos + len >= head->readbuf_size) return -ENOMEM;
+	head->read_avail += len;
+	return 0;
+}
+
+/*
+ * Get tomoyo_realpath() of current process.
+ * This function uses tomoyo_alloc(), so caller must tomoyo_free() if this function didn't return NULL.
+ */
+const char *tomoyo_get_exe(void)
+{
+	if (current->mm) {
+		struct vm_area_struct *vma = current->mm->mmap;
+		while (vma) {
+			if ((vma->vm_flags & VM_EXECUTABLE) && vma->vm_file) {
+				return tomoyo_realpath_from_dentry(vma->vm_file->f_dentry,
+				                                   vma->vm_file->f_vfsmnt);
+			}
+			vma = vma->vm_next;
+		}
+	}
+	return NULL;
+}
+
+const char *tomoyo_get_msg(const int is_enforce)
+{
+	if (is_enforce)
+		return "ERROR";
+	else
+		return "WARNING";
+}
+
+/*************************  DOMAIN POLICY HANDLER  *************************/
+
+/* Check whether the given access control is enabled. */
+unsigned int tomoyo_check_flags(const unsigned int index)
+{
+	const u8 profile = ((struct tomoyo_security *) current->security)->domain_info->profile;
+	return sbin_init_started && index < TOMOYO_MAX_CONTROL_INDEX
+#if TOMOYO_MAX_PROFILES != 256
+		&& profile < TOMOYO_MAX_PROFILES
+#endif
+		&& profile_ptr[profile] ? profile_ptr[profile]->value[index] : 0;
+}
+
+unsigned int tomoyo_verbose_mode(void)
+{
+	return tomoyo_check_flags(TOMOYO_VERBOSE);
+}
+
+/* Check whether the given access control is enforce mode. */
+unsigned int tomoyo_check_enforce(const unsigned int index)
+{
+	return tomoyo_check_flags(index) == 3;
+}
+
+/* Check whether the given access control is accept mode. */
+unsigned int tomoyo_check_accept(const unsigned int index)
+{
+	return tomoyo_check_flags(index) == 1;
+}
+
+static struct profile *tomoyo_find_or_assign_new_profile(const unsigned int profile)
+{
+	static DECLARE_MUTEX(profile_lock);
+	struct profile *ptr = NULL;
+	down(&profile_lock);
+	if (profile < TOMOYO_MAX_PROFILES && (ptr = profile_ptr[profile]) == NULL) {
+		if ((ptr = tomoyo_alloc_element(sizeof(*ptr))) != NULL) {
+			int i;
+			for (i = 0; i < TOMOYO_MAX_CONTROL_INDEX; i++)
+				ptr->value[i] = ccs_control_array[i].current_value;
+			mb(); /* Instead of using spinlock. */
+			profile_ptr[profile] = ptr;
+		}
+	}
+	up(&profile_lock);
+	return ptr;
+}
+
+static int profile_loaded = 0;
+
+static int tomoyo_set_status(struct io_buffer *head)
+{
+	char *data = head->write_buf;
+	unsigned int i, value;
+	char *cp;
+	struct profile *profile;
+	if (!tomoyo_is_root()) return -EPERM;
+	i = simple_strtoul(data, &cp, 10);
+	if (data != cp) {
+		if (*cp != '-') return -EINVAL;
+		data= cp + 1;
+	}
+	profile = tomoyo_find_or_assign_new_profile(i);
+	if (!profile) return -EINVAL;
+	cp = strchr(data, '=');
+	if (!cp) return -EINVAL;
+	*cp = '\0';
+	profile_loaded = 1;
+	tomoyo_update_counter(TOMOYO_UPDATES_COUNTER_STATUS);
+	if (strcmp(data, ccs_control_array[TOMOYO_PROFILE_COMMENT].keyword) == 0) {
+		profile->comment = tomoyo_save_name(cp + 1);
+		return 0;
+	}
+	if (sscanf(cp + 1, "%u", &value) != 1) return -EINVAL;
+	for (i = 0; i < TOMOYO_MAX_CONTROL_INDEX; i++) {
+		if (strcmp(data, ccs_control_array[i].keyword)) continue;
+		if (value > ccs_control_array[i].max_value) value = ccs_control_array[i].max_value;
+		profile->value[i] = value;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static int tomoyo_read_status(struct io_buffer *head)
+{
+	if (!head->read_eof) {
+		if (!tomoyo_is_root()) return -EPERM;
+		if (!head->read_var2) {
+			int step;
+			for (step = head->read_step;
+			     step < TOMOYO_MAX_PROFILES * TOMOYO_MAX_CONTROL_INDEX;
+			     step++) {
+				const int i = step / TOMOYO_MAX_CONTROL_INDEX,
+					  j = step % TOMOYO_MAX_CONTROL_INDEX;
+				const struct profile *profile = profile_ptr[i];
+				head->read_step = step;
+				if (!profile) continue;
+				if (j == TOMOYO_PROFILE_COMMENT) {
+					if (tomoyo_io_printf(head,
+					                     "%u-%s=%s\n",
+					                     i,
+					                     ccs_control_array[TOMOYO_PROFILE_COMMENT].keyword,
+					                     profile->comment ? profile->comment->name : ""))
+						break;
+				} else {
+					if (tomoyo_io_printf(head,
+					                     "%u-%s=%u\n",
+					                     i,
+					                     ccs_control_array[j].keyword,
+					                     profile->value[j]))
+						break;
+				}
+			}
+			if (step == TOMOYO_MAX_PROFILES * TOMOYO_MAX_CONTROL_INDEX) {
+				head->read_var2 = "";
+				head->read_step = 0;
+			}
+		}
+		if (head->read_var2) {
+			head->read_eof = 1;
+		}
+	}
+	return 0;
+}
+
+/*************************  POLICY MANAGER HANDLER  *************************/
+
+struct policy_manager_entry {
+	struct policy_manager_entry *next;
+	const struct path_info *manager;
+	u8 is_domain;
+	u8 is_deleted;
+};
+
+static struct policy_manager_entry *policy_manager_list = NULL;
+
+static int tomoyo_add_manager_entry(const char *manager, u8 is_delete)
+{
+	struct policy_manager_entry *new_entry, *ptr;
+	static DECLARE_MUTEX(lock);
+	const struct path_info *saved_manager;
+	int error = -ENOMEM;
+	u8 is_domain = 0;
+	if (!tomoyo_is_root()) return -EPERM;
+	if (tomoyo_is_domain_def(manager)) {
+		if (!tomoyo_is_correct_domain(manager, __FUNCTION__)) return -EINVAL;
+		is_domain = 1;
+	} else {
+		if (!tomoyo_is_correct_path(manager, 1, -1, -1, __FUNCTION__)) return -EINVAL;
+	}
+	if ((saved_manager = tomoyo_save_name(manager)) == NULL) return -ENOMEM;
+	down(&lock);
+	for (ptr = policy_manager_list; ptr; ptr = ptr->next) {
+		if (ptr->manager == saved_manager) {
+			ptr->is_deleted = is_delete;
+			error = 0;
+			goto out;
+		}
+	}
+	if (is_delete) {
+		error = -ENOENT;
+		goto out;
+	}
+	if ((new_entry = tomoyo_alloc_element(sizeof(*new_entry))) == NULL) goto out;
+	new_entry->manager = saved_manager;
+	new_entry->is_domain = is_domain;
+	mb(); /* Instead of using spinlock. */
+	if ((ptr = policy_manager_list) != NULL) {
+		while (ptr->next)
+			ptr = ptr->next;
+		ptr->next = new_entry;
+	} else {
+		policy_manager_list = new_entry;
+	}
+	error = 0;
+ out:
+	up(&lock);
+	if (!error) tomoyo_update_counter(TOMOYO_UPDATES_COUNTER_MANAGER);
+	return error;
+}
+
+static int tomoyo_add_manager_policy(struct io_buffer *head)
+{
+	const char *data = head->write_buf;
+	int is_delete = 0;
+	if (!tomoyo_is_root()) return -EPERM;
+	if (strncmp(data, TOMOYO_KEYWORD_DELETE, TOMOYO_KEYWORD_DELETE_LEN) == 0) {
+		data += TOMOYO_KEYWORD_DELETE_LEN;
+		is_delete = 1;
+	}
+	return tomoyo_add_manager_entry(data, is_delete);
+}
+
+static int tomoyo_read_manager_policy(struct io_buffer *head)
+{
+	if (!head->read_eof) {
+		struct policy_manager_entry *ptr = head->read_var2;
+		if (!tomoyo_is_root()) return -EPERM;
+		if (!ptr) ptr = policy_manager_list;
+		while (ptr) {
+			head->read_var2 = ptr;
+			if (!ptr->is_deleted && tomoyo_io_printf(head, "%s\n", ptr->manager->name))
+				break;
+			ptr = ptr->next;
+		}
+		if (!ptr) head->read_eof = 1;
+	}
+	return 0;
+}
+
+/* Check whether the current process is a policy manager. */
+static int tomoyo_is_policy_manager(void)
+{
+	struct policy_manager_entry *ptr;
+	const char *exe;
+	const struct path_info *domainname =
+		((struct tomoyo_security *) current->security)->domain_info->domainname;
+	if (!sbin_init_started) return 1;
+	for (ptr = policy_manager_list; ptr; ptr = ptr->next) {
+		if (!ptr->is_deleted && ptr->is_domain && !tomoyo_pathcmp(domainname, ptr->manager))
+			return 1;
+	}
+	if ((exe = tomoyo_get_exe()) == NULL) return 0;
+	for (ptr = policy_manager_list; ptr; ptr = ptr->next) {
+		if (!ptr->is_deleted && !ptr->is_domain && !strcmp(exe, ptr->manager->name))
+			break;
+	}
+	if (!ptr) { /* Reduce error messages. */
+		static pid_t last_pid = 0;
+		const pid_t pid = current->pid;
+		if (last_pid != pid) {
+			printk("%s is not permitted to update policies.\n", exe);
+			last_pid = pid;
+		}
+	}
+	tomoyo_free(exe);
+	return ptr ? 1 : 0;
+}
+
+/*************************  DOMAIN POLICY HANDLER  *************************/
+
+static int tomoyo_add_domain_policy(struct io_buffer *head)
+{
+	char *data = head->write_buf;
+	struct domain_info *domain = head->write_var1;
+	int is_delete = 0, is_select = 0, is_undelete = 0;
+	unsigned int profile;
+	if (!tomoyo_is_root()) return -EPERM;
+	if (strncmp(data, TOMOYO_KEYWORD_DELETE, TOMOYO_KEYWORD_DELETE_LEN) == 0) {
+		data += TOMOYO_KEYWORD_DELETE_LEN;
+		is_delete = 1;
+	} else if (strncmp(data, TOMOYO_KEYWORD_SELECT, TOMOYO_KEYWORD_SELECT_LEN) == 0) {
+		data += TOMOYO_KEYWORD_SELECT_LEN;
+		is_select = 1;
+	} else if (strncmp(data, TOMOYO_KEYWORD_UNDELETE, TOMOYO_KEYWORD_UNDELETE_LEN) == 0) {
+		data += TOMOYO_KEYWORD_UNDELETE_LEN;
+		is_undelete = 1;
+	}
+	tomoyo_update_counter(TOMOYO_UPDATES_COUNTER_DOMAIN_POLICY);
+	if (tomoyo_is_domain_def(data)) {
+		if (is_delete) {
+			tomoyo_delete_domain(data);
+			domain = NULL;
+		} else if (is_select) {
+			domain = tomoyo_find_domain(data);
+		} else if (is_undelete) {
+			domain = tomoyo_undelete_domain(data);
+		} else {
+			domain = tomoyo_find_or_assign_new_domain(data, 0);
+		}
+		head->write_var1 = domain;
+		return 0;
+	}
+	if (!domain) return -EINVAL;
+	if (sscanf(data, TOMOYO_KEYWORD_USE_PROFILE "%u", &profile) == 1 &&
+	    profile < TOMOYO_MAX_PROFILES) {
+		if (profile_ptr[profile] || !sbin_init_started) domain->profile = (u8) profile;
+	} else {
+		return tomoyo_add_file_policy(data, domain, is_delete);
+	}
+	return -EINVAL;
+}
+
+static int tomoyo_read_domain_policy(struct io_buffer *head)
+{
+	if (!head->read_eof) {
+		struct domain_info *domain = head->read_var1;
+		switch (head->read_step) {
+		case 0: break;
+		case 1: goto step1;
+		case 2: goto step2;
+		case 3: goto step3;
+		default: return -EINVAL;
+		}
+		if (!tomoyo_is_root()) return -EPERM;
+		for (domain = &KERNEL_DOMAIN; domain; domain = domain->next) {
+			struct acl_info *ptr;
+			if (domain->is_deleted) continue;
+			head->read_var1 = domain;
+			head->read_var2 = NULL;
+			head->read_step = 1;
+		step1:
+			if (tomoyo_io_printf(head,
+			                     "%s\n" TOMOYO_KEYWORD_USE_PROFILE "%u\n%s\n",
+			                     domain->domainname->name,
+			                     domain->profile,
+			                     domain->quota_warned ? "quota_exceeded\n" : ""))
+				break;
+			head->read_var2 = domain->first_acl_ptr;
+			head->read_step = 2;
+		step2:
+			for (ptr = head->read_var2; ptr; ptr = ptr->next) {
+				const u8 acl_type = ptr->type;
+				const int pos = head->read_avail;
+				head->read_var2 = ptr;
+				if (ptr->is_deleted) continue;
+				if (acl_type == TOMOYO_TYPE_FILE_ACL) {
+					const unsigned char b = ptr->u.b[1];
+					if (tomoyo_io_printf(head,
+					                     "%d %s%s\n",
+					                     ptr->u.b[0],
+					                     b ? "@" : "",
+					                     b ? ((struct file_acl_record *) ptr)->u.group->group_name->name :
+					                         ((struct file_acl_record *) ptr)->u.filename->name)) {
+						head->read_avail = pos;
+						break;
+					}
+				} else {
+					const char *keyword = tomoyo_acltype2keyword(acl_type);
+					if (keyword) {
+						if (tomoyo_acltype2paths(acl_type) == 2) {
+							const u8 b0 = ptr->u.b[0], b1 = ptr->u.b[1];
+							if (tomoyo_io_printf(head,
+							                     "allow_%s %s%s %s%s\n",
+							                     keyword,
+							                     b0 ? "@" : "",
+							                     b0 ? ((struct double_acl_record *) ptr)->u1.group1->group_name->name :
+							                          ((struct double_acl_record *) ptr)->u1.filename1->name,
+							                     b1 ? "@" : "",
+							                     b1 ? ((struct double_acl_record *) ptr)->u2.group2->group_name->name :
+							                          ((struct double_acl_record *) ptr)->u2.filename2->name)) {
+								head->read_avail = pos;
+								break;
+							}
+						} else {
+							const u8 b = ptr->u.b[0];
+							if (tomoyo_io_printf(head,
+							                     "allow_%s %s%s\n",
+							                     keyword,
+							                     b ? "@" : "",
+							                     b ? ((struct single_acl_record *) ptr)->u.group->group_name->name :
+							                         ((struct single_acl_record *) ptr)->u.filename->name)) {
+								head->read_avail = pos;
+								break;
+							}
+						}
+					}
+				}
+			}
+			if (ptr) break;
+			head->read_var2 = NULL;
+			head->read_step = 3;
+		step3:
+			if (tomoyo_io_printf(head, "\n")) break;
+		}
+		if (!domain) head->read_eof = 1;
+	}
+	return 0;
+}
+
+static int tomoyo_read_domain_profile(struct io_buffer *head)
+{
+	if (!head->read_eof) {
+		struct domain_info *domain;
+		if (head->read_step == 0) {
+			head->read_var1 = &KERNEL_DOMAIN;
+			head->read_step = 1;
+		}
+		if (!tomoyo_is_root()) return -EPERM;
+		for (domain = head->read_var1; domain; domain = domain->next) {
+			if (domain->is_deleted) continue;
+			head->read_var1 = domain;
+			if (tomoyo_io_printf(head,
+			                     "%u %s\n",
+			                     domain->profile,
+			                     domain->domainname->name))
+				break;
+		}
+		if (!domain) head->read_eof = 1;
+	}
+	return 0;
+}
+
+static int tomoyo_write_pid(struct io_buffer *head)
+{
+	head->read_step = (int) simple_strtoul(head->write_buf, NULL, 10);
+	head->read_eof = 0;
+	return 0;
+}
+
+static int tomoyo_read_pid(struct io_buffer *head)
+{
+	if (head->read_avail == 0 && !head->read_eof) {
+		const int pid = head->read_step;
+		struct task_struct *p;
+		struct domain_info *domain = NULL;
+		/***** CRITICAL SECTION START *****/
+		read_lock(&tasklist_lock);
+		p = find_task_by_pid(pid);
+		if (p) {
+			struct tomoyo_security *tmp = p->security;
+			if (tmp) {
+				domain = tmp->domain_info;
+				if (!domain) domain = &KERNEL_DOMAIN;
+			}
+		}
+		read_unlock(&tasklist_lock);
+		/***** CRITICAL SECTION END *****/
+		if (domain) tomoyo_io_printf(head,
+		                             "%d %u %s",
+		                             pid,
+		                             domain->profile,
+		                             domain->domainname->name);
+		head->read_eof = 1;
+	}
+	return 0;
+}
+
+static int tomoyo_update_domain_profile(struct io_buffer *head)
+{
+	char *data = head->write_buf;
+	char *cp = strchr(data, ' ');
+	struct domain_info *domain;
+	unsigned int profile;
+	if (!tomoyo_is_root()) return -EPERM;
+	if (!cp) return -EINVAL;
+	*cp = '\0';
+	domain = tomoyo_find_domain(cp + 1);
+	profile = simple_strtoul(data, NULL, 10);
+	if (domain && profile < TOMOYO_MAX_PROFILES && (profile_ptr[profile] || !sbin_init_started))
+		domain->profile = (u8) profile;
+	tomoyo_update_counter(TOMOYO_UPDATES_COUNTER_DOMAIN_POLICY);
+	return 0;
+}
+
+/*************************  EXCEPTION POLICY HANDLER  *************************/
+
+static int tomoyo_add_exception_policy(struct io_buffer *head)
+{
+	char *data = head->write_buf;
+	int is_delete = 0;
+	if (!tomoyo_is_root()) return -EPERM;
+	tomoyo_update_counter(TOMOYO_UPDATES_COUNTER_EXCEPTION_POLICY);
+	if (strncmp(data, TOMOYO_KEYWORD_DELETE, TOMOYO_KEYWORD_DELETE_LEN) == 0) {
+		data += TOMOYO_KEYWORD_DELETE_LEN;
+		is_delete = 1;
+	}
+	if (strncmp(data, TOMOYO_KEYWORD_KEEP_DOMAIN, TOMOYO_KEYWORD_KEEP_DOMAIN_LEN) == 0) {
+		return tomoyo_add_domain_keeper_policy(data + TOMOYO_KEYWORD_KEEP_DOMAIN_LEN, 0, is_delete);
+	} else if (strncmp(data, TOMOYO_KEYWORD_NO_KEEP_DOMAIN, TOMOYO_KEYWORD_NO_KEEP_DOMAIN_LEN) == 0) {
+		return tomoyo_add_domain_keeper_policy(data + TOMOYO_KEYWORD_NO_KEEP_DOMAIN_LEN, 1, is_delete);
+	} else if (strncmp(data, TOMOYO_KEYWORD_INITIALIZE_DOMAIN, TOMOYO_KEYWORD_INITIALIZE_DOMAIN_LEN) == 0) {
+		return tomoyo_add_domain_initializer_policy(data + TOMOYO_KEYWORD_INITIALIZE_DOMAIN_LEN, 0, is_delete, 0);
+	} else if (strncmp(data, TOMOYO_KEYWORD_NO_INITIALIZE_DOMAIN, TOMOYO_KEYWORD_NO_INITIALIZE_DOMAIN_LEN) == 0) {
+		return tomoyo_add_domain_initializer_policy(data + TOMOYO_KEYWORD_NO_INITIALIZE_DOMAIN_LEN, 1, is_delete, 0);
+	} else if (strncmp(data, TOMOYO_KEYWORD_INITIALIZER, TOMOYO_KEYWORD_INITIALIZER_LEN) == 0) {
+		return tomoyo_add_domain_initializer_policy(data + TOMOYO_KEYWORD_INITIALIZER_LEN, 0, is_delete, 1);
+	} else if (strncmp(data, TOMOYO_KEYWORD_NO_INITIALIZER, TOMOYO_KEYWORD_NO_INITIALIZER_LEN) == 0) {
+		return tomoyo_add_domain_initializer_policy(data + TOMOYO_KEYWORD_NO_INITIALIZER_LEN, 1, is_delete, 1);
+	} else if (strncmp(data, TOMOYO_KEYWORD_ALIAS, TOMOYO_KEYWORD_ALIAS_LEN) == 0) {
+		return tomoyo_add_alias_policy(data + TOMOYO_KEYWORD_ALIAS_LEN, is_delete);
+	} else if (strncmp(data, TOMOYO_KEYWORD_AGGREGATOR, TOMOYO_KEYWORD_AGGREGATOR_LEN) == 0) {
+		return tomoyo_add_aggregator_policy(data + TOMOYO_KEYWORD_AGGREGATOR_LEN, is_delete);
+	} else if (strncmp(data, TOMOYO_KEYWORD_ALLOW_READ, TOMOYO_KEYWORD_ALLOW_READ_LEN) == 0) {
+		return tomoyo_add_globally_readable_policy(data + TOMOYO_KEYWORD_ALLOW_READ_LEN, is_delete);
+	} else if (strncmp(data, TOMOYO_KEYWORD_FILE_PATTERN, TOMOYO_KEYWORD_FILE_PATTERN_LEN) == 0) {
+		return tomoyo_add_pattern_policy(data + TOMOYO_KEYWORD_FILE_PATTERN_LEN, is_delete);
+	} else if (strncmp(data, TOMOYO_KEYWORD_PATH_GROUP, TOMOYO_KEYWORD_PATH_GROUP_LEN) == 0) {
+		return tomoyo_add_group_policy(data + TOMOYO_KEYWORD_PATH_GROUP_LEN, is_delete);
+	} else if (strncmp(data, TOMOYO_KEYWORD_DENY_REWRITE, TOMOYO_KEYWORD_DENY_REWRITE_LEN) == 0) {
+		return tomoyo_add_no_rewrite_policy(data + TOMOYO_KEYWORD_DENY_REWRITE_LEN, is_delete);
+	}
+	return -EINVAL;
+}
+
+static int tomoyo_read_exception_policy(struct io_buffer *head)
+{
+	if (!head->read_eof) {
+		switch (head->read_step) {
+		case 0:
+			if (!tomoyo_is_root()) return -EPERM;
+			head->read_var2 = NULL;
+			head->read_step = 1;
+		case 1:
+			if (tomoyo_read_domain_keeper_policy(head)) break;
+			head->read_var2 = NULL;
+			head->read_step = 2;
+		case 2:
+			if (tomoyo_read_globally_readable_policy(head)) break;
+			head->read_var2 = NULL;
+			head->read_step = 3;
+		case 3:
+			if (tomoyo_read_domain_initializer_policy(head)) break;
+			head->read_var2 = NULL;
+			head->read_step = 4;
+		case 4:
+			if (tomoyo_read_alias_policy(head)) break;
+			head->read_var2 = NULL;
+			head->read_step = 5;
+		case 5:
+			if (tomoyo_read_aggregator_policy(head)) break;
+			head->read_var2 = NULL;
+			head->read_step = 6;
+		case 6:
+			if (tomoyo_read_pattern_policy(head)) break;
+			head->read_var2 = NULL;
+			head->read_step = 7;
+		case 7:
+			if (tomoyo_read_no_rewrite_policy(head)) break;
+			head->read_var2 = NULL;
+			head->read_step = 8;
+		case 8:
+			if (tomoyo_read_group_policy(head)) break;
+			head->read_var2 = NULL;
+			head->read_step = 9;
+		case 9:
+			head->read_eof = 1;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+/*************************  POLICY LOADER  *************************/
+
+static const char *ccs_loader = NULL;
+
+static int  tomoyo_loader_setup(char *str)
+{
+	ccs_loader = str;
+	return 0;
+}
+
+__setup("TOMOYO_loader=", tomoyo_loader_setup);
+
+void tomoyo_load_policy(const char *filename)
+{
+	if (sbin_init_started) return;
+	/*
+	 * Check filename is /sbin/init or /sbin/ccs-start .
+	 * /sbin/ccs-start is a dummy filename in case where /sbin/init can't be passed.
+	 * You can create /sbin/ccs-start by "ln -s /bin/true /sbin/ccs-start", for
+	 * only the pathname is needed to activate Mandatory Access Control.
+	 */
+	if (strcmp(filename, "/sbin/init") != 0 && strcmp(filename, "/sbin/ccs-start") != 0) return;
+	/*
+	 * Don't activate MAC if the path given by 'TOMOYO_loader=' option doesn't exist.
+	 * If initrd.img includes /sbin/init but real-root-dev has not mounted on / yet,
+	 * activating MAC will block the system since policies are not loaded yet.
+	 * So let do_execve() call this function everytime.
+	 */
+	{
+		struct nameidata nd;
+		if (!ccs_loader) ccs_loader = "/.init";
+		if (path_lookup(ccs_loader, LOOKUP_FOLLOW, &nd)) {
+			printk("Not activating Mandatory Access Control now since %s doesn't exist.\n",
+			       ccs_loader);
+			return;
+		}
+		path_release(&nd);
+	}
+
+	printk("TOMOYO: 2.0   2007/06/05\n");
+	if (!profile_loaded) panic("No profiles loaded. Run policy loader using 'init=' option.\n");
+	printk("Mandatory Access Control activated.\n");
+	sbin_init_started = 1;
+	ccs_log_level = KERN_WARNING;
+	{ /* Check all profiles currently assigned to domains are defined. */
+		struct domain_info *domain;
+		for (domain = &KERNEL_DOMAIN; domain; domain = domain->next) {
+			const u8 profile = domain->profile;
+			if (!profile_ptr[profile])
+				panic("Profile %u (used by '%s') not defined.\n",
+				      profile,
+				      domain->domainname->name); 
+		}
+	}
+}
+
+
+/*************************  MAC Decision Delayer  *************************/
+
+static DECLARE_WAIT_QUEUE_HEAD(query_wait);
+
+static spinlock_t query_lock = SPIN_LOCK_UNLOCKED;
+
+struct query_entry {
+	struct list_head list;
+	char *query;
+	int query_len;
+	unsigned int serial;
+	int timer;
+	int answer;
+};
+
+static LIST_HEAD(query_list);
+static atomic_t queryd_watcher = ATOMIC_INIT(0);
+
+int tomoyo_check_supervisor(const char *fmt, ...)
+{
+	va_list args;
+	int error = -EPERM;
+	int pos, len;
+	static unsigned int serial = 0;
+	struct query_entry *query_entry;
+	if (!tomoyo_check_flags(TOMOYO_ALLOW_ENFORCE_GRACE)) return -EPERM;
+	if (!atomic_read(&queryd_watcher)) return -EPERM;
+	va_start(args, fmt);
+	len = vsnprintf((char *) &pos, sizeof(pos) - 1, fmt, args) + 32;
+	va_end(args);
+	if ((query_entry = tomoyo_alloc(sizeof(*query_entry))) == NULL ||
+		(query_entry->query = tomoyo_alloc(len)) == NULL) goto out;
+	INIT_LIST_HEAD(&query_entry->list);
+	/***** CRITICAL SECTION START *****/
+	spin_lock(&query_lock);
+	query_entry->serial = serial++;
+	spin_unlock(&query_lock);
+	/***** CRITICAL SECTION END *****/
+	pos = snprintf(query_entry->query, len - 1, "Q%u\n", query_entry->serial);
+	va_start(args, fmt);
+	vsnprintf(query_entry->query + pos, len - 1 - pos, fmt, args);
+	query_entry->query_len = strlen(query_entry->query) + 1;
+	va_end(args);
+	/***** CRITICAL SECTION START *****/
+	spin_lock(&query_lock);
+	list_add_tail(&query_entry->list, &query_list);
+	spin_unlock(&query_lock);
+	/***** CRITICAL SECTION END *****/
+	tomoyo_update_counter(TOMOYO_UPDATES_COUNTER_QUERY);
+	/* Give 10 seconds for supervisor's opinion. */
+	for (query_entry->timer = 0;
+	     atomic_read(&queryd_watcher) &&
+	     	tomoyo_check_flags(TOMOYO_ALLOW_ENFORCE_GRACE) &&
+	     	query_entry->timer < 100;
+	     query_entry->timer++) {
+		wake_up(&query_wait);
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(HZ / 10);
+		if (query_entry->answer) break;
+	}
+	tomoyo_update_counter(TOMOYO_UPDATES_COUNTER_QUERY);
+	/***** CRITICAL SECTION START *****/
+	spin_lock(&query_lock);
+	list_del(&query_entry->list);
+	spin_unlock(&query_lock);
+	/***** CRITICAL SECTION END *****/
+	switch (query_entry->answer) {
+	case 1:
+		/* Granted by administrator. */
+		error = 0;
+		break;
+	case 0:
+		/* Timed out. */
+		break;
+	default:
+		/* Rejected by administrator. */
+		break;
+	}
+ out: ;
+	if (query_entry) tomoyo_free(query_entry->query);
+	tomoyo_free(query_entry);
+	return error;
+}
+
+static int tomoyo_poll_query(struct file *file, poll_table *wait)
+{
+	int found;
+	/***** CRITICAL SECTION START *****/
+	spin_lock(&query_lock);
+	found = !list_empty(&query_list);
+	spin_unlock(&query_lock);
+	/***** CRITICAL SECTION END *****/
+	if (found) return POLLIN | POLLRDNORM;
+	poll_wait(file, &query_wait, wait);
+	/***** CRITICAL SECTION START *****/
+	spin_lock(&query_lock);
+	found = !list_empty(&query_list);
+	spin_unlock(&query_lock);
+	/***** CRITICAL SECTION END *****/
+	if (found) return POLLIN | POLLRDNORM;
+	return 0;
+}
+
+static int tomoyo_read_query(struct io_buffer *head)
+{
+	struct list_head *tmp;
+	int pos = 0, len = 0;
+	char *buf;
+	if (head->read_avail) return 0;
+	if (head->read_buf) {
+		tomoyo_free(head->read_buf);
+		head->read_buf = NULL;
+		head->readbuf_size = 0;
+	}
+	/***** CRITICAL SECTION START *****/
+	spin_lock(&query_lock);
+	list_for_each(tmp, &query_list) {
+		struct query_entry *ptr = list_entry(tmp, struct query_entry, list);
+		if (pos++ == head->read_step) {
+			len = ptr->query_len;
+			break;
+		}
+	}
+	spin_unlock(&query_lock);
+	/***** CRITICAL SECTION END *****/
+	if (!len) {
+		head->read_step = 0;
+		return 0;
+	}
+	if ((buf = tomoyo_alloc(len)) != NULL) {
+		pos = 0;
+		/***** CRITICAL SECTION START *****/
+		spin_lock(&query_lock);
+		list_for_each(tmp, &query_list) {
+			struct query_entry *ptr = list_entry(tmp, struct query_entry, list);
+			if (pos++ == head->read_step) {
+				/* Some query can be skiipped since query_list can change, */
+				/* but I don't care. */
+				if (len == ptr->query_len) memmove(buf, ptr->query, len);
+				break;
+			}
+		}
+		spin_unlock(&query_lock);
+		/***** CRITICAL SECTION END *****/
+		if (buf[0]) {
+			head->readbuf_size = head->read_avail = len;
+			head->read_buf = buf;
+			head->read_step++;
+		} else {
+			tomoyo_free(buf);
+		}
+	}
+	return 0;
+}
+
+static int tomoyo_write_answer(struct io_buffer *head)
+{
+	char *data = head->write_buf;
+	struct list_head *tmp;
+	unsigned int serial, answer;
+	/***** CRITICAL SECTION START *****/
+	spin_lock(&query_lock);
+	list_for_each(tmp, &query_list) {
+		struct query_entry *ptr = list_entry(tmp, struct query_entry, list);
+		ptr->timer = 0;
+	}
+	spin_unlock(&query_lock);
+	/***** CRITICAL SECTION END *****/
+	if (sscanf(data, "A%u=%u", &serial, &answer) != 2) return -EINVAL;
+	/***** CRITICAL SECTION START *****/
+	spin_lock(&query_lock);
+	list_for_each(tmp, &query_list) {
+		struct query_entry *ptr = list_entry(tmp, struct query_entry, list);
+		if (ptr->serial != serial) continue;
+		if (!ptr->answer) ptr->answer = answer;
+		break;
+	}
+	spin_unlock(&query_lock);
+	/***** CRITICAL SECTION END *****/
+	return 0;
+}
+
+/*************************  /proc INTERFACE HANDLER  *************************/
+
+/* Policy updates counter. */
+static unsigned int updates_counter[TOMOYO_MAX_UPDATES_COUNTER];
+static spinlock_t updates_counter_lock = SPIN_LOCK_UNLOCKED;
+
+void tomoyo_update_counter(const unsigned char index)
+{
+	/***** CRITICAL SECTION START *****/
+	spin_lock(&updates_counter_lock);
+	if (index < TOMOYO_MAX_UPDATES_COUNTER) updates_counter[index]++;
+	spin_unlock(&updates_counter_lock);
+	/***** CRITICAL SECTION END *****/
+}
+
+static int tomoyo_read_updates_counter(struct io_buffer *head)
+{
+	if (!head->read_eof) {
+		unsigned int counter[TOMOYO_MAX_UPDATES_COUNTER];
+		/***** CRITICAL SECTION START *****/
+		spin_lock(&updates_counter_lock);
+		memmove(counter, updates_counter, sizeof(updates_counter));
+		memset(updates_counter, 0, sizeof(updates_counter));
+		spin_unlock(&updates_counter_lock);
+		/***** CRITICAL SECTION END *****/
+		tomoyo_io_printf(head,
+				  "/proc/ccs/policy/domain_policy:    %10u\n"
+				  "/proc/ccs/policy/exception_policy: %10u\n"
+				  "/proc/ccs/status:                  %10u\n"
+				  "/proc/ccs/policy/query:            %10u\n"
+				  "/proc/ccs/policy/manager:          %10u\n",
+				  counter[TOMOYO_UPDATES_COUNTER_DOMAIN_POLICY],
+				  counter[TOMOYO_UPDATES_COUNTER_EXCEPTION_POLICY],
+				  counter[TOMOYO_UPDATES_COUNTER_STATUS],
+				  counter[TOMOYO_UPDATES_COUNTER_QUERY],
+				  counter[TOMOYO_UPDATES_COUNTER_MANAGER]);
+		head->read_eof = 1;
+	}
+	return 0;
+}
+
+static int tomoyo_read_memory_counter(struct io_buffer *head)
+{
+	if (!head->read_eof) {
+		const int shared = tomoyo_get_memory_used_for_save_name(),
+		          private = tomoyo_get_memory_used_for_elements(),
+		          dynamic = tomoyo_get_memory_used_for_dynamic();
+		if (tomoyo_io_printf(head,
+		                     "Shared:  %10u\n"
+		                     "Private: %10u\n"
+		                     "Dynamic: %10u\n"
+		                     "Total:   %10u\n",
+		                     shared,
+		                     private,
+		                     dynamic,
+		                     shared + private + dynamic) == 0)
+			head->read_eof = 1;
+	}
+	return 0;
+}
+
+static int tomoyo_open_control(const int type, struct file *file)
+{
+	struct io_buffer *head = tomoyo_alloc(sizeof(*head));
+	if (!head) return -ENOMEM;
+	init_MUTEX(&head->read_sem);
+	init_MUTEX(&head->write_sem);
+	switch (type) {
+	case TOMOYO_POLICY_DOMAINPOLICY:
+		head->write = tomoyo_add_domain_policy;
+		head->read = tomoyo_read_domain_policy;
+		break;
+	case TOMOYO_POLICY_EXCEPTIONPOLICY:
+		head->write = tomoyo_add_exception_policy;
+		head->read = tomoyo_read_exception_policy;
+		break;
+	case TOMOYO_POLICY_DOMAIN_STATUS:
+		head->write = tomoyo_update_domain_profile;
+		head->read = tomoyo_read_domain_profile;
+		break;
+	case TOMOYO_INFO_PROCESS_STATUS:
+		head->write = tomoyo_write_pid;
+		head->read = tomoyo_read_pid;
+		break;
+	case TOMOYO_INFO_SELFDOMAIN:
+		head->read = tomoyo_read_self_domain;
+		break;
+	case TOMOYO_INFO_MAPPING:
+		if (!sbin_init_started) head->write = tomoyo_set_permission_mapping;
+		head->read = tomoyo_read_permission_mapping;
+		break;
+	case TOMOYO_INFO_MEMINFO:
+		head->read = tomoyo_read_memory_counter;
+		head->readbuf_size = 128;
+		break;
+	case TOMOYO_STATUS:
+		head->write = tomoyo_set_status;
+		head->read = tomoyo_read_status;
+		break;
+	case TOMOYO_POLICY_QUERY:
+		head->poll = tomoyo_poll_query;
+		head->write = tomoyo_write_answer;
+		head->read = tomoyo_read_query;
+		break;
+	case TOMOYO_POLICY_MANAGER:
+		head->write = tomoyo_add_manager_policy;
+		head->read = tomoyo_read_manager_policy;
+		break;
+	case TOMOYO_INFO_UPDATESCOUNTER:
+		head->read = tomoyo_read_updates_counter;
+		break;
+	}
+	if (type != TOMOYO_POLICY_QUERY) {
+		if (!head->readbuf_size) head->readbuf_size = PAGE_SIZE * 2;
+		if ((head->read_buf = tomoyo_alloc(head->readbuf_size)) == NULL) {
+			tomoyo_free(head);
+			return -ENOMEM;
+		}
+	}
+	if (head->write) {
+		head->writebuf_size = PAGE_SIZE * 2;
+		if ((head->write_buf = tomoyo_alloc(head->writebuf_size)) == NULL) {
+			tomoyo_free(head->read_buf);
+			tomoyo_free(head);
+			return -ENOMEM;
+		}
+	}
+	file->private_data = head;
+	if (type == TOMOYO_INFO_SELFDOMAIN) tomoyo_read_control(file, NULL, 0);
+	else if (head->write == tomoyo_write_answer) atomic_inc(&queryd_watcher);
+	return 0;
+}
+
+static int tomoyo_copy_to_user(struct io_buffer *head, char __user * buffer, int buffer_len)
+{
+	int len = head->read_avail;
+	char *cp = head->read_buf;
+	if (len > buffer_len) len = buffer_len;
+	if (len) {
+		if (copy_to_user(buffer, cp, len)) return -EFAULT;
+		head->read_avail -= len;
+		memmove(cp, cp + len, head->read_avail);
+	}
+	return len;
+}
+
+static int tomoyo_poll_control(struct file *file, poll_table *wait)
+{
+	struct io_buffer *head = (struct io_buffer *) file->private_data;
+	if (!head->poll) return -ENOSYS;
+	return head->poll(file, wait);
+}
+
+static int tomoyo_read_control(struct file *file, char __user *buffer, const int buffer_len)
+{
+	int len = 0;
+	struct io_buffer *head = (struct io_buffer *) file->private_data;
+	if (!head->read) return -ENOSYS;
+	if (!access_ok(VERIFY_WRITE, buffer, buffer_len)) return -EFAULT;
+	if (down_interruptible(&head->read_sem)) return -EINTR;
+	len = head->read(head);
+	if (len >= 0) len = tomoyo_copy_to_user(head, buffer, buffer_len);
+	up(&head->read_sem);
+	return len;
+}
+
+static int tomoyo_write_control(struct file *file, const char __user *buffer, const int buffer_len)
+{
+	struct io_buffer *head = (struct io_buffer *) file->private_data;
+	int error = buffer_len;
+	int avail_len = buffer_len;
+	char *cp0 = head->write_buf;
+	if (!head->write) return -ENOSYS;
+	if (!access_ok(VERIFY_READ, buffer, buffer_len)) return -EFAULT;
+	if (!tomoyo_is_root()) return -EPERM;
+	if (head->write != tomoyo_write_pid && !tomoyo_is_policy_manager()) {
+		return -EPERM; /* Forbid updating policies for non manager programs. */
+	}
+	if (down_interruptible(&head->write_sem)) return -EINTR;
+	while (avail_len > 0) {
+		char c;
+		if (head->write_avail >= head->writebuf_size - 1) {
+			error = -ENOMEM;
+			break;
+		} else if (get_user(c, buffer)) {
+			error = -EFAULT;
+			break;
+		}
+		buffer++;
+		avail_len--;
+		cp0[head->write_avail++] = c;
+		if (c != '\n') continue;
+		cp0[head->write_avail - 1] = '\0';
+		head->write_avail = 0;
+		tomoyo_normalize_line(cp0);
+		head->write(head);
+	}
+	up(&head->write_sem);
+	return error;
+}
+
+
+static int tomoyo_close_control(struct file *file)
+{
+	struct io_buffer *head = file->private_data;
+	if (head->write == tomoyo_write_answer) atomic_dec(&queryd_watcher);
+	tomoyo_free(head->read_buf);
+	head->read_buf = NULL;
+	tomoyo_free(head->write_buf);
+	head->write_buf = NULL;
+	tomoyo_free(head);
+	head = NULL;
+	file->private_data = NULL;
+	return 0;
+}
+
+static int tomoyo_open(struct inode *inode, struct file *file)
+{
+	return tomoyo_open_control(((u8 *) PDE(inode)->data) - ((u8 *) NULL), file);
+}
+
+static int tomoyo_release(struct inode *inode, struct file *file)
+{
+	return tomoyo_close_control(file);
+}
+
+static unsigned int tomoyo_poll(struct file *file, poll_table *wait)
+{
+	return tomoyo_poll_control(file, wait);
+}
+
+static ssize_t tomoyo_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
+{
+	return tomoyo_read_control(file, buf, count);
+}
+
+static ssize_t tomoyo_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+{
+	return tomoyo_write_control(file, buf, count);
+}
+
+static struct file_operations ccs_operations = {
+	open:    tomoyo_open,
+	release: tomoyo_release,
+	poll:    tomoyo_poll,
+	read:    tomoyo_read,
+	write:   tomoyo_write
+};
+
+static void tomoyo_create_entry(const char *name,
+                                const mode_t mode,
+                                struct proc_dir_entry *parent,
+                                const int key)
+{
+	struct proc_dir_entry *entry = create_proc_entry(name, mode, parent);
+	if (entry) {
+		entry->proc_fops = &ccs_operations;
+		entry->data = ((u8 *) NULL) + key;
+	}
+}
+
+void tomoyo_proc_init(void)
+{
+	static int initialized = 0;
+	struct proc_dir_entry *ccs_dir;
+	struct proc_dir_entry *policy_dir, *info_dir;
+	extern void tomoyo_realpath_init(void);
+	if (initialized)
+		return;
+	initialized = 1;
+	ccs_dir = proc_mkdir("ccs", NULL);
+	policy_dir = proc_mkdir("policy", ccs_dir);
+	info_dir = proc_mkdir("info", ccs_dir);
+	tomoyo_realpath_init();
+	tomoyo_find_domain(""); /* Set domainname of KERNEL domain. */
+	tomoyo_create_entry("query",            0600, policy_dir, TOMOYO_POLICY_QUERY);
+	tomoyo_create_entry("domain_policy",    0600, policy_dir, TOMOYO_POLICY_DOMAINPOLICY);
+	tomoyo_create_entry("exception_policy", 0600, policy_dir, TOMOYO_POLICY_EXCEPTIONPOLICY);
+	tomoyo_create_entry(".domain_status",   0600, policy_dir, TOMOYO_POLICY_DOMAIN_STATUS);
+	tomoyo_create_entry(".process_status",  0400, info_dir, TOMOYO_INFO_PROCESS_STATUS);
+	tomoyo_create_entry("self_domain",      0400, info_dir, TOMOYO_INFO_SELFDOMAIN);
+	tomoyo_create_entry("mapping",          0400, info_dir, TOMOYO_INFO_MAPPING);
+	tomoyo_create_entry("meminfo",          0400, info_dir, TOMOYO_INFO_MEMINFO);
+	tomoyo_create_entry("status",           0600, ccs_dir, TOMOYO_STATUS);
+	tomoyo_create_entry("manager",          0600, policy_dir, TOMOYO_POLICY_MANAGER);
+	tomoyo_create_entry(".updates_counter", 0400, info_dir, TOMOYO_INFO_UPDATESCOUNTER);
+}
---------------

