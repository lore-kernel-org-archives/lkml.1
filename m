Return-Path: <linux-kernel-owner+w=401wt.eu-S1752095AbYHREjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbYHREjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 00:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbYHREjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 00:39:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33883 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbYHREjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 00:39:07 -0400
Message-ID: <48A8FC21.9060908@zytor.com>
Date: Sun, 17 Aug 2008 21:35:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: David Fries <david@fries.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix i486 suspend to disk CR4 oops
References: <20080818040340.GB17528@spacedout.fries.net> <Pine.LNX.4.55.0808180510480.26857@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0808180510480.26857@cliff.in.clinika.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
> On Sun, 17 Aug 2008, David Fries wrote:
> 
>> arch/x86/power/cpu_32.c __save_processor_state calls read_cr4()
>> only a i486 CPU doesn't have the CR4 register.  Trying to read it
>> produces an invalid opcode oops during suspend to disk.
> [...]
>> diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
>> index 81e5ab6..bd0f2a3 100644
>> --- a/arch/x86/kernel/acpi/sleep.c
>> +++ b/arch/x86/kernel/acpi/sleep.c
>> @@ -86,7 +86,9 @@ int acpi_save_state_mem(void)
>>  #endif /* !CONFIG_64BIT */
>>  
>>  	header->pmode_cr0 = read_cr0();
>> -	header->pmode_cr4 = read_cr4();
>> +	/* cr4 was introduced in the Pentium CPU */
>> +	if (boot_cpu_data.x86 >= 5)
>> +		header->pmode_cr4 = read_cr4();
>>  	header->realmode_flags = acpi_realmode_flags;
>>  	header->real_magic = 0x12345678;
>>  
> 
>  NACK.  Later i486 chips do have CR4 -- for PSE, VME, etc. (the set of
> features varies across the line).  Use a fixup as elsewhere or something.
> 

The other alternative is to probe for the CPUID instruction (via 
EFLAGS.ID) -- CR4 is present if and only if CPUID exists.

	-hpa
