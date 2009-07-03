Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232AbZGCHjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbZGCHjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 03:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbZGCHj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 03:39:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:56477 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbZGCHj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 03:39:27 -0400
Subject: Re: [PATCH 1/2 -tip] perf_counter: Add generalized hardware
 vectored co-processor support for AMD and Intel Corei7/Nehalem
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Anton Blanchard <anton@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1246527872.13659.2.camel@hpdv5.satnam>
References: <1246440815.3403.3.camel@hpdv5.satnam>
	 <1246440909.3403.5.camel@hpdv5.satnam>
	 <1246440977.3403.7.camel@hpdv5.satnam>
	 <1246441043.3403.9.camel@hpdv5.satnam> <20090701112007.GD15958@elte.hu>
	 <20090701112704.GF15958@elte.hu> <1246448441.6940.3.camel@hpdv5.satnam>
	 <20090701114928.GI15958@elte.hu>  <1246527872.13659.2.camel@hpdv5.satnam>
Content-Type: text/plain
Date: Fri, 03 Jul 2009 13:08:56 +0530
Message-Id: <1246606736.2322.9.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

On Thu, 2009-07-02 at 15:14 +0530, Jaswinder Singh Rajput wrote:
> This output is from AMD box:
> 
> $ ./perf stat -e add -e multiply -e divide -e vec-idle-cycles -e vec-stall-cycles -e vec-ops -- ls -lR /usr/include/ > /dev/null
> 
>  Performance counter stats for 'ls -lR /usr/include/':
> 
>            4218  vec-adds                  (scaled from 66.60%)
>            7426  vec-muls                  (scaled from 66.67%)
>            5441  vec-divs                  (scaled from 66.29%)
>       821982187  vec-idle-cycles           (scaled from 66.45%)
>            2681  vec-stall-cycles          (scaled from 67.11%)
>            7887  vec-ops                   (scaled from 66.88%)
> 
>     0.417614573  seconds time elapsed
> 
> $ ./perf stat -e add -e multiply -e divide -e vec-idle-cycles -e vec-stall-cycles -e vec-ops -- /usr/bin/rhythmbox ~jaswinder/Music/singhiskinng.mp3
> 
>  Performance counter stats for '/usr/bin/rhythmbox /home/jaswinder/Music/singhiskinng.mp3':
> 
>        17552264  vec-adds                  (scaled from 66.28%)
>        19715258  vec-muls                  (scaled from 66.63%)
>        15862733  vec-divs                  (scaled from 66.82%)
>     23735187095  vec-idle-cycles           (scaled from 66.89%)
>        11353159  vec-stall-cycles          (scaled from 66.90%)
>        36628571  vec-ops                   (scaled from 66.48%)
> 
>   298.350012843  seconds time elapsed
> 
> $ ./perf stat -e add -e multiply -e divide -e vec-idle-cycles -e vec-stall-cycles -e vec-ops -- /usr/bin/vlc ~jaswinder/Videos/Linus_Torvalds_interview_with_Charlie_Rose_Part_1.flv
> 
>  Performance counter stats for '/usr/bin/vlc /home/jaswinder/Videos/Linus_Torvalds_interview_with_Charlie_Rose_Part_1.flv':
> 
>     20177177044  vec-adds                  (scaled from 66.63%)
>     34101687027  vec-muls                  (scaled from 66.64%)
>      3984060862  vec-divs                  (scaled from 66.71%)
>     26349684710  vec-idle-cycles           (scaled from 66.65%)
>      9052001905  vec-stall-cycles          (scaled from 66.66%)
>     76440734242  vec-ops                   (scaled from 66.71%)
> 
>   272.523058097  seconds time elapsed
> 
> $ ./perf list shows vector events like :
> 
>   vec-adds OR add                          [Hardware vector event]
>   vec-muls OR multiply                     [Hardware vector event]
>   vec-divs OR divide                       [Hardware vector event]
>   vec-idle-cycles OR vec-empty-cycles      [Hardware vector event]
>   vec-stall-cycles OR vec-busy-cycles      [Hardware vector event]
>   vec-ops OR vec-operations                [Hardware vector event]
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/kernel/cpu/perf_counter.c |   45 +++++++++++++++++++++++++++++
>  include/linux/perf_counter.h       |   15 ++++++++++
>  kernel/perf_counter.c              |    1 +
>  tools/perf/util/parse-events.c     |   55 ++++++++++++++++++++++++++++++++++++
>  4 files changed, 116 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
> index 36c3dc7..48f28b7 100644
> --- a/arch/x86/kernel/cpu/perf_counter.c
> +++ b/arch/x86/kernel/cpu/perf_counter.c
> @@ -372,6 +372,22 @@ static const u64 atom_hw_cache_event_ids
>   },
>  };
>  
> +/*
> + * Generalized hw vectored co-processor event table
> + */
> +
> +static u64 __read_mostly hw_vector_event_ids[PERF_COUNT_HW_VECTOR_MAX];
> +
> +static const u64 nehalem_hw_vector_event_ids[] =
> +{
> +  [PERF_COUNT_HW_VECTOR_ADD]		= 0x01B1, /* UOPS_EXECUTED.PORT0     */
> +  [PERF_COUNT_HW_VECTOR_MULTIPLY]	= 0x0214, /* ARITH.MUL               */
> +  [PERF_COUNT_HW_VECTOR_DIVIDE]		= 0x0114, /* ARITH.CYCLES_DIV_BUSY   */
> +  [PERF_COUNT_HW_VECTOR_IDLE_CYCLES]	= 0x0,
> +  [PERF_COUNT_HW_VECTOR_STALL_CYCLES]	= 0x60A2, /* RESOURCE_STALLS.FPCW|MXCSR*/
> +  [PERF_COUNT_HW_VECTOR_OPS]		= 0x0710, /* FP_COMP_OPS_EXE.X87|MMX|SSE_FP*/
> +};
> +

Have you tested this patch on Intel Corei7/Nehalem.

Thanks,
--
JSR

http://userweb.kernel.org/~jaswinder/



