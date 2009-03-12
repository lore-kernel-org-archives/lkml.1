Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbZCLDQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbZCLDQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 23:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbZCLDQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 23:16:02 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbZCLDQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 23:16:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: prasad@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch 08/11] Modify Ptrace routines to access breakpoint
	registers
In-Reply-To: Ingo Molnar's message of  Tuesday, 10 March 2009 15:40:02 +0100 <20090310144002.GF3850@elte.hu>
References: <20090305043440.189041194@linux.vnet.ibm.com>
	<20090305044051.GI17747@in.ibm.com>
	<20090310144002.GF3850@elte.hu>
X-Shopping-List: (1) Classical gloves
   (2) Burrowing piston sugar
   (3) Surfing soft-serve fads
   (4) Mighty liquid-center tampon nutrition
   (5) Magnificent retention commanders
Message-Id: <20090312031449.83F34FC3B6@magilla.sf.frob.com>
Date: Wed, 11 Mar 2009 20:14:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I dont see where this security check has been carried over into 
> the generic code. The new code has:
> 
>  +int arch_check_va_in_userspace(unsigned long va, struct task_struct *tsk)
>  +{
>  +       return (va < TASK_SIZE);
>  +}
> 
> but i think that misses the detail that it's not just the start 
> address of an x86 breakpoint that has to be considered, but also 
> the end addess of it.

It also needs to be TASK_SIZE_OF(tsk), which is shorthand for the same
logic already in the 64-bit debugreg_addr_limit().  

For the end-of-range issue, it perhaps ought to check size-1 instead of
wordsize-1, i.e. through the end of the actual breakpoint range, not of the
word containing it.  What debugreg_addr_limit() does is the historical
ptrace check on x86, but I don't see a reason to disallow a 1-byte
watchpoint on the last addressable user-space byte if the hardware will
support it.

So either the arch check should take a size parameter, or the
arch-independent code can just call it with address+size-1.


Thanks,
Roland
