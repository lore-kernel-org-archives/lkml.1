Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbZKBNEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbZKBNEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 08:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbZKBNEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 08:04:36 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:38797 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080AbZKBNEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 08:04:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lbqlNVPJvOl98nxQYltzsfS01534vC1zZZcLEWXQGLGrl9PY7GTSkDMPmEbiTqGjNi
         202poL44A1JX3rrrIjn5PxGyDLUfh08gVfDwGzTmG7P1k/5JlJHX0PDvoiRGdtlcJny5
         U01lLJoHO7qw6nR2bjMDrG3fLQjLoPLtapLWk=
Date: Mon, 2 Nov 2009 14:04:40 +0100
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
Message-ID: <20091102130434.GC4878@nowhere>
References: <4AE55B1B.2030006@web.de> <1257109753-6464-5-git-send-email-fweisbec@gmail.com> <4AEE06FF.9080807@web.de> <20091101233659.GE5263@nowhere> <4AEE8E34.8080105@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AEE8E34.8080105@web.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 08:45:56AM +0100, Jan Kiszka wrote:
> Frederic Weisbecker wrote:
> > On Sun, Nov 01, 2009 at 11:09:03PM +0100, Jan Kiszka wrote:
> >>> @@ -3643,14 +3644,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
> >>>  	trace_kvm_entry(vcpu->vcpu_id);
> >>>  	kvm_x86_ops->run(vcpu, kvm_run);
> >>>  
> >>> -	if (unlikely(vcpu->arch.switch_db_regs || test_thread_flag(TIF_DEBUG))) {
> >>> -		set_debugreg(current->thread.debugreg[0], 0);
> >>> -		set_debugreg(current->thread.debugreg[1], 1);
> >>> -		set_debugreg(current->thread.debugreg[2], 2);
> >>> -		set_debugreg(current->thread.debugreg[3], 3);
> >>> -		set_debugreg(current->thread.debugreg6, 6);
> >>> -		set_debugreg(current->thread.debugreg7, 7);
> >>> -	}
> >>> +	if (unlikely(vcpu->arch.switch_db_regs || test_thread_flag(TIF_DEBUG)))
> >>> +		hw_breakpoint_restore();
> >> TIF_DEBUG is only set on active ptrace hw-breakpoints, thus we miss
> >> other types here, right? (Note: arch.switch_db_regs is guest-related,
> >> thus does not help in this regard.)
> >>
> >> Jan
> >>
> > 
> > 
> > About this. vcpu->arch.switch_db_regs is guest related but it looks
> > like the only thing I need to check.
> > 
> > I'm not sure when it is activated. Is it always done once the guest
> > changes its debug registers? I suspect there is a corner case.
> 
> It's set when we had to write to some debugreg[0..4], either for use by
> the guest itself or for debugging it from the host. It used to be the
> only condition for switching on exit as we saved the registers on entry
> (under the same condition). This was reworked recently to avoid the
> entry saving.
> 
> > 
> > Because since I can't anymore assume TIF_DEBUG covers every
> > breakpoints uses, it means I'll need to maintain a refcount of
> > breakpoints in use.
> > Well, I have one already, but it is splitted into several refcounts
> > (per task events, per cpu, non-pinned, etc...). And since
> > vcpu_enter_guest() is a fast path, I'll need to maintain another global
> > per cpu one, without lock or further operations to know if we need
> > to save the debug registers, just a simple check.
> > 
> 
> I'm not 100% sure right now if we still need "switch_db_reg" in case we
> have a reliable indicator that the host requires properly set registers.
> ATM I would dare to say, we don't, but I need to think about this again.
> 
> Jan
> 


Ok. I'm going to just check if the host has active breakpoints pending and
if so, I'll restore them while exiting the guest.

Thanks.

