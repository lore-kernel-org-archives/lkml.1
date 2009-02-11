Return-Path: <linux-kernel-owner+w=401wt.eu-S1756398AbZBKObT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbZBKObT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 09:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbZBKObH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 09:31:07 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:10453 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbZBKObE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:31:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=A82v6rR3s2/nStgnLgXUMmx3M6nUpRg1vLRvPNLl8UX1wOusX/ZDw9g2Lp3ubxI1w0
         rkKQx8YGVYWgCYe8i83byD9YP1PQG4OxFhb3LY0VrEwMu2vQ0pilARVuMbxPnS0mq+nS
         +qG4mCYpIAD4EYUuaNXZYqyqzf3Po+mKvNiNA=
MIME-Version: 1.0
In-Reply-To: <4992812B.1050800@kernel.org>
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com>
	 <1234277507-4987-3-git-send-email-brgerst@gmail.com>
	 <4992812B.1050800@kernel.org>
Date: Wed, 11 Feb 2009 09:31:02 -0500
Message-ID: <73c1f2160902110631j68e58202h3e49288cfe613d66@mail.gmail.com>
Subject: Re: [PATCH 2/3] x86: Pass in pt_regs pointer for syscalls that need 
	it
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 2:41 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Brian.
>
> Brian Gerst wrote:
>> Some syscalls need to access the pt_regs structure, either to copy
>> user register state or to modifiy it.  This patch adds stubs to load
>> the address of the pt_regs struct into the %eax register, and changes
>> the syscalls to regparm(1) to receive the pt_regs pointer as the
>> first argument.
>
> Heh... neat.  Just one question.
>
>> -asmlinkage long sys_iopl(unsigned long regsp)
>> +ptregscall long sys_iopl(struct pt_regs *regs, unsigned int level)
>>  {
>> -     struct pt_regs *regs = (struct pt_regs *)&regsp;
>> -     unsigned int level = regs->bx;
>
> Here and at other places where the function takes more than one
> arguments, wouldn't it be better to just take *regs and use other
> parameters from regs?  That way we won't have to worry about gcc
> corrupting register frame at all and I think it's cleaner that way.

Expanding the parameters is good documentation.  If there is a risk of
tail-call optimization causing the register corruption, then
asmlinkage_protect() should be used.  The problem isn't limited to
just the syscalls that take pt_regs.  It's just getting the args out
of the pt_regs struct was an easy hack to get around it.  I checked
the disassembly of these functions and didn't see this happen on gcc
4.3.0.

--
Brian Gerst
