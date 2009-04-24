Return-Path: <linux-kernel-owner+w=401wt.eu-S1759302AbZDXIlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302AbZDXIlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 04:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759087AbZDXIkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 04:40:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:3662 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759336AbZDXIks convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 04:40:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,240,1239001200"; 
   d="scan'208";a="684582922"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>
CC: "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>
Date: Fri, 24 Apr 2009 09:39:38 +0100
Subject: RE: [rfc 2/2] x86, bts: use physically non-contiguous trace buffer
Thread-Topic: [rfc 2/2] x86, bts: use physically non-contiguous trace buffer
Thread-Index: AcnEtxmvI5JbLj3VTOC8+hMAYB53XgAAC6FQ
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E9BA9BB93@irsmsx504.ger.corp.intel.com>
References: <20090424100055.A30408@sedona.ch.intel.com>
 <20090424011328.b5e949ce.akpm@linux-foundation.org>
 <20090424083128.GI24912@elte.hu>
In-Reply-To: <20090424083128.GI24912@elte.hu>
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
>From: Ingo Molnar [mailto:mingo@elte.hu]
>Sent: Friday, April 24, 2009 10:31 AM
>To: Andrew Morton
>Cc: Metzger, Markus T; a.p.zijlstra@chello.nl; markus.t.metzger@gmail.com; roland@redhat.com;
>eranian@googlemail.com; oleg@redhat.com; Villacis, Juan; ak@linux.jf.intel.com; linux-
>kernel@vger.kernel.org; tglx@linutronix.de; hpa@zytor.com
>Subject: Re: [rfc 2/2] x86, bts: use physically non-contiguous trace buffer
>
>
>* Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> On Fri, 24 Apr 2009 10:00:55 +0200 Markus Metzger <markus.t.metzger@intel.com> wrote:
>>
>> > Use vmalloc to allocate the branch trace buffer.
>> >
>> > Peter Zijlstra suggested to use vmalloc rather than kmalloc to
>> > allocate the potentially multi-page branch trace buffer.
>>
>> The changelog provides no reason for this change.  It should do so.
>>
>> > Is there a way to have vmalloc allocate a physically non-contiguous
>> > buffer for test purposes? Ideally, the memory area would have big
>> > holes in it with sensitive data in between so I would know immediately
>> > when this is overwritten.
>>
>> I suppose you could allocate the pages by hand and then vmap() them.
>> Allocating 2* the number you need and then freeing every second one
>> should make them physically holey.
>>
>> > --- a/arch/x86/kernel/ptrace.c
>> > +++ b/arch/x86/kernel/ptrace.c
>> > @@ -22,6 +22,7 @@
>> >  #include <linux/seccomp.h>
>> >  #include <linux/signal.h>
>> >  #include <linux/workqueue.h>
>> > +#include <linux/vmalloc.h>
>> >
>> >  #include <asm/uaccess.h>
>> >  #include <asm/pgtable.h>
>> > @@ -626,7 +627,7 @@ static int alloc_bts_buffer(struct bts_c
>> >  	if (err < 0)
>> >  		return err;
>> >
>> > -	buffer = kzalloc(size, GFP_KERNEL);
>> > +	buffer = vmalloc(size);
>> >  	if (!buffer)
>> >  		goto out_refund;
>> >
>> > @@ -646,7 +647,7 @@ static inline void free_bts_buffer(struc
>> >  	if (!context->buffer)
>> >  		return;
>> >
>> > -	kfree(context->buffer);
>> > +	vfree(context->buffer);
>> >  	context->buffer = NULL;
>> >
>>
>> The patch looks like a regression to me.  vmalloc memory is slower
>> to allocate, slower to free, slower to access and can exhaust or
>> fragment the vmalloc arena.  Confused.
>
>Performance does not matter here (this is really a slowpath), but
>fragmentation does matter, especially on 32-bit systems.
>
>I'd not uglify the code via vmap() - and vmap has the same
>fundamental address space limitations on 32-bit as vmalloc().
>
>The existing kmalloc() is fine. We do larger than PAGE_SIZE
>allocations elsewhere too (the kernel stack for example), and this
>is a debug facility, so failing the allocation is not a big problem
>even if it happens.

OK. I'll drop 2/2 and send out 1/2 as a patch, then.

The original suggestion was to use the page allocator and vmap().
I assume you don't want that, either.

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

