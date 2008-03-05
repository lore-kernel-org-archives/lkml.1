Return-Path: <linux-kernel-owner+w=401wt.eu-S1765685AbYCEXFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765685AbYCEXFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932184AbYCEW7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:59:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:15953 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551AbYCEW7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:59:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=gF8P9oqPRTIH8d60tSqJzTEFKekS5optO0OqbsOLeVhq9EkUxe94PE5x2dvDpYk5+n+eH5RIRNv+JQtWeR1un+sBCxL1afPTN5i1n/+86wpeLgYo0NpzqaSMeDNvSf6AwVN8xaWPVEk0HK7Y9BPnsmMWMlZ3tQertO4rAQEHGJU=
Date: Thu, 6 Mar 2008 00:56:28 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jmorris@namei.org, sds@tycho.nsa.gov, casey@schaufler-ca.com,
       bunk@kernel.org, chrisw@sous-sol.org, eparis@parisplace.org,
       adobriyan@sw.ru, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH -v5 -mm] LSM: Add security= boot parameter
Message-ID: <20080305225628.GA6746@ubuntu>
References: <20080301232708.GA625@ubuntu> <20080302074912.GA3215@ubuntu> <20080302105946.GA6406@ubuntu> <Xine.LNX.4.64.0803031910170.6729@us.intercode.com.au> <20080303153510.GA6963@ubuntu> <1204559642.23738.63.camel@moss-spartans.epoch.ncsc.mil> <20080303212433.GA12998@ubuntu> <Xine.LNX.4.64.0803040906380.21610@us.intercode.com.au> <20080304030407.GA25686@ubuntu> <20080305142948.3d391d84.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305142948.3d391d84.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 02:29:48PM -0800, Andrew Morton wrote:
> On Tue, 4 Mar 2008 05:04:07 +0200
> "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:
> 
...
> > ...
> >  
> > +/* Maximum number of letters for an LSM name string */
> > +#define SECURITY_NAME_MAX	10
> 
> Is this long enough?
> 

I've judged from the four common applicants (selinux, smack,
apparmor, tomoyo) that 10 would be enough. Anyway this will be
easy to fix when something longer appears.

> >  struct ctl_table;
> >  struct audit_krule;
> >  
> >  ...
> >
> > -struct security_operations dummy_security_ops;
> > +struct security_operations dummy_security_ops = { "dummy" };
> 
> Please don't rely upon the layout of data structures in this manner.  Use
> ".name = ".
> 

Will do.

> >  
> >  #define set_to_dummy_if_null(ops, function)				\
> >  	do {								\
> > diff --git a/security/security.c b/security/security.c
> > index 1bf2ee4..def9fc0 100644
> > --- a/security/security.c
> > +++ b/security/security.c
> > @@ -17,6 +17,9 @@
> >  #include <linux/kernel.h>
> >  #include <linux/security.h>
> >  
> > +/* Boot-time LSM user choice */
> > +static spinlock_t chosen_lsm_lock;
> > +static char chosen_lsm[SECURITY_NAME_MAX + 1];
> >  
> >  /* things that live in dummy.c */
> >  extern struct security_operations dummy_security_ops;
> > @@ -62,18 +65,59 @@ int __init security_init(void)
> >  	}
> >  
> >  	security_ops = &dummy_security_ops;
> > +	spin_lock_init(&chosen_lsm_lock);
> 
> Please remove this and use compile-time initialisation with DEFINE_SPINLOCK.
> 

Ooh I thought the dynamic one was better cause I remember I read it
somewhere on LWN that this is nicer for the RT-patches. I'll modify
it, no problem.

> Do we actually need the lock?  This code is only called at boot-time if I
> understand it correctly?
> 

In the latest version (-v7b, in another thread, CCed), security_module_enable()
is also used to let an LSM know if it's currently loaded or not. This
was done to avoid using a `smack_enabled' global.

I'll resend the v7b for -mm once the LSM devs give their ACKs for the
-rc3 one.

> Can chosen_lsm[] be __initdata?
> 

You're the expert ;), I don't really understand the difference.

...
> >
> > +/**
> > + * security_module_enable - Load given security module on boot ?
> > + * @ops: a pointer to the struct security_operations that is to be checked.
> > + *
> > + * Each LSM must pass this method before registering its own operations
> > + * to avoid security registration races.
> > + *
> > + * Return true if:
> > + *	-The passed LSM is the one chosen by user at boot time,
> > + *	-or user didsn't specify a specific LSM and we're the first to ask
> > + *	 for registeration permissoin.
> > + * Otherwise, return false.
> > + */
> > +int security_module_enable(struct security_operations *ops)
> > +{
> > +	int rc = 1;
> > +
> > +	spin_lock(&chosen_lsm_lock);
> > +	if (!*chosen_lsm)
> > +		strncpy(chosen_lsm, ops->name, SECURITY_NAME_MAX);
> > +	else if (strncmp(ops->name, chosen_lsm, SECURITY_NAME_MAX))
> > +		rc = 0;
> > +	spin_unlock(&chosen_lsm_lock);
> > +
> > +	if (rc)
> > +		printk(KERN_INFO "Security: Loading '%s' security module.\n",
> > +		       ops->name);
> > +
> > +	return rc;
> > +}
> 
> I believe this can be __init.
> 

Will do.

> > +	if (!security_module_enable(&selinux_ops)) {
> > +		selinux_enabled = 0;
> > +		return 0;
> > +	}
> > +
> >
> > ...
> >
> >  static __init int smack_init(void)
> >  {
> > +	if (!security_module_enable(&smack_ops))
> > +		return 0;
> > +
> >  	printk(KERN_INFO "Smack:  Initializing.\n");
> >  
> >  	/*
> 
> hm.  selinux has a global selinux_enabled knob, but smack seems to be able
> to get by without one.  +1 for smack ;)
> 

Thanks to Linus ;). 

I've sent a patch that added a similar global yesterday and it was 
knocked-down by Linus after exactly 2 minutes. 
The situation is handled now without a global in v7/v7b.

Regards,

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

