Return-Path: <linux-kernel-owner+w=401wt.eu-S1752726AbZIXFVC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbZIXFVC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 01:21:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbZIXFVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 01:21:01 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33961 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbZIXFVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 01:21:00 -0400
Date: Thu, 24 Sep 2009 15:21:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: ppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Beulich <JBeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hollis Blanchard <hollisb@us.ibm.com>, kvm-ppc@vger.kernel.org
Subject: linux-next: tree build failure
Message-Id: <20090924152102.8d7d40cf.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next build (powerpc ppc44x_defconfig) failed like this:

In file included from arch/powerpc/kvm/booke.c:31:
arch/powerpc/kvm/timing.h: In function 'kvmppc_account_exit_stat':
arch/powerpc/kvm/timing.h:51: error: bit-field '<anonymous>' width not an integer constant
In file included from arch/powerpc/kvm/booke.h:26,
                 from arch/powerpc/kvm/booke_emulate.c:23:
arch/powerpc/kvm/timing.h: In function 'kvmppc_account_exit_stat':
arch/powerpc/kvm/timing.h:51: error: bit-field '<anonymous>' width not an integer constant

Presumably caused by commit 8c87df457cb58fe75b9b893007917cf8095660a0
("BUILD_BUG_ON(): fix it and a couple of bogus uses of it").

I applied the following patch for today.  This inline function is
only called from one place in one file ...

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 24 Sep 2009 15:13:20 +1000
Subject: [PATCH] powerpc/kvm: build fix for new BUILD_BUG_ON

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/kvm/timing.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kvm/timing.h b/arch/powerpc/kvm/timing.h
index bb13b1f..4c34099 100644
--- a/arch/powerpc/kvm/timing.h
+++ b/arch/powerpc/kvm/timing.h
@@ -48,7 +48,7 @@ static inline void kvmppc_set_exit_type(struct kvm_vcpu *vcpu, int type) {}
 static inline void kvmppc_account_exit_stat(struct kvm_vcpu *vcpu, int type)
 {
 	/* type has to be known at build time for optimization */
-	BUILD_BUG_ON(__builtin_constant_p(type));
+	//BUILD_BUG_ON(__builtin_constant_p(type));
 	switch (type) {
 	case EXT_INTR_EXITS:
 		vcpu->stat.ext_intr_exits++;
-- 
1.6.4.3


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
