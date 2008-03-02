Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYCBDlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYCBDlX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 22:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbYCBDlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 22:41:09 -0500
Received: from web36609.mail.mud.yahoo.com ([209.191.85.26]:20238 "HELO
	web36609.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751147AbYCBDlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 22:41:07 -0500
X-YMail-OSG: hpIQQdkVM1myjMC3OjV7sKFn8Vs9ASNf4ssHmBbwp1Gselw.wLk1HoNZ10siy2r.nlCTxnUDgKMn2V0LXGGghX_6qIoBpY3Wl9Xg3iQv_47sXC4XhZM-
X-RocketYMMF: rancidfat
Date: Sat, 1 Mar 2008 19:41:04 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH -v2 -mm] LSM: Add security= boot parameter
To: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Casey Schaufler <casey@schaufler-ca.com>
Cc: Adrian Bunk <bunk@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, Alexey Dobriyan <adobriyan@sw.ru>,
       LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>,
       Anrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080301232708.GA625@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <230454.43756.qm@web36609.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:

> Hi!,
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
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> ---
> 
> I'll send a similar patch for 2.6.25 if no more concerns for
> the patch exist. 
> 
> Adrian, Casey, Does this one have any more issues ?
> 
>  Documentation/kernel-parameters.txt |    6 ++++
>  include/linux/security.h            |   12 +++++++++
>  security/dummy.c                    |    3 +-
>  security/security.c                 |   47
> +++++++++++++++++++++++++++++++++++-
>  security/selinux/hooks.c            |    5 +++
>  security/smack/smack_lsm.c          |    7 +++++
> 
>  6 files changed, 77 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt
> b/Documentation/kernel-parameters.txt
> index c64dfd7..85044e8 100644
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

Yes, this is better.

