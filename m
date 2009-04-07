Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbZDGJMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbZDGJMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756314AbZDGJKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:10:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:7044 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756294AbZDGJKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:10:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,336,1235980800"; 
   d="scan'208";a="504241156"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 7 Apr 2009 10:09:50 +0100
Subject: RE: [patch 03/20] x86, ptrace, bts: defer branch trace stopping
Thread-Topic: [patch 03/20] x86, ptrace, bts: defer branch trace stopping
Thread-Index: Acm3WrzUpuqTReY7RRa3n4zjoB/UaAAAmQQw
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E927680A4@irsmsx504.ger.corp.intel.com>
References: <20090403144332.799740000@intel.com>
	 <20090403144550.712401000@intel.com> <1238770852.798.146.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77E9271853A@irsmsx504.ger.corp.intel.com>
	 <1238843551.4549.1041.camel@laptop>
	 <928CFBE8E7CB0040959E56B4EA41A77E92768007@irsmsx504.ger.corp.intel.com>
 <1239092961.798.5686.camel@twins>
In-Reply-To: <1239092961.798.5686.camel@twins>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n379Caqu014644

>-----Original Message-----
>From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl]
>Sent: Tuesday, April 07, 2009 10:29 AM
>To: Metzger, Markus T
>Cc: mingo@elte.hu; tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com; roland@redhat.com;
>eranian@googlemail.com; oleg@redhat.com; Villacis, Juan; ak@linux.jf.intel.com; linux-
>kernel@vger.kernel.org; Andrew Morton
>Subject: RE: [patch 03/20] x86, ptrace, bts: defer branch trace stopping
>
>On Tue, 2009-04-07 at 09:12 +0100, Metzger, Markus T wrote:
>> >-----Original Message-----
>> >From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl]
>> >Sent: Saturday, April 04, 2009 1:13 PM
>> >To: Metzger, Markus T
>> >Cc: mingo@elte.hu; tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com;
>roland@redhat.com;
>> >eranian@googlemail.com; oleg@redhat.com; Villacis, Juan; ak@linux.jf.intel..com; linux-
>> >kernel@vger.kernel.org; Andrew Morton
>> >Subject: RE: [patch 03/20] x86, ptrace, bts: defer branch trace stopping
>> >
>> >On Sat, 2009-04-04 at 08:17 +0100, Metzger, Markus T wrote:
>> >> >-----Original Message-----
>> >> >From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl]
>> >> >Sent: Friday, April 03, 2009 5:01 PM
>> >> >To: Metzger, Markus T
>> >>
>> >>
>> >> >Also, I can't say I like the name, what about something like:
>> >> >
>> >> >void account_locked_buffer(struct mm_struct *mm, long pages)
>> >> >{
>> >> >	down_write(&mm->mmap_sem);
>> >> >
>> >> >	mm->total_vm += pages;
>> >> >	mm->locked_vm += pages;
>> >> >
>> >> >	up_write(&mm->mmap_sem);
>> >> >}
>> >> >
>> >> >but looking more closely at that alloc_locked_buffer() stuff, I really
>> >> >hate it, who in his right mind does a multi-page kmalloc() -- that's
>> >> >crazy.
>> >>
>> >> I need a non-pageable chunk of memory to give to the cpu to store branch
>> >> trace data in. Kmalloc() is easy to use and gives me what I need.
>> >>
>> >> How would I do this correctly?
>> >
>> >Well, how large should this buffer be and must it be physically
>> >contiguous?
>>
>> The size is set by the user. It is limited by (locked memory) RLIMIT.
>>
>> The buffer need not be physically contiguous, but it must not be paged out
>> and should be marked accessed and dirty.
>> (see Â§18.7.8.2 in vol. 3b, Software Developer's Manual).
>
>The Intel one I presume?

Yes. For x86 Architecture.


>Ok, if you must mark the pages accessed and dirty you should get whole
>pages, otherwise you cannot make that promise on the ptes, right?

The feedback I got so far was that kmalloc'ed memory is OK to use
in that case.


>> >Apparently its large enough to account in pages, that would suggest you
>> >should use the page allocator to get memory.
>>
>> Wouldn't kmalloc forward the request to the page allocator for large memory?
>
>It may, but doesn't need to.
>
>> >Furthermore, if it needs to be physically contiguous and its more than
>> >say 8 pages worth, you're basically up shit creek.
>>
>> If not enough memory is available, I would expect users to request smaller
>> buffers until the request can be satisfied.
>
>Sounds like a very bad interface, esp since you don't need physically
>contiguous memory.
>
>So what you need to do is allocate pages, order-0, grab a reference,
>then vmap them into a linear piece, poke at the ptes to set the young
>and dirty bits and provide that to your hardware.

OK.

Would a simple vmalloc() do the job?
Looks like it uses PAGE_KERNEL which has the present, accessed, and dirty bits
set. It also does the page allocation and vmap() for me.

thanks,
markus.

---------------------------------------------------------------------Intel GmbHDornacher Strasse 185622 Feldkirchen/Muenchen GermanySitz der Gesellschaft: Feldkirchen bei MuenchenGeschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes SchwadererRegistergericht: Muenchen HRB 47456 Ust.-IdNr.VAT Registration No.: DE129385895Citibank Frankfurt (BLZ 502 109 00) 600119052
This e-mail and any attachments may contain confidential material forthe sole use of the intended recipient(s). Any review or distributionby others is strictly prohibited. If you are not the intendedrecipient, please contact the sender and delete all copies.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
