Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbZBCOp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbZBCOp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 09:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbZBCOpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 09:45:15 -0500
Received: from ozlabs.org ([203.10.76.45]:48601 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbZBCOpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 09:45:13 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] voyager: fix cpu bootmaps
Date: Wed, 4 Feb 2009 01:15:09 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <1233340317.3248.39.camel@localhost.localdomain> <200901312327.50684.rusty@rustcorp.com.au> <1233414293.3541.20.camel@localhost.localdomain>
In-Reply-To: <1233414293.3541.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200902040115.09755.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 February 2009 01:34:53 James Bottomley wrote:
> On Sat, 2009-01-31 at 23:27 +1030, Rusty Russell wrote:
> > On Saturday 31 January 2009 05:01:57 James Bottomley wrote:				       3) << 24;
> > > -	cpu_possible_map = phys_cpu_present_map;
> > > +	init_cpu_possible(&phys_cpu_present_map);
...
> > Strange, the assignment should still work, even though this new method is
> > preferred.
> 
> I know, it's weird ... it's like the compiler is copying to the lvalue
> but then discarding the result somehow

This makes me nervous.  I may have broken other archs.

I'm testing the following patch now.

Thanks,
Rusty.

cpumask: avoid cast-away-const for deprecated cpu_*_map.

James Bottomley encountered a Voyager bug where gcc was discarding
changes to cpu_possible_map, which is now #defined to
cpu_possible_mask with the const cast away.

The modern way is to use init_cpu_possible or set_cpu_possible, but
not everyone is converted yet.  I'm concerned that other archs might
have similar problems, so let's expose the underlying bits for the
moment (and prepend those names with __).

