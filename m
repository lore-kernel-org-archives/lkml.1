Return-Path: <linux-kernel-owner+w=401wt.eu-S932667AbXAWDLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667AbXAWDLB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 22:11:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932091AbXAWDLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 22:11:01 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:2047 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932667AbXAWDLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 22:11:00 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: avi@qumranet.com (Avi Kivity), torvalds@osdl.org
Subject: Re: [PATCH 4/5] KVM: Fix asm constraints with CONFIG_FRAME_POINTER=n
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@osdl.org, mingo@elte.hu
Organization: Core
In-Reply-To: <20070111100630.55461250595@il.qumranet.com>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1H9C2q-0006ZQ-00@gondolin.me.apana.org.au>
Date: Tue, 23 Jan 2007 14:10:00 +1100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@qumranet.com> wrote:
> A "g" constraint may place a local variable in an %rsp-relative memory operand.
> but if your assembly changes %rsp, the operand points to the wrong location.
> 
> An "r" constraint fixes that.
> 
> Thanks to Ingo Molnar for neatly bisecting the problem.
> 
> Signed-off-by: Avi Kivity <avi@qumranet.com>
> 
> Index: linux-2.6/drivers/kvm/vmx.c
> ===================================================================
> --- linux-2.6.orig/drivers/kvm/vmx.c
> +++ linux-2.6/drivers/kvm/vmx.c
> @@ -1825,7 +1825,7 @@ again:
> #endif
>                "setbe %0 \n\t"
>                "popf \n\t"
> -             : "=g" (fail)
> +             : "=r" (fail)
>              : "r"(vcpu->launched), "d"((unsigned long)HOST_RSP),
>                "c"(vcpu),
>                [rax]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RAX])),

We need the following fix for 2.6.20.

[KVM] vmx: Fix register constraint in launch code

Both "=r" and "=g" breaks my build on i386:

$ make
  CC [M]  drivers/kvm/vmx.o
{standard input}: Assembler messages:
{standard input}:3318: Error: bad register name `%sil'
make[1]: *** [drivers/kvm/vmx.o] Error 1
make: *** [_module_drivers/kvm] Error 2

The reason is that setbe requires an 8-bit register but "=r" does not
constrain the target register to be one that has an 8-bit version on
i386.

According to

	http://gcc.gnu.org/bugzilla/show_bug.cgi?id=10153

the correct constraint is "=q".

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index ce219e3..0aa2659 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1824,7 +1824,7 @@ again:
 #endif
 		"setbe %0 \n\t"
 		"popf \n\t"
-	      : "=g" (fail)
+	      : "=q" (fail)
 	      : "r"(vcpu->launched), "d"((unsigned long)HOST_RSP),
 		"c"(vcpu),
 		[rax]"i"(offsetof(struct kvm_vcpu, regs[VCPU_REGS_RAX])),
