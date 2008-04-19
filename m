Return-Path: <linux-kernel-owner+w=401wt.eu-S1759670AbYDSWT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759670AbYDSWT1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 18:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbYDSWTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 18:19:16 -0400
Received: from web36605.mail.mud.yahoo.com ([209.191.85.22]:46275 "HELO
	web36605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751563AbYDSWTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 18:19:14 -0400
X-YMail-OSG: 1ovIzWUVM1koSNwOUSkW4fZGxLdIwozUinqjc6GG.90BC33SCfKbHAGh0I81Uyo7sCySTQ84S1H_eQzWtEisB5FvCfg7vZg6OdY2gw8fERUlhf0Ood_RueJRiTQ-
X-RocketYMMF: rancidfat
Date: Sat, 19 Apr 2008 15:19:13 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 2.6.26 #repost] Smack: Integrate with Audit
To: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       James Morris <jmorris@namei.org>,
       Casey Schaufler <casey@schaufler-ca.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Steve Grubb <sgrubb@redhat.com>,
       Al Viro <viro@ftp.linux.org.uk>, linux-security-module@vger.kernel.org,
       linux-audit@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080417161032.GA24882@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <858638.48039.qm@web36605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:

> Hi James/all,
> 
> On Thu, Apr 17, 2008 at 11:05:57AM +0000, James Morris wrote:
> > 
> > Please review the following security patches for 2.6.26, which have
> > been undergoing testing in the "next" tree and affect multiple LSMs.
> > 
> > 
> 
> As a clarification, those new changes was added to the security tree 
> to modularly integrate Smack with Audit. The final step is the
> reposted below patch which setups the new Audit hooks for Smack.
> 
> The main concern against below patch was the reuse of SELinux Audit
> fields. For such reuse, Stephen asked for an explicit ACK from the 
> Audit devs. I've CCed Steve and Al as a kind request for the ACK.
> 
> Patch is re-based and re-tested over James's security/for-linus
> branch.
> 
> Thanks all.
> 
> -->
> 
> Setup the new Audit hooks for Smack. SELinux Audit rule fields 
> are recycled to avoid `auditd' userspace modifications.
> Currently only equality testing is supported on labels acting 
> as a subject (AUDIT_SUBJ_USER) or as an object (AUDIT_OBJ_USER).
> 
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

Had to test it before acking. It's running fine for me.

> ---
> 
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 904bdc0..70e4abc 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -26,6 +26,7 @@
>  #include <linux/pipe_fs_i.h>
>  #include <net/netlabel.h>
>  #include <net/cipso_ipv4.h>
> +#include <linux/audit.h>
>  
>  #include "smack.h"
>  
> @@ -752,6 +753,18 @@ static int smack_inode_listsecurity(struct inode *inode,
> char *buffer,
>  	return -EINVAL;
>  }
>  
> +/**
> + * smack_inode_getsecid - Extract inode's security id
> + * @inode: inode to extract the info from
> + * @secid: where result will be saved
> + */
> +static void smack_inode_getsecid(const struct inode *inode, u32 *secid)
> +{
> +	struct inode_smack *isp = inode->i_security;
> +
> +	*secid = smack_to_secid(isp->smk_inode);
> +}
> +
>  /*
>   * File Hooks
>   */
> @@ -1805,6 +1818,18 @@ static int smack_ipc_permission(struct kern_ipc_perm
> *ipp, short flag)
>  	return smk_curacc(isp, may);
>  }
>  
> +/**
> + * smack_ipc_getsecid - Extract smack security id
> + * @ipcp: the object permissions
> + * @secid: where result will be saved
> + */
> +static void smack_ipc_getsecid(struct kern_ipc_perm *ipp, u32 *secid)
> +{
> +	char *smack = ipp->security;
> +
> +	*secid = smack_to_secid(smack);
> +}
> +
>  /* module stacking operations */
>  
>  /**
> @@ -2382,6 +2407,124 @@ static int smack_key_permission(key_ref_t key_ref,
>  #endif /* CONFIG_KEYS */
>  
>  /*
> + * Smack Audit hooks
> + *
> + * Audit requires a unique representation of each Smack specific
> + * rule. This unique representation is used to distinguish the
> + * object to be audited from remaining kernel objects and also
> + * works as a glue between the audit hooks.
> + *
> + * Since repository entries are added but never deleted, we'll use
> + * the smack_known label address related to the given audit rule as
> + * the needed unique representation. This also better fits the smack
> + * model where nearly everything is a label.
> + */
> +#ifdef CONFIG_AUDIT
> +
> +/**
> + * smack_audit_rule_init - Initialize a smack audit rule
> + * @field: audit rule fields given from user-space (audit.h)
> + * @op: required testing operator (=, !=, >, <, ...)
> + * @rulestr: smack label to be audited
> + * @vrule: pointer to save our own audit rule representation
> + *
> + * Prepare to audit cases where (@field @op @rulestr) is true.
> + * The label to be audited is created if necessay.
> + */
> +static int smack_audit_rule_init(u32 field, u32 op, char *rulestr, void
> **vrule)
> +{
> +	char **rule = (char **)vrule;
> +	*rule = NULL;
> +
> +	if (field != AUDIT_SUBJ_USER && field != AUDIT_OBJ_USER)
> +		return -EINVAL;
> +
> +	if (op != AUDIT_EQUAL && op != AUDIT_NOT_EQUAL)
> +		return -EINVAL;
> +
> +	*rule = smk_import(rulestr, 0);
> +
> +	return 0;
> +}
> +
> +/**
> + * smack_audit_rule_known - Distinguish Smack audit rules
> + * @krule: rule of interest, in Audit kernel representation format
> + *
> + * This is used to filter Smack rules from remaining Audit ones.
> + * If it's proved that this rule belongs to us, the
> + * audit_rule_match hook will be called to do the final judgement.
> + */
> +static int smack_audit_rule_known(struct audit_krule *krule)
> +{
> +	struct audit_field *f;
> +	int i;
> +
> +	for (i = 0; i < krule->field_count; i++) {
> +		f = &krule->fields[i];
> +
> +		if (f->type == AUDIT_SUBJ_USER || f->type == AUDIT_OBJ_USER)
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * smack_audit_rule_match - Audit given object ?
> + * @secid: security id for identifying the object to test
> + * @field: audit rule flags given from user-space
> + * @op: required testing operator
> + * @vrule: smack internal rule presentation
> + * @actx: audit context associated with the check
> + *
> + * The core Audit hook. It's used to take the decision of
> + * whether to audit or not to audit a given object.
> + */
> +static int smack_audit_rule_match(u32 secid, u32 field, u32 op, void *vrule,
> +				  struct audit_context *actx)
> +{
> +	char *smack;
> +	char *rule = vrule;
> +
> +	if (!rule) {
> +		audit_log(actx, GFP_KERNEL, AUDIT_SELINUX_ERR,
> +			  "Smack: missing rule\n");
> +		return -ENOENT;
> +	}
> +
> +	if (field != AUDIT_SUBJ_USER && field != AUDIT_OBJ_USER)
> +		return 0;
> +
> +	smack = smack_from_secid(secid);
> +
> +	/*
> +	 * No need to do string comparisons. If a match occurs,
> +	 * both pointers will point to the same smack_known
> +	 * label.
> +	 */
> +	if (op == AUDIT_EQUAL)
> +		return (rule == smack);
> +	if (op == AUDIT_NOT_EQUAL)
> +		return (rule != smack);
> +
> +	return 0;
> +}
> +
> +/**
> + * smack_audit_rule_free - free smack rule representation
> + * @vrule: rule to be freed.
> + *
> + * No memory was allocated.
> + */
> +static void smack_audit_rule_free(void *vrule)
> +{
> +	/* No-op */
> +}
> +
> +#endif /* CONFIG_AUDIT */
> +
> +/*
>   * smack_secid_to_secctx - return the smack label for a secid
>   * @secid: incoming integer
>   * @secdata: destination
> @@ -2467,6 +2610,7 @@ struct security_operations smack_ops = {
>  	.inode_getsecurity = 		smack_inode_getsecurity,
>  	.inode_setsecurity = 		smack_inode_setsecurity,
>  	.inode_listsecurity = 		smack_inode_listsecurity,
> +	.inode_getsecid =		smack_inode_getsecid,
>  
>  	.file_permission = 		smack_file_permission,
>  	.file_alloc_security = 		smack_file_alloc_security,
> @@ -2497,6 +2641,7 @@ struct security_operations smack_ops = {
>  	.task_to_inode = 		smack_task_to_inode,
>  
>  	.ipc_permission = 		smack_ipc_permission,
> +	.ipc_getsecid =			smack_ipc_getsecid,
>  
>  	.msg_msg_alloc_security = 	smack_msg_msg_alloc_security,
>  	.msg_msg_free_security = 	smack_msg_msg_free_security,
> @@ -2541,12 +2686,22 @@ struct security_operations smack_ops = {
>  	.sk_free_security = 		smack_sk_free_security,
>  	.sock_graft = 			smack_sock_graft,
>  	.inet_conn_request = 		smack_inet_conn_request,
> +
>   /* key management security hooks */
>  #ifdef CONFIG_KEYS
>  	.key_alloc = 			smack_key_alloc,
>  	.key_free = 			smack_key_free,
>  	.key_permission = 		smack_key_permission,
>  #endif /* CONFIG_KEYS */
> +
> + /* Audit hooks */
> +#ifdef CONFIG_AUDIT
> +	.audit_rule_init =		smack_audit_rule_init,
> +	.audit_rule_known =		smack_audit_rule_known,
> +	.audit_rule_match =		smack_audit_rule_match,
> +	.audit_rule_free =		smack_audit_rule_free,
> +#endif /* CONFIG_AUDIT */
> +
>  	.secid_to_secctx = 		smack_secid_to_secctx,
>  	.secctx_to_secid = 		smack_secctx_to_secid,
>  	.release_secctx = 		smack_release_secctx,
> 
> -- 
> 
> "Better to light a candle, than curse the darkness"
> 
> Ahmed S. Darwish
> Homepage: http://darwish.07.googlepages.com
> Blog: http://darwish-07.blogspot.com
> 
> 
> 


Casey Schaufler
casey@schaufler-ca.com
