Return-Path: <linux-kernel-owner+w=401wt.eu-S1761099AbXGMNE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761099AbXGMNE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 09:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758874AbXGMNEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 09:04:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:44290 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757622AbXGMNET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 09:04:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,537,1175497200"; 
   d="scan'208";a="105903929"
Subject: Re: [PATCH 2/2] Kexec jump: Kexec jump
From: "Huang, Ying" <ying.huang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <20070712094207.GG1866@elf.ucw.cz>
References: <1184167836.12556.15.camel@caritas-dev.intel.com>
	 <20070712094207.GG1866@elf.ucw.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Jul 2007 21:03:31 +0000
Message-Id: <1184360611.1069.23.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 13 Jul 2007 13:04:14.0793 (UTC) FILETIME=[50415B90:01C7C54E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 11:42 +0200, Pavel Machek wrote:
> > This patch provide the kexec based implementation of hibernation image
> > operation. Now, only jumping between original kernel and kexeced
> > kernel is supported, real image write/read/check will be provided in
> > next patches.
> 
> I'd prefer this not to use hibernation hooks... existing dumping
> infrastructure should be good enough to write resume image, no?
> 
> BTW... is this able to do kdump, then return back to the old kernel?
> That seems to be similar functionality to hibernation, and I was told
> it would be very welcome.

Yes. Just because there are so much similarity between them, many people
think they can be merged.

> > +static int kexec_suspend(void)
> > +{
> > +	int error;
> > +
> > +	local_irq_disable();
> > +	/* At this point, device_suspend() has been called, but *not*
> > +	 * device_power_down(). We *must* device_power_down() now.
> > +	 * Otherwise, drivers for some devices (e.g. interrupt controllers)
> > +	 * become desynchronized with the actual state of the hardware
> > +	 * at resume time, and evil weirdness ensues.
> > +	 */
> > +	error = device_power_down(PMSG_FREEZE);
> > +	if (error) {
> > +		printk(KERN_ERR "Some devices failed to power down, aborting suspend\n");
> > +		goto Enable_irqs;
> > +	}
> > +
> > +	save_processor_state();
> > +	error = kexec_jump(KEXEC_JUMP_TYPE_EXEC);
> > +	restore_processor_state();
> > +
> > +	/* NOTE:  device_power_up() is just a resume() for devices
> > +	 * that suspended with irqs off ... no overall powerup.
> > +	 */
> > +	device_power_up();
> > + Enable_irqs:
> > +	in_suspend = 0;
> > +	local_irq_enable();
> > +	return error;
> > +}
> ...
> > +static int kexec_resume(void)
> > +{
> > +	int error = 0;
> > +
> > +	local_irq_disable();
> > +	/* NOTE:  device_power_down() is just a suspend() with irqs off;
> > +	 * it has no special "power things down" semantics
> > +	 */
> > +	if (device_power_down(PMSG_PRETHAW))
> > +		printk(KERN_ERR "Some devices failed to power down, very bad\n");
> > +	/* We'll ignore saved state, but this gets preempt count (etc) right */
> > +	save_processor_state();
> > +	kexec_restore_backup();
> > +	error = kexec_jump(KEXEC_JUMP_TYPE_JUMP);
> > +	swsusp_free();
> > +	restore_processor_state();
> > +	touch_softlockup_watchdog();
> > +	device_power_up();
> > +	local_irq_enable();
> > +	return error;
> > +}
> 
> This seems like mostly generic stuff for going between two kernels,
> no? I'd prefer it not be hooked into hibernation infrastructure.

Yes. In fact, with device_suspend(...), disable_nonboot_cpus() and
enable_nonboot_cpus(), device_resume(...) around the above two
functions, the jumping between normal kernel and kexeced kernel can work
too. Maybe it is more approriate not to hook the kexec into current
hibernation. It seems that there are no much code shared between them
except device/CPU state quiescent/save/restore.

Best Regards,
Huang Ying
