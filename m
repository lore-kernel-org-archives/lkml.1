Return-Path: <linux-kernel-owner+w=401wt.eu-S1758487AbZDEUmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487AbZDEUmg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 16:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758118AbZDEUmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 16:42:25 -0400
Received: from smtp6.tech.numericable.fr ([82.216.111.42]:53046 "EHLO
	smtp6.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758115AbZDEUmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 16:42:24 -0400
Message-ID: <49D917AB.8000400@numericable.fr>
Date: Sun, 05 Apr 2009 22:42:19 +0200
From: Etienne Basset <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: LSM <linux-security-module@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-audit@redhat.com
Subject: Re: [PATCH 2/2] security/smack implement logging V2
References: <49D8700A.8030605@numericable.fr> <49D8EF0C.3020503@schaufler-ca.com>
In-Reply-To: <49D8EF0C.3020503@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler wrote:
> Etienne Basset wrote:
>> the following patch, add logging of Smack security decisions. 
>> This is of course very useful to understand what your current smack policy does.
>> As suggested by Casey, it also now forbids labels with ' or "
>>   
> 
> It occurred to me later that \ should be disallowed as well.
> 
OK, will do

>> It introduces a '/smack/logging' switch :
>> 0: no logging
>> 1: log denied (default)
>> 2: log accepted 
>> 3: log denied&accepted 
>>
>>
>>
>> Signed-off-by: Etienne Basset <etienne.basset@numericable.fr>
>> ---
>> diff --git a/security/smack/Kconfig b/security/smack/Kconfig
>> index 603b087..d83e708 100644
>> --- a/security/smack/Kconfig
>> +++ b/security/smack/Kconfig
>> @@ -1,6 +1,6 @@
>>  config SECURITY_SMACK
>>  	bool "Simplified Mandatory Access Control Kernel Support"
>> -	depends on NETLABEL && SECURITY_NETWORK
>> +	depends on NETLABEL && SECURITY_NETWORK && AUDIT
>>   
> 
> AUDIT can't be required. While MAC does make sense in certain
> embedded environments, audit does not.
>
OK. 

 
>>  	default n
>>  	help
>>  	  This selects the Simplified Mandatory Access Control Kernel.
>> diff --git a/security/smack/smack.h b/security/smack/smack.h
>> index 42ef313..4639d56 100644
>> --- a/security/smack/smack.h
>> +++ b/security/smack/smack.h
>> @@ -20,6 +20,7 @@
>>  #include <net/netlabel.h>
>>  #include <linux/list.h>
>>  #include <linux/rculist.h>
>> +#include <linux/lsm_audit.h>
>>  
>>  /*
>>   * Why 23? CIPSO is constrained to 30, so a 32 byte buffer is
>> @@ -179,6 +180,11 @@ struct smack_known {
>>  #define MAY_NOT		0
>>  
>>  /*
>> + * Number of access types used by Smack (rwxa)
>> + */
>> +#define SMK_NUM_ACCESS_TYPE 4
>> +
>> +/*
>>   * These functions are in smack_lsm.c
>>   */
>>  struct inode_smack *new_inode_smack(char *);
>> @@ -237,4 +243,22 @@ static inline char *smk_of_inode(const struct inode *isp)
>>  	return sip->smk_inode;
>>  }
>>  
>> +/*
>> + * logging functions
>> + */
>> +struct smack_log_policy {
>> +	int log_accepted;
>> +	int log_denied;
>> +};
>>   
> 
> Use bits in a integer rather than a pair of integers unless you
> are anticipating using multiple values for them.
> 
OK will do

>> +
>> +extern struct smack_log_policy log_policy;
>> +
>> +void smack_log(char *subject_label, char *object_label,
>> +		int request,
>> +		int result, struct common_audit_data *auditdata);
>> +
>> +int smk_access_log(char *subjectlabel, char *olabel, int access,
>> +			 struct common_audit_data *a);
>> +int smk_curacc_log(char *olabel, int access, struct common_audit_data *a);
>>   
> 
> It looks like the only difference between these are their non-logging
> versions is the logging. I say go ahead and add the auditdata parameter
> to smk_access and smk_curacc and allow for the case where it is NULL.
> 
i would prefer keeping a logging and a non-logging variant
maybe rename smk_access & smk_curacc to smk_access_nolog & smk_curacc_nolog
Or you really prefer that we pass a NULL when we want the non-logging?
I guess its a matter of taste, so i let you decide :)


