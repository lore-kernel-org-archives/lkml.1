Return-Path: <linux-kernel-owner+w=401wt.eu-S1757265AbXKTCtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbXKTCtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbXKTCtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 21:49:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:23877 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbXKTCtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 21:49:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,438,1188802800"; 
   d="scan'208";a="275935598"
Subject: Re: [PATCH 3/3 -mm] kexec based hibernation -v6: kexec
	hibernate/resume
From: "Huang, Ying" <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <200711200324.31180.rjw@sisk.pl>
References: <1195455769.10291.26.camel@caritas-dev.intel.com>
	 <200711191922.44008.rjw@sisk.pl>
	 <1195523808.11955.27.camel@caritas-dev.intel.com>
	 <200711200324.31180.rjw@sisk.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 20 Nov 2007 10:50:33 +0800
Message-Id: <1195527033.11955.50.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 20 Nov 2007 02:46:40.0201 (UTC) FILETIME=[93B2D390:01C82B1F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-20 at 03:24 +0100, Rafael J. Wysocki wrote:
> On Tuesday, 20 of November 2007, Huang, Ying wrote:
> > On Mon, 2007-11-19 at 19:22 +0100, Rafael J. Wysocki wrote:
> > > > +#ifdef CONFIG_KEXEC
> > > > +static void kexec_hibernate_power_down(void)
> > > > +{
> > > > +	switch (hibernation_mode) {
> > > > +	case HIBERNATION_TEST:
> > > > +	case HIBERNATION_TESTPROC:
> > > > +		break;
> > > > +	case HIBERNATION_REBOOT:
> > > > +		machine_restart(NULL);
> > > > +		break;
> > > > +	case HIBERNATION_PLATFORM:
> > > > +		if (!hibernation_ops)
> > > > +			break;
> > > > +		hibernation_ops->enter();
> > > 
> > > hibernation_platform_enter() should be used here (as of the current mainline).
> > 
> > The power_down will be called with interrupt disabled, device suspended,
> > non-boot CPU disabled. But the latest hibernate_platform_enter calls the
> > device_suspend, disable_nonboot_cpus etc function. So, I use
> > hibernation_ops->enter() directly instead of
> > hibernation_platform_enter().
> 
> Hm, you need to call device_power_down(PMSG_SUSPEND) before
> hibernation_ops->enter().
> 
> Also, all of the ACPI global calls need to be carried out before that and the
> devices should be suspended rather than shut down in that case.
> 
> That's why hibernation_platform_enter() has been introduced, BTW.

Situation is a little different between u/swsusp and khiberantion.

u/swsusp:

platform_start();
suspend console();
device_suspend(PMSG_FREEZE);
platform_pre_snapshot();
disable_nonboot_cpus();
local_irq_disable();
device_power_down(PMSG_FREEZE);
/* create snapshot */
device_power_up();
local_irq_enable();
enable_nonboot_cpus();
platform_finish();
device_resume();
resume_console();
/* write the image out */
hibernation_ops->start();
suspend_console();
device_suspend(PMSG_SUSPEND);
hibernation_ops->prepare();
disable_nonboot_cpus();
local_irq_disable();
device_power_down(PMSG_SUSPEND);
hibernation_ops->enter();

khibernation:

suspend_console();
platform_start();
device_suspend(PMSG_FREEZE);
platform_pre_snapshot();
disable_nonboot_cpus();
local_irq_disable();
device_power_down(PMSG_FREEZE);
/* jump to kexeced (hibernating) kernel */
/* in kexeced kernel */
device_power_up();
local_irq_eanble();
enable_nonboot_cpus();
device_resume();
resume_console();
/* write the image */
suspend_console();
device_suspend(PMSG_FREEZE);
disable_nonboot_cpus();
local_irq_disable();
device_power_down(PMSG_FREEZE);
/* jump to original (hibernated) kernel */
/* in original kernel */
hibernation_ops->enter();

The difference is:

- In u/swsusp, ACPI methods are executed twice, before writing out the
image and after writing out the image.
- After writing out the image, the PMSG_SUSPEND is used instead of
PMSG_FREEZE.

Some questions:

- What is the difference between PMSG_SUSPEND and PMSG_FREEZE?
- The ACPI methods should be executed once or twice? According to ACPI
specification?

Best Regards,
Huang Ying
