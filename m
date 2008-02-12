Return-Path: <linux-kernel-owner+w=401wt.eu-S1759175AbYBLFtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175AbYBLFtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 00:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbYBLFtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 00:49:07 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:37401 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbYBLFtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 00:49:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jzfj1OeL7pCCQ7LCfr/X9Mn0K0iN52UcAqro3TP1TfrZUWq1iLB5hCulBBq8dF1FMqhkHubNOQqiSSsKC75Xxsdo8bDUfaWdvmVKZAsCprozlNW8mtxKivtSkh6r1RiENITpKWrPWVNMwRveEkL8chVtkmsYIAOQ8E8G9Jnf+k0=
Message-ID: <b115cb5f0802112149t574347e3of13a081937ec0ca0@mail.gmail.com>
Date: Tue, 12 Feb 2008 11:19:03 +0530
From: "Rajat Jain" <rajat.noida.india@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Kernel Bug? Use of IRQF_SHARED + IRQF_DISABLED
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Based on suggestion from Thomas Petazzoni, I'm moving this to LKML.

This is regarding the following code in kernel/irq/handle.c. Consider
the case of a shared IRQ line, where two handlers are registered such
that first handler does not specify IRQF_DISABLED, but the second one
does. But it seems both the handlers will be called with IRQs ENABLED
(which is certainly not what the second handler expects).

I also checked but could not find anything that stops me from
registering two shared ISRs - one with IRQF_DISABLED & another without
this flag. Am I missing something here?

irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
{
   irqreturn_t ret, retval = IRQ_NONE;
   unsigned int status = 0;

   handle_dynamic_tick(action);

   if (!(action->flags & IRQF_DISABLED))
       local_irq_enable_in_hardirq();

   do {
       ret = action->handler(irq, action->dev_id);
       if (ret == IRQ_HANDLED)
           status |= action->flags;
       retval |= ret;
       action = action->next;
   } while (action);

   if (status & IRQF_SAMPLE_RANDOM)
       add_interrupt_randomness(irq);
   local_irq_disable();

   return retval;
}

I'd like to submit a patch but was wondering which of the following is
the correct startegy to deal with above situation (I personally think
(1) below is more appropriate):

1) IN the above code while calling shared ISRs, check for each ISR
whether it specified IRQF_DISABLED or not. Enable IRQs only for ISR
that did not specify IRQF_DISABLED.

2) While installing ISR, check that all the ISRs for that IRQ should
have consistent use of IRQF_DISABLED. Don't allow insonsistent use of
IRQF_DISABLED on a shared IRQ.

Thanks,

Rajat
