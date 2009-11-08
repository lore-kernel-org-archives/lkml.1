Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbZKHMeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbZKHMeh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbZKHMeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:34:37 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48445 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbZKHMeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:34:36 -0500
Date: Sun, 8 Nov 2009 12:34:22 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Leo Chen <leochen@broadcom.com>
Subject: Re: [PATCH 22/23] sysctl arm: Remove binary sysctl support
Message-ID: <20091108123422.GA9145@flint.arm.linux.org.uk>
References: <m14op5jjo4.fsf@fess.ebiederm.org> <1257682930-31401-22-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257682930-31401-22-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 04:22:09AM -0800, Eric W. Biederman wrote:
> diff --git a/arch/arm/kernel/isa.c b/arch/arm/kernel/isa.c
> index 8ac9b84..738dfcc 100644
> --- a/arch/arm/kernel/isa.c
> +++ b/arch/arm/kernel/isa.c
> @@ -22,47 +22,42 @@ static unsigned int isa_membase, isa_portbase, isa_portshift;
>  
>  static ctl_table ctl_isa_vars[4] = {
>  	{
> -		.ctl_name	= BUS_ISA_MEM_BASE,
>  		.procname	= "membase",
>  		.data		= &isa_membase, 
>  		.maxlen		= sizeof(isa_membase),
>  		.mode		= 0444,
>  		.proc_handler	= &proc_dointvec,
>  	}, {
> -		.ctl_name	= BUS_ISA_PORT_BASE,
>  		.procname	= "portbase",
>  		.data		= &isa_portbase, 
>  		.maxlen		= sizeof(isa_portbase),
>  		.mode		= 0444,
>  		.proc_handler	= &proc_dointvec,
>  	}, {
> -		.ctl_name	= BUS_ISA_PORT_SHIFT,
>  		.procname	= "portshift",
>  		.data		= &isa_portshift, 
>  		.maxlen		= sizeof(isa_portshift),
>  		.mode		= 0444,
>  		.proc_handler	= &proc_dointvec,
> -	}, {0}
> +	}, {}
>  };
>  
>  static struct ctl_table_header *isa_sysctl_header;
>  
>  static ctl_table ctl_isa[2] = {
>  	{
> -		.ctl_name	= CTL_BUS_ISA,
>  		.procname	= "isa",
>  		.mode		= 0555,
>  		.child		= ctl_isa_vars,
> -	}, {0}
> +	}, {}
>  };
>  
>  static ctl_table ctl_bus[2] = {
>  	{
> -		.ctl_name	= CTL_BUS,
>  		.procname	= "bus",
>  		.mode		= 0555,
>  		.child		= ctl_isa,
> -	}, {0}
> +	}, {}
>  };
>  
>  void __init

NAK.  Glibc uses these numeric sysctls to support ioperm emulation on ARM.
Therefore, removal of these numeric sysctls breaks that user interface:

  static int iobase_name[] = { CTL_BUS, BUS_ISA, BUS_ISA_PORT_BASE };
  static int ioshift_name[] = { CTL_BUS, BUS_ISA, BUS_ISA_PORT_SHIFT };
  if (! sysctl (iobase_name, 3, &io.io_base, &len, NULL, 0)
      && ! sysctl (ioshift_name, 3, &io.shift, &len, NULL, 0))
    {
      io.initdone = 1;
      return 0;
    }
...

> diff --git a/arch/arm/mach-bcmring/arch.c b/arch/arm/mach-bcmring/arch.c
> index 0da693b..f3c1119 100644
> --- a/arch/arm/mach-bcmring/arch.c
> +++ b/arch/arm/mach-bcmring/arch.c
> @@ -47,10 +47,6 @@ HW_DECLARE_SPINLOCK(gpio)
>      EXPORT_SYMBOL(bcmring_gpio_reg_lock);
>  #endif
>  
> -/* FIXME: temporary solution */
> -#define BCM_SYSCTL_REBOOT_WARM               1
> -#define CTL_BCM_REBOOT                 112
> -
>  /* sysctl */
>  int bcmring_arch_warm_reboot;	/* do a warm reboot on hard reset */
>  
> @@ -58,7 +54,6 @@ static struct ctl_table_header *bcmring_sysctl_header;
>  
>  static struct ctl_table bcmring_sysctl_warm_reboot[] = {
>  	{
> -	 .ctl_name = BCM_SYSCTL_REBOOT_WARM,
>  	 .procname = "warm",
>  	 .data = &bcmring_arch_warm_reboot,
>  	 .maxlen = sizeof(int),
> @@ -69,7 +64,6 @@ static struct ctl_table bcmring_sysctl_warm_reboot[] = {
>  
>  static struct ctl_table bcmring_sysctl_reboot[] = {
>  	{
> -	 .ctl_name = CTL_BCM_REBOOT,
>  	 .procname = "reboot",
>  	 .mode = 0555,
>  	 .child = bcmring_sysctl_warm_reboot},

Ack for this part.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
