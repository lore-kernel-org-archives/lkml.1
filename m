Return-Path: <linux-kernel-owner+w=401wt.eu-S1752753AbZHSPxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbZHSPxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 11:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbZHSPxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 11:53:34 -0400
Received: from www.tglx.de ([62.245.132.106]:50055 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbZHSPxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 11:53:34 -0400
Date: Wed, 19 Aug 2009 17:52:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 8/10] x86/timer: use platform feature to choose timer
 init function
In-Reply-To: <43F901BD926A4E43B106BF17856F0755643EBDFA@orsmsx508.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.00.0908191751090.3361@localhost.localdomain>
References: <43F901BD926A4E43B106BF17856F0755643EBDFA@orsmsx508.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009, Pan, Jacob jun wrote:
>  
>  #ifdef CONFIG_X86_IO_APIC
> -	if (timer_ack) {
> +	if (timer_ack && platform_has(X86_PLATFORM_FEATURE_8259)) {

  Why is timer ack set at all ?

>  		/*
>  		 * Subtle, when I/O APICs are used we have to ack timer IRQ
>  		 * manually to deassert NMI lines for the watchdog if run

> @@ -118,9 +120,26 @@ void __init hpet_time_init(void)
>  {
>  	if (!hpet_enable())
>  		setup_pit_timer();
> +}
> +#ifndef CONFIG_PARAVIRT
> +static inline void __init native_time_init(void)
> +{
> +	if (platform_has(X86_PLATFORM_FEATURE_HPET))
> +		hpet_time_init();
> +	else if (platform_has(X86_PLATFORM_FEATURE_APBT)) {
> +		apbt_enable();
> +	} else {
> +		/* should not get here, at least one timer should be found */
> +		BUG();
> +	}
>  	x86_quirk_time_init();
>  }
> +static inline void (*choose_time_init(void))(void)
> +{
> +	return native_time_init;
> +}

As I said before. This needs to be cleaned up together with the whole
paravirt mess.

Thanks,

	tglx
