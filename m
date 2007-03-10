Return-Path: <linux-kernel-owner+w=401wt.eu-S933537AbXCJITr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537AbXCJITr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 03:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933539AbXCJITr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 03:19:47 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:42548 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933537AbXCJITq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 03:19:46 -0500
Date: Sat, 10 Mar 2007 03:19:44 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: akpm@linux-foundation.org, mbligh@google.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, paulus@samba.org
Subject: Re: [PATCH] Fix atomicity of TIF update in flush_thread() for powerpc
Message-ID: <20070310081944.GA22756@Krystal>
References: <20070309024525.GB9462@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070309024525.GB9462@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 03:19:24 up 35 days, 22:27,  3 users,  load average: 1.28, 1.23, 1.19
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Broken patch. Don't apply. Correct one coming.

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> Fix atomicity of TIF update in flush_thread() for powerpc
> 
> Race :
> 
> parent process executing :
> sys_ptrace()
>  (lock_kernel())
>  (ptrace_get_task_struct(pid))
>  arch_ptrace()
>    ptrace_detach()
>      ptrace_disable(child);
>        clear_singlestep(child);
>          clear_tsk_thread_flag(child, TIF_SINGLESTEP);
>          (which clears the TIF_SINGLESTEP flag atomically from a different
> 	  process)
>  (put_task_struct(child))
>  (unlock_kernel())
> 
> And at the same time, in the child process :
> sys_execve()
>  do_execve()
>    search_binary_handler()
>      load_elf_binary()
>        flush_old_exec()
>          flush_thread()
>            doing a non-atomic thread flag update 
> 
> Applies on 2.6.20.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> --- a/arch/powerpc/kernel/process.c
> +++ b/arch/powerpc/kernel/process.c
> @@ -476,8 +476,13 @@ void flush_thread(void)
>  #ifdef CONFIG_PPC64
>  	struct thread_info *t = current_thread_info();
>  
> -	if (t->flags & _TIF_ABI_PENDING)
> -		t->flags ^= (_TIF_ABI_PENDING | _TIF_32BIT);
> +	if (test_tsk_thread_flag(tsk, TIF_ABI_PENDING)) {
> +		clear_tsk_thread_flag(tsk, TIF_ABI_PENDING);
> +		if (test_tsk_thread_flag(tsk, TIF_32BIT))
> +			clear_tsk_thread_flag(tsk, TIF_32BIT);
> +		else
> +			set_tsk_thread_flag(tsk, TIF_32BIT);
> +	}
>  #endif
>  
>  	discard_lazy_cpu_state();
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
