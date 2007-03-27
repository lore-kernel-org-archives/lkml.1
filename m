Return-Path: <linux-kernel-owner+w=401wt.eu-S965044AbXC0WdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965044AbXC0WdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 18:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964813AbXC0WdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 18:33:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:50229 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965044AbXC0WdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 18:33:00 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] i386: add command line option "local_apic_timer_c2_ok"
Date: Tue, 27 Mar 2007 18:16:33 -0400
User-Agent: KMail/1.9.5
Cc: Thomas Gleixner <tglx@linutronix.de>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Mingming Cao <cmm@us.ibm.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Thomas Renninger <trenn@suse.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703271719.25795.lenb@kernel.org> <Pine.LNX.4.64.0703271430310.6730@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703271430310.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703271816.33868.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 March 2007 17:34, Linus Torvalds wrote:
> 
> On Tue, 27 Mar 2007, Len Brown wrote:
> > 
> > I think the only fool-proof way to do this automatically is to
> 
> Why not just take the known-good CPUID signature?
>
> Screw firmware or ACPI tables. They're going to be occasionally wrong.
> 
> If we know that "Core 2, version X" has a good local APIC timer, we use 
> it. Otherwise we don't.
> 
> That's generally how we handle other APIC bugs too (the read-after-write 
> thing, for example, or the differences between integrated and off-chip 
> APIC's). Sometimes we check the APIC version itself, sometimes we check 
> the CPUID information, and sometimes we check both ("modern_apic()").

Yep, this is what we tried to do last week.
It failed, and the patch was reverted.

I agree, the BIOS vendor can lie with ACPI tables.
In particular, they can map any hardware C-state
to any ACPI C-state. Our expectation that they
would not map hardware C3 to ACPI C2
appears at this point to have been invalid.

So, speaking for Intel parts, every single one that supports
HW C3 from the beginning of history through today has a broken
LAPIC timer.  (and a few listed in that patch are known to
be broken in HW C2)   If we can't guarantee that the BIOS vendor
will not map that broken HW C3 to ACPI C2 (or even C1 via SMM)
then we have to not use the LAPIC timer except for systems with
a "known-good" signature = "part supports only C1".

If we really care about using the LAPIC timer on systems with deeper
than C1 support, the only alternative seems to be to test
if it actually works or not at boot and run-time.
Otherwise, we wait for future hardware with guaranteed
not to break under any (BIOS) conditions ships, and check for that.

Based on what I read of the HP nx6325 where the LAPIC timer
is breaking C1, AMD is in the same boat.

-Len
