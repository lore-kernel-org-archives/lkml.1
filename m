Return-Path: <linux-kernel-owner+w=401wt.eu-S1759144AbYCEQds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759144AbYCEQds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509AbYCEQdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:33:37 -0500
Received: from web36611.mail.mud.yahoo.com ([209.191.85.28]:49133 "HELO
	web36611.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751294AbYCEQdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:33:36 -0500
X-YMail-OSG: vhFn60YVM1lYAHZ8aluESgqDYC5kWzoxOZCLthzifjSWqES63qXtOi6iU_HMOgusG_JZ1vWGsD5tKranTwaNGPaOAPK0T8obODg7EEk1Z5Ixtq.TOOJ1FER9wsXUkTAmaTpL7.n76_nd0dEaXRdDMg--
X-RocketYMMF: rancidfat
Date: Wed, 5 Mar 2008 08:33:34 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH -v7 -rc3] Security: Introduce security= boot parameter
To: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Paul Moore <paul.moore@hp.com>, Alexey Dobriyan <adobriyan@sw.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>
In-Reply-To: <20080305152901.GA26016@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <31708.65957.qm@web36611.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:

> Hi!,
> 
> [
>     Our usual changelog:
> 
>     - Fold the SMACK bugfix here cause now it depends on the
>       new introduced security_ symbol.
>     - Do not register smackfs if Smack was not loaded
>     - Do not use a global to check if Smack was enabled, use 
>       security_module_enable(ops) instead.
>     - Export smack_ops security operations to the rest of
>       SMACK code to satisfy above point.
>     - Remove James ACK cause patch semantics changed (could you
>       please reACK ?).
> ]
> 
> -->
> 
> Add the security= boot parameter. This is done to avoid LSM 
> registration clashes in case of more than one bult-in module.
> 
> User can choose a security module to enable at boot. If no 
> security= boot parameter is specified, only the first LSM 
> asking for registration will be loaded. An invalid security 
> module name will be treated as if no module has been chosen.
> 
> LSM modules must check now if they are allowed to register
> by calling security_module_enable(ops) first. Modify SELinux 
> and SMACK to do so.
> 
> Do not let SMACK register smackfs if it was not chosen on
> boot. Smackfs assumes that smack hooks are registered and
> the initial task security setup (swapper->security) is done.

If the problem with initializing smackfs is because the
locks aren't initialized why not leave the lock initializations
in smack_init, and have them done before the check to see if the
smack LSM is going to get used? Really, we're only talking
about the case where a kernel is configured for testing or
development purposes, and the lock initialization can't
be considered a major impact in any case.

> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> Reported-by: Alexey Dobriyan <adobriyan@sw.ru>
> ---
> 
>  Documentation/kernel-parameters.txt |    6 ++++
>  include/linux/security.h            |   12 +++++++++
>  security/dummy.c                    |    2 -
>  security/security.c                 |   46
> +++++++++++++++++++++++++++++++++++-
>  security/selinux/hooks.c            |    7 +++++
>  security/smack/smack.h              |    2 +
>  security/smack/smack_lsm.c          |    7 ++++-
>  security/smack/smackfs.c            |    9 ++++++-
> 
>  8 files changed, 87 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt
> b/Documentation/kernel-parameters.txt
> index 9a5b665..64efbdc 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -374,6 +374,12 @@ and is between 256 and 4096 characters. It is defined in
> the file
>  			possible to determine what the correct size should be.
>  			This option provides an override for these situations.
>  
> +	security=	[SECURITY] Choose a security module to enable at boot. 
> +			If this boot parameter is not specified, only the first 
> +			security module asking for security registration will be
> +			loaded. An invalid security module name will be treated
> +			as if no module has been chosen.
> +
>  	capability.disable=
>  			[SECURITY] Disable capabilities.  This would normally
>  			be used only if an alternative security model is to be
> diff --git a/include/linux/security.h b/include/linux/security.h
> index fe52cde..801c9ad 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -42,6 +42,9 @@
>  
>  extern unsigned securebits;
>  
> +/* Maximum number of letters for an LSM name string */
> +#define SECURITY_NAME_MAX	10
> +
>  struct ctl_table;
>  
>  /*
> @@ -117,6 +120,12 @@ struct request_sock;
>  /**
>   * struct security_operations - main security structure
>   *
> + * Security module identifier.
> + *
> + * @name:
> + *	A string that acts as a unique identifeir for the LSM with max number
> + *	of characters = SECURITY_NAME_MAX.
> + *
>   * Security hooks for program execution operations.
>   *
>   * @bprm_alloc_security:
> @@ -1207,6 +1216,8 @@ struct request_sock;
>   * This is the main security structure.
>   */
>  struct security_operations {
> +	char name[SECURITY_NAME_MAX + 1];
> +
>  	int (*ptrace) (struct task_struct * parent, struct task_struct * child);
>  	int (*capget) (struct task_struct * target,
>  		       kernel_cap_t * effective,
> @@ -1466,6 +1477,7 @@ struct security_operations {
>  
>  /* prototypes */
>  extern int security_init	(void);
> +extern int security_module_enable(struct security_operations *ops);
>  extern int register_security	(struct security_operations *ops);
>  extern int mod_reg_security	(const char *name, struct security_operations
> *ops);
>  extern struct dentry *securityfs_create_file(const char *name, mode_t mode,
> diff --git a/security/dummy.c b/security/dummy.c
> index 649326b..96d196f 100644
> --- a/security/dummy.c
> +++ b/security/dummy.c
> @@ -979,7 +979,7 @@ static inline int dummy_key_permission(key_ref_t key_ref,
>  }
>  #endif /* CONFIG_KEYS */
>  
> -struct security_operations dummy_security_ops;
> +struct security_operations dummy_security_ops = { "dummy" };
>  
>  #define set_to_dummy_if_null(ops, function)				\
>  	do {								\
> diff --git a/security/security.c b/security/security.c
> index d15e56c..f188672 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -17,6 +17,9 @@
>  #include <linux/kernel.h>
>  #include <linux/security.h>
>  
> +/* Boot-time LSM user choice */
> +static spinlock_t chosen_lsm_lock;
> +static char chosen_lsm[SECURITY_NAME_MAX + 1];
>  
>  /* things that live in dummy.c */
>  extern struct security_operations dummy_security_ops;
> @@ -62,18 +65,59 @@ int __init security_init(void)
>  	}
>  
>  	security_ops = &dummy_security_ops;
> +	spin_lock_init(&chosen_lsm_lock);
>  	do_security_initcalls();
>  
>  	return 0;
>  }
>  
> +/* Save user chosen LSM */
> +static int __init choose_lsm(char *str)
> +{
> +	strncpy(chosen_lsm, str, SECURITY_NAME_MAX);
> +	return 1;
> +}
> +__setup("security=", choose_lsm);
> +
> +/**
> + * security_module_enable - Load given security module on boot ?
> + * @ops: a pointer to the struct security_operations that is to be checked.
> + *
> + * Each LSM must pass this method before registering its own operations
> + * to avoid security registration races.
> + *
> + * Return true if:
> + *	-The passed LSM is the one chosen by user at boot time,
> + *	-or user didsn't specify a specific LSM and we're the first to ask
> + *	 for registeration permissoin.
> + * Otherwise, return false.
> + */
> +int security_module_enable(struct security_operations *ops)
> +{
> +	int rc = 1;
> +
> +	spin_lock(&chosen_lsm_lock);
> +	if (!*chosen_lsm)
> +		strncpy(chosen_lsm, ops->name, SECURITY_NAME_MAX);
> +	else if (strncmp(ops->name, chosen_lsm, SECURITY_NAME_MAX))
> +		rc = 0;
> +	spin_unlock(&chosen_lsm_lock);
> +
> +	if (rc)
> +		printk(KERN_INFO "Security: Loading '%s' security module.\n",
> +		       ops->name);
> +
> +	return rc;
> +}
> +
>  /**
>   * register_security - registers a security framework with the kernel
>   * @ops: a pointer to the struct security_options that is to be registered
>   *
>   * This function is to allow a security module to register itself with the
>   * kernel security subsystem.  Some rudimentary checking is done on the @ops
> - * value passed to this function.
> + * value passed to this function. You'll need to check first if your LSM
> + * is allowed to register its @ops by calling security_module_enable(@ops).
>   *
>   * If there is already a security module registered with the kernel,
>   * an error will be returned.  Otherwise 0 is returned on success.
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 75c2e99..49709a4 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -5219,6 +5219,8 @@ static int selinux_key_permission(key_ref_t key_ref,
>  #endif
>  
>  static struct security_operations selinux_ops = {
> +	.name =				"selinux",
> +
>  	.ptrace =			selinux_ptrace,
>  	.capget =			selinux_capget,
>  	.capset_check =			selinux_capset_check,
> @@ -5405,6 +5407,11 @@ static __init int selinux_init(void)
>  {
>  	struct task_security_struct *tsec;
>  
> +	if (!security_module_enable(&selinux_ops)) {
> +		selinux_enabled = 0;
> +		return 0;
> +	}
> +
>  	if (!selinux_enabled) {
>  		printk(KERN_INFO "SELinux:  Disabled at boot.\n");
>  		return 0;
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index a21a0e9..c444f48 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -15,6 +15,7 @@
>  
>  #include <linux/capability.h>
>  #include <linux/spinlock.h>
> +#include <linux/security.h>
>  #include <net/netlabel.h>
>  
>  /*
> @@ -195,6 +196,7 @@ extern struct smack_known smack_known_star;
>  extern struct smack_known smack_known_unset;
>  
>  extern struct smk_list_entry *smack_list;
> +extern struct security_operations smack_ops;
>  
>  /*
>   * Stricly for CIPSO level manipulation.
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 770eb06..afa7967 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -2433,7 +2433,9 @@ static void smack_release_secctx(char *secdata, u32
> seclen)
>  {
>  }
>  
> -static struct security_operations smack_ops = {
> +struct security_operations smack_ops = {
> +	.name =				"smack",
> +
>  	.ptrace = 			smack_ptrace,
>  	.capget = 			cap_capget,
>  	.capset_check = 		cap_capset_check,
> @@ -2566,6 +2568,9 @@ static struct security_operations smack_ops = {
>   */
>  static __init int smack_init(void)
>  {
> +	if (!security_module_enable(&smack_ops))
> +		return 0;
> +
>  	printk(KERN_INFO "Smack:  Initializing.\n");
>  
>  	/*
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index 358c92c..769da9a 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -986,12 +986,19 @@ static struct vfsmount *smackfs_mount;
>   *
>   * register the smackfs
>   *
> - * Returns 0 unless the registration fails.
> + * Do not register smackfs if Smack wasn't enabled
> + * on boot.
> + *
> + * Returns true if we were not chosen on boot or if
> + * we were chosen and filesystem registration succeeded.
>   */
>  static int __init init_smk_fs(void)
>  {
>  	int err;
>  
> +	if (!security_module_enable(&smack_ops))
> +		return 0;
> +
>  	err = register_filesystem(&smk_fs_type);
>  	if (!err) {
>  		smackfs_mount = kern_mount(&smk_fs_type);
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
