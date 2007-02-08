Return-Path: <linux-kernel-owner+w=401wt.eu-S1422873AbXBHPM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422873AbXBHPM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 10:12:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423044AbXBHPM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 10:12:59 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:55517 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422873AbXBHPM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 10:12:58 -0500
Subject: Re: [PATCH 2/2] sysctl: Restore the selinux path based label
	lookup for sysctls.
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       jmorris@namei.org
In-Reply-To: <m17iutobht.fsf@ebiederm.dsl.xmission.com>
References: <200701280106.l0S16CG3019873@shell0.pdx.osdl.net>
	 <20070127172410.2b041952.akpm@osdl.org>
	 <1169972718.17469.164.camel@localhost.localdomain>
	 <20070128003549.2ca38dc8.akpm@osdl.org> <20070128093358.GA2071@elte.hu>
	 <20070128095712.GA6485@elte.hu> <20070128100627.GA8416@elte.hu>
	 <20070128104548.a835d859.akpm@osdl.org>
	 <m1r6tfq7nv.fsf_-_@ebiederm.dsl.xmission.com>
	 <1170075866.8720.15.camel@moss-spartans.epoch.ncsc.mil>
	 <m17iuvrnpk.fsf_-_@ebiederm.dsl.xmission.com>
	 <m13b5jrngt.fsf_-_@ebiederm.dsl.xmission.com>
	 <1170872654.11912.87.camel@moss-spartans.epoch.ncsc.mil>
	 <1170882738.11912.144.camel@moss-spartans.epoch.ncsc.mil>
	 <1170885244.11912.168.camel@moss-spartans.epoch.ncsc.mil>
	 <m17iutobht.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 08 Feb 2007 10:07:50 -0500
Message-Id: <1170947270.11912.254.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-07 at 15:21 -0700, Eric W. Biederman wrote:
> Stephen Smalley <sds@tycho.nsa.gov> writes:
> 
> > Actually, on further inspection, it looks like the real issue is the
> > "path" name generation; "cat /proc/sys/kernel/modprobe" yields a call to
> > security_genfs_sid() with just "/modprobe" rather than the expected
> > "/sys/kernel/modprobe".  Which likewise leaves us with the generic proc
> > label, just as with the inode permission check, so I end up seeing
> > checks against it only.
> 
> Ok.  It looks like two silly thing are going on here.
> I failed to register the root sysctl table, so none of the parent
> pointers got set.
> 
> I didn't prepend /sys in the compatibility code, so for something with
> the parent pointers set you would have gotten "/kernel/modprobe" instead
> of /sys/kernel/modprobe"
> 
> Sorry about that.
> 
> I think the patch below will fix it.

Yes, thanks - this appears to correct the name generation and thus the
resulting SID computation for the selinux sysctl checks.  

> Eric
> 
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index 24f36f1..f316854 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -929,8 +929,6 @@ extern struct ctl_table_header *sysctl_head_next(struct ctl_table_header *prev);
>  extern void sysctl_head_finish(struct ctl_table_header *prev);
>  extern int sysctl_perm(struct ctl_table *table, int op);
>  
> -extern void sysctl_init(void);
> -
>  typedef struct ctl_table ctl_table;
>  
>  typedef int ctl_handler (ctl_table *table, int __user *name, int nlen,
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 0a5499f..0bb2c5f 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1241,6 +1241,14 @@ static void sysctl_set_parent(struct ctl_table *parent, struct ctl_table *table)
>  	}
>  }
>  
> +static __init int sysctl_init(void)
> +{
> +	sysctl_set_parent(NULL, root_table);
> +	return 0;
> +}
> +
> +core_initcall(sysctl_init);
> +
>  /**
>   * register_sysctl_table - register a sysctl hierarchy
>   * @table: the top-level table structure
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index c17a8dd..aad2697 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -1452,6 +1452,12 @@ static int selinux_sysctl_get_sid(ctl_table *table, u16 tclass, u32 *sid)
>  		path = end;
>  		table = table->parent;
>  	}
> +	buflen -= 4;
> +	if (buflen < 0)
> +		goto out_free;
> +	end -= 4;
> +	memcpy(end, "/sys", 4);
> +	path = end;
>  	rc = security_genfs_sid("proc", path, tclass, sid);
>  out_free:
>  	free_page((unsigned long)buffer);
> 


-- 
Stephen Smalley
National Security Agency

