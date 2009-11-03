Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbZKCXtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbZKCXtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbZKCXtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:49:52 -0500
Received: from adelie.canonical.com ([91.189.90.139]:41064 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbZKCXtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:49:47 -0500
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org,
       John Johansen <john.johansen@canonical.com>
Subject: [PATCH 04/12] AppArmor: core policy routines
Date: Tue,  3 Nov 2009 15:48:11 -0800
Message-Id: <1257292099-15802-5-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1257292099-15802-1-git-send-email-john.johansen@canonical.com>
References: <1257292099-15802-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The basic routines and defines for AppArmor policy.  AppArmor policy
is defined by a few basic components.
      profiles - the basic unit of confinement contain all the information
                 to enforce policy on a task

                 Profiles tend to be named after an executable that they
                 will attach to but this is not required.
      namespaces - a container for a set of profiles that will be used
                 during attachment and transitions between profiles.
      sids - which provide a unique id for each profile

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/include/policy.h |  296 ++++++++++++++++
 security/apparmor/include/sid.h    |   45 +++
 security/apparmor/policy.c         |  678 ++++++++++++++++++++++++++++++++++++
 security/apparmor/sid.c            |  108 ++++++
 4 files changed, 1127 insertions(+), 0 deletions(-)
 create mode 100644 security/apparmor/include/policy.h
 create mode 100644 security/apparmor/include/sid.h
 create mode 100644 security/apparmor/policy.c
 create mode 100644 security/apparmor/sid.c

diff --git a/security/apparmor/include/policy.h b/security/apparmor/include/policy.h
new file mode 100644
index 0000000..6274b82
--- /dev/null
+++ b/security/apparmor/include/policy.h
@@ -0,0 +1,296 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor policy definitions.
+ *
+ * Copyright (C) 1998-2008 Novell/SUSE
+ * Copyright 2009 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ */
+
+#ifndef __AA_POLICY_H
+#define __AA_POLICY_H
+
+#include <linux/capability.h>
+#include <linux/cred.h>
+#include <linux/kref.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/socket.h>
+
+#include "apparmor.h"
+#include "audit.h"
+#include "capability.h"
+#include "domain.h"
+#include "file.h"
+#include "net.h"
+#include "resource.h"
+
+extern const char *profile_mode_names[];
+#define APPARMOR_NAMES_MAX_INDEX 3
+
+#define PROFILE_COMPLAIN(_profile)				\
+	((aa_g_profile_mode == APPARMOR_COMPLAIN) || ((_profile) &&	\
+					(_profile)->mode == APPARMOR_COMPLAIN))
+
+#define PROFILE_KILL(_profile)					\
+	((aa_g_profile_mode == APPARMOR_KILL) || ((_profile) &&	\
+					(_profile)->mode == APPARMOR_KILL))
+
+#define PROFILE_IS_HAT(_profile) \
+	((_profile) && (_profile)->flags & PFLAG_HAT)
+
+/*
+ * FIXME: currently need a clean way to replace and remove profiles as a
+ * set.  It should be done at the namespace level.
+ * Either, with a set of profiles loaded at the namespace level or via
+ * a mark and remove marked interface.
+ */
+enum profile_mode {
+	APPARMOR_ENFORCE,	/* enforce access rules */
+	APPARMOR_COMPLAIN,	/* allow and log access violations */
+	APPARMOR_KILL,		/* kill task on access violation */
+};
+
+enum profile_flags {
+	PFLAG_HAT = 1,			/* profile is a hat */
+	PFLAG_UNCONFINED = 2,		/* profile is the unconfined profile */
+	PFLAG_NULL = 4,			/* profile is null learning profile */
+	PFLAG_IX_ON_NAME_ERROR = 8,	/* fallback to ix on name lookup fail */
+	PFLAG_IMMUTABLE = 0x10,		/* don't allow changes/replacement */
+	PFLAG_USER_DEFINED = 0x20,	/* user based profile */
+	PFLAG_NO_LIST_REF = 0x40,	/* list doesn't keep profile ref */
+	PFLAG_MMAP_MIN_ADDR = 0x80,	/* profile controls mmap_min_addr */
+	PFLAG_DELETED_NAMES = 0x100,	/* mediate deleted paths */
+	PFLAG_CONNECT_PATH = 0x200,	/* connect disconnected paths to / */
+};
+
+#define AA_NEW_SID 0
+
+struct aa_profile;
+
+/* struct aa_policy_common - common part of both namespaces and profiles
+ * @name: name of the object
+ * @count: reference count of the obj
+ * lock: lock for modifying the object
+ * @list: list object is on
+ * @profiles: head of the profiles list contained in the object
+ */
+struct aa_policy_common {
+	char *name;
+	struct kref count;
+	rwlock_t lock;
+	struct list_head list;
+	struct list_head profiles;
+};
+
+/* struct aa_ns_acct - accounting of profiles in namespace
+ * @max_size: maximum space allowed for all profiles in namespace
+ * @max_count: maximum number of profiles that can be in this namespace
+ * @size: current size of profiles
+ * @count: current count of profiles (includes null profiles)
+ */
+struct aa_ns_acct {
+	int max_size;
+	int max_count;
+	int size;
+	int count;
+};
+
+/* struct aa_namespace - namespace for a set of profiles
+ * @name: the name of the namespace
+ * @list: list the namespace is on
+ * @profiles: list of profile in the namespace
+ * @acct: accounting for the namespace
+ * @profile_count: count of profiles on @profiles list
+ * @size: accounting of how much memory is consumed by the contained profiles
+ * @unconfined: special unconfined profile for the namespace
+ * @count: reference count on the namespace
+ * @lock: lock for adding/removing profile to the namespace
+ *
+ * An aa_namespace defines the set profiles that are searched to determine
+ * which profile to attach to a task.  Profiles can not be shared between
+ * aa_namespaces and profile names within a namespace are guarenteed to be
+ * unique.  When profiles in seperate namespaces have the same name they
+ * are NOT considered to be equivalent.
+ *
+ * Namespace names must be unique and can not contain the characters :/\0
+ *
+ * FIXME TODO: add vserver support so a vserer gets a default namespace
+ */
+struct aa_namespace {
+	struct aa_policy_common base;
+	struct aa_ns_acct acct;
+	int is_stale;
+	struct aa_profile *unconfined;
+};
+
+/* struct aa_profile - basic confinement data
+ * @base - base componets of the profile (name, refcount, lists, lock ...)
+ * @fqname - The fully qualified profile name, less the namespace name
+ * @ns: namespace the profile is in
+ * @parent: parent profile of this profile, if one exists
+ * @replacedby: is set profile that replaced this profile
+ * @xmatch: optional extended matching for unconfined executables names
+ * @xmatch_plen: xmatch prefix len, used to determine xmatch priority
+ * @sid: the unique security id number of this profile
+ * @audit: the auditing mode of the profile
+ * @mode: the enforcement mode of the profile
+ * @flags: flags controlling profile behavior
+ * @size: the memory consumed by this profiles rules
+ * @file: The set of rules governing basic file access and domain transitions
+ * @caps: capabilities for the profile
+ * @net: network controls for the profile
+ * @rlimits: rlimits for the profile
+ *
+ * The AppArmor profile contains the basic confinement data.  Each profile
+ * has a name, and exist in a namespace.  The @name and @exec_match are
+ * used to determine profile attachment against unconfined tasks.  All other
+ * attachments are determined by in profile X transition rules.
+ *
+ * The @replacedby field is write protected by the profile lock.  Reads
+ * are assumed to be atomic, and are done without locking.
+ *
+ * Profiles have a hierachy where hats and children profiles keep
+ * a reference to their parent.
+ *
+ * Profile names can not begin with a : and can not contain the \0
+ * character.  If a profile name begins with / it will be considered when
+ * determining profile attachment on "unconfined" tasks.
+ */
+struct aa_profile {
+	struct aa_policy_common base;
+	char *fqname;
+
+	struct aa_namespace *ns;
+	struct aa_profile *parent;
+	struct aa_profile *replacedby;
+
+	struct aa_dfa *xmatch;
+	int xmatch_len;
+	u32 sid;
+	enum audit_mode audit;
+	enum profile_mode mode;
+	u32 flags;
+	int size;
+
+	unsigned long mmap_min_addr;
+
+	struct aa_file_rules file;
+	struct aa_caps caps;
+	struct aa_net net;
+	struct aa_rlimit rlimits;
+};
+
+extern struct list_head ns_list;
+extern rwlock_t ns_list_lock;
+
+extern struct aa_namespace *default_namespace;
+extern enum profile_mode aa_g_profile_mode;
+
+void aa_add_profile(struct aa_policy_common *common,
+		    struct aa_profile *profile);
+
+int aa_alloc_default_namespace(void);
+void aa_free_default_namespace(void);
+struct aa_namespace *alloc_aa_namespace(const char *name);
+void free_aa_namespace_kref(struct kref *kref);
+void free_aa_namespace(struct aa_namespace *ns);
+struct aa_namespace *__aa_find_namespace(struct list_head *head,
+					 const char *name);
+
+struct aa_namespace *aa_find_namespace(const char *name);
+struct aa_namespace *aa_prepare_namespace(const char *name);
+void aa_remove_namespace(struct aa_namespace *ns);
+struct aa_namespace *aa_prepare_namespace(const char *name);
+void aa_profile_list_release(struct list_head *head);
+void aa_profile_ns_list_release(void);
+void __aa_remove_namespace(struct aa_namespace *ns);
+
+static inline struct aa_policy_common *aa_get_common(struct aa_policy_common *c)
+{
+	if (c)
+		kref_get(&c->count);
+
+	return c;
+}
+
+static inline struct aa_namespace *aa_get_namespace(struct aa_namespace *ns)
+{
+	if (ns)
+		kref_get(&(ns->base.count));
+
+	return ns;
+}
+
+static inline void aa_put_namespace(struct aa_namespace *ns)
+{
+	if (ns)
+		kref_put(&ns->base.count, free_aa_namespace_kref);
+}
+
+struct aa_profile *alloc_aa_profile(const char *name);
+struct aa_profile *aa_alloc_null_profile(struct aa_profile *parent, int hat);
+void free_aa_profile_kref(struct kref *kref);
+void free_aa_profile(struct aa_profile *profile);
+struct aa_profile *__aa_find_profile(struct list_head *head, const char *name);
+struct aa_profile *aa_find_child(struct aa_profile *parent, const char *name);
+struct aa_policy_common *__aa_find_parent_by_fqname(struct aa_namespace *ns,
+						    const char *fqname);
+struct aa_profile *__aa_find_profile_by_fqname(struct aa_namespace *ns,
+					       const char *fqname);
+struct aa_profile *aa_find_profile_by_fqname(struct aa_namespace *ns,
+					     const char *name);
+struct aa_profile *aa_match_profile(struct aa_namespace *ns, const char *name);
+struct aa_profile *aa_profile_newest(struct aa_profile *profile);
+void __aa_add_profile(struct aa_policy_common *common,
+		      struct aa_profile *profile);
+void __aa_remove_profile(struct aa_profile *profile,
+			 struct aa_profile *replacement);
+void __aa_replace_profile(struct aa_profile *profile,
+			  struct aa_profile *replacement);
+void __aa_profile_list_release(struct list_head *head);
+
+static inline struct aa_profile *aa_filtered_profile(struct aa_profile *profile)
+{
+	if (profile->flags & PFLAG_UNCONFINED)
+		return NULL;
+	return profile;
+}
+
+/**
+ * aa_get_profile - increment refcount on profile @p
+ * @p: profile
+ */
+static inline struct aa_profile *aa_get_profile(struct aa_profile *p)
+{
+	if (p)
+		kref_get(&(p->base.count));
+
+	return p;
+}
+
+/**
+ * aa_put_profile - decrement refcount on profile @p
+ * @p: profile
+ */
+static inline void aa_put_profile(struct aa_profile *p)
+{
+	if (p)
+		kref_put(&p->base.count, free_aa_profile_kref);
+}
+
+static inline int PROFILE_AUDIT_MODE(struct aa_profile *profile)
+{
+	if (aa_g_audit != AUDIT_NORMAL)
+		return aa_g_audit;
+	if (profile)
+		return profile->audit;
+	return AUDIT_NORMAL;
+}
+
+#endif /* __AA_POLICY_H */
diff --git a/security/apparmor/include/sid.h b/security/apparmor/include/sid.h
new file mode 100644
index 0000000..0f5df2f
--- /dev/null
+++ b/security/apparmor/include/sid.h
@@ -0,0 +1,45 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor security identifier (sid) definitions
+ *
+ * Copyright 2009 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ */
+
+#ifndef __AA_SID_H
+#define __AA_SID_H
+
+#include <linux/types.h>
+
+struct aa_profile;
+
+#define AA_ALLOC_USR_SID 1
+#define AA_ALLOC_SYS_SID 0
+
+u32 aa_alloc_sid(int is_usr);
+void aa_free_sid(u32 sid);
+int aa_add_sid_profile(u32 sid, struct aa_profile *profile);
+int aa_replace_sid_profile(u32 sid, struct aa_profile *profile);
+struct aa_profile *aa_get_sid_profile(u32 sid);
+
+static inline u32 aa_compound_sid(u32 sys, u32 usr)
+{
+	return sys | usr;
+}
+
+static inline u32 aa_usr_sid(u32 sid)
+{
+	return sid & 0xffff0000;
+}
+
+static inline u32 aa_sys_sid(u32 sid)
+{
+	return sid & 0xffff;
+}
+
+#endif /* __AA_SID_H */
diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
new file mode 100644
index 0000000..4dbfaa2
--- /dev/null
+++ b/security/apparmor/policy.c
@@ -0,0 +1,678 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor policy manipulation functions
+ *
+ * Copyright (C) 1998-2008 Novell/SUSE
+ * Copyright 2009 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ *
+ * AppArmor policy is based around profiles, which contain the rules a
+ * task is confined by.  Every task in the sytem has a profile attached
+ * to it determined either by matching "unconfined" tasks against the
+ * visible set of profiles or by following a profiles attachment rules.
+ *
+ * Each profile exists in an AppArmor profile namespace which is a
+ * container of related profiles.  Each namespace contains a special
+ * "unconfined" profile, which doesn't efforce any confinement on
+ * a task beyond DAC.
+ *
+ * Namespace and profile names can be written together in either
+ * of two syntaxes.
+ *	:namespace:profile - used by kernel interfaces for easy detection
+ *	namespace://profile - used by policy
+ *
+ * Profile names name not start with : or @ and may not contain \0
+ * a // in a profile name indicates a compound name with the name before
+ * the // being the parent profile and the name after the child
+ *
+ * Reserved profile names
+ *	unconfined - special automatically generated unconfined profile
+ *	inherit - special name to indicate profile inheritance
+ *	null-XXXX-YYYY - special automically generated learning profiles
+ *
+ * Namespace names may not start with / or @ and may not contain \0 or /
+ * Reserved namespace namespace
+ *	default - the default namespace setup by AppArmor
+ *	user-XXXX - user defined profiles
+ */
+
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+
+#include "include/apparmor.h"
+#include "include/capability.h"
+#include "include/file.h"
+#include "include/ipc.h"
+#include "include/match.h"
+#include "include/policy.h"
+#include "include/resource.h"
+#include "include/sid.h"
+
+/* list of profile namespaces and lock */
+LIST_HEAD(ns_list);
+DEFINE_RWLOCK(ns_list_lock);
+
+struct aa_namespace *default_namespace;
+
+const char *profile_mode_names[] = {
+	"enforce",
+	"complain",
+	"kill",
+};
+
+static int common_init(struct aa_policy_common *common, const char *name)
+{
+	common->name = kstrdup(name, GFP_KERNEL);
+	if (!common->name)
+		return 0;
+	INIT_LIST_HEAD(&common->list);
+	INIT_LIST_HEAD(&common->profiles);
+	kref_init(&common->count);
+	rwlock_init(&common->lock);
+
+	return 1;
+}
+
+static void common_free(struct aa_policy_common *common)
+{
+	/* still contains profiles -- invalid */
+	if (!list_empty(&common->profiles)) {
+		AA_ERROR("%s: internal error, "
+			 "policy '%s' still contains profiles\n",
+			 __func__, common->name);
+		BUG();
+	}
+	if (!list_empty(&common->list)) {
+		AA_ERROR("%s: internal error, policy '%s' still on list\n",
+			 __func__, common->name);
+		BUG();
+	}
+
+	kfree(common->name);
+}
+
+static struct aa_policy_common *__common_find(struct list_head *head,
+					      const char *name)
+{
+	struct aa_policy_common *common;
+
+	list_for_each_entry(common, head, list) {
+		if (!strcmp(common->name, name))
+			return common;
+	}
+	return NULL;
+}
+
+static struct aa_policy_common *__common_find_strn(struct list_head *head,
+						   const char *str, int len)
+{
+	struct aa_policy_common *common;
+
+	list_for_each_entry(common, head, list) {
+		if (aa_strneq(common->name, str, len))
+			return common;
+	}
+
+	return NULL;
+}
+
+/*
+ * Routines for AppArmor namespaces
+ */
+
+int aa_alloc_default_namespace(void)
+{
+	struct aa_namespace *ns;
+	ns = alloc_aa_namespace("default");
+	if (!ns)
+		return -ENOMEM;
+
+	default_namespace = aa_get_namespace(ns);
+	write_lock(&ns_list_lock);
+	list_add(&ns->base.list, &ns_list);
+	write_unlock(&ns_list_lock);
+
+	return 0;
+}
+
+void aa_free_default_namespace(void)
+{
+	write_lock(&ns_list_lock);
+	list_del_init(&default_namespace->base.list);
+	aa_put_namespace(default_namespace);
+	write_unlock(&ns_list_lock);
+	aa_put_namespace(default_namespace);
+	default_namespace = NULL;
+}
+
+/**
+ * alloc_aa_namespace - allocate, initialize and return a new namespace
+ * @name: a preallocated name
+ * Returns NULL on failure.
+ */
+struct aa_namespace *alloc_aa_namespace(const char *name)
+{
+	struct aa_namespace *ns;
+
+	ns = kzalloc(sizeof(*ns), GFP_KERNEL);
+	AA_DEBUG("%s(%p)\n", __func__, ns);
+	if (!ns)
+		return NULL;
+
+	if (!common_init(&ns->base, name))
+		goto fail_ns;
+
+	/* null profile is not added to the profile list */
+	ns->unconfined = alloc_aa_profile("unconfined");
+	if (!ns->unconfined)
+		goto fail_unconfined;
+
+	ns->unconfined->sid = aa_alloc_sid(AA_ALLOC_SYS_SID);
+	ns->unconfined->flags = PFLAG_UNCONFINED | PFLAG_IX_ON_NAME_ERROR |
+	    PFLAG_IMMUTABLE;
+	ns->unconfined->ns = aa_get_namespace(ns);
+
+	return ns;
+
+fail_unconfined:
+	kfree(ns->base.name);
+fail_ns:
+	kfree(ns);
+	return NULL;
+}
+
+/**
+ * free_aa_namespace_kref - free aa_namespace by kref (see aa_put_namespace)
+ * @kr: kref callback for freeing of a namespace
+ */
+void free_aa_namespace_kref(struct kref *kref)
+{
+	free_aa_namespace(container_of(kref, struct aa_namespace, base.count));
+}
+
+/**
+ * free_aa_namespace - free a profile namespace
+ * @namespace: the namespace to free
+ *
+ * Free a namespace.  All references to the namespace must have been put.
+ * If the namespace was referenced by a profile confining a task,
+ */
+void free_aa_namespace(struct aa_namespace *ns)
+{
+	if (!ns)
+		return;
+
+	common_free(&ns->base);
+
+	if (ns->unconfined && ns->unconfined->ns == ns)
+		ns->unconfined->ns = NULL;
+
+	aa_put_profile(ns->unconfined);
+	kzfree(ns);
+}
+
+struct aa_namespace *__aa_find_namespace(struct list_head *head,
+					 const char *name)
+{
+	return (struct aa_namespace *)__common_find(head, name);
+}
+
+/**
+ * aa_find_namespace  -  look up a profile namespace on the namespace list
+ * @name: name of namespace to find
+ *
+ * Returns a pointer to the namespace on the list, or NULL if no namespace
+ * called @name exists.
+ */
+struct aa_namespace *aa_find_namespace(const char *name)
+{
+	struct aa_namespace *ns = NULL;
+
+	read_lock(&ns_list_lock);
+	ns = aa_get_namespace(__aa_find_namespace(&ns_list, name));
+	read_unlock(&ns_list_lock);
+
+	return ns;
+}
+
+static struct aa_namespace *__aa_find_namespace_by_strn(struct list_head *head,
+							const char *name,
+							int len)
+{
+	return (struct aa_namespace *)__common_find_strn(head, name, len);
+}
+
+struct aa_namespace *aa_find_namespace_by_strn(const char *name, int len)
+{
+	struct aa_namespace *ns = NULL;
+
+	read_lock(&ns_list_lock);
+	ns = aa_get_namespace(__aa_find_namespace_by_strn(&ns_list, name, len));
+	read_unlock(&ns_list_lock);
+
+	return ns;
+}
+
+/**
+ * aa_prepare_namespace - find an existing or create a new namespace of @name
+ * @name: the namespace to find or add
+ */
+struct aa_namespace *aa_prepare_namespace(const char *name)
+{
+	struct aa_namespace *ns;
+
+	write_lock(&ns_list_lock);
+	if (name)
+		ns = aa_get_namespace(__aa_find_namespace(&ns_list, name));
+	else
+		ns = aa_get_namespace(default_namespace);
+	if (!ns) {
+		struct aa_namespace *new_ns;
+		write_unlock(&ns_list_lock);
+		new_ns = alloc_aa_namespace(name);
+		if (!new_ns)
+			return NULL;
+		write_lock(&ns_list_lock);
+		ns = __aa_find_namespace(&ns_list, name);
+		if (!ns) {
+			list_add(&new_ns->base.list, &ns_list);
+			ns = aa_get_namespace(new_ns);
+		} else {
+			/* raced so free the new one */
+			free_aa_namespace(new_ns);
+			aa_get_namespace(ns);
+		}
+	}
+	write_unlock(&ns_list_lock);
+
+	return ns;
+}
+
+/*
+ * requires profile->ns set first, takes profiles refcount
+ * TODO: add accounting
+ */
+void __aa_add_profile(struct aa_policy_common *common,
+		      struct aa_profile *profile)
+{
+	list_add(&profile->base.list, &common->profiles);
+	if (!(profile->flags & PFLAG_NO_LIST_REF))
+		aa_get_profile(profile);
+}
+
+void __aa_remove_profile(struct aa_profile *profile,
+			 struct aa_profile *replacement)
+{
+	if (replacement)
+		profile->replacedby = aa_get_profile(replacement);
+	else
+		profile->replacedby = ERR_PTR(-EINVAL);
+	list_del_init(&profile->base.list);
+	if (!(profile->flags & PFLAG_NO_LIST_REF))
+		aa_put_profile(profile);
+}
+
+/* TODO: add accounting */
+void __aa_replace_profile(struct aa_profile *profile,
+			  struct aa_profile *replacement)
+{
+	if (replacement) {
+		struct aa_policy_common *common;
+
+		if (profile->parent)
+			common = &profile->parent->base;
+		else
+			common = &profile->ns->base;
+
+		__aa_remove_profile(profile, replacement);
+		__aa_add_profile(common, replacement);
+	} else
+		__aa_remove_profile(profile, NULL);
+}
+
+/**
+ * __aa_profile_list_release - remove all profiles on the list and put refs
+ * @head: list of profiles
+ */
+void __aa_profile_list_release(struct list_head *head)
+{
+	struct aa_profile *profile, *tmp;
+	list_for_each_entry_safe(profile, tmp, head, base.list) {
+		__aa_profile_list_release(&profile->base.profiles);
+		__aa_remove_profile(profile, NULL);
+	}
+}
+
+void __aa_remove_namespace(struct aa_namespace *ns)
+{
+	struct aa_profile *unconfined = ns->unconfined;
+	list_del_init(&ns->base.list);
+
+	/*
+	 * break the ns, unconfined profile cyclic reference and forward
+	 * all new unconfined profiles requests to the default namespace
+	 */
+	ns->unconfined = aa_get_profile(default_namespace->unconfined);
+	__aa_profile_list_release(&ns->base.profiles);
+	aa_put_profile(unconfined);
+	aa_put_namespace(ns);
+}
+
+/**
+ * aa_remove_namespace = Remove namespace from the list
+ * @ns: namespace to remove
+ */
+void aa_remove_namespace(struct aa_namespace *ns)
+{
+	write_lock(&ns_list_lock);
+	write_lock(&ns->base.lock);
+	__aa_remove_namespace(ns);
+	write_unlock(&ns->base.lock);
+	write_unlock(&ns_list_lock);
+}
+
+/**
+ * aa_profilelist_release - remove all namespaces and all associated profiles
+ */
+void aa_profile_ns_list_release(void)
+{
+	struct aa_namespace *ns, *tmp;
+
+	/* Remove and release all the profiles on namespace profile lists. */
+	write_lock(&ns_list_lock);
+	list_for_each_entry_safe(ns, tmp, &ns_list, base.list) {
+		write_lock(&ns->base.lock);
+		__aa_remove_namespace(ns);
+		write_unlock(&ns->base.lock);
+	}
+	write_unlock(&ns_list_lock);
+}
+
+static const char *fqname_subname(const char *name)
+{
+	char *split;
+	/* check for namespace which begins with a : and ends with : or \0 */
+	name = strstrip((char *)name);
+	if (*name == ':') {
+		split = aa_strchrnul(name + 1, ':');
+		if (*split == '\0')
+			return NULL;
+		name = strstrip(split + 1);
+	}
+	for (split = strstr(name, "//"); split; split = strstr(name, "//"))
+		name = split + 2;
+
+	return name;
+}
+
+/**
+ * alloc_aa_profile - allocate, initialize and return a new profile
+ * @fqname: name of the profile
+ *
+ * Returns NULL on failure.
+ */
+struct aa_profile *alloc_aa_profile(const char *fqname)
+{
+	struct aa_profile *profile;
+
+	profile = kzalloc(sizeof(*profile), GFP_KERNEL);
+	if (!profile)
+		return NULL;
+
+	if (!common_init(&profile->base, fqname)) {
+		kfree(profile);
+		return NULL;
+	}
+
+	profile->fqname = profile->base.name;
+	profile->base.name =
+	    (char *)fqname_subname((const char *)profile->fqname);
+	return profile;
+}
+
+/**
+ * aa_new_null_profile - create a new null-X learning profile
+ * @parent: profile that caused this profile to be created
+ * @hat: true if the null- learning profile is a hat
+ *
+ * Create a null- complain mode profile used in learning mode.  The name of
+ * the profile is unique and follows the format of parent//null-sid.
+ *
+ * null profiles are added to the profile list but the list does not
+ * hold a count on them so that they are automatically released when
+ * not in use.
+ */
+struct aa_profile *aa_alloc_null_profile(struct aa_profile *parent, int hat)
+{
+	struct aa_profile *profile = NULL;
+	char *name;
+	u32 sid = aa_alloc_sid(AA_ALLOC_SYS_SID);
+
+	name = kmalloc(strlen(parent->fqname) + 2 + 7 + 8, GFP_KERNEL);
+	if (!name)
+		goto fail;
+	sprintf(name, "%s//null-%x", parent->fqname, sid);
+
+	profile = alloc_aa_profile(name);
+	kfree(name);
+	if (!profile)
+		goto fail;
+
+	profile->sid = aa_alloc_sid(AA_ALLOC_SYS_SID);
+	profile->mode = APPARMOR_COMPLAIN;
+	profile->flags = PFLAG_NULL | PFLAG_NO_LIST_REF;
+	if (hat)
+		profile->flags |= PFLAG_HAT;
+
+	profile->parent = aa_get_profile(parent);
+	profile->ns = aa_get_namespace(parent->ns);
+
+	write_lock(&profile->ns->base.lock);
+	__aa_add_profile(&parent->base, profile);
+	write_unlock(&profile->ns->base.lock);
+
+	return profile;
+
+fail:
+	aa_free_sid(sid);
+	return NULL;
+}
+
+/**
+ * free_aa_profile_kref - free aa_profile by kref (called by aa_put_profile)
+ * @kr: kref callback for freeing of a profile
+ */
+void free_aa_profile_kref(struct kref *kref)
+{
+	struct aa_profile *p = container_of(kref, struct aa_profile,
+					    base.count);
+
+	free_aa_profile(p);
+}
+
+/**
+ * free_aa_profile - free a profile
+ * @profile: the profile to free
+ *
+ * Free a profile, its hats and null_profile. All references to the profile,
+ * its hats and null_profile must have been put.
+ *
+ * If the profile was referenced from a task context, free_aa_profile() will
+ * be called from an rcu callback routine, so we must not sleep here.
+ */
+void free_aa_profile(struct aa_profile *profile)
+{
+	AA_DEBUG("%s(%p)\n", __func__, profile);
+
+	if (!profile)
+		return;
+
+	/*
+	 * profile can still be on the list if the list doesn't hold a
+	 * reference.  There is no race as NULL profiles can't be attached
+	 */
+	if (!list_empty(&profile->base.list)) {
+		if ((profile->flags & PFLAG_NULL) && profile->ns) {
+			write_lock(&profile->ns->base.lock);
+			list_del_init(&profile->base.list);
+			write_unlock(&profile->ns->base.lock);
+		} else {
+			AA_ERROR("%s: internal error, "
+				 "profile '%s' still on ns list\n",
+				 __func__, profile->base.name);
+			BUG();
+		}
+	}
+
+	/* profile->name is a substring of fqname */
+	profile->base.name = NULL;
+	common_free(&profile->base);
+
+	BUG_ON(!list_empty(&profile->base.profiles));
+
+	kfree(profile->fqname);
+
+	aa_put_namespace(profile->ns);
+	aa_put_profile(profile->parent);
+
+	aa_free_file_rules(&profile->file);
+	aa_free_cap_rules(&profile->caps);
+	aa_free_net_rules(&profile->net);
+	aa_free_rlimit_rules(&profile->rlimits);
+
+	aa_free_sid(profile->sid);
+	aa_match_free(profile->xmatch);
+
+	if (profile->replacedby && !PTR_ERR(profile->replacedby))
+		aa_put_profile(profile->replacedby);
+
+	kzfree(profile);
+}
+
+/* TODO: profile count accounting - setup in remove */
+
+struct aa_profile *__aa_find_profile(struct list_head *head, const char *name)
+{
+	return (struct aa_profile *)__common_find(head, name);
+}
+
+struct aa_profile *__aa_find_profile_by_strn(struct list_head *head,
+					     const char *name, int len)
+{
+	return (struct aa_profile *)__common_find_strn(head, name, len);
+}
+
+/**
+ * aa_find_child - find a profile by @name in @parent
+ * @parent: profile to search
+ * @name: profile name to search for
+ *
+ * Returns a ref counted profile or NULL if not found
+ */
+struct aa_profile *aa_find_child(struct aa_profile *parent, const char *name)
+{
+	struct aa_profile *profile;
+
+	read_lock(&parent->ns->base.lock);
+	profile = aa_get_profile(__aa_find_profile(&parent->base.profiles,
+						   name));
+	read_unlock(&parent->ns->base.lock);
+
+	return profile;
+}
+
+struct aa_policy_common *__aa_find_parent_by_fqname(struct aa_namespace *ns,
+						    const char *fqname)
+{
+	struct aa_policy_common *common;
+	struct aa_profile *profile = NULL;
+	char *split;
+
+	common = &ns->base;
+
+	for (split = strstr(fqname, "//"); split;) {
+		profile = __aa_find_profile_by_strn(&common->profiles, fqname,
+						    split - fqname);
+		if (!profile)
+			return NULL;
+		common = &profile->base;
+		fqname = split + 2;
+		split = strstr(fqname, "//");
+	}
+	if (!profile)
+		return &ns->base;
+	return &profile->base;
+}
+
+struct aa_profile *__aa_find_profile_by_fqname(struct aa_namespace *ns,
+					       const char *fqname)
+{
+	struct aa_policy_common *common;
+	struct aa_profile *profile = NULL;
+	char *split;
+
+	common = &ns->base;
+	for (split = strstr(fqname, "//"); split;) {
+		profile = __aa_find_profile_by_strn(&common->profiles, fqname,
+						    split - fqname);
+		if (!profile)
+			return NULL;
+
+		common = &profile->base;
+		fqname = split + 2;
+		split = strstr(fqname, "//");
+	}
+
+	profile = __aa_find_profile(&common->profiles, fqname);
+
+	return profile;
+}
+
+/**
+ * aa_find_profile_by_name - find a profile by its full or partial name
+ * @ns: the namespace to start from
+ * @fqname: name to do lookup on.  Does not contain namespace prefix
+ */
+struct aa_profile *aa_find_profile_by_fqname(struct aa_namespace *ns,
+					     const char *fqname)
+{
+	struct aa_profile *profile;
+
+	read_lock(&ns->base.lock);
+	profile = aa_get_profile(__aa_find_profile_by_fqname(ns, fqname));
+	read_unlock(&ns->base.lock);
+	return profile;
+}
+
+/**
+ * aa_profile_newest - find the newest version of @profile
+ * @profile: the profile to check for newer versions of
+ *
+ * Find the newest version of @profile, if @profile is the newest version
+ * return @profile.  If @profile has been removed return NULL.
+ *
+ * NOTE: the profile returned is not refcounted, The refcount on @profile
+ * must be held until the caller decides what to do with the returned newest
+ * version.
+ */
+struct aa_profile *aa_profile_newest(struct aa_profile *profile)
+{
+	if (unlikely(profile && profile->replacedby)) {
+		for (; profile->replacedby; profile = profile->replacedby) {
+			if (IS_ERR(profile->replacedby)) {
+				/* profile has been removed */
+				profile = NULL;
+				break;
+			}
+		}
+	}
+
+	return profile;
+}
diff --git a/security/apparmor/sid.c b/security/apparmor/sid.c
new file mode 100644
index 0000000..e20843f
--- /dev/null
+++ b/security/apparmor/sid.c
@@ -0,0 +1,108 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor security identifier (sid) manipulation fns
+ *
+ * Copyright 2009 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ *
+ * AppArmor allocates a unique sid for every profile loaded.  If a profile
+ * is replaced it receive the sid of the profile it is replacing.  Each sid
+ * is a u32 with the lower u16 being sids of system profiles and the
+ * upper u16 being user profile sids.
+ *
+ * The sid value of 0 is invalid for system sids and is used to indicate
+ * unconfined for user sids.
+ *
+ * A compound sid is a pair of user and system sids that is used to identify
+ * both profiles confining a task.
+ *
+ * Both system and user sids are globally unique with all users pulling
+ * from the same sid pool.  User sid allocation is limited by the
+ * user controls, that can limit how many profiles are loaded by a user.
+ */
+
+#include <linux/spinlock.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+
+#include "include/sid.h"
+
+/* global counter from which sids are allocated */
+static u16 global_sys_sid;
+static u16 global_usr_sid;
+static DEFINE_SPINLOCK(sid_lock);
+
+/* TODO FIXME: add sid to profile mapping, and sid recycling */
+
+/**
+ * aa_alloc_sid - allocate a new sid for a profile
+ * @is_usr: true if the new sid is a user based sid
+ */
+u32 aa_alloc_sid(int is_usr)
+{
+	u32 sid;
+
+	/*
+	 * TODO FIXME: sid recycling - part of profile mapping table
+	 */
+	spin_lock(&sid_lock);
+	if (is_usr)
+		sid = (++global_usr_sid) << 16;
+	else
+		sid = ++global_sys_sid;
+	spin_unlock(&sid_lock);
+	return sid;
+}
+
+/**
+ * aa_free_sid - free a sid
+ * @sid: sid to free
+ */
+void aa_free_sid(u32 sid)
+{
+	;			/* NOP ATM */
+}
+
+/**
+ * aa_add_sid_profile - associate a profile to a sid for sid -> profile lookup
+ * @sid: sid of te profile
+ * @profile: profile to associate
+ *
+ * return 0 or error
+ */
+int aa_add_sid_profile(u32 sid, struct aa_profile *profile)
+{
+	/* NOP ATM */
+	return 0;
+}
+
+/**
+ * aa_replace_sid_profile - replace the profile associated with a sid
+ * @sid: sid to associate a new profile with
+ * @profile: profile to associate with side
+ *
+ * return 0 or error
+ */
+int aa_replace_sid_profile(u32 sid, struct aa_profile *profile)
+{
+	/* NOP ATM */
+	return 0;
+}
+
+/**
+ * aa_get_sid_profile - get the profile associated with the sid
+ * @sid: sid to lookup
+ *
+ * returns - the profile, or NULL for unconfined user.
+ *         - if there is an error -ENOENT, -EINVAL
+ */
+struct aa_profile *aa_get_sid_profile(u32 sid)
+{
+	return ERR_PTR(-EINVAL);
+}
-- 
1.6.3.3

