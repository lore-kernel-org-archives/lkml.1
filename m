Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbXLUILr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbXLUILr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 03:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbXLUILi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 03:11:38 -0500
Received: from styx.suse.cz ([82.119.242.94]:57175 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751326AbXLUILh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 03:11:37 -0500
Message-ID: <476B7623.3040008@suse.cz>
Date: Fri, 21 Dec 2007 09:15:31 +0100
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE CR, s.r.o.
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Kyle McMartin <kyle@mcmartin.ca>, lkml <linux-kernel@vger.kernel.org>,
       tony.luck@intel.com, linux-ia64@vger.kernel.org
Subject: Re: [ia64] BUG: sleeping in atomic
References: <20071219055430.GV4396912@sgi.com> <20071219164204.GA18161@fattire.cabal.ca> <20071220043429.GO4612@sgi.com>
In-Reply-To: <20071220043429.GO4612@sgi.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> On Wed, Dec 19, 2007 at 11:42:04AM -0500, Kyle McMartin wrote:
>   
>> On Wed, Dec 19, 2007 at 04:54:30PM +1100, David Chinner wrote:
>>     
>>> [ 5667.086055] BUG: sleeping function called from invalid context at kernel/fork.c:401
>>>
>>>       
>> The problem is that mmput is called under the read_lock by
>> find_thread_for_addr... The comment above seems to indicate that gdb
>> needs to be able to access any child tasks register backing store
>> memory... This seems pretty broken.
>>
>> cheers, Kyle
>>
>> ---
>>
>> Who knows, maybe gdb is saner now?
>>     

Well, gdb is saner, but the bug you're talking about will be fixed in a
clean way (even for insane debuggers) with  Shaohua's, Roland's and my
fixes to handling the RSE, because they make it possible to get rid of
find_thread_for_addr(). I already sent a mail about it to linux-ia64
some time ago, and Roland suggested we might even change everything to
the generic sys_ptrace(), which is the correct solution (TM), and I'm
planning to do it so as soon as the RSE patches are in.

Regards,
Petr Tesarik
>> diff --git a/arch/ia64/kernel/ptrace.c b/arch/ia64/kernel/ptrace.c
>> index 2e96f17..b609704 100644
>> --- a/arch/ia64/kernel/ptrace.c
>> +++ b/arch/ia64/kernel/ptrace.c
>> @@ -1418,7 +1418,7 @@ asmlinkage long
>>  sys_ptrace (long request, pid_t pid, unsigned long addr, unsigned long data)
>>  {
>>  	struct pt_regs *pt;
>> -	unsigned long urbs_end, peek_or_poke;
>> +	unsigned long urbs_end;
>>  	struct task_struct *child;
>>  	struct switch_stack *sw;
>>  	long ret;
>> @@ -1430,23 +1430,12 @@ sys_ptrace (long request, pid_t pid, unsigned long addr, unsigned long data)
>>  		goto out;
>>  	}
>>  
>> -	peek_or_poke = (request == PTRACE_PEEKTEXT
>> -			|| request == PTRACE_PEEKDATA
>> -			|| request == PTRACE_POKETEXT
>> -			|| request == PTRACE_POKEDATA);
>> -	ret = -ESRCH;
>> -	read_lock(&tasklist_lock);
>> -	{
>> -		child = find_task_by_pid(pid);
>> -		if (child) {
>> -			if (peek_or_poke)
>> -				child = find_thread_for_addr(child, addr);
>> -			get_task_struct(child);
>> -		}
>> -	}
>> -	read_unlock(&tasklist_lock);
>> -	if (!child)
>> +	child = ptrace_get_task_struct(pid);
>> +	if (IS_ERR(child)) {
>> +		ret = PTR_ERR(child);
>>  		goto out;
>> +	}
>> +
>>  	ret = -EPERM;
>>  	if (pid == 1)		/* no messing around with init! */
>>  		goto out_tsk;
>>     
>
> Yes, this patch fixes the problem (though I haven't tried to
> use gdb yet).
>
> Cheers,
>
> Dave.
>   

