Return-Path: <linux-kernel-owner+w=401wt.eu-S934977AbXK3OnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934977AbXK3OnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 09:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758544AbXK3OnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 09:43:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757898AbXK3OnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 09:43:15 -0500
Date: Fri, 30 Nov 2007 09:42:50 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Ben Woodard <woodard@redhat.com>
Cc: Neil Horman <nhorman@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, hbabu@us.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on
	boot cpu
Message-ID: <20071130144250.GC23810@redhat.com>
References: <m1lk8jka8j.fsf@ebiederm.dsl.xmission.com> <474C64CB.7080004@redhat.com> <20071127194220.GG14887@hmsendeavour.rdu.redhat.com> <20071127200011.GA3703@redhat.com> <20071127222408.GH24223@one.firstfloor.org> <474CA733.9050908@redhat.com> <20071128153649.GC3192@redhat.com> <20071128160206.GA21286@hmsendeavour.rdu.redhat.com> <20071128190525.GD3192@redhat.com> <474F7177.7050306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474F7177.7050306@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[..]
>> Can you print the LAPIC registers (print_local_APIC) during normal boot
>> and during kdump boot and paste here?
>
> Here are the ones from a normal bootup.
>
> I was unable to get info from a kdump boot. I haven't figured out why yet. 
> With the same patch that I used to capture this, when I tried to kdump the 
> kernel, it paused a second or two after the backtrace and then dropped to 
> BIOS and came up normally.
>
> Here is a little trick, at the point where we are trying to get the info to 
> print out, the kernel command line hasn't been completely parsed yet. That 
> tricked me for part of the day. I had apic=debug on the command line but 
> the logic in print_local_APIC saw the default value because the kernel 
> command line had yet to be parsed.
>
> 2007-11-29 17:58:07 ***Here is the info you requested
> 2007-11-29 17:58:07
> 2007-11-29 17:58:07 printing local APIC contents on CPU#0/0:
> 2007-11-29 17:58:07 ... APIC ID:      00000000 (0)
> 2007-11-29 17:58:07 ... APIC VERSION: 80050010
> 2007-11-29 17:58:07 ... APIC TASKPRI: 00000000 (00)
> 2007-11-29 17:58:07 ... APIC ARBPRI: 00000000 (00)
> 2007-11-29 17:58:07 ... APIC PROCPRI: 00000000
> 2007-11-29 17:58:07 ... APIC EOI: 00000000
> 2007-11-29 17:58:07 ... APIC RRR: 00000002
> 2007-11-29 17:58:07 ... APIC LDR: 00000000
> 2007-11-29 17:58:07 ... APIC DFR: ffffffff
> 2007-11-29 17:58:07 ... APIC SPIV: 0000010f
> 2007-11-29 17:58:07 ... APIC ISR field:
> 2007-11-29 17:58:07 ... APIC TMR field:
> 2007-11-29 17:58:07 ... APIC IRR field:
> 2007-11-29 17:58:07 ... APIC ESR: 00000000
> 2007-11-29 17:58:07 ... APIC ICR: 00004630
> 2007-11-29 17:58:07 ... APIC ICR2: 07000000
> 2007-11-29 17:58:07 ... APIC LVTT: 00010000
> 2007-11-29 17:58:07 ... APIC LVTPC: 00010000
> 2007-11-29 17:58:07 ... APIC LVT0: 00000700

Ok so here boot cpu LVT0 has been set to deliver any interrupt on pin
LINT0 as ExtInt. We do the same thing for kdump cpu local apic too.

I am not sure who is the guy in system who encodes the interrupt message
from 8259 to be put on hypertransport and on what basis do they decide
whether it should go to only cpu0 or a broadcast one. Looks like in this
case it is going to cpu0 only. That means we are left with no choice but
to work on patch to initialize IOAPIC early.

Thanks
Vivek
