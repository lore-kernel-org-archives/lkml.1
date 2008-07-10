Return-Path: <linux-kernel-owner+w=401wt.eu-S1760527AbYGJRsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760527AbYGJRsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbYGJRsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:48:22 -0400
Received: from gw.goop.org ([64.81.55.164]:35679 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755851AbYGJRsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:48:22 -0400
Message-ID: <48764B58.5040209@goop.org>
Date: Thu, 10 Jul 2008 10:48:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <20080709133958.612635f0@infradead.org>	<4875231F.1020506@zytor.com> <487524A0.6020304@goop.org>	<487529AE.3060505@zytor.com> <m1r6a2r9nj.fsf@frodo.ebiederm.org>	<48753A71.2030006@zytor.com> <m18wwahauq.fsf@frodo.ebiederm.org> <48763732.7020805@sgi.com> <487637DE.1050706@zytor.com> <48763A5E.7080105@linux-foundation.org> <48763B36.80104@zytor.com> <48763D1C.8040206@linux-foundation.org> <48764530.7000909@goop.org> <48764783.6030201@linux-foundation.org>
In-Reply-To: <48764783.6030201@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Jeremy Fitzhardinge wrote:
>   
>> The base address of the percpu area and the offsets from that base are
>> completely independent values.
>>     
>
> Definitely.
>
>
>   
>> The addressing modes:
>>
>>    * ABS
>>    * off(%rip)
>>
>> Are exactly equivalent in what offsets they can generate, so long as *at
>> link time* the percpu *symbols* are within 2G of the code addressing
>> them.  *After* the addressing mode has generated an effective address
>> (by whatever means it likes), the %gs: override applies the segment
>> base, which can therefore offset the effective address to anywhere at all.
>>     
>
> Right. The problem is with the percpu area handled by the linker. That percpu area is used by the boot cpu and later we setup other additional per cpu areas. Those can be placed in an arbitrary way if one goes through a table of pointers to these areas.
>   

Yes, but the offset is the same either way.  When you want a cpu to 
refer to its own percpu memory, regardless of where it is in memory, you 
just reload the gs base.  The offsets are the same everywhere, and are 
computed by the linker with out knowledge or reference to where the 
final address will end up.

In other words, at source level:

	a = x86_read_percpu(foo)

will generate

	mov %gs:percpu__foo, %rax

where the linker decides the value of percpu__foo, which can be up to 
4G.  Or if we use rip-relative:

	mov %gs:percpu__foo(%rip), %rax

we end up with the same result, except that the generated instruction is 
a bit more compact.

In the final generated assembly, it ends up being a hardcoded constant 
address.  Say, 0x7838.

Now if we allocate cpu 43 percpu data at 0xfffffffff7198000, we load %gs 
base with that value, and then the instruction is still

	mov %gs:0x7838, %rax

and the computed address will be 0xfffffffff7198000 + 0x7838 = 
0xfffffffff719f838.

And cpu 62 has its percpu data at 0xffffffffe3819000, and the 
instruction is still

	mov %gs:0x7838, %rax

and the computed address for it's version of percpu__foo is 
0xffffffffe3819000 + 0x7838 = 0xffffffffe3820838.

Note that it doesn't matter how you decide to place the percpu data, so 
long as you can load the address into the %gs base.

> However, that does not work if one calculates the virtual address instead of looking up a physical address.
>   

Calculate a virtual address for what?  Physical address for what?  If 
you have a large virtual region allocating 256M of percpu space, er, per 
cpu, then you just load %gs base with percpu_region_base + cpuid * 
256M.  It has no effect on the instructions accessing that percpu space.

    J
