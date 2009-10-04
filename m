Return-Path: <linux-kernel-owner+w=401wt.eu-S1758255AbZJDXG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255AbZJDXG5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 19:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757822AbZJDXG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 19:06:56 -0400
Received: from claw.goop.org ([74.207.240.146]:47154 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756098AbZJDXG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 19:06:56 -0400
Message-ID: <4AC92A65.40806@goop.org>
Date: Sun, 04 Oct 2009 16:06:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Bastian Blank <bastian@waldi.eu.org>, Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: Disable stack protector for irq helper
References: <20091004183013.GA26101@wavehammer.waldi.eu.org>
In-Reply-To: <20091004183013.GA26101@wavehammer.waldi.eu.org>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/09 11:30, Bastian Blank wrote:
> The stack protector needs additional registers on x86_32, which are not
> saved in calls to the small paravirt interrupt handlers. This leads to
> early crashes as registers are overwritten and not saved by the caller
> as instructed.
>   

Thanks for the patch, but I don't think its quite right.  
PV_CALLEE_SAVE_REGS_THUNK() is responsible for generating a wrapper for
the functions to save/restore all the appropriate registers.  If it is
failing to do so, then the correct fix is to update
PV_SAVE/RESTORE_ALL_CALLER_REGS.

Or have I misunderstood you analysis?

Thanks,
    J

> Signed-off-by: Bastian Blank <waldi@debian.org>
>
> diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
> index 3bb4fc2..ac19398 100644
> --- a/arch/x86/xen/Makefile
> +++ b/arch/x86/xen/Makefile
> @@ -5,9 +5,9 @@
>  CFLAGS_REMOVE_irq.o = -pg
>  endif
>  
> -# Make sure early boot has no stackprotector
>  nostackp := $(call cc-option, -fno-stack-protector)
>  CFLAGS_enlighten.o		:= $(nostackp)
> +CFLAGS_irq.o			:= $(nostackp)
>  CFLAGS_mmu.o			:= $(nostackp)
>  
>  obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
>   

