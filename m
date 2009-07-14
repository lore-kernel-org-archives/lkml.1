Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbZGNRpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbZGNRpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 13:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbZGNRpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 13:45:38 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:43159 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbZGNRph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 13:45:37 -0400
Message-ID: <4A5CC43B.1020402@monstr.eu>
Date: Tue, 14 Jul 2009 19:45:31 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>
Subject: Re: access_ok macor
References: <4A5C8068.6020203@monstr.eu> <200907141843.05629.arnd@arndb.de> <4A5CB8B4.7050108@monstr.eu> <200907141913.21240.arnd@arndb.de>
In-Reply-To: <200907141913.21240.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Tuesday 14 July 2009, Michal Simek wrote:
>> when the code tried to read/write from unaligned address (and in cpu is turn on unaligned exception)
>> then is caused unaligned exception and asm code assemble/return value which is on that unaligned
>> address. (Assemble it that read/write every byte separately). That will be harder to prevent all
>> this cases because unaligned exception is in generic code.
>> What do you mean add __range_ok? Range checking is ok. The problem is when in case get_user kernel
>> try to load unaligned addr - unaligned exception is perform and try to load that value separately.
>> If that page is not there, page fault handler is called and not find it, it is performed search
>> from exception table and that address is not there of course - because address in pc is generic
>> unaligned code. I think that handling this needs more code.
>> Maybe if the address with from unaligned exception handler (there are some address which can caused
>> it) and find out which aligned address is there and find out proper fixup for it.
>> I think that this could work.
>>
>> What do you think?
> 
> I think the key point is that the kernel should never try an unaligned
> access. Other architectures already rely on this, so you can too.

I think that especially for this case get/put_user (+ user_copy macros)
kernel can do it because just copy/paste data from user space and data
can be unaligned.


> Instead of doing an aligned access from the unaligned exception handler,
> you should not access the data at all when you come from kernel mode
> but only search the fixup table to see if you should continue anyway.

> 
> Sorry for adding confusion by mentioning the __range_ok, which is addressing
> a separate problem. I should have made that clearer.

it is ok.

> 
> In pseudo-code, I think you should do:
> 
> void unaligned_exception(struct pt_regs *regs, unsigned long address)
> {
> 	if (kernel_mode(regs)) {
> 		/*
> 		 * unaligned access not allowed in kernel,
> 		 * but search exception table.
> 		 */
> 		bad_page_fault(regs, address, 0);
> 	} else {
> 		if (!access_ok(address, 4))
> 			force_sig(SIGBUS, current);
> 		else
> 			fixup_unaligned_access(regs);
> 	}
> }

Not sure about this idea because I think we have to use unaligned access for kernel too.
Your idea to skip unaligned access for kernel code should work but I think we have to find out
a solution for case when we need to use it in kernel code.

My idea was


void bad_page_fault()
{
	fixup = search_exception_tables(regs->pc);
	if (fixup) {
		regs->pc = fixup->fixup;
		return;
	}

	fixup = search_exception_tables(unaligned exception addr & 0xffff fffc) //mask last 2bits to get
aligned address
	if (fixup) {
		regs->pc = fixup->fixup;
		return;
	}

	die();

}


but not sure if will work because this setup bad fixup. In case that tlb load correct data
and kernel is able to access that place then unaligned exception needn't caused next page fault
and exception handler can load that value.

Maybe this could be work.

Michal





> 
> 	Arnd <><


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
