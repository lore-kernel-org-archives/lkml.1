Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbYJXLKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbYJXLKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 07:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYJXLJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 07:09:52 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:17339 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbYJXLJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 07:09:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YsVaJCmNWkBfDQZm9QWACFxMJhBXLOXlctWUTjnPcnWH5SbERc/OY30Xjb1q8pGMHg
         zTaU55DmwGeG9hqJv0ecZ9weuR/bQ5jwX2aP5edUnytYfKQLQ/CTpfvX8fE/Cz1TVEKF
         E3rWdK3BVw2WN545wvebvA7GpOMDHGIKkx9sc=
Message-ID: <b9df5fa10810240409u311bb337x1ff9815431088685@mail.gmail.com>
Date: Fri, 24 Oct 2008 17:09:49 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH -mm] ftrace : Fix section mismatch warning.
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20081022070312.GA24749@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b9df5fa10810122250j1dd9c0eaq8c708c7b8e10a249@mail.gmail.com>
	 <20081020162756.GA31201@elte.hu> <20081022070312.GA24749@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/08, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>>
>> * Rakib Mullick <rakib.mullick@gmail.com> wrote:
>>
>> > WARNING: arch/x86/kernel/built-in.o(.text+0x11b41): Section mismatch
>> > in reference from the variable ftrace_test_p6nop to the function
>> > .init.text:ftrace_dyn_arch_init()
>> > The function ftrace_test_p6nop() references
>> > the function __init ftrace_dyn_arch_init().
>> > This is often because ftrace_test_p6nop lacks a __init
>> > annotation or the annotation of ftrace_dyn_arch_init is wrong.
>> >
>> > WARNING: arch/x86/kernel/built-in.o(.text+0x11b4b): Section mismatch
>> > in reference from the variable ftrace_test_nop5 to the function
>> > .init.text:ftrace_dyn_arch_init()
>> > The function ftrace_test_nop5() references
>> > the function __init ftrace_dyn_arch_init().
>> > This is often because ftrace_test_nop5 lacks a __init
>> > annotation or the annotation of ftrace_dyn_arch_init is wrong.
>> >
>> > This patch fixes the above warnings. Introduced by
>> > 'linux-next.patch'(2.6.27-rc5-mm1-broken-out).
>> > Thanks.
>> >
>> > Signed-off-by: Md.Rakib H. Mullick(rakib.mullick@gmail.com)
>>
>> applied to tip/tracing/urgent, thanks!
>
> actually, this patch is wrong: the problem highlighted in that warning
> is that ftrace_test_p6nop is non-__init while ftrace_dyn_arch_init() is
> __init. So the proper solution is to mark ftrace_test_p6nop init as
> well. (it's an assembly label so thus slightly more complex than usual,
> but doable.)

Does the following solves the problem?
Thanks.

--- linux-2.6-orig/arch/x86/kernel/ftrace.c	2008-10-24 16:35:48.000000000 +0600
+++ linux-2.6/arch/x86/kernel/ftrace.c	2008-10-24 16:40:09.000000000 +0600
@@ -129,7 +129,7 @@ int __init ftrace_dyn_arch_init(void *da
 	asm volatile (
 		"jmp ftrace_test_jmp\n"
 		/* This code needs to stay around */
-		".section .text, \"ax\"\n"
+		".section .text.init, \"ax\"\n"
 		"ftrace_test_jmp:"
 		"jmp ftrace_test_p6nop\n"
 		"nop\n"

>
> 	Ingo
>
