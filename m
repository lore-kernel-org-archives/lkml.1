Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab0BNQhO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 11:37:14 -0500
Received: from mail-yw0-f179.google.com ([209.85.211.179]:35520 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab0BNQhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 11:37:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uVAXA5GGo5NdRTp5pScXyU4KJaQntiBCZYCbJDU6z64wTVd634Vok6TikqjSddbqZx
         yNeh6SuXbPwr+Qi2KKVJGzAa7DtWK3jvke1uXngOjA7PpNSuywOxojwSDGvwbe+bK5gi
         qApzESKvg+BZI6g/AxsT95fpDw6SbVrdjE280=
Date: Sun, 14 Feb 2010 22:08:11 +0530
From: Rabin Vincent <rabin@rab.in>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 06/10] ARM: ftrace: add Thumb-2 support
Message-ID: <20100214163811.GA4467@debian>
References: <1266090518-31120-1-git-send-email-rabin@rab.in>
 <1266090518-31120-7-git-send-email-rabin@rab.in>
 <4B773560.2060800@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B773560.2060800@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 13, 2010 at 11:27:28PM +0000, Catalin Marinas wrote:
> >diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
> >index 42eb166..cd2a574 100644
> >--- a/arch/arm/kernel/entry-common.S
> >+++ b/arch/arm/kernel/entry-common.S
> >@@ -156,7 +156,8 @@ ENTRY(__gnu_mcount_nc)
> > 	stmdb	sp!, {r0-r3, lr}
> > 	ldr	r0, =ftrace_trace_function
> > 	ldr	r2, [r0]
> >-	adr	r0, ftrace_stub
> >+ THUMB(	orr	r2, r2, #1		)
> >+	adr	r0, BSYM(ftrace_stub)
> > 	cmp	r0, r2
> 
> Does this code not give the correct result if not modified?

Without the BSYM, I get assembler errors:

entry-common.S: Assembler messages:
entry-common.S:179: Error: invalid immediate for address calculation (value = 0x00000004)

Without the orr, the lsb is not set on the pointer loaded from
ftrace_trace_function, but is set on BSYM(ftrace_stub), leading to the
comparison failing even when the pointer is pointing to ftrace_stub.

> 
> > 	bne	gnu_trace
> > 	ldmia	sp!, {r0-r3, ip, lr}
> >@@ -166,8 +167,9 @@ gnu_trace:
> > 	ldr	r1, [sp, #20]			@ lr of instrumented routine
> > 	mov	r0, lr
> > 	sub	r0, r0, #MCOUNT_INSN_SIZE
> >-	mov	lr, pc
> >-	mov	pc, r2
> >+ ARM(	mov	lr, pc			)
> >+ ARM(	mov	pc, r2			)
> >+ THUMB(	blx	r2			)
> > 	ldmia	sp!, {r0-r3, ip, lr}
> > 	mov	pc, ip
> > ENDPROC(__gnu_mcount_nc)
> 
> As above, what does this need modifying? "mov pc, r2" wouldn't
> change the mode to ARM even if the value in r2 is even. It may need
> THUMB(nop) after this instruction.

The "mov pc, r2" is not the problem.  The problem is the "mov lr, pc",
which does not set the lsb when storing the pc in lr.  The called
function returns with "bx lr", and the mode changes to ARM.  The blx is
to avoid this.

Rabin
