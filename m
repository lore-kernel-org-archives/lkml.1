Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbZJZA1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbZJZA1Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 20:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbZJZA1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 20:27:15 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:65380 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbZJZA1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 20:27:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JqTwmpTpYvwrsfeH9PYGIi3FC5anL3wqXPdOJ0B6rqnI/AJNo3zU8DNqO4BsUBLb7k
         xjSh/o0I/YjuuRJtAV7hX7KxMOhv95d/tZJudNiU5bE9BAlOKO55tx4F0z676csx2G1Z
         Udjh7Jk7fzgSmpH6SyudQfPyU8Ut7qZdimqF4=
MIME-Version: 1.0
In-Reply-To: <49b3c441a57f4db423732f81432a3450ccb3240e.1256483735.git.wuzhangjin@gmail.com>
References: <cover.1256482555.git.wuzhangjin@gmail.com>
	 <028867b99ec532b84963a35e7d552becc783cafc.1256483735.git.wuzhangjin@gmail.com>
	 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256483735.git.wuzhangjin@gmail.com>
	 <3e0c2d7d8b8f196a8153beb41ea7f3cbf42b3d84.1256483735.git.wuzhangjin@gmail.com>
	 <54c417629e91f40b2bbb4e08cda2a4e6527824c0.1256483735.git.wuzhangjin@gmail.com>
	 <29bccff04932e993ecd9f516d8b6dcf84e2ceecf.1256483735.git.wuzhangjin@gmail.com>
	 <72f2270f7b6e01ca7a4cdf4ac8c21778e5d9652f.1256483735.git.wuzhangjin@gmail.com>
	 <cover.1256483735.git.wuzhangjin@gmail.com>
	 <6140dd8f4e1783e5ac30977cf008bb98e4698322.1256483735.git.wuzhangjin@gmail.com>
	 <49b3c441a57f4db423732f81432a3450ccb3240e.1256483735.git.wuzhangjin@gmail.com>
Date: Mon, 26 Oct 2009 01:27:18 +0100
Message-ID: <c62985530910251727o23beafcco539870e4b2f84637@mail.gmail.com>
Subject: Re: [PATCH -v5 08/11] tracing: not trace mips_timecounter_init() in 
	MIPS
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/25 Wu Zhangjin <wuzhangjin@gmail.com>:
> -static inline u64 mips_timecounter_read(void)
> +static inline u64 notrace mips_timecounter_read(void)


You don't need to set notrace functions, unless their addresses
are referenced somewhere, which unfortunately might happen
for some functions but this is rare.


>  {
>  #ifdef CONFIG_CSRC_R4K
>        return r4k_timecounter_read();
> diff --git a/arch/mips/kernel/csrc-r4k.c b/arch/mips/kernel/csrc-r4k.c
> index 4e7705f..0690bea 100644
> --- a/arch/mips/kernel/csrc-r4k.c
> +++ b/arch/mips/kernel/csrc-r4k.c
> @@ -42,7 +42,7 @@ static struct timecounter r4k_tc = {
>        .cc = NULL,
>  };
>
> -static cycle_t r4k_cc_read(const struct cyclecounter *cc)
> +static cycle_t notrace r4k_cc_read(const struct cyclecounter *cc)
>  {
>        return read_c0_count();
>  }
> @@ -66,7 +66,7 @@ int __init init_r4k_timecounter(void)
>        return 0;
>  }
>
> -u64 r4k_timecounter_read(void)
> +u64 notrace r4k_timecounter_read(void)
>  {
>        u64 clock;
>
> diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
> index 83d2fbd..2a02992 100644
> --- a/include/linux/clocksource.h
> +++ b/include/linux/clocksource.h
> @@ -73,7 +73,7 @@ struct timecounter {
>  * XXX - This could use some mult_lxl_ll() asm optimization. Same code
>  * as in cyc2ns, but with unsigned result.
>  */
> -static inline u64 cyclecounter_cyc2ns(const struct cyclecounter *cc,
> +static inline u64 notrace cyclecounter_cyc2ns(const struct cyclecounter

ditto here.


*cc,
>                                      cycle_t cycles)
>  {
>        u64 ret = (u64)cycles;
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index 5e18c6a..9ce9d02 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -52,7 +52,7 @@ EXPORT_SYMBOL(timecounter_init);
>  * The first call to this function for a new time counter initializes
>  * the time tracking and returns an undefined result.
>  */
> -static u64 timecounter_read_delta(struct timecounter *tc)
> +static u64 notrace timecounter_read_delta(struct timecounter *tc)
>  {
>        cycle_t cycle_now, cycle_delta;
>        u64 ns_offset;
> @@ -72,7 +72,7 @@ static u64 timecounter_read_delta(struct timecounter


Hmm yeah this is not very nice to do that in core functions because
of a specific arch problem.
At least you have __notrace_funcgraph, this is a notrace
that only applies if CONFIG_FUNCTION_GRAPH_TRACER
so that it's still traceable by the function tracer in this case.

But I would rather see a __mips_notrace on these two core functions.
