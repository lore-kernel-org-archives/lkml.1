Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbYILLwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbYILLwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 07:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbYILLwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 07:52:36 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:33403 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbYILLwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 07:52:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NTPJovv25KiVzR8AGZnqRIhlDfnuoaF39KdJ61CT2fu+h3858IWlKxWk5XWZbppINw
         UtGJ94Po22p+UIC6xVBSQkZYoR63pL+NwTjBdeE7LzdElPDBZ74NkCrtTXW3qMDx1Lyh
         A5sqNTPVj1xlRBLGdeRXzv7ymXXC8BGPgSuts=
Date: Fri, 12 Sep 2008 13:52:26 +0200
From: Adam Tkac <vonsch@gmail.com>
To: Andreas Schwab <schwab@suse.de>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mtk.manpages@gmail.com
Subject: Re: [PATCH 2.6.27-rc5] Allow set RLIMIT_NOFILE to RLIM_INFINITY
Message-ID: <20080912115226.GA4024@evileye.atkac.englab.brq.redhat.com>
References: <20080909071406.GA3814@traged.atkac.englab.brq.redhat.com> <20080910143141.a3bc8258.akpm@linux-foundation.org> <20080911075438.GA2882@traged.atkac.englab.brq.redhat.com> <20080911122219.fd5fdf4c.akpm@linux-foundation.org> <20080912110639.GA2706@traged.atkac.englab.brq.redhat.com> <jesks5wqy9.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <jesks5wqy9.fsf@sykes.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 12, 2008 at 01:20:46PM +0200, Andreas Schwab wrote:
> Adam Tkac <vonsch@gmail.com> writes:
> 
> > diff -puN kernel/sys.c~rlimit-permit-setting-rlimit_nofile-to-rlim_infinity kernel/sys.c
> > --- a/kernel/sys.c~rlimit-permit-setting-rlimit_nofile-to-rlim_infinity
> > +++ a/kernel/sys.c
> > @@ -1532,8 +1532,14 @@ asmlinkage long sys_setrlimit(unsigned i
> >  	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
> >  	    !capable(CAP_SYS_RESOURCE))
> >  		return -EPERM;
> > -	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
> > -		return -EPERM;
> > +	if (resource == RLIMIT_NOFILE) {
> > +		if (new_rlim.rlim_max == RLIM_INFINITY)
> > +			new_rlim.rlim_max = sysctl_nr_open;
> > +		if (new_rlim.rlim_cur == RLIM_INFINITY)
> > +			new_rlim.rlim_cur = sysctl_nr_open;
> > +		if (new_rlim.rlim_max > sysctl_nr_open)
> > +			return -EPERM;
> 
> This makes it possible to set cur > nr_open (when max = INF but nr_open
> < cur < INF).  You need to check that cur <= max after adjustment.
> 
> Andreas.
> 

Right you are. Improved patch is attached, when cur > max && cur !=
INF after adjustment EINVAL is returned. (cur can be also set to max
but it seems like bad solution for me)

-- 
Adam Tkac


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux26-openfiles.patch"

When a process wants to set the limit of open files to RLIM_INFINITY it
gets EPERM even if it has CAP_SYS_RESOURCE capability.

For example, BIND does:

...
#elif defined(NR_OPEN) && defined(__linux__)
        /*
         * Some Linux kernels don't accept RLIM_INFINIT; the maximum
         * possible value is the NR_OPEN defined in linux/fs.h.
         */
        if (resource == isc_resource_openfiles && rlim_value == RLIM_INFINITY) {
                rl.rlim_cur = rl.rlim_max = NR_OPEN;
                unixresult = setrlimit(unixresource, &rl);
                if (unixresult == 0)
                        return (ISC_R_SUCCESS);
        }
#elif ...

If we allow setting RLIMIT_NOFILE to RLIM_INFINITY we increase portability
- you don't have to check if OS is linux and then use different schema for
limits.

The spec says "Specifying RLIM_INFINITY as any resource limit value on a
successful call to setrlimit() shall inhibit enforcement of that resource
limit." and we're presently not doing that.

Signed-off-by: Adam Tkac <vonsch@gmail.com>
--- a/kernel/sys.c.openfiles
+++ a/kernel/sys.c
@@ -1469,14 +1469,22 @@ asmlinkage long sys_setrlimit(unsigned i
 		return -EINVAL;
 	if (copy_from_user(&new_rlim, rlim, sizeof(*rlim)))
 		return -EFAULT;
-	if (new_rlim.rlim_cur > new_rlim.rlim_max)
-		return -EINVAL;
 	old_rlim = current->signal->rlim + resource;
 	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
 	    !capable(CAP_SYS_RESOURCE))
 		return -EPERM;
-	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
-		return -EPERM;
+
+	if (resource == RLIMIT_NOFILE) {
+		if (new_rlim.rlim_max == RLIM_INFINITY)
+			new_rlim.rlim_max = sysctl_nr_open;
+		if (new_rlim.rlim_cur == RLIM_INFINITY)
+			new_rlim.rlim_cur = sysctl_nr_open;
+		if (new_rlim.rlim_max > sysctl_nr_open)
+			return -EPERM;
+	}
+
+	if (new_rlim.rlim_cur > new_rlim.rlim_max)
+		return -EINVAL;
 
 	retval = security_task_setrlimit(resource, &new_rlim);
 	if (retval)

--Nq2Wo0NMKNjxTN9z--
