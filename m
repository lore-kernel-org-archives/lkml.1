Return-Path: <linux-kernel-owner+w=401wt.eu-S1760779AbYEWXbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779AbYEWXbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 19:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbYEWXa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 19:30:57 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:29351 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbYEWXaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 19:30:55 -0400
Date: Fri, 23 May 2008 16:30:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com,
       Stephen Smalley <sds@tycho.nsa.gov>,
       CaseySchaufler <casey@schaufler-ca.com>
Subject: Re: [RFC][PATCH 4/5]integrity: Linux Integrity Module(LIM)
Message-Id: <20080523163032.d272ab0e.randy.dunlap@oracle.com>
In-Reply-To: <1211555133.16195.17.camel@new-host>
References: <1211555133.16195.17.camel@new-host>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 11:05:33 -0400 Mimi Zohar wrote:

> ---
> Index: linux-2.6.26-rc3-git2/security/integrity/integrity.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6.26-rc3-git2/security/integrity/integrity.c
> @@ -0,0 +1,259 @@
> +/**
> + * register_template

Needs short function description.

> + * @template_name: a pointer to a string containing the template name.
> + * @template_ops: a pointer to the template functions
> + *
> + * Register a set of functions to collect, appraise, store, and display
> + * a template measurement, and a means to decide whether to do them.
> + * Unlike integrity modules, any number of templates may be registered.
> + */
> +int register_template(char *template_name,
> +			struct template_operations *template_ops)
> +{
> +	int template_len;
> +	struct template_list_entry *entry;
> +
> +	if (!template_initialized++) {
> +		INIT_LIST_HEAD(&integrity_templates);
> +		mutex_init(&integrity_templates_mutex);
> +	}
> +
> +	entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
> +	INIT_LIST_HEAD(&entry->template);
> +
> +	template_len = strlen(template_name);
> +	if (template_len > TEMPLATE_NAME_LEN_MAX)
> +		template_len = TEMPLATE_NAME_LEN_MAX;
> +	memcpy(entry->template_name, template_name, template_len);
> +	entry->template_name[template_len] = '\0';
> +	entry->template_ops = template_ops;
> +
> +	mutex_lock(&integrity_templates_mutex);
> +	list_add_rcu(&entry->template, &integrity_templates);
> +	mutex_unlock(&integrity_templates_mutex);
> +	synchronize_rcu();
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(register_template);
> +
> +/**
> + * unregister_template

ditto.

> + * @template_name: a pointer to a string containing the template name.
> + *
> + * Unregister the template functions
> + */
> +int unregister_template(char *template_name)
> +{
> +	struct template_list_entry *entry;
> +
> +	mutex_lock(&integrity_templates_mutex);
> +	list_for_each_entry(entry, &integrity_templates, template) {
> +		if (strncmp(entry->template_name, template_name,
> +			    strlen(entry->template_name)) == 0) {
> +			list_del_rcu(&entry->template);
> +			mutex_unlock(&integrity_templates_mutex);
> +			synchronize_rcu();
> +			kfree(entry);
> +			return 0;
> +		}
> +	}
> +	mutex_unlock(&integrity_templates_mutex);
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL_GPL(unregister_template);
> +
> +/**
> + * integrity_find_template

ditto.

> + * @template_name: a pointer to a string containing the template name.
> + * @template_ops: a pointer to the template functions
> + *
> + * Find the template functions based on the template name.
> + */
> +int integrity_find_template(char *template_name,
> +				struct template_operations **template_ops)
> +{
> +	struct template_list_entry *entry;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(entry, &integrity_templates, template) {
> +		if (strncmp(entry->template_name, template_name,
> +			    strlen(entry->template_name)) == 0) {
> +			*template_ops = entry->template_ops;
> +			rcu_read_unlock();
> +			return 0;
> +		}
> +	}
> +	rcu_read_unlock();
> +	return 1;
> +}
> +EXPORT_SYMBOL_GPL(integrity_find_template);
> +
> +/* Integrity template API */

Please add kernel-doc for exported symbols (like this one and more
below).


> +int integrity_collect_measurement(char *template_name, void *data)
> +{
> +	struct template_operations *template_ops;
> +
> +	if (integrity_find_template(template_name, &template_ops) == 0)
> +		template_ops->collect_measurement(data);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(integrity_collect_measurement);
> +
> +int integrity_appraise_measurement(char *template_name, void *data)
> +{
> +	struct template_operations *template_ops;
> +
> +	if (integrity_find_template(template_name, &template_ops) == 0)
> +		return template_ops->appraise_measurement(data);
> +	return 1;
> +}
> +EXPORT_SYMBOL_GPL(integrity_appraise_measurement);
> +
> +void integrity_store_measurement(char *template_name, void *data)
> +{
> +	struct template_operations *template_ops;
> +
> +	if (integrity_find_template(template_name, &template_ops) == 0)
> +		template_ops->store_measurement(data);
> +	return;
> +}
> +EXPORT_SYMBOL_GPL(integrity_store_measurement);
> +
> +int integrity_must_measure(char *template_name, void *data)
> +{
> +	struct template_operations *template_ops;
> +
> +	if (integrity_find_template(template_name, &template_ops) == 0)
> +		return template_ops->must_measure(data);
> +	return 1;
> +}
> +EXPORT_SYMBOL_GPL(integrity_must_measure);
> +
> +/* Integrity Hooks */
> +int integrity_bprm_check(struct linux_binprm *bprm)
> +{
> +	return integrity_ops->bprm_check_integrity(bprm);
> +}
> +
> +int integrity_inode_setxattr(struct dentry *dentry, const char *name,
> +			     const void *value, size_t size, int flags)
> +{
> +	if (unlikely(IS_PRIVATE(dentry->d_inode)))
> +		return 0;
> +	return integrity_ops->inode_setxattr(dentry, name, value, size, flags);
> +}
> +
> +void integrity_inode_post_setxattr(struct dentry *dentry, const char *name)
> +{
> +	if (unlikely(IS_PRIVATE(dentry->d_inode)))
> +		return;
> +	integrity_ops->inode_post_setxattr(dentry, name);
> +}
> +
> +int integrity_inode_alloc(struct inode *inode)
> +{
> +	return integrity_ops->inode_alloc_integrity(inode);
> +}
> +
> +void integrity_inode_free(struct inode *inode)
> +{
> +	integrity_ops->inode_free_integrity(inode);
> +}
> +
> +int integrity_inode_permission(struct inode *inode, int mask,
> +				struct nameidata *nd)
> +{
> +	return integrity_ops->inode_permission(inode, mask, nd);
> +}
> +
> +void integrity_inode_init_integrity(struct inode *inode, struct inode *dir,
> +					char **name, void **value, size_t *len)
> +{
> +	if (unlikely(IS_PRIVATE(inode)))
> +		return;
> +	integrity_ops->inode_init_integrity(inode, dir, name, value, len);
> +	return;
> +}
> +EXPORT_SYMBOL(integrity_inode_init_integrity);
> +
> +void integrity_file_free(struct file *file)
> +{
> +	integrity_ops->file_free_integrity(file);
> +}
> +
> +int integrity_file_mmap(struct file *file, unsigned long reqprot,
> +			unsigned long prot, unsigned long flags,
> +			unsigned long addr, unsigned long addr_only)
> +{
> +	return integrity_ops->file_mmap(file, reqprot, prot, flags, addr,
> +					addr_only);
> +}
> +
> +void integrity_d_instantiate(struct dentry *dentry, struct inode *inode)
> +{
> +	if (unlikely(inode && IS_PRIVATE(inode)))
> +		return;
> +	integrity_ops->d_instantiate(dentry, inode);
> +}

> Index: linux-2.6.26-rc3-git2/Documentation/kernel-parameters.txt
> ===================================================================
> --- linux-2.6.26-rc3-git2.orig/Documentation/kernel-parameters.txt
> +++ linux-2.6.26-rc3-git2/Documentation/kernel-parameters.txt
> @@ -821,6 +821,11 @@ and is between 256 and 4096 characters. 
>  	inport.irq=	[HW] Inport (ATI XL and Microsoft) busmouse driver
>  			Format: <irq>
>  
> +	integrity_audit= [INTEGRITY]

Where is the INTEGRITY tag defined?

> +                        Format: { "0" | "1" }
> +                        0 -- disable integrity auditing messages.
> +                        1 -- enable integrity auditing messages. (Default)
> +
>  	inttest=	[IA64]
>  
>  	iommu=		[x86]

> Index: linux-2.6.26-rc3-git2/security/integrity/integrity_policy.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6.26-rc3-git2/security/integrity/integrity_policy.c
> @@ -0,0 +1,204 @@
> +
> +/**
> + * integrity_measure_rules - determine whether an inode matches the given rule.
> + * @rule - a pointer to a rule
> + * @inode - a pointer to an inode
> + * @func - LIM hook identifier
> + * @mask - requested action (MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)

kernel-doc notation for parameters is (e.g.)
 * @rule: a pointer to a rule

> + *
> + * Returns 1 on rule match, 0 on failure.
> + */
> +static int integrity_measure_rules(struct integrity_measure_rule_entry *rule,
> +				   struct inode *inode, enum lim_hooks func,
> +				   int mask)
> +{
> +	int result = 1;
> +
> +	if (result && (rule->func != 0)) {
> +		if (rule->func != func)
> +			result = 0;
> +	}
> +	if (result && (rule->mask != 0)) {
> +		if (rule->mask != mask)
> +			result = 0;
> +	}
> +	if (result && rule->lsm_subj_rule) {
> +		struct task_struct *tsk = current;
> +		u32 sid;
> +
> +		security_task_getsecid(tsk, &sid);
> +		result = security_filter_rule_match(sid, AUDIT_SUBJ_USER,
> +						    AUDIT_EQUAL,
> +						    rule->lsm_subj_rule, NULL);
> +	}
> +	if (result && rule->lsm_obj_rule) {
> +		u32 osid;
> +
> +		security_inode_getsecid(inode, &osid);
> +		result = security_filter_rule_match(osid, AUDIT_OBJ_USER,
> +						    AUDIT_EQUAL,
> +						    rule->lsm_obj_rule, NULL);
> +	}
> +	return result;
> +}
> +
> +/**
> + * integrity_measure_policy - base measure decision on: subj, obj, LIM hook,
> + * 			      and mask

One line for short description.

 * @inode: pointer to an inode

> + * @inode - pointer to an inode
> + * @func - LIM hook identifier
> + * @mask - requested action (MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)
> + *
> + * Returns 1 on rule match, 0 on failure.
> + */
> +int integrity_measure_policy(struct inode *inode, enum lim_hooks func, int mask)
> +{
> +	struct integrity_measure_rule_entry *entry;
> +	int rc = 0;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(entry, integrity_measure, list) {
> +		rc = integrity_measure_rules(entry, inode, func, mask);
> +		if (rc) {
> +			rcu_read_unlock();
> +			return rc;
> +		}
> +	}
> +	rcu_read_unlock();
> +	return rc;
> +}
> +
> +
> +
> +/**
> + * integrity_measure_rule_add - add integrity measure rules
> + * @subj - pointer to an LSM subject value

 * @subj: etc etc etc

> + * @obj -  pointer to an LSM object value
> + * @func - LIM hook identifier
> + * @mask - requested action (MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)
> + *
> + * Returns 0 on success, an error code on failure.
> + */
> +int integrity_measure_rule_add(char *subj, char *obj, char *func, char *mask)
> +{
> +	struct integrity_measure_rule_entry *entry;
> +	int result = 0;
> +
> +	/* Prevent installed policy from changing */
> +	if (integrity_measure != &measure_default_rules) {
> +		integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
> +				    NULL, "policy_update", "already exists", 1);
> +		return -EACCES;
> +	}
> +
> +	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
> +	INIT_LIST_HEAD(&entry->list);
> +	if (!result && subj)
> +		result = security_filter_rule_init(AUDIT_SUBJ_USER, AUDIT_EQUAL,
> +						   subj, &entry->lsm_subj_rule);
> +	if (!result && obj)
> +		result = security_filter_rule_init(AUDIT_OBJ_USER, AUDIT_EQUAL,
> +						   obj, &entry->lsm_obj_rule);
> +	if (!result && func) {
> +		if (strcmp(func, "INODE_PERMISSION") == 0)
> +			entry->func = INODE_PERMISSION;
> +		else if (strcmp(func, "FILE_MMAP") == 0)
> +			entry->func = FILE_MMAP;
> +		else if (strcmp(func, "BPRM_CHECK") == 0)
> +			entry->func = BPRM_CHECK;
> +		else
> +			result = -EINVAL;
> +	}
> +	if (!result && mask) {
> +		if (strcmp(mask, "MAY_EXEC") == 0)
> +			entry->mask = MAY_EXEC;
> +		else if (strcmp(mask, "MAY_WRITE") == 0)
> +			entry->mask = MAY_WRITE;
> +		else if (strcmp(mask, "MAY_READ") == 0)
> +			entry->mask = MAY_READ;
> +		else if (strcmp(mask, "MAY_APPEND") == 0)
> +			entry->mask = MAY_APPEND;
> +		else
> +			result = -EINVAL;
> +	}
> +	if (!result) {
> +		mutex_lock(&integrity_measure_mutex);
> +		list_add_tail(&entry->list, &measure_policy_rules);
> +		mutex_unlock(&integrity_measure_mutex);
> +	}
> +	return result;
> +}

---
~Randy
