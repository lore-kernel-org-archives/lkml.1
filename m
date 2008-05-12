Return-Path: <linux-kernel-owner+w=401wt.eu-S1758097AbYELTEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbYELTEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 15:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756719AbYELTDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 15:03:51 -0400
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:2644 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710AbYELTDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 15:03:50 -0400
Date: Mon, 12 May 2008 21:00:39 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>, Matthew Wilcox <matthew@wil.cx>,
       ARCH <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCHv2] Make for_each_cpu_mask a bit smaller
Message-ID: <20080512190039.GA13324@mailshack.com>
References: <20080511135039.GA3286@mailshack.com> <20080511091403.a75f5b78.pj@sgi.com> <20080511160658.GA3398@mailshack.com> <20080511160104.c3fef6bf.pj@sgi.com> <1210593896.23716.1252664185@webmail.messagingengine.com> <4828741B.2080802@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4828741B.2080802@sgi.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Mon, 12 May 2008 21:02:48 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.0.17; VDF: 7.0.4.27; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The for_each_cpu_mask loop is used quite often in the kernel. It
makes use of two functions: first_cpu and next_cpu. This patch
changes for_each_cpu_mask to use only the latter. Because next_cpu
finds the next eligible cpu _after_ the given one, the iteration
variable has to be initialized to -1 and next_cpu has to be
called with this value before the first iteration. An x86_64
defconfig kernel (from sched/latest) is about 2500 bytes smaller
with this patch applied:

   text	   data	    bss	    dec	    hex	filename
6222517	 917952	 749932	7890401	 7865e1	vmlinux.orig
6219922	 917952	 749932	7887806	 785bbe	vmlinux

The same size reduction is seen for defconfig+MAXSMP

   text	   data	    bss	    dec	    hex	filename
6241772	2563968	1492716	10298456	 9d2458	vmlinux.orig
6239211	2563968	1492716	10295895	 9d1a57	vmlinux

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

Hello Mike, Ingo,

Here is a version of the for_each_cpu_mask change that applies on
top of sched/latest. I think it is non-intrusive enough to put
it in sched/latest?

This version reuses the already-existing api next_cpu instead
of inventing a new one; initializing the iteration counter to
-1 was suggested by Matthew Wilcox.

Greetings,
	Alexander

 include/linux/cpumask.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 73434e5..74b748b 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -377,10 +377,10 @@ int __any_online_cpu(const cpumask_t *mask);
 #define first_cpu(src)		__first_cpu(&(src))
 #define next_cpu(n, src)	__next_cpu((n), &(src))
 #define any_online_cpu(mask) __any_online_cpu(&(mask))
-#define for_each_cpu_mask(cpu, mask)		\
-	for ((cpu) = first_cpu(mask);		\
-		(cpu) < NR_CPUS;		\
-		(cpu) = next_cpu((cpu), (mask)))
+#define for_each_cpu_mask(cpu, mask)			\
+	for ((cpu) = ~((typeof(cpu))0);			\
+		(cpu) = next_cpu((cpu), (mask)),	\
+		(cpu) < NR_CPUS; )
 #endif
 
 #if NR_CPUS <= 64
@@ -394,10 +394,10 @@ int __any_online_cpu(const cpumask_t *mask);
 int __next_cpu_nr(int n, const cpumask_t *srcp);
 #define next_cpu_nr(n, src)	__next_cpu_nr((n), &(src))
 #define cpus_weight_nr(cpumask)	__cpus_weight(&(cpumask), nr_cpu_ids)
-#define for_each_cpu_mask_nr(cpu, mask)		\
-	for ((cpu) = first_cpu(mask);		\
-		(cpu) < nr_cpu_ids;		\
-		(cpu) = next_cpu_nr((cpu), (mask)))
+#define for_each_cpu_mask_nr(cpu, mask)			\
+	for ((cpu) = ~((typeof(cpu))0);			\
+		(cpu) = next_cpu_nr((cpu), (mask)),	\
+		(cpu) < nr_cpu_ids; )
 
 #endif /* NR_CPUS > 64 */
 
