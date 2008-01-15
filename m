Return-Path: <linux-kernel-owner+w=401wt.eu-S1757012AbYAOUi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbYAOUi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbYAOUiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:38:51 -0500
Received: from smtp114.sbc.mail.re2.yahoo.com ([68.142.229.91]:29675 "HELO
	smtp114.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752416AbYAOUiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:38:50 -0500
X-YMail-OSG: mLMgxtYVM1nND1kuy5rFz1cdRNi6xyGUPUDGVvxbpy01F3XKV79aQ2UrbjvtVs6Go0QN8PFT6zpTkbsIQVode0Y8O8S07mIN0EdOJeNplmf0f3cXGBI3KrwOswzxpltu6jGSOq0-
Date: Tue, 15 Jan 2008 14:36:59 -0600
From: serge@hallyn.com
To: Clifford Wolf <clifford@clifford.at>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rlim in proc/<pid>/status
Message-ID: <20080115203659.GA5404@vino.hallyn.com>
References: <20080115100631.GA13394@clifford.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115100631.GA13394@clifford.at>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Clifford Wolf (clifford@clifford.at):
> Hi,
> 
> because I needed it already twice in two different projects this week: the
> following patch adds rlim (ulimits) output to /proc/<pid>/status.
> 
> Please let me know if there is another (already existing) way of accessing
> this information easy (i.e. connecting with gdb to the process in question
> and 'injecting' a getrlimit() call does not count.. ;-).
> 
> yours,
>  - clifford
> 
> Signed-off-by: Clifford Wolf <clifford@clifford.at>
> 
> --- linux/fs/proc/array.c	(revision 757)
> +++ linux/fs/proc/array.c	(working copy)
> @@ -239,6 +239,55 @@
>  	}
>  }
>  
> +static char *rlim_names[RLIM_NLIMITS] = {
> +	[RLIMIT_CPU]        = "CPU",
> +	[RLIMIT_FSIZE]      = "FSize",
> +	[RLIMIT_DATA]       = "Data",
> +	[RLIMIT_STACK]      = "Stack",
> +	[RLIMIT_CORE]       = "Core",
> +	[RLIMIT_RSS]        = "RSS",
> +	[RLIMIT_NPROC]      = "NProc",
> +	[RLIMIT_NOFILE]     = "NoFile",
> +	[RLIMIT_MEMLOCK]    = "MemLock",
> +	[RLIMIT_AS]         = "AddrSpace",
> +	[RLIMIT_LOCKS]      = "Locks",
> +	[RLIMIT_SIGPENDING] = "SigPending",
> +	[RLIMIT_MSGQUEUE]   = "MsgQueue",
> +	[RLIMIT_NICE]       = "Nice",
> +	[RLIMIT_RTPRIO]     = "RTPrio"
> +};
> +
> +static inline char *task_rlim(struct task_struct *p, char *buffer)
> +{
> +	unsigned long flags;
> +	struct rlimit rlim[RLIM_NLIMITS];
> +	int i;
> +	
> +	rcu_read_lock();
> +	if (lock_task_sighand(p, &flags)) {
> +		for (i=0; i<RLIM_NLIMITS; i++)
> +			rlim[i] = p->signal->rlim[i];

I'm confused - where do you unlock_task_sighand()?

> +	}
> +	rcu_read_unlock();
> +
> +	for (i=0; i<RLIM_NLIMITS; i++) {
> +		if (rlim_names[i])
> +			buffer += sprintf(buffer, "Rlim%s:\t", rlim_names[i]);
> +		else
> +			buffer += sprintf(buffer, "Rlim%d:\t", i);
> +		if (rlim[i].rlim_cur != ~0)
> +			buffer += sprintf(buffer, "%lu\t", rlim[i].rlim_cur);
> +		else
> +			buffer += sprintf(buffer, "-\t");
> +		if (rlim[i].rlim_max != ~0)
> +			buffer += sprintf(buffer, "%lu\n", rlim[i].rlim_max);
> +		else
> +			buffer += sprintf(buffer, "-\n");
> +	}
> +
> +	return buffer;
> +}
> +
>  static inline char *task_sig(struct task_struct *p, char *buffer)
>  {
>  	unsigned long flags;
> @@ -310,6 +359,7 @@
>  		buffer = task_mem(mm, buffer);
>  		mmput(mm);
>  	}
> +	buffer = task_rlim(task, buffer);
>  	buffer = task_sig(task, buffer);
>  	buffer = task_cap(task, buffer);
>  	buffer = cpuset_task_status_allowed(task, buffer);
> 
> -- 
> [..] If it still doesn't work, re-write it in assembler. This won't fix the
> bug, but it will make sure no one else finds it and makes you look bad.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
