Return-Path: <linux-kernel-owner+w=401wt.eu-S1760526AbYBGBfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760526AbYBGBfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 20:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbYBGBfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 20:35:04 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51337 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbYBGBfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 20:35:03 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Vivek Goyal <vgoyal@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>, tglx@linutronix.de,
       mingo@redhat.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH], issue EOI to APIC prior to calling crash_kexec in die_nmi path
References: <20080206192555.GA24910@hmsendeavour.rdu.redhat.com>
	<20080206220001.GA15155@elte.hu> <20080206224805.GD11886@redhat.com>
	<47AA3B16.7000507@zytor.com> <20080206233657.GB12393@elte.hu>
	<m1r6fpd2uo.fsf@ebiederm.dsl.xmission.com>
	<20080207003918.GA29943@elte.hu>
Date: Wed, 06 Feb 2008 18:30:21 -0700
In-Reply-To: <20080207003918.GA29943@elte.hu> (Ingo Molnar's message of "Thu,
	7 Feb 2008 01:39:18 +0100")
Message-ID: <m1bq6td042.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> Looking at the patch the local_irq_enable() is totally bogus.  As soon 
>> was we hit machine_crash_shutdown the first thing we do is disable 
>> irqs.
>
> yeah.
>
>> I'm wondering if someone was using the switch cpus on crash patch that 
>> was floating around.  That would require the ipis to work.
>> 
>> I don't know if nmi_exit makes sense.  There are enough layers of 
>> abstraction in that piece of code I can't quickly spot the part that 
>> is banging the hardware.
>> 
>> The location of nmi_exit in the patch is clearly wrong.  crash_kexec 
>> is a noop if we don't have a crash kernel loaded (and if we are not 
>> the first cpu into it), so if we don't execute the crash code 
>> something weird may happen.  Further the code is just more 
>> maintainable if that kind of code lives in machine_crash_shutdown.
>
> nmi_exit() has no hw effects - it's just our own bookeeping.

Alright so that should have no hardware effect then.

> the hw knows that we finished the NMI when we do an iret. Perhaps that's 
> the bug or side-effect that made the difference: via enabling irqs we 
> get an irq entry, and that does an iret and clears the NMI nested state 
> - allowing the kexec context to proceed? I suspect kexec() will do an 
> iret eventually (at minimum in the booted up kernel's context) - all 
> NMIs are blocked up to that point and maybe the APIC doesnt really like 
> being frobbed in that state? In any case, the local_irq_enable() is just 
> wrong - it's the worst thing a crashing kernel can do. Perhaps doing an 
> intentional iret with a prepared stack-let that just restores to 
> still-irqs-off state and jumps to the next instruction could 'exit' the 
> NMI context without really having to exit it in the kernel code flow?

Well I think this is slightly on the wrong track.  The original patch description
said  we get as far as purgatory.  Purgatory is the bit of C code form
/sbin/kexec that runs just before our second kernel.  It sets up
arguments and verify the target kernel has a valid sha256sum.  If
purgatory detects data corruption it spins, to prevent a corrupt
recovery kernel from doing something nasty.

It appears that the primary crash_kexec path is working fine.

The original description speculated that we had non-stopped cpus that
were telling the hardware to shut off.

I don't see what the hang is.  However the goal apparently is to make
the kexec on panic path more robust so that we can take crash dumps in
more strange cases.

We can get NMI from the nmi watchdogs so it is possible this happens
on legitimate hardware so there is a chance this is deterministic and
that we can get enough information to debug and fix the original
error.

If part of the problem is getting to crash_kexec my inclination is to
move the call to crash_kexec up as early as possible in die_nmi.  As
we may simply be hanging in printk or something stupid like that.

It is weird that only the 32bit die_nmi path calls bust_spinlocks.

I'm not really happy with the secondary cpus taking whole notify_die
path as that is more general purpose infrastructure that might go
bad.  However it doesn't appear broken, and it should not be critical
to the crash dump process.

Eric
