Return-Path: <linux-kernel-owner+w=401wt.eu-S932555AbZJ1DTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555AbZJ1DTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932519AbZJ1DTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:19:52 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51470 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509AbZJ1DTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:19:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Oct 2009 12:17:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, vedran.furac@gmail.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, minchan.kim@gmail.com,
       akpm@linux-foundation.org, rientjes@google.com, aarcange@redhat.com
Subject: Re: Memory overcommit
Message-Id: <20091028121722.6e93f3eb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091028113713.FD85.A69D9226@jp.fujitsu.com>
References: <20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0910271843510.11372@sister.anvils>
	<20091028113713.FD85.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Oct 2009 11:47:55 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > 2.  I started out running my mlock test program as root (later
> > switched to use "ulimit -l unlimited" first).  But badness() reckons
> > CAP_SYS_ADMIN or CAP_SYS_RESOURCE is a reason to quarter your points;
> > and CAP_SYS_RAWIO another reason to quarter your points: so running
> > as root makes you sixteen times less likely to be killed.  Quartering
> > is anyway debatable, but sixteenthing seems utterly excessive to me.
> > 
> > I moved the CAP_SYS_RAWIO test in with the others, so it does no
> > more than quartering; but is quartering appropriate anyway?  I did
> > wonder if I was right to be "subverting" the fine-grained CAPs in
> > this way, but have since seen unrelated mail from one who knows
> > better, implying they're something of a fantasy, that su and sudo
> > are indeed what's used in the real world.  Maybe this patch was okay.
> 
> I agree quartering is debatable.
> At least, killing quartering is worth for any user, and it can be push into -stable.
> 
> 
> 
> 
> From 27331555366c908a93c2cdd780b77e421869c5af Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Wed, 28 Oct 2009 11:28:39 +0900
> Subject: [PATCH] oom: Mitigate suer-user's bonus of oom-score
> 
> Currently, badness calculation code of oom contemplate following bonus.
>  - Super-user have quartering oom-score
>  - CAP_SYS_RAWIO process (e.g. database) also have quartering oom-score
> 
> The problem is, Super-users have CAP_SYS_RAWIO too. Then, they have
> sixteenthing bonus. it's obviously too excessive and meaningless.
> 
> This patch fixes it.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

I'll pick this up to my series.

Thanks,
-Kame

> ---
>  mm/oom_kill.c |   13 +++++--------
>  1 files changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index ea2147d..40d323d 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -152,18 +152,15 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
>  	/*
>  	 * Superuser processes are usually more important, so we make it
>  	 * less likely that we kill those.
> -	 */
> -	if (has_capability_noaudit(p, CAP_SYS_ADMIN) ||
> -	    has_capability_noaudit(p, CAP_SYS_RESOURCE))
> -		points /= 4;
> -
> -	/*
> -	 * We don't want to kill a process with direct hardware access.
> +	 *
> +	 * Plus, We don't want to kill a process with direct hardware access.
>  	 * Not only could that mess up the hardware, but usually users
>  	 * tend to only have this flag set on applications they think
>  	 * of as important.
>  	 */
> -	if (has_capability_noaudit(p, CAP_SYS_RAWIO))
> +	if (has_capability_noaudit(p, CAP_SYS_ADMIN) ||
> +	    has_capability_noaudit(p, CAP_SYS_RESOURCE) ||
> +	    has_capability_noaudit(p, CAP_SYS_RAWIO))
>  		points /= 4;
>  
>  	/*
> -- 
> 1.6.2.5
> 
> 
> 
> 
> 

