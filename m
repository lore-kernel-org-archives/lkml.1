Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbYI2SE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbYI2SE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbYI2SC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:02:56 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36434 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753953AbYI2SCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:51 -0400
Message-Id: <20080929180250.287081000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:02:51 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 01/31] cpumask: Documentation
Content-Disposition: inline; filename=docs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 cpumask.txt |   73 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

--- /dev/null
+++ struct-cpumasks/cpumask.txt
@@ -0,0 +1,73 @@
+
+		CPUMASKS
+		--------
+
+	      [PRELIMINARY]
+
+Introduction
+
+Cpumask variables are used to represent (with a single bit) all the
+CPU's in a system.  With the prolific increase in the number of CPU's
+in a single system image (SSI), managing this large number of cpus has
+become an ordeal.  When the limit of CPU's in a system was small, the
+cpumask could fit within an integer.  Even with the increase to 128, a
+bit pattern was well within a managable size.  Now with systems available
+with 2048 cores, with hyperthreading, there are 4096 cpu threads.  And the
+number of cpus in an SSI is growing, 16,384 is right around the corner.
+Even desktop systems with only 2 or 4 sockets, a new generation of Intel
+processors that have 128 cores per socket will increase the count of CPU
+threads tremendously.
+
+Thus the handling of the cpumask that represents this 4096 limit needs
+512 bytes, putting pressure on the amount of stack space needed to
+accomodate temporary cpumask variables.
+
+The primary goal of the cpumasks API is to accomodate these large number
+of cpus without effecting the compactness of Linux for small, compact
+systems.
+
+
+The Changes
+
+Provide new cpumask interface API.  The relevant change is basically
+cpumask_t becomes an opaque object.  This should result in the minimum
+amount of modifications while still allowing the inline cpumask functions,
+and the ability to declare static cpumask objects.
+
+
+    /* raw declaration */
+    struct __cpumask_data_s { DECLARE_BITMAP(bits, NR_CPUS); };
+
+    /* cpumask_map_t used for declaring static cpumask maps */
+    typedef struct __cpumask_data_s cpumask_map_t[1];
+
+    /* cpumask_t used for function args and return pointers */
+    typedef struct __cpumask_data_s *cpumask_t;
+    typedef const struct __cpumask_data_s *const_cpumask_t;
+
+    /* cpumask_var_t used for local variable, definition follows */
+    typedef struct __cpumask_data_s	cpumask_var_t[1]; /* SMALL NR_CPUS */
+    typedef struct __cpumask_data_s	*cpumask_var_t;	  /* LARGE NR_CPUS */
+
+    /* replaces cpumask_t dst = (cpumask_t)src */
+    void cpus_copy(cpumask_t dst, const cpumask_t src);
+
+This removes the '*' indirection in all references to cpumask_t objects.
+You can change the reference to the cpumask object but to change the
+cpumask object itself you must use the functions that operate on cpumask
+objects (f.e. the cpu_* operators).  Functions can return a cpumask_t
+(which is a pointer to the cpumask object) and can only be passed a
+cpumask_t.
+
+All uses of a cpumask_t variable on the stack are changed to be cpumask_var_t
+except for pointers to static (read only) cpumask objects.  Allocation of
+local (temp) cpumask objects use the functions available in cpumask_alloc.h.
+(descriptions to be supplied.)
+
+All cpumask operators now operate using nr_cpu_ids instead of NR_CPUS.  All
+variants of the cpumask operators which used nr_cpu_ids instead of NR_CPUS
+have been deleted.
+
+All variants of functions which use the (old cpumask_t *) pointer have been
+deleted (f.e. set_cpus_allowed_ptr()).
+

-- 
