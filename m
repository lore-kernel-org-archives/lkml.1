Return-Path: <linux-kernel-owner+w=401wt.eu-S1758624AbYAJUvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624AbYAJUvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 15:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758196AbYAJUv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 15:51:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:59333 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758165AbYAJUv2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 15:51:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,267,1196668800"; 
   d="scan'208";a="493691116"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 02/11] PAT x86: Map only usable memory in x86_64 identity map and kernel text
Date: Thu, 10 Jan 2008 12:50:55 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE5A28CE@orsmsx423.amr.corp.intel.com>
In-Reply-To: <20080110192808.GF747@one.firstfloor.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 02/11] PAT x86: Map only usable memory in x86_64 identity map and kernel text
Thread-Index: AchTvwTpMTRDPpyWSLWwGRDST98cAAACTmbg
References: <p737iiho5yq.fsf@bingen.suse.de> <924EFEDD5F540B4284297C4DC59F3DEE5A2805@orsmsx423.amr.corp.intel.com> <20080110192808.GF747@one.firstfloor.org>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: <ebiederm@xmission.com>, <rdreier@cisco.com>,
       <torvalds@linux-foundation.org>, <gregkh@suse.de>, <airlied@skynet.ie>,
       <davej@redhat.com>, <mingo@elte.hu>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
X-OriginalArrivalTime: 10 Jan 2008 20:50:01.0898 (UTC) FILETIME=[5ECBE8A0:01C853CA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Andi Kleen [mailto:andi@firstfloor.org] 
>Sent: Thursday, January 10, 2008 11:28 AM
>To: Pallipadi, Venkatesh
>Cc: Andi Kleen; ebiederm@xmission.com; rdreier@cisco.com; 
>torvalds@linux-foundation.org; gregkh@suse.de; 
>airlied@skynet.ie; davej@redhat.com; mingo@elte.hu; 
>tglx@linutronix.de; hpa@zytor.co; 
>linux-kernel@vger.kernel.org; Siddha, Suresh B
>Subject: Re: [patch 02/11] PAT x86: Map only usable memory in 
>x86_64 identity map and kernel text
>
>On Thu, Jan 10, 2008 at 11:17:07AM -0800, Pallipadi, Venkatesh wrote:
>> >I don't think that is needed or makes sense for 
>reserved/ACPI * etc. 
>> >Only e820 holes should be truly unmapped because only those should
>> >contain mmio.
>> 
>> Do you mean just the regions that are not listed in e820 at all? We
>> should also not map anything marked "RESERVED" in e820. Right?
>
>RESERVED is usually memory used by the BIOS. Properly MMIO areas
>should be in holes.
>
>Of course there might be buggy BIOS who violate that but the
>only way to find out is to check for the case in ioremap and 
>warn. I would
>be still optimistic of it being correct.
>
>Another way would be to double check against the MTRRs - if 
>it's UC then
>it should be unmapped. Maybe that would be a good idea. That should
>catch all true mmio holes unless a BIOS maps them cached but if it does
>that it's already beyond help.

One of the test systems I have has following E820
 BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
 BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000cc000 - 00000000000d0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cff60000 (usable)
 BIOS-e820: 00000000cff60000 - 00000000cff69000 (ACPI data)
 BIOS-e820: 00000000cff69000 - 00000000cff80000 (ACPI NVS)
 BIOS-e820: 00000000cff80000 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000130000000 (usable)

I think it is unsafe to access any reserved areas through "WB" not just
mmio regions. In the above case 0xe0000000-0xf0000000 is one such
region.

Also, relying on MTRR, is like giving more importance to BIOS writer
than required :-). I think the best way to deal with MTRR is just to not
touch it. Leave it as it is and do not try to assume that they are
correct, as frequently they will not be.

>> >> All reserved memory maps to a
>> >> zero page. 
>> >
>> >Why zero page?  Why not unmap.
>> 
>> I had it unmapped first. Then thought of zero mapping for dd 
>of devmem
>> to continue working. May be there are apps that depend on that?
>> Also, dd of devmem seems to be already broken with big memory without
>> any of these changes.
>
>Exactly it's already broken.
>
>Anyways if someone accesses mmio through /dev/mem I think they 
>definitely
>want the real mappings, not a zero page.  And dev/mem should provide.
>The trick is just to do it without caching attribute violations, 
>but with mattr it is possible.

I don't like /dev/mem supporting access to mmio. We do not know what
attributes to use for these regions. We can potentially map all these
pages uncacheable. But there may be cases where reading an address can
block too possibly?

>> >Anyways you could make that a zillion times more simple by 
>> >just rounding
>> >the e820 areas to 2MB -- for the holes only that should be 
>ok I think; 
>> >i would expect them to be near always already suitably aligned.
>> >
>> >In short this can be all done much simpler.
>> 
>> On systems I tested, ACPI regions are typically not 2MB 
>aligned. And on
>
>ACPI regions don't need to be unmapped.
>
>> some systems there are few 4k pages of reserved holes just before
>
>reserved shouldn't be unmapped, just holes. Do they have holes
>there or reserved areas?
>
>I still hope 2MB alignment will work out.

E820 above has a combination of reserved and holes.
The problem is that we end up depending on specific e820s and paltform
specific problems/workarounds. This is not a real problem for i386 at
all, as we map only < 1G memory there. So, it is limited to x86_64
systems which should be less in number.

Thanks,
Venki 
