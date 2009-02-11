Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbZBKQcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbZBKQcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 11:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755966AbZBKQcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 11:32:12 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:51621 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666AbZBKQcL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 11:32:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=C2YuoyQn66bx74uUH7GDXO9o77fKn3MK2UbG/gynWqNSwnQsWVKmOeDKJvAHVDxhAG
         O0G9FozoL6cUlPSQufRNfuQOSPa8+5A2rrtCyUrf0bYcyXdJGAPNzmzQ+6c9UXZBaStA
         yiUJJOroZ1cIg6sN5qAUc0qT7Qvxnf7HJ8sK4=
MIME-Version: 1.0
Reply-To: petkovbb@gmail.com
In-Reply-To: <4992D77F.3090802@ru.mvista.com>
References: <20090209231945.32406.14874.sendpatchset@localhost.localdomain>
	 <20090209232019.32406.98822.sendpatchset@localhost.localdomain>
	 <20090211065535.GC937@gollum.tnic> <4992D108.2070709@ru.mvista.com>
	 <9ea470500902110537g4d6c67a3o35d1d8a4dcca0927@mail.gmail.com>
	 <4992D77F.3090802@ru.mvista.com>
Date: Wed, 11 Feb 2009 17:32:09 +0100
Message-ID: <9ea470500902110832p58cf6b6at38a20f9ea7557017@mail.gmail.com>
Subject: Re: [PATCH 5/6] ide: remove ide_execute_pkt_cmd()
From: Borislav Petkov <petkovbb@googlemail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[..]

>>>>
>>>> How about we finally add those check macros in block layer fashion like
>>>> blk_pc_request et al and do
>>>>
>>>> #define drv_can_drq_interrupt(drive)    ((drive)->atapi_flags &
>>>> IDE_AFLAG_DRQ_INTERRUPT)
>>>>
>>>>
>>>
>>>  I suppose it's for the devices that interrupt on packet DRQ? Then it's
>>> hardly a good name because it's not like this is some optional
>>> capability.
>>>
>>
>> No, I was alluding to the command packet DRQ type used by the device as it
>> is
>> put in SFF8020i, 7.1.7.1 General Conﬁguration Word.
>>
>
>  I was talking about exactly the same feature. :-)

Ok, I agree, the names could be a bit more explanatory w.r.t of the DRQ type:

ide_drv_microprocessor_drq
ide_drv_interrupt_drq
ide_drv_accelerated_drq

although we use only one type currently.

>>>> or similar instead of wasting stack space?
>>>>
>>>
>>>  It doesn't necessarily waste stack space. Haven't you heard about
>>> compiler
>>> putting local vairables into registers?
>>>
>>
>> Yes, have you heard of unnecessary register spilling?
>>
>
>  No -- only about stack spilling on CPUs "caching" the top of stack in their
> register file (like SPARC).
>  Linux runs not only on x86 and many RISCs can store several local variables
> in the dedicated registers -- it's the part of say MIPS ABIs...

>>>> It'll also read better in the if() check:
>>>>
>>>> if (drv_can_irq_interrupt(drive)) { ...
>>>>
>>>>
>>>
>>>  It's faster to checj a local variable than to dereference drv several
>>> times
>>> -- unless gcc optimizes that away (by creating an implicit local variable
>>> :-).


Let's look at an example:

In ide-cd.c:cdrom_newpc_intr() you have the following code snippet:

<ide-cd.c>
 799         thislen = blk_fs_request(rq) ? len : rq->data_len;
 800         if (thislen > len)
 801                 thislen = len;
 802
 803         ide_debug_log(IDE_DBG_PC, "%s: DRQ: stat: 0x%x, thislen: %d\n",
 804                       __func__, stat, thislen);
 805
 806         /* If DRQ is clear, the command has completed. */
 807         if ((stat & ATA_DRQ) == 0) {
 808                 if (blk_fs_request(rq)) {
</ide-cd.c>

Now watch the blk_fs_request() thing.

Here's what my gcc¹ spits out:

<ide-cd.s>
.LVL174:
        .loc 1 799 0
        movl    76(%r12), %ecx  # <variable>.cmd_type, prephitmp.1128
        cmpl    $1, %ecx        #, prephitmp.1128
        movl    %ecx, %r8d      # prephitmp.1128, prephitmp.1047
        je      .L225   #,
.LVL175:
        .loc 1 800 0
        movzwl  -44(%rbp), %r15d        # len, thislen
.LVL176:
        .loc 1 799 0
        movl    280(%r12), %edx # <variable>.data_len, thislen.1129
.LVL177:
        .loc 1 800 0
        cmpl    %r15d, %edx     # thislen, thislen.1129
        movl    %r15d, %ebx     # thislen, thislen.1163
        jg      .L145   #,
.LVL178:
        movl    %edx, %r15d     # thislen.1129, thislen
.LVL179:
.L145:
        .loc 1 807 0
        testb   $8, -64(%rbp)   #, stat
        jne     .L147   #,
.LVL180:
        .loc 1 808 0
        cmpl    $1, %ecx        #, prephitmp.1128
        je      .L226   #,
        .loc 1 825 0
        cmpl    $2, %ecx        #, prephitmp.1128
        .p2align 4,,3
        .p2align 3
        je      .L152   #,
.LBB408:
</ide-cd.s>

and at label .LVL174 you see the blk_fs_request() check from line
799 above. Later, at label .LVL180 you see the next blk_fs_request() check from
line 808 and this is cached in %ecx so gcc is smart enough to do that. So,
actually you get the same thing/or even better with variables in registers
instead of on stack and the code is more readable. A win-win
situation, I'd say :).

>>
>> I hope gcc is smart enough to do that.
>>
>
>  Then where's the win?

Readability, of course. Also you have smaller, cleaner code. This is very
important, IMO.


---
¹gcc (Debian 4.3.3-3) 4.3.3
Copyright (C) 2008 Free Software Foundation, Inc.


-- 
Regards/Gruss,
Boris
