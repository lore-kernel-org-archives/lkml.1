Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbYHOCJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbYHOCJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 22:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYHOCJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 22:09:43 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:63991 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbYHOCJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 22:09:42 -0400
X-BigFish: VPS-44(zz1432R98dR168aJ936eQ4015M148cM1805M3117Kzz10dck10d3izzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K5MDZK-01-VB0-01
Subject: Re: [PATCH] HPET: Workaround for a BIOS workaround on AMD SB700
	platform
From: crane cai <crane.cai@amd.com>
Reply-To: crane.cai@amd.com
To: Thomas Gleixner <tglx@linutronix.de>
CC: vojtech@suse.cz, Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0808141206130.3243@apollo.tec.linutronix.de>
References: <1218683616.20466.13.camel@crane-laptop>
	 <alpine.LFD.1.10.0808141206130.3243@apollo.tec.linutronix.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: AMD
Date: Fri, 15 Aug 2008 10:09:26 +0800
Message-ID: <1218766167.5646.55.camel@crane-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 15 Aug 2008 02:09:28.0528 (UTC) FILETIME=[F2A34D00:01C8FE7B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Your modification has been checked OK on our SB700 platform. Thank you.
Now could you help us to merge your patch to kernel source? Or do I need
to resubmit a patch on it?

Best regards,
- Crane

On Thu, 2008-08-14 at 18:11 +0800, Thomas Gleixner wrote:

> Crane,
> 
> thanks for debugging this. I think we don't need a quirk for this
> workaround. Checking the config register value for 0xffffffff is safe
> on all machines. I simplified your patch to the one below and added a
> printk in case the check times out.
> 
> One thing I'm a bit wary about is the readout of the HPET_PERIOD
> register. Is the value correct even _before_ the SMM machinery is
> started ?

> Thanks,
> 
>         tglx
> -----
> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> index ad2b15a..59fd3b6 100644
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -359,6 +359,7 @@ static int hpet_clocksource_register(void)
>  int __init hpet_enable(void)
>  {
>         unsigned long id;
> +       int i;
> 
>         if (!is_hpet_capable())
>                 return 0;
> @@ -369,6 +370,29 @@ int __init hpet_enable(void)
>          * Read the period and check for a sane value:
>          */
>         hpet_period = hpet_readl(HPET_PERIOD);
> +
> +       /*
> +        * AMD SB700 based systems with spread spectrum enabled use a
> +        * SMM based HPET emulation to provide proper frequency
> +        * setting. The SMM code is initialized with the first HPET
> +        * register access and takes some time to complete. During
> +        * this time the config register reads 0xffffffff. We check
> +        * for max. 1000 loops whether the config register reads a non
> +        * 0xffffffff value to make sure that HPET is up and running
> +        * before we go further. A counting loop is safe, as the HPET
> +        * access takes thousands of CPU cycles. On non SB700 based
> +        * machines this check is only done once and has no side
> +        * effects.
> +        */
> +       for (i = 0; hpet_readl(HPET_CFG) == 0xFFFFFFFF; i++) {
> +               if (i == 1000) {
> +                       printk(KERN_WARNING
> +                              "HPET config register value = 0xFFFFFFFF. "
> +                              "Disabling HPET\n");
> +                       goto out_nohpet;
> +               }
> +       }
> +
>         if (hpet_period < HPET_MIN_PERIOD || hpet_period > HPET_MAX_PERIOD)
>                 goto out_nohpet;
> 


