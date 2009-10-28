Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbZJ1Pfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbZJ1Pfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 11:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbZJ1Pfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 11:35:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505AbZJ1Pfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 11:35:53 -0400
From: Chris Lalancette <clalance@redhat.com>
To: mingo@elte.hu
Cc: x86@kernel.org, mingo@redhat.com, kvm@vger.kernel.org, pbonzini@redhat.com,
       linux-kernel@vger.kernel.org, Chris Lalancette <clalance@redhat.com>
Subject: [PATCH] x86: Make sure get_user_desc() doesn't sign extend.
Date: Wed, 28 Oct 2009 16:35:27 +0100
Message-Id: <1256744127-9056-1-git-send-email-clalance@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation of get_user_desc() sign extends
the return value because of integer promotion rules.  For
the most part, this doesn't matter, because the top bit of
base2 is usually 0.  If, however, that bit is 1, then the
entire value will be 0xffff... which is probably not what
the caller intended.  This patch casts the entire thing
to unsigned before returning, which generates almost the
same assembly as the current code but replaces the final
"cltq" (sign extend) with a "mov %eax %eax" (zero-extend).
This fixes booting certain guests under KVM.

(2nd resend, since no response to the last two submissions)

Signed-off-by: Chris Lalancette <clalance@redhat.com>
---
 arch/x86/include/asm/desc.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index e8de2f6..617bd56 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -288,7 +288,7 @@ static inline void load_LDT(mm_context_t *pc)
 
 static inline unsigned long get_desc_base(const struct desc_struct *desc)
 {
-	return desc->base0 | ((desc->base1) << 16) | ((desc->base2) << 24);
+	return (unsigned)(desc->base0 | ((desc->base1) << 16) | ((desc->base2) << 24));
 }
 
 static inline void set_desc_base(struct desc_struct *desc, unsigned long base)
-- 
1.6.0.6

