Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbZBOMYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbZBOMYl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 07:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbZBOMYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 07:24:32 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:31943 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753173AbZBOMYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 07:24:31 -0500
Message-ID: <49980979.6090305@ru.mvista.com>
Date: Sun, 15 Feb 2009 15:24:25 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: petkovbb@gmail.com
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] ide: remove ide_execute_pkt_cmd()
References: <20090209231945.32406.14874.sendpatchset@localhost.localdomain>	 <20090209232019.32406.98822.sendpatchset@localhost.localdomain>	 <20090211065535.GC937@gollum.tnic> <4992D108.2070709@ru.mvista.com>	 <9ea470500902110537g4d6c67a3o35d1d8a4dcca0927@mail.gmail.com>	 <4992D77F.3090802@ru.mvista.com> <9ea470500902110832p58cf6b6at38a20f9ea7557017@mail.gmail.com>
In-Reply-To: <9ea470500902110832p58cf6b6at38a20f9ea7557017@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Borislav Petkov wrote:

>>>>> or similar instead of wasting stack space?
>>>>>
>>>>>           
>>>>  It doesn't necessarily waste stack space. Haven't you heard about
>>>> compiler
>>>> putting local vairables into registers?
>>>>
>>>>         
>>> Yes, have you heard of unnecessary register spilling?
>>>
>>>       
>>  No -- only about stack spilling on CPUs "caching" the top of stack in their
>> register file (like SPARC).
>>  Linux runs not only on x86 and many RISCs can store several local variables
>> in the dedicated registers -- it's the part of say MIPS ABIs...
>>     

   Oh, it's really the same on x86, only there are only 3 registers 
dedicated to that. RISCs typically have more, however x86_64 wiuth 16 
its registers is close to that already. However, you're right -- these 
registers need saving at the function entry, so they effectively take 
the stack space.

>>>>> It'll also read better in the if() check:
>>>>>
>>>>> if (drv_can_irq_interrupt(drive)) { ...
>>>>>
>>>>>
>>>>>           
>>>>  It's faster to checj a local variable than to dereference drv several
>>>> times
>>>> -- unless gcc optimizes that away (by creating an implicit local variable
>>>> :-).
>>>>         
>
>
> Let's look at an example:
>
> In ide-cd.c:cdrom_newpc_intr() you have the following code snippet:
>
> <ide-cd.c>
>  799         thislen = blk_fs_request(rq) ? len : rq->data_len;
>  800         if (thislen > len)
>  801                 thislen = len;
>  802
>  803         ide_debug_log(IDE_DBG_PC, "%s: DRQ: stat: 0x%x, thislen: %d\n",
>  804                       __func__, stat, thislen);
>  805
>  806         /* If DRQ is clear, the command has completed. */
>  807         if ((stat & ATA_DRQ) == 0) {
>  808                 if (blk_fs_request(rq)) {
> </ide-cd.c>
>
> Now watch the blk_fs_request() thing.
>
> Here's what my gcc¹ spits out:
>   

   Thsi code is somewhat confused. Also, I was of a better opinion of gcc...

> <ide-cd.s>
> .LVL174:
>         .loc 1 799 0
>         movl    76(%r12), %ecx  # <variable>.cmd_type, prephitmp.1128
>         cmpl    $1, %ecx        #, prephitmp.1128
>         movl    %ecx, %r8d      # prephitmp.1128, prephitmp.1047
>         je      .L225   #,
>   

  Now where is that label?

> .LVL175:
>         .loc 1 800 0
>         movzwl  -44(%rbp), %r15d        # len, thislen
>   

   Oh, that AT&T syntax... it took me a while to realize that it's a 
movzx insn. :-)

> .LVL176:
>         .loc 1 799 0
>         movl    280(%r12), %edx # <variable>.data_len, thislen.1129
> .LVL177:
>         .loc 1 800 0
>         cmpl    %r15d, %edx     # thislen, thislen.1129
>         movl    %r15d, %ebx     # thislen, thislen.1163
>         jg      .L145   #,
> .LVL178:
>         movl    %edx, %r15d     # thislen.1129, thislen
>   

   I wonder why it doesn't generate cmovng ISO jg and mov...

> .LVL179:
> .L145:
>         .loc 1 807 0
>         testb   $8, -64(%rbp)   #, stat
>         jne     .L147   #,
> .LVL180:
>         .loc 1 808 0
>         cmpl    $1, %ecx        #, prephitmp.1128
>         je      .L226   #,
>         .loc 1 825 0
>         cmpl    $2, %ecx        #, prephitmp.1128
>         .p2align 4,,3
>         .p2align 3
>         je      .L152   #,
> .LBB408:
> </ide-cd.s>
>   
> and at label .LVL174 you see the blk_fs_request() check from line
> 799 above. Later, at label .LVL180 you see the next blk_fs_request() check from
> line 808 and this is cached in %ecx so gcc is smart enough to do that. So,
>   

   Yes, CSE optimization does work...

> actually you get the same thing/or even better with variables in registers
> instead of on stack

  I still don't undestand why you assume that such variable will be 
alloceted on stack -- gcc has 3 registers available for local variables 
(which doesn't have to save across function calls). However, the 
register variables have to take stack space indeed as they need to be 
saved on funciton entry... though I'm not sure that gcc will necessary 
put such variable in one of those 3 registers if it figures out that 
there are no function calls going to happen during its life time.

> and the code is more readable. A win-win situation, I'd say :).
>   

  You haven't presented the code which gets generated when the local 
variable is used, so it's impossible to compare.

MBR, Sergei


