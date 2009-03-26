Return-Path: <linux-kernel-owner+w=401wt.eu-S1759022AbZCZRD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbZCZRD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 13:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757464AbZCZRDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 13:03:18 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:36593 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbZCZRDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:03:17 -0400
Message-ID: <49CBB54C.5080201@ct.jp.nec.com>
Date: Thu, 26 Mar 2009 10:03:08 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, roland@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Subject: Re: [tip:x86/signal] x86: signal: check signal stack overflow	properly
References: <49C2874D.3080002@ct.jp.nec.com> <tip-14fc9fbc700dc95b4f46ebd588169324fe6deff8@git.kernel.org> <20090324220008.GA23243@redhat.com>
In-Reply-To: <20090324220008.GA23243@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 03/20, Hiroshi Shimamoto wrote:
>> Commit-ID:  14fc9fbc700dc95b4f46ebd588169324fe6deff8
>> Gitweb:     http://git.kernel.org/tip/14fc9fbc700dc95b4f46ebd588169324fe6deff8
>> Author:     Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>> AuthorDate: Thu, 19 Mar 2009 10:56:29 -0700
>> Committer:  Ingo Molnar <mingo@elte.hu>
>> CommitDate: Fri, 20 Mar 2009 19:01:31 +0100
>>
>> x86: signal: check signal stack overflow properly
>>
>> Impact: cleanup
>>
>> Check alternate signal stack overflow with proper stack pointer.
>> The stack pointer of the next signal frame is different if that
>> task has i387 state.
> 
> I think the patch is correct but I have a minor question,
> 
>> No need to check SA_ONSTACK if we're already using alternate signal stack.
> 
> Yes, but this also mean that we don't need sas_ss_flags() under
> "if (!onsigstack)",
> 
>> @@ -211,31 +211,27 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
>>  {
>>  	/* Default to using normal stack */
>>  	unsigned long sp = regs->sp;
>> +	int onsigstack = on_sig_stack(sp);
>>
>>  #ifdef CONFIG_X86_64
>>  	/* redzone */
>>  	sp -= 128;
>>  #endif /* CONFIG_X86_64 */
>>
>> -	/*
>> -	 * If we are on the alternate signal stack and would overflow it, don't.
>> -	 * Return an always-bogus address instead so we will die with SIGSEGV.
>> -	 */
>> -	if (on_sig_stack(sp) && !likely(on_sig_stack(sp - frame_size)))
>> -		return (void __user *) -1L;
>> -
>> -	/* This is the X/Open sanctioned signal stack switching.  */
>> -	if (ka->sa.sa_flags & SA_ONSTACK) {
>> -		if (sas_ss_flags(sp) == 0)
>> -			sp = current->sas_ss_sp + current->sas_ss_size;
>> -	} else {
>> +	if (!onsigstack) {
>> +		/* This is the X/Open sanctioned signal stack switching.  */
>> +		if (ka->sa.sa_flags & SA_ONSTACK) {
>> +			if (sas_ss_flags(sp) == 0)
>> +				sp = current->sas_ss_sp + current->sas_ss_size;
> 
> We can use "->sas_ss_size != 0" instead and avoid the unnecessary
> sas_ss_flags()->on_sig_stack() check.
> 
> Please note that afaics sas_ss_flags()->on_sig_stack() is actually
> wrong because we already adjusted "sp" above for redzone.
> 
> Suppose that on_sig_stack(regs->sp) = F, but "sp - 128" falls into
> the altstack. In that case SA_ONSTACK won't switch the stack.
> 
> Of course, this is only theoretical, but still.

Hi Oleg,

Thanks for pointing out it.
I made a patch you suggested.

I haven't tested enough this patch, sorry.

Thanks,
Hiroshi
========
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: [PATCH] x86: signal: check sas_ss_size instead of sas_ss_flags()

Impact: fix redundant and incorrect check

Checking on_sig_stack() in sas_ss_flags() at get_sigframe() is redundant
and not correct on 64 bit. To check sas_ss_size is enough.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 62f2164..465b42d 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -221,7 +221,7 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 	if (!onsigstack) {
 		/* This is the X/Open sanctioned signal stack switching.  */
 		if (ka->sa.sa_flags & SA_ONSTACK) {
-			if (sas_ss_flags(sp) == 0)
+			if (current->sas_ss_size)
 				sp = current->sas_ss_sp + current->sas_ss_size;
 		} else {
 #ifdef CONFIG_X86_32
-- 
1.6.1.2

