Return-Path: <linux-kernel-owner+w=401wt.eu-S1764271AbXKTXmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764271AbXKTXmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762170AbXKTXmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:42:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46355 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760850AbXKTXma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:42:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 3/3 -mm] kexec based hibernation -v6: kexec hibernate/resume
Date: Wed, 21 Nov 2007 01:00:31 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1195455769.10291.26.camel@caritas-dev.intel.com> <200711200324.31180.rjw@sisk.pl> <1195527033.11955.50.camel@caritas-dev.intel.com>
In-Reply-To: <1195527033.11955.50.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711210100.32631.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 20 of November 2007, Huang, Ying wrote:
> On Tue, 2007-11-20 at 03:24 +0100, Rafael J. Wysocki wrote:
> > On Tuesday, 20 of November 2007, Huang, Ying wrote:
> > > On Mon, 2007-11-19 at 19:22 +0100, Rafael J. Wysocki wrote:
> > > > > +#ifdef CONFIG_KEXEC
> > > > > +static void kexec_hibernate_power_down(void)
> > > > > +{
> > > > > +	switch (hibernation_mode) {
> > > > > +	case HIBERNATION_TEST:
> > > > > +	case HIBERNATION_TESTPROC:
> > > > > +		break;
> > > > > +	case HIBERNATION_REBOOT:
> > > > > +		machine_restart(NULL);
> > > > > +		break;
> > > > > +	case HIBERNATION_PLATFORM:
> > > > > +		if (!hibernation_ops)
> > > > > +			break;
> > > > > +		hibernation_ops->enter();
> > > > 
> > > > hibernation_platform_enter() should be used here (as of the current mainline).
> > > 
> > > The power_down will be called with interrupt disabled, device suspended,
> > > non-boot CPU disabled. But the latest hibernate_platform_enter calls the
> > > device_suspend, disable_nonboot_cpus etc function. So, I use
> > > hibernation_ops->enter() directly instead of
> > > hibernation_platform_enter().
> > 
> > Hm, you need to call device_power_down(PMSG_SUSPEND) before
> > hibernation_ops->enter().
> > 
> > Also, all of the ACPI global calls need to be carried out before that and the
> > devices should be suspended rather than shut down in that case.
> > 
> > That's why hibernation_platform_enter() has been introduced, BTW.
> 
> Situation is a little different between u/swsusp and khiberantion.
> 
> u/swsusp:
> 
> platform_start();
> suspend console();
> device_suspend(PMSG_FREEZE);
> platform_pre_snapshot();
> disable_nonboot_cpus();
> local_irq_disable();
> device_power_down(PMSG_FREEZE);
> /* create snapshot */
> device_power_up();
> local_irq_enable();
> enable_nonboot_cpus();
> platform_finish();
> device_resume();
> resume_console();
> /* write the image out */
> hibernation_ops->start();
> suspend_console();
> device_suspend(PMSG_SUSPEND);
> hibernation_ops->prepare();
> disable_nonboot_cpus();
> local_irq_disable();
> device_power_down(PMSG_SUSPEND);
> hibernation_ops->enter();
> 
> khibernation:
> 
> suspend_console();
> platform_start();
> device_suspend(PMSG_FREEZE);
> platform_pre_snapshot();
> disable_nonboot_cpus();
> local_irq_disable();
> device_power_down(PMSG_FREEZE);
> /* jump to kexeced (hibernating) kernel */
> /* in kexeced kernel */
> device_power_up();
> local_irq_eanble();
> enable_nonboot_cpus();

You should call platform_finish() here, or device_resume() will not work
appropriately on some systems.

However, after platform_finish() has been executed, the ACPI firmware will
assume that the hibernation has been canceled, so you need to tell it that
you'd like to go into the low power state after all.

> device_resume();
> resume_console();
> /* write the image */

For this reason, you have to call hibernation_ops->start() once again
and the other functions like in the swsusp case, in that order.

> suspend_console();
> device_suspend(PMSG_FREEZE);
> disable_nonboot_cpus();
> local_irq_disable();
> device_power_down(PMSG_FREEZE);
> /* jump to original (hibernated) kernel */

This looks too fragile to my eyes.

Why don't you call hibernation_ops->enter() directly from the "kexeced" kernel?

Rafael
