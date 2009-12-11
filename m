Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbZLKNxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbZLKNxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 08:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757677AbZLKNxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 08:53:07 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:55111 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756884AbZLKNxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 08:53:05 -0500
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] TOMOYO: Use RCU primitives for list operation
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <200912112253.BCC87030.FLtMOOFOVSQFJH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 11 Dec 2009 22:53:05 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can somebody please review?
----------
[PATCH] TOMOYO: Use RCU primitives for list operation

Currently, TOMOYO is using down_read() only for protecting ->prev member from
writers. If we convert list operation using RCU primitives so that readers don't
look at ->prev member, we can replace down_read() by srcu_read_lock().

tomoyo_read_lock()/tomoyo_read_unlock() (these are wrappers for
srcu_read_lock()/srcu_read_unlock()) protects the data against the garbage
collector (which will be added in the future). I call tomoyo_read_lock() when
/sys/kernel/security/tomoyo/ interface is open()ed and call
tomoyo_read_unlock() when /sys/kernel/security/tomoyo/ interface is close()d
rather than calling tomoyo_read_lock()/tomoyo_read_unlock() upon individual
read()/write() requests. In this way, the pointers saved in
"struct tomoyo_io_buffer" are guaranteed to be valid. Please ignore

  warning: context imbalance in 'tomoyo_open_control' - wrong count at exit
  warning: context imbalance in 'tomoyo_close_control' - unexpected unlock

messages when built with "C=1" option.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 common.c   |   90 +++++++++++++++++++++++++++----------------------
 common.h   |   28 +++++++++++----
 domain.c   |   63 ++++++++++++++++++++--------------
 file.c     |  110 ++++++++++++++++++++++++++++++++++++++++++-------------------
 realpath.c |    8 ++--
 tomoyo.c   |   20 +++++++++--
 6 files changed, 207 insertions(+), 112 deletions(-)

diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
index 6c60616..f01b936 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -365,10 +365,9 @@ bool tomoyo_is_domain_def(const unsigned char *buffer)
  *
  * @domainname: The domainname to find.
  *
