Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbZAZJN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbZAZJN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 04:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbZAZJNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 04:13:41 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:3253 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbZAZJNk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 04:13:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=VURvlUOt9cSvFIBRtx4GsM0LAyEsPg4XUGMEv7bEYQVm2P6flUQ8D1tLzIdz2CQin7
         RVVF/HmhZct3nwogu0EW37LaXHp/ZJJ1OMLYYgIqLnrHnMUBD483V35D33uYXbNrCA+y
         MWQA1OiYIFzxIk9oeeZVzqtBIqVW5i8OS2Z2Y=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <497D0C81.5040406@linux.vnet.ibm.com>
References: <20090121185021.GA8852@elte.hu>
	 <497D0C81.5040406@linux.vnet.ibm.com>
Date: Mon, 26 Jan 2009 10:13:37 +0100
Message-ID: <7c86c4470901260113r4db6b15cpa0fa88ab3f8a516c@mail.gmail.com>
Subject: Re: [announce] Performance Counters for Linux, v6
From: stephane eranian <eranian@googlemail.com>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>,
       "perfmon2-devel@lists.sourceforge.net" 
	<perfmon2-devel@lists.sourceforge.net>,
       Papi <ptools-perfapi@cs.utk.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Corey brings up an interesting problem which I wanted to comment on.

The current proposal hinges on the idea that by interpreting a single
value the kernel
can understand what the user wants to measure. For instance, if I pass
type=0, then
the kernel understands I want to measure CPU_CYCLES. Given that the number of
events and their unit mask combinations can be large, the proposal also provides
a "raw" mode, where the content of the type field is interpreted as
the raw value to
put into a register.

This is where there is an issue because with several PMU models,
including on X86, using
the raw bit + 64 value is not enough to figure out what the user wants
to measure. This happens
when the PMU has more than counters. Thus, interpreting each raw value
has the event code
may be wrong. To remain on familiar territory, the Nehalem uncore PMU
has an opcode matcher register,
that uses a 64-bit value. On AMD64 Family 10h, you have IBS. But I
could give examples on
Itanium with opcode matchers, range restrictions. Corey provided other
examples for Power.
The API has to provide a way to express what the raw value is meant
for: counter, matcher, filter...

There are PMU where programming an event requires writing two config
registers. This is the case
for all Netburst-based processors where you have to program CCCR and
ESCR. I wonder how,
raw mode is supported for those processors. What if a PMU requires
three registers to be programmed?


On Mon, Jan 26, 2009 at 2:06 AM, Corey Ashford
<cjashfor@linux.vnet.ibm.com> wrote:
> Ingo Molnar wrote:
>>
>> We are pleased to announce version 6 of our performance counters subsystem
>> implementation. The shortlog, diffstat and the combo patch can be found
>> below. The combo patch against latest -git (2.6.29-rc2) can be also found
>> at:
>>
>>
>> http://people.redhat.com/mingo/perfcounters/perfcounters-v6-v2.6.29-rc2.patch
>>
>> It's also available in tip/master at:
>>
>>   http://people.redhat.com/mingo/tip.git/README
>>
>> There are many changes in the v6 release:
>>
>>  - PowerPC performance counters support from Paul Mackerras, for POWER6
>>   and for the PPC970 family.
>>
>>  - ioctl API to disable/enable individual counters and groups without
>>   closing their fd. This can be useful for libraries, ad-hoc
>> instrumentation and PAPI support.
>>
>>  - 'pinned' and 'exclusive' counter attributes - for those
>>   applications that want to influence counter scheduling explicitly.
>>
>>  - The 'perfstat' utility (ex 'timec') has been updated:
>>
>>      http://people.redhat.com/mingo/perfcounters/perfstat.c
>>
>>  - 'kerneltop' (easy-to-use text mode NMI profiler) has been updated:
>>        http://people.redhat.com/mingo/perfcounters/kerneltop.c
>>
>>  - Merged to latest mainline
>>
>>  - Various fixes and other updates
>>
>>        Ingo
>
> Hi Ingo,
>
> Looking over the latest capabilities of this proposal, I am wondering how it
> can accommodate performance monitor units which have extra registers which
> require user-defined data to be loaded into them.
>
> For example, on the Power architecture, there is an Instruction Matching
> Register which allows the counting of particular instructions. Currently,
> this is unsupported in perfmon2/3, but we have plans to add it, and it's
> pretty straight-forward to imagine how this would be done in perfmon.
>
> But I don't see an obvious way to do it with your proposal.  Do you have any
> ideas how Performance Counters for Linux could accommodate this sort of PMU
> functionality?
>
> One thought would be to change the event code to an event descriptor
> structure, which has room for lots of bits, including arch-defined bits (in
> the case of Power, an IMR value, and others).  This might also be a way to
> accommodate unit masks (and enums) as well, which Andi Kleen pointed out as
> an issue in an earlier LKML posting.
>
> Regards,
>
> - Corey
>
> Corey Ashford
> Software Engineer
> IBM Linux Technology Center, Linux Toolchain
> Beaverton, OR
> 503-578-3507
> cjashfor@us.ibm.com
>
>
