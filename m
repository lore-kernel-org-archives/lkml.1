Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbZKAXg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbZKAXg6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 18:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbZKAXg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 18:36:57 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:43940 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbZKAXg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 18:36:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xyGsemp3XCqMi8X/rGdBX2g5Fza/clhKMKmJtYjMj6gupd8vZ4vOi8/gOaNjeHEZ3K
         DdbMqQmeyqxROTn6Se0P//AKFUSErq888QWhPiYG/hvo2ZFt/4iB2fT2HXthSiLjC0qs
         T+WLuPbNUDPuvv/bAM9TbeiTXNyDmUxn2nV+o=
Date: Mon, 2 Nov 2009 00:37:01 +0100
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
Message-ID: <20091101233659.GE5263@nowhere>
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


About this. vcpu->arch.switch_db_regs is guest related but it looks
like the only thing I need to check.

I'm not sure when it is activated. Is it always done once the guest
changes its debug registers? I suspect there is a corner case.

Because since I can't anymore assume TIF_DEBUG covers every
breakpoints uses, it means I'll need to maintain a refcount of
breakpoints in use.
Well, I have one already, but it is splitted into several refcounts
(per task events, per cpu, non-pinned, etc...). And since
vcpu_enter_guest() is a fast path, I'll need to maintain another global
per cpu one, without lock or further operations to know if we need
to save the debug registers, just a simple check.

