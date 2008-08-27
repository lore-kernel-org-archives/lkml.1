Return-Path: <linux-kernel-owner+w=401wt.eu-S1755797AbYH0NXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbYH0NXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754897AbYH0NXC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:23:02 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41224 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437AbYH0NXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:23:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] ftrace: disable tracing for suspend to ram
Date: Wed, 27 Aug 2008 15:26:45 +0200
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.DEB.1.10.0808211139420.3947@gandalf.stny.rr.com> <alpine.DEB.1.10.0808221651350.15941@gandalf.stny.rr.com> <alpine.DEB.1.10.0808270844500.7871@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0808270844500.7871@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808271526.46868.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 27 of August 2008, Steven Rostedt wrote:
> 
> I've been painstakingly debugging the issue with suspend to ram and 
> ftraced. The 2.6.28 code does not have this issue, but since the mcount 
> recording is not going to be in 27, this must be solved for the ftrace 
> daemon version.
> 
> The resume from suspend to ram would reboot because it was triple 
> faulting. Debugging further, I found that calling the mcount function 
> itself was not an issue, but it would fault when it incremented 
> preempt_count. preempt_count is on the tasks info structure that is on the 
> low memory address of the task's stack.  For some reason, it could not 
> write to it. Resuming out of suspend to ram does quite a lot of funny 
> tricks to get to work, so it is not surprising at all that simply doing a 
> preempt_disable() would cause a fault.
> 
> Thanks to Rafael for suggesting to add a "while (1);" to find the place in 
> resuming that is causing the fault. I would place the loop somewhere in 
> the code, compile and reboot and see if it would either reboot (hit the 
> fault) or simply hang (hit the loop).  Doing this over and over again, I 
> narrowed it down that it was happening in enable_nonboot_cpus.
> 
> At this point, I found that it is easier to simply disable tracing around 
> the suspend code, instead of searching for the particular function that 
> can not handle doing a preempt_disable.
> 
> This patch disables the tracer as it suspends and reenables it on resume.
> 
> I tested this patch on my Laptop, and it can resume fine with the patch.

Great, thanks for fixing that!

> Signed-off-by: Steven Rostedt <srostedt@redhat.com>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  kernel/power/main.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> Index: linux-compile.git/kernel/power/main.c
> ===================================================================
> --- linux-compile.git.orig/kernel/power/main.c	2008-08-27 08:53:11.000000000 -0400
> +++ linux-compile.git/kernel/power/main.c	2008-08-27 08:53:58.000000000 -0400
> @@ -21,6 +21,7 @@
>  #include <linux/freezer.h>
>  #include <linux/vmstat.h>
>  #include <linux/syscalls.h>
> +#include <linux/ftrace.h>
>  
>  #include "power.h"
>  
> @@ -310,7 +311,7 @@ static int suspend_enter(suspend_state_t
>   */
>  int suspend_devices_and_enter(suspend_state_t state)
>  {
> -	int error;
> +	int error, ftrace_save;
>  
>  	if (!suspend_ops)
>  		return -ENOSYS;
> @@ -321,6 +322,7 @@ int suspend_devices_and_enter(suspend_st
>  			goto Close;
>  	}
>  	suspend_console();
> +	ftrace_save = __ftrace_enabled_save();
>  	suspend_test_start();
>  	error = device_suspend(PMSG_SUSPEND);
>  	if (error) {
> @@ -352,6 +354,7 @@ int suspend_devices_and_enter(suspend_st
>  	suspend_test_start();
>  	device_resume(PMSG_RESUME);
>  	suspend_test_finish("resume devices");
> +	__ftrace_enabled_restore(ftrace_save);
>  	resume_console();
>   Close:
>  	if (suspend_ops->end)

Well, if that's enable_nonboot_cpus() that's faulting, I guess a similar change
in the hibernation code is needed.  I'll try to prepare a patch for that.

Thanks,
Rafael
