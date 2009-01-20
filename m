Return-Path: <linux-kernel-owner+w=401wt.eu-S1762637AbZATWHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762637AbZATWHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 17:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbZATWHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 17:07:34 -0500
Received: from cs20.apochromatic.org ([204.152.189.161]:60108 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbZATWHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 17:07:33 -0500
X-Greylist: delayed 3194 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Jan 2009 17:07:33 EST
From: Matt Fleming <matt@console-pimps.org>
To: linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>
Subject: [PATCH 2/2] sh: Use the atomic_t "counter" member
Date: Tue, 20 Jan 2009 21:14:38 +0000
Message-Id: <1232486078-11227-2-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1232486078-11227-1-git-send-email-matt@console-pimps.org>
References: <1232486078-11227-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that atomic_t is a generic opaque type for all architectures, it is
unwise to use intimate knowledge of its internals when manipulating it.

Instead of relying on the "counter" member being at offset 0 from the
beginning of an atomic_t, explicitly reference the member. This guards
us from any changes to the layout of the beginning of the atomic_t type.

Signed-off-by: Matt Fleming <matt@console-pimps.org>
---
 arch/sh/include/asm/atomic-irq.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/sh/include/asm/atomic-irq.h b/arch/sh/include/asm/atomic-irq.h
index 74f7943..a0b3480 100644
--- a/arch/sh/include/asm/atomic-irq.h
+++ b/arch/sh/include/asm/atomic-irq.h
@@ -11,7 +11,7 @@ static inline void atomic_add(int i, atomic_t *v)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	*(long *)v += i;
+	v->counter += i;
 	local_irq_restore(flags);
 }
 
@@ -20,7 +20,7 @@ static inline void atomic_sub(int i, atomic_t *v)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	*(long *)v -= i;
+	v->counter -= i;
 	local_irq_restore(flags);
 }
 
@@ -29,9 +29,9 @@ static inline int atomic_add_return(int i, atomic_t *v)
 	unsigned long temp, flags;
 
 	local_irq_save(flags);
-	temp = *(long *)v;
+	temp = v->counter;
 	temp += i;
-	*(long *)v = temp;
+	v->counter = temp;
 	local_irq_restore(flags);
 
 	return temp;
@@ -42,9 +42,9 @@ static inline int atomic_sub_return(int i, atomic_t *v)
 	unsigned long temp, flags;
 
 	local_irq_save(flags);
-	temp = *(long *)v;
+	temp = v->counter;
 	temp -= i;
-	*(long *)v = temp;
+	v->counter = temp;
 	local_irq_restore(flags);
 
 	return temp;
@@ -55,7 +55,7 @@ static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	*(long *)v &= ~mask;
+	v->counter &= ~mask;
 	local_irq_restore(flags);
 }
 
@@ -64,7 +64,7 @@ static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	*(long *)v |= mask;
+	v->counter |= mask;
 	local_irq_restore(flags);
 }
 
-- 
1.5.6.3

