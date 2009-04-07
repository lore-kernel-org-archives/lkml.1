Return-Path: <linux-kernel-owner+w=401wt.eu-S1752485AbZDGIMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbZDGIMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 04:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbZDGIMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 04:12:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:15580 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbZDGIMP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 04:12:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,336,1235980800"; 
   d="scan'208";a="504228674"
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
Date: Tue, 7 Apr 2009 09:12:07 +0100
Subject: RE: [patch 03/20] x86, ptrace, bts: defer branch trace stopping
Thread-Topic: [patch 03/20] x86, ptrace, bts: defer branch trace stopping
Thread-Index: Acm1FkXE/DBYDZcnQUCVs4ekLabKXACP9+uQ
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E92768007@irsmsx504.ger.corp.intel.com>
References: <20090403144332.799740000@intel.com>
	 <20090403144550.712401000@intel.com> <1238770852.798.146.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77E9271853A@irsmsx504.ger.corp.intel.com>
 <1238843551.4549.1041.camel@laptop>
In-Reply-To: <1238843551.4549.1041.camel@laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl]
>Sent: Saturday, April 04, 2009 1:13 PM
>To: Metzger, Markus T
>Cc: mingo@elte.hu; tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com; roland@redhat.com;
>eranian@googlemail.com; oleg@redhat.com; Villacis, Juan; ak@linux.jf.intel.com; linux-
>kernel@vger.kernel.org; Andrew Morton
>Subject: RE: [patch 03/20] x86, ptrace, bts: defer branch trace stopping
>
>On Sat, 2009-04-04 at 08:17 +0100, Metzger, Markus T wrote:
>> >-----Original Message-----
>> >From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl]
>> >Sent: Friday, April 03, 2009 5:01 PM
>> >To: Metzger, Markus T
>>
>>
>> >Also, I can't say I like the name, what about something like:
>> >
>> >void account_locked_buffer(struct mm_struct *mm, long pages)
>> >{
>> >	down_write(&mm->mmap_sem);
>> >
>> >	mm->total_vm += pages;
>> >	mm->locked_vm += pages;
>> >
>> >	up_write(&mm->mmap_sem);
>> >}
>> >
>> >but looking more closely at that alloc_locked_buffer() stuff, I really
>> >hate it, who in his right mind does a multi-page kmalloc() -- that's
>> >crazy.
>>
>> I need a non-pageable chunk of memory to give to the cpu to store branch
>> trace data in. Kmalloc() is easy to use and gives me what I need.
>>
>> How would I do this correctly?
>
>Well, how large should this buffer be and must it be physically
>contiguous?

The size is set by the user. It is limited by (locked memory) RLIMIT.

The buffer need not be physically contiguous, but it must not be paged out
and should be marked accessed and dirty.
(see §18.7.8.2 in vol. 3b, Software Developer's Manual).

>Apparently its large enough to account in pages, that would suggest you
>should use the page allocator to get memory.

Wouldn't kmalloc forward the request to the page allocator for large memory?


>Furthermore, if it needs to be physically contiguous and its more than
>say 8 pages worth, you're basically up shit creek.

If not enough memory is available, I would expect users to request smaller
buffers until the request can be satisfied.


thanks and regards,
markus.
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

