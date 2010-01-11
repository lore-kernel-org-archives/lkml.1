Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530Ab0AKIVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab0AKIVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 03:21:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251Ab0AKIVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 03:21:09 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57128 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196Ab0AKIVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 03:21:08 -0500
Date: Mon, 11 Jan 2010 19:21:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexander Graf <agraf@suse.de>
Subject: Re: linux-next: kvm tree build failure
Message-Id: <20100111192105.304382e4.sfr@canb.auug.org.au>
In-Reply-To: <20100111190749.0a74d445.Stephen@Rothwell.id.au>
References: <20100111190749.0a74d445.Stephen@Rothwell.id.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi,

On Mon, 11 Jan 2010 19:07:49 +1100 Stephen Rothwell <Stephen@Rothwell.id.au> wrote:
>
> Caused by commit 7f31fad9aad3bb9df95793d72e037bb4d587ee83 ("KVM: PPC: Use
> accessor functions for GPR access").  I couldn't easily revert that
> commit, so I applied the following fixup patch instead.

After which I got this:

arch/powerpc/kvm/built-in.o: In function `kvmppc_handler_0':
(.text+0x69ba): undefined reference to `VCPU_GPRS'
arch/powerpc/kvm/built-in.o: In function `kvmppc_handler_0':
(.text+0x69be): undefined reference to `VCPU_GPRS'
arch/powerpc/kvm/built-in.o: In function `kvmppc_handler_1':
(.text+0x69e6): undefined reference to `VCPU_GPRS'
arch/powerpc/kvm/built-in.o: In function `kvmppc_handler_1':
(.text+0x69ea): undefined reference to `VCPU_GPRS'
arch/powerpc/kvm/built-in.o: In function `kvmppc_handler_2':
(.text+0x6a12): undefined reference to `VCPU_GPRS'
arch/powerpc/kvm/built-in.o:(.text+0x6a16): more undefined references to `VCPU_GPRS' follow

Caused by commit f38ae173fffd673d4bc5cb4062d9dc27146cfb4a ("KVM: PPC: Use
PACA backed shadow vcpu").  I have applied the following fixup patch for
today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 11 Jan 2010 19:15:02 +1100
Subject: [PATCH] kvm: another PPC fixup (asm-offsets)

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/kernel/asm-offsets.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index be90ced..16dab65 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -437,11 +437,11 @@ int main(void)
 	DEFINE(VCPU_HIGHMEM_HANDLER, offsetof(struct kvm_vcpu, arch.highmem_handler));
 	DEFINE(VCPU_RMCALL, offsetof(struct kvm_vcpu, arch.rmcall));
 	DEFINE(VCPU_HFLAGS, offsetof(struct kvm_vcpu, arch.hflags));
-	DEFINE(VCPU_GPRS, offsetof(struct kvm_vcpu, arch.gpr));
 #else
 	DEFINE(VCPU_CR, offsetof(struct kvm_vcpu, arch.cr));
 	DEFINE(VCPU_XER, offsetof(struct kvm_vcpu, arch.xer));
 #endif /* CONFIG_PPC64 */
+	DEFINE(VCPU_GPRS, offsetof(struct kvm_vcpu, arch.gpr));
 #endif
 #ifdef CONFIG_44x
 	DEFINE(PGD_T_LOG2, PGD_T_LOG2);
-- 
1.6.5.7


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
