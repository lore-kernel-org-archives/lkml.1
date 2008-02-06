Return-Path: <linux-kernel-owner+w=401wt.eu-S1761422AbYBFWtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761422AbYBFWtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 17:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757633AbYBFWtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 17:49:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbYBFWtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 17:49:13 -0500
Date: Wed, 6 Feb 2008 17:48:05 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Neil Horman <nhorman@tuxdriver.com>, tglx@linutronix.de, mingo@redhat.com,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH], issue EOI to APIC prior to calling crash_kexec in
	die_nmi path
Message-ID: <20080206224805.GD11886@redhat.com>
References: <20080206192555.GA24910@hmsendeavour.rdu.redhat.com> <20080206220001.GA15155@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206220001.GA15155@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 11:00:01PM +0100, Ingo Molnar wrote:
> 
> * Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> >  	if (!user_mode_vm(regs)) {
> > +		nmi_exit();
> > +		local_irq_enable();
> >  		current->thread.trap_no = 2;
> >  		crash_kexec(regs);
> 
> looks good to me, but please move the local_irq_enable() to within 
> crash_kexec() instead - probably inside the "got the kexec lock" 
> section. That makes crash_kexec() use generally safer too i guess: right 
> it seems that die() too can call crash_kexec() with irqs disabled - and 
> can thus hang in smp_send_stop() [or wherever it hung before].
> 

In general, I think we should not be servicing interrupts once the system
has crashed and crash_kexec() has been invoked. 

In fact, right now machine_crash_shutdown() explicity disables interrupt
before sending NMIs to other cpus to stop these cpus and which makes sense to
me.

I am wondering if interrupts are disabled on crashing cpu or if crashing
cpu is inside die_nmi(), how would it stop/prevent delivery of NMI IPI to
other cpus.

Am I missing something obivious?

Thanks
Vivek
