Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbZD2Rqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbZD2Rqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 13:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbZD2Rqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 13:46:39 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45016 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbZD2Rqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 13:46:38 -0400
To: Gary Hade <garyhade@us.ibm.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, mingo@elte.hu, mingo@redhat.com,
       tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, lcm@us.ibm.com
Subject: Re: [PATCH 3/3] [BUGFIX] x86/x86_64: fix IRQ migration triggered active device IRQ interrruption
References: <20090408210745.GE11159@us.ibm.com>
	<86802c440904081503k545bf7b4n3d44aa3c9d101e0d@mail.gmail.com>
	<20090408230820.GA14412@us.ibm.com>
	<86802c440904102346lfbc85f2w4508bded0572ec58@mail.gmail.com>
	<20090413193717.GB8393@us.ibm.com> <m1bpr0e2au.fsf@fess.ebiederm.org>
	<20090428000536.GA7347@us.ibm.com> <m1bpqhjco7.fsf@fess.ebiederm.org>
	<20090429004451.GA7329@us.ibm.com> <m1eivc9qsn.fsf@fess.ebiederm.org>
	<20090429171719.GA7385@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 29 Apr 2009 10:46:29 -0700
In-Reply-To: <20090429171719.GA7385@us.ibm.com> (Gary Hade's message of "Wed\, 29 Apr 2009 10\:17\:19 -0700")
Message-ID: <m13abr2w0a.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: garyhade@us.ibm.com, lcm@us.ibm.com, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, mingo@elte.hu, yhlu.kernel@gmail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gary Hade <garyhade@us.ibm.com> writes:

>> > This didn't help.  Using 2.6.30-rc3 plus your patch both bugs
>> > are unfortunately still present.
>> 
>> You could offline the cpus?  I know when I tested it on my
>> laptop I could not offline the cpus.
>
> Eric, I'm sorry!  This was due to my stupid mistake.  When I
> went to apply your patch I included --dry-run to test it but
> apparently got distracted and never actually ran patch(1)
> without --dry-run. <SIGH>
>
> So, I just rebuilt after _really_ applying the patch and got
> the following result which probably to be what you intended.

Ok.  Good to see.

>> >> I propose detecting thpe cases that we know are safe to migrate in
>> >> process context, aka logical deliver with less than 8 cpus aka "flat"
>> >> routing mode and modifying the code so that those work in process
>> >> context and simply deny cpu hotplug in all of the rest of the cases.
>> >
>> > Humm, are you suggesting that CPU offlining/onlining would not
>> > be possible at all on systems with >8 logical CPUs (i.e. most
>> > of our systems) or would this just force users to separately
>> > migrate IRQ affinities away from a CPU (e.g. by shutting down
>> > the irqbalance daemon and writing to /proc/irq/<irq>/smp_affinity)
>> > before attempting to offline it?
>> 
>> A separate migration, for those hard to handle irqs.
>> 
>> The newest systems have iommus that irqs go through or are using MSIs
>> for the important irqs, and as such can be migrated in process
>> context.  So this is not a restriction for future systems.
>
> I understand your concerns but we need a solution for the
> earlier systems that does NOT remove or cripple the existing
> CPU hotplug functionality.  If you can come up with a way to
> retain CPU hotplug function while doing all IRQ migration in
> interrupt context I would certainly be willing to try to find
> some time to help test and debug your changes on our systems.

Well that is ultimately what I am looking towards.

How do we move to a system that works by design, instead of
one with design goals that are completely conflicting.

Thinking about it, we should be able to preemptively migrate
irqs in the hook I am using that denies cpu hotplug.

If they don't migrate after a short while I expect we should
still fail but that would relieve some of the pain, and certainly
prevent a non-working system.

There are little bits we can tweak like special casing irqs that
no-one is using.

My preference here is that I would rather deny cpu hotplug unplug than
have the non-working system problems that you have seen.

All of that said I have some questions about your hardware.
- How many sockets and how many cores do you have?
- How many irqs do you have?
- Do you have an iommu that irqs can go through?

If you have <= 8 cores this problem is totally solvable.

Other cases may be but I don't know what the tradeoffs are.
For very large systems we don't have enough irqs without
limiting running in physical flat mode which makes things
even more of a challenge.

It may also be that your ioapics don't have the bugs that
intel and amd ioapics have and we could have a way to recognize
high quality ioapics.

Eric
