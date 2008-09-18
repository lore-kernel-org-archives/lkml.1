Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbYIRRun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbYIRRun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 13:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755047AbYIRRud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 13:50:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754235AbYIRRub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 13:50:31 -0400
Date: Thu, 18 Sep 2008 10:49:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: Rik Theys <rik.theys@esat.kuleuven.be>, Adam Belay <abelay@novell.com>,
       Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 2.6.27-rc6] cope with PNPACPI tables missing an RTC
 entry
Message-Id: <20080918104900.5ecb5dc9.akpm@linux-foundation.org>
In-Reply-To: <200809181042.46778.david-b@pacbell.net>
References: <200809181042.46778.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added)

On Thu, 18 Sep 2008 10:42:46 -0700 David Brownell <david-b@pacbell.net> wrote:

> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> A bugzilla entry (http://bugzilla.kernel.org/show_bug.cgi?id=11580)
> reports that some PNPACPI tables don't list RTC devices; they are
> instead glommed into a generic "system resources" entry.
> 
> Address that on x86 (while ignoring ia64, the other user of ACPI) by
> having ACPI glue check for that case, and if necessary then setting
> up a platform device and having rtc_cmos use it.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> Reported-by: Rik Theys <rik.theys@esat.kuleuven.be>
> ---
> Seems like a candidate for 2.6.27-final and for backporting.
> There's a Fedora kernel report for this too.  Workaround is
> simple (see the bug report) but less functional.
> 
>  arch/x86/kernel/rtc.c         |   13 ++++++++++++-
>  drivers/acpi/glue.c           |   16 +++++++++++++++-
>  drivers/pnp/core.c            |    8 ++++++++
>  drivers/rtc/rtc-cmos.c        |    4 ++--
>  include/asm-x86/mc146818rtc.h |    5 +++++
>  include/linux/pnp.h           |    1 +
>  6 files changed, 43 insertions(+), 4 deletions(-)
> 
> --- a/arch/x86/kernel/rtc.c
> +++ b/arch/x86/kernel/rtc.c
> @@ -220,11 +220,22 @@ static struct platform_device rtc_device
>  	.num_resources	= ARRAY_SIZE(rtc_resources),
>  };
>  
> +#ifdef CONFIG_PNP
> +/* PNPACPI tables sometimes omit the RTC, or are ignored */
> +struct device *__init add_nonpnp_rtc_cmos(void)
> +{
> +	if (!rtc_device.dev.bus)
> +		platform_device_register(&rtc_device);
> +	return &rtc_device.dev;
> +}
> +#endif
> +
>  static __init int add_rtc_cmos(void)
>  {
>  #ifdef CONFIG_PNP
> +	/* in case of pnpacpi=off */
>  	if (!pnp_platform_devices)
> -		platform_device_register(&rtc_device);
> +		add_nonpnp_rtc_cmos();
>  #else
>  	platform_device_register(&rtc_device);
>  #endif /* CONFIG_PNP */
> --- a/drivers/acpi/glue.c
> +++ b/drivers/acpi/glue.c
> @@ -338,7 +338,21 @@ static int __init pnp_match(struct devic
>  
>  static struct device *__init get_rtc_dev(void)
>  {
> -	return bus_find_device(&pnp_bus_type, NULL, NULL, pnp_match);
> +	struct device *rtc;
> +
> +	/* return RTC from PNPACPI tables */
> +	rtc = bus_find_device(&pnp_bus_type, NULL, NULL, pnp_match);
> +
> +#ifdef ARCH_PNP_RTC_WORKAROUND
> +	/* cope with buggy PNPACPI tables (like the HP DL3x0 servers
> +	 * which have no RTC device listed), and with pnpacpi=off
> +	 */
> +	if (!rtc) {
> +		pnp_rtc_missing = true;
> +		rtc = add_nonpnp_rtc_cmos();
> +	}
> +#endif
> +	return rtc;
>  }
>  
>  static int __init acpi_rtc_init(void)
> --- a/drivers/pnp/core.c
> +++ b/drivers/pnp/core.c
> @@ -25,10 +25,18 @@ DEFINE_SPINLOCK(pnp_lock);
>   * ACPI or PNPBIOS should tell us about all platform devices, so we can
>   * skip some blind probes.  ISAPNP typically enumerates only plug-in ISA
>   * devices, not built-in things like COM ports.
> + *
> + * Sometimes ACPI tables omit devices like RTCs, which can be critical.
> + * To avoid legacy poke-the-hardware-and-guess drivers (unfriendly to
> + * the driver model), something else creates a (platform) device node;
> + * and drivers must know to kick-in their non-PNP (non-PC) bus glue.
>   */
>  int pnp_platform_devices;
>  EXPORT_SYMBOL(pnp_platform_devices);
>  
> +bool pnp_rtc_missing;
> +EXPORT_SYMBOL(pnp_rtc_missing);
> +
>  void *pnp_alloc(long size)
>  {
>  	void *result;
> --- a/drivers/rtc/rtc-cmos.c
> +++ b/drivers/rtc/rtc-cmos.c
> @@ -1137,7 +1137,7 @@ static struct platform_driver cmos_platf
>  static int __init cmos_init(void)
>  {
>  #ifdef	CONFIG_PNP
> -	if (pnp_platform_devices)
> +	if (pnp_platform_devices && !pnp_rtc_missing)
>  		return pnp_register_driver(&cmos_pnp_driver);
>  	else
>  		return platform_driver_probe(&cmos_platform_driver,
> @@ -1152,7 +1152,7 @@ module_init(cmos_init);
>  static void __exit cmos_exit(void)
>  {
>  #ifdef	CONFIG_PNP
> -	if (pnp_platform_devices)
> +	if (pnp_platform_devices && !pnp_rtc_missing)
>  		pnp_unregister_driver(&cmos_pnp_driver);
>  	else
>  		platform_driver_unregister(&cmos_platform_driver);
> --- a/include/asm-x86/mc146818rtc.h
> +++ b/include/asm-x86/mc146818rtc.h
> @@ -101,4 +101,9 @@ extern unsigned long mach_get_cmos_time(
>  
>  #define RTC_IRQ 8
>  
> +#ifdef CONFIG_PNP
> +#define ARCH_PNP_RTC_WORKAROUND
> +extern struct device *add_nonpnp_rtc_cmos(void);
> +#endif
> +
>  #endif /* _ASM_MC146818RTC_H */
> --- a/include/linux/pnp.h
> +++ b/include/linux/pnp.h
> @@ -420,6 +420,7 @@ int pnp_device_attach(struct pnp_dev *pn
>  void pnp_device_detach(struct pnp_dev *pnp_dev);
>  extern struct list_head pnp_global;
>  extern int pnp_platform_devices;
> +extern bool pnp_rtc_missing;
>  
>  /* multidevice card support */
>  struct pnp_dev *pnp_request_card_device(struct pnp_card_link *clink,
