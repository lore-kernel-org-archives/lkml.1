Return-Path: <linux-kernel-owner+w=401wt.eu-S1759524AbYHBUXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524AbYHBUXT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 16:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755767AbYHBUXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 16:23:10 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:38233 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770AbYHBUXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 16:23:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
	<m1iqukwjjg.fsf@frodo.ebiederm.org>
	<86802c440808011430i6cf5cb8cn519777a78dd987b0@mail.gmail.com>
	<m1wsj0nyx6.fsf@frodo.ebiederm.org>
	<86802c440808011809t275aa511h4a1e9d70ede21702@mail.gmail.com>
	<m163qkjirc.fsf@frodo.ebiederm.org>
	<86802c440808011901w2aa40b25u45f5686b262cc2aa@mail.gmail.com>
	<4893C066.60401@zytor.com> <m1abfwi1ht.fsf@frodo.ebiederm.org>
	<4893D459.4030209@zytor.com> <m14p64gh81.fsf@frodo.ebiederm.org>
	<4894800F.40802@zytor.com>
Date: Sat, 02 Aug 2008 13:20:09 -0700
In-Reply-To: <4894800F.40802@zytor.com> (H. Peter Anvin's message of "Sat, 02
	Aug 2008 08:41:03 -0700")
Message-ID: <m11w17b24m.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 00/16] dyn_array and nr_irqs support v2
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>>
>> Yes.  I want the option of using those bits.  It might not be smart to
>> use them to encode a physical location and the irq number but just
>> having the option would be nice.
>>
>
> Urk!  First of all, there isn't enough space as we have already proven (on the
> machines where it actually matters there just aren't enough bits), but doing
> this kind of stuff *optionally* is going to hurt even worse.

With respect to space we have shown: We create many more irq_desc
entries then we use in practice.  Which hurts us when it comes to
pace.  Especially when compiling a single kernel for a wide range
of machines.

Which is why I ultimately want a list or a tree data structure holding
irq_desc entries instead of an array.  Arrays must be statically
oversized sized, waisting space and reducing our flexibility of
dealing with irqs at run time.

Which says to me the low level architecture code that actually knows
at run time how many irqs there are should do the allocation of
irq_desc entries and allocating them on the appropriate NUMA node.

All of which should yield no fixed cap short of 32 bits for the irq
number at run time.  Not having an arbitrarily low cap is what I mean
by having the option of a sparsely allocated irq number. If we have a
nice data structure that is a side effect that comes essentially for
free.

Except for upgrading the genirq code to pass things internally and to
the arch code in terms of irq_desc * entries.  This should be very little
change from where we are today.

> Furthermore, this crap will break anyway the *next* time someone comes up with a
> new clever way to do interrupts -- and to truly get stable identifiers, we can't
> treat HyperTransport MSI as APICs anymore, yadda, yadda...

Yes.  There are those kinds of issues.  I don't think I have yet come up with
a usable stable mapping for msi interrupts.  Just something close.

I expect what is most likely to work is after allocating the fixed irqs, to scan the
pci busses and for each for each pci device if msi is supported reserve 1 irq number.
If msi-X is supported reserve 4096 irq numbers.  If ht-irqs are supported reserve
1 irq for each irq number.  Hot plug slots that can ultimately have pci busses
plugged into them are going to be interesting.  But I think if we make an
effort msi irq numbers will stop flapping in the breeze and are likely to
remain the same, and fit in the number of bits we have.  While still not
requiring us to allocate storage for them.  Potentially we can even treat
GSIs the same way.  If we know that an ioapic line is simply not connected
we can reserve an irq number for it at boot but never allocate an irq_desc
structure for it.

What I mean by having the option to do a stable mapping is that we don't build
in unnecessary a priori limits to the maximum irq number.  Irq numbers have
always been sparsely allocated.  It was a rare ISA system that used all 16
of it's irqs.  It was an even rarer ioapic based system that used all of it's ioapic
inputs but we have always reserved irq numbers for all of those potential irqs.

So I ask to have a data structure that can potentially span the entire 32bit
range of irq numbers, and that instead of a dense and sparsely used array
we keep just the irq_desc entries that we need.

The only compile time options would be:  Has this architecture switched over
to a sparse irq array data structure.

Eric
