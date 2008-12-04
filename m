Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbYLDB5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbYLDB5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 20:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYLDB5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 20:57:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52428 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbYLDB5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 20:57:01 -0500
From: Thomas Renninger <trenn@suse.de>
To: Tom Hughes <tom@compton.nu>
Subject: Re: [PATCH 1/1] cpufreq: eeepc 900 frequency scaling driver
Date: Thu, 4 Dec 2008 02:57:07 +0100
User-Agent: KMail/1.9.10
Cc: Cristiano Prisciandaro <cristiano.p@solnet.ch>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1227454026.7262.59.camel@localhost> <492A7632.4040106@compton.nu> <4936DD78.4090501@compton.nu>
In-Reply-To: <4936DD78.4090501@compton.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812040257.09099.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 03 December 2008 08:26:48 pm Tom Hughes wrote:
> Tom Hughes wrote:
> > Cristiano Prisciandaro wrote:
> >> From: Cristiano Prisciandaro <cristiano.p@solnet.ch>
> >>
> >> The bios of the eeepc 900 exposes an acpi method that allows clocking
> >> the cpu to 630/900 MHz. This driver allows controlling the frequency
> >> switch through the cpufreq subsystem.
> >
> > I should perhaps add at this point that I have an alternative patch
> > based on Cristiano's code, which adds this cpufreq driver to the
> > existing eeepc-laptop module rather than creating a separate module for
> > it.
>
> For the record, and as this discussion seems to have ground to a halt a
> bit at the moment, here is my version of the eee 900 cpufreq driver:

The biggest problem I see with these "special" ACPI cpufreq interface is:
Can there be Asus/eeepcs which provide these ACPI functions (maybe dummies on
future machines?), but can still be switched via the spec conform and more 
efficient acpi-cpufreq driver via PSS tables?

Then it is pure luck which one will win, there can only be one cpufreq driver.

BTW: Have you tried out how much power (or at least battery life time) you
win?

        Thomas
