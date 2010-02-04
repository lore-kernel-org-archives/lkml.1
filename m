Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248Ab0BDNtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 08:49:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44468 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab0BDNty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 08:49:54 -0500
X-Authority-Analysis: v=1.0 c=1 a=5drdlUbjATAA:10 a=7U3hwN5JcxgA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8 a=tIakn2unZ5NFST6ecQoA:9 a=i07kh-lsmIDlv95Z7OYA:7 a=tU-Na4tYY30UmvEYiMeK_8EiHRQA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH -tip 4/4] ftrace: Remove record freezing
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       =?UTF-8?Q?Przemys=C5=82awPawe=C5=82czyk?= <przemyslaw@pawelczyk.it>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20100202214925.4694.73469.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100202214856.4694.72709.stgit@dhcp-100-2-132.bos.redhat.com>
	 <20100202214925.4694.73469.stgit@dhcp-100-2-132.bos.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Kihon Technologies Inc.
Date: Thu, 04 Feb 2010 08:49:50 -0500
Message-ID: <1265291391.24386.16.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late reply.


On Tue, 2010-02-02 at 16:49 -0500, Masami Hiramatsu wrote:
> Remove record freezing. Because kprobes never puts probe on
> ftrace's mcount call anymore, it doesn't need ftrace to check
> whether kprobes on it.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Ingo Molnar <mingo@elte.hu>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Cc: Przemysław Pawełczyk <przemyslaw@pawelczyk.it>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> ---
> 
>  include/linux/ftrace.h |    1 -
>  kernel/trace/ftrace.c  |   39 ---------------------------------------
>  2 files changed, 0 insertions(+), 40 deletions(-)
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 9d127ef..eb054ae 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -143,7 +143,6 @@ enum {
>  	FTRACE_FL_ENABLED	= (1 << 3),
>  	FTRACE_FL_NOTRACE	= (1 << 4),
>  	FTRACE_FL_CONVERTED	= (1 << 5),
> -	FTRACE_FL_FROZEN	= (1 << 6),
>  };
>  
>  struct dyn_ftrace {
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 3d90661..1904797 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -22,7 +22,6 @@
>  #include <linux/hardirq.h>
>  #include <linux/kthread.h>
>  #include <linux/uaccess.h>
> -#include <linux/kprobes.h>
>  #include <linux/ftrace.h>
>  #include <linux/sysctl.h>
>  #include <linux/ctype.h>
> @@ -898,36 +897,6 @@ static struct dyn_ftrace *ftrace_free_records;
>  		}				\
>  	}
>  
> -#ifdef CONFIG_KPROBES
> -
> -static int frozen_record_count;
> -
> -static inline void freeze_record(struct dyn_ftrace *rec)
> -{
> -	if (!(rec->flags & FTRACE_FL_FROZEN)) {
> -		rec->flags |= FTRACE_FL_FROZEN;
> -		frozen_record_count++;
> -	}
> -}
> -
> -static inline void unfreeze_record(struct dyn_ftrace *rec)
> -{
> -	if (rec->flags & FTRACE_FL_FROZEN) {
> -		rec->flags &= ~FTRACE_FL_FROZEN;
> -		frozen_record_count--;
> -	}
> -}
> -
> -static inline int record_frozen(struct dyn_ftrace *rec)
> -{
> -	return rec->flags & FTRACE_FL_FROZEN;
> -}
> -#else
> -# define freeze_record(rec)			({ 0; })
> -# define unfreeze_record(rec)			({ 0; })
> -# define record_frozen(rec)			({ 0; })
> -#endif /* CONFIG_KPROBES */
> -
>  static void ftrace_free_rec(struct dyn_ftrace *rec)
>  {
>  	rec->freelist = ftrace_free_records;
> @@ -1091,14 +1060,6 @@ static void ftrace_replace_code(int enable)
>  		    !(rec->flags & FTRACE_FL_CONVERTED))
>  			continue;
>  
> -		/* ignore updates to this record's mcount site */
> -		if (get_kprobe((void *)rec->ip)) {
> -			freeze_record(rec);
> -			continue;
> -		} else {
> -			unfreeze_record(rec);
> -		}
> -
>  		failed = __ftrace_replace_code(rec, enable);
>  		if (failed) {
>  			rec->flags |= FTRACE_FL_FAILED;
> 
> 


