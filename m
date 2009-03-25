Return-Path: <linux-kernel-owner+w=401wt.eu-S1762798AbZCYPZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762798AbZCYPZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 11:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758632AbZCYPZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 11:25:46 -0400
Received: from smtp104.prem.mail.sp1.yahoo.com ([98.136.44.59]:35565 "HELO
	smtp104.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754947AbZCYPZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 11:25:43 -0400
X-YMail-OSG: nSKY6.8VM1mUsdn3X9pUcFxhP8XJFlQdzPLppk5sSILzj6rVxV62NCZVvNSeP.xfSxHexNXCel.ubXf346WP_fqYYpmNxT_Oyd39mtBb0P__YF4rAO.SK5eofKY6dfOaVcIRNPovwsMgFfuTMsWbsF32U3XTD9SD3br0DLDCK4VUaPJmIyuvpjcOSrCdzXlWtuR6Yp6IA7QD0VRti8j.fC1BaFBum_7o2KI-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <49CA4CE1.8020209@schaufler-ca.com>
Date: Wed, 25 Mar 2009 08:25:21 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Etienne Basset <etienne.basset@numericable.fr>
CC: LSM <linux-security-module@vger.kernel.org>,
       Paul Moore <paul.moore@hp.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH][SMACK][2.6.30] convert smack to standard linux lists
References: <49C93A34.5070705@numericable.fr>
In-Reply-To: <49C93A34.5070705@numericable.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Etienne Basset wrote:
> hello,
>
> the following patch (on top of 2.6.29) converts Smack lists to standard linux lists
> Please review and consider for inclusion in 2.6.30-rc
>
> regards,
> Etienne
>
> Signed-off-by: Etienne Basset <etienne.basset@numericable.fr>
>   

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

My tests are passing. Thank you for doing this, it was long
overdue.

