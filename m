Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbYE2CqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbYE2CqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 22:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbYE2CqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 22:46:08 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:45292 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbYE2CqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 22:46:06 -0400
Subject: Re: [RFC][PATCH 4/5]integrity: Linux Integrity Module(LIM)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com,
       Stephen Smalley <sds@tycho.nsa.gov>,
       CaseySchaufler <casey@schaufler-ca.com>
In-Reply-To: <20080528004610.fde47571.akpm@linux-foundation.org>
References: <1211555133.16195.17.camel@new-host>
	 <20080528004610.fde47571.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 28 May 2008 22:46:02 -0400
Message-Id: <1212029162.4747.27.camel@new-host.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-28 at 00:46 -0700, Andrew Morton wrote: 
> On Fri, 23 May 2008 11:05:33 -0400 Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > This is a request for comments for a redesign of the integrity patches.
> >
> > ...
> >
> > +int register_template(char *template_name,
> > +			struct template_operations *template_ops)
> > +{
> > +	int template_len;
> > +	struct template_list_entry *entry;
> > +
> > +	if (!template_initialized++) {
> > +		INIT_LIST_HEAD(&integrity_templates);
> > +		mutex_init(&integrity_templates_mutex);
> > +	}
> > +
> > +	entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
> > +	INIT_LIST_HEAD(&entry->template);
> > +
> > +	template_len = strlen(template_name);
> > +	if (template_len > TEMPLATE_NAME_LEN_MAX)
> > +		template_len = TEMPLATE_NAME_LEN_MAX;
> > +	memcpy(entry->template_name, template_name, template_len);
> > +	entry->template_name[template_len] = '\0';
> > +	entry->template_ops = template_ops;
> > +
> > +	mutex_lock(&integrity_templates_mutex);
> > +	list_add_rcu(&entry->template, &integrity_templates);
> > +	mutex_unlock(&integrity_templates_mutex);
> > +	synchronize_rcu();
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(register_template);
> 
> Should be integrity_register_template()?

yes, definitely.

> > +/**
> > + * unregister_template
> > + * @template_name: a pointer to a string containing the template name.
> > + *
> > + * Unregister the template functions
> > + */
> > +int unregister_template(char *template_name)
> > +{
> > +	struct template_list_entry *entry;
> > +
> > +	mutex_lock(&integrity_templates_mutex);
> > +	list_for_each_entry(entry, &integrity_templates, template) {
> > +		if (strncmp(entry->template_name, template_name,
> > +			    strlen(entry->template_name)) == 0) {
> > +			list_del_rcu(&entry->template);
> > +			mutex_unlock(&integrity_templates_mutex);
> > +			synchronize_rcu();
> > +			kfree(entry);
> > +			return 0;
> > +		}
> > +	}
> > +	mutex_unlock(&integrity_templates_mutex);
> > +	return -EINVAL;
> > +}
> > +EXPORT_SYMBOL_GPL(unregister_template);
> 
> Similarly.

Ok

> > +/**
> > + * integrity_find_template
> > + * @template_name: a pointer to a string containing the template name.
> > + * @template_ops: a pointer to the template functions
> > + *
> > + * Find the template functions based on the template name.
> > + */
> > +int integrity_find_template(char *template_name,
> > +				struct template_operations **template_ops)
> > +{
> > +	struct template_list_entry *entry;
> > +
> > +	rcu_read_lock();
> > +	list_for_each_entry_rcu(entry, &integrity_templates, template) {
> > +		if (strncmp(entry->template_name, template_name,
> > +			    strlen(entry->template_name)) == 0) {
> > +			*template_ops = entry->template_ops;
> > +			rcu_read_unlock();
> > +			return 0;
> > +		}
> > +	}
> > +	rcu_read_unlock();
> > +	return 1;
> > +}
> > +EXPORT_SYMBOL_GPL(integrity_find_template);
> 
> Strange locking.  We take the rcu_read_lock then locate a pointer to an
> object then drop the lock, returning that pointer while doing nothing
> to ensure the stability of the returned object?

yep, I messed up the locking here.  Will fix it.

> >
> > ...
> >
> > +#define set_to_dummy_if_null(ops, function)				\
> > +	do {								\
> > +		if (!ops->function) {					\
> > +			ops->function = dummy_##function;		\
> > +			printk(KERN_INFO "Had to override the " #function \
> > +			" integrity operation with the dummy one.\n");\
> > +			}						\
> > +	} while (0)
> 
> hrm.
> 
> Probably the message should identify where it came from?  "integrity:
> had to override ..."

Ok.

> >
> > ...
> >
> > @@ -1036,6 +1038,7 @@ struct dentry *d_instantiate_unique(stru
> >  	spin_unlock(&dcache_lock);
> >  
> >  	if (!result) {
> > +		integrity_d_instantiate(entry, inode);
> >  		security_d_instantiate(entry, inode);
> >  		return NULL;
> >  	}
> > @@ -1173,6 +1176,7 @@ struct dentry *d_splice_alias(struct ino
> >  			BUG_ON(!(new->d_flags & DCACHE_DISCONNECTED));
> >  			fsnotify_d_instantiate(new, inode);
> >  			spin_unlock(&dcache_lock);
> > +			integrity_d_instantiate(new, inode);
> >  			security_d_instantiate(new, inode);
> >  			d_rehash(dentry);
> >  			d_move(new, dentry);
> > @@ -1183,6 +1187,7 @@ struct dentry *d_splice_alias(struct ino
> >  			dentry->d_inode = inode;
> >  			fsnotify_d_instantiate(dentry, inode);
> >  			spin_unlock(&dcache_lock);
> > +			integrity_d_instantiate(dentry, inode);
> >  			security_d_instantiate(dentry, inode);
> >  			d_rehash(dentry);
> >  		}
> > @@ -1733,6 +1738,7 @@ found:
> >  	spin_unlock(&dcache_lock);
> >  out_nolock:
> >  	if (actual == dentry) {
> > +		integrity_d_instantiate(dentry, inode);
> >  		security_d_instantiate(dentry, inode);
> >  		return NULL;
> >  	}
> 
> I'm trying to find a non-trivial ->d_instantiate() implementation to
> see how much overhead is being added to these performance-critical
> codepaths, but afaict this patchset doesn't add one?

The current IMA, as a stand alone integrity provider, does not use 
integrity_d_instantiate.  It was used by EVM to verify the integrity 
of the hash and store the results in i_integrity.
(Refer to 2.6.22-rc1-mm1-broken-out.tar.bz2) 

We could defer this discussion by removing it for now, as it is not 
being used by the IMA.

> > Index: linux-2.6.26-rc3-git2/fs/ext3/xattr_security.c
> > ===================================================================
> > --- linux-2.6.26-rc3-git2.orig/fs/ext3/xattr_security.c
> > +++ linux-2.6.26-rc3-git2/fs/ext3/xattr_security.c
> > @@ -9,6 +9,7 @@
> >  #include <linux/ext3_jbd.h>
> >  #include <linux/ext3_fs.h>
> >  #include <linux/security.h>
> > +#include <linux/integrity.h>
> >  #include "xattr.h"
> >  
> >  static size_t
> > @@ -57,12 +58,19 @@ ext3_init_security(handle_t *handle, str
> >  
> >  	err = security_inode_init_security(inode, dir, &name, &value, &len);
> >  	if (err) {
> > +		/* Even if creation of the security xattr fails, must
> > +		 * indicate this is a new inode. */
> > +		integrity_inode_init_integrity(inode, dir, NULL, NULL, NULL);
> >  		if (err == -EOPNOTSUPP)
> >  			return 0;
> >  		return err;
> >  	}
> >  	err = ext3_xattr_set_handle(handle, inode, EXT3_XATTR_INDEX_SECURITY,
> >  				    name, value, len, 0);
> > +
> > +	integrity_inode_init_integrity(inode, dir, &name, &value, &len);
> > +	err = ext3_xattr_set_handle(handle, inode, EXT3_XATTR_INDEX_SECURITY,
> > +				    name, value, len, 0);
> 
> Can we put the integrity_inode_init_integrity() call into
> security_inode_init_security() thus avoiding having to change lots of
> filesystems?

That is fine by me, not sure how others feel.

> >  	kfree(name);
> >  	kfree(value);
> >  	return err;
> >
> > ...
> >
> > @@ -17,6 +17,7 @@
> >  #include <linux/hash.h>
> >  #include <linux/swap.h>
> >  #include <linux/security.h>
> > +#include <linux/integrity.h>
> >  #include <linux/pagemap.h>
> >  #include <linux/cdev.h>
> >  #include <linux/bootmem.h>
> > @@ -160,6 +161,14 @@ static struct inode *alloc_inode(struct 
> >  		init_rwsem(&inode->i_alloc_sem);
> >  		lockdep_set_class(&inode->i_alloc_sem, &sb->s_type->i_alloc_sem_key);
> >  
> > +		if (integrity_inode_alloc(inode)) {
> > +			if (inode->i_sb->s_op->destroy_inode)
> > +				inode->i_sb->s_op->destroy_inode(inode);
> > +			else
> > +				kmem_cache_free(inode_cachep, (inode));
> > +			return NULL;
> > +		}
> 
> This code is uncommented and integrity_inode_alloc() also is
> uncommented.  People will want to know what's going on, please.

integrity_inode_alloc() is the wrapper which calls inode_alloc_integrity(). 
It is commented in integrity.h.  I'll comment the code here as well.

> Again, where do we go to see how much overhead is being added to these
> codepaths?

The IMA patch(5/5) instantiates the inode_alloc_integrity hook.
	.inode_alloc_integrity = ima_inode_alloc_integrity,

> >  		mapping->a_ops = &empty_aops;
> >   		mapping->host = inode;
> >  		mapping->flags = 0;
> > @@ -190,6 +199,7 @@ void destroy_inode(struct inode *inode) 
> >  {
> >  	BUG_ON(inode_has_buffers(inode));
> >  	security_inode_free(inode);
> > +	integrity_inode_free(inode);
> >  	if (inode->i_sb->s_op->destroy_inode)
> >  		inode->i_sb->s_op->destroy_inode(inode);
> >  	else
> >
> > ...
> >
> > --- linux-2.6.26-rc3-git2.orig/include/linux/fs.h
> > +++ linux-2.6.26-rc3-git2/include/linux/fs.h
> > @@ -653,6 +653,9 @@ struct inode {
> >  #ifdef CONFIG_SECURITY
> >  	void			*i_security;
> >  #endif
> > +#ifdef CONFIG_INTEGRITY
> > +	void			*i_integrity;
> > +#endif
> 
> Does this _have_ to be a void*?  Something typesafe would be far
> preferable.

Different integrity providers will define it differently, using 
their specific data structure.

> >  	void			*i_private; /* fs or device private pointer */
> >  };
> >  
> > ...
> >
> > @@ -521,6 +528,7 @@ extern int audit_signals;
> >  #define audit_get_loginuid(t) (-1)
> >  #define audit_get_sessionid(t) (-1)
> >  #define audit_log_task_context(b) do { ; } while (0)
> > +#define audit_log_inode_context(b, a) do { ; } while (0)
> 
> static inline C functions are preferable.
> 
> The ";" inside the {} is unneeded.

Ok

> >  #define audit_ipc_obj(i) ({ 0; })
> >  #define audit_ipc_set_perm(q,u,g,m) ({ 0; })
> >  #define audit_bprm(p) ({ 0; })
> > Index: linux-2.6.26-rc3-git2/security/integrity/integrity_audit.c
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6.26-rc3-git2/security/integrity/integrity_audit.c
> > @@ -0,0 +1,73 @@
> > +/*
> > + * Copyright (C) 2008 IBM Corporation
> > + * Author: Mimi Zohar <zohar@us.ibm.com>
> > + *
> > + *      This program is free software; you can redistribute it and/or modify
> > + *      it under the terms of the GNU General Public License as published by
> > + *      the Free Software Foundation, version 2 of the License.
> > + *
> > + * File: integrity_audit.c
> > + * 	Audit calls for the integrity subsystem
> > + */
> > +
> > +#include <linux/audit.h>
> > +#include <linux/fs.h>
> > +#include <linux/integrity.h>
> > +
> > +#ifdef CONFIG_INTEGRITY_AUDIT
> > +static int integrity_audit = 1;
> > +
> > +static int __init integrity_audit_setup(char *str)
> > +{
> > +	char *op;
> > +
> > +	integrity_audit = simple_strtol(str, NULL, 0);
> 
> This will treat "42foo" as valid input.  strict_strtoul() fixes that.

Thank you for pointing this out.

> > +	op = integrity_audit ? "integrity_audit_enabled" :
> > +	    "integrity_audit_not_enabled";
> > +	integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL, NULL, NULL, op, 0);
> > +	return 1;
> > +}
> > +
> > +__setup("integrity_audit=", integrity_audit_setup);
> > +#else
> > +static int integrity_audit = 1;
> 
> This could be outside the ifdef.  If it is correct?

Yes, will fix it.

> > +#endif
> > +
> > +void integrity_audit_msg(int audit_msgno, struct inode *inode,
> > +			 const unsigned char *fname, char *op,
> > +			 char *cause, int result)
> > +{
> > +	struct audit_buffer *ab;
> > +	if (!integrity_audit && result == 1)
> > +		return;
> 
> A newline between end-of-declarations and start-of-code is conventional.

Of course, don't know how I missed it.

> > +	ab = audit_log_start(current->audit_context, GFP_ATOMIC, audit_msgno);
> > +	audit_log_format(ab, "integrity: pid=%d uid=%u auid=%u",
> > +			 current->pid, current->uid,
> > +			 audit_get_loginuid(current));
> > +	audit_log_task_context(ab);
> > +	switch (audit_msgno) {
> > +	case AUDIT_INTEGRITY_DATA:
> > +	case AUDIT_INTEGRITY_METADATA:
> > +	case AUDIT_INTEGRITY_PCR:
> > +		audit_log_format(ab, " op=%s cause=%s", op, cause);
> > +		break;
> > +	case AUDIT_INTEGRITY_HASH:
> > +		audit_log_format(ab, " op=%s hash=%s", op, cause);
> > +		break;
> > +	case AUDIT_INTEGRITY_STATUS:
> > +	default:
> > +		audit_log_format(ab, " op=%s", op);
> > +	}
> > +	audit_log_format(ab, " comm=");
> > +	audit_log_untrustedstring(ab, current->comm);
> > +	if (fname) {
> > +		audit_log_format(ab, " name=");
> > +		audit_log_untrustedstring(ab, fname);
> > +	}
> > +	if (inode)
> > +		audit_log_format(ab, " dev=%s ino=%lu",
> > +				 inode->i_sb->s_id, inode->i_ino);
> > +	audit_log_format(ab, " res=%d", result);
> > +	audit_log_end(ab);
> > +}
> >
> > ...
> >
> > +static struct integrity_measure_rule_entry default_rules[] = {
> > +	{{NULL, NULL}, NULL, NULL, FILE_MMAP, MAY_EXEC},
> > +	{{NULL, NULL}, NULL, NULL, BPRM_CHECK, MAY_EXEC},
> > +	{{NULL, NULL}, NULL, NULL, INODE_PERMISSION, MAY_READ},
> > +};
> 
> Can we use the
> 
> 	.field = value,
> 
> format here please?  That will permit the omission of all the NULLs.

np

> > +static struct list_head measure_default_rules;
> > +static struct list_head measure_policy_rules;
> > +static struct list_head *integrity_measure;
> > +
> > +static DEFINE_MUTEX(integrity_measure_mutex);
> > +
> > +/**
> > + * integrity_measure_rules - determine whether an inode matches the given rule.
> > + * @rule - a pointer to a rule
> > + * @inode - a pointer to an inode
> > + * @func - LIM hook identifier
> > + * @mask - requested action (MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)
> > + *
> > + * Returns 1 on rule match, 0 on failure.
> > + */
> 
> What a strange name.  integrity_match_rules()

The match decision, here, is deciding whether or not to measure 
a file.  

The functions below are called: integrity_measure_policy_init(), 
integrity_measure_policy_complete(), integrity_measure_policy_add().
To parallel the rest of the names, then the function here would be 
integrity_measure_rules_match().  Or I could remove 'measure'
from all of the function names, as you're suggesting. 

choice 2: integrity_policy_init, integrity_policy_add, 
integrity_policy_complete/end, integrity_policy_match, 
integrity_rules_match

choice 3: integrity_init_policy, integrity_add_policy,
integrity_complete/end_policy, integrity_match_policy, 
integrity_match_rules

> Could return a bool type, if you like that sort of thing.
> 
> > +static int integrity_measure_rules(struct integrity_measure_rule_entry *rule,
> > +				   struct inode *inode, enum lim_hooks func,
> > +				   int mask)
> > +{
> > +	int result = 1;
> > +
> > +	if (result && (rule->func != 0)) {
> 
> The test of the known-to-be-non-zero `result' is a bit weird, btu I
> guess it makes sense in context, and the compiler should elide it OK.
> 
> > +		if (rule->func != func)
> > +			result = 0;
> > +	}
> > +	if (result && (rule->mask != 0)) {
> > +		if (rule->mask != mask)
> > +			result = 0;
> > +	}
> > +	if (result && rule->lsm_subj_rule) {
> > +		struct task_struct *tsk = current;
> > +		u32 sid;
> > +
> > +		security_task_getsecid(tsk, &sid);
> > +		result = security_filter_rule_match(sid, AUDIT_SUBJ_USER,
> > +						    AUDIT_EQUAL,
> > +						    rule->lsm_subj_rule, NULL);
> > +	}
> > +	if (result && rule->lsm_obj_rule) {
> > +		u32 osid;
> > +
> > +		security_inode_getsecid(inode, &osid);
> > +		result = security_filter_rule_match(osid, AUDIT_OBJ_USER,
> > +						    AUDIT_EQUAL,
> > +						    rule->lsm_obj_rule, NULL);
> > +	}
> > +	return result;
> > +}
> 
> However the shole function could be simplified and sped up (depending
> on how smart the compiler is) via:
> 
> 	if (rule->func && rule->func != func)
> 		return 0;
> 	if (rule->mask && rule->mask != mask)
> 		return 0;
> 	...
> 	return 1;
> }
> 
> or similar.

yes, of course. thanks!

> > +/**
> > + * integrity_measure_policy - base measure decision on: subj, obj, LIM hook,
> > + * 			      and mask
> > + * @inode - pointer to an inode
> > + * @func - LIM hook identifier
> > + * @mask - requested action (MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)
> > + *
> > + * Returns 1 on rule match, 0 on failure.
> > + */
> > +int integrity_measure_policy(struct inode *inode, enum lim_hooks func, int mask)
> > +{
> > +	struct integrity_measure_rule_entry *entry;
> > +	int rc = 0;
> > +
> > +	rcu_read_lock();
> > +	list_for_each_entry_rcu(entry, integrity_measure, list) {
> > +		rc = integrity_measure_rules(entry, inode, func, mask);
> > +		if (rc) {
> > +			rcu_read_unlock();
> > +			return rc;
> > +		}
> > +	}
> > +	rcu_read_unlock();
> > +	return rc;
> > +}
> 
> "measure"?  Or "match"?

discussion above.

> > +/**
> > + * integrity_measure_policy_init - initialize the default and policy rules.
> > + */
> > +void integrity_measure_policy_init(void)
> > +{
> > +	int i;
> > +
> > +	INIT_LIST_HEAD(&measure_default_rules);
> > +	for (i = 0; i < ARRAY_SIZE(default_rules); i++)
> > +		list_add(&default_rules[i].list, &measure_default_rules);
> > +	integrity_measure = &measure_default_rules;
> > +	mutex_init(&integrity_measure_mutex);
> 
> The mutex_init() is unneeded.

Ok

> > +	INIT_LIST_HEAD(&measure_policy_rules);
> > +}
> > +
> > +/**
> > + * integrity_measure_policy_complete - wait to replace default_rules with
> > + * 		a complete policy ruleset.
> > + */
> > +void integrity_measure_policy_complete(void)
> > +{
> > +	char *op = "policy_update";
> > +	char *cause = "already exists";
> > +	int result = 1;
> > +
> > +	if (integrity_measure == &measure_default_rules) {
> > +		integrity_measure = &measure_policy_rules;
> > +		cause = "complete";
> > +		result = 0;
> > +	}
> > +	integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
> > +			    NULL, op, cause, result);
> > +}
> 
> Does it actually "wait"?

No, it doesn't wait. The function is called when the file closes,
meaning that all of the rules have been added.  Refer to 
ima_release_policy() in the IMA patch (5/5).  Only after this function
is called, are the new set of rules used.

> The name again doesn't seem to match the behaviour.  "foo_complete"
> would mean "tell listeners that foo has completed".  What you have here
> is a "foo_wait".

Juxtaposed to the function below called integrity_measure_policy_add(),
how about integrity_measure_policy_end()?

> > +/**
> > + * integrity_measure_rule_add - add integrity measure rules
> > + * @subj - pointer to an LSM subject value
> > + * @obj -  pointer to an LSM object value
> > + * @func - LIM hook identifier
> > + * @mask - requested action (MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)
> > + *
> > + * Returns 0 on success, an error code on failure.
> > + */
> > +int integrity_measure_rule_add(char *subj, char *obj, char *func, char *mask)
> > +{
> > +	struct integrity_measure_rule_entry *entry;
> > +	int result = 0;
> > +
> > +	/* Prevent installed policy from changing */
> > +	if (integrity_measure != &measure_default_rules) {
> > +		integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
> > +				    NULL, "policy_update", "already exists", 1);
> > +		return -EACCES;
> > +	}
> > +
> > +	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
> 
> GFP_ATOMIC is unreliable.  GFP_KERNEL is much much preferable, and I
> suspect that it can be used here?

Probably. Will look into it.

> > +	INIT_LIST_HEAD(&entry->list);
> > +	if (!result && subj)
> > +		result = security_filter_rule_init(AUDIT_SUBJ_USER, AUDIT_EQUAL,
> > +						   subj, &entry->lsm_subj_rule);
> > +	if (!result && obj)
> > +		result = security_filter_rule_init(AUDIT_OBJ_USER, AUDIT_EQUAL,
> > +						   obj, &entry->lsm_obj_rule);
> > +	if (!result && func) {
> > +		if (strcmp(func, "INODE_PERMISSION") == 0)
> > +			entry->func = INODE_PERMISSION;
> > +		else if (strcmp(func, "FILE_MMAP") == 0)
> > +			entry->func = FILE_MMAP;
> > +		else if (strcmp(func, "BPRM_CHECK") == 0)
> > +			entry->func = BPRM_CHECK;
> > +		else
> > +			result = -EINVAL;
> > +	}
> > +	if (!result && mask) {
> > +		if (strcmp(mask, "MAY_EXEC") == 0)
> > +			entry->mask = MAY_EXEC;
> > +		else if (strcmp(mask, "MAY_WRITE") == 0)
> > +			entry->mask = MAY_WRITE;
> > +		else if (strcmp(mask, "MAY_READ") == 0)
> > +			entry->mask = MAY_READ;
> > +		else if (strcmp(mask, "MAY_APPEND") == 0)
> > +			entry->mask = MAY_APPEND;
> > +		else
> > +			result = -EINVAL;
> > +	}
> > +	if (!result) {
> > +		mutex_lock(&integrity_measure_mutex);
> > +		list_add_tail(&entry->list, &measure_policy_rules);
> > +		mutex_unlock(&integrity_measure_mutex);
> > +	}
> > +	return result;
> > +}
> >
> > ...

