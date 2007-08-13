Return-Path: <linux-kernel-owner+w=401wt.eu-S1031552AbXHMVEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031552AbXHMVEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 17:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S946849AbXHMVEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 17:04:15 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:31467 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S946459AbXHMVEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 17:04:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=T6Ebgojm/D/UGOsOplfqj9QK5Sk3G82vJuZDovxjfjCzIKrV1USFnTyJMSArZ2HKX8OcmsQ7I0rFfl6e77fD+CliPbSo0y16FsR0Yc9mQRBhqPv7Mx5z0a2psAjg/8bODhdxPUCrxsX3NS4Ljr4uzpgxG1NHMADxSNh/h0CEe94=
Date: Tue, 14 Aug 2007 01:04:02 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Ingo Oeser <ioe-lkml@rameria.de>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH]: proc: export a processes resource limits via proc/<pid>
Message-ID: <20070813210402.GB5870@martell.zuzino.mipt.ru>
References: <20070813140044.GB1960@hmsreliant.think-freely.org> <200708132125.47188.ioe-lkml@rameria.de> <20070813201130.GD1960@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070813201130.GD1960@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 04:11:30PM -0400, Neil Horman wrote:
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -323,6 +324,68 @@ static int proc_oom_score(struct task_struct *task, char *buffer)
>  	return sprintf(buffer, "%lu\n", points);
>  }
>  
> +struct limit_names {
> +	char *name;
> +	char *unit;
> +};
> +
> +static const struct limit_names lnames[RLIM_NLIMITS] = {
> +	[RLIMIT_CPU] = {"Max cpu time", "ms"},
> +	[RLIMIT_FSIZE] = {"Max file size", "bytes"},
> +	[RLIMIT_DATA] = {"Max data size", "bytes"},
> +	[RLIMIT_STACK] = {"Max stack size", "bytes"},
> +	[RLIMIT_CORE] = {"Max core file size", "bytes"},
> +	[RLIMIT_RSS] = {"Max resident set", "bytes"},
> +	[RLIMIT_NPROC] = {"Max processes", "processes"},
> +	[RLIMIT_NOFILE] = {"Max open files", "files"},
> +	[RLIMIT_MEMLOCK] = {"Max locked memory", "bytes"},
> +	[RLIMIT_AS] = {"Max address space", "bytes"},
> +	[RLIMIT_LOCKS] = {"Max file locks", "locks"},
> +	[RLIMIT_SIGPENDING] = {"Max pending signals", "signals"},

this and processes should be left empty methinks, because max signals is
in fact unitless.

> +	[RLIMIT_MSGQUEUE] = {"Max msgqueue size", "bytes"},
> +	[RLIMIT_NICE] = {"Max nice priority", NULL},
> +	[RLIMIT_RTPRIO] = {"Max realtime priority", NULL},
> +};	

aha! trailing whitespace!

> +static int proc_pid_limits(struct task_struct *task, char *buffer)
> +{
> +	unsigned int i;
> +	int count = 0;
> +	char *bufptr = buffer;
> +
> +	struct rlimit rlim[RLIM_NLIMITS];
> +
> +	read_lock(&tasklist_lock);
> +	memcpy(rlim, task->signal->rlim, (sizeof(struct rlimit) * RLIM_NLIMITS));

unneeded (, )

> +	read_unlock(&tasklist_lock);

hmm, fork copies this under task lock of group leader and system calls
in sys.c too. What's up?

I'm sure it will give you nonsensical output because of wrong locks but
I haven't checked.

FWIW, it survived ~1 hour of cat /proc/*/limits, mini fork bombs, LTP,
gdb testsuite and one sooper sikrit proggie. on core2


