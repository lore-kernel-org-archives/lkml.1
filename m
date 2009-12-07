Return-Path: <linux-kernel-owner+w=401wt.eu-S935381AbZLGQa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935381AbZLGQa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935370AbZLGQaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:30:55 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:64969 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935289AbZLGQay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 11:30:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fx6OcbNeucqF1C4YD/KCrXJKnwKkBRZvO0IN5gJLv6mbTNxbtcAyTQsWfms9qW01oe
         s9cfVZG4VVGEYFPBM+VYubDLIQ8R8KUR91ikFXtWsimf3HVeK9E7NsGcR4w0gIuJe5b0
         vJSK4syoGQPri/ok2lORVBle6WUlnicxEuXr4=
Date: Mon, 7 Dec 2009 19:30:57 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Fix bogus warning in
	apic_noop.apic_write()
Message-ID: <20091207163057.GB5489@lenovo>
References: <alpine.LFD.2.00.0912071255420.3089@localhost.localdomain> <tip-a946d8f11f0da9cfc714248036fcfd3a794d1e27@git.kernel.org> <20091207150425.GA5489@lenovo> <alpine.LFD.2.00.0912071629350.3089@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912071629350.3089@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 04:48:51PM +0100, Thomas Gleixner wrote:
> On Mon, 7 Dec 2009, Cyrill Gorcunov wrote:
> > On Mon, Dec 07, 2009 at 12:18:37PM +0000, tip-bot for Thomas Gleixner wrote:
> > > Commit-ID:  a946d8f11f0da9cfc714248036fcfd3a794d1e27
> > > Gitweb:     http://git.kernel.org/tip/a946d8f11f0da9cfc714248036fcfd3a794d1e27
> > > Author:     Thomas Gleixner <tglx@linutronix.de>
> > > AuthorDate: Mon, 7 Dec 2009 12:59:46 +0100
> > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > CommitDate: Mon, 7 Dec 2009 13:16:37 +0100
> > > 
> > > x86: Fix bogus warning in apic_noop.apic_write()
> > > 
> > > apic_noop is used to provide dummy apic functions. It's installed
> > > when the CPU has no APIC or when the APIC is disabled on the kernel
> > > command line.
> > > 
> > > The apic_noop implementation of apic_write() warns when the CPU has
> > > an APIC or when the APIC is not disabled.
> > > 
> > > That's bogus. The warning should only happen when the CPU has an
> > > APIC _AND_ the APIC is not disabled. apic_noop.apic_read() has the
> > > correct check.
> > > 
> > > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> > > Cc: <stable@kernel.org> # in <= .32 this typo resides in native_apic_write_dummy()
> > > LKML-Reference: <alpine.LFD.2.00.0912071255420.3089@localhost.localdomain>
> > > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > > ---
> > >  arch/x86/kernel/apic/apic_noop.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > ...
> > 
> > Hi Thomas, Ingo,
> > 
> > please do not change it. There are still machines without
> > cpu_has_apic bit support so with this patch any attempt
> > to write to 82489DX will success. So the former code has
> > been using "OR" by a purpose, there is no error.
> 
> Err, your warning has the following false positive:
> 
>      cpu_has_apic == true and disable_apic == true

This combination impossible at moment (by "impossible" I mean
at moment of apic_write action). When apic disabled via boot
option cpu_has_apic cleared as well.

static int __init setup_disableapic(char *arg)
{
	disable_apic = 1;
	setup_clear_cpu_cap(X86_FEATURE_APIC);
	return 0;
}

And, btw if some code is trying to write to apic when
it's disabled via boot option -- it means the code is
buggy and this is not a false positive but rather proper
warning.

Thomas, if you've changed this code I suppose you saw some
warning triggered, right? Could you pointed me on it?

The idea was exactly to use "OR" here, so any attempts to
make WRITE on dosabled apic were captured.

> 
> Which is crap, as it warns just because someone disabled the APIC on
> the command line and the kernel did the right thing of installing
> apic_noop.
> 
> And I have a hard time to see how this is related to 82489DX.

On 82489DX there is no X86_FEATURE_APIC at all, so cpu_has_apic
is never set and disable_apic is the only flag we inspect to find
out if we're allowed to operate over apic.

An example you may find in APIC_init_uniprocessor, the first check
is done for disable_apic, not cpu_has_apic.

>  
> Thanks,
> 
> 	tglx
> 

	-- Cyrill