>> +
>>  #endif  /* _SECURITY_SMACK_H */
>> diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
>> index ac0a270..2da8a40 100644
>> --- a/security/smack/smack_access.c
>> +++ b/security/smack/smack_access.c
>> @@ -13,6 +13,7 @@
>>  #include <linux/types.h>
>>  #include <linux/fs.h>
>>  #include <linux/sched.h>
>> +
>>   
> 
> Remove the empty line.
> 
>>  #include "smack.h"
>>  
>>  struct smack_known smack_known_huh = {
>> @@ -59,6 +60,14 @@ LIST_HEAD(smack_known_list);
>>   */
>>  static u32 smack_next_secid = 10;
>>  
>> +/* what events do we log
>> + * can be overwriten at run-time by /smack/logging
>> + */
>> +struct smack_log_policy log_policy = {
>> +	.log_accepted = 0,
>> +	.log_denied   = 1
>> +};
>> +
>>   
> 
> As I mentioned before, log_policy should be an integer with
> bits defined for accepted and denied logging.
> 
>>  /**
>>   * smk_access - determine if a subject has a specific access to an object
>>   * @subject_label: a pointer to the subject's Smack label
>> @@ -185,6 +194,129 @@ int smk_curacc(char *obj_label, u32 mode)
>>  	return rc;
>>  }
>>  
>> +/**
>> + * smack_str_from_perm : helper to transalate an int to a
>> + * readable string
>> + * @string : the string to fill
>> + * @access : the int
>> + *
>> + **/
>> +static inline void smack_str_from_perm(char *string, int access)
>> +{
>> +	int i = 0;
>> +	if (access & MAY_READ)
>> +		string[i++] = 'r';
>> +	if (access & MAY_WRITE)
>> +		string[i++] = 'w';
>> +	if (access & MAY_EXEC)
>> +		string[i++] = 'x';
>> +	if (access & MAY_APPEND)
>> +		string[i++] = 'a';
>> +	string[i] = '\0';
>> +}
>> +
>> +/**
>> + * smack_log_callback - SMACK specific information
>> + * will be called by generic audit code
>> + * @ab : the audit_buffer
>> + * @a  : audit_data
>> + *
>> + */
>> +static void smack_log_callback(struct audit_buffer *ab, void *a)
>> +{
>> +	struct common_audit_data *ad = a;
>> +#define smack_info lsm_priv.smack_audit_data
>>   
> 
> Create a variable of the right type and assign it rather than this define.
> 
>> +	audit_log_format(ab, "SMACK[%s]: action=%s", ad->function,
>> +			ad->smack_info.result ? "denied" : "granted");
>> +	audit_log_format(ab, " subject=");
>> +	audit_log_untrustedstring(ab, ad->smack_info.subject);
>>   
> 
> I'm not 100% sure, but I think that untrustedstring is unnecessary
> with {'"\} disallowed and Smack labels always known to be NULL
> terminated strings.
>
i think its unneccessary, as now smack labels are more restrictive than
audit.c:audit_string_contains_control

>> +	audit_log_format(ab, " object=");
>> +	audit_log_untrustedstring(ab, ad->smack_info.object);
>> +	audit_log_format(ab, " requested=%s", ad->smack_info.request);
>> +#undef smack_info
>> +}
>> +
>> +/**
>> + *  smack_log - Audit the granting or denial of permissions.
>> + *  @subject_label : smack label of the requester
>> + *  @object_label  : smack label of the object being accessed
>> + *  @request: requested permissions
>> + *  @result: result from smk_access
>> + *  @a:  auxiliary audit data
>> + *
>> + * Audit the granting or denial of permissions in accordance
>> + * with the policy.
>> + **/
>> +void smack_log(char *subject_label, char *object_label, int request,
>> +		int result, struct common_audit_data *a)
>> +{
>> +	char request_buffer[SMK_NUM_ACCESS_TYPE + 1];
>> +	u32 denied;
>> +	u32 audited = 0;
>> +
>> +	/* check if we have to log the current event */
>> +	if (result != 0) {
>> +		denied = 1;
>> +		if  (log_policy.log_denied)
>> +			audited = 1;
>> +	} else {
>> +		denied = 0;
>> +		if (log_policy.log_accepted)
>> +			audited = 1;
>> +	}
>> +	if (audited == 0)
>> +		return;
>>   
> 
>         if (result == 0 && (log_policy & LOG_ACCEPTED) == 0)
>                 return;
>         if (result == 1 && (log_policy & LOG_DENIED) == 0)
>                 return;
> 
> Cleaner, no?
>
yes
 
>> +
>> +	if (a->function == NULL)
>> +		a->function = "unknown";
>> +
>> +#define smack_info lsm_priv.smack_audit_data
>>   
> 
> Use a variable instead of the define.
> 
OK

>> +	/* end preparing the audit data */
>> +	smack_str_from_perm(request_buffer, request);
>> +	a->smack_info.subject = subject_label;
>> +	a->smack_info.object  = object_label;
>> +	a->smack_info.request = request_buffer;
>> +	a->smack_info.result  = result;
>> +	a->lsm_pre_audit = smack_log_callback;
>> +
>> +	common_lsm_audit(a);
>> +#undef smack_info
>> +}
>> +
>> +/**
>> + * smk_curracc_log : check access of current on olabel
>> + * @olabel : label being accessed
>> + * @access : access requested
>> + * @a	   : pointer to data
>> + *
>> + * return the same perm return by smk_curacc
>> + */
>> +int smk_curacc_log(char *olabel, int access, struct common_audit_data *a)
>> +{
>> +	int rc;
>> +	rc = smk_curacc(olabel, access);
>> +	smack_log(current_security(), olabel, access, rc, a);
>> +	return rc;
>> +}
>>   
> 
> I definitely think that adding the audit data to smk_curacc would work.
> 
>> +
>> +/**
>> + * smk_access_log : check access of slabel on olabel
>> + * @slabel : subjet label
>> + * @olabel : label being accessed
>> + * @access : access requested
>> + * @a	   : pointer to data
>> + *
>> + * return the same perm return by smk_access
>> + */
>> +int smk_access_log(char *slabel, char *olabel, int access,
>> +		struct common_audit_data *a)
>> +{
>> +	int rc;
>> +	rc = smk_access(slabel, olabel, access);
>> +	smack_log(slabel, olabel, access, rc, a);
>> +	return rc;
>> +}
>> +
>>   
> 
> As above.
> 
>>  static DEFINE_MUTEX(smack_known_lock);
>>  
>>  /**
>> @@ -209,7 +341,8 @@ struct smack_known *smk_import_entry(const char *string, int len)
>>  		if (found)
>>  			smack[i] = '\0';
>>  		else if (i >= len || string[i] > '~' || string[i] <= ' ' ||
>> -			 string[i] == '/') {
>> +				string[i] == '/' || string[i] == '"' ||
>> +				string[i] == 0x27) {
>>   
> 
> I would prefer '\'' to 0x27, and add a check for '\\' please.
> 
OK

> 
>>  			smack[i] = '\0';
>>  			found = 1;
>>  		} else
>> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
>> index 9215149..c1844ed 100644
>> --- a/security/smack/smack_lsm.c
>> +++ b/security/smack/smack_lsm.c
>> @@ -103,14 +103,21 @@ struct inode_smack *new_inode_smack(char *smack)
>>  static int smack_ptrace_may_access(struct task_struct *ctp, unsigned int mode)
>>  {
>>  	int rc;
>> +	struct common_audit_data ad;
>>  
>>  	rc = cap_ptrace_may_access(ctp, mode);
>>  	if (rc != 0)
>>  		return rc;
>>  
>> +	COMMON_AUDIT_DATA_INIT(&ad, TASK);
>> +	ad.u.tsk = ctp;
>>   
> 
> It would be nice if audit data was only manipulated if audit is
> installed, but I don't like the idea of ifdeffing everything
> very much either. How about a static inline in smack.h that is
> ifdeffed for audit? smack_audit_init? There would need to be one
> for each field, too.
>
why not, but instead of a "initialiser" for each field i'll prefer a macro
 To save some stack we could also conditionnaly define the "common_audit_data"

something like :

#ifdef CONFIG_AUDIT
#define DEFINE_SMACK_AUDIT_DATA(ad) struct common_audit_data ad
void smack_audit_init(..) {
 COMMON_AUDIT_DATA_INIT(...)
}
#define SMACK_AUDIT_DATA_SET_FIELD(_ad, _field, _value) (_ad._field = _value)
...
#else
#define DEFINE_SMACK_AUDIT_DATA(ad)
void smack_audit_init(..)
{
} 
#define SMACK_AUDIT_DATA_SET_FIELD(_ad, _field, _value) 
#endif
 


> Assign the result of current_security() to a variable so
> you don't have to call it multiple times. This comment applies
> in all instances below.
> 
> 
OK

>> +static int smk_curacc_on_task(struct task_struct *p, int access)
>> +{
>> +	struct common_audit_data ad;
>> +
>> +	COMMON_AUDIT_DATA_INIT(&ad, TASK);
>> +	ad.u.tsk = p;
>> +	return smk_curacc_log(task_security(p), access, &ad);
>> +}
>>   
> 
> I don't think that this is all that much help, and it adds a
> level indirection. Better to do the audit initialization in a
> consistent way, even if it is clumsy.
> 
> Hum. It does happen a lot. I suppose it's OK.
>
well, it was easier to do it that way, and uses less code
 
>> +
>> +/**
>>   * smack_task_setpgid - Smack check on setting pgid
>>   * @p: the task object
>>   * @pgid: unused
>> @@ -1060,7 +1168,7 @@ static int smack_kernel_create_files_as(struct cred *new,
>>   */
>>  static int smack_task_setpgid(struct task_struct *p, pid_t pgid)
>>  {
>> -	return smk_curacc(task_security(p), MAY_WRITE);
>> +	return smk_curacc_on_task(p, MAY_WRITE);
>>  }
>>  
>>  /**
>> @@ -1071,7 +1179,7 @@ static int smack_task_setpgid(struct task_struct *p, pid_t pgid)
>>   */
>>  static int smack_task_getpgid(struct task_struct *p)
>>  {
>> -	return smk_curacc(task_security(p), MAY_READ);
>> +	return smk_curacc_on_task(p, MAY_READ);
>>  }
>>  
>>  /**
>> @@ -1082,7 +1190,7 @@ static int smack_task_getpgid(struct task_struct *p)
>>   */
>>  static int smack_task_getsid(struct task_struct *p)
>>  {
>> -	return smk_curacc(task_security(p), MAY_READ);
>> +	return smk_curacc_on_task(p, MAY_READ);
>>  }
>>  
>>  /**
>> @@ -1110,7 +1218,7 @@ static int smack_task_setnice(struct task_struct *p, int nice)
>>  
>>  	rc = cap_task_setnice(p, nice);
>>  	if (rc == 0)
>> -		rc = smk_curacc(task_security(p), MAY_WRITE);
>> +		rc = smk_curacc_on_task(p, MAY_WRITE);
>>  	return rc;
>>  }
>>  
>> @@ -1127,7 +1235,7 @@ static int smack_task_setioprio(struct task_struct *p, int ioprio)
>>  
>>  	rc = cap_task_setioprio(p, ioprio);
>>  	if (rc == 0)
>> -		rc = smk_curacc(task_security(p), MAY_WRITE);
>> +		rc = smk_curacc_on_task(p, MAY_WRITE);
>>  	return rc;
>>  }
>>  
>> @@ -1139,7 +1247,7 @@ static int smack_task_setioprio(struct task_struct *p, int ioprio)
>>   */
>>  static int smack_task_getioprio(struct task_struct *p)
>>  {
>> -	return smk_curacc(task_security(p), MAY_READ);
>> +	return smk_curacc_on_task(p, MAY_READ);
>>  }
>>  
>>  /**
>> @@ -1157,7 +1265,7 @@ static int smack_task_setscheduler(struct task_struct *p, int policy,
>>  
>>  	rc = cap_task_setscheduler(p, policy, lp);
>>  	if (rc == 0)
>> -		rc = smk_curacc(task_security(p), MAY_WRITE);
>> +		rc = smk_curacc_on_task(p, MAY_WRITE);
>>  	return rc;
>>  }
>>  
>> @@ -1169,7 +1277,7 @@ static int smack_task_setscheduler(struct task_struct *p, int policy,
>>   */
>>  static int smack_task_getscheduler(struct task_struct *p)
>>  {
>> -	return smk_curacc(task_security(p), MAY_READ);
>> +	return smk_curacc_on_task(p, MAY_READ);
>>  }
>>  
>>  /**
>> @@ -1180,7 +1288,7 @@ static int smack_task_getscheduler(struct task_struct *p)
>>   */
>>  static int smack_task_movememory(struct task_struct *p)
>>  {
>> -	return smk_curacc(task_security(p), MAY_WRITE);
>> +	return smk_curacc_on_task(p, MAY_WRITE);
>>  }
>>  
>>  /**
>> @@ -1198,18 +1306,23 @@ static int smack_task_movememory(struct task_struct *p)
>>  static int smack_task_kill(struct task_struct *p, struct siginfo *info,
>>  			   int sig, u32 secid)
>>  {
>> +	struct common_audit_data ad;
>> +
>> +	COMMON_AUDIT_DATA_INIT(&ad, TASK);
>> +	ad.u.tsk = p;
>>  	/*
>>  	 * Sending a signal requires that the sender
>>  	 * can write the receiver.
>>  	 */
>>  	if (secid == 0)
>> -		return smk_curacc(task_security(p), MAY_WRITE);
>> +		return smk_curacc_log(task_security(p), MAY_WRITE, &ad);
>>  	/*
>>  	 * If the secid isn't 0 we're dealing with some USB IO
>>  	 * specific behavior. This is not clean. For one thing
>>  	 * we can't take privilege into account.
>>  	 */
>> -	return smk_access(smack_from_secid(secid), task_security(p), MAY_WRITE);
>> +	return smk_access_log(smack_from_secid(secid), task_security(p),
>> +				 MAY_WRITE, &ad);
>>  }
>>  
>>  /**
>> @@ -1220,12 +1333,13 @@ static int smack_task_kill(struct task_struct *p, struct siginfo *info,
>>   */
>>  static int smack_task_wait(struct task_struct *p)
>>  {
>> +	struct common_audit_data ad;
>>  	int rc;
>>  
>> +	/* we don't log here, we can be overriden */
>>  	rc = smk_access(current_security(), task_security(p), MAY_WRITE);
>>  	if (rc == 0)
>> -		return 0;
>> -
>> +		goto out_log;
>>  	/*
>>  	 * Allow the operation to succeed if either task
>>  	 * has privilege to perform operations that might
>> @@ -1239,7 +1353,11 @@ static int smack_task_wait(struct task_struct *p)
>>  	 */
>>  	if (capable(CAP_MAC_OVERRIDE) || has_capability(p, CAP_MAC_OVERRIDE))
>>  		return 0;
>>   
> 
> Did you miss this return, or is this check special?
>

humm... yes this should be rc = 0; (and i forgot one another place too :) )


>> -
>> +	/* we log only if we didn't get overriden */
>> + out_log:
>> +	COMMON_AUDIT_DATA_INIT(&ad, TASK);
>> +	ad.u.tsk = p;
>> +	smack_log(current_security(), task_security(p), MAY_WRITE, rc, &ad);
>>  	return rc;
>>  }
>>  
>> @@ -1455,12 +1573,18 @@ static int smack_netlabel_send(struct sock *sk, struct sockaddr_in *sap)
>>  	int sk_lbl;
>>  	char *hostsp;
>>  	struct socket_smack *ssp = sk->sk_security;
>> +	struct common_audit_data ad;
>>  
>>  	rcu_read_lock();
>>  	hostsp = smack_host_label(sap);
>>  	if (hostsp != NULL) {
>>  		sk_lbl = SMACK_UNLABELED_SOCKET;
>> -		rc = smk_access(ssp->smk_out, hostsp, MAY_WRITE);
>> +		COMMON_AUDIT_DATA_INIT(&ad, NET);
>> +		ad.u.net.family = sap->sin_family;
>> +		ad.u.net.dport = sap->sin_port;
>> +		ad.u.net.v4info.daddr = sap->sin_addr.s_addr;
>> +
>> +		rc = smk_access_log(ssp->smk_out, hostsp, MAY_WRITE, &ad);
>>  	} else {
>>  		sk_lbl = SMACK_CIPSO_SOCKET;
>>  		rc = 0;
>> @@ -1656,6 +1780,23 @@ static void smack_shm_free_security(struct shmid_kernel *shp)
>>  }
>>   
> 
> Now this is tricky. You'll get an audit record for single-label
> hosts, but not for those that use CIPSO. The former is good, the
> latter is bad.
> 
gargll you're right

thanks for the review,
Etienne
