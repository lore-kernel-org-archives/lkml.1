Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbZGOLjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbZGOLjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 07:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbZGOLjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 07:39:16 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:65493 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbZGOLjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 07:39:15 -0400
Message-ID: <4A5DBFD9.7070707@monstr.eu>
Date: Wed, 15 Jul 2009 13:39:05 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: John Williams <jwilliams@itee.uq.edu.au>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>,
       Ralf Baechle <ralf@linux-mips.org>,
       "subrata@linux.vnet.ibm.com" <subrata@linux.vnet.ibm.com>
Subject: Re: access_ok macor
References: <4A5C8068.6020203@monstr.eu> <200907141843.05629.arnd@arndb.de> <9e6f3dfd0907141811p512b4edp3f9dd0fdeae1123e@mail.gmail.com> <200907151214.52369.arnd@arndb.de>
In-Reply-To: <200907151214.52369.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Wednesday 15 July 2009, John Williams wrote:
>> On Wed, Jul 15, 2009 at 2:43 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> The solution then is to handle fixups from the unaligned exception handler
>>> if you come from the kernel. That should fix the three text cases.
>>>
>>> I don't fully understand your exception handling there, but I think you
>>> also need to add code checking for __range_ok() to your unaligned handler,
>>> to prevent malicious user space code from accessing the kernel through
>>> unaligned pointers.
>>
>> Just to try to clarify - are there any alignment rules in the ABI on
>> user-space pointers (which end up going to get/put_user)?
> 
> The kernel normally expects aligned input from user space, but I guess
> it can't hurt to handle it anyway. arch/mips/kernel/alignment.c seems
> to handle that case. Maybe Ralf can give some more insight.

you meant unaligned.c.

> 
>> It seems the failure path is like this:
>>
>> 1. userspace passes unaligned pointer
>> 2. get_user attempts to access
>> 3. CPU raises unaligned exception (if only it would raise the segfault as
>> higher priority, before the unaligned!)
>> 4. unaligned exception handler attempts to simulate the unaligned access
>> with multiple partial read/write ops
>> 5. CPU raises MMU exception on the read/write by the unaligned handler
>> 6. kernel segfault handler looks up faulting address, it is in the unaligned
>> exception handler, which has no fixup.
>> 7. no fixup -> failure
> 
> Right.
> 
>> So, I suppose the question is - where in the sequence is the true failure?
> 
> I think in step 4. AFIACT, the kernel must do a number of checks on accesses
> to random pointers.
> 
>> Clearly LTP thinks it's ok to pass unaligned pointers to the kernel,
>> suggesting (1) is fine - thus my question about alignment rules in the ABI.
> 
> No, LTP thinks it should get a -EFAULT error code for that access. It does
> specify whether it expects this because of an unaligned address or because
> of an invalid page.

IMHO author of this test not expect that caused too much troubles. From that tests
EFAULT should be return from copy_to_user macro not caused kernel fault. LTP should contain
special testcases for testing unaligned address.
I think we should add one more test with invalid aligned argument for that 3 tests + some doc.
I'll send it.

M

> 
>> Do we need fixups on the unaligned handler itself? This will be ugly ugly
>> ugly. 
> 
> That's what ARM does. You don't have to do it from assembly though,
> implementing it in C is probably easier.
> 
>> Or, some way of tracing the segfault back through the unaligned
>> exception and to the root cause (the get/put-user), and call that fixup as
>> required?
> 
> Yes, I guess that would have to look roughly like this:


> 
> int emulate_insn(struct pt_regs *regs, unsigned long addr, unsigned long len)
> {
> 	/* use inline assembly with fixups here, return -EFAULT on bad addr */		
> }
> 
> void alignment_exception(struct pt_regs *regs, unsigned long addr, unsigned long len)
> {
> 	const struct exception_table_entry *fixup;
> 	int err;
> 
> 	if (user_mode(regs)) {
> 		if (!access_ok(addr, len))
> 			goto segv;
> 		if (emulate_insn(regs) == -EFAULT))
> 			goto segv;
> 	} else {
> 		if (!access_ok(addr, len))
> 			goto fixup;
> 		if (emulate_insn(regs, addr, len) == -EFAULT))
> 			goto fixup;
> 	return;
> 
> fixup:
> 	fixup = search_exception_tables(regs->ip);
> 	if (!fixup)
> 		goto segv;
> 
> 	regs->ip = fixup->fixup;
> 	return;
> 
> segv:
> 	force_sig(SIGSEGV, current));
> }


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
