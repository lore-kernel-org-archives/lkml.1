Return-Path: <linux-kernel-owner+w=401wt.eu-S1753114AbZJUCdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbZJUCdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 22:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbZJUCdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 22:33:20 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:27756 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbZJUCdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 22:33:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=MSGahbdg7D5X28xYRr/iod3OOPe0R4Trlh1U20zzreRSsJ4fa2xjy01Fg+uXvCRZEN
         LK+8T8tfyl8VJEx5DoFyUlwEw2Tg85aaz3/UJQTDIic0ClbBrB/PQVnjq+BJt3u9ZozD
         m9efH7rzB4Q52/WP2Vhfdz+kzursV7f/zKRec=
Subject: Re: ftrace for MIPS
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: rostedt@goodmis.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Nicholas Mc Guire <der.herr@hofr.at>,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1256055714.18347.1608.camel@gandalf.stny.rr.com>
References: <1255995599.17795.15.camel@falcon>
	 <1255997319.18347.576.camel@gandalf.stny.rr.com>
	 <1256052667.8149.56.camel@falcon>
	 <1256055714.18347.1608.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Wed, 21 Oct 2009 10:33:15 +0800
Message-Id: <1256092395.5482.32.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

Just made it(function graph tracer for MIPS) work :-)

The problem is that: the stack offset should be from 0 to PT_SIZE(304),
but I mask it with 0xff(256), which is totally wrong.

Here is an example, the stack address of ra(return address) should be
(s8 + ffbf0128 & 0xfff).

ffffffff801dad10 <do_sync_read>:
ffffffff801dad10:       67bdfed0        daddiu  sp,sp,-304
ffffffff801dad14:       ffbe0120        sd      s8,288(sp)
ffffffff801dad18:       03a0f02d        move    s8,sp
ffffffff801dad1c:       ffbf0128        sd      ra,296(sp)
ffffffff801dad20:       ffb30118        sd      s3,280(sp)
ffffffff801dad24:       ffb20110        sd      s2,272(sp)
ffffffff801dad28:       ffb10108        sd      s1,264(sp)
ffffffff801dad2c:       ffb00100        sd      s0,256(sp)
ffffffff801dad30:       03e0082d        move    at,ra
ffffffff801dad34:       0c042ab0        jal     ffffffff8010aac0
<_mcount>
ffffffff801dad38:       00020021        nop

Thanks! will send the patches out later.

Regards,
	Wu Zhangjin

On Tue, 2009-10-20 at 12:21 -0400, Steven Rostedt wrote:
> On Tue, 2009-10-20 at 23:31 +0800, Wu Zhangjin wrote:
> 
> > Just added tracing_stop() and tracing_start() around
> 
> That seems a bit heavy handed. I still think writing it in "asm" the way
> x86 and powerpc do is the best.
> 
> > probe_kernel_read(), it works(not hang again), and i can get the stack
> > address of the ra register(return address) now, but failed when trying
> > to hijack the return address via writing &return_to_handler in the stack
> > address:
> > 
> > I can write hijack some of the addresses, but failed with this error at
> > last:
> > 
> > Unable to handle kernel paging request at 0000000000000000, epc =
> > 0000000000000000, ra = 000000000000.
> 
> hmm, looks like you jumped to "0"
> 
> > 
> > Need to check which registers is missing when saving/restoring for
> > _mcount:
> > 
> > 
> > NESTED(ftrace_graph_caller, PT_SIZE, ra) 
> >         MCOUNT_SAVE_REGS
> >         PTR_S   v0, PT_R2(sp)
> > 
> >         MCOUNT_SET_ARGS
> >         jal     prepare_ftrace_return
> >         nop
> > 
> >         /* overwrite the parent as &return_to_handler: v0 -> $1(at) */
> >         move    $1,     v0  
> 
> I'm confused here? I'm not exactly sure what the above is doing. Is $1 a
> register (AT)? And how is this register used before calling mcount?
> 
> > 
> >         PTR_L   v0, PT_R2(sp)
> >         MCOUNT_RESTORE_REGS
> >         RETURN_BACK
> >         END(ftrace_graph_caller)
> > 
> >         .align  2
> >         .globl  return_to_handler
> > return_to_handler:
> >         PTR_SUBU        sp, PT_SIZE
> >         PTR_S   v0, PT_R2(sp)
> 
> BTW, is v0 the only return register? I know x86 can return two different
> registers depending on what it returns. What happens if a function
> returns a 64 bit value on a 32bit box? Does it use two registers for
> that?
> 
> -- Steve
> 
> > 
> >         jal     ftrace_return_to_handler
> >         nop
> > 
> >         /* restore the real parent address: v0 -> ra */
> >         move    ra, v0
> > 
> >         PTR_L   v0, PT_R2(sp)
> >         PTR_ADDIU       sp, PT_SIZE
> > 
> >         jr      ra
> > 
> > ...
> > 
> >         .macro MCOUNT_SAVE_REGS
> >         PTR_SUBU        sp, PT_SIZE
> >         PTR_S   ra, PT_R31(sp)
> >         PTR_S   AT, PT_R1(sp)
> >         PTR_S   a0, PT_R4(sp)
> >         PTR_S   a1, PT_R5(sp)
> >         PTR_S   a2, PT_R6(sp)
> >         PTR_S   a3, PT_R7(sp)
> > #ifdef CONFIG_64BIT
> >         PTR_S   a4, PT_R8(sp)
> >         PTR_S   a5, PT_R9(sp)
> >         PTR_S   a6, PT_R10(sp)
> >         PTR_S   a7, PT_R11(sp)
> > #endif
> >         .endm
> > 
> >         .macro MCOUNT_RESTORE_REGS
> >         PTR_L   ra, PT_R31(sp)
> >         PTR_L   AT, PT_R1(sp)
> >         PTR_L   a0, PT_R4(sp)
> >         PTR_L   a1, PT_R5(sp)
> >         PTR_L   a2, PT_R6(sp)
> >         PTR_L   a3, PT_R7(sp)
> > #ifdef CONFIG_64BIT
> >         PTR_L   a4, PT_R8(sp)
> >         PTR_L   a5, PT_R9(sp)
> >         PTR_L   a6, PT_R10(sp)
> >         PTR_L   a7, PT_R11(sp)
> > #endif
> >         PTR_ADDIU       sp, PT_SIZE
> > 
> > Regards,
> > 	Wu Zhangjin
> > 
> 

