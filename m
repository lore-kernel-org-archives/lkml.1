Return-Path: <linux-kernel-owner+w=401wt.eu-S1758763AbZFAQ4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763AbZFAQ4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 12:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758577AbZFAQ4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 12:56:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53218 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758506AbZFAQ4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 12:56:37 -0400
Message-ID: <4A2407D1.5050706@zytor.com>
Date: Mon, 01 Jun 2009 09:54:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Borislav Petkov <petkovbb@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Borislav Petkov <borislav.petkov@amd.com>, greg@kroah.com,
       mingo@elte.hu, norsk5@yahoo.com, tglx@linutronix.de, mchehab@redhat.com,
       aris@redhat.com, edt@aei.ca, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
CC: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 0/4] amd64_edac: misc fixes
References: <1242845037-1029-1-git-send-email-borislav.petkov@amd.com> <20090528164720.0af5752b.akpm@linux-foundation.org> <20090529103329.GB23530@aftab> <20090529130115.a44efaee.akpm@linux-foundation.org> <20090530081954.GA21954@liondog.tnic> <20090530014007.3c1e22d5.akpm@linux-foundation.org> <4A218761.5080607@zytor.com> <20090601145326.GA28260@liondog.tnic>
In-Reply-To: <20090601145326.GA28260@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> 
> How about we pin the src/dst into a register:
> 
> #define popcnt_spelled(x)                                       \
> ({                                                              \
>         typeof(x) __ret;                                        \
>         __asm__(".byte 0xf3\n\t.byte 0x48\n\t.byte 0x0f\n\t"    \
>                 ".byte 0xb8\n\t.byte 0xc0\n\t"                  \
>                 : "=a" (__ret)                                  \
>                 : "0" (x));                                     \
>         __ret;                                                  \
> })
> 
> which generates
> 
>   40055e:       48 8b 45 e8             mov    -0x18(%rbp),%rax
>   400562:       f3 48 0f b8 c0          popcnt %rax,%rax
>   400567:       48 89 45 f8             mov    %rax,-0x8(%rbp)
> 
> here.
> 

Yes, we would have to do something like that.

However, if you're doing that you shouldn't use typeof() there...
instead this should be turned into an inline function with explicit
64-bit types.

It would be good if we could get Kbuild to export some kind of macro
that we can use to test binutils version, so we can do something like:

#if BINUTILS_VERSION >= KERNEL_VERSION(2,18,50)
/* Do the right thing */
#else
/* Do the wrong thing */
#endif

> For < 64bit operand sizes, the operands get zero-extended so that
> garbage in the high 32/48 bits of %rax doesn't corrupt the result.
> We might even want to do the movzwq explicitly so that some compiler
> doesn't decide to take the version with the "0f b6" opcode which
> zero-extends only the 16-/32-bit register. This way, you can popcnt even
> single bytes although the popcnt implementation doesn't allow single
> byte operands.
> 
>   400572:       0f b7 45 f2             movzwl -0xe(%rbp),%eax
>   400579:       f3 48 0f b8 c0          popcnt %rax,%rax
>   40057e:       66 89 45 f6             mov    %ax,-0xa(%rbp)
> 
> 
> So, in addition to popcnt itself, we have two movs added. This is still
> less than the 30+ ops (+ function call overhead) that hweight* get
> translated into. I'll redo my kernel build benchmarks tomorrow to get
> some more recent numbers on the performance gain.

With explicit types, the compiler should do the right thing.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

