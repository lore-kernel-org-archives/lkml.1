Return-Path: <linux-kernel-owner+w=401wt.eu-S1754397AbYJ2M40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbYJ2M40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 08:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbYJ2M4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 08:56:08 -0400
Received: from gw.goop.org ([64.81.55.164]:42303 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114AbYJ2M4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 08:56:06 -0400
Message-ID: <49085D60.7050807@goop.org>
Date: Wed, 29 Oct 2008 23:56:00 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Joe Damato <ice799@gmail.com>
CC: linux-x86_64@vger.kernel.org, linux-newbie@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] x86: Use struct fields instead of bitmasks
References: <> <1224904532-9586-1-git-send-email-ice799@gmail.com> <52f8491fb5d55c0171840b01638ea6db0a98f3be.1224903712.git.ice799@gmail.com> <03269a2e8f455b431612a32e8cce048e98c75b27.1224903712.git.ice799@gmail.com> <4810cc08c12cd78612b53f9b52d7ba93a9b03fd0.1224903712.git.ice799@gmail.com> <a9cabc5cabdb5a10631e2a6dc330c54826f2b210.1224903712.git.ice799@gmail.com> <a4c806abcf7a46c78aaff4e338fdbc1a06a56c88.1224903712.git.ice799@gmail.com> <8834ad1ab5a5ab9b4902ab708160b23f078f3758.1224903712.git.ice799@gmail.com> <4d0ab6d642a4edc3ecc7367df7043ecc8f0a7f98.1224903712.git.ice799@gmail.com> <c53b3a54b3215187055dfe5673e1351d1bd3957a.1224903712.git.ice799@gmail.com> <e1bbf5a92bbf8fcf36dcbb650ee5f22d48d4b0f4.1224903712.git.ice799@gmail.com> <63f6f0d8b3da967e88094b6cd4b23f2ba78abbdc.1224903712.git.ice799@gmail.com> <0df5b7f8e2bee4a3599d6b80ea344b69d4bb4dc6.1224903713.git.ice799@gmail.com> <434766d4b5b6c08a3665c19038daaa3c1fa04cb0.1224903713.git.ice799@gmail.com>
In-Reply-To: <434766d4b5b6c08a3665c19038daaa3c1fa04cb0.1224903713.git.ice799@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Damato wrote:
> Use fields in structs instead of bitmasks for getting/setting descriptor data.
>
> Signed-off-by: Joe Damato <ice799@gmail.com>
> ---
>  drivers/lguest/interrupts_and_traps.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/lguest/interrupts_and_traps.c b/drivers/lguest/interrupts_and_traps.c
> index bfb24d9..0d9c065 100644
> --- a/drivers/lguest/interrupts_and_traps.c
> +++ b/drivers/lguest/interrupts_and_traps.c
> @@ -178,7 +178,7 @@ void maybe_do_interrupt(struct lg_cpu *cpu)
>  	 * over them. */
>  	idt = &cpu->arch.idt[FIRST_EXTERNAL_VECTOR+irq];
>  	/* If they don't have a handler (yet?), we just ignore it */
> -	if (idt_present(idt->a, idt->b)) {
> +	if (idt->p) {
>   

No, using an idt_present() accessor is better, but just pass it an idt.

>  		/* OK, mark it no longer pending and deliver it. */
>  		clear_bit(irq, cpu->irqs_pending);
>  		/* set_guest_interrupt() takes the interrupt descriptor and a
> @@ -254,7 +254,7 @@ int deliver_trap(struct lg_cpu *cpu, unsigned int num)
>  
>  	/* Early on the Guest hasn't set the IDT entries (or maybe it put a
>  	 * bogus one in): if we fail here, the Guest will be killed. */
> -	if (!idt_present(cpu->arch.idt[num].a, cpu->arch.idt[num].b))
> +	if (!cpu->arch.idt[num].p)
>  		return 0;
>  	set_guest_interrupt(cpu, desc_lo(cpu->arch.idt[num]),
>  			    desc_hi(cpu->arch.idt[num]), has_err(num));
> @@ -461,7 +461,7 @@ void copy_traps(const struct lg_cpu *cpu, gate_desc *idt,
>  		 * If it can't go direct, we still need to copy the priv. level:
>  		 * they might want to give userspace access to a software
>  		 * interrupt. */
> -		if (idt_type(gidt->a, gidt->b) == 0xF)
> +		if (gidt->type == 0xF)
>   

We should have symbolic names for the IDT types.

    J
