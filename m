Return-Path: <linux-kernel-owner+w=401wt.eu-S1757358AbXK0NPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbXK0NPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 08:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbXK0NPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 08:15:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbXK0NPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 08:15:36 -0500
Date: Tue, 27 Nov 2007 08:13:55 -0500
From: Neil Horman <nhorman@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, hbabu@us.ibm.com, vgoyal@in.ibm.com,
       kexec@lists.infradead.org, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
Message-ID: <20071127131355.GA14887@hmsendeavour.rdu.redhat.com>
References: <20071127014740.GA28622@hmsreliant.think-freely.org> <m1d4twmimu.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d4twmimu.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 09:12:25PM -0700, Eric W. Biederman wrote:
> Neil Horman <nhorman@tuxdriver.com> writes:
> 
> > Hey all-
> > 	I've been working on an issue lately involving multi socket x86_64
> > systems connected via hypertransport bridges.  It appears that some systems,
> > disable the hypertransport connections during a kdump operation when all but the
> > crashing processor gets halted in machine_crash_shutdown.  This becomes a
> > problem when the ioapic attempts to route interrupts to the only remaining
> > processor.  Even though the active processor is targeted for interrupt
> > reception, the fact that the hypertransport connections are inactive result in
> > interrupts not getting delivered.  The effective result is that timer interrupts
> > are not delivered to the running cpu, and the system hangs on reboot into the
> > kdump kernel during calibrate_delay.  I've found that I've been able to avoid
> > this hang, by forcing a transition to the bios defined boot cpu during the
> > crashing kernel shutdown.  This patch accomplished that.  Tested by myself and
> > the origional reporter with successful results.
> 
> If you can get to calibrate_delay hypertransport is still routing traffic.
> Your diagnosis of the problem is wrong.  Most likely it is just an ioapic
> programming error in restoring the system to PIC mode.
> 
What makes you say this?  I don't see any need for interrupts prior to
calibrate_delay()

> I agree that there is a problem.
> 
> The reliable fix is to totally skip the PIC interrupt mode and go directly
> to apic mode.
> 
> To make the code kexec on panic code path reliable we need to remove code
> not add it.
> 
> Frankly I think switching cpus is one of the least reliable things that
> we can do in general.
> 
I understand the sentiment here, but its not like we're adding additional
functionality with this patch.  We're already sending an IPI to all the
processors to halt them, we're just adding logic here so that we can detect the
boot cpu and use it to jump to the kexec image instead of halting.  I don't
think this is any less reliable that what we have currently.

Regards
Neil

> Eric
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@redhat.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
