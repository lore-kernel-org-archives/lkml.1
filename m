Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbZKJQNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbZKJQNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 11:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756924AbZKJQN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 11:13:27 -0500
Received: from adelie.canonical.com ([91.189.90.139]:59886 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756908AbZKJQNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 11:13:20 -0500
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org,
       John Johansen <john.johansen@canonical.com>
Subject: [PATCH 04/12] AppArmor: core policy routines
Date: Tue, 10 Nov 2009 08:12:57 -0800
Message-Id: <1257869585-7092-5-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1257869585-7092-1-git-send-email-john.johansen@canonical.com>
References: <1257869585-7092-1-git-send-email-john.johansen@canonical.com>
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
 security/apparmor/include/policy.h |  321 +++++++++++
 security/apparmor/include/sid.h    |   45 ++
 security/apparmor/policy.c         | 1034 ++++++++++++++++++++++++++++++++++++
 security/apparmor/sid.c            |  108 ++++
 4 files changed, 1508 insertions(+), 0 deletions(-)
 create mode 100644 security/apparmor/include/policy.h
 create mode 100644 security/apparmor/include/sid.h
 create mode 100644 security/apparmor/policy.c
 create mode 100644 security/apparmor/sid.c

diff --git a/security/apparmor/include/policy.h b/security/apparmor/include/policy.h
new file mode 100644
index 0000000..a53d9a4
--- /dev/null
+++ b/security/apparmor/include/policy.h
@@ -0,0 +1,321 @@
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
+
+struct aa_namespace *aa_find_namespace(const char *name);
+struct aa_namespace *aa_prepare_namespace(const char *name);
+void aa_profile_ns_list_release(void);
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
+struct aa_profile *aa_find_child(struct aa_profile *parent, const char *name);
+struct aa_profile *aa_find_profile(struct aa_namespace *ns, const char *name);
+struct aa_profile *aa_match_profile(struct aa_namespace *ns, const char *name);
+
+ssize_t aa_interface_add_profiles(void *data, size_t size);
+ssize_t aa_interface_replace_profiles(void *udata, size_t size);
+ssize_t aa_interface_remove_profiles(char *name, size_t size);
+
+/**
+ * aa_filter_profile - filter out profiles that shouldn't be used to mediate
+ * @profile: profile to filter
+ *
+ * does not change refcounts
+ *
+ * Return: @profile or NULL if it is filtered
+ */
+static inline struct aa_profile *aa_filter_profile(struct aa_profile *profile)
+{
+	if (profile->flags & PFLAG_UNCONFINED)
+		return NULL;
+	return profile;
+}
+
+
+/**
+ * aa_profile_newest - find the newest version of @profile
+ * @profile: the profile to check for newer versions of
+ *
+ * Find the newest version of @profile, if @profile is the newest version
+ * return @profile.
+ *
+ * NOTE: the profile returned is not refcounted, The refcount on @profile
+ * must be held until the caller decides what to do with the returned newest
+ * version.
+ */
+static inline struct aa_profile *aa_profile_newest(struct aa_profile *profile)
+{
+	if (unlikely(profile && profile->replacedby))
+		for (; profile->replacedby; profile = profile->replacedby) ;
+
+	return profile;
+}
+
+/**
+ * aa_confining_profile - find the newest confining profile version
+ * @p - profile to check if newest version
+ *
+ * NOTE: the profile returned is not refcounted, The refcount on @p
+ * must be held until the caller decides what to do with the returned newest
+ * version.
+ */
+static inline struct aa_profile *aa_confining_profile(struct aa_profile *p)
+{
+	return aa_filter_profile(aa_profile_newest(p));
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
index 0000000..22b2be9
--- /dev/null
+++ b/security/apparmor/policy.c
@@ -0,0 +1,1034 @@
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
+ * Each profile exists in an profile namespace which is a container of
+ * related profiles.  Each namespace contains a special "unconfined" profile,
+ * which doesn't enfforce any confinement on a task beyond DAC.
+ *
+ * Namespace and profile names can be written together in either
+ * of two syntaxes.
+ *	:namespace:profile - used by kernel interfaces for easy detection
+ *	namespace://profile - used by policy
+ *
+ * Profile names can not start with : or @ or ^ and may not contain \0
+ * 
+ * Reserved profile names
+ *	unconfined - special automatically generated unconfined profile
+ *	inherit - special name to indicate profile inheritance
+ *	null-XXXX-YYYY - special automically generated learning profiles
+ *
+ * Namespace names may not start with / or @ and may not contain \0 or :
+ * Reserved namespace namespace
+ *	default - the default namespace setup by AppArmor
+ *	user-XXXX - user defined profiles
+ *
+ * a // in a profile or namespace name indicates a compound name with the
+ * name before the // being the parent and the name after the child.
+ *
+ * Profile and namespace hierachies serve two different but similar purposes.
+ * The namespace contains the set of visible profiles that are considered
+ * for attachment.  The hierarchy of namespaces allows for virtualizing
+ * the namespace so that for example a chroot can have its own set of profiles
+ * which may define some local user namespaces.
+ * The profile hierachy severs two distinct purposes,
+ * -  it allows for sub profiles or hats, which allows an application to run
+ *    subprograms under its own profile with different restriction than it
+ *    self, and not have it use the system profile.
+ *    eg. if a mail program starts an editor, the policy might make the
+ *        restrictions tighter on the editor tighter than the mail program,
+ *        and definitely different than general editor restrictions
+ * - it allows for binary hierarchy of profiles, so that execution history
+ *   is preserved.  This feature isn't exploited by AppArmor reference policy
+ *   but is allowed.  NOTE: this is currently suboptimal because profile
+ *   aliasing is not currently implemented so that a profile for each
+ *   level must be defined.
+ *   eg. /bin/bash///bin/ls as a name would indicate /bin/ls was started
+ *       from /bin/bash
+ *   
+ * NOTES:
+ *   - hierarchical namespaces are not currently implemented.  Currently
+ *     there is only a flat set of namespaces.
+ *   - locking of profile lists is currently fairly coarse.  All profile
+ *     lists within a namespace use the namespace lock.
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
+#include "include/policy_unpack.h"
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
+	/* freed by common_free */
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
+static struct aa_policy_common *__common_strn_find(struct list_head *head,
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
+/**
+ * aa_alloc_default_namespace - allocate the base default namespace
+ *
+ * Returns 0 on success else error
+ * 
+ */
+int aa_alloc_default_namespace(void)
+{
+	struct aa_namespace *ns;
+	/* released by aa_free_default_namespace - used as list ref*/
+	ns = alloc_aa_namespace("default");
+	if (!ns)
+		return -ENOMEM;
+
+	/* released by aa_free_default_namespace - global var ref*/
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
+	write_unlock(&ns_list_lock);
+	/* drop the list ref and the global default_namespace ref */
+	aa_put_namespace(default_namespace);
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
+	/*
+	 * null profile is not added to the profile list,
+	 * released by free_aa_namespace
+	 */
+	ns->unconfined = alloc_aa_profile("unconfined");
+	if (!ns->unconfined)
+		goto fail_unconfined;
+
+	ns->unconfined->sid = aa_alloc_sid(AA_ALLOC_SYS_SID);
+	ns->unconfined->flags = PFLAG_UNCONFINED | PFLAG_IX_ON_NAME_ERROR |
+	    PFLAG_IMMUTABLE;
+
+	/*
+	 * released by free_aa_namespace, however aa_remove_namespace breaks
+	 * the cyclic references (ns->unconfined, and unconfinged->ns) and
+	 * replaces with refs to default namespace unconfined 
+	 */
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
+ * Requires: All references to the namespace must have been put, if the
+ *           namespace was referenced by a profile confining a task,
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
+/**
+ * __aa_find_namespace - find a namespace on a list by @name
+ * @name - name of namespace to look for
+ *
+ * Return: unrefcounted namespace
+ *
+ * Requires: ns_list_lock be held
+ */
+static struct aa_namespace *__aa_find_namespace(struct list_head *head,
+						const char *name)
+{
+	return (struct aa_namespace *)__common_find(head, name);
+}
+
+/**
+ * aa_find_namespace  -  look up a profile namespace on the namespace list
+ * @name: name of namespace to find
+ *
+ * Return: a pointer to the namespace on the list, or NULL if no namespace
+ * called @name exists.
+ *
+ * refcount released by caller
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
+/**
+ * aa_prepare_namespace - find an existing or create a new namespace of @name
+ * @name: the namespace to find or add
+ *
+ * Return: refcounted namespace or NULL if failed to create one
+ */
+struct aa_namespace *aa_prepare_namespace(const char *name)
+{
+	struct aa_namespace *ns;
+
+	write_lock(&ns_list_lock);
+	if (name)
+		/* released by caller */
+		ns = aa_get_namespace(__aa_find_namespace(&ns_list, name));
+	else
+		/* released by caller */
+		ns = aa_get_namespace(default_namespace);
+	if (!ns) {
+		struct aa_namespace *new_ns;
+		write_unlock(&ns_list_lock);
+		new_ns = alloc_aa_namespace(name);
+		if (!new_ns)
+			return NULL;
+		write_lock(&ns_list_lock);
+		/* test for race when new_ns was allocated */
+		ns = __aa_find_namespace(&ns_list, name);
+		if (!ns) {
+			list_add(&new_ns->base.list, &ns_list);
+			/* add list ref */
+			ns = aa_get_namespace(new_ns);
+		} else {
+			/* raced so free the new one */
+			free_aa_namespace(new_ns);
+			/* get reference on namespace */
+			aa_get_namespace(ns);
+		}
+	}
+	write_unlock(&ns_list_lock);
+
+	/* return ref */
+	return ns;
+}
+
+/**
+ * __aa_add_profile - add a profile to a list
+ * @common: the namespace or profile list to add it to
+ * @profile: the profile to add
+ *
+ * refcount @profile, should be put by __aa_remove_profile
+ *
+ * Requires: namespace list lock be held, or list not be shared
+ */
+void __aa_add_profile(struct aa_policy_common *common,
+		      struct aa_profile *profile)
+{
+	list_add(&profile->base.list, &common->profiles);
+	if (!(profile->flags & PFLAG_NO_LIST_REF))
+		/* get list reference */
+		aa_get_profile(profile);
+}
+
+/**
+ * __aa_remove_profile - remove a profile from the list it is one
+ * @profile: the profile to remove
+ *
+ * remove a profile from the list, warning generally removal should
+ * be done with __aa_replace_profile as most profile removals are
+ * should be replacements to the unconfined profile.
+ *
+ * put @profile refcount
+ *
+ * Requires: namespace list lock be held, or list not be shared
+ */
+void __aa_remove_profile(struct aa_profile *profile)
+{
+	list_del_init(&profile->base.list);
+	if (!(profile->flags & PFLAG_NO_LIST_REF))
+		/* release list reference */
+		aa_put_profile(profile);
+}
+
+/**
+ * __aa_replace_profile - replace @old with @new on a list
+ * @old: profile to be replaced
+ * @new: profile to replace @old with
+ *
+ * Will duplicaticate and refcount elements that @new inherits from @old
+ * and will inherit @old children.  If new is NULL it will replace to the
+ * 
+ *
+ * refcount @new for list, put @old list refcount
+ *
+ * Requires: namespace list lock be held, or list not be shared
+ */
+void __aa_replace_profile(struct aa_profile *old,
+			  struct aa_profile *new)
+{
+	struct aa_policy_common *common;
+	struct aa_profile *child, *tmp;
+
+	if (old->parent)
+		common = &old->parent->base;
+	else
+		common = &old->ns->base;
+
+	if (new) {
+		/* released when @new is freed */
+		new->parent = aa_get_profile(old->parent);
+		new->ns = aa_get_namespace(old->ns);
+		new->sid = old->sid;
+		__aa_add_profile(common, new);
+	} else {
+		/* refcount not taken, held via @old refcount */
+		new = old->ns->unconfined;
+	}
+
+	/* inherit children */
+	list_for_each_entry_safe(child, tmp, &old->base.profiles, base.list) {
+		aa_put_profile(child->parent);
+		child->parent = aa_get_profile(new);
+		/* list refcount transfered to @new*/
+		list_move(&child->base.list, &new->base.profiles);
+	}
+
+	/* released by free_aa_profile */
+	old->replacedby = aa_get_profile(new);
+	__aa_remove_profile(old);
+}
+
+/**
+ * __aa_profile_list_release - remove all profiles on the list and put refs
+ * @head: list of profiles
+ *
+ * Requires: namespace lock be held
+ */
+void __aa_profile_list_release(struct list_head *head)
+{
+	struct aa_profile *profile, *tmp;
+	list_for_each_entry_safe(profile, tmp, head, base.list) {
+		/* release any children lists first */
+		__aa_profile_list_release(&profile->base.profiles);
+		__aa_replace_profile(profile, NULL);
+	}
+}
+
+/**
+ * __aa_remove_namespace - remove a namespace and all its children
+ * @ns: namespace to be removed
+ * 
+ * Requires: ns_list_lock && ns->base.lock be held
+ */
+void __aa_remove_namespace(struct aa_namespace *ns)
+{
+	struct aa_profile *unconfined = ns->unconfined;
+	/* remove ns from namespace list */
+	list_del_init(&ns->base.list);
+
+	/*
+	 * break the ns, unconfined profile cyclic reference and forward
+	 * all new unconfined profiles requests to the default namespace
+	 * This will result in all confined tasks that have a profile
+	 * being removed inheriting the default->unconfined profile.
+	 */
+	ns->unconfined = aa_get_profile(default_namespace->unconfined);
+	__aa_profile_list_release(&ns->base.profiles);
+	/* release original ns->unconfined ref */
+	aa_put_profile(unconfined);
+	/* release ns->base.list ref, from removal above */
+	aa_put_namespace(ns);
+}
+
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
+ * Returns NULL on failure, else refcounted profile
+ */
+struct aa_profile *alloc_aa_profile(const char *fqname)
+{
+	struct aa_profile *profile;
+
+	/* freed by free_aa_profile - usually through aa_put_profile */
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
+	/* base.name is a substring of fqname */
+	profile->base.name =
+	    (char *)fqname_subname((const char *)profile->fqname);
+
+	/* return ref */
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
+	/* freed below */
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
+	/* released on free_aa_profile */
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
+	/* free children profiles */
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
+/**
+ * __aa_find_child - find a profile on @head list with a name matching @name
+ * @head: list to search
+ * @name: name of profile
+ *
+ * Requires: ns lock protecting list be held
+ *
+ * Returns unrefcounted profile ptr, or NULL if not found
+ */
+static struct aa_profile *__aa_find_child(struct list_head *head,
+					  const char *name)
+{
+	return (struct aa_profile *)__common_find(head, name);
+}
+
+/**
+ * __aa_strn_find_child - find a profile on @head list using substring of @name
+ * @head: list to search
+ * @name: name of profile
+ * @len: length of @name substring to match
+ *
+ * Requires: ns lock protecting list be held
+ *
+ * Returns unrefcounted profile ptr, or NULL if not found
+ */
+static struct aa_profile *__aa_strn_find_child(struct list_head *head,
+					       const char *name, int len)
+{
+	return (struct aa_profile *)__common_strn_find(head, name, len);
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
+	profile = aa_get_profile(__aa_find_child(&parent->base.profiles, name));
+	read_unlock(&parent->ns->base.lock);
+
+	return profile;
+}
+
+/**
+ * __aa_find_parent - lookup the parent of a profile of name @fqname
+ * @ns: namespace to lookup profile in
+ * @fqname: fully qualified profile name to find parent of
+ *
+ * Lookups up the parent of a fully qualified profile name, the profile
+ * that matches fqname does not need to exist, in general this
+ * is used to load a new profile.
+ *
+ * Requires: ns->base.lock be held
+ *
+ * Returns: unrefcounted common or NULL if not found
+ */
+static struct aa_policy_common *__aa_find_parent(struct aa_namespace *ns,
+						 const char *fqname)
+{
+	struct aa_policy_common *common;
+	struct aa_profile *profile = NULL;
+	char *split;
+
+	common = &ns->base;
+
+	for (split = strstr(fqname, "//"); split;) {
+		profile = __aa_strn_find_child(&common->profiles, fqname,
+					       split - fqname);
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
+/**
+ * __aa_find_profile - lookup the profile matching @fqname
+ * @ns: namespace to search for profile in
+ * @fqname: fully qualified profile name
+ *
+ * Requires: ns->base.lock be held
+ *
+ * Returns: unrefcounted profile pointer or NULL if not found
+ */
+static struct aa_profile *__aa_find_profile(struct aa_namespace *ns,
+					    const char *fqname)
+{
+	struct aa_policy_common *common;
+	struct aa_profile *profile = NULL;
+	char *split;
+
+	common = &ns->base;
+	for (split = strstr(fqname, "//"); split;) {
+		profile = __aa_strn_find_child(&common->profiles, fqname,
+						 split - fqname);
+		if (!profile)
+			return NULL;
+
+		common = &profile->base;
+		fqname = split + 2;
+		split = strstr(fqname, "//");
+	}
+
+	profile = __aa_find_child(&common->profiles, fqname);
+
+	return profile;
+}
+
+/**
+ * aa_find_profile_by_name - find a profile by its full or partial name
+ * @ns: the namespace to start from
+ * @fqname: name to do lookup on.  Does not contain namespace prefix
+ *
+ * Returns: refcounted profile or NULL if not found 
+ */
+struct aa_profile *aa_find_profile(struct aa_namespace *ns, const char *fqname)
+{
+	struct aa_profile *profile;
+
+	read_lock(&ns->base.lock);
+	profile = aa_get_profile(__aa_find_profile(ns, fqname));
+	read_unlock(&ns->base.lock);
+	return profile;
+}
+
+/**
+ * aa_interface_add_profiles - Unpack and add new profile(s) to the profile list
+ * @data: serialized data stream
+ * @size: size of the serialized data stream
+ */
+ssize_t aa_interface_add_profiles(void *udata, size_t size)
+{
+	struct aa_profile *profile;
+	struct aa_namespace *ns = NULL;
+	struct aa_policy_common *common;
+	ssize_t error;
+	struct aa_audit_iface sa = {
+		.base.operation = "profile_load",
+		.base.gfp_mask = GFP_KERNEL,
+	};
+
+	/* check if loading policy is locked out */
+	if (aa_g_lock_policy)
+		return -EACCES;
+
+	/* released below */
+	profile = aa_unpack(udata, size, &sa);
+	if (IS_ERR(profile))
+		return PTR_ERR(profile);
+
+	/* released below */
+	ns = aa_prepare_namespace(sa.name2);
+	if (IS_ERR(ns)) {
+		sa.base.info = "failed to prepare namespace";
+		sa.base.error = PTR_ERR(ns);
+		goto fail;
+	}
+	/* profiles are currently loaded flat with fqnames */
+	sa.name = profile->fqname;
+
+	write_lock(&ns->base.lock);
+
+	/* no ref on common only use inside of lock */
+	common = __aa_find_parent(ns, sa.name);
+	if (!common) {
+		sa.base.info = "parent does not exist";
+		sa.base.error = -ENOENT;
+		goto fail2;
+	}
+
+	if (common != &ns->base)
+		/* released on profile replacement or free_aa_profile */
+		profile->parent = aa_get_profile((struct aa_profile *)common);
+
+	if (__aa_find_child(&common->profiles, profile->base.name)) {
+		/* A profile with this name exists already. */
+		sa.base.info = "profile already exists";
+		sa.base.error = -EEXIST;
+		goto fail2;
+	}
+	/* released on free_aa_profile */
+	profile->sid = aa_alloc_sid(AA_ALLOC_SYS_SID);
+	profile->ns = aa_get_namespace(ns);
+	__aa_add_profile(common, profile);
+	write_unlock(&ns->base.lock);
+
+	error = aa_audit_iface(&sa);
+	aa_put_namespace(ns);
+	aa_put_profile(profile);
+	if (error)
+		return error;
+	return size;
+
+fail2:
+	write_unlock(&ns->base.lock);
+
+fail:
+	error = aa_audit_iface(&sa);
+	aa_put_namespace(ns);
+	aa_put_profile(profile);
+	return error;
+}
+
+/**
+ * aa_interface_replace_profiles - replace profile(s) on the profile list
+ * @udata: serialized data stream
+ * @size: size of the serialized data stream
+ *
+ * unpack and replace a profile on the profile list and uses of that profile
+ * by any aa_task_context.  If the profile does not exist on the profile list
+ * it is added.  Return %0 or error.
+ */
+ssize_t aa_interface_replace_profiles(void *udata, size_t size)
+{
+	struct aa_policy_common *common;
+	struct aa_profile *old_profile = NULL, *new_profile;
+	struct aa_namespace *ns;
+	ssize_t error;
+	struct aa_audit_iface sa = {
+		.base.operation = "profile_replace",
+		.base.gfp_mask = GFP_KERNEL,
+	};
+
+	/* check if loading policy is locked out */
+	if (aa_g_lock_policy)
+		return -EACCES;
+
+	/* released below */
+	new_profile = aa_unpack(udata, size, &sa);
+	if (IS_ERR(new_profile))
+		return PTR_ERR(new_profile);
+
+	/* released below */
+	ns = aa_prepare_namespace(sa.name2);
+	if (!ns) {
+		sa.base.info = "failed to prepare namespace";
+		sa.base.error = -ENOMEM;
+		goto fail;
+	}
+
+	sa.name = new_profile->fqname;
+
+	write_lock(&ns->base.lock);
+	/* no ref on common only use inside lock */
+	common = __aa_find_parent(ns, sa.name);
+
+	if (!common) {
+		sa.base.info = "parent does not exist";
+		sa.base.error = -ENOENT;
+		goto fail2;
+	}
+
+	old_profile = __aa_find_child(&common->profiles,
+				      new_profile->base.name);
+	/* released below */
+	aa_get_profile(old_profile);
+	if (old_profile && old_profile->flags & PFLAG_IMMUTABLE) {
+		sa.base.info = "cannot replace immutible profile";
+		sa.base.error = -EPERM;
+		goto fail2;
+	} else if (old_profile) {
+		__aa_replace_profile(old_profile, new_profile);
+	} else {
+		__aa_add_profile(common, new_profile);
+		new_profile->sid = aa_alloc_sid(AA_ALLOC_SYS_SID);
+	}
+
+	write_unlock(&ns->base.lock);
+
+	if (!old_profile)
+		sa.base.operation = "profile_load";
+
+	error = aa_audit_iface(&sa);
+	aa_put_namespace(ns);
+	aa_put_profile(old_profile);
+	aa_put_profile(new_profile);
+	if (error)
+		return error;
+	return size;
+
+fail2:
+	write_unlock(&ns->base.lock);
+fail:
+	error = aa_audit_iface(&sa);
+	aa_put_namespace(ns);
+	aa_put_profile(old_profile);
+	aa_put_profile(new_profile);
+	return error;
+}
+
+/**
+ * aa_interface_remove_profiles - remove profile(s) from the system
+ * @name: name of the profile to remove
+ * @size: size of the name
+ *
+ * remove a profile from the profile list and all aa_task_context references
+ * to said profile.
+ * NOTE: removing confinement does not restore rlimits to preconfinemnet values
+ */
+ssize_t aa_interface_remove_profiles(char *name, size_t size)
+{
+	struct aa_namespace *ns;
+	struct aa_profile *profile;
+	struct aa_audit_iface sa = {
+		.base.operation = "profile_remove",
+		.base.gfp_mask = GFP_KERNEL,
+	};
+
+	/* check if loading policy is locked out */
+	if (aa_g_lock_policy)
+		return -EACCES;
+
+	write_lock(&ns_list_lock);
+	if (name[0] == ':') {
+		char *ns_name;
+		name = aa_split_name_from_ns(name, &ns_name);
+		/* released below */
+		ns = aa_get_namespace(__aa_find_namespace(&ns_list, ns_name));
+	} else {
+		/* released below */
+		ns = aa_get_namespace(default_namespace);
+	}
+
+	if (!ns) {
+		sa.base.info = "failed: namespace does not exist";
+		goto fail_ns_list_lock;
+	}
+
+	sa.name2 = ns->base.name;
+	write_lock(&ns->base.lock);
+	if (!name) {
+		/* remove namespace */
+		if (ns == default_namespace)
+			__aa_profile_list_release(&ns->base.profiles);
+		else
+			__aa_remove_namespace(ns);
+	} else {
+		/* released below - remove profile */
+		profile = aa_get_profile(__aa_find_profile(ns, name));
+		if (!profile) {
+			sa.name = name;
+			sa.base.info = "failed: profile does not exist";
+			goto fail_ns_lock;
+		}
+		sa.name = profile->fqname;
+		__aa_profile_list_release(&profile->base.profiles);
+		__aa_replace_profile(profile, NULL);
+	}
+	write_unlock(&ns->base.lock);
+	write_unlock(&ns_list_lock);
+
+	aa_audit_iface(&sa);
+	aa_put_profile(profile);
+	aa_put_namespace(ns);
+	return size;
+
+fail_ns_lock:
+	write_unlock(&ns->base.lock);
+
+fail_ns_list_lock:
+	write_unlock(&ns_list_lock);
+	aa_audit_iface(&sa);
+	aa_put_namespace(ns);
+	return -ENOENT;
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

