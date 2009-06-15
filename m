Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbZFOCG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbZFOCG7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 22:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750935AbZFOCGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 22:06:52 -0400
Received: from claw.goop.org ([74.207.240.146]:46150 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbZFOCGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 22:06:51 -0400
Message-ID: <4A35ACB3.9040501@goop.org>
Date: Sun, 14 Jun 2009 19:06:43 -0700
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
References: <4A329CF8.4050502@goop.org> <m1d499yyug.fsf@fess.ebiederm.org>
In-Reply-To: <m1d499yyug.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/09 13:35, Eric W. Biederman wrote:
> Jeremy Fitzhardinge<jeremy@goop.org>  writes:
>
>    
>> Parse the ACPI MADT for I/O APIC information, even if the cpu has no
>> (apparent) local APIC (ie, the CPU's APIC feature flag is clear).
>>
>> In principle, the local APIC and the I/O APIC are distinct (but related)
>> components, which can be independently present.
>>
>> In practice this can happen in a Xen system, where the hypervisor has
>> full control over the local APICs, and delivers interrupts initiated by
>> the I/O APICs via Xen's event channel mechanism.
>>      
>
> Xen  is giving us a semi bogus acpi table?
>    

No, not really.  The guest is reading the real BIOS-provided ACPI 
tables, but Xen is clobbering the APIC feature in CPUID so the virtual 
CPU doesn't appear to have a usable local APIC.  Xen itself doesn't care 
very much about interrupt routing or ACPI, and doesn't make any attempt 
to read or parse the ACPI data itself (except for very basic things like 
the APIC addresses).
> What is the paravirt configuration model with Xen?  Is it documented
> somewhere?
>    

Not very well.  The basic idea is that Xen owns the local apics, and 
does things like vector allocation.  The guest kernel is responsible for 
asking for a vector, and doing the appropriate IO APIC programming, and 
binding that vector to an event channel.  The interrupt is then 
delivered via the normal event channel mechanism already in place to 
deal with all the other event types an unprivileged domain can get.

     J
