Return-Path: <linux-kernel-owner+w=401wt.eu-S1759498AbZKKWKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498AbZKKWKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 17:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759461AbZKKWKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 17:10:42 -0500
Received: from mx1.informatik.uni-stuttgart.de ([129.69.211.41]:48686 "EHLO
	mx1.informatik.uni-stuttgart.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759457AbZKKWKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 17:10:41 -0500
From: Alexander Miller <Miller@fmi.uni-stuttgart.de>
Organization: FMI, =?iso-8859-1?q?Universit=E4t?= Stuttgart
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] cpufreq: fix conservative/ondemand behaviour with ignore_nice_load
Date: Wed, 11 Nov 2009 23:10:45 +0100
User-Agent: KMail/1.9.10
References: <200911061727.17541.Miller@fmi.uni-stuttgart.de> <B5B0CFF685D7DF46A05CF1678CFB42ED20E0C63D@orsmsx505.amr.corp.intel.com> <20091110222038.GA32028@linux-os.sc.intel.com>
In-Reply-To: <20091110222038.GA32028@linux-os.sc.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911112310.45175.Miller@fmi.uni-stuttgart.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009, Pallipadi, Venkatesh wrote:
> > Can you describe the "unresonable behavior" you are seeing. Is it
> > with NO_HZ enabled or disabled?
$ zgrep NO_HZ /proc/config.gz
# CONFIG_NO_HZ is not set

When there are two cpu-intense processes, one with nice 19 and the other
with nice 0, then the latter will use almost 100% cpu time, of course.
But the cpu has been stuck at the lowest frequency without the patch.
To be exact, it would change the freq sometimes, but return to the
lowest freq within a fraction of a second.
I would expect it to select a freq such that the non-nice processes
take <80% or the highest freq (which it does with the patch).

> > I see there can be a problem with this code when NO_HZ is disabled.
> > But, the patch below is not the right solution as it will result in
> > Adding times in different units with NO_HZ enabled.

Yes, you are right. Looks like I've patched the wrong half of the
inconsistency :-(
I think it's a bit irritating you are using cputime64_t to store
microseconds. At least it fooled me (I'm no kernel guy though) into
thinking that get_cpu_idle_time_jiffy() returning jiffies was the
intended behaviour.

> Does the below test patch (only compile tested) resolve the problem you
> are seeing?

I've just rebooted the machine with the new patched kernel, and
it looks good.

Thank you,
Alex

> ---
>  drivers/cpufreq/cpufreq_conservative.c |    4 ++--
>  drivers/cpufreq/cpufreq_ondemand.c     |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
> index bc33ddc..c7b081b 100644
> --- a/drivers/cpufreq/cpufreq_conservative.c
> +++ b/drivers/cpufreq/cpufreq_conservative.c
> @@ -116,9 +116,9 @@ static inline cputime64_t get_cpu_idle_time_jiffy(unsigned int cpu,
>  
>  	idle_time = cputime64_sub(cur_wall_time, busy_time);
>  	if (wall)
> -		*wall = cur_wall_time;
> +		*wall = (cputime64_t)jiffies_to_usecs(cur_wall_time);
>  
> -	return idle_time;
> +	return (cputime64_t)jiffies_to_usecs(idle_time);;
>  }
>  
>  static inline cputime64_t get_cpu_idle_time(unsigned int cpu, cputime64_t *wall)
> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> index 071699d..4b34ade 100644
> --- a/drivers/cpufreq/cpufreq_ondemand.c
> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -133,9 +133,9 @@ static inline cputime64_t get_cpu_idle_time_jiffy(unsigned int cpu,
>  
>  	idle_time = cputime64_sub(cur_wall_time, busy_time);
>  	if (wall)
> -		*wall = cur_wall_time;
> +		*wall = (cputime64_t)jiffies_to_usecs(cur_wall_time);
>  
> -	return idle_time;
> +	return (cputime64_t)jiffies_to_usecs(idle_time);
>  }
>  
>  static inline cputime64_t get_cpu_idle_time(unsigned int cpu, cputime64_t *wall)
> -- 
> 1.6.0.6
