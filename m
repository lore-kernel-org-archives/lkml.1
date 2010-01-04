Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439Ab0ADSOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab0ADSOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 13:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983Ab0ADSOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 13:14:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab0ADSOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 13:14:18 -0500
Date: Mon, 4 Jan 2010 19:14:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: caiqian@redhat.com, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jan Kratochvil <jkratoch@redhat.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, utrace-devel@redhat.com
Subject: Re: s390 && user_enable_single_step() (Was: odd utrace testing
	results on s390x)
Message-ID: <20100104181412.GA21146@redhat.com>
References: <1503844142.2061111261478093776.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <1257887498.2061171261478252049.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <20100104155225.GA16650@redhat.com> <20100104171626.22ea2d9c@mschwide.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100104171626.22ea2d9c@mschwide.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04, Martin Schwidefsky wrote:
>
> On Mon, 4 Jan 2010 16:52:25 +0100
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > We have some strange problems with utrace on s390, and so far this _looks_
> > like a s390 problem.
> >
> > Looks like, on any CPU user_enable_single_step() does not "work" until at
> > least one thread with per_info.single_step = 1 does the context switch.
>
> The PER control registers only get reloaded on task switch. Can you test
> if this patch fixes your problem?
>
> --
> Subject: [PATCH] fix loading of PER control registers for utrace.
>
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
>
> If the current task enables / disables PER tracing for itself the
> PER control registers need to be loaded in FixPerRegisters.
>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
>  arch/s390/kernel/ptrace.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> --- a/arch/s390/kernel/ptrace.c
> +++ b/arch/s390/kernel/ptrace.c
> @@ -98,6 +98,9 @@ FixPerRegisters(struct task_struct *task
>  		per_info->control_regs.bits.storage_alt_space_ctl = 1;
>  	else
>  		per_info->control_regs.bits.storage_alt_space_ctl = 0;
> +
> +	if (task == current)
> +		__ctl_load(per_info->control_regs.words, 9, 11);
>  }

Yes it does fix the problem! Thanks a lot Martin.


However. Could you please look at 6580807da14c423f0d0a708108e6df6ebc8bc83d ?
I am worried, perhaps this commit is not enough for s390. OK, do_single_step()
tracehook_consider_fatal_signal(), this means the forked thread will not
be killed by SIGTRAP if it is not auto-attached, but still this may be
wrong.

IOW. I think this problem is minor and probably can be ignored, but if
I remove tracehook_consider_fatal_signal() check from do_single_step(),

--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -382,8 +382,7 @@ void __kprobes do_single_step(struct pt_
 					SIGTRAP) == NOTIFY_STOP){
 		return;
 	}
-	if (tracehook_consider_fatal_signal(current, SIGTRAP))
-		force_sig(SIGTRAP, current);
+	force_sig(SIGTRAP, current);
 }
 
 static void default_trap_handler(struct pt_regs * regs, long interruption_code)
-------------------------------------------------------------------

then the test-case from 6580807da14c423f0d0a708108e6df6ebc8bc83d
fails. This probably means that copy_process()->user_disable_single_step()
is not enough to clear the "this task wants single-stepping" copied
from parent.

Thanks!

Oleg.

