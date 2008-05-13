Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbYEMJa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbYEMJa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 05:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbYEMJaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 05:30:20 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:25640 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbYEMJaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 05:30:18 -0400
Date: Tue, 13 May 2008 11:28:21 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Andreas Schwab <schwab@suse.de>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>, Matthew Wilcox <matthew@wil.cx>,
       ARCH <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCHv3] Make for_each_cpu_mask a bit smaller
Message-ID: <20080513092821.GA20416@mailshack.com>
References: <20080511135039.GA3286@mailshack.com> <20080511091403.a75f5b78.pj@sgi.com> <20080511160658.GA3398@mailshack.com> <20080511160104.c3fef6bf.pj@sgi.com> <1210593896.23716.1252664185@webmail.messagingengine.com> <4828741B.2080802@sgi.com> <20080512190039.GA13324@mailshack.com> <jeej8742nt.fsf@sykes.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jeej8742nt.fsf@sykes.suse.de>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Tue, 13 May 2008 11:29:50 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.0.17; VDF: 7.0.4.29; host: AntiVir1)
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

On Mon, May 12, 2008, Andreas Schwab wrote:
> > +#define for_each_cpu_mask(cpu, mask)			\
> > +	for ((cpu) = ~((typeof(cpu))0);			\
> 
> There is no need for such a complicated expression, -1 will work for
> every (arithmetic) type.

Indeed, thanks.

This version applies on top of sched/latest.

This version reuses the already-existing api next_cpu instead
of inventing a new one; initializing the iteration counter to
-1 was suggested by Matthew Wilcox. Now with a -1 instead of
an overly carefull ~((typeof(cpu))0). "-1" is properly sign-
extended even if cpu is u64 in a 32-bit environment.

Greetings,
	Alexander

 include/linux/cpumask.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 73434e5..c24a556 100644
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
+	for ((cpu) = -1;				\
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
+	for ((cpu) = -1;				\
+		(cpu) = next_cpu_nr((cpu), (mask)),	\
+		(cpu) < nr_cpu_ids; )
 
 #endif /* NR_CPUS > 64 */
 
