Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbYHWQrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbYHWQrY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 12:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbYHWQrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 12:47:17 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:44825 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbYHWQrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 12:47:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type;
	b=bKcYKCcF32/JUYFYb1mEq3EVa+Mx+iy/YIVb+9y8leoMaNGulrEoFzwYKO99Qn0RYn1brGCt4MyeDVl8aGI29GWPVMJ0pGZO/RNcWNRnaUVM3kDwH+/S1GZPbEyI3seq;
Message-ID: <48B03F0E.9060605@simon.arlott.org.uk>
Date: Sat, 23 Aug 2008 17:47:10 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Tyan S2923-E suspend to ram fails to resume
References: <48977AF7.2070300@simon.arlott.org.uk> <20080808071430.GA10370@ucw.cz> <21f16315cade48d9ecdc87a25b769b9f310fa112@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid> <489DACCE.7050000@simon.arlott.org.uk> <20080812103143.GD2641@elf.ucw.cz>
In-Reply-To: <20080812103143.GD2641@elf.ucw.cz>
Content-Type: multipart/mixed;
 boundary="------------080002090807010009080906"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080002090807010009080906
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/08/08 11:31, Pavel Machek wrote:
> On Sat 2008-08-09 15:42:22, Simon Arlott wrote:
>> On 08/08/08 12:20, Simon Arlott wrote:
>>> On Fri, August 8, 2008 08:14, Pavel Machek wrote:
>>>> On Mon 2008-08-04 22:56:07, Simon Arlott wrote:
>>>>> My system (Tyan S2923-E, dmesg attached) suspends ok in
>>>>> all pm_test modes, but it won't resume with pm_test
>>>>> "none".
>>>>>
>>>>> [    6.423515] mem full: hash matches
>>>>>
>>>>> When I press the power button, the port 80 display shows:
>>>>> FF D0 23 01 D0 ... DE
>>>>> (and again each time I press it)
>>>>>
>>>>> If I force it to turn off, then on again:
>>>>> FF D0 23 01 D0 ... FF D0 23 01 D0 ... (D2?) D3 00 01 D5
>>>>> D6 <normal boot>
>>>>>
>>>>> Any ideas? (onboard SAS is disabled, watchdog is
>>>>> disabled, everything else is enabled, PCI-E graphics
>>>>> card)
>>>>
>>>> Try verifying if it reaches assembly code under realmode/ ...
>>
>> I've tried acpi_sleep=s3_beep, and this:
>> diff --git a/arch/x86/kernel/acpi/realmode/wakeup.S b/arch/x86/kernel/acpi/realmode/wakeup.S
>> Which doesn't work either.
> 
> Yep, that should work. When it does not, it means BIOS is not
> returning to our real mode code :-(. You may want to try disabling
> APIC and similar stuff, in hope of working around BIOS bug you are
> hitting, but ...

I've tried the simplest possible 32-bit UP kernel I could come up 
with (.config attached) and it still doesn't work.

(I modified post_init() to call pm_suspend(PM_SUSPEND_MEM).)

Disassembly of the BIOS shows that DE is indeed part of 0xDEAD, 
but I haven't been able to tell what it's doing between D0 and 
there... not all of the port 80 codes that are displayed are 
easily visible.

I've tried disabling all the CPU options in the BIOS, e.g. microcode 
update, VM, NMI but it doesn't help. I'm wondering if D0 is the right 
start point for the system - there's a DC code for S3 resume:

AMI Checkpoint & Beep Code List 1.71:
> The Bootblock initialization code sets up the chipset, memory and other components
> before system memory is available. The following table describes the type of
> checkpoints that may occur during the bootblock initialization portion of the BIOS:
>
> Before D0: If boot block debugger is enabled, CPU cache-as-RAM functionality is
> enabled at this point. Stack will be enabled from this point.
>
> D0: Early Boot Strap Processor (BSP) initialization like microcode update,
> frequency and other CPU critical initialization. Early chipset initialization is
> done.
>
> D1: Early super I/O initialization is done including RTC and keyboard controller.
> Serial port is enabled at this point if needed for debugging. NMI is disabled.
> Perform keyboard controller BAT test. Save power-on CPUID value in scratch
> CMOS. Go to flat mode with 4GB limit and GA20 enabled.
>
> D2: Verify the boot block checksum. System will hang here if checksum is bad.
>
> D3: Disable CACHE before memory detection. Execute full memory sizing
> module. If memory sizing module not executed, start memory refresh and
> do memory sizing in Boot block code. Do additional chipset initialization.
> Re-enable CACHE. Verify that flat mode is enabled.
>
> D4: Test base 512KB memory. Adjust policies and cache first 8MB. Set stack.
>
> D5: Bootblock code is copied from ROM to lower system memory and control is
> given to it. BIOS now executes out of RAM. Copies compressed boot block
> code to memory in right segments. Copies BIOS from ROM to RAM for faster
> access. Performs main BIOS checksum and updates recovery status
> accordingly.
>
> D6: Both key sequence and OEM specific method is checked to determine if BIOS
> recovery is forced. If BIOS recovery is necessary, control flows to
> checkpoint E0. See Bootblock Recovery Code Checkpoints section of
> document for more information.
>
> D7: Restore CPUID value back into register. The Bootblock-Runtime interface
> module is moved to system memory and control is given to it. Determine
> whether to execute serial flash.
>
> D8: The Runtime module is uncompressed into memory. CPUID information is
> stored in memory.
>
> D9: Store the Uncompressed pointer for future use in PMM. Copying Main BIOS
> into memory. Leaves all RAM below 1MB Read-Write including E000 and
> F000 shadow areas but closing SMRAM.
>
> DA: Restore CPUID value back into register. Give control to BIOS POST
> (ExecutePOSTKernel). See POST Code Checkpoints section of document for
> more information.
>
> DC: System is waking from ACPI S3 state

-- 
Simon Arlott


--------------080002090807010009080906
Content-Type: application/x-bzip;
 name="config.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="config.bz2"

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
5dHQ
--------------080002090807010009080906--
