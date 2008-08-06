Return-Path: <linux-kernel-owner+w=401wt.eu-S932171AbYHFU6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbYHFU6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422708AbYHFU5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:57:49 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:56930 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422859AbYHFU5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:57:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=aVU1LkumMumkfRO4sMmxcswq7+tir23Sj9p0zgUDvV9s8G1F/56+fOnOBJZ2wrYHPQ
         glrk0qGKthWT4nn0bw6ybSDSyv+nBPwwsmUeA76ftjMmcBhZQoixSqjMgORy9oYB8W6A
         3dXGGBWwGwMDQNY947LDHIjN1ziPJjz/esiIw=
Message-ID: <86802c440808061357j425da86bj94165c47c669eb61@mail.gmail.com>
Date: Wed, 6 Aug 2008 13:57:45 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 00/33] dyn_array and nr_irqs support v4
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m1y739j2z8.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218011937-10084-1-git-send-email-yhlu.kernel@gmail.com>
	 <m1hc9yjb7x.fsf@frodo.ebiederm.org>
	 <86802c440808061129l2bbe1658w453a11b4f16ffc83@mail.gmail.com>
	 <m1y739j2z8.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2008 at 1:35 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>
>>> My suggestion for a non-breaking path:
>>> - Kill NR_IRQS in then generic code.
>>>  With Alan's serial patch and my kstat patch it looks like we have
>>>  the worst of that.
>>
>> will use Alan's patch.at first.
>> already reused your patch about kstat. and move kstat_irqs to irq_desc.
>
> Part of what I am thinking is that there should never be a patch
> that does s/NR_IRQS/nr_irqs/ that is just pointless noise.

for some platform like 32bit, may not like to mess up with
CONFIG_HAVE_SPARSE_IRQ, to have dyn_array to take small nr_irqs with
probing.

>
> Either we need a new abstraction like for_each_irq or to update the
> code to the current best practices.

already add for_each_irq_desc(irq, desc)...

| #ifndef CONFIG_HAVE_DYN_ARRAY
| /* could be removed if we get rid of all irq_desc reference */
| extern struct irq_desc irq_desc[NR_IRQS];
| #else
| extern struct irq_desc *irq_desc;
| #endif
|
| #define for_each_irq_desc(irq, desc)            \
|        for (irq = 0, desc = irq_desc; irq < nr_irqs; irq++, desc =
&irq_desc[irq])
|
|#else
|
|extern struct irq_desc *irq_descX;
|#define for_each_irq_desc(irqX, desc)           \
|        for (desc = irq_descX, irqX = desc->irq; desc && irqX != -1U;
desc = desc->next, irqX = desc ? desc->irq: -1U)
|
|#endif


>
> Which means the patches should be uncontroversial and mergeble on their
> own with no weird dependencies.

sure.

YH
