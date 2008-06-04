Return-Path: <linux-kernel-owner+w=401wt.eu-S1757654AbYFDNso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654AbYFDNso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 09:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYFDNsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 09:48:37 -0400
Received: from relay2.sgi.com ([192.48.171.30]:38399 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752262AbYFDNsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 09:48:36 -0400
Message-ID: <48469D30.40901@sgi.com>
Date: Wed, 04 Jun 2008 06:48:32 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/4] x86_64: Fold pda into per cpu area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <20080604003019.509483000@polaris-admin.engr.sgi.com> <484691CB.6090809@goop.org>
In-Reply-To: <484691CB.6090809@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Mike Travis wrote:
>>   * Declare the pda as a per cpu variable.
>>
>>   * Make the x86_64 per cpu area start at zero.
>>
>>   * Since the pda is now the first element of the per_cpu area, cpu_pda()
>>     is no longer needed and per_cpu() can be used instead.  This also
>> makes
>>     the _cpu_pda[] table obsolete.
>>
>>   * Since %gs is pointing to the pda, it will then also point to the
>> per cpu
>>     variables and can be accessed thusly:
>>
>>     %gs:[&per_cpu_xxxx - __per_cpu_start]
>> 

  
The above is only a partial story (I folded the two patches but didn't
update the comments correctly.]  The variables are already offset from
__per_cpu_start by virtue of the .data.percpu section being based at
zero.  Therefore only the %gs register needs to be set to the base of
each cpu's percpu section to resolve the target address:

        %gs:&per_cpu_xxxx

And the .data.percpu.first forces the pda percpu variable to the front.


> 
> Unfortunately that doesn't actually work, because you can't have a reloc
> with two variables.
> 
> In something like:
> 
>     mov %gs:per_cpu__foo - 12345, %rax
>     mov %gs:per_cpu__foo, %rax
>     mov %gs:per_cpu__foo - 12345(%rip), %rax
>     mov %gs:per_cpu__foo(%rip), %rax
>     mov %gs:per_cpu__foo - __per_cpu_start, %rax
>     mov %gs:per_cpu__foo - __per_cpu_start(%rip), %rax
> 
> the last two lines will not assemble:
> 
> t.S:5: Error: can't resolve `per_cpu__foo' {*UND* section} -
> `__per_cpu_start' {*UND* section}
> t.S:6: Error: can't resolve `per_cpu__foo' {*UND* section} -
> `__per_cpu_start' {*UND* section}
> 
> Unfortunately, the only way I can think of fixing this is to compute the
> offset into a temp register, then use that:
> 
>     lea per_cpu__foo(%rip), %rax
>     mov %gs:__per_cpu_offset(%rax), %rax
> 
> (where __per_cpu_offset is defined in the linker script as
> -__per_cpu_start).
> 
> This seems to be a general problem with zero-offset per-cpu.  And its
> unfortunate, because no-register access to per-cpu variables is nice to
> have.
> 
> The other alternative - and I have no idea whether this is practical or
> possible - is to define  a complete set of pre-offset per_cpu symbols.
> 
>    J

