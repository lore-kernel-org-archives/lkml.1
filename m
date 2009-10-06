Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbZJFB0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbZJFB0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 21:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbZJFB0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 21:26:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46027 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbZJFB0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 21:26:08 -0400
Subject: Re: system gets stuck in a lock during boot
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jason Baron <jbaron@redhat.com>
Cc: Justin Mattock <justinmattock@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20091002211211.GA2633@redhat.com>
References: <1251093523.7538.118.camel@twins>
	 <4A922F82.9080000@cn.fujitsu.com> <1251096925.7538.121.camel@twins>
	 <4A9251EB.8040805@gmail.com>
	 <dd18b0c30908241219mdb76311t9334929f34f2c4c3@mail.gmail.com>
	 <20090825085919.GB14003@elte.hu> <4A94803A.5060408@gmail.com>
	 <20090826073351.GE23435@elte.hu> <4A9549E5.5020002@gmail.com>
	 <dd18b0c30909071449q6834e847yb0f27ec971c9564a@mail.gmail.com>
	 <20091002211211.GA2633@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 05 Oct 2009 21:24:09 -0400
Message-Id: <1254792249.13160.213.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-02 at 17:12 -0400, Jason Baron wrote:

> hi Justin,
> 
> I've been playing around with gcc '4.5' as well and hit a panic that
> looks very similar to what you've seen with stock 2.6.31 - I haven't
> seen it anywhere else. Anyways, it seems to be some sort of alignment
> issue with the 'struct ftrace_event_call'. I'm not sure yet if this is a
> compiler or kernel issue. But the following kernel patch fixes the issue
> for me. It would be interesting to verify if the patch also resolves the
> issue for you.
> 
> thanks,
> 
> -Jason
> 
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 6ad76bf..0029af4 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -164,6 +164,7 @@
>  	LIKELY_PROFILE()		       				\
>  	BRANCH_PROFILE()						\
>  	TRACE_PRINTKS()							\
> +	. = ALIGN(32);							\
>  	FTRACE_EVENTS()							\
>  	TRACE_SYSCALLS()
>  
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index a81170d..43f9f1e 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -124,7 +124,7 @@ struct ftrace_event_call {
>  	atomic_t		profile_count;
>  	int			(*profile_enable)(struct ftrace_event_call *);
>  	void			(*profile_disable)(struct ftrace_event_call *);
> -};
> +} __attribute__((aligned(32)));
>  
>  #define MAX_FILTER_PRED		32
>  #define MAX_FILTER_STR_VAL	128
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index f64fbaa..4697fb6 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -600,7 +600,7 @@ static int ftrace_raw_init_event_##call(void)				\
>  }									\
>  									\
>  static struct ftrace_event_call __used					\
> -__attribute__((__aligned__(4)))						\
> +__attribute__((__aligned__(32)))					\
>  __attribute__((section("_ftrace_events"))) event_##call = {		\
>  	.name			= #call,				\
>  	.system			= __stringify(TRACE_SYSTEM),		\

Are all alignments needed? Or just adding one might help. Or removing
the one directly above?

-- Steve


