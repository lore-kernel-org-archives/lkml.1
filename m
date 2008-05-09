Return-Path: <linux-kernel-owner+w=401wt.eu-S1763417AbYEINnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763417AbYEINnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 09:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbYEINnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 09:43:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:58006 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbYEINnb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 09:43:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,460,1204531200"; 
   d="scan'208";a="326340759"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with	xf86MapVidMem error
Date: Fri, 9 May 2008 06:46:06 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE01046D96@orsmsx423.amr.corp.intel.com>
In-reply-to: <4823A059.1090400@zytor.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with	xf86MapVidMem error
Thread-Index: AcixbxEhwcw2PDEKQV6nLXsZrC1qrAAaQfLg
References: <924EFEDD5F540B4284297C4DC59F3DEE010057B4@orsmsx423.amr.corp.intel.com> <4822A6F7.7010704@numericable.fr> <B5B0CFF685D7DF46A05CF1678CFB42ED20E04609@orsmsx423.amr.corp.intel.com> <20080508192555.GA8643@linux-os.sc.intel.com> <48235DA1.5060809@numericable.fr> <20080508213722.GA28372@linux-os.sc.intel.com> <482373C5.1060202@zytor.com> <20080508215931.GA5035@jamoon.sc.intel.com> <20080508234016.GA14169@linux-os.sc.intel.com> <482392C4.7080901@zytor.com> <20080509003424.GA19710@linux-os.sc.intel.com> <4823A059.1090400@zytor.com>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rufus & Azrael" <rufus-azrael@numericable.fr>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
X-OriginalArrivalTime: 09 May 2008 13:43:29.0669 (UTC) FILETIME=[AA35AB50:01C8B1DA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: H. Peter Anvin [mailto:hpa@zytor.com] 
>Sent: Thursday, May 08, 2008 5:53 PM
>To: Pallipadi, Venkatesh
>Cc: Rufus & Azrael; Ingo Molnar; Siddha, Suresh B; 
>Linux-kernel Mailing List; Yinghai Lu; Thomas Gleixner
>Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with 
>xf86MapVidMem error
>
>Venki Pallipadi wrote:
>> 
>> One of the reason for heristic was to get proper type for 
>/dev/mem maps for WB
>> region (ACPI and BIOS area). /dev/mem checks to see the mtrr 
>type of the start
>> address and starts with that type for the request. As long 
>as there are no
>> other conflict in PAT list, we can give WB to this /dev/mem 
>request. Not
>> having this heuristic we will have to most probably default to UC.
>> 
>> When there are overlapping PAT list entries, the mtrr_lookup 
>does not matter
>> as we have to inherit things from those PAT entries or 
>conflicting with them.
>> 
>
>Okay, now here is something...
>
>I don't believe it is kosher for mmap() to behave differently if we 
>called it once or called it twice.

May be I am missing something. Only time mmap will behave differently is
when some of the pre-existing conditions are different. If the MTRRs are
different and/or there has been conflicting mapping in between first and
second mmap. Otherwise, it will be same. We had to do this inheriting
Business if there are other conflicting maps to have compatibility with
All existing /dev/mem users.

>Therefore, the proper behaviour in the case of a range that covers 
>multiple types is to break it down into multiple requests each mapped 
>with the appropriate type, as if mmap had been called separate on each 
>subrange.  In the limiting case, yes, this does mean the subranges can 
>be individual pages, but such an outcome is vanishingly improbable in 
>practice.

We thought about splitting the range. But, in general the interface
requires
us to give one single type of access back. Interfaces like pci accesses
in /sysfs. If user maps the file with mmap, we give one particular type
of mapping.
returning multi type may be a possibility, but that will mean whole new
level of complications in tracking, splitting the vmas, returning this
subrange mapping info to user in some way etc.

Sub-range of a page is probably improbable. But overlaps are common.
That is exactly what is happening with the issue in this thread.
Part of the region is mmaped first (it will get UC_MINUS) and MTRR setup
for WC.
Later a bigger region that includes the first smaller part is being
mmaped. We can
safely return UC_MINUS to this bigger request (without causing any
aliases) and things
will work fine as this bigger mmap does its own MTRR for WC as well.
This is the case
where I feel just maintaining the consistency across the PAT list (which
is UC_MINUS)
here is safe irrespective of any MTRR setting we may have underneath.
Worrying about
MTRR ranges here doesn't seem to add any additional safety-ness.

Thanks,
Venki


