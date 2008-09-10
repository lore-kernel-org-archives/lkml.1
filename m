Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbYIJRat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbYIJRat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 13:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbYIJRal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 13:30:41 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:43073 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbYIJRak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 13:30:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RjRsevpO/dukPw8d7AuoGBbYEut4foaiirymS83pBl7k01MPrMNxQ877RdNNpU4/pP
         oqUqIVG2FatotB3HlTs9lrzt4diKtZ7LNU56+Dwt6bypXIC8oj7jZqpuUuObYWbXGMOE
         Guwyk4kCQOh3PRWyW0zwL4cWN2rnPCt3e8J1k=
Message-ID: <86802c440809101030q758d2f92v470727c88654d91d@mail.gmail.com>
Date: Wed, 10 Sep 2008 10:30:39 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: io-apic - get rid of __DO_ACTION macro
Cc: "Cyrill Gorcunov" <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080910093105.GA5259@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080909184615.GA7303@lenovo>
	 <86802c440809091313l6b3e1f48x6e3b5cd0b948ccf9@mail.gmail.com>
	 <aa79d98a0809092302g60967a60sd0609044a6d6a137@mail.gmail.com>
	 <86802c440809092322w363cc9dbt5eb172d5c80a6adc@mail.gmail.com>
	 <20080910093105.GA5259@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 2:31 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> On Tue, Sep 9, 2008 at 11:02 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> > On Wed, Sep 10, 2008 at 12:13 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> > ...
>> >>
>> >> hope we can keep using MACRO..
>> >>
>> >> YH
>> >>
>> >
>> > Btw, Yinghai, what does it mean? To not touch this macro at all?
>> > Or you mean about implementation issue (ie the design itself)?
>>
>> do not touch this macro... and may revisit after 2.6.28
>
> anything you are particularly worried about? Regressions we should be
> able to find pretty quickly, in a central macro like that - and the
> macro is quite ugly.
>

ok, let remove unneeded "if", and use function pointer...

void (*extra_action_t)(struct irq_pin_list *entry);

+static inline void io_apic_modify_irq(unsigned int irq,
+                               int mask_and, int mask_or,
+                               int mask_and_not, extra_action_t action)
+{
+       int pin;
+       struct irq_cfg *cfg;
+       struct irq_pin_list *entry;
+       cfg = irq_cfg(irq);
+       for (entry = cfg->irq_2_pin; entry != NULL; entry = entry->next) {
+               unsigned int reg;
+               pin = entry->pin;
+               reg = io_apic_read(entry->apic, 0x10 + pin * 2);
+               reg &= mask_and;
+               reg |= mask_or;
+               reg &= ~mask_and_not;
+               io_apic_modify(entry->apic, 0x10 + pin * 2, reg);
+               if (action)
+                       action(entry);
+       }
+}

+void extra_read(struct irq_pin_list *entry)
+             {
+                       /*
+                        * Synchronize the IO-APIC and the CPU by doing
+                        * a dummy read from the IO-APIC
+                        */
+                       struct io_apic __iomem *io_apic;
+                       io_apic = io_apic_base(entry->apic);
+                       readl(&io_apic->data);
+               }


YH
