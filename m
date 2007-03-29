Return-Path: <linux-kernel-owner+w=401wt.eu-S1030650AbXC2UH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030650AbXC2UH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 16:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030657AbXC2UH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 16:07:26 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:5738 "EHLO
	outbound1-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030650AbXC2UHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 16:07:25 -0400
X-BigFish: VP
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Message-ID: <460C1B5B.4090802@amd.com>
Date: Thu, 29 Mar 2007 15:02:35 -0500
From: "Mark Langsdorf" <mark.langsdorf@amd.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: "Andi Kleen" <andi@firstfloor.org>
cc: "Len Brown" <lenb@kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Morrow, William" <William.Morrow@amd.com>,
       "Crouse, Jordan" <jordan.crouse@ldcmail.amd.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Pavel Machek" <pavel@ucw.cz>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Mingming Cao" <cmm@us.ibm.com>, "Adrian Bunk" <bunk@stusta.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>,
       "Oliver Pinter" <oliver.pntr@gmail.com>,
       "Sid Boyce" <g3vbv@blueyonder.co.uk>, "Nick Piggin" <npiggin@suse.de>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Renninger" <trenn@suse.de>
Subject: Re: [PATCH] i386: add command line option
 "local_apic_timer_c2_ok"
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703271430310.6730@woody.linux-foundation.org>
 <200703271816.33868.lenb@kernel.org>
 <200703272218.50531.lenb@kernel.org>
 <1449F58C868D8D4E9C72945771150BDFD967BB@SAUSEXMB1.amd.com>
 <p73d52s2dvi.fsf@bingen.suse.de>
In-Reply-To: <p73d52s2dvi.fsf@bingen.suse.de>
X-OriginalArrivalTime: 29 Mar 2007 20:03:34.0886 (UTC)
 FILETIME=[550D6060:01C7723D]
X-WSS-ID: 6A12C41D2EW2606376-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> "Langsdorf, Mark" <mark.langsdorf@amd.com> writes:
> 
>>>> If we really care about using the LAPIC timer on systems with deeper
>>>> than C1 support, the only alternative seems to be to test
>>>> if it actually works or not at boot and run-time.
>>>> Otherwise, we wait for future hardware with guaranteed
>>>> not to break under any (BIOS) conditions ships, and check for that.
>>>>
>>>> Based on what I read of the HP nx6325 where the LAPIC timer
>>>> is breaking C1, AMD is in the same boat.
>>> The nx6325 (Turion 64 X2) exports only C1.
>>> I'm not sure how the conclusion was drawn that it has
>>> a broken lapic timer as reflected in the "nolapic_timer" patch:
>> If both cores goes into C1 at the same time, the chipset
>> can move the processor into a C3 like state called C1e.
> 
> ... and that seems to break the local APIC timer.

Yes.  The APIC timer still runs, but no longer has an HT link
to send the signal on.

>> AMD can craft a patch to sort this out as soon as we have
>> an idea what the framework is going to look like.
> 
> Just a snippet to detect it would be great. Then the dmi scan
> could be removed and replaced with that. This would be a 2.6.21
> candidate imho over the DMI hack.

Reviewed but not tested.  Needs to be wrapped in an AMD specific
call.

#define ENABLE_C1E_MASK		0x18000000
#define CPUID_PROCESSOR_SIGNATURE	1
#define CPUID_XFAM		0x0ff00000
#define CPUID_XFAM_K8		0x00000000
#define CPUID_XFAM_10H		0x00100000
#define CPUID_XFAM_11H		0x00200000
#define CPUID_XMOD		0x000f0000
#define CPUID_XMOD_REV_F	0x00040000

	int safe_c1 = 1;
	u32 eax, lo, hi;
	eax = cpuid_eax(CPUID_PROCESSOR_SIGNATURE)
	switch (eax & CPUID_XFAM) {
	case CPUID_XFAM_K8:
		if ((eax & CPUID_XMOD) < CPUID_XMOD_REV_F)
			break;
	case CPUID_XFAM_10H:
	case CPUID_XFAM_11H:
		rdmsr(MSR_ENABLE_C1E, lo, hi);
		if (lo & ENABLE_C1E_MASK)
			safe_c1 = 0;
		break;
	default:
		/* err on the side of caution */
		safe_c1 = 0;
	}

-Mark Langsdorf
Operating Systems Research Center
AMD, Inc.


