Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787AbYKMUH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbYKMUH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 15:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbYKMUHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 15:07:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:40711 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbYKMUHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 15:07:11 -0500
Message-ID: <491C88D9.6050409@kernel.org>
Date: Thu, 13 Nov 2008 12:06:49 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sparse_irq aka dyn_irq v13
References: <49168BD3.5010204@kernel.org> <20081109073813.GA17180@elte.hu> <86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com> <20081110094033.GL22392@elte.hu> <20081110015511.453a801e.akpm@linux-foundation.org> <4918065A.6050402@kernel.org> <20081110100329.GA19970@elte.hu> <491A9F87.8040403@kernel.org> <20081112120814.GG11352@elte.hu> <491BD0BA.5070008@kernel.org> <20081113095345.GM25479@elte.hu>
In-Reply-To: <20081113095345.GM25479@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> it still looks ugly to me: couldnt we make it completely #ifdef-free, 
> by just adding the new API variants?
> 
> i.e. leave these present unconditionally:
> 
>>  extern void hpet_msi_unmask(unsigned int irq);
>>  extern void hpet_msi_mask(unsigned int irq);
> 
> and just _add_ these (unconditionally):
> 
>> +extern void hpet_msi_unmask_desc(unsigned int irq, struct irq_desc **descp);
>> +extern void hpet_msi_mask_desc(unsigned int irq, struct irq_desc **descp);
> 
> that gives us zero #ifdefs and much nicer to read patches. Am i 
> missing something why this isnt possible?

in io_apic.c

struct irq_chip hpet_msi_type = {
        .name = "HPET_MSI",
        .unmask = hpet_msi_unmask,
        .mask = hpet_msi_mask,
        .ack = ack_apic_edge,
#ifdef CONFIG_SMP
        .set_affinity = hpet_msi_set_affinity,
#endif
        .retrigger = ioapic_retrigger_irq,
};

so those ack, mask, unmak, eoi field will have different function prototype..when sparseirq is enabled or not.

if you want to remove those #ifdef, we need to go over all irq_chip definition to make all those field to take struct irq_desc *desc (or **descp) instead of unsigned int irq.

actually we only need to pass desc struct instead of irq, because we can get desc->irq in case.

YH
