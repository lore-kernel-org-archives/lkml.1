Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbZJZD4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbZJZD4H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 23:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbZJZD4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 23:56:05 -0400
Received: from ozlabs.org ([203.10.76.45]:55541 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648AbZJZD4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 23:56:03 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Johannes Stezenbach <js@sig21.net>
Subject: Re: [Lguest] 2.6.32-rc5 guest crash
Date: Mon, 26 Oct 2009 14:26:04 +1030
User-Agent: KMail/1.11.2 (Linux/2.6.28-16-generic; KDE/4.2.2; i686; ; )
Cc: lguest@ozlabs.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
References: <20091025175521.GA13300@sig21.net>
In-Reply-To: <20091025175521.GA13300@sig21.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910261426.05769.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Oct 2009 04:25:21 am Johannes Stezenbach wrote:
> Hi,
> 
> I'm using linux-2.6.32-rc5-81-g964fe08 as both host and guest,
> and the guest crashes on boot:
> 
> Calibrating delay loop... 
> general protection fault: 0000 [#1] PREEMPT SMP 
> last sysfs file: 
> Modules linked in:
> 
> Pid: 0, comm: swapper Not tainted (2.6.32-rc5 #1) 
> EIP: 0061:[<c11f915d>] EFLAGS: 00010046 CPU: 0
> EIP is at cmpxchg8b_emu+0x1/0x12

OK, it's the non-paravirt "cli" we're breaking on (the pushfl is bad too).

This is because alternatives haven't been subbed yet.  The Right Thing is to
make this asm code paravirt aware.  The Easy Thing is to fix this code to
only get included when we're actually compiling for a 386 or 486 (this was
introduced with the original pentium AFAICT).

How's this Ingo, Arjan?

Subject: x86: sidestep lguest problem by only building cmpxchg8b_emu for pre-Pentium

Arjen's 79e1dd05d1a22 "x86: Provide an alternative() based cmpxchg64()" broke
lguest, even on systems which have cmpxchg8b support.  The emulation code
gets used until alternatives get run, but it contains native instructions,
not their paravirt alternatives.

The simplest fix is to turn this code off except for 386 and 486 builds.

Reported-by: Johannes Stezenbach <js@sig21.net>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -400,7 +400,7 @@ config X86_TSC
 
 config X86_CMPXCHG64
 	def_bool y
-	depends on X86_PAE || X86_64 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MATOM
+	depends on !M386 && !M486
 
 # this should be set for all -march=.. options where the compiler
 # generates cmov.



