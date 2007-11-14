Return-Path: <linux-kernel-owner+w=401wt.eu-S1759308AbXKNOVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308AbXKNOVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 09:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbXKNOVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 09:21:39 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:43375 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752585AbXKNOVi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 09:21:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAKKSOkdMROHU/2dsb2JhbACBW450
Date: Wed, 14 Nov 2007 09:16:35 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 5/8] Immediate Values - x86 Optimization (update 2)
Message-ID: <20071114141635.GB22251@Krystal>
References: <20071113194550.GA4400@Krystal> <473A017D.2030501@zytor.com> <20071113204033.GB7450@Krystal> <473A166E.3070708@zytor.com> <20071113220227.GB9057@Krystal> <473A26A2.7090007@zytor.com> <20071114003409.GA18032@Krystal> <473A4909.1020609@zytor.com> <20071114014445.GB19901@Krystal> <473A6471.4040700@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <473A6471.4040700@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:51:32 up 10 days, 18:56,  5 users,  load average: 0.82, 0.98,
	1.23
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
>> Immediate Values - x86 Optimization
>> x86 optimization of the immediate values which uses a movl with code 
>> patching
>> to set/unset the value used to populate the register used as variable 
>> source.
>> Changelog:
>> - Use text_poke_early with cr0 WP save/restore to patch the bypass. We are 
>> doing
>>   non atomic writes to a code region only touched by us (nobody can 
>> execute it
>>   since we are protected by the immediate_mutex).
>> - Put immediate_set and _immediate_set in the architecture independent 
>> header.
>> - Use $0 instead of %2 with (0) operand.
>> - Add x86_64 support, ready for i386+x86_64 -> x86 merge.
>> - Use asm-x86/asm.h.
>> Ok, so the most flexible solution that I see, that should fit for both
>> i386 and x86_64 would be :
>> 1 byte  : "=Q" : Any register accessible as rh: a, b, c, and d.
>> 2, 4 bytes : "=R" : Legacy register—the eight integer registers 
>> available
>>                  on all i386 processors (a, b, c, d, si, di, bp, sp). 8
>> bytes : (only for x86_64)
>>           "=r" : A register operand is allowed provided that it is in a
>>                  general register.
>> That should make sure x86_64 won't try to use REX prefixed opcodes for
>> 1, 2 and 4 bytes values.
>
> I just had a couple of utterly sick ideas.
>
> Consider this variant (this example is for a 32-bit immediate on x86-64, 
> but the obvious macroizations apply):
>
> 	.section __discard,"a",@progbits
> 1:	movl $0x12345678,%r9d
> 2:
> 	.previous
>
> 	.section __immediate,"a",@progbits
> 	.quad foo_immediate, (3f)-4, 4
> 	.previous
> 	
> 	.org . + ((-.-(2b-1b)) & 3), 0x90
> 	movl $0x12345678,%r9d
> 3:
>
>
> The idea is that the instruction is emitted into a section, which is marked 
> DISCARD in the linker script.  That lets us actually measure the length, 
> and since we know the immediate is always at the end of the instruction... 
> done!
>

Wow! I like this idea. I'll give it a try in a test sandbox to see if
gas or ld complains. I'll keep you posted.

Mathieu

>


> 	-hpa
>

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
