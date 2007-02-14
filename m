Return-Path: <linux-kernel-owner+w=401wt.eu-S932213AbXBNBGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbXBNBGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 20:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932212AbXBNBGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 20:06:44 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:42281 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932208AbXBNBGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 20:06:43 -0500
Message-ID: <45D260A2.4010200@vmware.com>
Date: Tue, 13 Feb 2007 17:06:42 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 10/21] Xen-paravirt: Name: dont export paravirt_ops structure,
 do individual functions
References: <20070213221729.772002682@goop.org> <20070213221830.238235953@goop.org>
In-Reply-To: <20070213221830.238235953@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Wrap the paravirt_ops members we want to export in wrapper functions.
> Since we binary-patch the critical ones, this doesn't make a speed
> impact.
>
> I moved drm_follow_page into the core, to avoid having to wrap the
> various pte ops.  Unlining kernel_fpu_end and using that in the RAID6
> code would remove the need to export clts/read_cr0/write_cr0 too.
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
>
> ===================================================================
> --- a/arch/i386/kernel/paravirt.c
> +++ b/arch/i386/kernel/paravirt.c
> @@ -596,6 +596,123 @@ static int __init print_banner(void)
>  	return 0;
>  }
>  core_initcall(print_banner);
> +
> +unsigned long paravirt_save_flags(void)
> +{
> +	return paravirt_ops.save_fl();
> +}
> +EXPORT_SYMBOL(paravirt_save_flags);
> +
> +void paravirt_restore_flags(unsigned long flags)
> +{
> +	paravirt_ops.restore_fl(flags);
> +}
> +EXPORT_SYMBOL(paravirt_restore_flags);
> +
> +void paravirt_irq_disable(void)
> +{
> +	paravirt_ops.irq_disable();
> +}
> +EXPORT_SYMBOL(paravirt_irq_disable);
> +
> +void paravirt_irq_enable(void)
> +{
> +	paravirt_ops.irq_enable();
> +}
> +EXPORT_SYMBOL(paravirt_irq_enable);
>   

This turned out really hideous looking to me.  Can't we split the struct 
into GPL'd and non-GPL'd functions instead?  We still have the same 
granularity, and none of this function call to an indirect function call 
nonsense.

Zach
