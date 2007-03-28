Return-Path: <linux-kernel-owner+w=401wt.eu-S933473AbXC1C1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473AbXC1C1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 22:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933482AbXC1C1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 22:27:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:55026 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933473AbXC1C1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 22:27:08 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>, william.morrow@amd.com,
       jordan.crouse@amd.com
Subject: Re: [PATCH] i386: add command line option "local_apic_timer_c2_ok"
Date: Tue, 27 Mar 2007 22:18:49 -0400
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
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <Pine.LNX.4.64.0703271430310.6730@woody.linux-foundation.org> <200703271816.33868.lenb@kernel.org>
In-Reply-To: <200703271816.33868.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703272218.50531.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 March 2007 18:16, Len Brown wrote:
> On Tuesday 27 March 2007 17:34, Linus Torvalds wrote:
> > 
> > On Tue, 27 Mar 2007, Len Brown wrote:
> > > 
> > > I think the only fool-proof way to do this automatically is to
> > 
> > Why not just take the known-good CPUID signature?
> >
> > Screw firmware or ACPI tables. They're going to be occasionally wrong.
> > 
> > If we know that "Core 2, version X" has a good local APIC timer, we use 
> > it. Otherwise we don't.
> > 
> > That's generally how we handle other APIC bugs too (the read-after-write 
> > thing, for example, or the differences between integrated and off-chip 
> > APIC's). Sometimes we check the APIC version itself, sometimes we check 
> > the CPUID information, and sometimes we check both ("modern_apic()").
> 
> Yep, this is what we tried to do last week.
> It failed, and the patch was reverted.
> 
> I agree, the BIOS vendor can lie with ACPI tables.
> In particular, they can map any hardware C-state
> to any ACPI C-state. Our expectation that they
> would not map hardware C3 to ACPI C2
> appears at this point to have been invalid.
> 
> So, speaking for Intel parts, every single one that supports
> HW C3 from the beginning of history through today has a broken
> LAPIC timer.  (and a few listed in that patch are known to
> be broken in HW C2)   If we can't guarantee that the BIOS vendor
> will not map that broken HW C3 to ACPI C2 (or even C1 via SMM)
> then we have to not use the LAPIC timer except for systems with
> a "known-good" signature = "part supports only C1".

On an Intel processor, it seems that the safe and simple route
is if the system exports C2 or deeper, don't use the LAPIC timer.
(which is what 2.6.21-rc5 is doing as of this moment)
We may be able to white-list some systems over time.

> If we really care about using the LAPIC timer on systems with deeper
> than C1 support, the only alternative seems to be to test
> if it actually works or not at boot and run-time.
> Otherwise, we wait for future hardware with guaranteed
> not to break under any (BIOS) conditions ships, and check for that.
> 
> Based on what I read of the HP nx6325 where the LAPIC timer
> is breaking C1, AMD is in the same boat.

The nx6325 (Turion 64 X2) exports only C1.
I'm not sure how the conclusion was drawn that it has
a broken lapic timer as reflected in the "nolapic_timer" patch:

+               /*
+                * BIOS exports only C1 state, but uses deeper power
+                * modes behind the kernels back.
+                */
+                 .callback = lapic_check_broken_bios,
+                 .ident = "HP nx6325",
+                 .matches = {
+                       DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6325"),
+                 },
+        },

But if this is true, then I don't know how to determine on
an AMD system if the LAPIC timer is guaranteed to work --
even for systems with just C1.

Jordan, William,
can you clarify?

thanks,
-Len
