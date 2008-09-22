Return-Path: <linux-kernel-owner+w=401wt.eu-S1753145AbYIVBNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbYIVBNY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 21:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbYIVBNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 21:13:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48337 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbYIVBNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 21:13:13 -0400
Date: Mon, 22 Sep 2008 10:12:18 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] [RFC] tracehook: Hook in syscall tracing markers.
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20080921021630.GA6443@linux-sh.org>
References: <20080921021630.GA6443@linux-sh.org>
Message-Id: <20080922010408.F53D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

> At kernel summit, the idea that syscall tracing was generally desirable
> for tracing was mentioned several times, as was the argument that kernel
> developers aren't placing markers in meaningful locations. This is a
> simple patch to try and do that for the syscall case.
> 
> Presently LTTng attempts to litter these trace markers all over the
> architecture code, primarily to get around the fact that there was no
> generic way to get at this information before. Now that platforms are
> starting to do their syscall entry/exit notifiers through tracehook and
> we have the asm/syscall.h interface, all of this information can be
> generically abstracted.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> 

I think marriage between tracehook and generic marker is very good idea. 
at least, instruction pointer and return value are definitly useful.

but...
Have you seen Mathieu's tracepoint patch?
I recommend to use tracepoint insted use marker directly.


> ---
> 
>  include/linux/tracehook.h |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
> index 6186a78..481ff45 100644
> --- a/include/linux/tracehook.h
> +++ b/include/linux/tracehook.h
> @@ -49,6 +49,9 @@
>  #include <linux/sched.h>
>  #include <linux/ptrace.h>
>  #include <linux/security.h>
> +#include <linux/marker.h>
> +#include <asm/syscall.h>
> +
>  struct linux_binprm;
>  
>  /**
> @@ -112,6 +115,8 @@ static inline __must_check int tracehook_report_syscall_entry(
>  	struct pt_regs *regs)
>  {
>  	ptrace_report_syscall(regs);
> +	trace_mark(kernel_arch_syscall_entry, "syscall_id %ld ip #p%ld",
> +		   syscall_get_nr(NULL, regs), instruction_pointer(regs));
>  	return 0;
>  }
>  
> @@ -135,6 +140,8 @@ static inline __must_check int tracehook_report_syscall_entry(
>  static inline void tracehook_report_syscall_exit(struct pt_regs *regs, int step)
>  {
>  	ptrace_report_syscall(regs);
> +	trace_mark(kernel_arch_syscall_exit, "ret %ld",
> +		   syscall_get_return_value(NULL, regs));
>  }


