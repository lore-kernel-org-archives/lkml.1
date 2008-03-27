Return-Path: <linux-kernel-owner+w=401wt.eu-S1760262AbYC0Tsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760262AbYC0Tsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 15:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757753AbYC0Tsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 15:48:32 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:19848 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757425AbYC0Tsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 15:48:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=sPbrgogkGcdg8cVkMlzNLOQ9yiynbwwZhcLmDKxnoNbIPS6oGelcNWJ2UTpfccvle4ftrGNJS4c7B+4snexQjDBIv69cfydj66ib0c/lhfMpFGE7CMDxrWQhohEP4qB5SIo6SMu2AlDzRfZm0SEfUM7+pDH3zVUV16WN1sqDnpo=
Date: Thu, 27 Mar 2008 22:47:49 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: processor flags
Message-ID: <20080327194749.GA7633@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter, Ingo

could you spend a few minutes on me? ;)

You know, I'm almost complete changing the vm86 flags
with X86_EFLAGS_... but there is a hidden problem lays.
Look, in vm86.h we have the definition

#ifdef CONFIG_VM86
#define VM_MASK		0x00020000
#else
#define VM_MASK		0 /* ignored */
#endif

which has an indirect conditional compilation effect.
For example, if we take a look on include/asm-x86/ptrace.h

	static inline int v8086_mode(struct pt_regs *regs)
	{
	#ifdef CONFIG_X86_32
		return (regs->flags & VM_MASK);
	#else
		return 0;	/* No V86 mode support in long mode */
	#endif
	}

so if we don't have CONFIG_VM86 defined this function *always*
returning 0 so there I can't just change VM_MASK to X86_EFLAGS_VM.

Another piece of code from traps_32.c:do_general_protection

	if (regs->flags & VM_MASK)
		goto gp_in_vm86;

so if we didn't set CONFIG_VM86 i think this part is just thrown out
by gcc. So as we see, this VM_MASK original flag is not *just* a flag
but also says gcc which part of code to compile.

And now I'm in confusion - the way of changing this code I see is the
following:

- or use additional #ifdef CONFIG_VM86 in code where VM_MASK is used
  (that would be ugly IMHO)
- rename VM_MASK to say X86_EFLAGS_VM86 with that #ifdef remained
- rest VM_MASK as it is

How do you think?

		- Cyrill -
