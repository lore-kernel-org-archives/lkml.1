Return-Path: <linux-kernel-owner+w=401wt.eu-S1758300AbZHQWyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbZHQWyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 18:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758289AbZHQWyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 18:54:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:49274 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758225AbZHQWyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 18:54:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,398,1246863600"; 
   d="scan'208";a="542124452"
Subject: Re: [PATCH] x86: move dmar_table_init out of enable_IR
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Gleb Natapov <gleb@redhat.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <4A89C1CE.9040501@kernel.org>
References: <4A89990D.4030703@sun.com> <20090817180924.GA8599@elte.hu>
	 <4A899F3C.2050104@kernel.org>
	 <1250534019.2709.94.camel@sbs-t61.sc.intel.com>
	 <4A89C1CE.9040501@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 17 Aug 2009 15:53:16 -0700
Message-Id: <1250549596.2709.254.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-17 at 13:47 -0700, Yinghai Lu wrote:
> Suresh Siddha wrote:
> > 
> > We can remove this ifdef check, as dmar_table_init() already handles
> > the !config_intr_remap
> > 
> > Also, at this error condition, we should simply return if the cpu has no
> > x2apic support. There is no x2apic support and we failed to enable
> > interrupt-remapping. No need to go further down.
> 
> like this ?
> 
> ---
>  arch/x86/kernel/apic/apic.c |    9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/apic/apic.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/apic.c
> +++ linux-2.6/arch/x86/kernel/apic/apic.c
> @@ -1392,14 +1392,11 @@ void __init enable_IR_x2apic(void)
>  	unsigned long flags;
>  	struct IO_APIC_route_entry **ioapic_entries = NULL;
>  	int ret, x2apic_enabled = 0;
> -	int dmar_table_init_ret = 0;
> +	int dmar_table_init_ret;
>  
> -#ifdef CONFIG_INTR_REMAP
>  	dmar_table_init_ret = dmar_table_init();
> -	if (dmar_table_init_ret)
> -		pr_debug("dmar_table_init() failed with %d:\n",
> -				dmar_table_init_ret);
> -#endif
> +	if (dmar_table_init_ret && !x2apic_supported())
> +		return;
>  
>  	ioapic_entries = alloc_ioapic_entries();
>  	if (!ioapic_entries) {

Ack.

