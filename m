Return-Path: <linux-kernel-owner+w=401wt.eu-S1758562AbYFYEjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbYFYEjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbYFYEhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:16 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37449 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753294AbYFYEhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:12 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 03 of 36] x86: add memory barriers to wrmsr
X-Mercurial-Node: 93c7057b1f4acae501b2e5699f97dc6910a8b657
Message-Id: <93c7057b1f4acae501b2.1214367539@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:18:59 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wrmsr is a special instruction which can have arbitrary system-wide
effects.  We don't want the compiler to reorder it with respect to
memory operations, so make it a memory barrier.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/msr.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/msr.h b/include/asm-x86/msr.h
--- a/include/asm-x86/msr.h
+++ b/include/asm-x86/msr.h
@@ -66,7 +66,7 @@
 static inline void native_write_msr(unsigned int msr,
 				    unsigned low, unsigned high)
 {
-	asm volatile("wrmsr" : : "c" (msr), "a"(low), "d" (high));
+	asm volatile("wrmsr" : : "c" (msr), "a"(low), "d" (high) : "memory");
 }
 
 static inline int native_write_msr_safe(unsigned int msr,
@@ -81,7 +81,8 @@
 		     _ASM_EXTABLE(2b, 3b)
 		     : "=a" (err)
 		     : "c" (msr), "0" (low), "d" (high),
-		     "i" (-EFAULT));
+		       "i" (-EFAULT)
+		     : "memory");
 	return err;
 }
 


