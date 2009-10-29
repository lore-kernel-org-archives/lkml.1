Return-Path: <linux-kernel-owner+w=401wt.eu-S1751445AbZJ2H5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbZJ2H5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 03:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbZJ2H5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 03:57:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56193 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbZJ2H5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 03:57:45 -0400
Date: Thu, 29 Oct 2009 08:57:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: Fix to use unused attribute
Message-ID: <20091029075735.GC18976@elte.hu>
References: <4AE7A217.8030008@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE7A217.8030008@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> ____ftrace_check_##name() is used for compile-time check
> on F_printk() only, so it should be marked as __unused
> instead of __used.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
> 
> I'm thinking about introducing __always_unused, comparing
> to __maybe_unused.
> 
> ---
>  kernel/trace/trace_export.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
> index 934d81f..85309fc 100644
> --- a/kernel/trace/trace_export.c
> +++ b/kernel/trace/trace_export.c
> @@ -48,11 +48,12 @@
>  struct ____ftrace_##name {					\
>  	tstruct							\
>  };								\
> -static void __used ____ftrace_check_##name(void)		\
> +static void __attribute__((unused))				\
> +____ftrace_check_##name(void)					\
>  {								\
>  	struct ____ftrace_##name *__entry = NULL;		\
>  								\
> -	/* force cmpile-time check on F_printk() */		\
> +	/* force compile-time check on F_printk() */		\
>  	printk(print);						\
>  }

Hm, open-coding __attribute__()'s is not good.

These tags are somewhat of a mess:

 #if __GNUC_MINOR__ >= 3
 # define __used                 __attribute__((__used__))
 #else
 # define __used                 __attribute__((__unused__))
 #endif

I've Cc:-ed Linus and Andrew, to solicite feedback on __always_unused. I 
think we should add it.

	Ingo
