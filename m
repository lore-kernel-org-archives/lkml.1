Return-Path: <linux-kernel-owner+w=401wt.eu-S1765488AbXGLUlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765488AbXGLUlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 16:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764535AbXGLUkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 16:40:13 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36632 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755827AbXGLUkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 16:40:11 -0400
Date: Thu, 12 Jul 2007 11:42:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 2/2] Kexec jump: Kexec jump
Message-ID: <20070712094207.GG1866@elf.ucw.cz>
References: <1184167836.12556.15.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184167836.12556.15.camel@caritas-dev.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This patch provide the kexec based implementation of hibernation image
> operation. Now, only jumping between original kernel and kexeced
> kernel is supported, real image write/read/check will be provided in
> next patches.

I'd prefer this not to use hibernation hooks... existing dumping
infrastructure should be good enough to write resume image, no?

BTW... is this able to do kdump, then return back to the old kernel?
That seems to be similar functionality to hibernation, and I was told
it would be very welcome.

> +static int kexec_suspend(void)
> +{
> +	int error;
> +
> +	local_irq_disable();
> +	/* At this point, device_suspend() has been called, but *not*
> +	 * device_power_down(). We *must* device_power_down() now.
> +	 * Otherwise, drivers for some devices (e.g. interrupt controllers)
> +	 * become desynchronized with the actual state of the hardware
> +	 * at resume time, and evil weirdness ensues.
> +	 */
> +	error = device_power_down(PMSG_FREEZE);
> +	if (error) {
> +		printk(KERN_ERR "Some devices failed to power down, aborting suspend\n");
> +		goto Enable_irqs;
> +	}
> +
> +	save_processor_state();
> +	error = kexec_jump(KEXEC_JUMP_TYPE_EXEC);
> +	restore_processor_state();
> +
> +	/* NOTE:  device_power_up() is just a resume() for devices
> +	 * that suspended with irqs off ... no overall powerup.
> +	 */
> +	device_power_up();
> + Enable_irqs:
> +	in_suspend = 0;
> +	local_irq_enable();
> +	return error;
> +}
...
> +static int kexec_resume(void)
> +{
> +	int error = 0;
> +
> +	local_irq_disable();
> +	/* NOTE:  device_power_down() is just a suspend() with irqs off;
> +	 * it has no special "power things down" semantics
> +	 */
> +	if (device_power_down(PMSG_PRETHAW))
> +		printk(KERN_ERR "Some devices failed to power down, very bad\n");
> +	/* We'll ignore saved state, but this gets preempt count (etc) right */
> +	save_processor_state();
> +	kexec_restore_backup();
> +	error = kexec_jump(KEXEC_JUMP_TYPE_JUMP);
> +	swsusp_free();
> +	restore_processor_state();
> +	touch_softlockup_watchdog();
> +	device_power_up();
> +	local_irq_enable();
> +	return error;
> +}

This seems like mostly generic stuff for going between two kernels,
no? I'd prefer it not be hooked into hibernation infrastructure.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
