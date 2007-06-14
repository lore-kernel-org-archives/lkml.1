Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbXFNHjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbXFNHjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 03:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbXFNHjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 03:39:36 -0400
Received: from ms1.nttdata.co.jp ([163.135.193.232]:40066 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbXFNHje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 03:39:34 -0400
Message-ID: <4670F0B1.1040708@nttdata.co.jp>
Date: Thu, 14 Jun 2007 16:39:29 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [TOMOYO 9/9] Domain transition handler functions.
References: <5fb14edc0706140030x4a906178ofd35df06dfa5c192@mail.gmail.com>
In-Reply-To: <5fb14edc0706140030x4a906178ofd35df06dfa5c192@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jun 2007 07:39:30.0191 (UTC) FILETIME=[248C49F0:01C7AE57]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the main part for domain transition.
In TOMOYO Linux, domains are automatically created at runtime.

To make discussion smooth by reducing the amount of patches,
we pruned argv[0] checks (although we referred the need of argv[0] checking
at AppArmor's thread, http://lkml.org/lkml/2007/5/26/52 ).

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

---------------
 security/tomoyo/domain.c |  782 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 782 insertions(+)

diff -ubBpErN linux-2.6.21.5/security/tomoyo/domain.c linux-2.6.21.5-tomoyo/security/tomoyo/domain.c
--- linux-2.6.21.5/security/tomoyo/domain.c	1970-01-01 09:00:00.000000000 +0900
+++ linux-2.6.21.5-tomoyo/security/tomoyo/domain.c	2007-06-05 00:00:00.000000000 +0900
@@ -0,0 +1,782 @@
+/*
+ * security/tomoyo/domain.c
+ *
+ * Domain transition functions for TOMOYO Linux.
+ *
+ * Copyright (C) 2005-2007  NTT DATA CORPORATION
+ *
+ * Version: 2.0   2007/06/05
+ */
+
+#include "tomoyo.h"
+#include "realpath.h"
+#include <linux/highmem.h>
+#include <linux/binfmts.h>
+
+#ifndef for_each_process
+#define for_each_process for_each_task
+#endif
+
+/*************************  VARIABLES  *************************/
+
+/* /sbin/init started? */
+extern int sbin_init_started;
+
+/* Lock for appending domain's ACL. */
+DECLARE_MUTEX(domain_acl_lock);
+
+/***** The structure for program files to force domain reconstruction. *****/
+
+struct domain_initializer_entry {
+	struct domain_initializer_entry *next;
+	const struct path_info *domainname;    /* This may be NULL */
+	const struct path_info *program;
+	u8 is_deleted;
+	u8 is_not;
+	u8 is_last_name;
+	u8 is_oldstyle;
+};
+
+/***** The structure for domains to not to transit domains. *****/
+
+struct domain_keeper_entry {
+	struct domain_keeper_entry *next;
+	const struct path_info *domainname;
+	const struct path_info *program;       /* This may be NULL */
+	u8 is_deleted;
+	u8 is_not;
+	u8 is_last_name;
+};
+
+/***** The structure for program files that should be aggregated. *****/
+
+struct aggregator_entry {
+	struct aggregator_entry *next;
+	const struct path_info *original_name;
+	const struct path_info *aggregated_name;
+	int is_deleted;
+};
+
+/***** The structure for program files that should be aliased. *****/
+
+struct alias_entry {
+	struct alias_entry *next;
+	const struct path_info *original_name;
+	const struct path_info *aliased_name;
+	int is_deleted;
+};
+
+/*************************  VARIABLES  *************************/
+
+/* Domain creation lock. */
+static DECLARE_MUTEX(new_domain_assign_lock);
+
+/*************************  UTILITY FUNCTIONS  *************************/
+
+int tomoyo_is_domain_def(const unsigned char *buffer)
+{
+	/* while (*buffer && (*buffer <= ' ' || *buffer >= 127)) buffer++; */
+	return strncmp(buffer, TOMOYO_ROOT_NAME, TOMOYO_ROOT_NAME_LEN) == 0;
+}
+
+const char *tomoyo_get_last_name(const struct domain_info *domain)
+{
+	const char *cp0 = domain->domainname->name, *cp1;
+	if ((cp1 = strrchr(cp0, ' ')) != NULL) return cp1 + 1;
+	return cp0;
+}
+
+int tomoyo_read_self_domain(struct io_buffer *head)
+{
+	if (!head->read_eof) {
+		tomoyo_io_printf(head,
+		                 "%s",
+		                 ((struct tomoyo_security *) current->security)->domain_info->domainname->name);
+		head->read_eof = 1;
+	}
+	return 0;
+}
+
+int tomoyo_add_domain_acl(struct acl_info *ptr, struct domain_info *domain, struct acl_info *new_ptr)
+{
+	mb(); /* Instead of using spinlock. */
+	if (!ptr) domain->first_acl_ptr = (struct acl_info *) new_ptr;
+	else ptr->next = (struct acl_info *) new_ptr;
+	tomoyo_update_counter(TOMOYO_UPDATES_COUNTER_DOMAIN_POLICY);
+	return 0;
+}
+
+int tomoyo_del_domain_acl(struct acl_info *ptr)
+{
+	ptr->is_deleted = 1;
+	tomoyo_update_counter(TOMOYO_UPDATES_COUNTER_DOMAIN_POLICY);
+	return 0;
+}
+
+int tomoyo_too_many_domain_acl(struct domain_info * const domain) {
+	unsigned int count = 0;
+	struct acl_info *ptr;
+	for (ptr = domain->first_acl_ptr; ptr; ptr = ptr->next) {
+		if (!ptr->is_deleted) count++;
+	}
+	/* If there are so many entries, don't append if accept mode. */
+	if (count < tomoyo_check_flags(TOMOYO_MAX_ACCEPT_ENTRY)) return 0;
+	if (!domain->quota_warned) {
+		printk("TOMOYO-WARNING: Domain '%s' has so many ACLs to hold. "
+		       "Stopped auto-append mode.\n", domain->domainname->name);
+		domain->quota_warned = 1;
+	}
+	return 1;
+}
+
+
+/*************************  DOMAIN INITIALIZER HANDLER  *************************/
+
+static struct domain_initializer_entry *domain_initializer_list = NULL;
+
+static int tomoyo_add_domain_initializer_entry(const char *domainname,
+                                               const char *program,
+                                               const int is_not,
+                                               const int is_delete,
+                                               const int is_oldstyle)
+{
+	struct domain_initializer_entry *new_entry, *ptr;
+	static DECLARE_MUTEX(lock);
+	const struct path_info *saved_program, *saved_domainname = NULL;
+	int error = -ENOMEM;
+	int is_last_name = 0;
+	if (!tomoyo_is_correct_path(program, 1, -1, -1, __FUNCTION__))
+		return -EINVAL; /* No patterns allowed. */
+	if (domainname) {
+		if (!tomoyo_is_domain_def(domainname) &&
+		    tomoyo_is_correct_path(domainname, 1, -1, -1, __FUNCTION__)) {
+			is_last_name = 1;
+		} else if (!tomoyo_is_correct_domain(domainname, __FUNCTION__)) {
+			return -EINVAL;
+		}
+		if ((saved_domainname = tomoyo_save_name(domainname)) == NULL) return -ENOMEM;
+	}
+	if ((saved_program = tomoyo_save_name(program)) == NULL) return -ENOMEM;
+	down(&lock);
+	for (ptr = domain_initializer_list; ptr; ptr = ptr->next) {
+		if (ptr->is_not == is_not &&
+		    ptr->is_oldstyle == is_oldstyle &&
+		    ptr->domainname == saved_domainname &&
+		    ptr->program == saved_program) {
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
+	new_entry->domainname = saved_domainname;
+	new_entry->program = saved_program;
+	new_entry->is_not = is_not;
+	new_entry->is_last_name = is_last_name;
+	new_entry->is_oldstyle = is_oldstyle;
+	mb(); /* Instead of using spinlock. */
+	if ((ptr = domain_initializer_list) != NULL) {
+		while (ptr->next)
+			ptr = ptr->next;
+		ptr->next = new_entry;
+	} else {
+		domain_initializer_list = new_entry;
+	}
+	error = 0;
+ out:
+	up(&lock);
+	return error;
+}
+
+int tomoyo_read_domain_initializer_policy(struct io_buffer *head)
+{
+	struct domain_initializer_entry *ptr = head->read_var2;
+	if (!ptr) ptr = domain_initializer_list;
+	while (ptr) {
+		head->read_var2 = ptr;
+		if (!ptr->is_deleted) {
+			if (ptr->domainname) {
+				if (tomoyo_io_printf(head,
+				                     "%s%s%s from %s\n",
+				                     ptr->is_not ? "no_" : "", 
+				                     ptr->is_oldstyle ?
+				                     	TOMOYO_KEYWORD_INITIALIZER : TOMOYO_KEYWORD_INITIALIZE_DOMAIN,
+				                     ptr->program->name, ptr->domainname->name))
+					break;
+			} else {
+				if (tomoyo_io_printf(head,
+				                     "%s%s%s\n",
+				                     ptr->is_not ? "no_" : "",
+				                     ptr->is_oldstyle ?
+				                     	TOMOYO_KEYWORD_INITIALIZER : TOMOYO_KEYWORD_INITIALIZE_DOMAIN,
+				                     ptr->program->name))
+					break;
+			}
+		}
+		ptr = ptr->next;
+	}
+	return ptr ? -ENOMEM : 0;
+}
+
+int tomoyo_add_domain_initializer_policy(char *data,
+                                         const int is_not,
+                                         const int is_delete,
+                                         const int is_oldstyle)
+{
+	char *cp = strstr(data, " from ");
+	if (cp) {
+		*cp = '\0';
+		return tomoyo_add_domain_initializer_entry(cp + 6,
+		                                           data,
+		                                           is_not,
+		                                           is_delete,
+		                                           is_oldstyle);
+	} else {
+		return tomoyo_add_domain_initializer_entry(NULL,
+		                                           data,
+		                                           is_not,
+		                                           is_delete,
+		                                           is_oldstyle);
+	}
+}
+
+static int tomoyo_is_domain_initializer(const struct path_info *domainname,
+                                        const struct path_info *program,
+                                        const struct path_info *last_name)
+{
+	struct domain_initializer_entry *ptr;
+	int flag = 0;
+	for (ptr = domain_initializer_list; ptr; ptr = ptr->next) {
+		if (ptr->is_deleted ) continue;
+		if (ptr->domainname) {
+			if (!ptr->is_last_name) {
+				if (ptr->domainname != domainname) continue;
+			} else {
+				if (tomoyo_pathcmp(ptr->domainname, last_name)) continue;
+			}
+		}
+		if (tomoyo_pathcmp(ptr->program, program)) continue;
+		if (ptr->is_not) return 0;
+		flag = 1;
+	}
+	return flag;
+}
+
+/*************************  DOMAIN KEEPER HANDLER  *************************/
+
+static struct domain_keeper_entry *domain_keeper_list = NULL;
+
+static int tomoyo_add_domain_keeper_entry(const char *domainname,
+                                          const char *program,
+                                          const int is_not,
+                                          const int is_delete)
+{
+	struct domain_keeper_entry *new_entry, *ptr;
+	const struct path_info *saved_domainname, *saved_program = NULL;
+	static DECLARE_MUTEX(lock);
+	int error = -ENOMEM;
+	int is_last_name = 0;
+	if (!tomoyo_is_domain_def(domainname) &&
+	    tomoyo_is_correct_path(domainname, 1, -1, -1, __FUNCTION__)) {
+		is_last_name = 1;
+	} else if (!tomoyo_is_correct_domain(domainname, __FUNCTION__)) {
+		return -EINVAL;
+	}
+	if (program) {
+		if (!tomoyo_is_correct_path(program, 1, -1, -1, __FUNCTION__)) return -EINVAL;
+		if ((saved_program = tomoyo_save_name(program)) == NULL) return -ENOMEM;
+	}
+	if ((saved_domainname = tomoyo_save_name(domainname)) == NULL) return -ENOMEM;
+	down(&lock);
+	for (ptr = domain_keeper_list; ptr; ptr = ptr->next) {
+		if (ptr->is_not == is_not && ptr->domainname == saved_domainname &&
+		    ptr->program == saved_program) {
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
+	new_entry->domainname = saved_domainname;
+	new_entry->program = saved_program;
+	new_entry->is_not = is_not;
+	new_entry->is_last_name = is_last_name;
+	mb(); /* Instead of using spinlock. */
+	if ((ptr = domain_keeper_list) != NULL) {
+		while (ptr->next)
+			ptr = ptr->next;
+		ptr->next = new_entry;
+	} else {
+		domain_keeper_list = new_entry;
+	}
+	error = 0;
+ out:
+	up(&lock);
+	return error;
+}
+
+int tomoyo_add_domain_keeper_policy(char *data, const int is_not, const int is_delete)
+{
+	char *cp = strstr(data, " from ");
+	if (cp) {
+		*cp = '\0';
+		return tomoyo_add_domain_keeper_entry(cp + 6, data, is_not, is_delete);
+	} else {
+		return tomoyo_add_domain_keeper_entry(data, NULL, is_not, is_delete);
+	}
+}
+
+int tomoyo_read_domain_keeper_policy(struct io_buffer *head)
+{
+	struct domain_keeper_entry *ptr = head->read_var2;
+	if (!ptr) ptr = domain_keeper_list;
+	while (ptr) {
+		head->read_var2 = ptr;
+		if (!ptr->is_deleted) {
+			if (ptr->program) {
+				if (tomoyo_io_printf(head,
+				                     "%s" TOMOYO_KEYWORD_KEEP_DOMAIN "%s from %s\n",
+				                     ptr->is_not ? "no_" : "",
+				                     ptr->program->name,
+				                     ptr->domainname->name))
+					break;
+			} else {
+				if (tomoyo_io_printf(head,
+				                     "%s" TOMOYO_KEYWORD_KEEP_DOMAIN "%s\n",
+				                     ptr->is_not ? "no_" : "",
+				                     ptr->domainname->name))
+					break;
+			}
+		}
+		ptr = ptr->next;
+	}
+	return ptr ? -ENOMEM : 0;
+}
+
+static int tomoyo_is_domain_keeper(const struct path_info *domainname,
+                                   const struct path_info *program,
+                                   const struct path_info *last_name)
+{
+	struct domain_keeper_entry *ptr;
+	int flag = 0;
+	for (ptr = domain_keeper_list; ptr; ptr = ptr->next) {
+		if (ptr->is_deleted) continue;
+		if (!ptr->is_last_name) {
+			if (ptr->domainname != domainname) continue;
+		} else {
+			if (tomoyo_pathcmp(ptr->domainname, last_name)) continue; 
+		}
+		if (ptr->program && tomoyo_pathcmp(ptr->program, program)) continue;
+		if (ptr->is_not) return 0;
+		flag = 1;
+	}
+	return flag;
+}
+
+/*************************  SYMBOLIC LINKED PROGRAM HANDLER  *************************/
+
+static struct alias_entry *alias_list = NULL;
+
+static int tomoyo_add_alias_entry(const char *original_name, const char *aliased_name, const int is_delete)
+{
+	struct alias_entry *new_entry, *ptr;
+	static DECLARE_MUTEX(lock);
+	const struct path_info *saved_original_name, *saved_aliased_name;
+	int error = -ENOMEM;
+	if (!tomoyo_is_correct_path(original_name, 1, -1, -1, __FUNCTION__) ||
+	    !tomoyo_is_correct_path(aliased_name, 1, -1, -1, __FUNCTION__))
+		return -EINVAL; /* No patterns allowed. */
+	if ((saved_original_name = tomoyo_save_name(original_name)) == NULL ||
+	    (saved_aliased_name = tomoyo_save_name(aliased_name)) == NULL)
+		return -ENOMEM;
+	down(&lock);
+	for (ptr = alias_list; ptr; ptr = ptr->next) {
+		if (ptr->original_name == saved_original_name &&
+		    ptr->aliased_name == saved_aliased_name) {
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
+	new_entry->original_name = saved_original_name;
+	new_entry->aliased_name = saved_aliased_name;
+	mb(); /* Instead of using spinlock. */
+	if ((ptr = alias_list) != NULL) {
+		while (ptr->next)
+			ptr = ptr->next;
+		ptr->next = new_entry;
+	} else {
+		alias_list = new_entry;
+	}
+	error = 0;
+ out:
+	up(&lock);
+	return error;
+}
+
+int tomoyo_read_alias_policy(struct io_buffer *head)
+{
+	struct alias_entry *ptr = head->read_var2;
+	if (!ptr) ptr = alias_list;
+	while (ptr) {
+		head->read_var2 = ptr;
+		if (!ptr->is_deleted &&
+		    tomoyo_io_printf(head,
+		                     TOMOYO_KEYWORD_ALIAS "%s %s\n",
+		                     ptr->original_name->name,
+		                     ptr->aliased_name->name))
+			break;
+		ptr = ptr->next;
+	}
+	return ptr ? -ENOMEM : 0;
+}
+
+int tomoyo_add_alias_policy(char *data, const int is_delete)
+{
+	char *cp = strchr(data, ' ');
+	if (!cp) return -EINVAL;
+	*cp++ = '\0';
+	return tomoyo_add_alias_entry(data, cp, is_delete);
+}
+
+/*************************  DOMAIN AGGREGATOR HANDLER  *************************/
+
+static struct aggregator_entry *aggregator_list = NULL;
+
+static int tomoyo_add_aggregator_entry(const char *original_name,
+                                       const char *aggregated_name,
+                                       const int is_delete)
+{
+	struct aggregator_entry *new_entry, *ptr;
+	static DECLARE_MUTEX(lock);
+	const struct path_info *saved_original_name, *saved_aggregated_name;
+	int error = -ENOMEM;
+	if (!tomoyo_is_correct_path(original_name, 1, 0, -1, __FUNCTION__) ||
+	    !tomoyo_is_correct_path(aggregated_name, 1, -1, -1, __FUNCTION__))
+		return -EINVAL;
+	if ((saved_original_name = tomoyo_save_name(original_name)) == NULL ||
+	    (saved_aggregated_name = tomoyo_save_name(aggregated_name)) == NULL)
+		return -ENOMEM;
+	down(&lock);
+	for (ptr = aggregator_list; ptr; ptr = ptr->next) {
+		if (ptr->original_name == saved_original_name &&
+		    ptr->aggregated_name == saved_aggregated_name) {
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
+	new_entry->original_name = saved_original_name;
+	new_entry->aggregated_name = saved_aggregated_name;
+	mb(); /* Instead of using spinlock. */
+	if ((ptr = aggregator_list) != NULL) {
+		while (ptr->next)
+			ptr = ptr->next;
+		ptr->next = new_entry;
+	} else {
+		aggregator_list = new_entry;
+	}
+	error = 0;
+ out:
+	up(&lock);
+	return error;
+}
+
+int tomoyo_read_aggregator_policy(struct io_buffer *head)
+{
+	struct aggregator_entry *ptr = head->read_var2;
+	if (!ptr) ptr = aggregator_list;
+	while (ptr) {
+		head->read_var2 = ptr;
+		if (!ptr->is_deleted &&
+		    tomoyo_io_printf(head,
+		                     TOMOYO_KEYWORD_AGGREGATOR "%s %s\n",
+		                     ptr->original_name->name,
+		                     ptr->aggregated_name->name))
+			break;
+		ptr = ptr->next;
+	}
+	return ptr ? -ENOMEM : 0;
+}
+
+int tomoyo_add_aggregator_policy(char *data, const int is_delete)
+{
+	char *cp = strchr(data, ' ');
+	if (!cp) return -EINVAL;
+	*cp++ = '\0';
+	return tomoyo_add_aggregator_entry(data, cp, is_delete);
+}
+
+/*************************  DOMAIN DELETION HANDLER  *************************/
+
+int tomoyo_delete_domain(char *domainname0)
+{
+	struct domain_info *domain;
+	struct path_info domainname;
+	domainname.name = domainname0;
+	tomoyo_fill_path_info(&domainname);
+	down(&new_domain_assign_lock);
+	/* Is there an active domain? */ /* Never delete KERNEL_DOMAIN */
+	for (domain = KERNEL_DOMAIN.next; domain; domain = domain->next) {
+		if (domain->is_deleted || tomoyo_pathcmp(domain->domainname, &domainname)) continue;
+		break;
+	}
+	if (domain) {
+		struct domain_info *domain2;
+		/* Mark already deleted domains as non undeletable. */
+		for (domain2 = KERNEL_DOMAIN.next; domain2; domain2 = domain2->next) {
+			if (!domain2->is_deleted || tomoyo_pathcmp(domain2->domainname, &domainname))
+				continue;
+			domain2->is_deleted = 255;
+		}
+		/* Delete and mark active domain as undeletable. */
+		domain->is_deleted = 1;
+	}
+	up(&new_domain_assign_lock);
+	return 0;
+}
+
+struct domain_info *tomoyo_undelete_domain(const char *domainname0)
+{
+	struct domain_info *domain, *candidate_domain = NULL;
+	struct path_info domainname;
+	domainname.name = domainname0;
+	tomoyo_fill_path_info(&domainname);
+	down(&new_domain_assign_lock);
+	for (domain = KERNEL_DOMAIN.next; domain; domain = domain->next) {
+		if (tomoyo_pathcmp(&domainname, domain->domainname)) continue;
+		if (!domain->is_deleted) {
+			/* This domain is active. I can't undelete. */
+			candidate_domain = NULL;
+			break;
+		}
+		/* Is this domain undeletable? */
+		if (domain->is_deleted == 1) candidate_domain = domain;
+	}
+	if (candidate_domain) {
+		candidate_domain->is_deleted = 0;
+	}
+	up(&new_domain_assign_lock);
+	return candidate_domain;
+}
+
+/*************************  DOMAIN TRANSITION HANDLER  *************************/
+
+struct domain_info *tomoyo_find_domain(const char *domainname0)
+{
+	struct domain_info *domain;
+	static int first = 1;
+	struct path_info domainname;
+	domainname.name = domainname0;
+	tomoyo_fill_path_info(&domainname);
+	if (first) {
+		KERNEL_DOMAIN.domainname = tomoyo_save_name(TOMOYO_ROOT_NAME);
+		first = 0;
+	}
+	for (domain = &KERNEL_DOMAIN; domain; domain = domain->next) {
+		if (!domain->is_deleted && !tomoyo_pathcmp(&domainname, domain->domainname))
+			return domain;
+	}
+	return NULL;
+}
+
+struct domain_info *tomoyo_find_or_assign_new_domain(const char *domainname, const u8 profile)
+{
+	struct domain_info *domain = NULL;
+	const struct path_info *saved_domainname;
+	down(&new_domain_assign_lock);
+	if ((domain = tomoyo_find_domain(domainname)) != NULL) goto out;
+	if (!tomoyo_is_correct_domain(domainname, __FUNCTION__)) goto out;
+	if ((saved_domainname = tomoyo_save_name(domainname)) == NULL) goto out;
+	/* Can I reuse memory of deleted domain? */
+	for (domain = KERNEL_DOMAIN.next; domain; domain = domain->next) {
+		struct task_struct *p;
+		struct acl_info *ptr;
+		int flag;
+		if (!domain->is_deleted || domain->domainname != saved_domainname) continue;
+		flag = 0;
+		/***** CRITICAL SECTION START *****/
+		read_lock(&tasklist_lock);
+		for_each_process(p) {
+			if (p->security == domain) {
+				flag = 1;
+				break;
+			}
+		}
+		read_unlock(&tasklist_lock);
+		/***** CRITICAL SECTION END *****/
+		if (flag) continue;
+		for (ptr = domain->first_acl_ptr; ptr; ptr = ptr->next) ptr->is_deleted = 1;
+		domain->profile = profile;
+		domain->quota_warned = 0;
+		mb(); /* Instead of using spinlock. */
+		domain->is_deleted = 0;
+		goto out;
+	}
+	/* No memory reusable. Create using new memory. */
+	if ((domain = tomoyo_alloc_element(sizeof(*domain))) != NULL) {
+		struct domain_info *ptr = &KERNEL_DOMAIN;
+		domain->domainname = saved_domainname;
+		domain->profile = profile;
+		mb(); /* Instead of using spinlock. */
+		while (ptr->next)
+			ptr = ptr->next;
+		ptr->next = domain;
+	}
+ out: ;
+	up(&new_domain_assign_lock);
+	return domain;
+}
+
+int tomoyo_find_next_domain(struct linux_binprm *bprm, struct domain_info **next_domain)
+{
+	/* This function assumes that the size of buffer returned */
+	/* by tomoyo_realpath() = TOMOYO_MAX_PATHNAME_LEN. */
+	struct domain_info *old_domain =
+		((struct tomoyo_security *) current->security)->domain_info, *domain = NULL;
+	const char *old_domain_name = old_domain->domainname->name;
+	const char *original_name = bprm->filename;
+	struct file *filp = bprm->file;
+	char *new_domain_name = NULL;
+	char *real_program_name = NULL, *symlink_program_name = NULL;
+	const int is_enforce = tomoyo_check_enforce(TOMOYO_MAC_FOR_FILE);
+	int retval;
+	struct path_info r, s, l;
+
+	{
+		/*
+		 * Built-in initializers.
+		 * This is needed because policies are not loaded until starting /sbin/init .
+		 */
+		static int first = 1;
+		if (first) {
+			tomoyo_add_domain_initializer_entry(NULL, "/sbin/hotplug", 0, 0, 0);
+			tomoyo_add_domain_initializer_entry(NULL, "/sbin/modprobe", 0, 0, 0);
+			first = 0;
+		}
+	}
+
+	/* Get realpath of program. */
+	retval = -ENOENT; /* I hope tomoyo_realpath() won't fail with -ENOMEM. */
+	if ((real_program_name = tomoyo_realpath(original_name)) == NULL) goto out;
+	/* Get realpath of symbolic link. */
+	if ((symlink_program_name = tomoyo_realpath_nofollow(original_name)) == NULL) goto out;
+
+	r.name = real_program_name;
+	tomoyo_fill_path_info(&r);
+	s.name = symlink_program_name;
+	tomoyo_fill_path_info(&s);
+	if ((l.name = strrchr(old_domain_name, ' ')) != NULL) l.name++;
+	else l.name = old_domain_name;
+	tomoyo_fill_path_info(&l);
+
+	/* Check 'alias' directive. */
+	if (tomoyo_pathcmp(&r, &s)) {
+		struct alias_entry *ptr;
+		/* Is this program allowed to be called via symbolic links? */
+		for (ptr = alias_list; ptr; ptr = ptr->next) {
+			if (ptr->is_deleted ||
+			    tomoyo_pathcmp(&r, ptr->original_name) ||
+			    tomoyo_pathcmp(&s, ptr->aliased_name))
+				continue;
+			memset(real_program_name, 0, TOMOYO_MAX_PATHNAME_LEN);
+			strncpy(real_program_name,
+			        ptr->aliased_name->name,
+			        TOMOYO_MAX_PATHNAME_LEN - 1);
+			tomoyo_fill_path_info(&r);
+			break;
+		}
+	}
+	
+	/* Check 'aggregator' directive. */
+	{
+		struct aggregator_entry *ptr;
+		/* Is this program allowed to be aggregated? */
+		for (ptr = aggregator_list; ptr; ptr = ptr->next) {
+			if (ptr->is_deleted ||
+			    !tomoyo_path_matches_to_pattern(&r, ptr->original_name))
+				continue;
+			memset(real_program_name, 0, TOMOYO_MAX_PATHNAME_LEN);
+			strncpy(real_program_name,
+			        ptr->aggregated_name->name,
+			        TOMOYO_MAX_PATHNAME_LEN - 1);
+			tomoyo_fill_path_info(&r);
+			break;
+		}
+	}
+	
+	/* Check execute permission. */
+	if ((retval = tomoyo_check_exec_perm(&r, filp)) < 0) goto out;
+
+	/* Allocate memory for calcurating domain name. */
+	retval = -ENOMEM;
+	if ((new_domain_name = tomoyo_alloc(TOMOYO_MAX_PATHNAME_LEN + 16)) == NULL) goto out;
+	
+	if (tomoyo_is_domain_initializer(old_domain->domainname, &r, &l)) {
+		/* Transit to the child of KERNEL_DOMAIN domain. */
+		snprintf(new_domain_name,
+		         TOMOYO_MAX_PATHNAME_LEN + 1,
+		         TOMOYO_ROOT_NAME " " "%s",
+		         real_program_name);
+	} else if (old_domain == &KERNEL_DOMAIN && !sbin_init_started) {
+		/*
+		 * Needn't to transit from kernel domain before starting /sbin/init .
+		 * But transit from kernel domain if executing initializers,
+		 * for they might start before /sbin/init .
+		 */
+		domain = old_domain;
+	} else if (tomoyo_is_domain_keeper(old_domain->domainname, &r, &l)) {
+		/* Keep current domain. */
+		domain = old_domain;
+	} else {
+		/* Normal domain transition. */
+		snprintf(new_domain_name,
+		         TOMOYO_MAX_PATHNAME_LEN + 1,
+		         "%s %s",
+		         old_domain_name,
+		         real_program_name);
+	}
+	if (!domain && strlen(new_domain_name) < TOMOYO_MAX_PATHNAME_LEN) {
+		if (is_enforce) {
+			domain = tomoyo_find_domain(new_domain_name);
+			if (!domain)
+				if (tomoyo_check_supervisor("#Need to create domain\n%s\n",
+				    new_domain_name) == 0)
+					domain = tomoyo_find_or_assign_new_domain(new_domain_name,
+						                                  ((struct tomoyo_security *) current->security)->domain_info->profile);
+		} else {
+			domain = tomoyo_find_or_assign_new_domain(new_domain_name,
+			                                          ((struct tomoyo_security *) current->security)->domain_info->profile);
+		}
+	}
+	if (!domain) {
+		printk("TOMOYO-ERROR: Domain '%s' not defined.\n", new_domain_name);
+		if (is_enforce) retval = -EPERM;
+	} else {
+		retval = 0;
+	}
+ out: ;
+	tomoyo_free(new_domain_name);
+	tomoyo_free(real_program_name);
+	tomoyo_free(symlink_program_name);
+	*next_domain = domain ? domain : old_domain;
+	return retval;
+}
---------------