- * Caller must call down_read(&tomoyo_domain_list_lock); or
- * down_write(&tomoyo_domain_list_lock); .
- *
  * Returns pointer to "struct tomoyo_domain_info" if found, NULL otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 struct tomoyo_domain_info *tomoyo_find_domain(const char *domainname)
 {
@@ -377,7 +376,7 @@ struct tomoyo_domain_info *tomoyo_find_domain(const char *domainname)
 
 	name.name = domainname;
 	tomoyo_fill_path_info(&name);
-	list_for_each_entry(domain, &tomoyo_domain_list, list) {
+	list_for_each_entry_rcu(domain, &tomoyo_domain_list, list) {
 		if (!domain->is_deleted &&
 		    !tomoyo_pathcmp(&name, domain->domainname))
 			return domain;
@@ -829,6 +828,8 @@ bool tomoyo_verbose_mode(const struct tomoyo_domain_info *domain)
  * @domain: Pointer to "struct tomoyo_domain_info".
  *
  * Returns true if the domain is not exceeded quota, false otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 bool tomoyo_domain_quota_is_ok(struct tomoyo_domain_info * const domain)
 {
@@ -837,8 +838,7 @@ bool tomoyo_domain_quota_is_ok(struct tomoyo_domain_info * const domain)
 
 	if (!domain)
 		return true;
-	down_read(&tomoyo_domain_acl_info_list_lock);
-	list_for_each_entry(ptr, &domain->acl_info_list, list) {
+	list_for_each_entry_rcu(ptr, &domain->acl_info_list, list) {
 		if (ptr->type & TOMOYO_ACL_DELETED)
 			continue;
 		switch (tomoyo_acl_type2(ptr)) {
@@ -866,7 +866,6 @@ bool tomoyo_domain_quota_is_ok(struct tomoyo_domain_info * const domain)
 			break;
 		}
 	}
-	up_read(&tomoyo_domain_acl_info_list_lock);
 	if (count < tomoyo_check_flags(domain, TOMOYO_MAX_ACCEPT_ENTRY))
 		return true;
 	if (!domain->quota_warned) {
@@ -1096,6 +1095,8 @@ static DECLARE_RWSEM(tomoyo_policy_manager_list_lock);
  * @is_delete: True if it is a delete request.
  *
  * Returns 0 on success, negative value otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_update_manager_entry(const char *manager,
 				       const bool is_delete)
@@ -1118,7 +1119,7 @@ static int tomoyo_update_manager_entry(const char *manager,
 	if (!saved_manager)
 		return -ENOMEM;
 	down_write(&tomoyo_policy_manager_list_lock);
-	list_for_each_entry(ptr, &tomoyo_policy_manager_list, list) {
+	list_for_each_entry_rcu(ptr, &tomoyo_policy_manager_list, list) {
 		if (ptr->manager != saved_manager)
 			continue;
 		ptr->is_deleted = is_delete;
@@ -1134,7 +1135,7 @@ static int tomoyo_update_manager_entry(const char *manager,
 		goto out;
 	new_entry->manager = saved_manager;
 	new_entry->is_domain = is_domain;
-	list_add_tail(&new_entry->list, &tomoyo_policy_manager_list);
+	list_add_tail_rcu(&new_entry->list, &tomoyo_policy_manager_list);
 	error = 0;
  out:
 	up_write(&tomoyo_policy_manager_list_lock);
@@ -1147,6 +1148,8 @@ static int tomoyo_update_manager_entry(const char *manager,
  * @head: Pointer to "struct tomoyo_io_buffer".
  *
  * Returns 0 on success, negative value otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_write_manager_policy(struct tomoyo_io_buffer *head)
 {
@@ -1166,6 +1169,8 @@ static int tomoyo_write_manager_policy(struct tomoyo_io_buffer *head)
  * @head: Pointer to "struct tomoyo_io_buffer".
  *
  * Returns 0.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_read_manager_policy(struct tomoyo_io_buffer *head)
 {
@@ -1174,7 +1179,6 @@ static int tomoyo_read_manager_policy(struct tomoyo_io_buffer *head)
 
 	if (head->read_eof)
 		return 0;
-	down_read(&tomoyo_policy_manager_list_lock);
 	list_for_each_cookie(pos, head->read_var2,
 			     &tomoyo_policy_manager_list) {
 		struct tomoyo_policy_manager_entry *ptr;
@@ -1186,7 +1190,6 @@ static int tomoyo_read_manager_policy(struct tomoyo_io_buffer *head)
 		if (!done)
 			break;
 	}
-	up_read(&tomoyo_policy_manager_list_lock);
 	head->read_eof = done;
 	return 0;
 }
@@ -1196,6 +1199,8 @@ static int tomoyo_read_manager_policy(struct tomoyo_io_buffer *head)
  *
  * Returns true if the current process is permitted to modify policy
  * via /sys/kernel/security/tomoyo/ interface.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static bool tomoyo_is_policy_manager(void)
 {
@@ -1209,29 +1214,25 @@ static bool tomoyo_is_policy_manager(void)
 		return true;
 	if (!tomoyo_manage_by_non_root && (task->cred->uid || task->cred->euid))
 		return false;
-	down_read(&tomoyo_policy_manager_list_lock);
-	list_for_each_entry(ptr, &tomoyo_policy_manager_list, list) {
+	list_for_each_entry_rcu(ptr, &tomoyo_policy_manager_list, list) {
 		if (!ptr->is_deleted && ptr->is_domain
 		    && !tomoyo_pathcmp(domainname, ptr->manager)) {
 			found = true;
 			break;
 		}
 	}
-	up_read(&tomoyo_policy_manager_list_lock);
 	if (found)
 		return true;
 	exe = tomoyo_get_exe();
 	if (!exe)
 		return false;
-	down_read(&tomoyo_policy_manager_list_lock);
-	list_for_each_entry(ptr, &tomoyo_policy_manager_list, list) {
+	list_for_each_entry_rcu(ptr, &tomoyo_policy_manager_list, list) {
 		if (!ptr->is_deleted && !ptr->is_domain
 		    && !strcmp(exe, ptr->manager->name)) {
 			found = true;
 			break;
 		}
 	}
-	up_read(&tomoyo_policy_manager_list_lock);
 	if (!found) { /* Reduce error messages. */
 		static pid_t last_pid;
 		const pid_t pid = current->pid;
@@ -1252,6 +1253,8 @@ static bool tomoyo_is_policy_manager(void)
  * @data: String to parse.
  *
  * Returns true on success, false otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static bool tomoyo_is_select_one(struct tomoyo_io_buffer *head,
 				 const char *data)
@@ -1267,11 +1270,8 @@ static bool tomoyo_is_select_one(struct tomoyo_io_buffer *head,
 			domain = tomoyo_real_domain(p);
 		read_unlock(&tasklist_lock);
 	} else if (!strncmp(data, "domain=", 7)) {
-		if (tomoyo_is_domain_def(data + 7)) {
-			down_read(&tomoyo_domain_list_lock);
+		if (tomoyo_is_domain_def(data + 7))
 			domain = tomoyo_find_domain(data + 7);
-			up_read(&tomoyo_domain_list_lock);
-		}
 	} else
 		return false;
 	head->write_var1 = domain;
@@ -1285,13 +1285,11 @@ static bool tomoyo_is_select_one(struct tomoyo_io_buffer *head,
 	if (domain) {
 		struct tomoyo_domain_info *d;
 		head->read_var1 = NULL;
-		down_read(&tomoyo_domain_list_lock);
-		list_for_each_entry(d, &tomoyo_domain_list, list) {
+		list_for_each_entry_rcu(d, &tomoyo_domain_list, list) {
 			if (d == domain)
 				break;
 			head->read_var1 = &d->list;
 		}
-		up_read(&tomoyo_domain_list_lock);
 		head->read_var2 = NULL;
 		head->read_bit = 0;
 		head->read_step = 0;
@@ -1307,6 +1305,8 @@ static bool tomoyo_is_select_one(struct tomoyo_io_buffer *head,
  * @domainname: The name of domain.
  *
  * Returns 0.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_delete_domain(char *domainname)
 {
@@ -1317,7 +1317,7 @@ static int tomoyo_delete_domain(char *domainname)
 	tomoyo_fill_path_info(&name);
 	down_write(&tomoyo_domain_list_lock);
 	/* Is there an active domain? */
-	list_for_each_entry(domain, &tomoyo_domain_list, list) {
+	list_for_each_entry_rcu(domain, &tomoyo_domain_list, list) {
 		/* Never delete tomoyo_kernel_domain */
 		if (domain == &tomoyo_kernel_domain)
 			continue;
@@ -1337,6 +1337,8 @@ static int tomoyo_delete_domain(char *domainname)
  * @head: Pointer to "struct tomoyo_io_buffer".
  *
  * Returns 0 on success, negative value otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_write_domain_policy(struct tomoyo_io_buffer *head)
 {
@@ -1359,11 +1361,9 @@ static int tomoyo_write_domain_policy(struct tomoyo_io_buffer *head)
 		domain = NULL;
 		if (is_delete)
 			tomoyo_delete_domain(data);
-		else if (is_select) {
-			down_read(&tomoyo_domain_list_lock);
+		else if (is_select)
 			domain = tomoyo_find_domain(data);
-			up_read(&tomoyo_domain_list_lock);
-		} else
+		else
 			domain = tomoyo_find_or_assign_new_domain(data, 0);
 		head->write_var1 = domain;
 		return 0;
@@ -1508,6 +1508,8 @@ static bool tomoyo_print_entry(struct tomoyo_io_buffer *head,
  * @head: Pointer to "struct tomoyo_io_buffer".
  *
  * Returns 0.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_read_domain_policy(struct tomoyo_io_buffer *head)
 {
@@ -1519,7 +1521,6 @@ static int tomoyo_read_domain_policy(struct tomoyo_io_buffer *head)
 		return 0;
 	if (head->read_step == 0)
 		head->read_step = 1;
-	down_read(&tomoyo_domain_list_lock);
 	list_for_each_cookie(dpos, head->read_var1, &tomoyo_domain_list) {
 		struct tomoyo_domain_info *domain;
 		const char *quota_exceeded = "";
@@ -1552,7 +1553,6 @@ acl_loop:
 		if (head->read_step == 3)
 			goto tail_mark;
 		/* Print ACL entries in the domain. */
-		down_read(&tomoyo_domain_acl_info_list_lock);
 		list_for_each_cookie(apos, head->read_var2,
 				     &domain->acl_info_list) {
 			struct tomoyo_acl_info *ptr
@@ -1562,7 +1562,6 @@ acl_loop:
 			if (!done)
 				break;
 		}
-		up_read(&tomoyo_domain_acl_info_list_lock);
 		if (!done)
 			break;
 		head->read_step = 3;
@@ -1574,7 +1573,6 @@ tail_mark:
 		if (head->read_single_domain)
 			break;
 	}
-	up_read(&tomoyo_domain_list_lock);
 	head->read_eof = done;
 	return 0;
 }
@@ -1590,6 +1588,8 @@ tail_mark:
  *
  *     ( echo "select " $domainname; echo "use_profile " $profile ) |
  *     /usr/lib/ccs/loadpolicy -d
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_write_domain_profile(struct tomoyo_io_buffer *head)
 {
@@ -1601,9 +1601,7 @@ static int tomoyo_write_domain_profile(struct tomoyo_io_buffer *head)
 	if (!cp)
 		return -EINVAL;
 	*cp = '\0';
-	down_read(&tomoyo_domain_list_lock);
 	domain = tomoyo_find_domain(cp + 1);
-	up_read(&tomoyo_domain_list_lock);
 	if (strict_strtoul(data, 10, &profile))
 		return -EINVAL;
 	if (domain && profile < TOMOYO_MAX_PROFILES
@@ -1625,6 +1623,8 @@ static int tomoyo_write_domain_profile(struct tomoyo_io_buffer *head)
  *     awk ' { if ( domainname == "" ) { if ( $1 == "<kernel>" )
  *     domainname = $0; } else if ( $1 == "use_profile" ) {
  *     print $2 " " domainname; domainname = ""; } } ; '
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_read_domain_profile(struct tomoyo_io_buffer *head)
 {
@@ -1633,7 +1633,6 @@ static int tomoyo_read_domain_profile(struct tomoyo_io_buffer *head)
 
 	if (head->read_eof)
 		return 0;
-	down_read(&tomoyo_domain_list_lock);
 	list_for_each_cookie(pos, head->read_var1, &tomoyo_domain_list) {
 		struct tomoyo_domain_info *domain;
 		domain = list_entry(pos, struct tomoyo_domain_info, list);
@@ -1644,7 +1643,6 @@ static int tomoyo_read_domain_profile(struct tomoyo_io_buffer *head)
 		if (!done)
 			break;
 	}
-	up_read(&tomoyo_domain_list_lock);
 	head->read_eof = done;
 	return 0;
 }
@@ -1701,6 +1699,8 @@ static int tomoyo_read_pid(struct tomoyo_io_buffer *head)
  * @head: Pointer to "struct tomoyo_io_buffer".
  *
  * Returns 0 on success, negative value otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_write_exception_policy(struct tomoyo_io_buffer *head)
 {
@@ -1735,6 +1735,8 @@ static int tomoyo_write_exception_policy(struct tomoyo_io_buffer *head)
  * @head: Pointer to "struct tomoyo_io_buffer".
  *
  * Returns 0 on success, -EINVAL otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_read_exception_policy(struct tomoyo_io_buffer *head)
 {
@@ -1864,15 +1866,13 @@ void tomoyo_load_policy(const char *filename)
 	tomoyo_policy_loaded = true;
 	{ /* Check all profiles currently assigned to domains are defined. */
 		struct tomoyo_domain_info *domain;
-		down_read(&tomoyo_domain_list_lock);
-		list_for_each_entry(domain, &tomoyo_domain_list, list) {
+		list_for_each_entry_rcu(domain, &tomoyo_domain_list, list) {
 			const u8 profile = domain->profile;
 			if (tomoyo_profile_ptr[profile])
 				continue;
 			panic("Profile %u (used by '%s') not defined.\n",
 			      profile, domain->domainname->name);
 		}
-		up_read(&tomoyo_domain_list_lock);
 	}
 }
 
@@ -1920,6 +1920,8 @@ static int tomoyo_read_self_domain(struct tomoyo_io_buffer *head)
  * @file: Pointer to "struct file".
  *
  * Associates policy handler and returns 0 on success, -ENOMEM otherwise.
+ *
+ * Caller acquires tomoyo_read_lock().
  */
 static int tomoyo_open_control(const u8 type, struct file *file)
 {
@@ -2005,6 +2007,7 @@ static int tomoyo_open_control(const u8 type, struct file *file)
 			return -ENOMEM;
 		}
 	}
+	head->reader_idx = tomoyo_read_lock();
 	file->private_data = head;
 	/*
 	 * Call the handler now if the file is
@@ -2026,6 +2029,8 @@ static int tomoyo_open_control(const u8 type, struct file *file)
  * @buffer_len: Size of @buffer.
  *
  * Returns bytes read on success, negative value otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_read_control(struct file *file, char __user *buffer,
 			       const int buffer_len)
@@ -2069,6 +2074,8 @@ static int tomoyo_read_control(struct file *file, char __user *buffer,
  * @buffer_len: Size of @buffer.
  *
  * Returns @buffer_len on success, negative value otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_write_control(struct file *file, const char __user *buffer,
 				const int buffer_len)
@@ -2119,11 +2126,14 @@ static int tomoyo_write_control(struct file *file, const char __user *buffer,
  * @file: Pointer to "struct file".
  *
  * Releases memory and returns 0.
+ *
+ * Caller looses tomoyo_read_lock().
  */
 static int tomoyo_close_control(struct file *file)
 {
 	struct tomoyo_io_buffer *head = file->private_data;
 
+	tomoyo_read_unlock(head->reader_idx);
 	/* Release memory used for policy I/O. */
 	tomoyo_free(head->read_buf);
 	head->read_buf = NULL;
diff --git a/security/tomoyo/common.h b/security/tomoyo/common.h
index bd10f9f..c6f1392 100644
--- a/security/tomoyo/common.h
+++ b/security/tomoyo/common.h
@@ -269,6 +269,8 @@ struct tomoyo_io_buffer {
 	int (*write) (struct tomoyo_io_buffer *);
 	/* Exclusive lock for this structure.   */
 	struct mutex io_sem;
+	/* Index returned by tomoyo_read_lock(). */
+	int reader_idx;
 	/* The position currently reading from. */
 	struct list_head *read_var1;
 	/* Extra variables for reading.         */
@@ -446,16 +448,28 @@ extern struct tomoyo_domain_info tomoyo_kernel_domain;
  * @cookie:     the &struct list_head to use as a cookie.
  * @head:       the head for your list.
  *
- * Same with list_for_each() except that this primitive uses @cookie
+ * Same with list_for_each_rcu() except that this primitive uses @cookie
  * so that we can continue iteration.
  * @cookie must be NULL when iteration starts, and @cookie will become
  * NULL when iteration finishes.
  */
-#define list_for_each_cookie(pos, cookie, head)                       \
-	for (({ if (!cookie)                                          \
-				     cookie = head; }),               \
-	     pos = (cookie)->next;                                    \
-	     prefetch(pos->next), pos != (head) || ((cookie) = NULL); \
-	     (cookie) = pos, pos = pos->next)
+#define list_for_each_cookie(pos, cookie, head)				\
+	for (({ if (!cookie)						\
+				     cookie = head; }),			\
+		     pos = rcu_dereference((cookie)->next);		\
+	     prefetch(pos->next), pos != (head) || ((cookie) = NULL);	\
+	     (cookie) = pos, pos = rcu_dereference(pos->next))
+
+extern struct srcu_struct tomoyo_ss;
+
+static inline int tomoyo_read_lock(void)
+{
+	return srcu_read_lock(&tomoyo_ss);
+}
+
+static inline void tomoyo_read_unlock(int idx)
+{
+	srcu_read_unlock(&tomoyo_ss, idx);
+}
 
 #endif /* !defined(_SECURITY_TOMOYO_COMMON_H) */
diff --git a/security/tomoyo/domain.c b/security/tomoyo/domain.c
index fcf52ac..2fd1901 100644
--- a/security/tomoyo/domain.c
+++ b/security/tomoyo/domain.c
@@ -217,6 +217,8 @@ static DECLARE_RWSEM(tomoyo_domain_initializer_list_lock);
  * @is_delete:  True if it is a delete request.
  *
  * Returns 0 on success, negative value otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_update_domain_initializer_entry(const char *domainname,
 						  const char *program,
@@ -246,7 +248,7 @@ static int tomoyo_update_domain_initializer_entry(const char *domainname,
 	if (!saved_program)
 		return -ENOMEM;
 	down_write(&tomoyo_domain_initializer_list_lock);
-	list_for_each_entry(ptr, &tomoyo_domain_initializer_list, list) {
+	list_for_each_entry_rcu(ptr, &tomoyo_domain_initializer_list, list) {
 		if (ptr->is_not != is_not ||
 		    ptr->domainname != saved_domainname ||
 		    ptr->program != saved_program)
@@ -266,7 +268,7 @@ static int tomoyo_update_domain_initializer_entry(const char *domainname,
 	new_entry->program = saved_program;
 	new_entry->is_not = is_not;
 	new_entry->is_last_name = is_last_name;
-	list_add_tail(&new_entry->list, &tomoyo_domain_initializer_list);
+	list_add_tail_rcu(&new_entry->list, &tomoyo_domain_initializer_list);
 	error = 0;
  out:
 	up_write(&tomoyo_domain_initializer_list_lock);
@@ -279,13 +281,14 @@ static int tomoyo_update_domain_initializer_entry(const char *domainname,
  * @head: Pointer to "struct tomoyo_io_buffer".
  *
  * Returns true on success, false otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 bool tomoyo_read_domain_initializer_policy(struct tomoyo_io_buffer *head)
 {
 	struct list_head *pos;
 	bool done = true;
 
-	down_read(&tomoyo_domain_initializer_list_lock);
 	list_for_each_cookie(pos, head->read_var2,
 			     &tomoyo_domain_initializer_list) {
 		const char *no;
@@ -308,7 +311,6 @@ bool tomoyo_read_domain_initializer_policy(struct tomoyo_io_buffer *head)
 		if (!done)
 			break;
 	}
-	up_read(&tomoyo_domain_initializer_list_lock);
 	return done;
 }
 
@@ -320,6 +322,8 @@ bool tomoyo_read_domain_initializer_policy(struct tomoyo_io_buffer *head)
  * @is_delete: True if it is a delete request.
  *
  * Returns 0 on success, negative value otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 int tomoyo_write_domain_initializer_policy(char *data, const bool is_not,
 					   const bool is_delete)
@@ -345,6 +349,8 @@ int tomoyo_write_domain_initializer_policy(char *data, const bool is_not,
  *
  * Returns true if executing @program reinitializes domain transition,
  * false otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static bool tomoyo_is_domain_initializer(const struct tomoyo_path_info *
 					 domainname,
@@ -355,8 +361,7 @@ static bool tomoyo_is_domain_initializer(const struct tomoyo_path_info *
 	struct tomoyo_domain_initializer_entry *ptr;
 	bool flag = false;
 
-	down_read(&tomoyo_domain_initializer_list_lock);
-	list_for_each_entry(ptr,  &tomoyo_domain_initializer_list, list) {
+	list_for_each_entry_rcu(ptr, &tomoyo_domain_initializer_list, list) {
 		if (ptr->is_deleted)
 			continue;
 		if (ptr->domainname) {
@@ -376,7 +381,6 @@ static bool tomoyo_is_domain_initializer(const struct tomoyo_path_info *
 		}
 		flag = true;
 	}
-	up_read(&tomoyo_domain_initializer_list_lock);
 	return flag;
 }
 
@@ -430,6 +434,8 @@ static DECLARE_RWSEM(tomoyo_domain_keeper_list_lock);
  * @is_delete:  True if it is a delete request.
  *
  * Returns 0 on success, negative value otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_update_domain_keeper_entry(const char *domainname,
 					     const char *program,
@@ -459,7 +465,7 @@ static int tomoyo_update_domain_keeper_entry(const char *domainname,
 	if (!saved_domainname)
 		return -ENOMEM;
 	down_write(&tomoyo_domain_keeper_list_lock);
-	list_for_each_entry(ptr, &tomoyo_domain_keeper_list, list) {
+	list_for_each_entry_rcu(ptr, &tomoyo_domain_keeper_list, list) {
 		if (ptr->is_not != is_not ||
 		    ptr->domainname != saved_domainname ||
 		    ptr->program != saved_program)
@@ -479,7 +485,7 @@ static int tomoyo_update_domain_keeper_entry(const char *domainname,
 	new_entry->program = saved_program;
 	new_entry->is_not = is_not;
 	new_entry->is_last_name = is_last_name;
-	list_add_tail(&new_entry->list, &tomoyo_domain_keeper_list);
+	list_add_tail_rcu(&new_entry->list, &tomoyo_domain_keeper_list);
 	error = 0;
  out:
 	up_write(&tomoyo_domain_keeper_list_lock);
@@ -493,6 +499,7 @@ static int tomoyo_update_domain_keeper_entry(const char *domainname,
  * @is_not:    True if it is "no_keep_domain" entry.
  * @is_delete: True if it is a delete request.
  *
+ * Caller holds tomoyo_read_lock().
  */
 int tomoyo_write_domain_keeper_policy(char *data, const bool is_not,
 				      const bool is_delete)
@@ -513,13 +520,14 @@ int tomoyo_write_domain_keeper_policy(char *data, const bool is_not,
  * @head: Pointer to "struct tomoyo_io_buffer".
  *
  * Returns true on success, false otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 bool tomoyo_read_domain_keeper_policy(struct tomoyo_io_buffer *head)
 {
 	struct list_head *pos;
 	bool done = true;
 
-	down_read(&tomoyo_domain_keeper_list_lock);
 	list_for_each_cookie(pos, head->read_var2,
 			     &tomoyo_domain_keeper_list) {
 		struct tomoyo_domain_keeper_entry *ptr;
@@ -542,7 +550,6 @@ bool tomoyo_read_domain_keeper_policy(struct tomoyo_io_buffer *head)
 		if (!done)
 			break;
 	}
-	up_read(&tomoyo_domain_keeper_list_lock);
 	return done;
 }
 
@@ -555,6 +562,8 @@ bool tomoyo_read_domain_keeper_policy(struct tomoyo_io_buffer *head)
  *
  * Returns true if executing @program supresses domain transition,
  * false otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static bool tomoyo_is_domain_keeper(const struct tomoyo_path_info *domainname,
 				    const struct tomoyo_path_info *program,
@@ -563,8 +572,7 @@ static bool tomoyo_is_domain_keeper(const struct tomoyo_path_info *domainname,
 	struct tomoyo_domain_keeper_entry *ptr;
 	bool flag = false;
 
-	down_read(&tomoyo_domain_keeper_list_lock);
-	list_for_each_entry(ptr, &tomoyo_domain_keeper_list, list) {
+	list_for_each_entry_rcu(ptr, &tomoyo_domain_keeper_list, list) {
 		if (ptr->is_deleted)
 			continue;
 		if (!ptr->is_last_name) {
@@ -582,7 +590,6 @@ static bool tomoyo_is_domain_keeper(const struct tomoyo_path_info *domainname,
 		}
 		flag = true;
 	}
-	up_read(&tomoyo_domain_keeper_list_lock);
 	return flag;
 }
 
@@ -627,6 +634,8 @@ static DECLARE_RWSEM(tomoyo_alias_list_lock);
  * @is_delete:     True if it is a delete request.
  *
  * Returns 0 on success, negative value otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_update_alias_entry(const char *original_name,
 				     const char *aliased_name,
@@ -646,7 +655,7 @@ static int tomoyo_update_alias_entry(const char *original_name,
 	if (!saved_original_name || !saved_aliased_name)
 		return -ENOMEM;
 	down_write(&tomoyo_alias_list_lock);
-	list_for_each_entry(ptr, &tomoyo_alias_list, list) {
+	list_for_each_entry_rcu(ptr, &tomoyo_alias_list, list) {
 		if (ptr->original_name != saved_original_name ||
 		    ptr->aliased_name != saved_aliased_name)
 			continue;
@@ -663,7 +672,7 @@ static int tomoyo_update_alias_entry(const char *original_name,
 		goto out;
 	new_entry->original_name = saved_original_name;
 	new_entry->aliased_name = saved_aliased_name;
-	list_add_tail(&new_entry->list, &tomoyo_alias_list);
+	list_add_tail_rcu(&new_entry->list, &tomoyo_alias_list);
 	error = 0;
  out:
 	up_write(&tomoyo_alias_list_lock);
@@ -676,13 +685,14 @@ static int tomoyo_update_alias_entry(const char *original_name,
  * @head: Pointer to "struct tomoyo_io_buffer".
  *
  * Returns true on success, false otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 bool tomoyo_read_alias_policy(struct tomoyo_io_buffer *head)
 {
 	struct list_head *pos;
 	bool done = true;
 
-	down_read(&tomoyo_alias_list_lock);
 	list_for_each_cookie(pos, head->read_var2, &tomoyo_alias_list) {
 		struct tomoyo_alias_entry *ptr;
 
@@ -695,7 +705,6 @@ bool tomoyo_read_alias_policy(struct tomoyo_io_buffer *head)
 		if (!done)
 			break;
 	}
-	up_read(&tomoyo_alias_list_lock);
 	return done;
 }
 
@@ -706,6 +715,8 @@ bool tomoyo_read_alias_policy(struct tomoyo_io_buffer *head)
  * @is_delete: True if it is a delete request.
  *
  * Returns 0 on success, negative value otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 int tomoyo_write_alias_policy(char *data, const bool is_delete)
 {
@@ -724,6 +735,8 @@ int tomoyo_write_alias_policy(char *data, const bool is_delete)
  * @profile:    Profile number to assign if the domain was newly created.
  *
  * Returns pointer to "struct tomoyo_domain_info" on success, NULL otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 struct tomoyo_domain_info *tomoyo_find_or_assign_new_domain(const char *
 							    domainname,
@@ -742,7 +755,7 @@ struct tomoyo_domain_info *tomoyo_find_or_assign_new_domain(const char *
 	if (!saved_domainname)
 		goto out;
 	/* Can I reuse memory of deleted domain? */
-	list_for_each_entry(domain, &tomoyo_domain_list, list) {
+	list_for_each_entry_rcu(domain, &tomoyo_domain_list, list) {
 		struct task_struct *p;
 		struct tomoyo_acl_info *ptr;
 		bool flag;
@@ -760,7 +773,7 @@ struct tomoyo_domain_info *tomoyo_find_or_assign_new_domain(const char *
 		read_unlock(&tasklist_lock);
 		if (flag)
 			continue;
-		list_for_each_entry(ptr, &domain->acl_info_list, list) {
+		list_for_each_entry_rcu(ptr, &domain->acl_info_list, list) {
 			ptr->type |= TOMOYO_ACL_DELETED;
 		}
 		tomoyo_set_domain_flag(domain, true, domain->flags);
@@ -776,7 +789,7 @@ struct tomoyo_domain_info *tomoyo_find_or_assign_new_domain(const char *
 		INIT_LIST_HEAD(&domain->acl_info_list);
 		domain->domainname = saved_domainname;
 		domain->profile = profile;
-		list_add_tail(&domain->list, &tomoyo_domain_list);
+		list_add_tail_rcu(&domain->list, &tomoyo_domain_list);
 	}
  out:
 	up_write(&tomoyo_domain_list_lock);
@@ -789,6 +802,8 @@ struct tomoyo_domain_info *tomoyo_find_or_assign_new_domain(const char *
  * @bprm: Pointer to "struct linux_binprm".
  *
  * Returns 0 on success, negative value otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 int tomoyo_find_next_domain(struct linux_binprm *bprm)
 {
@@ -849,8 +864,7 @@ int tomoyo_find_next_domain(struct linux_binprm *bprm)
 	if (tomoyo_pathcmp(&r, &s)) {
 		struct tomoyo_alias_entry *ptr;
 		/* Is this program allowed to be called via symbolic links? */
-		down_read(&tomoyo_alias_list_lock);
-		list_for_each_entry(ptr, &tomoyo_alias_list, list) {
+		list_for_each_entry_rcu(ptr, &tomoyo_alias_list, list) {
 			if (ptr->is_deleted ||
 			    tomoyo_pathcmp(&r, ptr->original_name) ||
 			    tomoyo_pathcmp(&s, ptr->aliased_name))
@@ -861,7 +875,6 @@ int tomoyo_find_next_domain(struct linux_binprm *bprm)
 			tomoyo_fill_path_info(&r);
 			break;
 		}
-		up_read(&tomoyo_alias_list_lock);
 	}
 
 	/* Check execute permission. */
@@ -892,9 +905,7 @@ int tomoyo_find_next_domain(struct linux_binprm *bprm)
 	}
 	if (domain || strlen(new_domain_name) >= TOMOYO_MAX_PATHNAME_LEN)
 		goto done;
-	down_read(&tomoyo_domain_list_lock);
 	domain = tomoyo_find_domain(new_domain_name);
-	up_read(&tomoyo_domain_list_lock);
 	if (domain)
 		goto done;
 	if (is_enforce)
diff --git a/security/tomoyo/file.c b/security/tomoyo/file.c
index 482f0e7..3c47286 100644
--- a/security/tomoyo/file.c
+++ b/security/tomoyo/file.c
@@ -213,6 +213,8 @@ static DECLARE_RWSEM(tomoyo_globally_readable_list_lock);
  * @is_delete: True if it is a delete request.
  *
  * Returns 0 on success, negative value otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_update_globally_readable_entry(const char *filename,
 						 const bool is_delete)
@@ -228,7 +230,7 @@ static int tomoyo_update_globally_readable_entry(const char *filename,
 	if (!saved_filename)
 		return -ENOMEM;
 	down_write(&tomoyo_globally_readable_list_lock);
-	list_for_each_entry(ptr, &tomoyo_globally_readable_list, list) {
+	list_for_each_entry_rcu(ptr, &tomoyo_globally_readable_list, list) {
 		if (ptr->filename != saved_filename)
 			continue;
 		ptr->is_deleted = is_delete;
@@ -243,7 +245,7 @@ static int tomoyo_update_globally_readable_entry(const char *filename,
 	if (!new_entry)
 		goto out;
 	new_entry->filename = saved_filename;
-	list_add_tail(&new_entry->list, &tomoyo_globally_readable_list);
+	list_add_tail_rcu(&new_entry->list, &tomoyo_globally_readable_list);
 	error = 0;
  out:
 	up_write(&tomoyo_globally_readable_list_lock);
@@ -256,21 +258,22 @@ static int tomoyo_update_globally_readable_entry(const char *filename,
  * @filename: The filename to check.
  *
  * Returns true if any domain can open @filename for reading, false otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static bool tomoyo_is_globally_readable_file(const struct tomoyo_path_info *
 					     filename)
 {
 	struct tomoyo_globally_readable_file_entry *ptr;
 	bool found = false;
-	down_read(&tomoyo_globally_readable_list_lock);
-	list_for_each_entry(ptr, &tomoyo_globally_readable_list, list) {
+
+	list_for_each_entry_rcu(ptr, &tomoyo_globally_readable_list, list) {
 		if (!ptr->is_deleted &&
 		    tomoyo_path_matches_pattern(filename, ptr->filename)) {
 			found = true;
 			break;
 		}
 	}
-	up_read(&tomoyo_globally_readable_list_lock);
 	return found;
 }
 
@@ -281,6 +284,8 @@ static bool tomoyo_is_globally_readable_file(const struct tomoyo_path_info *
  * @is_delete: True if it is a delete request.
  *
  * Returns 0 on success, negative value otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 int tomoyo_write_globally_readable_policy(char *data, const bool is_delete)
 {
@@ -293,13 +298,14 @@ int tomoyo_write_globally_readable_policy(char *data, const bool is_delete)
  * @head: Pointer to "struct tomoyo_io_buffer".
  *
  * Returns true on success, false otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 bool tomoyo_read_globally_readable_policy(struct tomoyo_io_buffer *head)
 {
 	struct list_head *pos;
 	bool done = true;
 
-	down_read(&tomoyo_globally_readable_list_lock);
 	list_for_each_cookie(pos, head->read_var2,
 			     &tomoyo_globally_readable_list) {
 		struct tomoyo_globally_readable_file_entry *ptr;
@@ -313,7 +319,6 @@ bool tomoyo_read_globally_readable_policy(struct tomoyo_io_buffer *head)
 		if (!done)
 			break;
 	}
-	up_read(&tomoyo_globally_readable_list_lock);
 	return done;
 }
 
@@ -356,6 +361,8 @@ static DECLARE_RWSEM(tomoyo_pattern_list_lock);
  * @is_delete: True if it is a delete request.
  *
  * Returns 0 on success, negative value otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_update_file_pattern_entry(const char *pattern,
 					    const bool is_delete)
@@ -371,7 +378,7 @@ static int tomoyo_update_file_pattern_entry(const char *pattern,
 	if (!saved_pattern)
 		return -ENOMEM;
 	down_write(&tomoyo_pattern_list_lock);
-	list_for_each_entry(ptr, &tomoyo_pattern_list, list) {
+	list_for_each_entry_rcu(ptr, &tomoyo_pattern_list, list) {
 		if (saved_pattern != ptr->pattern)
 			continue;
 		ptr->is_deleted = is_delete;
@@ -386,7 +393,7 @@ static int tomoyo_update_file_pattern_entry(const char *pattern,
 	if (!new_entry)
 		goto out;
 	new_entry->pattern = saved_pattern;
-	list_add_tail(&new_entry->list, &tomoyo_pattern_list);
+	list_add_tail_rcu(&new_entry->list, &tomoyo_pattern_list);
 	error = 0;
  out:
 	up_write(&tomoyo_pattern_list_lock);
@@ -399,6 +406,8 @@ static int tomoyo_update_file_pattern_entry(const char *pattern,
  * @filename: The filename to find patterned pathname.
  *
  * Returns pointer to pathname pattern if matched, @filename otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static const struct tomoyo_path_info *
 tomoyo_get_file_pattern(const struct tomoyo_path_info *filename)
@@ -406,8 +415,7 @@ tomoyo_get_file_pattern(const struct tomoyo_path_info *filename)
 	struct tomoyo_pattern_entry *ptr;
 	const struct tomoyo_path_info *pattern = NULL;
 
-	down_read(&tomoyo_pattern_list_lock);
-	list_for_each_entry(ptr, &tomoyo_pattern_list, list) {
+	list_for_each_entry_rcu(ptr, &tomoyo_pattern_list, list) {
 		if (ptr->is_deleted)
 			continue;
 		if (!tomoyo_path_matches_pattern(filename, ptr->pattern))
@@ -420,7 +428,6 @@ tomoyo_get_file_pattern(const struct tomoyo_path_info *filename)
 			break;
 		}
 	}
-	up_read(&tomoyo_pattern_list_lock);
 	if (pattern)
 		filename = pattern;
 	return filename;
@@ -433,6 +440,8 @@ tomoyo_get_file_pattern(const struct tomoyo_path_info *filename)
  * @is_delete: True if it is a delete request.
  *
  * Returns 0 on success, negative value otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 int tomoyo_write_pattern_policy(char *data, const bool is_delete)
 {
@@ -445,13 +454,14 @@ int tomoyo_write_pattern_policy(char *data, const bool is_delete)
  * @head: Pointer to "struct tomoyo_io_buffer".
  *
  * Returns true on success, false otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 bool tomoyo_read_file_pattern(struct tomoyo_io_buffer *head)
 {
 	struct list_head *pos;
 	bool done = true;
 
-	down_read(&tomoyo_pattern_list_lock);
 	list_for_each_cookie(pos, head->read_var2, &tomoyo_pattern_list) {
 		struct tomoyo_pattern_entry *ptr;
 		ptr = list_entry(pos, struct tomoyo_pattern_entry, list);
@@ -462,7 +472,6 @@ bool tomoyo_read_file_pattern(struct tomoyo_io_buffer *head)
 		if (!done)
 			break;
 	}
-	up_read(&tomoyo_pattern_list_lock);
 	return done;
 }
 
@@ -505,6 +514,8 @@ static DECLARE_RWSEM(tomoyo_no_rewrite_list_lock);
  * @is_delete: True if it is a delete request.
  *
  * Returns 0 on success, negative value otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_update_no_rewrite_entry(const char *pattern,
 					  const bool is_delete)
@@ -519,7 +530,7 @@ static int tomoyo_update_no_rewrite_entry(const char *pattern,
 	if (!saved_pattern)
 		return -ENOMEM;
 	down_write(&tomoyo_no_rewrite_list_lock);
-	list_for_each_entry(ptr, &tomoyo_no_rewrite_list, list) {
+	list_for_each_entry_rcu(ptr, &tomoyo_no_rewrite_list, list) {
 		if (ptr->pattern != saved_pattern)
 			continue;
 		ptr->is_deleted = is_delete;
@@ -534,7 +545,7 @@ static int tomoyo_update_no_rewrite_entry(const char *pattern,
 	if (!new_entry)
 		goto out;
 	new_entry->pattern = saved_pattern;
-	list_add_tail(&new_entry->list, &tomoyo_no_rewrite_list);
+	list_add_tail_rcu(&new_entry->list, &tomoyo_no_rewrite_list);
 	error = 0;
  out:
 	up_write(&tomoyo_no_rewrite_list_lock);
@@ -548,14 +559,15 @@ static int tomoyo_update_no_rewrite_entry(const char *pattern,
  *
  * Returns true if @filename is specified by "deny_rewrite" directive,
  * false otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static bool tomoyo_is_no_rewrite_file(const struct tomoyo_path_info *filename)
 {
 	struct tomoyo_no_rewrite_entry *ptr;
 	bool found = false;
 
-	down_read(&tomoyo_no_rewrite_list_lock);
-	list_for_each_entry(ptr, &tomoyo_no_rewrite_list, list) {
+	list_for_each_entry_rcu(ptr, &tomoyo_no_rewrite_list, list) {
 		if (ptr->is_deleted)
 			continue;
 		if (!tomoyo_path_matches_pattern(filename, ptr->pattern))
@@ -563,7 +575,6 @@ static bool tomoyo_is_no_rewrite_file(const struct tomoyo_path_info *filename)
 		found = true;
 		break;
 	}
-	up_read(&tomoyo_no_rewrite_list_lock);
 	return found;
 }
 
@@ -574,6 +585,8 @@ static bool tomoyo_is_no_rewrite_file(const struct tomoyo_path_info *filename)
  * @is_delete: True if it is a delete request.
  *
  * Returns 0 on success, negative value otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 int tomoyo_write_no_rewrite_policy(char *data, const bool is_delete)
 {
@@ -586,13 +599,14 @@ int tomoyo_write_no_rewrite_policy(char *data, const bool is_delete)
  * @head: Pointer to "struct tomoyo_io_buffer".
  *
  * Returns true on success, false otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 bool tomoyo_read_no_rewrite_policy(struct tomoyo_io_buffer *head)
 {
 	struct list_head *pos;
 	bool done = true;
 
-	down_read(&tomoyo_no_rewrite_list_lock);
 	list_for_each_cookie(pos, head->read_var2, &tomoyo_no_rewrite_list) {
 		struct tomoyo_no_rewrite_entry *ptr;
 		ptr = list_entry(pos, struct tomoyo_no_rewrite_entry, list);
@@ -603,7 +617,6 @@ bool tomoyo_read_no_rewrite_policy(struct tomoyo_io_buffer *head)
 		if (!done)
 			break;
 	}
-	up_read(&tomoyo_no_rewrite_list_lock);
 	return done;
 }
 
@@ -621,6 +634,8 @@ bool tomoyo_read_no_rewrite_policy(struct tomoyo_io_buffer *head)
  * Current policy syntax uses "allow_read/write" instead of "6",
  * "allow_read" instead of "4", "allow_write" instead of "2",
  * "allow_execute" instead of "1".
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_update_file_acl(const char *filename, u8 perm,
 				  struct tomoyo_domain_info * const domain,
@@ -658,6 +673,8 @@ static int tomoyo_update_file_acl(const char *filename, u8 perm,
  * @may_use_pattern: True if patterned ACL is permitted.
  *
  * Returns 0 on success, -EPERM otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_check_single_path_acl2(const struct tomoyo_domain_info *
 					 domain,
@@ -669,8 +686,7 @@ static int tomoyo_check_single_path_acl2(const struct tomoyo_domain_info *
 	struct tomoyo_acl_info *ptr;
 	int error = -EPERM;
 
-	down_read(&tomoyo_domain_acl_info_list_lock);
-	list_for_each_entry(ptr, &domain->acl_info_list, list) {
+	list_for_each_entry_rcu(ptr, &domain->acl_info_list, list) {
 		struct tomoyo_single_path_acl_record *acl;
 		if (tomoyo_acl_type2(ptr) != TOMOYO_TYPE_SINGLE_PATH_ACL)
 			continue;
@@ -693,7 +709,6 @@ static int tomoyo_check_single_path_acl2(const struct tomoyo_domain_info *
 		error = 0;
 		break;
 	}
-	up_read(&tomoyo_domain_acl_info_list_lock);
 	return error;
 }
 
@@ -705,6 +720,8 @@ static int tomoyo_check_single_path_acl2(const struct tomoyo_domain_info *
  * @operation: Mode ("read" or "write" or "read/write" or "execute").
  *
  * Returns 0 on success, -EPERM otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_check_file_acl(const struct tomoyo_domain_info *domain,
 				 const struct tomoyo_path_info *filename,
@@ -738,6 +755,8 @@ static int tomoyo_check_file_acl(const struct tomoyo_domain_info *domain,
  * @mode:      Access control mode.
  *
  * Returns 0 on success, negative value otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_check_file_perm2(struct tomoyo_domain_info * const domain,
 				   const struct tomoyo_path_info *filename,
@@ -791,6 +810,8 @@ static int tomoyo_check_file_perm2(struct tomoyo_domain_info * const domain,
  * @is_delete: True if it is a delete request.
  *
  * Returns 0 on success, negative value otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 int tomoyo_write_file_policy(char *data, struct tomoyo_domain_info *domain,
 			     const bool is_delete)
@@ -838,6 +859,8 @@ int tomoyo_write_file_policy(char *data, struct tomoyo_domain_info *domain,
  * @is_delete: True if it is a delete request.
  *
  * Returns 0 on success, negative value otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_update_single_path_acl(const u8 type, const char *filename,
 					 struct tomoyo_domain_info *
@@ -861,7 +884,7 @@ static int tomoyo_update_single_path_acl(const u8 type, const char *filename,
 	down_write(&tomoyo_domain_acl_info_list_lock);
 	if (is_delete)
 		goto delete;
-	list_for_each_entry(ptr, &domain->acl_info_list, list) {
+	list_for_each_entry_rcu(ptr, &domain->acl_info_list, list) {
 		if (tomoyo_acl_type1(ptr) != TOMOYO_TYPE_SINGLE_PATH_ACL)
 			continue;
 		acl = container_of(ptr, struct tomoyo_single_path_acl_record,
@@ -894,12 +917,12 @@ static int tomoyo_update_single_path_acl(const u8 type, const char *filename,
 	if (perm == (1 << TOMOYO_TYPE_READ_WRITE_ACL))
 		acl->perm |= rw_mask;
 	acl->filename = saved_filename;
-	list_add_tail(&acl->head.list, &domain->acl_info_list);
+	list_add_tail_rcu(&acl->head.list, &domain->acl_info_list);
 	error = 0;
 	goto out;
  delete:
 	error = -ENOENT;
-	list_for_each_entry(ptr, &domain->acl_info_list, list) {
+	list_for_each_entry_rcu(ptr, &domain->acl_info_list, list) {
 		if (tomoyo_acl_type2(ptr) != TOMOYO_TYPE_SINGLE_PATH_ACL)
 			continue;
 		acl = container_of(ptr, struct tomoyo_single_path_acl_record,
@@ -934,6 +957,8 @@ static int tomoyo_update_single_path_acl(const u8 type, const char *filename,
  * @is_delete: True if it is a delete request.
  *
  * Returns 0 on success, negative value otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_update_double_path_acl(const u8 type, const char *filename1,
 					 const char *filename2,
@@ -959,7 +984,7 @@ static int tomoyo_update_double_path_acl(const u8 type, const char *filename1,
 	down_write(&tomoyo_domain_acl_info_list_lock);
 	if (is_delete)
 		goto delete;
-	list_for_each_entry(ptr, &domain->acl_info_list, list) {
+	list_for_each_entry_rcu(ptr, &domain->acl_info_list, list) {
 		if (tomoyo_acl_type1(ptr) != TOMOYO_TYPE_DOUBLE_PATH_ACL)
 			continue;
 		acl = container_of(ptr, struct tomoyo_double_path_acl_record,
@@ -982,12 +1007,12 @@ static int tomoyo_update_double_path_acl(const u8 type, const char *filename1,
 	acl->perm = perm;
 	acl->filename1 = saved_filename1;
 	acl->filename2 = saved_filename2;
-	list_add_tail(&acl->head.list, &domain->acl_info_list);
+	list_add_tail_rcu(&acl->head.list, &domain->acl_info_list);
 	error = 0;
 	goto out;
  delete:
 	error = -ENOENT;
-	list_for_each_entry(ptr, &domain->acl_info_list, list) {
+	list_for_each_entry_rcu(ptr, &domain->acl_info_list, list) {
 		if (tomoyo_acl_type2(ptr) != TOMOYO_TYPE_DOUBLE_PATH_ACL)
 			continue;
 		acl = container_of(ptr, struct tomoyo_double_path_acl_record,
@@ -1014,6 +1039,8 @@ static int tomoyo_update_double_path_acl(const u8 type, const char *filename1,
  * @filename: Filename to check.
  *
  * Returns 0 on success, negative value otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_check_single_path_acl(struct tomoyo_domain_info *domain,
 					const u8 type,
@@ -1033,6 +1060,8 @@ static int tomoyo_check_single_path_acl(struct tomoyo_domain_info *domain,
  * @filename2: Second filename to check.
  *
  * Returns 0 on success, -EPERM otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_check_double_path_acl(const struct tomoyo_domain_info *domain,
 					const u8 type,
@@ -1047,8 +1076,7 @@ static int tomoyo_check_double_path_acl(const struct tomoyo_domain_info *domain,
 
 	if (!tomoyo_check_flags(domain, TOMOYO_MAC_FOR_FILE))
 		return 0;
-	down_read(&tomoyo_domain_acl_info_list_lock);
-	list_for_each_entry(ptr, &domain->acl_info_list, list) {
+	list_for_each_entry_rcu(ptr, &domain->acl_info_list, list) {
 		struct tomoyo_double_path_acl_record *acl;
 		if (tomoyo_acl_type2(ptr) != TOMOYO_TYPE_DOUBLE_PATH_ACL)
 			continue;
@@ -1063,7 +1091,6 @@ static int tomoyo_check_double_path_acl(const struct tomoyo_domain_info *domain,
 		error = 0;
 		break;
 	}
-	up_read(&tomoyo_domain_acl_info_list_lock);
 	return error;
 }
 
@@ -1076,6 +1103,8 @@ static int tomoyo_check_double_path_acl(const struct tomoyo_domain_info *domain,
  * @mode:      Access control mode.
  *
  * Returns 0 on success, negative value otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 static int tomoyo_check_single_path_permission2(struct tomoyo_domain_info *
 						const domain, u8 operation,
@@ -1124,6 +1153,8 @@ static int tomoyo_check_single_path_permission2(struct tomoyo_domain_info *
  * @filename: Check permission for "execute".
  *
  * Returns 0 on success, negativevalue otherwise.
+ *
+ * Caller holds tomoyo_read_lock().
  */
 int tomoyo_check_exec_perm(struct tomoyo_domain_info *domain,
 			   const struct tomoyo_path_info *filename)
@@ -1152,6 +1183,7 @@ int tomoyo_check_open_permission(struct tomoyo_domain_info *domain,
 	struct tomoyo_path_info *buf;
 	const u8 mode = tomoyo_check_flags(domain, TOMOYO_MAC_FOR_FILE);
 	const bool is_enforce = (mode == 3);
+	int idx;
 
 	if (!mode || !path->mnt)
 		return 0;
@@ -1163,6 +1195,7 @@ int tomoyo_check_open_permission(struct tomoyo_domain_info *domain,
 		 * don't call me.
 		 */
 		return 0;
+	idx = tomoyo_read_lock();
 	buf = tomoyo_get_path(path);
 	if (!buf)
 		goto out;
@@ -1188,6 +1221,7 @@ int tomoyo_check_open_permission(struct tomoyo_domain_info *domain,
 							     buf, mode);
  out:
 	tomoyo_free(buf);
+	tomoyo_read_unlock(idx);
 	if (!is_enforce)
 		error = 0;
 	return error;
@@ -1209,9 +1243,11 @@ int tomoyo_check_1path_perm(struct tomoyo_domain_info *domain,
 	struct tomoyo_path_info *buf;
 	const u8 mode = tomoyo_check_flags(domain, TOMOYO_MAC_FOR_FILE);
 	const bool is_enforce = (mode == 3);
+	int idx;
 
 	if (!mode || !path->mnt)
 		return 0;
+	idx = tomoyo_read_lock();
 	buf = tomoyo_get_path(path);
 	if (!buf)
 		goto out;
@@ -1231,6 +1267,7 @@ int tomoyo_check_1path_perm(struct tomoyo_domain_info *domain,
 						     mode);
  out:
 	tomoyo_free(buf);
+	tomoyo_read_unlock(idx);
 	if (!is_enforce)
 		error = 0;
 	return error;
@@ -1251,9 +1288,12 @@ int tomoyo_check_rewrite_permission(struct tomoyo_domain_info *domain,
 	const u8 mode = tomoyo_check_flags(domain, TOMOYO_MAC_FOR_FILE);
 	const bool is_enforce = (mode == 3);
 	struct tomoyo_path_info *buf;
+	int idx;
 
 	if (!mode || !filp->f_path.mnt)
 		return 0;
+
+	idx = tomoyo_read_lock();
 	buf = tomoyo_get_path(&filp->f_path);
 	if (!buf)
 		goto out;
@@ -1266,6 +1306,7 @@ int tomoyo_check_rewrite_permission(struct tomoyo_domain_info *domain,
 						     buf, mode);
  out:
 	tomoyo_free(buf);
+	tomoyo_read_unlock(idx);
 	if (!is_enforce)
 		error = 0;
 	return error;
@@ -1290,9 +1331,11 @@ int tomoyo_check_2path_perm(struct tomoyo_domain_info * const domain,
 	const u8 mode = tomoyo_check_flags(domain, TOMOYO_MAC_FOR_FILE);
 	const bool is_enforce = (mode == 3);
 	const char *msg;
+	int idx;
 
 	if (!mode || !path1->mnt || !path2->mnt)
 		return 0;
+	idx = tomoyo_read_lock();
 	buf1 = tomoyo_get_path(path1);
 	buf2 = tomoyo_get_path(path2);
 	if (!buf1 || !buf2)
@@ -1331,6 +1374,7 @@ int tomoyo_check_2path_perm(struct tomoyo_domain_info * const domain,
  out:
 	tomoyo_free(buf1);
 	tomoyo_free(buf2);
+	tomoyo_read_unlock(idx);
 	if (!is_enforce)
 		error = 0;
 	return error;
diff --git a/security/tomoyo/realpath.c b/security/tomoyo/realpath.c
index e3c7aa0..62363b3 100644
--- a/security/tomoyo/realpath.c
+++ b/security/tomoyo/realpath.c
@@ -402,11 +402,13 @@ void __init tomoyo_realpath_init(void)
 		INIT_LIST_HEAD(&tomoyo_name_list[i]);
 	INIT_LIST_HEAD(&tomoyo_kernel_domain.acl_info_list);
 	tomoyo_kernel_domain.domainname = tomoyo_save_name(TOMOYO_ROOT_NAME);
-	list_add_tail(&tomoyo_kernel_domain.list, &tomoyo_domain_list);
-	down_read(&tomoyo_domain_list_lock);
+	/*
+	 * tomoyo_read_lock() is not needed because this function is
+	 * called before the first "delete" request.
+	 */
+	list_add_tail_rcu(&tomoyo_kernel_domain.list, &tomoyo_domain_list);
 	if (tomoyo_find_domain(TOMOYO_ROOT_NAME) != &tomoyo_kernel_domain)
 		panic("Can't register tomoyo_kernel_domain");
-	up_read(&tomoyo_domain_list_lock);
 }
 
 /* Memory allocated for temporary purpose. */
diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
index ad9555f..714daa3 100644
--- a/security/tomoyo/tomoyo.c
+++ b/security/tomoyo/tomoyo.c
@@ -76,8 +76,18 @@ static int tomoyo_bprm_check_security(struct linux_binprm *bprm)
 	 * Execute permission is checked against pathname passed to do_execve()
 	 * using current domain.
 	 */
-	if (!domain)
-		return tomoyo_find_next_domain(bprm);
+	if (!domain) {
+		/*
+		 * We will need to protect whole execve() operation when GC
+		 * starts kfree()ing "struct tomoyo_domain_info" because
+		 * bprm->cred->security points to "struct tomoyo_domain_info"
+		 * but "struct tomoyo_domain_info" does not have a refcounter.
+		 */
+		const int idx = tomoyo_read_lock();
+		const int err = tomoyo_find_next_domain(bprm);
+		tomoyo_read_unlock(idx);
+		return err;
+	}
 	/*
 	 * Read permission is checked against interpreters using next domain.
 	 * '1' is the result of open_to_namei_flags(O_RDONLY).
@@ -278,6 +288,9 @@ static struct security_operations tomoyo_security_ops = {
 	.sb_pivotroot        = tomoyo_sb_pivotroot,
 };
 
+/* Lock for GC. */
+struct srcu_struct tomoyo_ss;
+
 static int __init tomoyo_init(void)
 {
 	struct cred *cred = (struct cred *) current_cred();
@@ -285,7 +298,8 @@ static int __init tomoyo_init(void)
 	if (!security_module_enable(&tomoyo_security_ops))
 		return 0;
 	/* register ourselves with the security framework */
-	if (register_security(&tomoyo_security_ops))
+	if (register_security(&tomoyo_security_ops) ||
+	    init_srcu_struct(&tomoyo_ss))
 		panic("Failure registering TOMOYO Linux");
 	printk(KERN_INFO "TOMOYO Linux initialized\n");
 	cred->security = &tomoyo_kernel_domain;
