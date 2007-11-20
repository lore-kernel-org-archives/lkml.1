Return-Path: <linux-kernel-owner+w=401wt.eu-S1760836AbXKTCGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760836AbXKTCGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758309AbXKTBw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:52:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:61086 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758301AbXKTBw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:52:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,438,1188802800"; 
   d="scan'208";a="235002840"
Subject: Re: [PATCH 3/3 -mm] kexec based hibernation -v6: kexec
	hibernate/resume
From: "Huang, Ying" <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <200711191922.44008.rjw@sisk.pl>
References: <1195455769.10291.26.camel@caritas-dev.intel.com>
	 <200711191922.44008.rjw@sisk.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 20 Nov 2007 09:56:48 +0800
Message-Id: <1195523808.11955.27.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 20 Nov 2007 01:52:53.0979 (UTC) FILETIME=[10B86AB0:01C82B18]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-19 at 19:22 +0100, Rafael J. Wysocki wrote:
> > +#ifdef CONFIG_KEXEC
> > +static void kexec_hibernate_power_down(void)
> > +{
> > +	switch (hibernation_mode) {
> > +	case HIBERNATION_TEST:
> > +	case HIBERNATION_TESTPROC:
> > +		break;
> > +	case HIBERNATION_REBOOT:
> > +		machine_restart(NULL);
> > +		break;
> > +	case HIBERNATION_PLATFORM:
> > +		if (!hibernation_ops)
> > +			break;
> > +		hibernation_ops->enter();
> 
> hibernation_platform_enter() should be used here (as of the current mainline).

The power_down will be called with interrupt disabled, device suspended,
non-boot CPU disabled. But the latest hibernate_platform_enter calls the
device_suspend, disable_nonboot_cpus etc function. So, I use
hibernation_ops->enter() directly instead of
hibernation_platform_enter().

> > +		/* We should never get here */
> > +		while (1);
> > +		break;
> > +	case HIBERNATION_SHUTDOWN:
> > +		machine_power_off();
> > +		break;
> > +	}
> > +	machine_halt();
> > +	/*
> > +	 * Valid image is on the disk, if we continue we risk serious data
> > +	 * corruption after resume.
> > +	 */
> > +	printk(KERN_CRIT "Please power me down manually\n");
> > +	while (1);
> > +}
> 
> Hm, what's the difference between the above function and power_down(),
> actually?

Same as above.

> > +
> > +int kexec_hibernate(struct kimage *image)
> > +{
> > +	int error;
> > +	int platform_mode = (hibernation_mode == HIBERNATION_PLATFORM);
> > +	unsigned long cmd_ret;
> > +
> > +	mutex_lock(&pm_mutex);
> > +
> > +	pm_prepare_console();
> > +	suspend_console();
> > +
> > +	error = pm_notifier_call_chain(PM_HIBERNATION_PREPARE);
> > +	if (error)
> > +		goto Resume_console;
> > +
> > +	error = platform_start(platform_mode);
> > +	if (error)
> > +		goto Resume_console;
> > +
> > +	error = device_suspend(PMSG_FREEZE);
> > +	if (error)
> > +		goto Resume_console;
> > +
> > +	error = platform_pre_snapshot(platform_mode);
> > +	if (error)
> > +		goto Resume_devices;
> > +
> > +	error = disable_nonboot_cpus();
> > +	if (error)
> > +		goto Resume_devices;
> 
> I wonder if it's viable to merge the above with hibernate() and
> hibernation_snapshot() somehow, to avoid code duplication?

Yes. Most code are duplicated. But there is one advantage not to merge
them: power_down can called with IRQ disabled to make it possible to
eliminate the freezer.

I think it is possible to merge the two implementation. I will try to do
it.

> Apart from the above, there's some new debug code to be added to disk.c
> in 2.6.25.  It's in the ACPI test tree right now and you can get it as
> individual patches from:
> http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.24-rc2/patches/
> (patches 10-12).
> 
> Please base your changes on top of that.

OK, I will do it.

Best Regards,
Huang Ying
