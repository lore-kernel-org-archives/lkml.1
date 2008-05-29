Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbYE2TOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbYE2TOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 15:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbYE2TOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 15:14:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:11318 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbYE2TOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 15:14:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FOG1UxiQ3M3Vkt8KkRIInqXcdLa6oWTPtXmv+HySSfhetFFgC67OrM1ioQlugQ8SidN+8yvf2jSwyiD0ztQsu1HyrMq1kVJSCBS0/jKeQozcED5j4LdBOyB88RdmQZEziqMTv/NqTIEa1IABcg4s4afTXjGN033/0CZfRveGYvI=
Message-ID: <86802c440805291214r50879732qc263b245985b4ba4@mail.gmail.com>
Date: Thu, 29 May 2008 12:14:20 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] x86: extend e820 ealy_res support 32bit - fix #2
Cc: "Rusty Russell" <rusty@rustcorp.com.au>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440805291152w1cdfa5feoac7c92bc2ecca9d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805110030.15510.yhlu.kernel@gmail.com>
	 <86802c440805271406l4348db33r5622c440b494baa2@mail.gmail.com>
	 <483C7BB0.6080901@goop.org>
	 <86802c440805271435l744eab84xe55ac9ce6196c03b@mail.gmail.com>
	 <483C8157.7080702@goop.org>
	 <86802c440805271552k724415a6i66686b9abb8c083f@mail.gmail.com>
	 <483D2D8A.5040800@goop.org>
	 <86802c440805281348u2fdd6ce2t71231f0fc94d8b5b@mail.gmail.com>
	 <483EB18F.4070105@goop.org>
	 <86802c440805291152w1cdfa5feoac7c92bc2ecca9d6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 11:52 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Thu, May 29, 2008 at 6:37 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>> Yinghai Lu wrote:
>>>
>>> can we use e820 entries for that? So the domain builder could have
>>> several entries for E820_RAM and E820_RESERVED...
>>>
>>
>> I tried this, but it doesn't work; the kernel crashes during boot,
>> presumably because it's trying to use the reserved memory as heap.  I
>> suspect the e820 maps are not registered early enough or something...
>>
>> (One thought: if reserving in the E820 map were enough, then couldn't we use
>> it for all the early reservations?)
>>
>> I've attached the non-working patch below.
>>
>> The working kernel reports:
>>
>> (early) BIOS-provided physical RAM map:
>> (early)  Xen: 0000000000000000 - 000000000009f000 (usable)
>> (early)  Xen: 0000000000100000 - 0000000010000000 (usable)
>> (early) console [xenboot0] enabled
>> (early) debug: ignoring loglevel setting.
>> (early) 0MB HIGHMEM available.
>> (early) 256MB LOWMEM available.
>> (early)   low ram: 018fd000 - 10000000
>> (early)   bootmap 018fd000 - 018ff000
>> (early)   early res: 0 [0-fff] BIOS data page
>> (early)   early res: 1 [1000-1fff] EX TRAMPOLINE
>> (early)   early res: 2 [6000-6fff] TRAMPOLINE
>> (early)   early res: 3 [18aa000-18ecfff] XEN
>> (early)   early res: 4 [1000000-18a9303] TEXT DATA BSS
>> (early)   early res: 5 [18ed000-18fcfff] INIT_PG_TABLE
>> (early)   early res: 6 [18fd000-18fefff] BOOTMAP
>>
>> But the non-working one says:
>>
>> (early) BIOS-provided physical RAM map:
>> (early)  Xen: 0000000000000000 - 000000000009f000 (usable)
>> (early)  Xen: 0000000000100000 - 0000000010000000 (usable)
>> (early)  Xen: 00000000018aa000 - 00000000018ed000 (reserved)
>
> it seems we miss to call sanitize_e820_map for 32 bit. we should get
> (early)  Xen: 0000000000000000 - 000000000009f000 (usable)
> (early)  Xen: 0000000000100000 - 00000000018aa000 (usable)
> (early)  Xen: 00000000018aa000 - 00000000018ed000 (reserved)
> (early)  Xen: 00000000018ed000 - 0000000010000000 (usable)

xen pv override the memory_setup. and default one is
machine_specific_memory_setup(), and it does call sanitize_e820_map...

so you may need to add sanitize_e820_map to xen_memory_setup, or re
arrange your add_memory_range parameter...

YH