>
> --- kmod-eeepc-laptop-2.6.28rc5/eeepc-laptop.c	2008-11-20
> 09:24:41.000000000 +0000 +++
> kmod-eeepc-laptop-cpufreq/eeepc-laptop.c	2008-12-03 18:59:14.000000000
> +0000 @@ -25,6 +25,7 @@
>  #include <linux/fb.h>
>  #include <linux/hwmon.h>
>  #include <linux/hwmon-sysfs.h>
> +#include <linux/cpufreq.h>
>  #include <acpi/acpi_drivers.h>
>  #include <acpi/acpi_bus.h>
>  #include <linux/uaccess.h>
> @@ -731,6 +732,112 @@
>  };
>
>  /*
> + * Cpufreq
> + *
> + * Based on work by Cristiano P. <cris69@solnet.ch>
> + */
> +static struct cpufreq_frequency_table eeepc_cpufreq_table[] = {
> +       {0, 630000},
> +       {1, 900000},
> +       {0, CPUFREQ_TABLE_END}
> +};
> +
> +static unsigned int eeepc_cpufreq_get(unsigned int cpu)
> +{
> +	switch (get_acpi(CM_ASL_CPUFV)) {
> +	case 0x200:
> +		return 900000;
> +	case 0x201:
> +		return 630000;
> +	}
> +
> +	return 0;
> +}
> +
> +static void eeepc_cpufreq_set(unsigned int frequency)
> +{
> +	struct cpufreq_freqs freqs;
> +
> +	freqs.cpu = 0;
> +	freqs.old = eeepc_cpufreq_get(0);
> +	freqs.new = frequency;
> +
> +	cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
> +
> +	switch (frequency) {
> +	case 900000:
> +		set_acpi(CM_ASL_CPUFV, 0);
> +		break;
> +	case 630000:
> +		set_acpi(CM_ASL_CPUFV, 1);
> +		break;
> +	}
> +
> +	cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
> +
> +	return;
> +}
> +
> +static int eeepc_cpufreq_verify(struct cpufreq_policy *policy)
> +{
> +	return cpufreq_frequency_table_verify(policy, eeepc_cpufreq_table);
> +}
> +
> +static int eeepc_cpufreq_target (struct cpufreq_policy *policy,
> +				 unsigned int target_freq,
> +				 unsigned int relation)
> +{
> +	unsigned int newstate = 0;
> +
> +	if (cpufreq_frequency_table_target(policy, eeepc_cpufreq_table,
> +					   target_freq, relation, &newstate))
> +		return -EINVAL;
> +
> +	eeepc_cpufreq_set(eeepc_cpufreq_table[newstate].frequency);
> +
> +	return 0;
> +}
> +
> +static int eeepc_cpufreq_cpu_init(struct cpufreq_policy *policy)
> +{
> +	if (get_acpi(CM_ASL_CPUFV) != -1)
> +	{
> +		policy->cpuinfo.transition_latency = 1000000;
> +		policy->cur = eeepc_cpufreq_get(policy->cpu);
> +
> +		if (cpufreq_frequency_table_cpuinfo(policy, eeepc_cpufreq_table))
> +			return -EINVAL;
> +
> +		cpufreq_frequency_table_get_attr(eeepc_cpufreq_table, policy->cpu);
> +	}
> +
> +	return 0;
> +}
> +
> +static int eeepc_cpufreq_cpu_exit(struct cpufreq_policy *policy)
> +{
> +	cpufreq_frequency_table_put_attr(policy->cpu);
> +
> +	return 0;
> +}
> +
> +static struct freq_attr *eeepc_cpufreq_attr[] = {
> +	&cpufreq_freq_attr_scaling_available_freqs,
> +	NULL,
> +};
> +
> +static struct cpufreq_driver eeepc_cpufreq_driver = {
> +	.verify         = eeepc_cpufreq_verify,
> +	.target         = eeepc_cpufreq_target,
> +	.init           = eeepc_cpufreq_cpu_init,
> +	.exit           = eeepc_cpufreq_cpu_exit,
> +	.get            = eeepc_cpufreq_get,
> +	.name           = "eeepc",
> +	.owner          = THIS_MODULE,
> +	.attr           = eeepc_cpufreq_attr,
> +};
> +
> +/*
>   * exit/init
>   */
>  static void eeepc_backlight_exit(void)
> @@ -759,10 +866,16 @@
>  	eeepc_hwmon_device = NULL;
>  }
>
> +static void eeepc_cpufreq_exit(void)
> +{
> +	cpufreq_unregister_driver(&eeepc_cpufreq_driver);
> +}
> +
>  static void __exit eeepc_laptop_exit(void)
>  {
>  	eeepc_backlight_exit();
>  	eeepc_hwmon_exit();
> +	eeepc_cpufreq_exit();
>  	acpi_bus_unregister_driver(&eeepc_hotk_driver);
>  	sysfs_remove_group(&platform_device->dev.kobj,
>  			   &platform_attribute_group);
> @@ -810,6 +923,11 @@
>  	return result;
>  }
>
> +static int eeepc_cpufreq_init(struct device *dev)
> +{
> +	return cpufreq_register_driver(&eeepc_cpufreq_driver);
> +}
> +
>  static int __init eeepc_laptop_init(void)
>  {
>  	struct device *dev;
> @@ -837,6 +955,9 @@
>  	result = eeepc_hwmon_init(dev);
>  	if (result)
>  		goto fail_hwmon;
> +	result = eeepc_cpufreq_init(dev);
> +	if (result)
> +		goto fail_cpufreq;
>  	/* Register platform stuff */
>  	result = platform_driver_register(&platform_driver);
>  	if (result)
> @@ -861,6 +982,8 @@
>  fail_platform_device1:
>  	platform_driver_unregister(&platform_driver);
>  fail_platform_driver:
> +	eeepc_cpufreq_exit();
> +fail_cpufreq:
>  	eeepc_hwmon_exit();
>  fail_hwmon:
>  	eeepc_backlight_exit();
>
>
> Tom


