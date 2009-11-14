Return-Path: <linux-kernel-owner+w=401wt.eu-S932549AbZKNAAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549AbZKNAAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 19:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932504AbZKNAAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 19:00:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932488AbZKNAAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 19:00:45 -0500
Message-ID: <4AFDF305.20903@redhat.com>
Date: Fri, 13 Nov 2009 19:00:05 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 2/3] Add coredump tracepoint
References: <20091113225226.15079.90813.stgit@harusame>	<20091113225233.15079.41600.stgit@harusame> <20091113233912.192A3100E@magilla.sf.frob.com>
In-Reply-To: <20091113233912.192A3100E@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> I can't really see what this has to do with "sched" to warrant that name.
> But, whatever.
>
> Note that you put the tracepoint where it won't get called in the various
> cases where no dump is really being made because of RLIMIT_CORE or file
> failures.  I suspect you would like to get those reported.  (Perhaps
> especially so, since there won't be any file around to notice later.)

Exactly, yes.

> Also, it seems nice to give the tracepoint the chance to look at the actual
> open file in case a fancy one wants to do that.

Ah, that's very nice to me! thanks!

>
> e.g.
>
> diff --git a/fs/exec.c b/fs/exec.c
> index ba112bd..0000000 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1822,9 +1822,7 @@ void do_coredump(long signr, int exit_co
>   	ispipe = format_corename(corename, signr);
>   	unlock_kernel();
>
> -	if ((!ispipe)&&  (core_limit<  binfmt->min_coredump))
> -		goto fail_unlock;
> -
> +	file = NULL;
>    	if (ispipe) {
>   		if (core_limit == 0) {
>   			/*
> @@ -1845,7 +1843,7 @@ void do_coredump(long signr, int exit_co
>   				"Process %d(%s) has RLIMIT_CORE set to 0\n",
>   				task_tgid_vnr(current), current->comm);
>   			printk(KERN_WARNING "Aborting core\n");
> -			goto fail_unlock;
> +			goto nopipe;
>   		}
>
>   		dump_count = atomic_inc_return(&core_dump_count);
> @@ -1853,14 +1851,14 @@ void do_coredump(long signr, int exit_co
>   			printk(KERN_WARNING "Pid %d(%s) over core_pipe_limit\n",
>   			       task_tgid_vnr(current), current->comm);
>   			printk(KERN_WARNING "Skipping core dump\n");
> -			goto fail_dropcount;
> +			goto nopipe;
>   		}
>
>   		helper_argv = argv_split(GFP_KERNEL, corename+1,&helper_argc);
>   		if (!helper_argv) {
>   			printk(KERN_WARNING "%s failed to allocate memory\n",
>   			       __func__);
> -			goto fail_dropcount;
> +			goto nopipe;
>   		}
>
>   		core_limit = RLIM_INFINITY;
> @@ -1870,13 +1868,19 @@ void do_coredump(long signr, int exit_co
>   				&file)) {
>    			printk(KERN_INFO "Core dump to %s pipe failed\n",
>   			       corename);
> -			goto fail_dropcount;
> +			goto nopipe;
>    		}
> - 	} else
> + 	} else if (core_limit>= binfmt->min_coredump) {
>    		file = filp_open(corename,
>   				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
>   				 0600);
> -	if (IS_ERR(file))
> +	}
> +
> +nopipe:
> +	trace_process_coredump((int) signr, core_limit, mm_flags,
> +			       corename, file);
> +
> +	if (!file || IS_ERR(file))
>   		goto fail_dropcount;
>   	inode = file->f_path.dentry->d_inode;
>   	if (inode->i_nlink>  1)

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

