Return-Path: <linux-kernel-owner+w=401wt.eu-S1764930AbYFFIaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764930AbYFFIaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 04:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbYFFIaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 04:30:00 -0400
Received: from gw.goop.org ([64.81.55.164]:55306 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756043AbYFFI36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 04:29:58 -0400
Message-ID: <4848F55C.90904@goop.org>
Date: Fri, 06 Jun 2008 09:29:16 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <20080604003019.509483000@polaris-admin.engr.sgi.com> <20080605102222.GA21319@elte.hu> <48480DFB.7000404@sgi.com>
In-Reply-To: <48480DFB.7000404@sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Ingo Molnar wrote:
>   
>> * Mike Travis <travis@sgi.com> wrote:
>>
>>     
>>>   * Declare the pda as a per cpu variable.
>>>
>>>   * Make the x86_64 per cpu area start at zero.
>>>
>>>   * Since the pda is now the first element of the per_cpu area, cpu_pda()
>>>     is no longer needed and per_cpu() can be used instead.  This also makes
>>>     the _cpu_pda[] table obsolete.
>>>
>>>   * Since %gs is pointing to the pda, it will then also point to the per cpu
>>>     variables and can be accessed thusly:
>>>
>>> 	%gs:[&per_cpu_xxxx - __per_cpu_start]
>>>
>>> Based on linux-2.6.tip
>>>       
>> -tip testing found an instantaneous reboot crash on 64-bit x86, with 
>> this config:
>>
>>   http://redhat.com/~mingo/misc/config-Thu_Jun__5_11_43_51_CEST_2008.bad
>>
>> there is no boot log as the instantaneous reboot happens before anything 
>> is printed to the (early-) serial console. I have bisected it down to:
>>
>> | 7670dc09e89a2b151a1cf49eccebc07c41c2ce9f is first bad commit
>> | commit 7670dc09e89a2b151a1cf49eccebc07c41c2ce9f
>> | Author: Mike Travis <travis@sgi.com>
>> | Date:   Tue Jun 3 17:30:21 2008 -0700
>> |
>> |     x86_64: Fold pda into per cpu area
>>
>> the big problem is not just this crash, but that the patch is _way_ too 
>> big:
>>
>>  arch/x86/Kconfig                 |    3 +
>>  arch/x86/kernel/head64.c         |   34 ++++++--------
>>  arch/x86/kernel/irq_64.c         |   36 ++++++++-------
>>  arch/x86/kernel/setup.c          |   90 ++++++++++++---------------------------
>>  arch/x86/kernel/setup64.c        |    5 --
>>  arch/x86/kernel/smpboot.c        |   51 ----------------------
>>  arch/x86/kernel/traps_64.c       |   11 +++-
>>  arch/x86/kernel/vmlinux_64.lds.S |    1 
>>  include/asm-x86/percpu.h         |   48 ++++++--------------
>>  9 files changed, 89 insertions(+), 190 deletions(-)
>>
>> considering the danger involved, this is just way too large, and there's 
>> no reasonable debugging i can do in the bisection to narrow it down any 
>> further.
>>
>> Please resubmit with the bug fixed and with a proper splitup, the more 
>> patches you manage to create, the better. For a dangerous code area like 
>> this, with a track record of frequent breakages in the past, i would not 
>> mind a "one line of code changed per patch" splitup either. (Feel free 
>> to send a git tree link for us to try as well.)
>>
>> 	Ingo
>>     
>
> Thanks for the feedback Ingo.  I'll test the above config and look at
> splitting up the patch.  The difficulty is making each patch independently
> compilable and testable.

FWIW, I'm getting past the "crashes very, very early" stage with this 
series applied when booting under Xen.  Then it crashes pretty early, 
but that's not your fault...

    J
