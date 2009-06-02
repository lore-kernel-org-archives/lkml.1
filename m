Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbZFBQPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbZFBQPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 12:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbZFBQPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 12:15:41 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:50232 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbZFBQPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 12:15:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rMtS4TfljHF2Hc8A8X4RWRsSxjnTpm7ecIoQAHEZcdVVOTQfzTM5CLTJgP2FJLffgQ
         VH/Ass61gQnXdZhPrNqbEADkYhUHbjG3/jqY0mOAl2t8J2LeChenLfoniQ9ZkJXWEmah
         fyRetmsxL+Jfu1VJluvWAEIy/LvBHTaPxkcys=
MIME-Version: 1.0
In-Reply-To: <4A22281B.7020908@windriver.com>
References: <cover.1243604390.git.wuzj@lemote.com>
	 <a00a91f6fc79b7d20b5b2193086e879dcafded46.1243604390.git.wuzj@lemote.com>
	 <4A22281B.7020908@windriver.com>
Date: Wed, 3 Jun 2009 00:15:42 +0800
Message-ID: <b00321320906020915n7ba241eqb3cb0de877af514d@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] mips dynamic function tracer support
From: wu zhangjin <wuzhangjin@gmail.com>
To: Wang Liming <liming.wang@windriver.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Wu Zhangjin <wuzj@lemote.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

sorry, I'm so late to reply your E-mail, a little busy these days.

On Sun, May 31, 2009 at 2:47 PM, Wang Liming <liming.wang@windriver.com> wrote:
> hi Wu,
>
> I have one question about dynamic ftrace support for modules on mips arch.
> I have also ported a dynamic ftrace of mips before, but when I using modules
> with dynamic ftrace enabled in mips, I have following error:
>
> # insmod ./usbcore
> module usbcore: relocation overflow
> insmod: cannot insert './usbcore.ko': invalid module format
> #
>
> I have no time to test your patch, but I think your patch also has this
> problem.
>
> Below I explain possibility of this problem in details:
>
> We know that on mips, kernel symbol will locate in 0x80000000~0x90000000,
> and modules' symbol will locate in >0xc0000000.
>
> On mips, gcc will insert following assembler code before every functions:
>
>    move    at,ra
>    jal     0 <usb_ifnum_to_if>
>    10: R_MIPS_26   _mcount
>
>
> Here "_mcount" is a kernel symbol in 0x80000000~0x90000000, for
> example at 0x8027a740.
>
> When loading a module, kernel should relocate "jal 0" instruction to jump to
> the kernel's "_mcount" address, 0x8027a740. But "jal 0" is a 26 bits offset
> jump
> instruction, it only can be relocated to jump to modules' symbol address
> space(>0xc0000000) and it can't be relocated to jump to kernel symbol
> address
> space(such as 0x8027a740), because offset is 32 bits(is 0xc0000000 -
> 0x80000000). We can't modify this instruction to jump to a 32 offset address
> except that we modify gcc compiler to insert other assembler codes.
>
> So, when installing modules, the kernel will try to relocate "jal 0"
> instruction
>  to instruction of jumping to >0xc0000000, but it finds that _mcount's
> address
> is 0x8027a740 and then print error indicated that it can't be reloacted.
>
> The following source code is the checking place:
>
>
> ----------arch/mips/kernel/module.c:apply_r_mips_26_rel()-------------------
>
> static int apply_r_mips_26_rel(struct module *me, u32 *location, Elf_Addr v)
> {
>    ...
>    if ((v & 0xf0000000) != (((unsigned long)location + 4) & 0xf0000000)) {
>                printk(KERN_ERR
>                       "module %s: relocation overflow, v:%x, location:%x\n",
>                       me->name, v, (unsigned long)location);
>                return -ENOEXEC;
>        }
>
>    *location = (*location & ~0x03ffffff) |
>                    ((*location + (v >> 2)) & 0x03ffffff);
>
> }
> ----------arch/mips/kernel/module.c:apply_r_mips_26_rel()-------------------
>
> v is kernel _mcount's address, location is the address of the instrution
> that should be relocated;
>
> To resolve this problem, we may need to do more work, either on gcc or on
> the kernel. So I want to hear your test result and if you have solution,
> please let me know.
>

yes, current version of mips-specific dynamic ftrace not support modules yet.

there is similar solution implemented in PowerPC(something named trampoline),
although I did not look into it, but I'm sure we can implement the
mips-specific one
via imitating it.

and currently, I'm planning to fix it in the -v3 of mips-specific
ftrace support.

best wishes,
Wu Zhangjin
