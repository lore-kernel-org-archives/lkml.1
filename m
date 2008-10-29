Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbYJ2QGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbYJ2QGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 12:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbYJ2QG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 12:06:27 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:56038 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbYJ2QG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 12:06:26 -0400
Date: Wed, 29 Oct 2008 09:05:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] NMI watchdog: add support to enable and disable
 IOAPIC NMI
Message-Id: <20081029090532.cc9536d9.randy.dunlap@oracle.com>
In-Reply-To: <20081027164234.679734000@napanee.usersys.redhat.com>
References: <20081027164233.132189000@napanee.usersys.redhat.com>
	<20081027164234.679734000@napanee.usersys.redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008 12:42:34 -0400 Aristeu Rozanski wrote:

> This patch adds support to enable/disable IOAPIC NMI watchdog in runtime via
> procfs.

Some info on how to use this, what to write(?) to what file(?) in procfs
would be Very Good to have.


> Signed-off-by: Aristeu Rozanski <aris@redhat.com>
> 
> ---
>  arch/x86/kernel/nmi.c |   25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> --- linus-2.6.orig/arch/x86/kernel/nmi.c	2008-10-27 11:31:56.000000000 -0400
> +++ linus-2.6/arch/x86/kernel/nmi.c	2008-10-27 11:43:49.000000000 -0400
> @@ -340,6 +340,8 @@ void stop_apic_nmi_watchdog(void *unused
>  		return;
>  	if (nmi_watchdog == NMI_LOCAL_APIC)
>  		lapic_watchdog_stop();
> +	else
> +		__acpi_nmi_disable(NULL);
>  	__get_cpu_var(wd_enabled) = 0;
>  	atomic_dec(&nmi_active);
>  }
> @@ -465,6 +467,24 @@ nmi_watchdog_tick(struct pt_regs *regs, 
>  
>  #ifdef CONFIG_SYSCTL
>  
> +static void enable_ioapic_nmi_watchdog_single(void *unused)
> +{
> +	__get_cpu_var(wd_enabled) = 1;
> +	atomic_inc(&nmi_active);
> +	__acpi_nmi_enable(NULL);
> +}
> +
> +static void enable_ioapic_nmi_watchdog(void)
> +{
> +	on_each_cpu(enable_ioapic_nmi_watchdog_single, NULL, 1);
> +	touch_nmi_watchdog();
> +}
> +
> +static void disable_ioapic_nmi_watchdog(void)
> +{
> +	on_each_cpu(stop_apic_nmi_watchdog, NULL, 1);
> +}
> +
>  static int __init setup_unknown_nmi_panic(char *str)
>  {
>  	unknown_nmi_panic = 1;
> @@ -507,6 +527,11 @@ int proc_nmi_enabled(struct ctl_table *t
>  			enable_lapic_nmi_watchdog();
>  		else
>  			disable_lapic_nmi_watchdog();
> +	} else if (nmi_watchdog == NMI_IO_APIC) {
> +		if (nmi_watchdog_enabled)
> +			enable_ioapic_nmi_watchdog();
> +		else
> +			disable_ioapic_nmi_watchdog();
>  	} else {
>  		printk(KERN_WARNING
>  			"NMI watchdog doesn't know what hardware to touch\n");
> 
> -- 

---
~Randy
