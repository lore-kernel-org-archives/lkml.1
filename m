Return-Path: <linux-kernel-owner+w=401wt.eu-S1765504AbYEVW6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765504AbYEVW6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756864AbYEVW6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:58:24 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46703 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756781AbYEVW6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:58:23 -0400
Date: Thu, 22 May 2008 14:17:50 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Andrew G. Morgan" <morgan@kernel.org>, Shi Weihua <shiwh@cn.fujitsu.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-security-module@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, jmorris@namei.org,
       ltp-list@lists.sourceforge.net
Subject: Re: [PATCH] fix sys_prctl() returned uninitialized value
Message-ID: <20080522191750.GA14289@us.ibm.com>
References: <4834E639.2010209@cn.fujitsu.com> <20080521203212.ddf05254.akpm@linux-foundation.org> <4834FE1D.10909@kernel.org> <20080521222551.8d8e064a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521222551.8d8e064a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Wed, 21 May 2008 22:01:17 -0700 "Andrew G. Morgan" <morgan@kernel.org> wrote:
> 
> > this is the default expected by the subsequent switch ().
> > 
> > Signed-off-by: Andrew G. Morgan <morgan@kernel.org>
> > ---
> >  kernel/sys.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/sys.c b/kernel/sys.c
> > index 895d2d4..cb25a64 100644
> > --- a/kernel/sys.c
> > +++ b/kernel/sys.c
> > @@ -1657,6 +1657,8 @@ asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
> >  	if (security_task_prctl(option, arg2, arg3, arg4, arg5, &error))
> >  		return error;
> >  
> > +	error = 0;
> > +
> >  	switch (option) {
> >  		case PR_SET_PDEATHSIG:
> >  			if (!valid_signal(arg2)) {
> 
> Looking at it some more there are two cases which don't initialise
> `error': PR_SET_PDEATHSIG and PR_SET_DUMPABLE.  (let's set aside the
> silliness of having sys_prctl() perform set_dumpable()'s argument
> checking for it).

Hmm, I don't know what kernel version I was looking at, or whose glasses
I was wearing at the time.  Clearly these are the two...

> So I would propose this fix, mainly because it removes that nasty
> uninitialized_var().  Please review carefully.
> 
> 
> 
> From: Shi Weihua <shiwh@cn.fujitsu.com> 
> 
> If none of the switch cases match, the PR_SET_PDEATHSIG and
> PR_SET_DUMPABLE cases of the switch statement will never write to local
> variable `error'.
> 
> Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com> 
> Cc: Andrew G. Morgan <morgan@kernel.org>
> Cc: "Serge E. Hallyn" <serue@us.ibm.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/sys.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff -puN kernel/sys.c~sys_prctl-fix-return-of-uninitialized-value kernel/sys.c
> --- a/kernel/sys.c~sys_prctl-fix-return-of-uninitialized-value
> +++ a/kernel/sys.c
> @@ -1652,7 +1652,7 @@ asmlinkage long sys_umask(int mask)
>  asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
>  			  unsigned long arg4, unsigned long arg5)
>  {
> -	long uninitialized_var(error);
> +	long error = 0;
> 
>  	if (security_task_prctl(option, arg2, arg3, arg4, arg5, &error))
>  		return error;
> @@ -1701,9 +1701,7 @@ asmlinkage long sys_prctl(int option, un
>  			error = PR_TIMING_STATISTICAL;
>  			break;
>  		case PR_SET_TIMING:
> -			if (arg2 == PR_TIMING_STATISTICAL)
> -				error = 0;
> -			else
> +			if (arg2 != PR_TIMING_STATISTICAL)
>  				error = -EINVAL;
>  			break;
> 
> _
