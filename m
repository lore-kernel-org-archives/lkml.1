Return-Path: <linux-kernel-owner+w=401wt.eu-S1762278AbYBFWy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762278AbYBFWy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 17:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762035AbYBFWym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 17:54:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35856 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762028AbYBFWyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 17:54:41 -0500
Date: Wed, 6 Feb 2008 23:53:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, tglx@linutronix.de, mingo@redhat.com,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH], issue EOI to APIC prior to calling crash_kexec in
	die_nmi path
Message-ID: <20080206225355.GB4316@elte.hu>
References: <20080206192555.GA24910@hmsendeavour.rdu.redhat.com> <20080206220001.GA15155@elte.hu> <20080206224805.GD11886@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206224805.GD11886@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vivek Goyal <vgoyal@redhat.com> wrote:

> On Wed, Feb 06, 2008 at 11:00:01PM +0100, Ingo Molnar wrote:
> > 
> > * Neil Horman <nhorman@tuxdriver.com> wrote:
> > 
> > >  	if (!user_mode_vm(regs)) {
> > > +		nmi_exit();
> > > +		local_irq_enable();
> > >  		current->thread.trap_no = 2;
> > >  		crash_kexec(regs);
> > 
> > looks good to me, but please move the local_irq_enable() to within 
> > crash_kexec() instead - probably inside the "got the kexec lock" 
> > section. That makes crash_kexec() use generally safer too i guess: right 
> > it seems that die() too can call crash_kexec() with irqs disabled - and 
> > can thus hang in smp_send_stop() [or wherever it hung before].
> > 
> 
> In general, I think we should not be servicing interrupts once the 
> system has crashed and crash_kexec() has been invoked.
> 
> In fact, right now machine_crash_shutdown() explicity disables 
> interrupt before sending NMIs to other cpus to stop these cpus and 
> which makes sense to me.
> 
> I am wondering if interrupts are disabled on crashing cpu or if 
> crashing cpu is inside die_nmi(), how would it stop/prevent delivery 
> of NMI IPI to other cpus.
> 
> Am I missing something obivious?

i wondered about that too. kexec should be as atomic as it can be - 
enabling interrupts only opens up a window for another crash (more 
memory corruption, etc. etc) to happen.

	Ingo