>  	capability.disable=
>  			[SECURITY] Disable capabilities.  This would normally
>  			be used only if an alternative security model is to be
> diff --git a/include/linux/security.h b/include/linux/security.h
> index a33fd03..416afcf 100644
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
> + *	A string that acts as  unique identifeir for the LSM with max number 
> + *	of characters = SECURITY_NAME_MAX.
> + *
>   * Security hooks for program execution operations.
>   *
>   * @bprm_alloc_security:
> @@ -1218,6 +1227,8 @@ struct request_sock;
>   * This is the main security structure.
>   */
>  struct security_operations {
> +	char name[SECURITY_NAME_MAX + 1];
> +
>  	int (*ptrace) (struct task_struct * parent, struct task_struct * child);
>  	int (*capget) (struct task_struct * target,
>  		       kernel_cap_t * effective,
> @@ -1477,6 +1488,7 @@ struct security_operations {
>  
>  /* prototypes */
>  extern int security_init	(void);
> +extern int security_module_enable(struct security_operations *ops);
>  extern int register_security	(struct security_operations *ops);
>  extern int mod_reg_security	(const char *name, struct security_operations
> *ops);
>  extern struct dentry *securityfs_create_file(const char *name, mode_t mode,
> diff --git a/security/dummy.c b/security/dummy.c
> index 6a0056b..7cb999c 100644
> --- a/security/dummy.c
> +++ b/security/dummy.c
> @@ -986,7 +986,7 @@ static int dummy_key_getsecurity(struct key *key, char
> **_buffer)
>  
>  #endif /* CONFIG_KEYS */
>  
> -struct security_operations dummy_security_ops;
> +struct security_operations dummy_security_ops = { "dummy" };
>  
>  #define set_to_dummy_if_null(ops, function)				\
>  	do {								\
> @@ -999,6 +999,7 @@ struct security_operations dummy_security_ops;
>  
>  void security_fixup_ops (struct security_operations *ops)
>  {
> +	BUG_ON(!ops->name);
>  	set_to_dummy_if_null(ops, ptrace);
>  	set_to_dummy_if_null(ops, capget);
>  	set_to_dummy_if_null(ops, capset_check);
> diff --git a/security/security.c b/security/security.c
> index 3e75b90..261d2e4 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -17,6 +17,9 @@
>  #include <linux/kernel.h>
>  #include <linux/security.h>
>  
> +/* Boot-time LSM user choice */
> +static char chosen_lsm[SECURITY_NAME_MAX + 1];
> +static atomic_t security_ops_registered = ATOMIC_INIT(0);
>  
>  /* things that live in dummy.c */
>  extern struct security_operations dummy_security_ops;
> @@ -67,13 +70,54 @@ int __init security_init(void)
>  	return 0;
>  }
>  
> +/* Save user chosen LSM */
> +static int __init choose_lsm(char *str)
> +{
> +	if (strlen(str) > SECURITY_NAME_MAX) {
> +		printk(KERN_INFO "Security: LSM name length extends possible"
> +		       "limit.\n");
> +		printk(KERN_INFO "Security: Ignoring passed security= "
> +		       "parameter.\n");
> +		return 0;
> +	}
> +
> +	strncpy(chosen_lsm, str, SECURITY_NAME_MAX);
> +	return 1;
> +}
> +__setup("security=", choose_lsm);
> +
> +/**
> + * security_module_enable - Load given security module on boot ?
> + * @ops: a pointer to the struct security_operations that is to be checked.
> + *
> + * Return true if:
> + *	-The passed LSM is the one chosen by user at boot time,
> + *	-or user didsn't specify a specific LSM and we're the first to ask
> + *	 for registeration permissoin.
> + * Otherwise, return false.
> + */
> +int security_module_enable(struct security_operations *ops)
> +{
> +	if (!ops || !ops->name)
> +		return 0;
> +
> +	if (!*chosen_lsm && !atomic_read(&security_ops_registered))
> +		return 1;
> +
> +	if (!strncmp(ops->name, chosen_lsm, SECURITY_NAME_MAX))
> +		return 1;
> +	
> +	return 0;
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
> + * is allowed to register by calling security_module_enable(@ops).
>   *
>   * If there is already a security module registered with the kernel,
>   * an error will be returned.  Otherwise 0 is returned on success.
> @@ -90,6 +134,7 @@ int register_security(struct security_operations *ops)
>  		return -EAGAIN;
>  
>  	security_ops = ops;
> +	atomic_inc(&security_ops_registered);
>  
>  	return 0;
>  }
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index f42ebfc..fe30d2b 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -5233,6 +5233,8 @@ static int selinux_key_getsecurity(struct key *key,
> char **_buffer)
>  #endif
>  
>  static struct security_operations selinux_ops = {
> +	.name =				"selinux",
> +
>  	.ptrace =			selinux_ptrace,
>  	.capget =			selinux_capget,
>  	.capset_check =			selinux_capset_check,
> @@ -5420,7 +5422,8 @@ static __init int selinux_init(void)
>  {
>  	struct task_security_struct *tsec;
>  
> -	if (!selinux_enabled) {
> +	if (!selinux_enabled || !security_module_enable(&selinux_ops)) {
> +		selinux_enabled = 0;
>  		printk(KERN_INFO "SELinux:  Disabled at boot.\n");

How about "SELinux: Not enabled because LSM %s is already enabled.\n"

>  		return 0;
>  	}
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 2b5d6f7..3fc8c6e 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -2358,6 +2358,8 @@ static void smack_release_secctx(char *secdata, u32
> seclen)
>  }
>  
>  static struct security_operations smack_ops = {
> +	.name =				"smack",
> +
>  	.ptrace = 			smack_ptrace,
>  	.capget = 			cap_capget,
>  	.capset_check = 		cap_capset_check,
> @@ -2485,6 +2487,11 @@ static struct security_operations smack_ops = {
>   */
>  static __init int smack_init(void)
>  {
> +	if (!security_module_enable(&smack_ops)) {
> +		printk(KERN_INFO "Smack: Disabled at boot.\n");

How about "Smack: Not enabled because LSM %s is already enabled.\n"

> +		return 0;
> +	}
> +
>  	printk(KERN_INFO "Smack:  Initializing.\n");
>  
>  	/*
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
