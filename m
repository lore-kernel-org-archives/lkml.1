Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbYLPKQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbYLPKQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 05:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbYLPKQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 05:16:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53113 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbYLPKQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 05:16:08 -0500
Date: Tue, 16 Dec 2008 11:15:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ken Chen <kenchen@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] x86: convert rdtscll() to use __native_read_tsc
Message-ID: <20081216101551.GA27481@elte.hu>
References: <b040c32a0812160032pf681f13s9e5e86c4b5448012@mail.gmail.com> <20081216091509.GA29872@elte.hu> <49477452.6030307@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49477452.6030307@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> The reason for the __native_read_tsc() / native_read_tsc() distinction 
>> is and obscure problem with paravirt function pointers. Such 
>> constructs:
>>
>>   ./xen/enlighten.c:	.read_tsc = native_read_tsc,
>>
>> do not always work fine with all versions of gcc, if native_read_tsc() 
>> is a simple static inline (as it should be) - the build would fail with 
>> certain gcc flags.
>
> I don't think that's true.  We rely on taking function pointers of 
> static inlines pretty extensively; native_read_tsc is hardly unique in 
> this respect.  I don't remember seeing any problems of the sort you 
> describe.  (I can well believe this may have been a problem at some 
> point, but not during the pv-ops development timeframe.)

i do remember build and boot failures there - with weird combos of gcc 
options. It's a clear GCC bug. Anyway, we can clean this up and we'll see 
how relevant the failure modes are.

>> Perhaps the real fix is to do this rename as well:
>>
>>     native_read_tsc => native_read_tsc_paravirt
>>   __native_read_tsc => native_read_tsc
>>
>> as this makes the native_read_tsc_paravirt() a pure technical variant, 
>> to be used in paravirt_ops function pointer assignments. People would 
>> thus just use the obvious native_read_tsc() inline function most of the 
>> time and could forget about native_read_tsc_paravirt().
>>
>> Jeremy?
>
> I'm trying to remember the real reason for 
> __native_read_tsc/native_read_tsc.  At least part of it is that 
> __native_read_tsc is used in a vdso, and so *must* be inlined to avoid a 
> bogus call from user to kernel space.  But I don't know why you wouldn't 
> want to inline native_read_tsc everywhere.  I have a feeling it may be a 
> relic from unification - possibly because x86-64 was late to the 
> clocksource party - but I don't remember anything specific.
>
> I think we can probably make do with a single native_read_tsc, so long 
> as its always inlined.

agreed mostly, with this twist: vdso inlining dependencies should be 
expressed explicitly, via:

  native_vread_tsc()

but we can also make native_read_tsc() __always_inline [it's a single 
instruction with basically no preparatory halo around that instruction] 
and document the vdso detail there.

	Ingo
