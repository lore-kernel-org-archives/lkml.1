Return-Path: <linux-kernel-owner+w=401wt.eu-S932689AbZFQFEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689AbZFQFEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 01:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932671AbZFQFEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 01:04:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34096 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932670AbZFQFEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 01:04:24 -0400
Date: Wed, 17 Jun 2009 15:04:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       <linuxppc-dev@ozlabs.org>
Subject: linux-next: kvm/powerpc tree build failure
Message-Id: <20090617150419.e406a69a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi, Ben,

Today's linux-next build (powerpc ppc44x_defconfig) failed like this:

cc1: warnings being treated as errors
arch/powerpc/kvm/../../../virt/kvm/kvm_main.c: In function '__kvm_set_memory_region':
arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:1178: error: integer overflow in expression

Probably caused by commit ac04527f7947020c5890090b2ac87af4e98d977e ("KVM:
Disable large pages on misaligned memory slots"). The build fails because
arch/powerpc is now being built (mostly) with -Werror.

arch/powerpc/include/asm/kvm_host.h:#define KVM_PAGES_PER_HPAGE (1<<31)

this needs to be (1UL << 31) or ((unsigned int)1 << 31).

I applied the following patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 17 Jun 2009 14:57:29 +1000
Subject: [PATCH] kvm/powerpc: make 32 bit constant unsigned long

KVM_PAGES_PER_HPAGE needs to be unsigned long since its value is 2^31.

Eliminates this compiler warning:

arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:1178: error: integer overflow in expression

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/include/asm/kvm_host.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 3625424..d4caa61 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -34,7 +34,7 @@
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 
 /* We don't currently support large pages. */
-#define KVM_PAGES_PER_HPAGE (1<<31)
+#define KVM_PAGES_PER_HPAGE (1UL << 31)
 
 struct kvm;
 struct kvm_run;
-- 
1.6.3.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
