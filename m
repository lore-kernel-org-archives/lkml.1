Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbYHCTUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbYHCTUw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 15:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbYHCTUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 15:20:43 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:3826 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbYHCTUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 15:20:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CP7WjNMiAdHyahyhMCpJ0+fOaY/9pRFcJBVy+QcA0Idn7vvoS1UW0H6wFmDKen++MD
         FyK9eDqU+5WFgJHHAFa4hJJ3U+9ZwqA0cpX7zng8JIy5sQ9cGMeuTqNNs3rJHs6JATwf
         K/meKHIVJawc8We5EpQPF1cXWWHh27dfiadsU=
Message-ID: <86802c440808031220p3f9b9f7ay733cc886bbab99c4@mail.gmail.com>
Date: Sun, 3 Aug 2008 12:20:41 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/25] dyn_array and nr_irqs support v3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <86802c440808031054m7a451871mb9fdde97304fe0db@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
	 <m1fxpm8x3n.fsf@frodo.ebiederm.org>
	 <86802c440808022304g41749d9dn7688c81c3fdbed8a@mail.gmail.com>
	 <m18wve7gbt.fsf@frodo.ebiederm.org>
	 <86802c440808030125v32c6a83aoe3c09eea6a6cce08@mail.gmail.com>
	 <m1vdyi4fxx.fsf@frodo.ebiederm.org>
	 <86802c440808031054m7a451871mb9fdde97304fe0db@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 3, 2008 at 10:54 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>>   * Each architecture has to answer this themself.
>>>
>>>
>>> and later use get_irq_desc(i) instead irq_desc + i;
>>
>> That is the general idea.
>
> could use pre_allocate array + list to replace irq_desc array.
>

how about this one?

diff --git a/include/linux/irq.h b/include/linux/irq.h
index bd69d90..9d87f6a 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -154,6 +154,8 @@ struct irq_chip {
  * @name:              flow handler name for /proc/interrupts output
  */
 struct irq_desc {
+       unsigned int            irq;
+       struct irq_desc         *next;
        irq_flow_handler_t      handle_irq;
        struct irq_chip         *chip;
        struct msi_desc         *msi_desc;
@@ -181,7 +183,7 @@ struct irq_desc {
        const char              *name;
 } ____cacheline_internodealigned_in_smp;

-extern struct irq_desc irq_desc[NR_IRQS];
+extern struct irq_desc *get_irq_desc(unsigned int irq);

 /*
  * Migration helpers for obsolete names, they will go away:
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index e9d022c..347edb8 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -48,7 +48,90 @@ handle_bad_irq(unsigned int irq, struct irq_desc *desc)
  * Controller mappings for all interrupt sources:
  */
 int nr_irqs = NR_IRQS;
-struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
+
+#ifdef CONFIG_HAVE_DYN_ARRAY
+static struct irq_desc irq_desc_init __initdata = {
+       .irq = -1U;
+       .status = IRQ_DISABLED,
+       .chip = &no_irq_chip,
+       .handle_irq = handle_bad_irq,
+       .depth = 1,
+       .lock = __SPIN_LOCK_UNLOCKED(irq_desc->lock),
+#ifdef CONFIG_SMP
+       .affinity = CPU_MASK_ALL
+#endif
+};
+
+static int nr_irq_desc = NR_VECTORS;
+
+static int __init parse_nr_irq_desc(char *arg)
+{
+       if (arg)
+               nr_irq_desc = simple_strtoul(arg, NULL, 0);
+       return 0;
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
+
+       for (i = 1; i < *da->nr; i++)
+               desc[i-1].next = &desc[i];
+}
+
+static struct irq_desc *irq_desc;
+DEFINE_DYN_ARRAY(irq_desc, sizeof(struct irq_desc), nr_irq_desc,
PAGE_SIZE, init_work);
+
+struct irq_desc *get_irq_desc(unsigned int irq)
+{
+       struct irq_desc *desc, *desc_pri;
+
+       BUG_ON(irq == -1U);
+
+       desc = &irq_desc[0];
+       while (desc) {
+               if (desc->irq == irq)
+                       return desc;
+
+               if (desc->irq == -1U) {
+                       desc->irq = irq;
+                       return desc;
+               }
+               desc_pri = desc;
+               desc = desc->next;
+       }
+
+       /*
+        *  we run out of pre-allocate ones
+        *  and __alloc_bootmem or kzalloc could be used
+        */
+
+        if (after_bootmem)
+                desc = (struct irq_desc *) get_zeroed_page(GFP_ATOMIC);
+        else
+                desc = alloc_bootmem_pages(PAGE_SIZE);
+
+        if (!desc || ((unsigned long)desc & ~PAGE_MASK))
+               panic("please boot with nr_irq_desc= %d\n", nr_irq_desc * 2);
+
+       desc_pri->next = desc;
+       desc->irq = irq;
+
+       return desc;
+}
+
+#else
+
+static struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
        [0 ... NR_IRQS-1] = {
                .status = IRQ_DISABLED,
                .chip = &no_irq_chip,
@@ -61,6 +144,16 @@ struct irq_desc irq_desc[NR_IRQS]
__cacheline_aligned_in_smp = {
        }
 };

+struct irq_desc *get_irq_desc(unsigned int irq)
+{
+       if (irq < nr_irqs)
+               return &irq_desc[irq];
+
+       return NULL;
+}
+
+#endif
+
 /*
  * What should we do if we get a hw irq event on an illegal vector?
  * Each architecture has to answer this themself.

do we need to lock to avoid racing in get_irq_desc?

YH
