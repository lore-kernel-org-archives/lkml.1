Return-Path: <linux-kernel-owner+w=401wt.eu-S965181AbXCFEgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965181AbXCFEgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 23:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbXCFEgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 23:36:13 -0500
Received: from smtp-out.google.com ([216.239.45.13]:61282 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbXCFEgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 23:36:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=Poa/XsRSpmw5ZuFpUZ0j82JU5nlnODxvhvwmoDUANvL4GF6N78w8iHl/IJ+LmiCDC
	G6dovjdOhlg+v/6+Pfg3w==
Message-ID: <45ECEF85.2080503@google.com>
Date: Mon, 05 Mar 2007 20:35:17 -0800
From: Mathieu Desnoyers <compudj@google.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Martin J. Bligh" <mbligh@google.com>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Paul Mackerras <paulus@samba.org>, "Luck, Tony" <tony.luck@intel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: Thread flags modified without set_thread_flag() (non atomically)
References: <45E33EBD.6020603@google.com> <20070228220349.b42bf571.akpm@linux-foundation.org> <20070305144033.GG22829@bingen.suse.de>
In-Reply-To: <20070305144033.GG22829@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> It does seem risky.  Perhaps it is a micro-optimisation which utilises
>> knowledge that this thread_struct cannot be looked up via any path in this
>> context.
>>
>> Or perhaps it is a bug.  Andi, can you please comment?
>>     
>
> On flush_thread nobody else can mess with the thread, so yes it's a micro
> optimization.
>
>   
Hi Andi,

Here is what I think would be a counter example :

If, at the same time, we have, on x86_64 :

parent process executing :
sys_ptrace()
  (lock_kernel())
  (ptrace_get_task_struct(pid))
  arch_ptrace()
    ptrace_detach()
      ptrace_disable(child);
        clear_singlestep(child);
          clear_tsk_thread_flag(child, TIF_SINGLESTEP);
          (which clears the TIF_SINGLESTEP  flag atomically from a 
different process)
  (put_task_struct(child))
  (unlock_kernel())

And at the same time, in the child process :
sys_execve()
  do_execve()
    search_binary_handler()
      load_elf_binary()
        flush_old_exec()
          flush_thread()
            doing a non-atomic thread flag update

Is there any protection mechanism that would protect from this race 
condition
that I have missed ?

>>> And about this specific flush_thread, I am puzzled about the t->flags ^= 
>>> (_TIF_ABI_PENDING | _TIF_IA32); line. The XOR will clearly flip the 
>>> _TIF_ABI_PENDING bit to 0, and very likely set _TIF_IA32 to the opposite 
>>> of its current value. Why does this change need to be written atomically 
>>> (can other threads play with these flags ?) ?
>>>
>>>       
>> Don't know.
>>     
>
> iirc it came from DaveM originally. He just likes to write things in 
> comp^wclever ways :0) It's just a little shorter.
>
>   
>> No, I don't immediately see anything in the flush_old_exec() code path
>> which tells us that nobody else can look up this thread_info (or be holding
>> a ref to it) in this context.
>>     
>
> Normally the process flags atomicity should only matter with signals;
> i don't think you can send a signal to a process being in exec this way.
>
> -Andi
>   

