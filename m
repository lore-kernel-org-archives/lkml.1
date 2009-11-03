Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbZKCUPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbZKCUPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 15:15:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbZKCUPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 15:15:04 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55599 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbZKCUPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 15:15:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Fzlh6lKa7ARCamdgWNK/k2U1h5L5aEvh+Z8oWVJ0GpVfAMl3yH9EwbRvYQb6CIOeqV
         AWDTTwBO7of6f+HNiJRHzz0xoMpudYuCP+MaA7NqGxX4GnD+PKy9Efa1E2yViH1zrTST
         8Tf6VTIaZKpS14Ik4IuKeSQGCxT9AAcksHwgM=
Date: Tue, 3 Nov 2009 21:15:06 +0100
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
Message-ID: <20091103201503.GA4962@nowhere>
References: <1257275474-5285-1-git-send-email-fweisbec@gmail.com> <1257275474-5285-5-git-send-email-fweisbec@gmail.com> <4AF08B7C.8040903@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF08B7C.8040903@web.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 08:58:52PM +0100, Jan Kiszka wrote:
> Frederic Weisbecker wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index fc2974a..6560129 100644
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
> > @@ -3643,14 +3644,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
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
> > +	/*
> > +	 * CHECKME: is vcpu->arch.switch_db_regs sufficient to check
> > +	 * if the guest is using breakpoints? If so we may want to do
> > +	 * this check before.
> > +	 */
> > +	hw_breakpoint_restore();
> 
> Obviously, this variant will make KVM users very unhappy. But trying to
> reduce this performance regression via vcpu->arch.switch_db_regs will
> make hw-breakpoint users unhappy: KVM leaves at least dr7 clobbered
> behind, even if the guest does not use breakpoints.


Yeah, that's why I've made unconditionally. At least it works in every
cases, but this is temporary.

 
> We really need a replacement for TIF_DEBUG (but we only need this [1]).
> 
> Jan
> 
> [1]http://thread.gmane.org/gmane.comp.emulators.kvm.devel/39784/focus=39827
> 


Thinking about it, this check should cover every cases:

if (vcpu->arch.switch_db_regs || __get_cpu_var(dr7) & DR_GLOBAL_ENABLE_MASK)

If we have __get_cpu_var(dr7) & DR_GLOBAL_ENABLE_MASK, it means there is an
active breakpoint and then we should restore the current state.

