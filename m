Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbYIKTWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbYIKTWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 15:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYIKTWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 15:22:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751676AbYIKTWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 15:22:21 -0400
Date: Thu, 11 Sep 2008 12:22:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adam Tkac <vonsch@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27-rc5] Allow set RLIMIT_NOFILE to RLIM_INFINITY
Message-Id: <20080911122219.fd5fdf4c.akpm@linux-foundation.org>
In-Reply-To: <20080911075438.GA2882@traged.atkac.englab.brq.redhat.com>
References: <20080909071406.GA3814@traged.atkac.englab.brq.redhat.com>
	<20080910143141.a3bc8258.akpm@linux-foundation.org>
	<20080911075438.GA2882@traged.atkac.englab.brq.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2008 09:54:38 +0200
Adam Tkac <vonsch@gmail.com> wrote:

> On Wed, Sep 10, 2008 at 02:31:41PM -0700, Andrew Morton wrote:
> > On Tue, 9 Sep 2008 09:14:07 +0200
> > Adam Tkac <vonsch@gmail.com> wrote:
> > 
> > > when process wants set limit of open files to RLIM_INFINITY it gets
> > > EPERM even if it has CAP_SYS_RESOURCE capability. Attached patch
> > > should fix the problem. Please add me to CC of your responses because
> > > I'm not member of list.
> > > 
> > > Regards, Adam
> > > 
> > > -- 
> > > Adam Tkac
> > > 
> > > 
> > > [linux26-openfiles.patch  text/plain (634B)]
> > > --- a/kernel/sys.c
> > > +++ b/kernel/sys.c
> > > @@ -1458,8 +1458,14 @@ asmlinkage long sys_setrlimit(unsigned i
> > >  	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
> > >  	    !capable(CAP_SYS_RESOURCE))
> > >  		return -EPERM;
> > > -	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
> > > -		return -EPERM;
> > > +	if (resource == RLIMIT_NOFILE) {
> > > +		if (new_rlim.rlim_max == RLIM_INFINITY)
> > > +			new_rlim.rlim_max = sysctl_nr_open;
> > > +		if (new_rlim.rlim_cur == RLIM_INFINITY)
> > > +			new_rlim.rlim_cur = sysctl_nr_open;
> > > +		if (new_rlim.rlim_max > sysctl_nr_open)
> > > +			return -EPERM;
> > > +	}
> > 
> > The kernel has had this behaviour for a long time.  2.6.13 had:
> > 
> > 	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
> > 	    !capable(CAP_SYS_RESOURCE))
> > 		return -EPERM;
> > 	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > NR_OPEN)
> > 			return -EPERM;
> > 
> > I don't immediately see a problem with your change, but what makes you
> > believe that it is needed?  Is there some standard which we're
> > violating?  Is there some operational situation in which the current
> > behaviour is causing a problem?
> > 
> > Thanks.
> 
> Well, this change is not _absolutely_ needed because everyone who wants
> unlimited file descriptors he could set it to NR_OPEN. Look on
> example (from BIND):
> 
> ...
> #elif defined(NR_OPEN) && defined(__linux__)
>         /*
>          * Some Linux kernels don't accept RLIM_INFINIT; the maximum
>          * possible value is the NR_OPEN defined in linux/fs.h.
>          */
>         if (resource == isc_resource_openfiles && rlim_value == RLIM_INFINITY) {
>                 rl.rlim_cur = rl.rlim_max = NR_OPEN;
>                 unixresult = setrlimit(unixresource, &rl);
>                 if (unixresult == 0)
>                         return (ISC_R_SUCCESS);
>         }
> #elif ...
> 
> I think that when you allow set RLIMIT_NOFILE to RLIM_INFINITY you
> increase portability - you don't have to check if OS is linux and then
> use different schema for limits.
> 

OK.

I updated the changelog as below.

Please send a Signed-off-by: for thsi change, as per section 12 of
Documentation/SubmittingPatches.

Thanks.

From: Adam Tkac <vonsch@gmail.com>

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

Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN kernel/sys.c~rlimit-permit-setting-rlimit_nofile-to-rlim_infinity kernel/sys.c
--- a/kernel/sys.c~rlimit-permit-setting-rlimit_nofile-to-rlim_infinity
+++ a/kernel/sys.c
@@ -1532,8 +1532,14 @@ asmlinkage long sys_setrlimit(unsigned i
 	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
 	    !capable(CAP_SYS_RESOURCE))
 		return -EPERM;
-	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
-		return -EPERM;
+	if (resource == RLIMIT_NOFILE) {
+		if (new_rlim.rlim_max == RLIM_INFINITY)
+			new_rlim.rlim_max = sysctl_nr_open;
+		if (new_rlim.rlim_cur == RLIM_INFINITY)
+			new_rlim.rlim_cur = sysctl_nr_open;
+		if (new_rlim.rlim_max > sysctl_nr_open)
+			return -EPERM;
+	}
 
 	retval = security_task_setrlimit(resource, &new_rlim);
 	if (retval)
_

