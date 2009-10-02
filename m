Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbZJBXjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbZJBXjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 19:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbZJBXjC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 19:39:02 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:60448 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbZJBXjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 19:39:01 -0400
Message-ID: <4AC68F13.8050601@us.ibm.com>
Date: Fri, 02 Oct 2009 16:38:59 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Anirban Sinha <ASinha@zeugmasystems.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: futex question
References: <DDFD17CC94A9BD49A82147DDF7D545C501FD7F97@exchange.ZeugmaSystems.local> <20091001092218.GH15345@elte.hu> <DDFD17CC94A9BD49A82147DDF7D545C501FD8409@exchange.ZeugmaSystems.local>
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C501FD8409@exchange.ZeugmaSystems.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anirban Sinha wrote:
>> Should we not just clear the pointer (and
>>> it's compat version) within do_execve()?
> 
> 
> In our private repository, applying the following patch resolved the
> issues I mentioned. I no longer see messages like this:
> 
>  [futex] ("ifconfig")(pid=2509) exit_robust_list:unable to fetch robust
> entry. uaddr=0x000000002abbc4f0
> 
> from my instrumented kernel within exit_robust_list(). My
> instrumentation looked something like this:

> 
> if (fetch_robust_entry(...)) {
> printk(...);
> return;
> }
> 
> Just tossing the patch in the community in case someone is interested


Thanks for sending the patch.  I'm looking into it now.  Couple questions:

1) What caused you to instrument this path in the first place?  Were you 
seeing some unexpected behavior?

2) I wonder why we would need to clear the robust list, but I don't see 
other things like pi_blocked_on, etc. in execve being cleared.  I'm 
looking into this now (perhaps we don't do the same cleanup, need to 
check).... have to get on the plane...

--
Darren Hart

> ...
> 
> 
> 
> Signed-off-by: Anirban Sinha <asinha@zeugmasystems.com>
> ---
>  fs/compat.c |    3 +++
>  fs/exec.c   |    3 +++
>  2 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/compat.c b/fs/compat.c
> index 6d6f98f..c3d117c 100644
> --- a/fs/compat.c
> +++ b/fs/compat.c
> @@ -1510,6 +1510,9 @@ int compat_do_execve(char * filename,
>         if (retval)
>                 goto out_file;
> 
> +#ifdef CONFIG_FUTEX
> +       current->compat_robust_list = NULL;
> +#endif
>         bprm->argc = compat_count(argv, MAX_ARG_STRINGS);
>         if ((retval = bprm->argc) < 0)
>                 goto out;
> diff --git a/fs/exec.c b/fs/exec.c
> index 172ceb6..e9334b8 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1323,6 +1323,9 @@ int do_execve(char * filename,
>         retval = bprm_mm_init(bprm);
>         if (retval)
>                 goto out_file;
> +#ifdef CONFIG_FUTEX
> +       current->robust_list = NULL;
> +#endif
> 
>         bprm->argc = count(argv, MAX_ARG_STRINGS);
>         if ((retval = bprm->argc) < 0)
> 
> 


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
