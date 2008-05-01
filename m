Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbYEABT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbYEABT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 21:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbYEABTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 21:19:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:29026 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbYEABTS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 21:19:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,419,1204531200"; 
   d="scan'208";a="559171978"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Bugme-new] [Bug 10580] New: uvesafb is broken
Date: Wed, 30 Apr 2008 18:21:46 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEEF7D857@orsmsx423.amr.corp.intel.com>
In-Reply-To: <20080430163638.34855120.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Bugme-new] [Bug 10580] New: uvesafb is broken
Thread-Index: AcirGyPn/YhqFayRQAG6BalsR6N0IQADYkfw
References: <bug-10580-10286@http.bugzilla.kernel.org/> <20080430163638.34855120.akpm@linux-foundation.org>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       <francois.valenduc@tvcablenet.be>
Cc: <bugme-daemon@bugzilla.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
X-OriginalArrivalTime: 01 May 2008 01:19:14.0057 (UTC) FILETIME=[5E160790:01C8AB29]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Andrew Morton [mailto:akpm@linux-foundation.org] 
>Sent: Wednesday, April 30, 2008 4:37 PM
>To: francois.valenduc@tvcablenet.be
>Cc: bugme-daemon@bugzilla.kernel.org; Ingo Molnar; Pallipadi, 
>Venkatesh; linux-kernel@vger.kernel.org
>Subject: Re: [Bugme-new] [Bug 10580] New: uvesafb is broken
>
>> 
>> uvesafb doesn't work anymore with the current git version. 
>v86d failed with the
>> following error:
>> 
>> Program v86d tried to access /dev/mem between a0000->110000.
>> v86d[255]: segfault at 7f1025c22000 ip 400da6 sp 
>7fff2dc3e1d0 error 6 in
>> v86d[400000+17000]
>> uvesafb: Getting VBE info block failed (eax=0x4f00, err=-3)
>> uvesafb: vbe_init() failed with -22
>> uvesafb: probe of uvesafb.0 failed with error -22
>> 
>> After having tried git-bisect, it seems that the first bad 
>commit which might
>> cause the problem is the following:
>> 
>> commit e2beb3eae627211b67e456c53f946cede2ac10d7
>> Author: Venki Pallipadi <venkatesh.pallipadi@intel.com>
>> Date:   Thu Mar 6 23:01:47 2008 -0800
>> 
>>     devmem: add range_is_allowed() check to mmap of /dev/mem
>>
>> I have tried to revert it on the current git (git16) but 
>it's not possible to
>> do so.
>> 
>> Steps to reproduce:
>
>Thanks for the report - it really helps.
>
>Was you setting of CONFIG_NONPROMISC_DEVMEM the same in both 
>-git7 and in
>-git8?
>
>
------- Comment #4 From Venkatesh Pallipadi 2008-04-30 16:45:54 [reply]
------- 
>We have the range_is_allowed check with and without
CONFIG_NONPROMISC_DEVMEM
>now!
>
>It is needed to prevent PAT aliasing. Looks like, the driver or user
app is
>trying to map the range a0000->110000, and atleast part of that range
is
>usable memory.
> BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
> BIOS-e820: 0000000000100000 - 00000000bf6d0000 (usable)
>
>Thats the reason why mmap is failing.
>
>Now, we need to find who is mapping that memory and why. Looking at
uvesafb.c
>....

Looked at this a bit more..
v86d emulator seems to be hardcoding
mem_bios as 0x0a0000 - 0x10ffef

And mmaping the whole address and may be doing read write in that range
during the emulation.
But, as per e820 0x100000 onwards is usable memory and may be getting
used by kernel. So, surely there is some conflict here.

I am not sure whether it is the BIOS that is giving wrong E820 info or
is it the v86d emulator making assumption about this address wrongly.
One workaround is to make upto 0x10ffef as reserved and make kernel not
use it. But, we should really know why this problem is happening in the
first place, before going the workaround route.

Thanks,
Venki 
