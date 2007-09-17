Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbXIQJlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbXIQJlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbXIQJky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 05:40:54 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:37585 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1753021AbXIQJkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 05:40:52 -0400
Date: Mon, 17 Sep 2007 13:47:28 +0400
From: Konstantin Baydarov <kbaidarov@ru.mvista.com>
To: Konstantin Baydarov <kbaidarov@ru.mvista.com>
Cc: ebiederm@xmission.com (Eric W. Biederman),
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       <vgoyal@in.ibm.com>, "RT" <linux-rt-users@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <ak@suse.de>,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH] kexec: reenable HPET before kexec
Message-ID: <20070917134728.14a9326a@localhost.localdomain>
In-Reply-To: <20070831143151.7dde7c86@windmill.dev.rtsoft.ru>
References: <20070820205530.1ffd5876@windmill.dev.rtsoft.ru>
	<20070823090845.GA13065@in.ibm.com>
	<20070823154936.3b7ae498@windmill.dev.rtsoft.ru>
	<20070827053656.GC9809@in.ibm.com>
	<653FFBB4508B9042B5D43DC9E18836F501522051@scsmsx415.amr.corp.intel.com>
	<20070828165832.5047d4de@windmill.dev.rtsoft.ru>
	<m1ps1532b5.fsf@ebiederm.dsl.xmission.com>
	<20070830200749.2f1f0a18@windmill.dev.rtsoft.ru>
	<m1d4x4zyoe.fsf@ebiederm.dsl.xmission.com>
	<20070831143151.7dde7c86@windmill.dev.rtsoft.ru>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.19; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2007 14:31:51 +0400
Konstantin Baydarov <kbaidarov@ru.mvista.com> wrote:

> On Thu, 30 Aug 2007 12:04:33 -0600
> ebiederm@xmission.com (Eric W. Biederman) wrote:
> 
> > I was assuming that CLOCK_EVT_MODE_SHUTDOWN just mapped
> > to the shutdown method of the clock events or something else.
> > But it shutdown means something different in this context we
> > can certainly find a better place to hook into the device
> > tree and call shutdown methods.   Especially if that will
> > make the code simpler.
> 
> Agree. I've got rig from timekeeping. Now I'm using system device
> tree shutdown interface, as you suggested. I've added HPET system
> device class with shutdown method and HPET device to sysdev.
> 
> > This is a design feature.  machine_crash_shutdown is not really 
> > supposed to disable any hardware.  There is a very minimal set that
> > we haven't been able to figure out how to get the kernels
> > initialization routines to deal with properly.  Which is a
> > temporary justification for not doing more now.  If we can't find
> > anyway to make the initialization code more robust for the hpet we
> > can revisit this.
> 
> So you suggest to check if HPET is present in HPET init code even if
> HPET disabled in boot kernel command line or APIC is disabled. And if
> HPET is present and kernel not going to use it - disable HPET
> interrupts?
> 
> > Please remove the CONFIG_KEXEC.  We need to do this on a reboot also
> > so we don't confuse the BIOS.  BIOS's frequently but not always
> > can just reset the board to avoid complications like this, but if
> > we need a shutdown method we need a shutdown method.  The kexec
> > case just exercises things more.
> Removed CONFIG_KEXEC.
> 
> So here is new version of fix. Patch against 2.6.23-rc3.
> Eric, review please. Thanks.
> 
> Signed-off-by: Konstantin Baydarov <kbaidarov@ru.mvista.com>
> 
>  arch/i386/kernel/hpet.c |   48
> ++++++++++++++++++++++++++++++++++++++++++++++++ 1 file changed, 48
> insertions(+)
> 
> Index: linux-2.6.23-rc3/arch/i386/kernel/hpet.c
> ===================================================================
> --- linux-2.6.23-rc3.orig/arch/i386/kernel/hpet.c
> +++ linux-2.6.23-rc3/arch/i386/kernel/hpet.c
> @@ -144,11 +144,31 @@ static void hpet_enable_int(void)
>  {
>  	unsigned long cfg = hpet_readl(HPET_CFG);
>  
> +	if (hpet_legacy_int_enabled)
> +		return;
> +
>  	cfg |= HPET_CFG_LEGACY;
>  	hpet_writel(cfg, HPET_CFG);
>  	hpet_legacy_int_enabled = 1;
>  }
>  
> +static void hpet_disable_int(void)
> +{
> +	unsigned long cfg;
> +
> +	if (!hpet_legacy_int_enabled)
> +		return;
> +
> +	if (!is_hpet_capable())
> +		return;
> +
> +	cfg = hpet_readl(HPET_CFG);
> +	cfg &= ~HPET_CFG_LEGACY;
> +	hpet_writel(cfg, HPET_CFG);
> +	hpet_legacy_int_enabled = 0;
> +
> +}
> +
>  static void hpet_set_mode(enum clock_event_mode mode,
>  			  struct clock_event_device *evt)
>  {
> @@ -551,3 +571,31 @@ irqreturn_t hpet_rtc_interrupt(int irq, 
>  	return IRQ_HANDLED;
>  }
>  #endif
> +
> +static int hpet_shutdown(struct sys_device *dev)
> +{
> +	/* We need this to make PIT works in KEXECuted kernel */
> +	hpet_disable_int();
> +
> +	return 0;
> +}
> +
> +static struct sysdev_class hpet_sysdev_class = {
> +	set_kset_name("hpet"),
> +	.shutdown = hpet_shutdown,
> +};
> +
> +static struct sys_device device_hpet = {
> +	.id	= 0,
> +	.cls	= &hpet_sysdev_class,
> +};
> +
> +static int __init hpet_init_sysfs(void)
> +{
> +	int error = sysdev_class_register(&hpet_sysdev_class);
> +	if (!error)
> +		error = sysdev_register(&device_hpet);
> +	return error;
> +}
> +
> +device_initcall(hpet_init_sysfs);
> -
> To unsubscribe from this list: send the line "unsubscribe
> linux-rt-users" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

  Eric, can you tell me, when are you going to review last version of fix?
  Thanks.
