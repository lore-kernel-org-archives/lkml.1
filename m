Return-Path: <linux-kernel-owner+w=401wt.eu-S1755788AbZLRXPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbZLRXPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 18:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbZLRXPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 18:15:52 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51976 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbZLRXPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 18:15:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HeOq2YqP+0uf4tMbX1ooLusgz23bCQR6secUemZCrOsikgqzSCR9R+d4VfYP3+Fsfs
         e6n+F9LOAIuuf7uuCjFwSJ7+zQemM0tFDfKUbOx0HGcQmORxlXqA9uV+OHO2OOO4NBYa
         cQZ+yAU1XD0mJbAP586QfZ0eQ5ZOclGoVVTCg=
Date: Sat, 19 Dec 2009 00:15:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Roland McGrath <roland@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
       Avi Kivity <avi@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: Re: x86: do_debug && PTRACE_SINGLESTEP broken by
	08d68323d1f0c34452e614263b212ca556dae47f
Message-ID: <20091218231545.GA8803@nowhere>
References: <20091218005650.GA20667@redhat.com> <20091218030601.GB16470@nowhere> <20091218172747.GA10924@redhat.com> <20091218200503.2CA0DF9A4@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091218200503.2CA0DF9A4@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 12:05:03PM -0800, Roland McGrath wrote:
> > Please find the trivial test-case below. It hangs, because
> > PTRACE_SINGLESTEP doesn't trigger the trap.
> 
> 2.6.33-rc1 x86-64 works for me with either -m64 or -m32 version of that test.
> 
> > (not sure this matters, but I did the testing under kvm)
> 
> Apparently it does.  You should hack some printks into do_debug() and see
> how kvm is differing from real hardware.  (Actually you can probably do
> this with a notifier added by a module, not that you are shy about
> recompiling!)  
> 
> Probably kvm's emulation of the hardware behavior wrt the DR6 bits is not
> sufficiently faithful.  Conceivably, kvm is being consistent with some
> older hardware and we have encoded assumptions that only newer hardware
> meets.  But I'd guess it's just a plain kvm bug.


It looks like in kvm, before entering the guest, we restore its
debug registers:

vcpu_enter_guest():
	if (unlikely(vcpu->arch.switch_db_regs)) {
		set_debugreg(0, 7);
		set_debugreg(vcpu->arch.eff_db[0], 0);
		set_debugreg(vcpu->arch.eff_db[1], 1);
		set_debugreg(vcpu->arch.eff_db[2], 2);
		set_debugreg(vcpu->arch.eff_db[3], 3);
	}


But what happens to dr6, I don't know.

Adding Avi and Jan in Cc.

