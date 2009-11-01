Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbZKAWtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbZKAWtE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 17:49:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbZKAWtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 17:49:03 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:45369 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbZKAWtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 17:49:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p/n3Kmn6rG1i6VZ0+s/5cTXxlaaHBeapRMD8Vodgv4GZ9RxCeZnCn/x0x/erxWMkNB
         UBIzklHX3eWzPQ2ME07Blu0yGggfl1MsZPrav1Qsfu7j37rJIHWK8bEoB+aw+TzLUztC
         puJqkto1AAPkruAN88ASxa/oQ8hz+mbnxUk3Q=
Date: Sun, 1 Nov 2009 23:49:06 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 4/6] hw-breakpoints: Rewrite the hw-breakpoints layer
	on top of perf events
Message-ID: <20091101224904.GC5263@nowhere>
References: <4AE55B1B.2030006@web.de> <1257109753-6464-5-git-send-email-fweisbec@gmail.com> <4AEE06FF.9080807@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AEE06FF.9080807@web.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 01, 2009 at 11:09:03PM +0100, Jan Kiszka wrote:
> Frederic Weisbecker wrote:
> [...]
> > @@ -94,6 +87,12 @@ static inline void hw_breakpoint_disable(void)
> >  	set_debugreg(0UL, 3);
> >  }
> >
> > +#ifdef CONFIG_KVM
> > +extern void hw_breakpoint_restore(void);
> > +#else
> > +static inline void hw_breakpoint_restore(void)	{ }
> > +#endif
> > +
> 
> Hmm, if this shall become a KVM-only API, why the empty wrapper?



Right, this is an odd reflex.


 
> [...]
> > -void arch_flush_thread_hw_breakpoint(struct task_struct *tsk)
> > +#ifdef CONFIG_KVM
> > +void hw_breakpoint_restore(void)
> >  {
> > -	int i;
> > -	struct thread_struct *thread = &(tsk->thread);
> > -
> > -	thread->debugreg7 = 0;
> > -	for (i = 0; i < HBP_NUM; i++)
> > -		thread->debugreg[i] = 0;
> > +	set_debugreg(__get_cpu_var(cpu_debugreg[0]), 0);
> > +	set_debugreg(__get_cpu_var(cpu_debugreg[1]), 1);
> > +	set_debugreg(__get_cpu_var(cpu_debugreg[2]), 2);
> > +	set_debugreg(__get_cpu_var(cpu_debugreg[3]), 3);
> > +	set_debugreg(current->thread.debugreg6, 6);
> > +	set_debugreg(__get_cpu_var(dr7), 7);
> >  }
> > +#endif
> 
> EXPORT_SYMBOL_GPL(hw_breakpoint_restore);
> 
> as KVM can be built as module.



Indeed.


 
> [...]
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index fc2974a..32d7bca 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -42,6 +42,7 @@
> >  #define CREATE_TRACE_POINTS
> >  #include "trace.h"
> >  
> > +#include <asm/debugreg.h>
> >  #include <asm/uaccess.h>
> >  #include <asm/msr.h>
> >  #include <asm/desc.h>
> > @@ -3643,14 +3644,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
> >  	trace_kvm_entry(vcpu->vcpu_id);
> >  	kvm_x86_ops->run(vcpu, kvm_run);
> >  
> > -	if (unlikely(vcpu->arch.switch_db_regs || test_thread_flag(TIF_DEBUG))) {
> > -		set_debugreg(current->thread.debugreg[0], 0);
> > -		set_debugreg(current->thread.debugreg[1], 1);
> > -		set_debugreg(current->thread.debugreg[2], 2);
> > -		set_debugreg(current->thread.debugreg[3], 3);
> > -		set_debugreg(current->thread.debugreg6, 6);
> > -		set_debugreg(current->thread.debugreg7, 7);
> > -	}
> > +	if (unlikely(vcpu->arch.switch_db_regs || test_thread_flag(TIF_DEBUG)))
> > +		hw_breakpoint_restore();
> 
> TIF_DEBUG is only set on active ptrace hw-breakpoints, thus we miss
> other types here, right? (Note: arch.switch_db_regs is guest-related,
> thus does not help in this regard.)
> 
> Jan
> 


True :)
Thanks a lot for this review, I'm going to fix that quickly.

