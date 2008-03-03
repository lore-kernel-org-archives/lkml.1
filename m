Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbYCCWSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbYCCWSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 17:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbYCCWSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 17:18:39 -0500
Received: from namei.org ([69.55.235.186]:42917 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750842AbYCCWSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 17:18:38 -0500
Date: Tue, 4 Mar 2008 09:16:19 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
cc: Stephen Smalley <sds@tycho.nsa.gov>,
       Casey Schaufler <casey@schaufler-ca.com>, Adrian Bunk <bunk@kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, Eric Paris <eparis@parisplace.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>,
       Anrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v4 -mm] LSM: Add security= boot parameter
In-Reply-To: <20080303212433.GA12998@ubuntu>
Message-ID: <Xine.LNX.4.64.0803040906380.21610@us.intercode.com.au>
References: <20080301211108.GF25835@cs181133002.pp.htv.fi>
 <674864.46980.qm@web36615.mail.mud.yahoo.com> <20080301232708.GA625@ubuntu>
 <20080302074912.GA3215@ubuntu> <20080302105946.GA6406@ubuntu>
 <Xine.LNX.4.64.0803031910170.6729@us.intercode.com.au> <20080303153510.GA6963@ubuntu>
 <1204559642.23738.63.camel@moss-spartans.epoch.ncsc.mil> <20080303212433.GA12998@ubuntu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Ahmed S. Darwish wrote:

>  static inline int verify(struct security_operations *ops)
>  {
>  	/* verify the security_operations structure exists */
> -	if (!ops)
> +	if (!ops || !ops->name)
>  		return -EINVAL;

verify() will now be called after ops->name has been referenced, so these 
checks won't be necessary now.

> +int security_module_enable(struct security_operations *ops)
> +{
> +	if (!ops || !ops->name) {
> +		BUG();
> +		return 0;
> +	}

It's not going to return after BUG(), and actually, you can probably just 
rely on the subsequent oops (i.e. no check needed).

> +
> +	if (!*chosen_lsm && atomic_inc_and_test(&security_ops_enabled))
> +		return 1;
> +
> +	if (!strncmp(ops->name, chosen_lsm, SECURITY_NAME_MAX))
> +		return 1;


I still think you should use a spinlock here to make the semantics 
simpler.  Dispense with the confusingly named security_ops_enabled, and 
fill chosen_lsm in with the first lsm to regsiter if none chosen at boot.


> +               printk(KERN_INFO "SELinux:  Another security module was chosen.\n");
> +               printk(KERN_INFO "SELinux:  Use security=%s to force loading "
> +                      "SELinux on boot.\n", selinux_ops.name);

These messages are not going to scale, e.g. what if there are 20 LSMs 
compiled in, and they all print this on boot? Just print the chosen LSM 
in security_module_enabled().


- James
-- 
James Morris
<jmorris@namei.org>
