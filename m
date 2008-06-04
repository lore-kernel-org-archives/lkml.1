Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbYFDNAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbYFDNAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 09:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbYFDNAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 09:00:37 -0400
Received: from gw.goop.org ([64.81.55.164]:43818 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbYFDNAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 09:00:36 -0400
Message-ID: <484691CB.6090809@goop.org>
Date: Wed, 04 Jun 2008 13:59:55 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/4] x86_64: Fold pda into per cpu area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <20080604003019.509483000@polaris-admin.engr.sgi.com>
In-Reply-To: <20080604003019.509483000@polaris-admin.engr.sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
>   * Declare the pda as a per cpu variable.
>
>   * Make the x86_64 per cpu area start at zero.
>
>   * Since the pda is now the first element of the per_cpu area, cpu_pda()
>     is no longer needed and per_cpu() can be used instead.  This also makes
>     the _cpu_pda[] table obsolete.
>
>   * Since %gs is pointing to the pda, it will then also point to the per cpu
>     variables and can be accessed thusly:
>
> 	%gs:[&per_cpu_xxxx - __per_cpu_start]
>   

Unfortunately that doesn't actually work, because you can't have a reloc 
with two variables.

In something like:

	mov %gs:per_cpu__foo - 12345, %rax
	mov %gs:per_cpu__foo, %rax
	mov %gs:per_cpu__foo - 12345(%rip), %rax
	mov %gs:per_cpu__foo(%rip), %rax
	mov %gs:per_cpu__foo - __per_cpu_start, %rax
	mov %gs:per_cpu__foo - __per_cpu_start(%rip), %rax

the last two lines will not assemble:

t.S:5: Error: can't resolve `per_cpu__foo' {*UND* section} - `__per_cpu_start' {*UND* section}
t.S:6: Error: can't resolve `per_cpu__foo' {*UND* section} - `__per_cpu_start' {*UND* section}

Unfortunately, the only way I can think of fixing this is to compute the 
offset into a temp register, then use that:

	lea per_cpu__foo(%rip), %rax
	mov %gs:__per_cpu_offset(%rax), %rax

(where __per_cpu_offset is defined in the linker script as 
-__per_cpu_start).

This seems to be a general problem with zero-offset per-cpu.  And its 
unfortunate, because no-register access to per-cpu variables is nice to 
have.

The other alternative - and I have no idea whether this is practical or 
possible - is to define  a complete set of pre-offset per_cpu symbols.

    J
