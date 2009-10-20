Return-Path: <linux-kernel-owner+w=401wt.eu-S1752535AbZJTPbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbZJTPbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 11:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbZJTPbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 11:31:14 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:42486 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZJTPbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 11:31:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=AigYUXnuH5q91a+fk3eWVM7RnwGQWV16xt0LYpa0fchRhUNSFsMjIEkfePKclbGL33
         TY6KcOuaa1qt9Us/oPa7uLUfgL0+7cKnn7gpG+fVp7avVRAMVLE1GHkfChq6LjtDwydG
         R/OnVnHTn7uXs4PV001rn14MZxJ6Jt368GEHw=
Subject: Re: ftrace for MIPS
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: rostedt@goodmis.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Nicholas Mc Guire <der.herr@hofr.at>,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1255997319.18347.576.camel@gandalf.stny.rr.com>
References: <1255995599.17795.15.camel@falcon>
	 <1255997319.18347.576.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Tue, 20 Oct 2009 23:31:07 +0800
Message-Id: <1256052667.8149.56.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

added CC to linux-mips and lkml.

> On Tue, 2009-10-20 at 07:39 +0800, Wu Zhangjin wrote:
> 
> > 3. to handle the non-leaf function(hijack the return address), we need
> > to get the stack address of the return address, but it's not easy to get
> > it in MIPS, search the return address in the stack space is not
> > reliable, searching the text is dangerous(pagefault..., have tried
> > probe_kernel_read(), just hang there!), so, a clean solution maybe
> > hacking gcc via pushing ra to 0(sp) or another "fixed"(fixed offset)
> > stack address or recording the offset and transfer it to _mcount.
> 
> Have you figured out why you can't find the text? If mcount is called,
> you most definitely must have stored ra somewhere.
> 
> As for the hang with probe kernel read, I wonder if you need to disable
> tracing before using it. Or at least have a way not to recurs. I'm
> looking at probe_kernel_read, and it looks like it would also be traced.
> 
> Looking at x86 and powerpc, we hand do the probing.
> 

Just added tracing_stop() and tracing_start() around
probe_kernel_read(), it works(not hang again), and i can get the stack
address of the ra register(return address) now, but failed when trying
to hijack the return address via writing &return_to_handler in the stack
address:

I can write hijack some of the addresses, but failed with this error at
last:

Unable to handle kernel paging request at 0000000000000000, epc =
0000000000000000, ra = 000000000000.

Need to check which registers is missing when saving/restoring for
_mcount:


NESTED(ftrace_graph_caller, PT_SIZE, ra) 
        MCOUNT_SAVE_REGS
        PTR_S   v0, PT_R2(sp)

        MCOUNT_SET_ARGS
        jal     prepare_ftrace_return
        nop

        /* overwrite the parent as &return_to_handler: v0 -> $1(at) */
        move    $1,     v0  

        PTR_L   v0, PT_R2(sp)
        MCOUNT_RESTORE_REGS
        RETURN_BACK
        END(ftrace_graph_caller)

        .align  2
        .globl  return_to_handler
return_to_handler:
        PTR_SUBU        sp, PT_SIZE
        PTR_S   v0, PT_R2(sp)

        jal     ftrace_return_to_handler
        nop

        /* restore the real parent address: v0 -> ra */
        move    ra, v0

        PTR_L   v0, PT_R2(sp)
        PTR_ADDIU       sp, PT_SIZE

        jr      ra

...

        .macro MCOUNT_SAVE_REGS
        PTR_SUBU        sp, PT_SIZE
        PTR_S   ra, PT_R31(sp)
        PTR_S   AT, PT_R1(sp)
        PTR_S   a0, PT_R4(sp)
        PTR_S   a1, PT_R5(sp)
        PTR_S   a2, PT_R6(sp)
        PTR_S   a3, PT_R7(sp)
#ifdef CONFIG_64BIT
        PTR_S   a4, PT_R8(sp)
        PTR_S   a5, PT_R9(sp)
        PTR_S   a6, PT_R10(sp)
        PTR_S   a7, PT_R11(sp)
#endif
        .endm

        .macro MCOUNT_RESTORE_REGS
        PTR_L   ra, PT_R31(sp)
        PTR_L   AT, PT_R1(sp)
        PTR_L   a0, PT_R4(sp)
        PTR_L   a1, PT_R5(sp)
        PTR_L   a2, PT_R6(sp)
        PTR_L   a3, PT_R7(sp)
#ifdef CONFIG_64BIT
        PTR_L   a4, PT_R8(sp)
        PTR_L   a5, PT_R9(sp)
        PTR_L   a6, PT_R10(sp)
        PTR_L   a7, PT_R11(sp)
#endif
        PTR_ADDIU       sp, PT_SIZE

Regards,
	Wu Zhangjin

