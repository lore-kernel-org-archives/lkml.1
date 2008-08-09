Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbYHIWgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbYHIWgD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 18:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbYHIWft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 18:35:49 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:35478 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbYHIWfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 18:35:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=C+wuuQZhi+C80iO/ZdB1keYH0EypDz0QoRG2A954GtCICeZR3mctEirzA/MJwhGTjW
         VqjURec/ucdTOc22jMRdBWH6YAK4so++0MyDFjusPgtD5Kb7V3JPN13KtziNcAqEAS+h
         fpr4SY4rfDdRhU/gEmW42BFU+K2M0X5F4NLXA=
Message-ID: <86802c440808091535g394f0567x675dbb93d1a8f91@mail.gmail.com>
Date: Sat, 9 Aug 2008 15:35:46 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 08/42] introduce nr_irqs
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m1bq01uavp.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
	 <1218232368-31228-8-git-send-email-yhlu.kernel@gmail.com>
	 <1218232368-31228-9-git-send-email-yhlu.kernel@gmail.com>
	 <m1ej4zvw6s.fsf@frodo.ebiederm.org>
	 <86802c440808081838r66cc8162t5c2e157908457048@mail.gmail.com>
	 <489CFA0A.5030609@zytor.com>
	 <86802c440808090030k7269590ftf233a13a21a2e37e@mail.gmail.com>
	 <m14p5uuqh3.fsf@frodo.ebiederm.org>
	 <86802c440808091421n50fd4b25i73e1bd00d7a8a67e@mail.gmail.com>
	 <m1bq01uavp.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 9, 2008 at 2:38 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>
>> On Sat, Aug 9, 2008 at 9:02 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>>>
>>>>> Also, what's the point, if it's just a renaming?
>>>>
>>>> that is the start point.
>>>> nr_irqs is variable, and will be probed later. and use that number to
>>>> init dyn_alloc.
>>>
>>> YH.
>>>
>>> In my conception the code in kernel/irq.c that today does:
>>>
>>> struct irq_desc *desc;
>>> if (irq >= NR_IRQS)
>>>   return -EINVAL;
>>> desc = irq_desc + irq;
>>>
>>> Should become:
>>>
>>> struct irq_desc *desc;
>>> desc = irq_desc(irq);
>>> if (!desc)
>>>   return -EINVAL;
>>>
>>
>> OK.
>>
>> also want to introduce dummy
>> struct irq_desc
>> {
>>    unsigned int irq;
>> };
>>
>> in linux/interrupt.h if GENERIC_HARDIRQS is not defined.
>> so could have same interface
>> irq_desc()
>> and
>> for_each_irq_desc(irq, desc)
>
> What would use it?  irq_desc doesn't even exist if GENERIC_HARDIRQS are
> not defined.
>
> Far far in the future we may want to introduce an opaque type
> struct irq.  For use with linux/interrupt.h  Allowing things
> like irq_request(struct irq *irq, ...);  For now those kinds
> of interfaces should be internal to the genirq code.

From: Yinghai Lu <yhlu.kernel@gmail.com>
Date: Fri, 8 Aug 2008 13:56:15 -0700
Subject: [PATCH 31/42] replace loop with nr_irqs for proc/stat

so don't all irq_desc at begining to allocate all.
and only call that when needed

v2: make sure arch without GENERIC_HARDIRQS works too

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 fs/proc/proc_misc.c |   50 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 14 deletions(-)

Index: linux-2.6/fs/proc/proc_misc.c
===================================================================
--- linux-2.6.orig/fs/proc/proc_misc.c
+++ linux-2.6/fs/proc/proc_misc.c
@@ -495,17 +495,16 @@ static const struct file_operations proc

 static int show_stat(struct seq_file *p, void *v)
 {
-       int i;
+       int i, j;
        unsigned long jif;
        cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
        cputime64_t guest;
        u64 sum = 0;
        struct timespec boottime;
-       unsigned int *per_irq_sum;
-
-       per_irq_sum = kzalloc(sizeof(unsigned int)*nr_irqs, GFP_KERNEL);
-       if (!per_irq_sum)
-               return -ENOMEM;
+       unsigned int per_irq_sum;
+#ifdef CONFIG_GENERIC_HARDIRQS
+       struct irq_desc *desc;
+#endif

        user = nice = system = idle = iowait =
                irq = softirq = steal = cputime64_zero;
@@ -514,8 +513,6 @@ static int show_stat(struct seq_file *p,
        jif = boottime.tv_sec;

        for_each_possible_cpu(i) {
-               int j;
-
                user = cputime64_add(user, kstat_cpu(i).cpustat.user);
                nice = cputime64_add(nice, kstat_cpu(i).cpustat.nice);
                system = cputime64_add(system, kstat_cpu(i).cpustat.system);
@@ -525,10 +522,12 @@ static int show_stat(struct seq_file *p,
                softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
                steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
                guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
-               for (j = 0; j < nr_irqs; j++) {
-                       unsigned int temp = kstat_irqs_cpu(j, i);
+               for_each_irq_desc(j, desc)
+               {
+                       unsigned int temp;
+
+                       temp = kstat_irqs_cpu(j, i);
                        sum += temp;
-                       per_irq_sum[j] += temp;
                }
                sum += arch_irq_stat_cpu(i);
        }
@@ -571,8 +570,23 @@ static int show_stat(struct seq_file *p,
        }
        seq_printf(p, "intr %llu", (unsigned long long)sum);

-       for (i = 0; i < nr_irqs; i++)
-               seq_printf(p, " %u", per_irq_sum[i]);
+       /* sum again ? it could be updated? */
+       for_each_irq_desc(j, desc)
+       {
+               per_irq_sum = 0;
+               for_each_possible_cpu(i) {
+                       unsigned int temp;
+
+                       temp = kstat_irqs_cpu(j, i);
+                       per_irq_sum += temp;
+               }
+
+#ifdef CONFIG_HAVE_SPARSE_IRQ
+               seq_printf(p, " %u:%u", j, per_irq_sum);
+#else
+               seq_printf(p, " %u", per_irq_sum);
+#endif
+       }

        seq_printf(p,
                "\nctxt %llu\n"
@@ -586,7 +600,6 @@ static int show_stat(struct seq_file *p,
                nr_running(),
                nr_iowait());

-       kfree(per_irq_sum);
        return 0;
 }

Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h
+++ linux-2.6/include/linux/interrupt.h
@@ -17,6 +17,11 @@

 extern int nr_irqs;

+#ifndef CONFIG_GENERIC_HARDIRQS
+#define for_each_irq_desc(irq, desc)           \
+       for (irq = 0; irq < nr_irqs; irq++])
+#endif
+
 /*
  * These correspond to the IORESOURCE_IRQ_* defines in
  * linux/ioport.h to select the interrupt line behaviour.  When
