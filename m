Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbZLEPGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbZLEPGk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 10:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755665AbZLEPGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 10:06:37 -0500
Received: from mail-qy0-f192.google.com ([209.85.221.192]:42628 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531AbZLEPGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 10:06:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=gKQdPCpIIqyCXpqC52n8TQQseL06oD7pXjwJO+T7nXTuPVZjgp/HVoAckGBUW6xv7D
         QXMQNQvY5E90M4Gvmck7f//qoZn7U4E5tE0SA5r3FECA9ldBUkLtS3GLZPdd8qaKRrHs
         Px8mmMMBIXvFVRKYOoysP5P4Kzx8ZUQhiTzdw=
Date: Sat, 5 Dec 2009 10:06:39 -0500 (EST)
From: Bart Oldeman <bartoldeman@users.sourceforge.net>
X-X-Sender: bart@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       "K.Prasad" <prasad@linux.vnet.ibm.com>, stable@kernel.org
Subject: Re: [PATCH] x86, vm86: fix preemption bug for int3 breakpoint
 handlers.
In-Reply-To: <alpine.LFD.2.00.0905251225190.3582@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0912050945350.6093@localhost.localdomain>
References: <alpine.DEB.2.00.0905241834110.17184@localhost.localdomain> <alpine.LFD.2.00.0905251225190.3582@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Mon, 25 May 2009, Thomas Gleixner wrote:
> On Sun, 24 May 2009, Bart Oldeman wrote:
>> --- a/arch/x86/kernel/vm86_32.c
>> +++ b/arch/x86/kernel/vm86_32.c
>> @@ -551,8 +551,12 @@ cannot_handle:
>>  int handle_vm86_trap(struct kernel_vm86_regs *regs, long error_code, int
>> trapno)
>>  {
>>  	if (VMPI.is_vm86pus) {
>> -		if ((trapno == 3) || (trapno == 1))
>> +		if ((trapno == 3) || (trapno == 1)) {
>> +			/* re-enable preemption: return_to_32bit()
>> +			   jumps straight to entry_32.S */
>> +			dec_preempt_count();
>
>  This will break other callers of handle_vm86_trap().

sorry for the late reply, I was just pointed out by someone else about the
existence of this bug again. You are right of course. Below is a new 
patch.

Note that on the linux-2.6-x86.git tree, commit 
08d68323d1f0c34452e614263b212ca556dae47f ("hw-breakpoints: modifying
generic debug exception to use thread-specific debug registers") broke 
vm86 debug exceptions as well again. The trouble is that 
handle_vm86_trap() may jump and change the stack to let the kernel return 
to 32 bit user space, so the handle_vm86_trap() call itself may not 
return.

--
Impact: fix kernel bug such as:
May 22 16:47:47 localhost kernel: note: dosemu.bin[5281] exited with preempt_count 1

Commit be716615fe596ee117292dc615e95f707fb67fd1 ("x86, vm86:
fix preemption bug"), fixed the problem for debug exceptions but not for 
breakpoints. This change also fixes breakpoints.

Cc: stable@kernel.org
Signed-off-by: Bart Oldeman <bartoldeman@users.sourceforge.net>
---
  arch/x86/kernel/traps.c |    7 ++++++-
  1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -181,9 +181,14 @@ kernel_trap:

  #ifdef CONFIG_X86_32
  vm86_trap:
+	/* reenable preemption: handle_vm86_trap() might sleep */
+	dec_preempt_count();
  	if (handle_vm86_trap((struct kernel_vm86_regs *) regs,
-						error_code, trapnr))
+						error_code, trapnr)) {
+		inc_preempt_count();
  		goto trap_signal;
+	}
+	inc_preempt_count();
  	return;
  #endif
  }
