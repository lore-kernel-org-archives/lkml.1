Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab0CEHry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 02:47:54 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:40248 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab0CEHrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 02:47:52 -0500
Message-ID: <4B90B723.3000100@in.ibm.com>
Date: Fri, 05 Mar 2010 13:17:47 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: -next March 3: Boot failure on x86 (Oops)
References: <20100303174603.5be197ba.sfr@canb.auug.org.au> <4B8E83D4.6090507@in.ibm.com> <4B8F0CD0.1040507@kernel.org> <4B8F43DD.10002@in.ibm.com> <4B909FC5.8020800@kernel.org> <4B90A031.8090306@kernel.org> <4B90A214.70301@kernel.org>
In-Reply-To: <4B90A214.70301@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
>
> On 03/05/2010 03:09 PM, Tejun Heo wrote:
>   
>> On 03/05/2010 03:08 PM, Tejun Heo wrote:
>>     
>>> Hmmm... this means that on one of the chunks, chunk->list.next was
>>> NULL (BTW, the disassembly is from unlinked object, right?).  The main
>>> allocation code hasn't seen much change lately.  The only changes are,
>>>
>>> 22b737f4c75197372d64afc6ed1bccd58c00e549 : just refactoring
>>> 833af8427be4b217b5bc522f61afdbd3f1d282c2 : possible but isn't very new
>>>       
>> Can you also please try reverting the above two commits?
>>     
>
> Sorry about all the fuss but I think this could be it.  It looks like
> I forgot to update need_to_extend logic while adding simultaneous
> head/tail split for alignment, so the array might be overrun by one
> entry.  Can you please try this one first?
>
> Thanks.
>
> diff --git a/mm/percpu.c b/mm/percpu.c
> index 768419d..f1ed9ea 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -373,11 +373,11 @@ static int pcpu_need_to_extend(struct pcpu_chunk *chunk)
>  {
>  	int new_alloc;
>
> -	if (chunk->map_alloc >= chunk->map_used + 2)
> +	if (chunk->map_alloc >= chunk->map_used + 3)
>  		return 0;
>
>  	new_alloc = PCPU_DFL_MAP_ALLOC;
> -	while (new_alloc < chunk->map_used + 2)
> +	while (new_alloc < chunk->map_used + 3)
>  		new_alloc *= 2;
>
>  	return new_alloc;
>
>   
This did not help. With this patch applied i ran into the
following 

Unpacking initramfs...
Freeing initrd memory: 11780k freed
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<c01df0e2>] pcpu_alloc+0x1cb/0x75e
*pdpt = 0000000000661001 *pde = 0000000000000000
Oops: 0000 [#1] SMP
last sysfs file:
Modules linked in:

Pid: 1, comm: swapper Not tainted 2.6.33-git10-autotest #2 /eserver xSeries 235 -[86717AX]-
EIP: 0060:[<c01df0e2>] EFLAGS: 00010002 CPU: 1
EIP is at pcpu_alloc+0x1cb/0x75e
EAX: 00000000 EBX: c0647a00 ECX: cccccccc EDX: 00000000
ESI: 00000040 EDI: 00000004 EBP: f5c3ff74 ESP: f5c3fef8
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 1, ti=f5c3e000 task=f5c48000 task.ti=f5c3e000)
Stack:
 00000000 00000004 00000002 00000002 00000002 f6227fa0 00000040 00000040
<0> 00000002 00000286 f62294a0 00000000 f5c3ff54 00000202 00000000 f6200400
<0> 00000202 00000000 00000020 f6200000 00000000 f62294a0 00000000 f5c3ff64
Call Trace:
 [<c01b364b>] ? free_hot_page+0x31/0x35
 [<c01df68e>] ? __alloc_percpu+0xa/0xc
 [<c0163c29>] ? __create_workqueue_key+0x74/0x1c8
 [<c05fe3d3>] ? irqfd_module_init+0x0/0x2c
 [<c05fe3ed>] ? irqfd_module_init+0x1a/0x2c
 [<c0101139>] ? do_one_initcall+0x4c/0x131
 [<c05fc352>] ? kernel_init+0x127/0x1a8
 [<c05fc22b>] ? kernel_init+0x0/0x1a8
 [<c01220b6>] ? kernel_thread_helper+0x6/0x10
Code: 45 a8 e9 65 ff ff ff 8b 4d 9c 8b 55 a0 8b 45 84 e8 31 fa ff ff 85 c0 89 45 a4 0f 89 fd 00 00 00 8b 45 84 8b 00 89 45 84 8b 55 84 <8b> 02 0f 18 00 90 8b 45 cc 03 05 a0 9f 5f c0 39 c2 0f 85 67 ff
EIP: [<c01df0e2>] pcpu_alloc+0x1cb/0x75e SS:ESP 0068:f5c3fef8
CR2: 0000000000000000
---[ end trace a7919e7f17c0a725 ]---

I will try reverting the two commits you mentioned and see if that
helps.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