> ---
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index b79582e..64164f8 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -18,6 +18,8 @@
>  #include <linux/security.h>
>  #include <linux/in.h>
>  #include <net/netlabel.h>
> +#include <linux/list.h>
> +#include <linux/rculist.h>
>  
>  /*
>   * Why 23? CIPSO is constrained to 30, so a 32 byte buffer is
> @@ -59,17 +61,10 @@ struct inode_smack {
>   * A label access rule.
>   */
>  struct smack_rule {
> -	char	*smk_subject;
> -	char	*smk_object;
> -	int	smk_access;
> -};
> -
> -/*
> - * An entry in the table of permitted label accesses.
> - */
> -struct smk_list_entry {
> -	struct smk_list_entry	*smk_next;
> -	struct smack_rule	smk_rule;
> +	struct list_head	list;
> +	char			*smk_subject;
> +	char			*smk_object;
> +	int			smk_access;
>  };
>  
>  /*
> @@ -85,7 +80,7 @@ struct smack_cipso {
>   * An entry in the table identifying hosts.
>   */
>  struct smk_netlbladdr {
> -	struct smk_netlbladdr	*smk_next;
> +	struct list_head	list;
>  	struct sockaddr_in	smk_host;	/* network address */
>  	struct in_addr		smk_mask;	/* network mask */
>  	char			*smk_label;	/* label */
> @@ -113,7 +108,7 @@ struct smk_netlbladdr {
>   * the cipso direct mapping in used internally.
>   */
>  struct smack_known {
> -	struct smack_known	*smk_next;
> +	struct list_head	list;
>  	char			smk_known[SMK_LABELLEN];
>  	u32			smk_secid;
>  	struct smack_cipso	*smk_cipso;
> @@ -206,7 +201,6 @@ extern int smack_cipso_direct;
>  extern char *smack_net_ambient;
>  extern char *smack_onlycap;
>  
> -extern struct smack_known *smack_known;
>  extern struct smack_known smack_known_floor;
>  extern struct smack_known smack_known_hat;
>  extern struct smack_known smack_known_huh;
> @@ -214,8 +208,10 @@ extern struct smack_known smack_known_invalid;
>  extern struct smack_known smack_known_star;
>  extern struct smack_known smack_known_web;
>  
> -extern struct smk_list_entry *smack_list;
> -extern struct smk_netlbladdr *smack_netlbladdrs;
> +extern struct list_head smack_known_list;
> +extern struct list_head smack_rule_list;
> +extern struct list_head smk_netlbladdr_list;
> +
>  extern struct security_operations smack_ops;
>  
>  /*
> diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
> index 2e0b83e..5648c2f 100644
> --- a/security/smack/smack_access.c
> +++ b/security/smack/smack_access.c
> @@ -16,48 +16,42 @@
>  #include "smack.h"
>  
>  struct smack_known smack_known_huh = {
> -	.smk_next	= NULL,
>  	.smk_known	= "?",
>  	.smk_secid	= 2,
>  	.smk_cipso	= NULL,
>  };
>  
>  struct smack_known smack_known_hat = {
> -	.smk_next	= &smack_known_huh,
>  	.smk_known	= "^",
>  	.smk_secid	= 3,
>  	.smk_cipso	= NULL,
>  };
>  
>  struct smack_known smack_known_star = {
> -	.smk_next	= &smack_known_hat,
>  	.smk_known	= "*",
>  	.smk_secid	= 4,
>  	.smk_cipso	= NULL,
>  };
>  
>  struct smack_known smack_known_floor = {
> -	.smk_next	= &smack_known_star,
>  	.smk_known	= "_",
>  	.smk_secid	= 5,
>  	.smk_cipso	= NULL,
>  };
>  
>  struct smack_known smack_known_invalid = {
> -	.smk_next	= &smack_known_floor,
>  	.smk_known	= "",
>  	.smk_secid	= 6,
>  	.smk_cipso	= NULL,
>  };
>  
>  struct smack_known smack_known_web = {
> -	.smk_next	= &smack_known_invalid,
>  	.smk_known	= "@",
>  	.smk_secid	= 7,
>  	.smk_cipso	= NULL,
>  };
>  
> -struct smack_known *smack_known = &smack_known_web;
> +LIST_HEAD(smack_known_list);
>  
>  /*
>   * The initial value needs to be bigger than any of the
> @@ -87,7 +81,6 @@ static u32 smack_next_secid = 10;
>  int smk_access(char *subject_label, char *object_label, int request)
>  {
>  	u32 may = MAY_NOT;
> -	struct smk_list_entry *sp;
>  	struct smack_rule *srp;
>  
>  	/*
> @@ -139,9 +132,8 @@ int smk_access(char *subject_label, char *object_label, int request)
>  	 * access (e.g. read is included in readwrite) it's
>  	 * good.
>  	 */
> -	for (sp = smack_list; sp != NULL; sp = sp->smk_next) {
> -		srp = &sp->smk_rule;
> -
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(srp, &smack_rule_list, list) {
>  		if (srp->smk_subject == subject_label ||
>  		    strcmp(srp->smk_subject, subject_label) == 0) {
>  			if (srp->smk_object == object_label ||
> @@ -151,6 +143,7 @@ int smk_access(char *subject_label, char *object_label, int request)
>  			}
>  		}
>  	}
> +	rcu_read_unlock();
>  	/*
>  	 * This is a bit map operation.
>  	 */
> @@ -228,14 +221,17 @@ struct smack_known *smk_import_entry(const char *string, int len)
>  
>  	mutex_lock(&smack_known_lock);
>  
> -	for (skp = smack_known; skp != NULL; skp = skp->smk_next)
> -		if (strncmp(skp->smk_known, smack, SMK_MAXLEN) == 0)
> +	found = 0;
> +	list_for_each_entry_rcu(skp, &smack_known_list, list) {
> +		if (strncmp(skp->smk_known, smack, SMK_MAXLEN) == 0) {
> +			found = 1;
>  			break;
> +		}
> +	}
>  
> -	if (skp == NULL) {
> +	if (found == 0) {
>  		skp = kzalloc(sizeof(struct smack_known), GFP_KERNEL);
>  		if (skp != NULL) {
> -			skp->smk_next = smack_known;
>  			strncpy(skp->smk_known, smack, SMK_MAXLEN);
>  			skp->smk_secid = smack_next_secid++;
>  			skp->smk_cipso = NULL;
> @@ -244,8 +240,7 @@ struct smack_known *smk_import_entry(const char *string, int len)
>  			 * Make sure that the entry is actually
>  			 * filled before putting it on the list.
>  			 */
> -			smp_mb();
> -			smack_known = skp;
> +			list_add_rcu(&skp->list, &smack_known_list);
>  		}
>  	}
>  
> @@ -283,14 +278,19 @@ char *smack_from_secid(const u32 secid)
>  {
>  	struct smack_known *skp;
>  
> -	for (skp = smack_known; skp != NULL; skp = skp->smk_next)
> -		if (skp->smk_secid == secid)
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(skp, &smack_known_list, list) {
> +		if (skp->smk_secid == secid) {
> +			rcu_read_unlock();
>  			return skp->smk_known;
> +		}
> +	}
>  
>  	/*
>  	 * If we got this far someone asked for the translation
>  	 * of a secid that is not on the list.
>  	 */
> +	rcu_read_unlock();
>  	return smack_known_invalid.smk_known;
>  }
>  
> @@ -305,9 +305,14 @@ u32 smack_to_secid(const char *smack)
>  {
>  	struct smack_known *skp;
>  
> -	for (skp = smack_known; skp != NULL; skp = skp->smk_next)
> -		if (strncmp(skp->smk_known, smack, SMK_MAXLEN) == 0)
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(skp, &smack_known_list, list) {
> +		if (strncmp(skp->smk_known, smack, SMK_MAXLEN) == 0) {
> +			rcu_read_unlock();
>  			return skp->smk_secid;
> +		}
> +	}
> +	rcu_read_unlock();
>  	return 0;
>  }
>  
> @@ -332,7 +337,8 @@ void smack_from_cipso(u32 level, char *cp, char *result)
>  	struct smack_known *kp;
>  	char *final = NULL;
>  
> -	for (kp = smack_known; final == NULL && kp != NULL; kp = kp->smk_next) {
> +	rcu_read_lock();
> +	list_for_each_entry(kp, &smack_known_list, list) {
>  		if (kp->smk_cipso == NULL)
>  			continue;
>  
> @@ -344,6 +350,7 @@ void smack_from_cipso(u32 level, char *cp, char *result)
>  
>  		spin_unlock_bh(&kp->smk_cipsolock);
>  	}
> +	rcu_read_unlock();
>  	if (final == NULL)
>  		final = smack_known_huh.smk_known;
>  	strncpy(result, final, SMK_MAXLEN);
> @@ -360,13 +367,19 @@ void smack_from_cipso(u32 level, char *cp, char *result)
>  int smack_to_cipso(const char *smack, struct smack_cipso *cp)
>  {
>  	struct smack_known *kp;
> +	int found = 0;
>  
> -	for (kp = smack_known; kp != NULL; kp = kp->smk_next)
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(kp, &smack_known_list, list) {
>  		if (kp->smk_known == smack ||
> -		    strcmp(kp->smk_known, smack) == 0)
> +		    strcmp(kp->smk_known, smack) == 0) {
> +			found = 1;
>  			break;
> +		}
> +	}
> +	rcu_read_unlock();
>  
> -	if (kp == NULL || kp->smk_cipso == NULL)
> +	if (found == 0 || kp->smk_cipso == NULL)
>  		return -ENOENT;
>  
>  	memcpy(cp, kp->smk_cipso, sizeof(struct smack_cipso));
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index e7ded13..fdbb065 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -1510,7 +1510,8 @@ static char *smack_host_label(struct sockaddr_in *sip)
>  	if (siap->s_addr == 0)
>  		return NULL;
>  
> -	for (snp = smack_netlbladdrs; snp != NULL; snp = snp->smk_next) {
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(snp, &smk_netlbladdr_list, list) {
>  		/*
>  		 * we break after finding the first match because
>  		 * the list is sorted from longest to shortest mask
> @@ -1518,10 +1519,11 @@ static char *smack_host_label(struct sockaddr_in *sip)
>  		 */
>  		if ((&snp->smk_host.sin_addr)->s_addr  ==
>  			(siap->s_addr & (&snp->smk_mask)->s_addr)) {
> +			rcu_read_unlock();
>  			return snp->smk_label;
>  		}
>  	}
> -
> +	rcu_read_unlock();
>  	return NULL;
>  }
>  
> @@ -2934,6 +2936,17 @@ struct security_operations smack_ops = {
>  	.release_secctx = 		smack_release_secctx,
>  };
>  
> +
> +static __init void init_smack_know_list(void)
> +{
> +	list_add(&smack_known_huh.list, &smack_known_list);
> +	list_add(&smack_known_hat.list, &smack_known_list);
> +	list_add(&smack_known_star.list, &smack_known_list);
> +	list_add(&smack_known_floor.list, &smack_known_list);
> +	list_add(&smack_known_invalid.list, &smack_known_list);
> +	list_add(&smack_known_web.list, &smack_known_list);
> +}
> +
>  /**
>   * smack_init - initialize the smack system
>   *
> @@ -2954,6 +2967,8 @@ static __init int smack_init(void)
>  	cred = (struct cred *) current->cred;
>  	cred->security = &smack_known_floor.smk_known;
>  
> +	/* initilize the smack_know_list */
> +	init_smack_know_list();
>  	/*
>  	 * Initialize locks
>  	 */
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index 51f0efc..45a975c 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -80,10 +80,11 @@ char *smack_onlycap;
>   * Packets are sent there unlabeled, but only from tasks that
>   * can write to the specified label.
>   */
> -struct smk_netlbladdr *smack_netlbladdrs;
> +
> +LIST_HEAD(smk_netlbladdr_list);
> +LIST_HEAD(smack_rule_list);
>  
>  static int smk_cipso_doi_value = SMACK_CIPSO_DOI_DEFAULT;
> -struct smk_list_entry *smack_list;
>  
>  #define	SEQ_READ_FINISHED	1
>  
> @@ -134,24 +135,27 @@ static void *load_seq_start(struct seq_file *s, loff_t *pos)
>  {
>  	if (*pos == SEQ_READ_FINISHED)
>  		return NULL;
> -
> -	return smack_list;
> +	if (list_empty(&smack_rule_list))
> +		return NULL;
> +	return smack_rule_list.next;
>  }
>  
>  static void *load_seq_next(struct seq_file *s, void *v, loff_t *pos)
>  {
> -	struct smk_list_entry *skp = ((struct smk_list_entry *) v)->smk_next;
> +	struct list_head *list = v;
>  
> -	if (skp == NULL)
> +	if (list_is_last(list, &smack_rule_list)) {
>  		*pos = SEQ_READ_FINISHED;
> -
> -	return skp;
> +		return NULL;
> +	}
> +	return list->next;
>  }
>  
>  static int load_seq_show(struct seq_file *s, void *v)
>  {
> -	struct smk_list_entry *slp = (struct smk_list_entry *) v;
> -	struct smack_rule *srp = &slp->smk_rule;
> +	struct list_head *list = v;
> +	struct smack_rule *srp =
> +		 list_entry(list, struct smack_rule, list);
>  
>  	seq_printf(s, "%s %s", (char *)srp->smk_subject,
>  		   (char *)srp->smk_object);
> @@ -212,32 +216,23 @@ static int smk_open_load(struct inode *inode, struct file *file)
>   */
>  static int smk_set_access(struct smack_rule *srp)
>  {
> -	struct smk_list_entry *sp;
> -	struct smk_list_entry *newp;
> +	struct smack_rule *sp;
>  	int ret = 0;
> -
> +	int found;
>  	mutex_lock(&smack_list_lock);
>  
> -	for (sp = smack_list; sp != NULL; sp = sp->smk_next)
> -		if (sp->smk_rule.smk_subject == srp->smk_subject &&
> -		    sp->smk_rule.smk_object == srp->smk_object) {
> -			sp->smk_rule.smk_access = srp->smk_access;
> +	found = 0;
> +	list_for_each_entry_rcu(sp, &smack_rule_list, list) {
> +		if (sp->smk_subject == srp->smk_subject &&
> +		    sp->smk_object == srp->smk_object) {
> +			found = 1;
> +			sp->smk_access = srp->smk_access;
>  			break;
>  		}
> -
> -	if (sp == NULL) {
> -		newp = kzalloc(sizeof(struct smk_list_entry), GFP_KERNEL);
> -		if (newp == NULL) {
> -			ret = -ENOMEM;
> -			goto out;
> -		}
> -
> -		newp->smk_rule = *srp;
> -		newp->smk_next = smack_list;
> -		smack_list = newp;
>  	}
> +	if (found == 0)
> +		list_add_rcu(&srp->list, &smack_rule_list);
>  
> -out:
>  	mutex_unlock(&smack_list_lock);
>  
>  	return ret;
> @@ -261,7 +256,7 @@ out:
>  static ssize_t smk_write_load(struct file *file, const char __user *buf,
>  			      size_t count, loff_t *ppos)
>  {
> -	struct smack_rule rule;
> +	struct smack_rule *rule;
>  	char *data;
>  	int rc = -EINVAL;
>  
> @@ -272,9 +267,8 @@ static ssize_t smk_write_load(struct file *file, const char __user *buf,
>  	 */
>  	if (!capable(CAP_MAC_ADMIN))
>  		return -EPERM;
> -	if (*ppos != 0)
> -		return -EINVAL;
> -	if (count != SMK_LOADLEN)
> +
> +	if (*ppos != 0 || count != SMK_LOADLEN)
>  		return -EINVAL;
>  
>  	data = kzalloc(count, GFP_KERNEL);
> @@ -286,25 +280,31 @@ static ssize_t smk_write_load(struct file *file, const char __user *buf,
>  		goto out;
>  	}
>  
> -	rule.smk_subject = smk_import(data, 0);
> -	if (rule.smk_subject == NULL)
> +	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
> +	if (rule == NULL) {
> +		rc = -ENOMEM;
>  		goto out;
> +	}
>  
> -	rule.smk_object = smk_import(data + SMK_LABELLEN, 0);
> -	if (rule.smk_object == NULL)
> -		goto out;
> +	rule->smk_subject = smk_import(data, 0);
> +	if (rule->smk_subject == NULL)
> +		goto out_free_rule;
>  
> -	rule.smk_access = 0;
> +	rule->smk_object = smk_import(data + SMK_LABELLEN, 0);
> +	if (rule->smk_object == NULL)
> +		goto out_free_rule;
> +
> +	rule->smk_access = 0;
>  
>  	switch (data[SMK_LABELLEN + SMK_LABELLEN]) {
>  	case '-':
>  		break;
>  	case 'r':
>  	case 'R':
> -		rule.smk_access |= MAY_READ;
> +		rule->smk_access |= MAY_READ;
>  		break;
>  	default:
> -		goto out;
> +		goto out_free_rule;
>  	}
>  
>  	switch (data[SMK_LABELLEN + SMK_LABELLEN + 1]) {
> @@ -312,10 +312,10 @@ static ssize_t smk_write_load(struct file *file, const char __user *buf,
>  		break;
>  	case 'w':
>  	case 'W':
> -		rule.smk_access |= MAY_WRITE;
> +		rule->smk_access |= MAY_WRITE;
>  		break;
>  	default:
> -		goto out;
> +		goto out_free_rule;
>  	}
>  
>  	switch (data[SMK_LABELLEN + SMK_LABELLEN + 2]) {
> @@ -323,10 +323,10 @@ static ssize_t smk_write_load(struct file *file, const char __user *buf,
>  		break;
>  	case 'x':
>  	case 'X':
> -		rule.smk_access |= MAY_EXEC;
> +		rule->smk_access |= MAY_EXEC;
>  		break;
>  	default:
> -		goto out;
> +		goto out_free_rule;
>  	}
>  
>  	switch (data[SMK_LABELLEN + SMK_LABELLEN + 3]) {
> @@ -334,17 +334,20 @@ static ssize_t smk_write_load(struct file *file, const char __user *buf,
>  		break;
>  	case 'a':
>  	case 'A':
> -		rule.smk_access |= MAY_APPEND;
> +		rule->smk_access |= MAY_APPEND;
>  		break;
>  	default:
> -		goto out;
> +		goto out_free_rule;
>  	}
>  
> -	rc = smk_set_access(&rule);
> +	rc = smk_set_access(rule);
>  
>  	if (!rc)
>  		rc = count;
> +	goto out;
>  
> +out_free_rule:
> +	kfree(rule);
>  out:
>  	kfree(data);
>  	return rc;
> @@ -432,24 +435,26 @@ static void *cipso_seq_start(struct seq_file *s, loff_t *pos)
>  {
>  	if (*pos == SEQ_READ_FINISHED)
>  		return NULL;
> +	if (list_empty(&smack_known_list))
> +		return NULL;
>  
> -	return smack_known;
> +	return smack_known_list.next;
>  }
>  
>  static void *cipso_seq_next(struct seq_file *s, void *v, loff_t *pos)
>  {
> -	struct smack_known *skp = ((struct smack_known *) v)->smk_next;
> +	struct list_head  *list = v;
>  
>  	/*
> -	 * Omit labels with no associated cipso value
> +	 * labels with no associated cipso value wont be printed
> +	 * in cipso_seq_show
>  	 */
> -	while (skp != NULL && !skp->smk_cipso)
> -		skp = skp->smk_next;
> -
> -	if (skp == NULL)
> +	if (list_is_last(list, &smack_known_list)) {
>  		*pos = SEQ_READ_FINISHED;
> +		return NULL;
> +	}
>  
> -	return skp;
> +	return list->next;
>  }
>  
>  /*
> @@ -458,7 +463,9 @@ static void *cipso_seq_next(struct seq_file *s, void *v, loff_t *pos)
>   */
>  static int cipso_seq_show(struct seq_file *s, void *v)
>  {
> -	struct smack_known *skp = (struct smack_known *) v;
> +	struct list_head  *list = v;
> +	struct smack_known *skp =
> +		 list_entry(list, struct smack_known, list);
>  	struct smack_cipso *scp = skp->smk_cipso;
>  	char *cbp;
>  	char sep = '/';
> @@ -637,18 +644,21 @@ static void *netlbladdr_seq_start(struct seq_file *s, loff_t *pos)
>  {
>  	if (*pos == SEQ_READ_FINISHED)
>  		return NULL;
> -
> -	return smack_netlbladdrs;
> +	if (list_empty(&smk_netlbladdr_list))
> +		return NULL;
> +	return smk_netlbladdr_list.next;
>  }
>  
>  static void *netlbladdr_seq_next(struct seq_file *s, void *v, loff_t *pos)
>  {
> -	struct smk_netlbladdr *skp = ((struct smk_netlbladdr *) v)->smk_next;
> +	struct list_head *list = v;
>  
> -	if (skp == NULL)
> +	if (list_is_last(list, &smk_netlbladdr_list)) {
>  		*pos = SEQ_READ_FINISHED;
> +		return NULL;
> +	}
>  
> -	return skp;
> +	return list->next;
>  }
>  #define BEBITS	(sizeof(__be32) * 8)
>  
> @@ -657,7 +667,9 @@ static void *netlbladdr_seq_next(struct seq_file *s, void *v, loff_t *pos)
>   */
>  static int netlbladdr_seq_show(struct seq_file *s, void *v)
>  {
> -	struct smk_netlbladdr *skp = (struct smk_netlbladdr *) v;
> +	struct list_head *list = v;
> +	struct smk_netlbladdr *skp =
> +			 list_entry(list, struct smk_netlbladdr, list);
>  	unsigned char *hp = (char *) &skp->smk_host.sin_addr.s_addr;
>  	int maskn;
>  	u32 temp_mask = be32_to_cpu(skp->smk_mask.s_addr);
> @@ -701,30 +713,36 @@ static int smk_open_netlbladdr(struct inode *inode, struct file *file)
>   *
>   * This helper insert netlabel in the smack_netlbladdrs list
>   * sorted by netmask length (longest to smallest)
> + * locked by &smk_netlbladdr_lock in smk_write_netlbladdr
> + *
>   */
>  static void smk_netlbladdr_insert(struct smk_netlbladdr *new)
>  {
> -	struct smk_netlbladdr *m;
> +	struct smk_netlbladdr *m, *m_next;
>  
> -	if (smack_netlbladdrs == NULL) {
> -		smack_netlbladdrs = new;
> +	if (list_empty(&smk_netlbladdr_list)) {
> +		list_add_rcu(&new->list, &smk_netlbladdr_list);
>  		return;
>  	}
>  
> +	m = list_entry(rcu_dereference(smk_netlbladdr_list.next),
> +			 struct smk_netlbladdr, list);
> +
>  	/* the comparison '>' is a bit hacky, but works */
> -	if (new->smk_mask.s_addr > smack_netlbladdrs->smk_mask.s_addr) {
> -		new->smk_next = smack_netlbladdrs;
> -		smack_netlbladdrs = new;
> +	if (new->smk_mask.s_addr > m->smk_mask.s_addr) {
> +		list_add_rcu(&new->list, &smk_netlbladdr_list);
>  		return;
>  	}
> -	for (m = smack_netlbladdrs; m != NULL; m = m->smk_next) {
> -		if (m->smk_next == NULL) {
> -			m->smk_next = new;
> +
> +	list_for_each_entry_rcu(m, &smk_netlbladdr_list, list) {
> +		if (list_is_last(&m->list, &smk_netlbladdr_list)) {
> +			list_add_rcu(&new->list, &m->list);
>  			return;
>  		}
> -		if (new->smk_mask.s_addr > m->smk_next->smk_mask.s_addr) {
> -			new->smk_next = m->smk_next;
> -			m->smk_next = new;
> +		m_next = list_entry(rcu_dereference(m->list.next),
> +				 struct smk_netlbladdr, list);
> +		if (new->smk_mask.s_addr > m_next->smk_mask.s_addr) {
> +			list_add_rcu(&new->list, &m->list);
>  			return;
>  		}
>  	}
> @@ -754,6 +772,7 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
>  	struct netlbl_audit audit_info;
>  	struct in_addr mask;
>  	unsigned int m;
> +	int found;
>  	u32 mask_bits = (1<<31);
>  	__be32 nsa;
>  	u32 temp_mask;
> @@ -807,14 +826,17 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
>  
>  	nsa = newname.sin_addr.s_addr;
>  	/* try to find if the prefix is already in the list */
> -	for (skp = smack_netlbladdrs; skp != NULL; skp = skp->smk_next)
> +	found = 0;
> +	list_for_each_entry_rcu(skp, &smk_netlbladdr_list, list) {
>  		if (skp->smk_host.sin_addr.s_addr == nsa &&
> -		    skp->smk_mask.s_addr == mask.s_addr)
> +		    skp->smk_mask.s_addr == mask.s_addr) {
> +			found = 1;
>  			break;
> -
> +		}
> +	}
>  	smk_netlabel_audit_set(&audit_info);
>  
> -	if (skp == NULL) {
> +	if (found == 0) {
>  		skp = kzalloc(sizeof(*skp), GFP_KERNEL);
>  		if (skp == NULL)
>  			rc = -ENOMEM;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>   

