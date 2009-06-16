Return-Path: <linux-kernel-owner+w=401wt.eu-S1762049AbZFPTim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762049AbZFPTim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761583AbZFPTic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:38:32 -0400
Received: from claw.goop.org ([74.207.240.146]:46070 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761268AbZFPTia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:38:30 -0400
Message-ID: <4A37F4AE.5050902@goop.org>
Date: Tue, 16 Jun 2009 12:38:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's
 no local APIC
References: <4A329CF8.4050502@goop.org> <m1d499yyug.fsf@fess.ebiederm.org>	<4A35ACB3.9040501@goop.org> <m1k53dbwo2.fsf@fess.ebiederm.org>	<4A36B3EC.7010004@goop.org> <m1fxe117n5.fsf@fess.ebiederm.org>
In-Reply-To: <m1fxe117n5.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/09 14:58, Eric W. Biederman wrote:
>>> The only clean way I can see to handle this is to make xen dom0 it's own
>>> weird separate subarch that does all of the table parsing of the
>>> firmware tables in completely separate code.  Then once we have something
>>> that works factoring out the commonalities into a helper library for
>>> better long term maintenance.
>>>
>>>        
>> That seems like overkill.  We can get things working under Xen with 3 changes:
>>      
>
> All of the subtle assumptions sound like the come out differently.  Which means
> you can very easily start down the road of just reusing small bits and then
> you find so many assumptions are different you have to scrap/replace or gunk
> up with if (xen) tests.
>    

I think we're getting off into the weeds a bit here.  I'm looking at 
other options of how to fit Xen interrupt handling into the kernel in a 
clean way; we may end up with a different model from the previous patch 
postings (not this particular one under discussion; the ones from last 
month).  We can reopen this discussion when I post those patches.

However, the kernel will still need information about the I/O APICs from 
ACPI so that it can perform basic interrupt routing for PCI devices (ie, 
regardless of how the interrupt gets delivered, and who programs the 
APIC hardware, we still need the basic information of "what io apic+pin 
is this PCI device connected to?").  This particular patch is my attempt 
to achieve this.

> To be very clear.  We have mechanism and policy mixed in the mptable
> and related code today.  While we continue to have that mixed I think
> even attempting to reuse it for Xen dom0 is a horrifically bad move.
>
> Nacked-by: "Eric W. Biederman"<ebiederm@xmission.com>
>    

The only effect of this patch is to parse the I/O APIC parts of the MADT 
even if it skips the local APIC parts; it causes no change in behaviour 
in normal circumstances (unless you actually have a physical machine 
with ACPI and I/O APICs but CPUs with no local APICs, which is guess is 
possible in principle).

Can you give an example of how mechanism and policy are mixed?  In what 
ways could it break?  Would you agree to a patch which attempts to 
decouple policy and mechanism to solve these problems?

     J
