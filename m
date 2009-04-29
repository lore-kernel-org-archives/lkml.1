Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbZD2JOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbZD2JOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbZD2JOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:14:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:62695 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbZD2JOd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:14:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,265,1239001200"; 
   d="scan'208";a="452466731"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>
Date: Wed, 29 Apr 2009 10:14:27 +0100
Subject: RE: [rfc 2/2] x86, bts: use physically non-contiguous trace buffer
Thread-Topic: [rfc 2/2] x86, bts: use physically non-contiguous trace buffer
Thread-Index: AcnHJnBHgrrctlKsQqOeZg6J6YDEsABg2EaA
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E9BB6634C@irsmsx504.ger.corp.intel.com>
References: <20090424100055.A30408@sedona.ch.intel.com>
	 <20090424011328.b5e949ce.akpm@linux-foundation.org>
	 <20090424083128.GI24912@elte.hu> <1240829616.7620.7.camel@twins>
In-Reply-To: <1240829616.7620.7.camel@twins>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl]
>Sent: Monday, April 27, 2009 12:54 PM
>To: Ingo Molnar
>Cc: Andrew Morton; Metzger, Markus T; markus.t.metzger@gmail.com; roland@redhat.com;
>eranian@googlemail.com; oleg@redhat.com; Villacis, Juan; ak@linux.jf.intel.com; linux-
>kernel@vger.kernel.org; tglx@linutronix.de; hpa@zytor.com
>Subject: Re: [rfc 2/2] x86, bts: use physically non-contiguous trace buffer
>
>On Fri, 2009-04-24 at 10:31 +0200, Ingo Molnar wrote:
>> * Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>
>> > The patch looks like a regression to me.  vmalloc memory is slower
>> > to allocate, slower to free, slower to access and can exhaust or
>> > fragment the vmalloc arena.  Confused.
>>
>> Performance does not matter here (this is really a slowpath), but
>> fragmentation does matter, especially on 32-bit systems.
>>
>> I'd not uglify the code via vmap() - and vmap has the same
>> fundamental address space limitations on 32-bit as vmalloc().
>>
>> The existing kmalloc() is fine. We do larger than PAGE_SIZE
>> allocations elsewhere too (the kernel stack for example), and this
>> is a debug facility, so failing the allocation is not a big problem
>> even if it happens.
>
>Nobody has yet told what the typical size of these allocations are. If
>they're large enough to account in pages, one should arguable use the
>page allocator not kmalloc. Also, any >3 order allocation (>32kb) are
>very likely to fail. Having this ptrace interface work in the (unloaded)
>development environment but not in a (loaded) production environment
>will render it basically useless IMHO.

The size of these allocations is limited by the lockable memory ulimit
and debuggers typically need to divide this between multiple threads.

In practice, I would expect the buffers to be small. One page already
gives you ~170 entries and the most interesting part is the tail of
the trace, anyway.


>Having a regular high order allocation with vmalloc/vmap fallback is
>quite normal, esp. if one wants to promote the use of this facility as
>usable.
>
>So, no, I very strongly disagree that the existing kmalloc is fine.

I could add the vmalloc fallback. Is there already some function that
tries kmalloc and falls back to vmalloc which I should use?

thanks,
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

