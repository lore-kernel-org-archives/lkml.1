Return-Path: <linux-kernel-owner+w=401wt.eu-S1758974AbYBGMTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974AbYBGMTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 07:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755627AbYBGMTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 07:19:10 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:2357 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755572AbYBGMTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:19:09 -0500
Date: Thu, 7 Feb 2008 07:17:19 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Vivek Goyal <vgoyal@redhat.com>, tglx@linutronix.de, mingo@redhat.com,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH], issue EOI to APIC prior to calling crash_kexec in
	die_nmi path
Message-ID: <20080207121719.GA29279@hmsreliant.think-freely.org>
References: <20080206192555.GA24910@hmsendeavour.rdu.redhat.com> <20080206220001.GA15155@elte.hu> <20080206224805.GD11886@redhat.com> <47AA3B16.7000507@zytor.com> <20080206233657.GB12393@elte.hu> <m1r6fpd2uo.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1r6fpd2uo.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 05:31:11PM -0700, Eric W. Biederman wrote:
> Ingo Molnar <mingo@elte.hu> writes:
> 
> > * H. Peter Anvin <hpa@zytor.com> wrote:
> >
> >>> I am wondering if interrupts are disabled on crashing cpu or if 
> >>> crashing cpu is inside die_nmi(), how would it stop/prevent delivery 
> >>> of NMI IPI to other cpus.
> >>
> >> I don't see how it would.
> >
> > cross-CPU IPIs are a bit fragile on some PC platforms. So if the kexec 
> > code relies on getting IPIs to all other CPUs, it might not be able to 
> > do it reliably. There might be limitations on how many APIC irqs there 
> > can be queued at a time, and if those slots are used up and the CPU is 
> > not servicing irqs then stuff gets retried. This might even affect NMIs 
> > sent via APIC messages - not sure about that.
> 
> 
> 
> The design was as follows:
> - Doing anything in the crashing kernel is unreliable.
> - We do not have the information to do anything useful in the recovery/target
>   kernel.
> - Having the other cpus stopped is very nice as it reduces the amount of
>   weirdness happening.  We do not share the same text or data addresses
>   so stopping the other cpus is not mandatory.  On some other architectures
>   there are cpu tables that must live at a fixed address but this is not
>   the case on x86.
> - Having the location the other cpus were running at is potentially very
>   interesting debugging information.
> 
> Therefore the intent of the code is to send an NMI to each other cpu.  With
> a timeout of a second or so.  So that if the NMI do not get sent we continue
> on.
> 
> There is certainly still room for improving the robustness by not shutting
> down the ioapics and using less general infrastructure code on that path.
> That said I would be a little surprised if that is what is biting us.
> 
> Looking at the patch the local_irq_enable() is totally bogus.  As soon
> was we hit machine_crash_shutdown the first thing we do is disable irqs.
> 

Ingo noted a few posts down the nmi_exit doesn't actually write to the APIC EOI
register, so yeah, I agree, its bogus (and I apologize, I should have checked
that more carefully).  Nevertheless, this patch consistently allowed a hangning
machine to boot through an Nmi lockup.  So I'm forced to wonder whats going on
then that this patch helps with.  perhaps its a just a very fragile timing
issue, I'll need to look more closely.

> I'm wondering if someone was using the switch cpus on crash patch that was
> floating around.  That would require the ipis to work.
> 
Definately not the case, I did a clean build from a cvs tree to test this and
can verify that the switch cpu patch was not in place.

> I don't know if nmi_exit makes sense.  There are enough layers of abstraction
> in that piece of code I can't quickly spot the part that is banging the hardware.
> 
As ingo mentioned this does seem to be bogus.

> The location of nmi_exit in the patch is clearly wrong.  crash_kexec is a noop
> if we don't have a crash kernel loaded (and if we are not the first cpu into it),
> so if we don't execute the crash code something weird may happen.  Further the
> code is just more maintainable if that kind of code lives in machine_crash_shutdown.
> 
> 
> 
> Eric

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
