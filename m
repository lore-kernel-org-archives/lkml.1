Return-Path: <linux-kernel-owner+w=401wt.eu-S1760870AbZBMSOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760870AbZBMSOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 13:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758515AbZBMSOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 13:14:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52790 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbZBMSOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 13:14:19 -0500
Message-ID: <4995B88C.2090900@redhat.com>
Date: Fri, 13 Feb 2009 13:14:36 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@suse.de>,
       akpm <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: irq-disabled vs vmap vs text_poke
References: <1234529407.6519.28.camel@twins> <20090213141839.GA31922@Krystal> <4995A0B7.1030705@redhat.com> <20090213165555.GA4684@Krystal>
In-Reply-To: <20090213165555.GA4684@Krystal>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
>>> text_poke should actually use local_irq_disable/enable rather than
>>> local_irq_save/restore because it _must_ be called with interrupts on.
>> Could you tell me why it must be called with irq on?
>>
> 
> Because it uses vmap, but see below..
> 
>>>> Anybody got an idea on how to fix this?
>>> There is probably something wrong with the caller, kprobes, which calls
>>> text_poke with interrupts off.
>> Hmm, kprobe's smoke test caused this problem. Since (un)register_kprobe()
>> may sleep for waiting a mutex, it should not be called with interrupts off.
>> So, it's not text_poke()'s issue nor vmap().
>>
>> BTW, what about using map_vm_area() in text_poke() instead of vmap()?
>> Since text_poke() just maps text pages to alias pages temporarily,
>> I think we don't need to use delayed vunmap().
>>
> 
> As with this patch from you ? Sorry, when it has been initially
> submitted, the discussion turned in a different direction. Please see
> comments inline.

No, sorry for confusing, vm_unmap_ram() is basically same as vunmap().
(The root cause of that bug which I had been reported was not in text_poke())

Here I said is (maybe) improving text_poke() by using map_vm_area() which
simply maps pages to pre-allocated vm_area. And when unmapping, we just
cleanup pte by unmap_kernel_range().
For pre-allocating vm_area, we can use get_vm_area().

If we can use kmap for this purpose, it will be better solution.
However, kmap can not be used for making alias pages.

Thanks,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

