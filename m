Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbXFNJW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbXFNJW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 05:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbXFNJWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 05:22:18 -0400
Received: from ms2.nttdata.co.jp ([163.135.193.237]:42243 "EHLO
	ms2.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbXFNJWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 05:22:16 -0400
Message-ID: <4670EF68.8090209@nttdata.co.jp>
Date: Thu, 14 Jun 2007 16:34:00 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [TOMOYO 3/9] Data structures and prototypes definition.
References: <5fb14edc0706140030x4a906178ofd35df06dfa5c192@mail.gmail.com>
In-Reply-To: <5fb14edc0706140030x4a906178ofd35df06dfa5c192@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jun 2007 07:34:00.0729 (UTC) FILETIME=[602C6090:01C7AE56]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is prototypes and structures definition.

Many of structures are single-linked list and memory allocated for them are never freed,
because entries used for access control needn't to be removed from the list so frequently
compared to general other entries in the kernel. This saves the amount of memory needed by TOMOYO.

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

---------------
 security/tomoyo/include/tomoyo.h |  319 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 319 insertions(+)

diff -ubBpErN linux-2.6.21.5/security/tomoyo/include/tomoyo.h linux-2.6.21.5-tomoyo/security/tomoyo/include/tomoyo.h
--- linux-2.6.21.5/security/tomoyo/include/tomoyo.h	1970-01-01 09:00:00.000000000 +0900
+++ linux-2.6.21.5-tomoyo/security/tomoyo/include/tomoyo.h	2007-06-05 00:00:00.000000000 +0900
@@ -0,0 +1,319 @@
+/*
+ * security/tomoyo/include/tomoyo.h
+ *
+ * Implementation of the Domain-Based Mandatory Access Control.
+ *
+ * Copyright (C) 2005-2007  NTT DATA CORPORATION
+ *
+ * Version: 2.0   2007/06/05
+ *
+ */
+#ifndef _TOMOYO_H
+#define _TOMOYO_H
+
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/utime.h>
+#include <linux/file.h>
+#include <linux/smp_lock.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/poll.h>
+#include <asm/uaccess.h>
+#include <stdarg.h>
+#include <linux/delay.h>
+
+/***** TOMOYO Linux start. *****/
+
+struct tomoyo_security {
+	struct domain_info *domain_info;
+	u32 flags;
+};
+
+struct path_info {
+	const char *name;
+	u32 hash;        /* = full_name_hash(name, strlen(name)) */
+	u16 total_len;   /* = strlen(name)                       */
+	u16 const_len;   /* = tomoyo_const_part_length(name)            */
+	u8 is_dir;       /* = tomoyo_strendswith(name, "/")             */
+	u8 is_patterned; /* = PathContainsPattern(name)          */
+	u16 depth;       /* = tomoyo_path_depth(name)                    */
+};
+
+#define TOMOYO_MAX_PATHNAME_LEN 4000
+
+struct group_member {
+	struct group_member *next;
+	const struct path_info *member_name;
+	int is_deleted;
+};
+
+struct group_entry {
+	struct group_entry *next;
+	const struct path_info *group_name;
+	struct group_member *first_member;
+};
+
+/*
+ *  TOMOYO uses the following structures.
+ *  Memory allocated for these structures are never kfree()ed.
+ *  Since no locks are used for reading, assignment must be performed atomically.
+ */
+
+/*************************  The structure for domains.  *************************/
+
+struct acl_info {
+	struct acl_info *next;
+	u8 type;
+	u8 is_deleted;
+	union {
+		u16 w;
+		u8 b[2];
+	} u;
+};
+
+struct domain_info {
+	struct domain_info *next;           /* Pointer to next record. NULL if none. */
+	struct acl_info *first_acl_ptr;     /* Pointer to first acl. NULL if none.   */
+	const struct path_info *domainname; /* Name of this domain. Never NULL.      */
+	u8 profile;                         /* Profile to use.                       */
+	u8 is_deleted;                      /* Delete flag.                          */
+	u8 quota_warned;                    /* Quota warnning done flag.             */
+};
+
+#define TOMOYO_MAX_PROFILES 256
+
+struct file_acl_record {
+	struct acl_info head; /* type = TOMOYO_TYPE_FILE_ACL, b[0] = perm, b[1] = u_is_group */
+	union {
+		const struct path_info *filename;   /* Pointer to single pathname. */
+		const struct group_entry *group;    /* Pointer to pathname group.  */
+	} u;
+};
+
+struct single_acl_record {
+	struct acl_info head;                 /* type = TOMOYO_TYPE_*, w = u_is_group */
+	union {
+		const struct path_info *filename; /* Pointer to single pathname. */
+		const struct group_entry *group;  /* Pointer to pathname group.  */
+	} u;
+};
+
+struct double_acl_record {
+	/* type = TOMOYO_TYPE_RENAME_ACL or TOMOYO_TYPE_LINK_ACL, */
+	/* b[0] = u1_is_group, b[1] = u2_is_group */
+	struct acl_info head;
+	union {
+		const struct path_info *filename1;  /* Pointer to single pathname. */
+		const struct group_entry *group1;   /* Pointer to pathname group.  */
+	} u1;
+	union {
+		const struct path_info *filename2;  /* Pointer to single pathname. */
+		const struct group_entry *group2;   /* Pointer to pathname group.  */
+	} u2;
+};
+
+/*************************  Keywords for ACLs.  *************************/
+
+#define TOMOYO_KEYWORD_AGGREGATOR               "aggregator "
+#define TOMOYO_KEYWORD_AGGREGATOR_LEN           (sizeof(TOMOYO_KEYWORD_AGGREGATOR) - 1)
+#define TOMOYO_KEYWORD_ALIAS                    "alias "
+#define TOMOYO_KEYWORD_ALIAS_LEN                (sizeof(TOMOYO_KEYWORD_ALIAS) - 1)
+#define TOMOYO_KEYWORD_ALLOW_READ               "allow_read "
+#define TOMOYO_KEYWORD_ALLOW_READ_LEN           (sizeof(TOMOYO_KEYWORD_ALLOW_READ) - 1)
+#define TOMOYO_KEYWORD_DELETE                   "delete "
+#define TOMOYO_KEYWORD_DELETE_LEN               (sizeof(TOMOYO_KEYWORD_DELETE) - 1)
+#define TOMOYO_KEYWORD_DENY_REWRITE             "deny_rewrite "
+#define TOMOYO_KEYWORD_DENY_REWRITE_LEN         (sizeof(TOMOYO_KEYWORD_DENY_REWRITE) - 1)
+#define TOMOYO_KEYWORD_FILE_PATTERN             "file_pattern "
+#define TOMOYO_KEYWORD_FILE_PATTERN_LEN         (sizeof(TOMOYO_KEYWORD_FILE_PATTERN) - 1)
+#define TOMOYO_KEYWORD_INITIALIZER              "initializer "
+#define TOMOYO_KEYWORD_INITIALIZER_LEN          (sizeof(TOMOYO_KEYWORD_INITIALIZER) - 1)
+#define TOMOYO_KEYWORD_INITIALIZE_DOMAIN        "initialize_domain "
+#define TOMOYO_KEYWORD_INITIALIZE_DOMAIN_LEN    (sizeof(TOMOYO_KEYWORD_INITIALIZE_DOMAIN) - 1)
+#define TOMOYO_KEYWORD_KEEP_DOMAIN              "keep_domain "
+#define TOMOYO_KEYWORD_KEEP_DOMAIN_LEN          (sizeof(TOMOYO_KEYWORD_KEEP_DOMAIN) - 1)
+#define TOMOYO_KEYWORD_NO_INITIALIZER           "no_initializer "
+#define TOMOYO_KEYWORD_NO_INITIALIZER_LEN       (sizeof(TOMOYO_KEYWORD_NO_INITIALIZER) - 1)
+#define TOMOYO_KEYWORD_NO_INITIALIZE_DOMAIN     "no_initialize_domain "
+#define TOMOYO_KEYWORD_NO_INITIALIZE_DOMAIN_LEN (sizeof(TOMOYO_KEYWORD_NO_INITIALIZE_DOMAIN) - 1)
+#define TOMOYO_KEYWORD_NO_KEEP_DOMAIN           "no_keep_domain "
+#define TOMOYO_KEYWORD_NO_KEEP_DOMAIN_LEN       (sizeof(TOMOYO_KEYWORD_NO_KEEP_DOMAIN) - 1)
+#define TOMOYO_KEYWORD_PATH_GROUP               "path_group "
+#define TOMOYO_KEYWORD_PATH_GROUP_LEN           (sizeof(TOMOYO_KEYWORD_PATH_GROUP) - 1)
+#define TOMOYO_KEYWORD_SELECT                   "select "
+#define TOMOYO_KEYWORD_SELECT_LEN               (sizeof(TOMOYO_KEYWORD_SELECT) - 1)
+#define TOMOYO_KEYWORD_UNDELETE                 "undelete "
+#define TOMOYO_KEYWORD_UNDELETE_LEN             (sizeof(TOMOYO_KEYWORD_UNDELETE) - 1)
+
+#define TOMOYO_KEYWORD_USE_PROFILE              "use_profile "
+
+#define TOMOYO_ROOT_NAME "<kernel>"             /* A domain definition starts with <kernel> . */
+#define TOMOYO_ROOT_NAME_LEN (sizeof(TOMOYO_ROOT_NAME) - 1)
+
+/*************************  Index numbers for Access Controls.  *************************/
+
+#define TOMOYO_PROFILE_COMMENT                      0  /* status.txt             */
+#define TOMOYO_MAC_FOR_FILE                  1  /* domain_policy.txt      */
+#define TOMOYO_MAX_ACCEPT_ENTRY              2
+#define TOMOYO_VERBOSE                       3
+#define TOMOYO_ALLOW_ENFORCE_GRACE                  4
+#define TOMOYO_MAX_CONTROL_INDEX                    5
+
+/*************************  Index numbers for updates counter.  *************************/
+
+#define TOMOYO_UPDATES_COUNTER_DOMAIN_POLICY    1
+#define TOMOYO_UPDATES_COUNTER_EXCEPTION_POLICY 2
+#define TOMOYO_UPDATES_COUNTER_STATUS           3
+#define TOMOYO_UPDATES_COUNTER_QUERY            4
+#define TOMOYO_UPDATES_COUNTER_MANAGER          5
+#define TOMOYO_MAX_UPDATES_COUNTER              6
+
+/*************************  Indexes for /proc interfaces.  *************************/
+
+#define TOMOYO_POLICY_DOMAINPOLICY          0
+#define TOMOYO_POLICY_EXCEPTIONPOLICY       1
+#define TOMOYO_POLICY_DOMAIN_STATUS         2
+#define TOMOYO_INFO_PROCESS_STATUS          3
+#define TOMOYO_INFO_MEMINFO                 4
+#define TOMOYO_INFO_SELFDOMAIN              5
+#define TOMOYO_INFO_MAPPING                 6
+#define TOMOYO_STATUS                       7
+#define TOMOYO_POLICY_QUERY                 8
+#define TOMOYO_POLICY_MANAGER               9
+#define TOMOYO_INFO_UPDATESCOUNTER         10
+
+/*************************  The structure for /proc interfaces.  *************************/
+
+struct io_buffer {
+	int (*read) (struct io_buffer *);
+	struct semaphore read_sem;
+	int (*write) (struct io_buffer *);
+	struct semaphore write_sem;
+	int (*poll) (struct file *file, poll_table *wait);
+	void *read_var1;                  /* The position currently reading from. */
+	void *read_var2;                  /* Extra variables for reading.         */
+	struct domain_info *write_var1;   /* The position currently writing to.   */
+	int read_step;                    /* The step for reading.                */
+	char *read_buf;                   /* Buffer for reading.                  */
+	int read_eof;                     /* EOF flag for reading.                */
+	int read_avail;                   /* Bytes available for reading.         */
+	int readbuf_size;                 /* Size of read buffer.                 */
+	char *write_buf;                  /* Buffer for writing.                  */
+	int write_avail;                  /* Bytes available for writing.         */
+	int writebuf_size;                /* Size of write buffer.                */
+};
+
+/*************************  PROTOTYPES  *************************/
+
+char *tomoyo_init_audit_log(int *len);
+const char *tomoyo_get_exe(void);
+const char *tomoyo_get_last_name(const struct domain_info *domain);
+const char *tomoyo_get_msg(const int is_enforce);
+const char *tomoyo_acltype2keyword(const unsigned int acl_type);
+int tomoyo_add_aggregator_policy(char *data, const int is_delete);
+int tomoyo_add_alias_policy(char *data, const int is_delete);
+int tomoyo_add_domain_acl(struct acl_info *ptr,
+                          struct domain_info *domain,
+                          struct acl_info *new_ptr);
+int tomoyo_add_domain_initializer_policy(char *data,
+                                         const int is_not,
+                                         const int is_delete,
+                                         const int is_oldstyle);
+int tomoyo_add_domain_keeper_policy(char *data, const int is_not, const int is_delete);
+int tomoyo_add_file_policy(char *data, struct domain_info *domain, const int is_delete);
+int tomoyo_add_globally_readable_policy(char *data, const int is_delete);
+int tomoyo_add_group_policy(char *data, const int is_delete);
+int tomoyo_add_no_rewrite_policy(char *pattern, const int is_delete);
+int tomoyo_add_pattern_policy(char *data, const int is_delete);
+int tomoyo_check_supervisor(const char *fmt, ...) __attribute__ ((format(printf, 1, 2)));
+int tomoyo_del_domain_acl(struct acl_info *ptr);
+int tomoyo_delete_domain(char *data);
+int tomoyo_is_correct_domain(const unsigned char *domainname, const char *function);
+int tomoyo_is_correct_path(const char *filename,
+                           const int start_type,
+                           const int pattern_type,
+                           const int end_type,
+                           const char *function);
+int tomoyo_is_domain_def(const unsigned char *buffer);
+int tomoyo_path_matches_to_pattern(const struct path_info *pathname0,
+                                   const struct path_info *pattern0);
+int tomoyo_read_aggregator_policy(struct io_buffer *head);
+int tomoyo_read_alias_policy(struct io_buffer *head);
+int tomoyo_read_domain_initializer_policy(struct io_buffer *head);
+int tomoyo_read_domain_keeper_policy(struct io_buffer *head);
+int tomoyo_read_globally_readable_policy(struct io_buffer *head);
+int tomoyo_read_group_policy(struct io_buffer *head);
+int tomoyo_read_no_rewrite_policy(struct io_buffer *head);
+int tomoyo_read_pattern_policy(struct io_buffer *head);
+int tomoyo_read_permission_mapping(struct io_buffer *head);
+int tomoyo_read_self_domain(struct io_buffer *head);
+int tomoyo_set_permission_mapping(struct io_buffer *head);
+int tomoyo_write_audit_log(char *log, const int is_granted);
+int tomoyo_acltype2paths(const unsigned int acl_type);
+int tomoyo_io_printf(struct io_buffer *head, const char *fmt, ...)
+	__attribute__ ((format(printf, 2, 3)));
+struct domain_info *tomoyo_find_domain(const char *domainname);
+struct domain_info *tomoyo_find_or_assign_new_domain(const char *domainname, const u8 profile);
+struct domain_info *tomoyo_undelete_domain(const char *domainname0);
+unsigned int tomoyo_check_accept(const unsigned int index);
+unsigned int tomoyo_check_enforce(const unsigned int index);
+unsigned int tomoyo_check_flags(const unsigned int index);
+unsigned int tomoyo_verbose_mode(void);
+void tomoyo_update_counter(const unsigned char index);
+void *tomoyo_alloc(const size_t size);
+void tomoyo_free(const void *p);
+void tomoyo_fill_path_info(struct path_info *ptr);
+
+static inline int tomoyo_pathcmp(const struct path_info *a, const struct path_info *b)
+{
+	return a->hash != b->hash || strcmp(a->name, b->name);
+}
+
+extern struct domain_info KERNEL_DOMAIN;
+
+struct path_info;
+
+int tomoyo_check_exec_perm(const struct path_info *filename, struct file *filp);
+/* Check whether the given dentry is allowed to read/write/execute. */
+int tomoyo_check_open_permission(struct dentry *dentry, struct vfsmount *mnt, const int flag);
+/* Check whether the given dentry is allowed to write. */
+int tomoyo_check_single_write_permission(const unsigned int operation,
+                                         struct dentry *dentry,
+                                         struct vfsmount *mnt);
+int tomoyo_check_double_write_permission(const unsigned int operation,
+                                         struct dentry *dentry1,
+                                         struct vfsmount *mnt1,
+                                         struct dentry *dentry2,
+                                         struct vfsmount *mnt2);
+int tomoyo_check_rewrite_permission(struct file *filp);
+
+struct inode;
+
+/*************************  Index numbers for Access Controls.  *************************/
+
+#define TOMOYO_TYPE_CREATE_ACL       0
+#define TOMOYO_TYPE_UNLINK_ACL       1
+#define TOMOYO_TYPE_MKDIR_ACL        2
+#define TOMOYO_TYPE_RMDIR_ACL        3
+#define TOMOYO_TYPE_MKFIFO_ACL       4
+#define TOMOYO_TYPE_MKSOCK_ACL       5
+#define TOMOYO_TYPE_MKBLOCK_ACL      6
+#define TOMOYO_TYPE_MKCHAR_ACL       7
+#define TOMOYO_TYPE_TRUNCATE_ACL     8
+#define TOMOYO_TYPE_SYMLINK_ACL      9
+#define TOMOYO_TYPE_LINK_ACL        10
+#define TOMOYO_TYPE_RENAME_ACL      11
+#define TOMOYO_TYPE_REWRITE_ACL     12
+
+#define TOMOYO_TYPE_FILE_ACL         100
+
+struct linux_binprm;
+struct pt_regs;
+
+#define TOMOYO_CHECK_READ_FOR_OPEN_EXEC 1
+
+int tomoyo_too_many_domain_acl(struct domain_info * const domain);
+/***** TOMOYO Linux end. *****/
+#endif
---------------

