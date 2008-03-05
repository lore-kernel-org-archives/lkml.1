Return-Path: <linux-kernel-owner+w=401wt.eu-S1764270AbYCEWbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764270AbYCEWbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756289AbYCEWbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:31:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687AbYCEWbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:31:10 -0500
Date: Wed, 5 Mar 2008 14:29:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: jmorris@namei.org, sds@tycho.nsa.gov, casey@schaufler-ca.com,
       bunk@kernel.org, chrisw@sous-sol.org, eparis@parisplace.org,
       adobriyan@sw.ru, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH -v5 -mm] LSM: Add security= boot parameter
Message-Id: <20080305142948.3d391d84.akpm@linux-foundation.org>
In-Reply-To: <20080304030407.GA25686@ubuntu>
References: <20080301211108.GF25835@cs181133002.pp.htv.fi>
	<674864.46980.qm@web36615.mail.mud.yahoo.com>
	<20080301232708.GA625@ubuntu>
	<20080302074912.GA3215@ubuntu>
	<20080302105946.GA6406@ubuntu>
	<Xine.LNX.4.64.0803031910170.6729@us.intercode.com.au>
	<20080303153510.GA6963@ubuntu>
	<1204559642.23738.63.camel@moss-spartans.epoch.ncsc.mil>
	<20080303212433.GA12998@ubuntu>
	<Xine.LNX.4.64.0803040906380.21610@us.intercode.com.au>
	<20080304030407.GA25686@ubuntu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008 05:04:07 +0200
"Ahmed S. Darwish" <darwish.07@gmail.com> wrote:

> Hi!,
> 
> [ 
> Fix stuff mentioned by James in parent mail:
> - use spinlocks instead of atomic counter (yes, this is clearer).
> - remove redundant BUG_ON
> - don't let LSMs loudly complain when they aren't chosen.
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
> ...
>  
> +/* Maximum number of letters for an LSM name string */
> +#define SECURITY_NAME_MAX	10

Is this long enough?

>  struct ctl_table;
>  struct audit_krule;
>  
>  ...
>
> -struct security_operations dummy_security_ops;
> +struct security_operations dummy_security_ops = { "dummy" };

Please don't rely upon the layout of data structures in this manner.  Use
".name = ".

>  
>  #define set_to_dummy_if_null(ops, function)				\
>  	do {								\
> diff --git a/security/security.c b/security/security.c
> index 1bf2ee4..def9fc0 100644
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

Please remove this and use compile-time initialisation with DEFINE_SPINLOCK.

Do we actually need the lock?  This code is only called at boot-time if I
understand it correctly?

Can chosen_lsm[] be __initdata?

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

I believe this can be __init.

> +	if (!security_module_enable(&selinux_ops)) {
> +		selinux_enabled = 0;
> +		return 0;
> +	}
> +
>
> ...
>
>  static __init int smack_init(void)
>  {
> +	if (!security_module_enable(&smack_ops))
> +		return 0;
> +
>  	printk(KERN_INFO "Smack:  Initializing.\n");
>  
>  	/*

hm.  selinux has a global selinux_enabled knob, but smack seems to be able
to get by without one.  +1 for smack ;)



