Return-Path: <linux-kernel-owner+w=401wt.eu-S1752719AbYHCIZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbYHCIZi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 04:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbYHCIZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 04:25:15 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:5560 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbYHCIZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 04:25:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Yyj7CdjeJmHwS/bNDMt3xxpDksanIpTEXVak0tNvXjP44z1SoWv1R+lynsloclWc/P
         DpGsJ3/tGAOFrEqckkEYIchDowknpFKs1F18J2IAutcqpvUsPmSnO1dhX3BGZvOStE0d
         yzBQoIuymny1MKloaqDnMIfTmBFQWA5aEm9s8=
Message-ID: <86802c440808030125v32c6a83aoe3c09eea6a6cce08@mail.gmail.com>
Date: Sun, 3 Aug 2008 01:25:09 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 00/25] dyn_array and nr_irqs support v3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m18wve7gbt.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
	 <m1fxpm8x3n.fsf@frodo.ebiederm.org>
	 <86802c440808022304g41749d9dn7688c81c3fdbed8a@mail.gmail.com>
	 <m18wve7gbt.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 2, 2008 at 11:39 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>
>> On Sat, Aug 2, 2008 at 10:51 PM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>>>
>>> It appears that quite a few of the places you have changed are testing
>>> to see if an irq is valid.  The idiomatic way to perform that test in
>>> the kernel is:
>>>
>>> if (irq)
>>
>> is uninitialized irq to be -1 or 0?
>
> 0.  There is a long history behind it, but by decree of Linus and to conform
> with reasonable intuition 0 is not a valid irq except in certain arch specific
> corner cases.
>
>>> With no test to see if you are >= NR_IRQS.
>>>
>>> I expect that is the change we want in the drivers that are performing such a
>> silly
>>> extra check.
>>
>> is_irq_valid(irq_no) ?
>>
>> wait to see your new patchset about dyn irq_cfg and irq_desc
>
> I haven't promised one, at least not lately.  I went down a couple of
> blind alleys and figured out what needed to be accomplished and then
> ran out of steam about a year and a half 2 years ago, and I haven't
> been able to get back to it.
>

how about

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index f4c8a03..aa6888c 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -47,19 +47,73 @@ handle_bad_irq(unsigned int irq, struct irq_desc *desc)
  *
  * Controller mappings for all interrupt sources:
  */
-struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
-       [0 ... NR_IRQS-1] = {
-               .status = IRQ_DISABLED,
-               .chip = &no_irq_chip,
-               .handle_irq = handle_bad_irq,
-               .depth = 1,
-               .lock = __SPIN_LOCK_UNLOCKED(irq_desc->lock),
+static irq_desc **irq_desc_ptr;
+DEFINE_DYN_ARRAY(irq_desc_ptr, sizeof(struct irq_desc *), nr_irqs,
PAGE_SIZE, NULL);
+
+#define NR_IRQ_DESC    4096
+
+static struct irq_desc irq_desc__init = {
+       .irq = -1;
+       .status = IRQ_DISABLED,
+       .chip = &no_irq_chip,
+       .handle_irq = handle_bad_irq,
+       .depth = 1,
+       .lock = __SPIN_LOCK_UNLOCKED(irq_desc->lock),
 #ifdef CONFIG_SMP
-               .affinity = CPU_MASK_ALL
+       .affinity = CPU_MASK_ALL
 #endif
-       }
 };

+static int nr_irq_desc = NR_IRQ_DESC;
+
+static int __init parse_nr_irq_desc(char *arg)
+{
+        if (arg)
+                nr_irq_desc = simple_strtoul(arg, NULL, 0);
+        return 0;
+}
+
+early_param("nr_irq_desc", parse_nr_irq_desc);
+
+static void __init init_work(void *data)
+{
+       struct dyn_array *da = data;
+       int i;
+       struct  irq_desc *desc;
+
+       desc = *da->name;
+
+       for (i = 0; i < *da->nr; i++)
+               memcpy(&desc[i], &irq_desc_init, sizeof(struct irq_desc));
+}
+
+static struct irq_desc *irq_desc;
+DEFINE_DYN_ARRAY(irq_desc, sizeof(struct irq_desc), nr_irq_desc,
PAGE_SIZE, init_work);
+
+struct irq_desc *get_irq_desc(int irq)
+{
+       struct irq_desc *desc;
+       int i;
+
+       desc = irq_desc_ptr[irq];
+
+       if (desc)
+               return desc;
+
+       for (i = 0; i < nr_irq_desc; i++) {
+               if (irq_desc[i]->irq != -1)
+                       continue;
+
+               desc = &irq_desc[i];
+               desc->irq = irq;
+               irq_desc_ptr[irq] = desc;
+
+               return desc;
+       }
+
+       panic("please boot with nr_irq_desc=%d\n", nr_irq_desc * 2);
+}
+
 /*
  * What should we do if we get a hw irq event on an illegal vector?
  * Each architecture has to answer this themself.


and later use get_irq_desc(i) instead irq_desc + i;

YH
