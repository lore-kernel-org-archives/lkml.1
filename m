Return-Path: <linux-kernel-owner+w=401wt.eu-S1760184AbZFWQb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184AbZFWQb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbZFWQbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:31:47 -0400
Received: from www.tglx.de ([62.245.132.106]:47267 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbZFWQbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:31:47 -0400
Date: Tue, 23 Jun 2009 18:31:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pawel MOLL <pawel.moll@st.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: genirq default_disable()
In-Reply-To: <1245774218.14443.120.camel@bri1004.bri.st.com>
Message-ID: <alpine.LFD.2.00.0906231826100.2767@localhost.localdomain>
References: <1245774218.14443.120.camel@bri1004.bri.st.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Pawel MOLL wrote:
> Folks,
> 
> A quick question about the interrupt management... (the story takes
> place in kernel/irq/chip.c ;-)
> 
> Here we have the default_enable():
> 
> static void default_enable(unsigned int irq)
> {
>         struct irq_desc *desc = irq_to_desc(irq);
> 
>         desc->chip->unmask(irq);
>         desc->status &= ~IRQ_MASKED;
> }
> 
> It calls chip->unmask(), which absolutely makes sense...
> 
> The default_disable(), however, is not symmetric:
> 
> static void default_disable(unsigned int irq)
> {
> }
> 
> Is there any reason why it shouldn't call chip->mask()?
> 
> I'll be more then happy to prepare a patch doing so, but maybe it's a
> feature not a bug and I'm just missing something?

Yup, it's a feature: delayed irq disable.

Disabling irqs on the hardware level can be expensive. So we keep them
enabled and mark the irq as disabled. When an interrupt comes in
during that time then we disable the irq on the hardware level for
real and note internaly that it happened. On enable we replay the
interrupt so nothing is lost. That replay can be in hardware or in
software.

Thanks,

	tglx
