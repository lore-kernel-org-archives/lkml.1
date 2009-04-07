Return-Path: <linux-kernel-owner+w=401wt.eu-S1760857AbZDGSa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760857AbZDGSa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 14:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757819AbZDGSaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 14:30:20 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:50885 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066AbZDGSaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 14:30:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e/3CL9abQAkel20yloZTA4qpIwxN8h7o4239U6EoyKmNvJWS74Py5yEyl6DSNFA/rU
         DCqCnsd7hm5KZOOkGg8cUHNJftflThlNezosTsC8OHFiN7EtjOtn3XXayvPn/Q1GTTKq
         9dgySfA8miqIt4Eqb+PCwry1WfWpyaUm3HSIk=
Date: Tue, 7 Apr 2009 20:30:15 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, srostedt@redhat.com,
       mingo@elte.hu
Subject: Re: [bug] lockdep warning: module_mutex vs. ftrace_lock
Message-ID: <20090407183014.GA7531@nowhere>
References: <E1LrEGG-0000ag-Js@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LrEGG-0000ag-Js@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 06:34:56PM +0200, Miklos Szeredi wrote:
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.29-09854-gd508afb-dirty #6
> -------------------------------------------------------
> modprobe/3184 is trying to acquire lock:
>  (ftrace_lock){+.+.+.}, at: [<ffffffff80277e71>] ftrace_convert_nops+0x32/0x267
> 
> but task is already holding lock:
>  (module_mutex){+.+.+.}, at: [<ffffffff8026a539>] sys_init_module+0x3f/0x1d3
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (module_mutex){+.+.+.}:
>        [<ffffffff8026134a>] __lock_acquire+0x12fe/0x1668
>        [<ffffffff802617a2>] lock_acquire+0xee/0x112
>        [<ffffffff804fe0a6>] mutex_lock_nested+0x4f/0x305
>        [<ffffffff8026709e>] module_update_tracepoints+0x1c/0x73
>        [<ffffffff80274f74>] tracepoint_update_probes+0x21/0x23
>        [<ffffffff8027510a>] tracepoint_probe_register+0x4a/0x68
>        [<ffffffff80277cae>] register_ftrace_graph+0x2a9/0x30f
>        [<ffffffff8027f928>] trace_selftest_startup_function_graph+0x2e/0xbb
>        [<ffffffff8027fdc5>] register_tracer+0x151/0x26e
>        [<ffffffff8070b942>] init_graph_trace+0x10/0x12
>        [<ffffffff80209066>] do_one_initcall+0x5b/0x135
>        [<ffffffff806fa5e4>] kernel_init+0x12f/0x185
>        [<ffffffff8020c2ba>] child_rip+0xa/0x20
>        [<ffffffffffffffff>] 0xffffffffffffffff
> 
> -> #0 (ftrace_lock){+.+.+.}:
>        [<ffffffff80261067>] __lock_acquire+0x101b/0x1668
>        [<ffffffff802617a2>] lock_acquire+0xee/0x112
>        [<ffffffff804fe0a6>] mutex_lock_nested+0x4f/0x305
>        [<ffffffff80277e71>] ftrace_convert_nops+0x32/0x267
>        [<ffffffff802780bd>] ftrace_init_module+0x17/0x19
>        [<ffffffff8026a011>] load_module+0x1122/0x160b
>        [<ffffffff8026a556>] sys_init_module+0x5c/0x1d3
>        [<ffffffff8020b21b>] system_call_fastpath+0x16/0x1b
>        [<ffffffffffffffff>] 0xffffffffffffffff



Ah that's this ftrace/modules lock dependency that Steven told me about
recently. Steven, do you know more about it now?

Thanks.
Frederic.

 
> other info that might help us debug this:
> 
> 1 lock held by modprobe/3184:
>  #0:  (module_mutex){+.+.+.}, at: [<ffffffff8026a539>] sys_init_module+0x3f/0x1d3
> 
> stack backtrace:
> Pid: 3184, comm: modprobe Not tainted 2.6.29-09854-gd508afb-dirty #6
> Call Trace:
>  [<ffffffff8025fba1>] print_circular_bug_tail+0xc5/0xd0
>  [<ffffffff80261067>] __lock_acquire+0x101b/0x1668
>  [<ffffffff80267905>] ? find_symbol_in_section+0x39/0xda
>  [<ffffffff80266a52>] ? each_symbol_in_section+0x3a/0x7a
>  [<ffffffff802617a2>] lock_acquire+0xee/0x112
>  [<ffffffff80277e71>] ? ftrace_convert_nops+0x32/0x267
>  [<ffffffff804fe0a6>] mutex_lock_nested+0x4f/0x305
>  [<ffffffff80277e71>] ? ftrace_convert_nops+0x32/0x267
>  [<ffffffff8020af16>] ? ftrace_call+0x5/0x2b
>  [<ffffffff80277e71>] ftrace_convert_nops+0x32/0x267
>  [<ffffffff802780bd>] ftrace_init_module+0x17/0x19
>  [<ffffffff8026a011>] load_module+0x1122/0x160b
>  [<ffffffff8025f3a5>] ? trace_hardirqs_on_caller+0x114/0x138
>  [<ffffffff8026a556>] sys_init_module+0x5c/0x1d3
>  [<ffffffff8020b21b>] system_call_fastpath+0x16/0x1b
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

