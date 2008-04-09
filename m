Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbYDIXUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbYDIXUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 19:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbYDIXUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 19:20:40 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:38942 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432AbYDIXUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 19:20:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMFAHjs/EdMQWoK/2dsb2JhbACBXKsI
Date: Wed, 9 Apr 2008 19:15:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Adrian Bunk <bunk@stusta.de>, Alexey Dobriyan <adobriyan@gmail.com>,
       akpm@osdl.org
Subject: Re: [patch 13/17] Immediate Values - x86 Optimization (updated)
Message-ID: <20080409231534.GA7842@Krystal>
References: <20080409150829.855195878@polymtl.ca> <20080409152051.117322728@polymtl.ca> <47FD0497.10303@zytor.com> <20080409202106.GA1675@Krystal> <47FD4424.20907@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <47FD4424.20907@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:09:49 up 40 days, 19:20,  6 users,  load average: 0.42, 0.61,
	0.56
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
>> Hrm, since even the nmi-safe version supports REX-prefixed instructions,
>> there is no need for an =q constraint on single-byte immediate values
>> anymore. (thanks to your "discard" section used in the nmi-safe version)
>
> WRONG!
>
> Using =r for single-byte values is incorrect for 32-bit code -- that would 
> permit %spl, %bpl, %sil, %dil which are illegal in 32-bit mode. That is not 
> the incorrect bit, it's the description that is confused.
>
> 	-hpa

Ah, right. I remembered there was something that made us use =q, but
could not remember what. I'll describe it correctly.

Therefore, this updated patch is bogus. The original one was ok, given
that we change the header to :


Immediate Values - x86 Optimization

x86 optimization of the immediate values which uses a movl with code patching
to set/unset the value used to populate the register used as variable source.

Note : a movb needs to get its value froma =q constraint.

Quoting "H. Peter Anvin" <hpa@zytor.com>

Using =r for single-byte values is incorrect for 32-bit code -- that would  
permit %spl, %bpl, %sil, %dil which are illegal in 32-bit mode. 

Changelog:
- Use text_poke_early with cr0 WP save/restore to patch the bypass. We are doing
  non atomic writes to a code region only touched by us (nobody can execute it
  since we are protected by the imv_mutex).
- Put imv_set and _imv_set in the architecture independent header.
- Use $0 instead of %2 with (0) operand.
- Add x86_64 support, ready for i386+x86_64 -> x86 merge.
- Use asm-x86/asm.h.
- Bugfix : 8 bytes 64 bits immediate value was declared as "4 bytes" in the
  immediate structure.
- Change the immediate.c update code to support variable length opcodes.
- Vastly simplified, using a busy looping IPI with interrupts disabled.
  Does not protect against NMI nor MCE.
- Pack the __imv section. Use smallest types required for size (char).
- Use imv_* instead of immediate_*.


Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
