Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbYLKUoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbYLKUoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 15:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757297AbYLKUoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 15:44:15 -0500
Received: from relay1.sgi.com ([192.48.179.29]:38198 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756840AbYLKUoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 15:44:14 -0500
Message-ID: <49417B99.7090004@sgi.com>
Date: Thu, 11 Dec 2008 12:44:09 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@googlemail.com>,
       Ralf Baechle <ralf@linux-mips.org>, Tony Luck <tony.luck@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: [PATCH 1/1] cpumask: force nr_cpumask_bit to NR_CPUS for CPUMASK_OFFSTACK=n
References: <200812082136.33212.rusty@rustcorp.com.au> <493E4EE4.6010609@sgi.com> <200812101019.42908.rusty@rustcorp.com.au>
In-Reply-To: <200812101019.42908.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re: cpumask conversions, or not?

Rusty Russell wrote:
> On Tuesday 09 December 2008 21:26:36 Mike Travis wrote:
>> Rusty Russell wrote:
>>> Hi all,
>>>
>>>    The new cpumask conversions are going well, but unfortunately Stephen
>>> uncovered a nasty bug via linux-next: the new cpumask operators only go to
>>> nr_cpumask_bits which can be less than NR_CPUS if NR_CPUS > BITS_PER_LONG.
>>> The undefined bits confuse the old cpumask operators.  We fixed one case,
>>> but I am concerned that we will break archs as we convert more core code.
>> Hi Rusty,
>>
>> I think we can avoid this problem if we make cpumask_bits == NR_CPUS iff
>> CONFIG_CPUMASK_OFFSTACK=n.  This complies with the current cpumask_t
>> approach and should cause all cpumask operators to always operate on
>> all cpumask bits.
> 
> A very good point.  And it's no worse than the old method.
> 
> OK, forget about this for now, no urgent conversions needed :)
> Rusty.

This probably should be submitted through linux-next for wider test coverage?

Thanks,
Mike
---
cpumask: force nr_cpumask_bits to be NR_CPUS when CPUMASK_OFFSTACK is false

This maintains compatibility with the current cpumask_t.  Once an architecture
is "cpumask clean" [IOW, all references span 0..(nr_cpus_ids-1) only, ignoring
any bits >= nr_cpu_ids], then it can set CPUMASK_OFFSTACK=y.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask.h |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- linux-2.6-for-ingo.orig/include/linux/cpumask.h
+++ linux-2.6-for-ingo/include/linux/cpumask.h
@@ -510,9 +510,6 @@ extern cpumask_t cpu_active_map;
 	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD	\
 }
 
-/* This produces more efficient code. */
-#define nr_cpumask_bits	NR_CPUS
-
 #else /* NR_CPUS > BITS_PER_LONG */
 
 #define CPU_BITS_ALL						\
@@ -521,9 +518,20 @@ extern cpumask_t cpu_active_map;
 	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD		\
 }
 
-#define nr_cpumask_bits	nr_cpu_ids
 #endif /* NR_CPUS > BITS_PER_LONG */
 
+#ifndef CONFIG_CPUMASK_OFFSTACK
+
+/* This produces more efficient code. */
+#define nr_cpumask_bits	NR_CPUS
+
+#else
+
+/* This allows for variabled-sized cpumask's */
+#define nr_cpumask_bits	nr_cpu_ids
+
+#endif
+
 /* verify cpu argument to cpumask_* operators */
 static inline unsigned int cpumask_check(unsigned int cpu)
 {
