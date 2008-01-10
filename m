Return-Path: <linux-kernel-owner+w=401wt.eu-S1758408AbYAJWYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408AbYAJWYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbYAJWYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:24:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:62495 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401AbYAJWYm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:24:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,268,1196668800"; 
   d="scan'208";a="283576143"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 02/11] PAT x86: Map only usable memory in x86_64 identity map and kernel text
Date: Thu, 10 Jan 2008 14:25:29 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE5A29A1@orsmsx423.amr.corp.intel.com>
In-Reply-To: <20080110211658.GA3145@one.firstfloor.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 02/11] PAT x86: Map only usable memory in x86_64 identity map and kernel text
Thread-Index: AchTzlQfIzGYJ6KRQ7KtAqKmmzRfRQABnJlw
References: <p737iiho5yq.fsf@bingen.suse.de> <924EFEDD5F540B4284297C4DC59F3DEE5A2805@orsmsx423.amr.corp.intel.com> <20080110192808.GF747@one.firstfloor.org> <924EFEDD5F540B4284297C4DC59F3DEE5A28CE@orsmsx423.amr.corp.intel.com> <20080110211658.GA3145@one.firstfloor.org>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: <ebiederm@xmission.com>, <rdreier@cisco.com>,
       <torvalds@linux-foundation.org>, <gregkh@suse.de>, <airlied@skynet.ie>,
       <davej@redhat.com>, <mingo@elte.hu>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
X-OriginalArrivalTime: 10 Jan 2008 22:24:38.0638 (UTC) FILETIME=[9665B0E0:01C853D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org 
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Andi Kleen
>Sent: Thursday, January 10, 2008 1:17 PM
>To: Pallipadi, Venkatesh
>Cc: Andi Kleen; ebiederm@xmission.com; rdreier@cisco.com; 
>torvalds@linux-foundation.org; gregkh@suse.de; 
>airlied@skynet.ie; davej@redhat.com; mingo@elte.hu; 
>tglx@linutronix.de; linux-kernel@vger.kernel.org; Siddha, Suresh B
>Subject: Re: [patch 02/11] PAT x86: Map only usable memory in 
>x86_64 identity map and kernel text
>
>> I think it is unsafe to access any reserved areas through 
>"WB" not just
>> mmio regions. In the above case 0xe0000000-0xf0000000 is one such
>> region.
>
>That is 2MB aligned.

That e820 also has a reserved here at 0x9d000.

 BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
 BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000cc000 - 00000000000d0000 (reserved)

If we keep mapping for such pages, it will be problematic as if a driver
later does a ioremap, then we have to go through split-pages and cpa.
With not mapping any reserved regions at all, we can avoid cpa for all
maps of reserved regions. Reducing the complications at setup will make
code more complicated at ioremap, etc.

Most of the holes/reserved areas will be 2M aligned, other than initial
2M and possible 2M around ACPI region. So, we may end up mapping some of
those pages with small pages. Even though it was not enforced until now,
I feel that is required for correctness.

>> >
>> >Exactly it's already broken.
>> >
>> >Anyways if someone accesses mmio through /dev/mem I think they 
>> >definitely
>> >want the real mappings, not a zero page.  And dev/mem 
>should provide.
>> >The trick is just to do it without caching attribute violations, 
>> >but with mattr it is possible.
>> 
>> I don't like /dev/mem supporting access to mmio. We do not know what
>
>But it always did that. I'm sure you'll break stuff if you forbid
>it suddenly.
>
>> attributes to use for these regions.  We can potentially map 
>all these
>> pages uncacheable. 
>
>That is what current /dev/mem does.

May be I am missing something. But, I don't think I saw /dev/mem
checking whether some region is reserved and mapping those pages as
uncacheable. As I though, its mostly done as MTRR has such setting. If I
do dd of devmem which ends up reading all reserved regions today, I see
one of my systems dying horribly with NMI dazed and confused and the
other gets SCSI errors etc. I am not sure how can some apps depend on
reading mmio regions through /dev/mem. Any particular app you are
thinking about?

>> But there may be cases where reading an address can
>> block too possibly?
>
>Yes sure, machine may hang, but that was always the case and I don't
>think it can be changed.
>
>> 
>> >> >Anyways you could make that a zillion times more simple by 
>> >> >just rounding
>> >> >the e820 areas to 2MB -- for the holes only that should be 
>> >ok I think; 
>> >> >i would expect them to be near always already suitably aligned.
>> >> >
>> >> >In short this can be all done much simpler.
>> >> 
>> >> On systems I tested, ACPI regions are typically not 2MB 
>> >aligned. And on
>> >
>> >ACPI regions don't need to be unmapped.
>> >
>> >> some systems there are few 4k pages of reserved holes just before
>> >
>> >reserved shouldn't be unmapped, just holes. Do they have holes
>> >there or reserved areas?
>> >
>> >I still hope 2MB alignment will work out.
>> 
>> E820 above has a combination of reserved and holes.
>> The problem is that we end up depending on specific e820s 
>and paltform
>> specific problems/workarounds. This is not a real problem for i386 at
>
>> all, as we map only < 1G memory there. 
>
>First there is the 2GB and in theory 1/3 GB split too which 
>are supported.
>And then in theory someone could put mmio in the first 1GB 
>anyways (e.g.
>in the 1MB hole) 
>
>I don't think you can ignore i386 here.
>

OK. I was thinking that we will have smaller subset of systems to worry
about with x86_64. With above, yes. We need to worry about i386 as well.

Other than the complicated code, do you see any issues of identity
mapping only "usable" and "ACPI" regions as per e820? We can possible
try to simplify the code, if that is the only concern.

Thanks,
Venki
