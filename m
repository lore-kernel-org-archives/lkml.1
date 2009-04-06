Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124AbZDFDao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbZDFDao (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 23:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbZDFDae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 23:30:34 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51039 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbZDFDad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 23:30:33 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Subject: Re: + mm-align-vmstat_works-timer.patch added to -mm tree
Cc: kosaki.motohiro@jp.fujitsu.com, anton@samba.org,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200904011945.n31JjWqG028114@imap1.linux-foundation.org>
References: <200904011945.n31JjWqG028114@imap1.linux-foundation.org>
Message-Id: <20090406120533.450B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Mon,  6 Apr 2009 12:30:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(swich to lkml and linux-mm)

Hi Anton,

Do you have any mesurement data?

Honestly, I made the same patch few week ago.
but I found two problems.

1)
work queue tracer (in -tip) reported it isn't proper rounded.

The fact is, schedule_delayed_work(work, round_jiffies_relative()) is
a bit ill.

it mean
  - round_jiffies_relative() calculate rounded-time - jiffies
  - schedule_delayed_work() calculate argument + jiffies

it assume no jiffies change at above two place. IOW it assume
non preempt kernel.


2)
> -	schedule_delayed_work_on(cpu, vmstat_work, HZ + cpu);
> +	schedule_delayed_work_on(cpu, vmstat_work,
> +				 __round_jiffies_relative(HZ, cpu));

isn't same meaning.

vmstat_work mean to move per-cpu stastics to global stastics.
Then, (HZ + cpu) mean to avoid to touch the same global variable at the same time.

Oh well, this patch have performance regression risk on _very_ big server.
(perhaps, only sgi?)

but I agree vmstat_work is one of most work queue heavy user.
For power consumption view, it isn't proper behavior.

I still think improving another way.

> 
> The patch titled
>      mm: align vmstat_work's timer
> has been added to the -mm tree.  Its filename is
>      mm-align-vmstat_works-timer.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: mm: align vmstat_work's timer
> From: Anton Blanchard <anton@samba.org>
> 
> Even though vmstat_work is marked deferrable, there are still benefits to
> aligning it.  For certain applications we want to keep OS jitter as low as
> possible and aligning timers and work so they occur together can reduce
> their overall impact.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/vmstat.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff -puN mm/vmstat.c~mm-align-vmstat_works-timer mm/vmstat.c
> --- a/mm/vmstat.c~mm-align-vmstat_works-timer
> +++ a/mm/vmstat.c
> @@ -984,7 +984,7 @@ static void vmstat_update(struct work_st
>  {
>  	refresh_cpu_vm_stats(smp_processor_id());
>  	schedule_delayed_work(&__get_cpu_var(vmstat_work),
> -		sysctl_stat_interval);
> +		round_jiffies_relative(sysctl_stat_interval));
>  }
>  
>  static void __cpuinit start_cpu_timer(int cpu)
> @@ -992,7 +992,8 @@ static void __cpuinit start_cpu_timer(in
>  	struct delayed_work *vmstat_work = &per_cpu(vmstat_work, cpu);
>  
>  	INIT_DELAYED_WORK_DEFERRABLE(vmstat_work, vmstat_update);
> -	schedule_delayed_work_on(cpu, vmstat_work, HZ + cpu);
> +	schedule_delayed_work_on(cpu, vmstat_work,
> +				 __round_jiffies_relative(HZ, cpu));
>  }
>  
>  /*
> _
> 
> Patches currently in -mm which might be from anton@samba.org are
> 
> origin.patch
> mm-align-vmstat_works-timer.patch
> random-align-rekey_works-timer.patch
> sunrpc-align-cache_clean-works-timer.patch
> 
> --
> To unsubscribe from this list: send the line "unsubscribe mm-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



