Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbZKVLtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbZKVLtu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 06:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbZKVLtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 06:49:49 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:62879 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbZKVLtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 06:49:47 -0500
To: john.johansen@canonical.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [AppArmor #3 0/12] AppArmor security module
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1257869585-7092-1-git-send-email-john.johansen@canonical.com>
	<200911210239.DCI56207.HQFOVOJOSLMFFt@I-love.SAKURA.ne.jp>
	<200911211428.JJH90667.LFOJFMSQVOFOtH@I-love.SAKURA.ne.jp>
In-Reply-To: <200911211428.JJH90667.LFOJFMSQVOFOtH@I-love.SAKURA.ne.jp>
Message-Id: <200911222049.BCG40864.HVQMOOFtLFJOSF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 22 Nov 2009 20:49:51 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And the rest of files...



Regarding match.c

Why not to start YYTD_ID_something from 0 so that we can avoid "- 1" in
dfa->tables[table->td_id - 1] ? I think you can do "- 1" at

	th.td_id = be16_to_cpu(*(u16 *) (blob));

.



> int unpack_dfa(struct aa_dfa *dfa, void *blob, size_t size)
> {
(...snipped...)
> fail:
> 	for (i = 0; i < ARRAY_SIZE(dfa->tables); i++) {
> 		free_table(dfa->tables[i]);
> 		dfa->tables[i] = NULL;
> 	}

This function is called by only aa_unpack_dfa(), and aa_unpack_dfa() calls
aa_match_free(). Thus, you don't need to call free_table() here.

> 	return error;
> }



Regarding net.c

> static void audit_cb(struct audit_buffer *ab, void *va)
> {
> 	struct aa_audit_net *sa = va;

static void audit_cb(struct audit_buffer *ab, struct aa_audit *va)
{
	struct aa_audit_net *sa = container_of(va, struct aa_audit_net, base);

> static int aa_audit_net(struct aa_profile *profile, struct aa_audit_net *sa)
> {
(...snipped...)
> 	return aa_audit(type, profile, (struct aa_audit *)sa, audit_cb);

	return aa_audit(type, profile, &sa->base, audit_cb);

> }



Regarding policy.c

> struct aa_namespace *alloc_aa_namespace(const char *name)

This function could be "static". Please try "make namespacecheck".



> struct aa_namespace *aa_prepare_namespace(const char *name)

This function could be "static".

> {
> 	struct aa_namespace *ns;
> 
> 	write_lock(&ns_list_lock);
> 	if (name)
> 		/* released by caller */
> 		ns = aa_get_namespace(__aa_find_namespace(&ns_list, name));
> 	else
> 		/* released by caller */
> 		ns = aa_get_namespace(default_namespace);

alloc_aa_namespace() returns NULL if name == NULL.
If it is intended behavior, you may do like

	else {
 		/* released by caller */
		ns = aa_get_namespace(default_namespace);
		write_unlock(&ns_list_lock);
		return ns;
	}

> 	if (!ns) {
> 		struct aa_namespace *new_ns;
> 		write_unlock(&ns_list_lock);
> 		new_ns = alloc_aa_namespace(name);
> 		if (!new_ns)
> 			return NULL;
> 		write_lock(&ns_list_lock);
> 		/* test for race when new_ns was allocated */
> 		ns = __aa_find_namespace(&ns_list, name);
> 		if (!ns) {
> 			list_add(&new_ns->base.list, &ns_list);
> 			/* add list ref */
> 			ns = aa_get_namespace(new_ns);
> 		} else {
> 			/* raced so free the new one */
> 			free_aa_namespace(new_ns);
> 			/* get reference on namespace */
> 			aa_get_namespace(ns);
> 		}
> 	}
> 	write_unlock(&ns_list_lock);
> 
> 	/* return ref */
> 	return ns;
> }



> void __aa_replace_profile(struct aa_profile *old,
> 			  struct aa_profile *new)

This function could be "static".



> void __aa_profile_list_release(struct list_head *head)

This function could be "static".



> void __aa_remove_namespace(struct aa_namespace *ns)

This function could be "static".

> {
> 	struct aa_profile *unconfined = ns->unconfined;
> 	/* remove ns from namespace list */
> 	list_del_init(&ns->base.list);
> 
> 	/*
> 	 * break the ns, unconfined profile cyclic reference and forward
> 	 * all new unconfined profiles requests to the default namespace
> 	 * This will result in all confined tasks that have a profile
> 	 * being removed inheriting the default->unconfined profile.
> 	 */
> 	ns->unconfined = aa_get_profile(default_namespace->unconfined);
> 	__aa_profile_list_release(&ns->base.profiles);
> 	/* release original ns->unconfined ref */
> 	aa_put_profile(unconfined);
> 	/* release ns->base.list ref, from removal above */
> 	aa_put_namespace(ns);

aa_put_profile() and aa_put_namespace() may call write_lock() inside
free_aa_profile(). Are you sure that these calls do not dead lock?

> }



> ssize_t aa_interface_remove_profiles(char *name, size_t size)
(...snipped...)
> 	write_lock(&ns_list_lock);
> 	if (name[0] == ':') {
> 	char *ns_name;
> 	name = aa_split_name_from_ns(name, &ns_name);
> 	/* released below */
> 	ns = aa_get_namespace(__aa_find_namespace(&ns_list, ns_name));

aa_split_name_from_ns() may set ns_name to NULL but __aa_find_namespace() can't
handle ns_name == NULL case. I think you should check ns_name != NULL.



Regarding policy_unpack.c

Please use bool for functions that return 0 or 1.



> static void audit_cb(struct audit_buffer *ab, void *va)
> {
> 	struct aa_audit_iface *sa = va;

static void audit_cb(struct audit_buffer *ab, struct aa_audit *va)
{
	struct aa_audit_iface *sa = container_of(va, struct aa_audit_iface,
						 base);



> static int aa_unpack_trans_table(struct aa_ext *e, struct aa_profile *profile)
(...snipped...)
> 		for (i = 0; i < size; i++) {
> 			char *tmp;
> 			if (!unpack_dynstring(e, &tmp, NULL))
> 				goto fail;
> 			/*
> 			 * note: strings beginning with a : have an embedded
> 			 * \0 seperating the profile ns name from the profile
> 			 * name
> 			 */
> 			profile->file.trans.table[i] = tmp;

unpack_dynstring() returns string duplicated by kstrdup(). Thus, "tmp" can't
have an embedded \0 seperating the profile ns name from the profile name
even if tmp[0] == ':' is true, can it?

> 		}



Regarding resource.c

> static void audit_cb(struct audit_buffer *ab, void *va)
> {
> 	struct aa_audit_resource *sa = va;

static void audit_cb(struct audit_buffer *ab, struct aa_audit *va)
{
	struct aa_audit_resource *sa = container_of(va, struct aa_audit_resource,
						    base);



> static int aa_audit_resource(struct aa_profile *profile,
> 			     struct aa_audit_resource *sa)
> {
> 	return aa_audit(AUDIT_APPARMOR_AUTO, profile, (struct aa_audit *)sa,
> 			audit_cb);

	return aa_audit(AUDIT_APPARMOR_AUTO, profile, &sa->base, audit_cb);

> }



Regarding sid.c

> int aa_add_sid_profile(u32 sid, struct aa_profile *profile)

This function is not used.



> int aa_replace_sid_profile(u32 sid, struct aa_profile *profile)

This function is not used.



> struct aa_profile *aa_get_sid_profile(u32 sid)

This function is not used.
