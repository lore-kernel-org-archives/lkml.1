Return-Path: <linux-kernel-owner+w=401wt.eu-S1757145AbYGJVMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145AbYGJVMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 17:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbYGJVMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 17:12:01 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:46145 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYGJVMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 17:12:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, hpa@zytor.com,
       tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
       andi@firstfloor.org, jbarnes@virtuousgeek.org, steiner@sgi.com,
       linux-kernel@vger.kernel.org
References: <20080710181634.764954000@linux-os.sc.intel.com>
	<m1prplv71d.fsf@frodo.ebiederm.org> <20080710201801.GA6168@elte.hu>
Date: Thu, 10 Jul 2008 14:07:29 -0700
In-Reply-To: <20080710201801.GA6168@elte.hu> (Ingo Molnar's message of "Thu,
	10 Jul 2008 22:18:01 +0200")
Message-ID: <m1abgpqwha.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ingo Molnar <mingo@elte.hu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1732]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and x2apic support
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> A lot of your code is generic, and some of it is for just x86_64.  
>> Since the cpus are capable of running in 32bit mode.  We really need 
>> to implement x86_32 and x86_64 support in the same code base.  Which I 
>> believe means factoring out pieces of io_apic_N.c into things such as 
>> msi.c that can be shared between the two architectures.
>
> i think the APIC code should be fully unified down the line - the 
> APIC/IOAPIC knows little about the mode the CPU is running in and has to 
> be programmed the same way independent of which mode the CPU is in. The 
> current fork between the 32-bit and 64-bit APIC code is in good part 
> artificial.

I completely agree.  However
1) There is a fair amount of work involved in the unification so taking it in small pieces
   is good.
2) We are doing much more then we should in ioapic_N.c anyway.

So it makes sense to grab the pieces we are actively working on factor them out and unify them
first.

The basic model I expect will end up looking something like:
Type of cpu irq reception.  PIC mode, local APIC mode, ???? Virtualized modes????
Type of irq source.  ioapic, msi, htirq, ??? Virtualized source ????
Type of configuration mptable, acpi mps table.

Some of this we have split out today and nicely factored.  Other parts we don't.

In particular for setting up msi and ioapics we use exactly the same mapping
of bits.  So we describe things a little differently from the irq reception layer
to the irq sending layer we should be able to reuse exactly the same msi and ioapic code
instead of having their setup methods test for irq_remapping().

Eric
