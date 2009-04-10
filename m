Return-Path: <linux-kernel-owner+w=401wt.eu-S938314AbZDJPMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938314AbZDJPMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 11:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761996AbZDJPM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 11:12:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34198 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbZDJPMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 11:12:25 -0400
Date: Fri, 10 Apr 2009 16:12:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] unbreak alpha percpu
Message-ID: <20090410151224.GM26366@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm-generic/percpu.h is *NOT* included by every asm/percpu.h out there.
Namely, alpha can't use it since it needs the var name in
SHIFT_PERCPU_PTR - &per_cpu_var(var) won't do at all.  So adding stuff
to asm-generic/percpu.h and expecting it to be picked by everything
is not going to work.

Frankly, I'd rather have SHIFT_PERCPU_PTR() calling conventions changed,
but for now the patch below will do.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/arch/alpha/include/asm/percpu.h b/arch/alpha/include/asm/percpu.h
index 3495e8e..fffec74 100644
--- a/arch/alpha/include/asm/percpu.h
+++ b/arch/alpha/include/asm/percpu.h
@@ -75,4 +75,30 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
 
 #define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu_var(name)
 
+# define percpu_read(var)						\
+  ({									\
+	typeof(per_cpu_var(var)) __tmp_var__;				\
+	__tmp_var__ = get_cpu_var(var);					\
+	put_cpu_var(var);						\
+	__tmp_var__;							\
+  })
+
+#define __percpu_generic_to_op(var, val, op)				\
+do {									\
+	get_cpu_var(var) op val;					\
+	put_cpu_var(var);						\
+} while (0)
+
+# define percpu_write(var, val)		__percpu_generic_to_op(var, (val), =)
+
+# define percpu_add(var, val)		__percpu_generic_to_op(var, (val), +=)
+
+# define percpu_sub(var, val)		__percpu_generic_to_op(var, (val), -=)
+
+# define percpu_and(var, val)		__percpu_generic_to_op(var, (val), &=)
+
+# define percpu_or(var, val)		__percpu_generic_to_op(var, (val), |=)
+
+# define percpu_xor(var, val)		__percpu_generic_to_op(var, (val), ^=)
+
 #endif /* __ALPHA_PERCPU_H */
