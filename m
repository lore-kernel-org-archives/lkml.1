Return-Path: <linux-kernel-owner+w=401wt.eu-S1762220AbYGOTPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762220AbYGOTPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758254AbYGOTPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:15:19 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:30788 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758202AbYGOTPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:15:17 -0400
Date: Tue, 15 Jul 2008 13:15:15 -0600
From: Alex Chiang <achiang@hp.com>
To: Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 01/14] Introduce cpu_enabled_map and friends
Message-ID: <20080715191515.GE10919@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-acpi@vger.kernel.org
References: <20080715023344.2528.1836.stgit@blender.achiang> <20080715023349.2528.9423.stgit@blender.achiang> <20080715031512.GF14894@parisc-linux.org> <87wsjnxy4w.fsf@basil.nowhere.org> <20080715102130.GA22866@flint.arm.linux.org.uk> <20080715175740.GB10919@ldl.fc.hp.com> <20080715181632.GG14894@parisc-linux.org> <20080715184822.GB29991@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715184822.GB29991@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King <rmk+lkml@arm.linux.org.uk>:
> On Tue, Jul 15, 2008 at 12:16:32PM -0600, Matthew Wilcox wrote:
> > On Tue, Jul 15, 2008 at 11:57:40AM -0600, Alex Chiang wrote:
> > > My thought was that big SMP systems like ia64, possibly sparc and
> > > ppc, and increasingly, x86, might find something like this
> > > useful, as systems get larger and larger, and vendors are going
> > > to want to do RAS-ish features, like the ability to keep CPUs in
> > > firmware across reboots until told otherwise by the sysadmin.
> > > 
> > > Right now, a 'present' CPU strongly implies 'online' as well,
> > > since we're calling cpu_up() for all 'present' CPUs in
> > > smp_init(). But this hurts if:
> > > 
> > > 	- you don't actually want to bring up all 'present' CPUs
> > > 	- you still want to interact with these weirdo zombie
> > > 	  CPUs that are 'present' but not 'online'
> > 
> > Have you considered simply failing __cpu_up() for CPUs that are
> > deconfigured by firmware?
> 
> But what if you want to have a system boot with, say, 4 CPUs and
> then decide at run time to bring up another 4 CPUs when required?
> 
> How about having smp_init() call into arch code to query whether
> it should bring up a not-already-online CPU?  Architectures that
> want to do something special can then make the decision there and
> everyone else can define the test completely away.

So this is exactly what I'm doing. The ia64 patch has this hunk:

@@ -820,6 +824,9 @@ __cpu_up (unsigned int cpu)
        if (cpu_isset(cpu, cpu_callin_map))
                return -EINVAL;

+       if (!cpu_isset(cpu, cpu_enabled_map))
+               return -EINVAL;
+
        per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
        /* Processor goes to start_secondary(), sets online flag */
        ret = do_boot_cpu(sapicid, cpu);

That was the easiest, most-straightforward solution I could think
of. If you have an idea for a version with lower taxes (doesn't
touch all the archs or can be #define'd out), I'm happy to hear
it.

Thanks.

/ac

