Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab0CCXqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 18:46:23 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38206 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab0CCXqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 18:46:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=KQvBWfXZ5cTM08O9vyiNrwx0Ee2zI4ddSjdBkcSMQag34HL2QZIcAvMYpTLOHu0AGs
         W9SV/sF9xjBwTMbf81zcFaAHiPjmcwjKONp+S3Hk9K9MNWCu1QWqaQPNQB0wO3pQSphG
         GSqYYPbldNEeRrwk8nWIMOwubM2SXGFpJJfpY=
Date: Wed, 3 Mar 2010 20:46:10 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Eric B Munson <ebmunson@us.ibm.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] Enable the enable_on_exec flag if record forks the
	target
Message-ID: <20100303234610.GA17271@ghostprotocols.net>
References: <1267653987-11022-1-git-send-email-ebmunson@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267653987-11022-1-git-send-email-ebmunson@us.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Mar 03, 2010 at 10:06:27PM +0000, Eric B Munson escreveu:
> When forking its target, perf record can capture data from before the target
> application is started.  Perf stat uses the enable_on_exec flag in the event
> attributes to keep from displaying events from before the target program
> starts, this patch adds the same functionality to perf record when it is will
> fork the target process.

Good catch, Dave, this will help that case too, or at least avoid
exercising that bug you fixed by flushing maps when a comm is received
:-)

Eric, I'll test your patches for handling multiple counters in 'perf
report'and integrate then, most likely tomorrow, thanks!

- Arnaldo

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
 
> Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
> ---
>  tools/perf/builtin-record.c |   13 ++++++++-----
>  1 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 771533c..625076e 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -224,7 +224,7 @@ static struct perf_header_attr *get_header_attr(struct perf_event_attr *a, int n
>  	return h_attr;
>  }
>  
> -static void create_counter(int counter, int cpu, pid_t pid)
> +static void create_counter(int counter, int cpu, pid_t pid, bool forks)
>  {
>  	char *filter = filters[counter];
>  	struct perf_event_attr *attr = attrs + counter;
> @@ -273,6 +273,9 @@ static void create_counter(int counter, int cpu, pid_t pid)
>  	attr->inherit		= inherit;
>  	attr->disabled		= 1;
>  
> +	if (forks)
> +		attr->enable_on_exec = 1;
> +
>  try_again:
>  	fd[nr_cpu][counter] = sys_perf_event_open(attr, pid, cpu, group_fd, 0);
>  
> @@ -376,13 +379,13 @@ try_again:
>  	ioctl(fd[nr_cpu][counter], PERF_EVENT_IOC_ENABLE);
>  }
>  
> -static void open_counters(int cpu, pid_t pid)
> +static void open_counters(int cpu, pid_t pid, bool forks)
>  {
>  	int counter;
>  
>  	group_fd = -1;
>  	for (counter = 0; counter < nr_counters; counter++)
> -		create_counter(counter, cpu, pid);
> +		create_counter(counter, cpu, pid, forks);
>  
>  	nr_cpu++;
>  }
> @@ -542,10 +545,10 @@ static int __cmd_record(int argc, const char **argv)
>  
>  
>  	if ((!system_wide && !inherit) || profile_cpu != -1) {
> -		open_counters(profile_cpu, target_pid);
> +		open_counters(profile_cpu, target_pid, forks);
>  	} else {
>  		for (i = 0; i < nr_cpus; i++)
> -			open_counters(i, target_pid);
> +			open_counters(i, target_pid, forks);
>  	}
>  
>  	if (file_new) {
> -- 
> 1.6.3.3
