Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbZCFWGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbZCFWGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbZCFWGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:06:35 -0500
Received: from gw.goop.org ([64.81.55.164]:39244 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbZCFWGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:06:35 -0500
Message-ID: <49B19E67.9050003@goop.org>
Date: Fri, 06 Mar 2009 14:06:31 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, yinghai@kernel.org,
       tglx@linutronix.de, hpa@zytor.com, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: introduce bootmem_state -v2
References: <1236257708-27269-7-git-send-email-penberg@cs.helsinki.fi> <49B02498.9080300@kernel.org> <49B02C68.1030203@cs.helsinki.fi> <49B0640A.5080607@kernel.org> <20090306145928.GE21907@elte.hu> <49B16DA6.4090108@kernel.org> <20090306191249.GC28582@elte.hu> <20090306113054.4ae4b875.akpm@linux-foundation.org> <20090306193611.GA4278@elte.hu>
In-Reply-To: <20090306193611.GA4278@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
>
>   
>> On Fri, 6 Mar 2009 20:12:49 +0100
>> Ingo Molnar <mingo@elte.hu> wrote:
>>
>>     
>>> * Yinghai Lu <yinghai@kernel.org> wrote:
>>>
>>>       
>>>> Impact: cleanup
>>>>
>>>> extend after_bootmem and after_init_bootmem to bootmem_state
>>>> and will have BEFORE_BOOTMEM, DURING_BOOTMEM, AFTER_BOOTMEM
>>>>
>>>> v2: style changes according to ingo
>>>>
>>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>>
>>>> ---
>>>>  arch/x86/kernel/setup.c |    1 +
>>>>  arch/x86/mm/init.c      |   13 +++++++------
>>>>  arch/x86/mm/init_32.c   |   28 ++++++++++++++++++++--------
>>>>  arch/x86/mm/init_64.c   |   33 +++++++++++++++++++--------------
>>>>  include/linux/mm.h      |    9 +++++++++
>>>>  5 files changed, 56 insertions(+), 28 deletions(-)
>>>>         
>>>> Index: linux-2.6/include/linux/mm.h
>>>> ===================================================================
>>>> --- linux-2.6.orig/include/linux/mm.h
>>>> +++ linux-2.6/include/linux/mm.h
>>>> @@ -1067,6 +1067,15 @@ extern void __init mmap_init(void);
>>>>  extern void show_mem(void);
>>>>  extern void si_meminfo(struct sysinfo * val);
>>>>  extern void si_meminfo_node(struct sysinfo *val, int nid);
>>>> +
>>>> +enum bootmem_state {
>>>> +	BEFORE_BOOTMEM,
>>>> +	DURING_BOOTMEM,
>>>> +	AFTER_BOOTMEM
>>>> +};
>>>> +
>>>> +extern enum bootmem_state bootmem_state;
>>>> +
>>>>  extern int after_bootmem;
>>>>         
>>> Btw., the after_bootmem variable itself should either move to 
>>> x86 (and arch/sh), or should be defined in mm/bootmem.c.
>>>
>>> Right now we have this weird mm.h construct that is not actually 
>>> useful to generic code.
>>>
>>> Andrew, what would be your preference?
>>>
>>>       
>> If two architectures are using it then it should be provided 
>> by core kernel?
>>
>> This is obvious if the state transitions are occurring in 
>> core-kernel code, but if the transitions are happening in arch 
>> code then making it a core concept assumes consistency between 
>> different architectures which might not exist.
>>
>> IOW: dunno.
>>     
>
> Core kernel could provide a wrapper allocator which calls the 
> right method depending on which state we are in. It will call 
> bootmem_alloc() if called early, and kmalloc() if called later. 
> Or something like that. Would there be any utility in that?
>   

Yes, so long as you're never intending to free the memory (since you 
won't know which free function to use for a given pointer - assuming one 
even exists).  And code which does:

    p = use_anytime_alloctor();

...
    kfree(p);        /* I know it was really allocated by kmalloc */


should be shot.

    J
