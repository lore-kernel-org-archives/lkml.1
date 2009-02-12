Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbZBLBMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbZBLBMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 20:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbZBLBL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 20:11:58 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:7241 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbZBLBL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 20:11:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=uRHc4CpVPJAL34wZ7wWGKNgANh0ccXMM+Gz+bnCj2Ceox5KzZ7cWGUWmPIDZIeOWZy
         7S+zPJRwF/7CXqgKq4Tf6X3zdh8g8yQc8/Nww4WTEChdqkf2fi2I/Y3hJHQPorvXB+FX
         77k/7/i48IH+25U/vQn8oabPbyTHiDzCLCV74=
Message-ID: <49937766.4070102@gmail.com>
Date: Thu, 12 Feb 2009 10:12:06 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: Pass in pt_regs pointer for syscalls that	need
 it
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com> <1234277507-4987-3-git-send-email-brgerst@gmail.com> <4992812B.1050800@kernel.org> <73c1f2160902110631j68e58202h3e49288cfe613d66@mail.gmail.com> <4992E396.6000205@kernel.org> <4992E551.4060901@gmail.com> <73c1f2160902110659i776e1d89qc23d89363881572e@mail.gmail.com> <4992E92C.5000000@gmail.com> <73c1f2160902110710u77a563bftf09c460fab6f9136@mail.gmail.com> <4992EB62.3000501@gmail.com> <20090211155926.GA26194@elte.hu>
In-Reply-To: <20090211155926.GA26194@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Tejun Heo <htejun@gmail.com> wrote:
> 
>> Brian Gerst wrote:
>>> x86-64 doesn't have the tail-call problem because it doesn't use the
>>> pt_regs on stack trick for syscall args.  All the args are passed in
>>> registers.
>> Yeah, I was saying that we can do about the same thing on x86_32 by
>> passing in pointer to pt_regs and defining proper syscall wrappers.
>> It will cost a bit of performance by increasing register pressure tho.
> 
> Do you mean converting:
> 
> ptregscall int sys_execve(struct pt_regs *regs, char __user *u_filename,
>                           char __user * __user *argv,
>                           char __user * __user *envp)
> 
> to:
> 
> ptregscall int sys_execve(struct pt_regs *regs)
> {
> 	char __user *u_filename		= syscall_arg1(regs);
> 	char __user * __user *argv	= syscall_arg2(regs);
> 	char __user * __user *envp	= syscall_arg3(regs);
> 
> etc.?

Not exactly.  include/linux/syscalls.h already has syscall wrapping
macros defined, with slight modification to allow archs to define its
own __SC_DECL and __SC_LONG (probably should use different name tho),
the outer function can be easily defined to take pt_regs pointer and
pass in the correct argument to the actual implementation function.
The only added overhead would be pt_regs pointer having to be loaded
into %edi and it having to stay somewhere in the callee till the last
parameter access.

Thanks.

-- 
tejun
