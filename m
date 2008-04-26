Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbYDZQwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbYDZQwN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 12:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758571AbYDZQv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 12:51:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:37346 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758458AbYDZQv5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 12:51:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,711,1199692800"; 
   d="scan'208";a="275040875"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [git pull] x86 PAT changes
Date: Sat, 26 Apr 2008 09:54:23 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEEF313A6@orsmsx423.amr.corp.intel.com>
In-Reply-To: <20080426085600.GA5891@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [git pull] x86 PAT changes
Thread-Index: Acine5CZiVjqaTBBS7qMjEbYrSQMtwAQeiNg
References: <20080424225625.GB8717@elte.hu> <alpine.LFD.1.10.0804251351511.2779@woody.linux-foundation.org> <481271F4.7060401@zytor.com> <alpine.LFD.1.10.0804251808590.2813@woody.linux-foundation.org> <20080426085600.GA5891@elte.hu>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
X-OriginalArrivalTime: 26 Apr 2008 16:51:56.0937 (UTC) FILETIME=[D67F1790:01C8A7BD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org 
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Ingo Molnar
>Sent: Saturday, April 26, 2008 1:56 AM
>To: Linus Torvalds
>Cc: H. Peter Anvin; linux-kernel@vger.kernel.org; Andrew 
>Morton; Thomas Gleixner
>Subject: Re: [git pull] x86 PAT changes
>
>
>* Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> On Fri, 25 Apr 2008, H. Peter Anvin wrote:
>> > 
>> > The problem is that that can create cached/uncached aliases, which 
>> > can cause some processors to lock up (especially AMD is known to 
>> > have a lot of errata in this area.)
>> 
>> Umm.. I don't think you understand. Right now, NONPROMISC_DEVMEM 
>> doesn't just disable mmap() on /dev/mem, it disables totally regular 
>> reads and writes too. That seems pretty damn excessive.
>> 
>> If it was just mmap(), I don't think it would matter much. I don't 
>> think we traditionally even supported mmap() on real RAM 
>(because the 
>> page counting would get confused), and that actually got supported 
>> only thanks to VM changes that made it possible.
>> 
>> But read/write has always been supported, and shouldn't cause any 
>> cached/uncached aliases!
>
>You are right, there should be no architectural need to make PAT 
>dependent on nonpromisc-devmem, and thus the patch below 
>should be safe.
>

Agreed that NONPROMISC_DEVMEM is not really needed for read/write. But,
we will still need it for /dev/mem.

The problem with /dev/mem maps of RAM is situation like this:
1) drivers does vmalloc(), followed by set_memory_uc.
2) User does a /dev/mem map of that vmalloced physical address. User
will get a UC mapping for /dev/mem.
3) driver changes the memory to set_memory_wb and frees the memory.
4) user mapping for this address is still UC which will lead to
aliasing.

Read/write is ok, as they will just use __va for RAM to access and that
will always be consistent.

Thanks,
Venki