(This also makes accessing cpu_*_mask slightly more efficient, rather
than going via a pointer).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/cpumask.h |   28 +++++++++++++++++++---------
 kernel/cpu.c            |   44 ++++++++++++++++++++------------------------
 2 files changed, 39 insertions(+), 33 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -482,16 +482,26 @@ int __next_cpu_nr(int n, const cpumask_t
  *    only one CPU.
  */
 
-extern const struct cpumask *const cpu_possible_mask;
-extern const struct cpumask *const cpu_online_mask;
-extern const struct cpumask *const cpu_present_mask;
-extern const struct cpumask *const cpu_active_mask;
+#define cpu_possible_mask \
+	((const struct cpumask *)to_cpumask(__cpu_possible_bits))
+#define cpu_online_mask \
+	((const struct cpumask *)to_cpumask(__cpu_online_bits))
+#define cpu_present_mask \
+	((const struct cpumask *)to_cpumask(__cpu_present_bits))
+#define cpu_active_mask \
+	((const struct cpumask *)to_cpumask(__cpu_active_bits))
 
-/* These strip const, as traditionally they weren't const. */
-#define cpu_possible_map	(*(cpumask_t *)cpu_possible_mask)
-#define cpu_online_map		(*(cpumask_t *)cpu_online_mask)
-#define cpu_present_map		(*(cpumask_t *)cpu_present_mask)
-#define cpu_active_map		(*(cpumask_t *)cpu_active_mask)
+/* Deprecated non-const versions. */
+#define cpu_possible_map	(*to_cpumask(__cpu_possible_bits))
+#define cpu_online_map		(*to_cpumask(__cpu_online_bits))
+#define cpu_present_map		(*to_cpumask(__cpu_present_bits))
+#define cpu_active_map		(*to_cpumask(__cpu_active_bits))
+
+/* Don't use these directly: use cpu_*_mask, set_cpu_* or init_cpu_*. */
+extern unsigned long __cpu_possible_bits[];
+extern unsigned long __cpu_online_bits[];
+extern unsigned long __cpu_present_bits[];
+extern unsigned long __cpu_active_bits[];
 
 #if NR_CPUS > 1
 #define num_online_cpus()	cpumask_weight(cpu_online_mask)
diff --git a/kernel/cpu.c b/kernel/cpu.c
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -499,69 +499,65 @@ EXPORT_SYMBOL(cpu_all_bits);
 EXPORT_SYMBOL(cpu_all_bits);
 
 #ifdef CONFIG_INIT_ALL_POSSIBLE
-static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly
+DECLARE_BITMAP(__cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly
 	= CPU_BITS_ALL;
 #else
-static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly;
+DECLARE_BITMAP(__cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly;
 #endif
-const struct cpumask *const cpu_possible_mask = to_cpumask(cpu_possible_bits);
-EXPORT_SYMBOL(cpu_possible_mask);
+EXPORT_SYMBOL(__cpu_possible_bits);
 
-static DECLARE_BITMAP(cpu_online_bits, CONFIG_NR_CPUS) __read_mostly;
-const struct cpumask *const cpu_online_mask = to_cpumask(cpu_online_bits);
-EXPORT_SYMBOL(cpu_online_mask);
+DECLARE_BITMAP(__cpu_online_bits, CONFIG_NR_CPUS) __read_mostly;
+EXPORT_SYMBOL(__cpu_online_bits);
 
-static DECLARE_BITMAP(cpu_present_bits, CONFIG_NR_CPUS) __read_mostly;
-const struct cpumask *const cpu_present_mask = to_cpumask(cpu_present_bits);
-EXPORT_SYMBOL(cpu_present_mask);
+DECLARE_BITMAP(__cpu_present_bits, CONFIG_NR_CPUS) __read_mostly;
+EXPORT_SYMBOL(__cpu_present_bits);
 
-static DECLARE_BITMAP(cpu_active_bits, CONFIG_NR_CPUS) __read_mostly;
-const struct cpumask *const cpu_active_mask = to_cpumask(cpu_active_bits);
-EXPORT_SYMBOL(cpu_active_mask);
+DECLARE_BITMAP(__cpu_active_bits, CONFIG_NR_CPUS) __read_mostly;
+EXPORT_SYMBOL(__cpu_active_bits);
 
 void set_cpu_possible(unsigned int cpu, bool possible)
 {
 	if (possible)
-		cpumask_set_cpu(cpu, to_cpumask(cpu_possible_bits));
+		cpumask_set_cpu(cpu, to_cpumask(__cpu_possible_bits));
 	else
-		cpumask_clear_cpu(cpu, to_cpumask(cpu_possible_bits));
+		cpumask_clear_cpu(cpu, to_cpumask(__cpu_possible_bits));
 }
 
 void set_cpu_present(unsigned int cpu, bool present)
 {
 	if (present)
-		cpumask_set_cpu(cpu, to_cpumask(cpu_present_bits));
+		cpumask_set_cpu(cpu, to_cpumask(__cpu_present_bits));
 	else
-		cpumask_clear_cpu(cpu, to_cpumask(cpu_present_bits));
+		cpumask_clear_cpu(cpu, to_cpumask(__cpu_present_bits));
 }
 
 void set_cpu_online(unsigned int cpu, bool online)
 {
 	if (online)
-		cpumask_set_cpu(cpu, to_cpumask(cpu_online_bits));
+		cpumask_set_cpu(cpu, to_cpumask(__cpu_online_bits));
 	else
-		cpumask_clear_cpu(cpu, to_cpumask(cpu_online_bits));
+		cpumask_clear_cpu(cpu, to_cpumask(__cpu_online_bits));
 }
 
 void set_cpu_active(unsigned int cpu, bool active)
 {
 	if (active)
-		cpumask_set_cpu(cpu, to_cpumask(cpu_active_bits));
+		cpumask_set_cpu(cpu, to_cpumask(__cpu_active_bits));
 	else
-		cpumask_clear_cpu(cpu, to_cpumask(cpu_active_bits));
+		cpumask_clear_cpu(cpu, to_cpumask(__cpu_active_bits));
 }
 
 void init_cpu_present(const struct cpumask *src)
 {
-	cpumask_copy(to_cpumask(cpu_present_bits), src);
+	cpumask_copy(to_cpumask(__cpu_present_bits), src);
 }
 
 void init_cpu_possible(const struct cpumask *src)
 {
-	cpumask_copy(to_cpumask(cpu_possible_bits), src);
+	cpumask_copy(to_cpumask(__cpu_possible_bits), src);
 }
 
 void init_cpu_online(const struct cpumask *src)
 {
-	cpumask_copy(to_cpumask(cpu_online_bits), src);
+	cpumask_copy(to_cpumask(__cpu_online_bits), src);
 }


