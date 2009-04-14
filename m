Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbZDNPig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbZDNPig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755328AbZDNPhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:37:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:41363 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755267AbZDNPhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:37:53 -0400
Subject: Re: [PATCH -tip] x86: cpu_debug.c prepare report if files are less
 or more then expected
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090414134655.GD27163@elte.hu>
References: <1239711444.3079.13.camel@ht.satnam>
	 <20090414134655.GD27163@elte.hu>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 21:07:34 +0530
Message-Id: <1239723454.2966.1.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 15:46 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > This will prepare the report to update cpu_debug
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  arch/x86/include/asm/cpu_debug.h |    1 +
> >  arch/x86/kernel/cpu/cpu_debug.c  |   12 ++++++++++++
> >  2 files changed, 13 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/cpu_debug.h b/arch/x86/include/asm/cpu_debug.h
> > index 2228020..b64da5d 100644
> > --- a/arch/x86/include/asm/cpu_debug.h
> > +++ b/arch/x86/include/asm/cpu_debug.h
> > @@ -187,6 +187,7 @@ enum cpu_processor_bit {
> >  #define	CPU_ALL			(CPU_INTEL_ALL | CPU_AMD_ALL)
> >  
> >  #define MAX_CPU_FILES		512
> > +#define MIN_CPU_FILES		10
> >  
> >  struct cpu_private {
> >  	unsigned		cpu;
> > diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
> > index 46e29ab..1c3ebd4 100644
> > --- a/arch/x86/kernel/cpu/cpu_debug.c
> > +++ b/arch/x86/kernel/cpu/cpu_debug.c
> > @@ -838,6 +838,14 @@ static int cpu_init_allreg(unsigned cpu, struct dentry *dentry)
> >  	return err;
> >  }
> >  
> > +/* Send Report to maintainer if files are less or more then expected */ 
> > +static void send_report(int files, struct cpuinfo_x86 *cpui)
> > +{
> > +	pr_info("Please report \"cpu_debug files %d for %x:%x:%x:%x\" to"
> > +		" jaswinderrajput@gmail.com\n", files, cpui->x86_vendor,
> > +		cpui->x86, cpui->x86_model, cpui->x86_mask);
> 
> i'd rather see this reported to linux-kernel@vger.kernel.org, plus 
> please use a WARN_ONCE() instead of a pr_info(). Hitting this is a 
> bug we want to fix.
> 

Subject: [PATCH] x86: cpu_debug.c prepare report if files are less or more then expected

This will prepare the report to update cpu_debug

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpu_debug.h |    1 +
 arch/x86/kernel/cpu/cpu_debug.c  |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpu_debug.h b/arch/x86/include/asm/cpu_debug.h
index 2228020..b64da5d 100644
--- a/arch/x86/include/asm/cpu_debug.h
+++ b/arch/x86/include/asm/cpu_debug.h
@@ -187,6 +187,7 @@ enum cpu_processor_bit {
 #define	CPU_ALL			(CPU_INTEL_ALL | CPU_AMD_ALL)
 
 #define MAX_CPU_FILES		512
+#define MIN_CPU_FILES		10
 
 struct cpu_private {
 	unsigned		cpu;
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index 46e29ab..71e7f57 100644
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -30,6 +30,8 @@
 #include <asm/apic.h>
 #include <asm/desc.h>
 
+#define EMAIL	"<linux-kernel@vger.kernel.org>, <jaswinderrajput@gmail.com>"
+
 static DEFINE_PER_CPU(struct cpu_cpuX_base, cpu_arr[CPU_REG_ALL_BIT]);
 static DEFINE_PER_CPU(struct cpu_private *, priv_arr[MAX_CPU_FILES]);
 static DEFINE_PER_CPU(unsigned, cpu_modelflag);
@@ -838,6 +840,14 @@ static int cpu_init_allreg(unsigned cpu, struct dentry *dentry)
 	return err;
 }
 
+/* Prepare report for LKML and maintainer if files count are inappropriate */
+static void send_report(int files, struct cpuinfo_x86 *cpui)
+{
+	WARN_ONCE(1, "Please report \"cpu_debug files %d for %x:%x:%x:%x\" to"
+		  " %s\n", files, cpui->x86_vendor, cpui->x86, cpui->x86_model,
+		  cpui->x86_mask, EMAIL);
+}
+
 static int cpu_init_cpu(void)
 {
 	struct dentry *cpu_dentry = NULL;
@@ -861,9 +871,13 @@ static int cpu_init_cpu(void)
 
 		pr_info("cpu%d(%d) debug files %d\n",
 			cpu, nr_cpu_ids, per_cpu(cpu_priv_count, cpu));
+		if ((per_cpu(cpu_priv_count, cpu) < MIN_CPU_FILES))
+			send_report(per_cpu(cpu_priv_count, cpu), cpui);
+
 		if (per_cpu(cpu_priv_count, cpu) > MAX_CPU_FILES) {
 			pr_err("Register files count %d exceeds limit %d\n",
 				per_cpu(cpu_priv_count, cpu), MAX_CPU_FILES);
+			send_report(per_cpu(cpu_priv_count, cpu), cpui);
 			per_cpu(cpu_priv_count, cpu) = MAX_CPU_FILES;
 			err = -ENFILE;
 		}
-- 
1.6.0.6



