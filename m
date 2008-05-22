Return-Path: <linux-kernel-owner+w=401wt.eu-S1765440AbYEVE65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765440AbYEVE65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 00:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbYEVE6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 00:58:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753338AbYEVE6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 00:58:46 -0400
Date: Wed, 21 May 2008 21:57:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Shi Weihua <shiwh@cn.fujitsu.com>, ltp-list@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>, jmorris@namei.org,
       linux-security-module@vger.kernel.org, morgan@kernel.org
Subject: Re: [LTP] [PATCH] fix sys_prctl() returned uninitialized value
Message-Id: <20080521215737.2ac70543.akpm@linux-foundation.org>
In-Reply-To: <4834F7F3.8050800@cn.fujitsu.com>
References: <4834E639.2010209@cn.fujitsu.com>
	<20080521203212.ddf05254.akpm@linux-foundation.org>
	<4834F7F3.8050800@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008 12:34:59 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:

> Andrew Morton wrote:
> > On Thu, 22 May 2008 11:19:21 +0800 Shi Weihua <shiwh@cn.fujitsu.com> wrote:
> > 
> >> When we test kernel by the latest LTP(20080430) on ia64,
> >> the following failure occured:
> >> -------------------------------------
> >> prctl01     1  PASS  :  Test Passed
> >> prctl01     0  WARN  :  prctl() returned 2048 errno = 0 : Success
> >> prctl01     1  PASS  :  Test Passed
> >> prctl01     2  FAIL  :  Test Failed
> >> -------------------------------------
> >>
> >> We found commit 3898b1b4ebff8dcfbcf1807e0661585e06c9a91c
> >> causes this failure by git-bisect.
> >> And, we found 'error' has not been initialized in the function 
> >> sys_prctl()(kernel/sys.c). When the capability module is not taking
> >> responsibility for this call, sys_prctl() may return a wrong value.
> >>
> >> Now, i fixed it.
> >>
> >> Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com> 
> >> ---
> >> diff --git a/kernel/sys.c b/kernel/sys.c
> >> index 895d2d4..26eb0f7 100644
> >> --- a/kernel/sys.c
> >> +++ b/kernel/sys.c
> >> @@ -1652,7 +1652,7 @@ asmlinkage long sys_umask(int mask)
> >>  asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
> >>  			  unsigned long arg4, unsigned long arg5)
> >>  {
> >> -	long uninitialized_var(error);
> >> +	long error = 0;
> >>  
> >>  	if (security_task_prctl(option, arg2, arg3, arg4, arg5, &error))
> >>  		return error;
> > 
> > Oh dear, there are so many things wrong with this...
> > 
> > - if security_task_prctl() is returning "fail" then why on earth
> >   isn't it setting the error code?
> > 
> 
> See comments in security.h:
> 
>  * @task_prctl:
> 	...
>  *      @rc_p contains a pointer to communicate back the forced return code
>  *	Return 0 if permission is granted, and non-zero if the security module
>  *      has taken responsibility (setting *rc_p) for the prctl call.

But that didn't happen!  As you've discovered, security_task_prctl()
returns non-zero but _doesn't_ set *rc_p.

Which, as I said, is inconsistent with cap_task_prctl().  As well as
being downright peculiar.

> But I don't know why can't just set *rc_p to 0 before returning 0 (as Shi's previous
> patch did).

Zeroing it seems wrong.  It should return the _reason_ for the non-zero
return?

> > - cap_task_prctl() _does_ set `error' is if returns non-zero, so it
> >   must be one of the other myriad backend implementations of
> >   security_task_prctl() which is busted.  Which one is it?
> > 
> > - With the above patch applied, sys_prctl() will return zero (ie:
> >   "success") even though it just failed.
> > 
> 
> This won't happen. We initialize error to 0, and it will be set to some error
> value when it should be.

If that were true, we'd never be returning an uninitialised value.

Unless there's some code somewhere which is doing

	if (*rc_p != 0)
		*rc_p = something;

which there might be.  In which case the entire patch makes complete
sense, but a) it needs changelog repair and b) I'd suggest that the
zeroing should be done in security_task_prctl() instead and c) someone
needs to work out what the actual interface is to this thing and document
it properly.

If that interface is deemed to be "randomly returns inexplicable garbage
in `error'" then fine, perhaps sys_prctl() should just return literal zero
in this case and ignore `error'.  Even though returning zero in that case
seems exactly wrong.

> The alternative is to set error to -EFXXX or 0 in every
> switch cases.
> 
> > - Can't we remove the sixth argument to security_task_prctl() and
> >   just return the result code like a sane function would do?  
> > 
> 
> It used to have 5 arguments, but this commit changed it (and caused this ltp failure):
> 	3898b1b4ebff8dcfbcf1807e0661585e06c9a91c
> 	(capabilities: implement per-process securebits)

hm, I suppose there was a reason.


Sorry, but the whole thing looks screwed up to me.
