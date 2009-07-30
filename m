Return-Path: <linux-kernel-owner+w=401wt.eu-S1751997AbZG3Wae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbZG3Wae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 18:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbZG3Wad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 18:30:33 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:44822 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbZG3Wac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 18:30:32 -0400
X-Greylist: delayed 493 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jul 2009 18:30:32 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=JopMze3D7DFguHKmwfhwr2tR/Yyo6Oze3xKh6Le5lbeBRcjAYj33hYz4+hCT7wVizs
         SbGM8tj0UrI+mky2DSynjX7S3bIkl0JoS1Z7XtS2FWtsiU+l108KrncBhOPHfdAsUFI5
         TpydzWbgTV5OwUAyCTK9AJBlKVsrm+I6rus7E=
Message-ID: <4A721D16.7030000@gmail.com>
Date: Fri, 31 Jul 2009 00:22:14 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: mingo@redhat.com, hpa@zytor.com, x86@kernel.org, yinghai@kernel.org,
       linux-kernel@vger.kernel.org, Bernhard Walle <bernhard.walle@gmx.de>
Subject: Re: [PATCH 1/2] IRQ: fix performance regression on large IA64 systems
References: <1246611709-9919-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.2.00.0907051810030.2771@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0907051810030.2771@localhost.localdomain>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2009 09:26 PM, Thomas Gleixner wrote:
> On Fri, 3 Jul 2009, Jiri Slaby wrote:
>> Commit b60c1f6ffd88850079ae419aa933ab0eddbd5535
>> (drop note_interrupt() for per-CPU for proper scaling) removed call to
>> note_interrupt() in __do_IRQ(). Commit
>> d85a60d85ea5b7c597508c1510c88e657773d378
>> (Add IRQF_IRQPOLL flag (common code)) added it again, because it's needed
>> for irqpoll.
>>
>> This patch now introduces a new parameter 'only_fixup' for
>> note_interrupt(). This parameter determines two cases:
...
> Hmm. I'm not really happy about that patch. It's all about percpu
> interrupts which happen to have the same irq number. I think the
> correct thing to do is to use the handle_percpu_irq() handler and
> modify handle_percpu_irq to call note_interrupt() only when the return
> value of the action handler is IRQ_NONE. Otherwise we can leave
> everything untouched.

Sorry for the delay, I waited for test results. I have the patch
attached and the boot still lasts very long. Do you see any obvious
mistake which I don't see? (It's 2.6.27-based, therefore no irq_to_desc.)

Thanks.

---
 arch/ia64/kernel/irq_ia64.c |    9 ++++-----
 kernel/irq/chip.c           |    2 +-
 2 files changed, 5 insertions(+), 6 deletions(-)

--- a/arch/ia64/kernel/irq_ia64.c
+++ b/arch/ia64/kernel/irq_ia64.c
@@ -624,14 +624,13 @@ static struct irqaction tlb_irqaction =
 void
 ia64_native_register_percpu_irq (ia64_vector vec, struct irqaction *action)
 {
-       irq_desc_t *desc;
-       unsigned int irq;
+       unsigned int irq = vec;
+       irq_desc_t *desc = irq_desc + irq;

-       irq = vec;
        BUG_ON(bind_irq_vector(irq, vec, CPU_MASK_ALL));
-       desc = irq_desc + irq;
        desc->status |= IRQ_PER_CPU;
-       desc->chip = &irq_type_ia64_lsapic;
+       set_irq_chip_and_handler(irq, &irq_type_ia64_lsapic,
+                       &handle_percpu_irq);
        if (action)
                setup_irq(irq, action);
 }
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -531,7 +531,7 @@ handle_percpu_irq(unsigned int irq, stru
                desc->chip->ack(irq);

        action_ret = handle_IRQ_event(irq, desc->action);
-       if (!noirqdebug)
+       if (!noirqdebug && action_ret == IRQ_NONE)
                note_interrupt(irq, desc, action_ret);

        if (desc->chip->eoi)
