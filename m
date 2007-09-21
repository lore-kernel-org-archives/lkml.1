Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbXIUIlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbXIUIlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 04:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbXIUIlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 04:41:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:64906 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbXIUIln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 04:41:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,282,1186383600"; 
   d="scan'208";a="299952969"
Subject: Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <m1y7f0k6p4.fsf@ebiederm.dsl.xmission.com>
References: <1190266447.21818.17.camel@caritas-dev.intel.com>
	 <m1y7f0k6p4.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Sep 2007 16:42:34 +0800
Message-Id: <1190364154.21818.182.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 21 Sep 2007 08:40:34.0560 (UTC) FILETIME=[1393E000:01C7FC2B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-20 at 22:01 -0600, Eric W. Biederman wrote:
> "Huang, Ying" <ying.huang@intel.com> writes:
> 
> > Index: linux-2.6.23-rc6/include/linux/kexec.h
> > ===================================================================
> > --- linux-2.6.23-rc6.orig/include/linux/kexec.h 2007-09-20 11:24:25.000000000
> > +0800
> > +++ linux-2.6.23-rc6/include/linux/kexec.h 2007-09-20 11:26:03.000000000 +0800
> > @@ -83,6 +83,7 @@
> >  
> >  	unsigned long start;
> >  	struct page *control_code_page;
> > +	struct page *swap_page;
> >  
> >  	unsigned long nr_segments;
> >  	struct kexec_segment segment[KEXEC_SEGMENT_MAX];
> > @@ -194,4 +195,12 @@
> >  static inline void crash_kexec(struct pt_regs *regs) { }
> >  static inline int kexec_should_crash(struct task_struct *p) { return 0; }
> >  #endif /* CONFIG_KEXEC */
> > +
> > +#ifdef CONFIG_KEXEC_JUMP
> > +extern int machine_kexec_jump(struct kimage *image);
> > +extern unsigned long kexec_jump_back_entry;
> > +extern int kexec_jump(void);
> > +#else /* !CONFIG_KEXEC_JUMP */
> > +static inline int kexec_jump(void) { return 0; }
> > +#endif /* CONFIG_KEXEC_JUMP */
> >  #endif /* LINUX_KEXEC_H */
> 
> Please the kexec_jump code just be triggered off of a flag in
> struct kimage.  We just need to define an extra flag to sys_kexec_load
> say KEXEC_RETURNS.  Ideally in the long term we would not have to
> do anything except to accept the flag.  Adding a flag makes
> a nice feature test if you want to see if your kernel supports
> the extended version of kexec.
> 
> Until we get the hibernation methods sorted out storing the flag in
> struct kimage and making the methods that we call conditional feels
> like a more maintainable interface.  Especially since we have to
> know at kexec image load time what we are going to do with the
> kexec image.

You mean we use KEXEC_RETURNS when do sys_kexec_load, then use ordinary
reboot command LINUX_REBOOT_CMD_KEXEC, which call kexec_jump conditional
based on KEXEC_RETURNS? This is reasonable. I will change it.

> > +#ifdef CONFIG_KEXEC_JUMP
> > +unsigned long kexec_jump_back_entry;
> > +
> > +int kexec_jump(void)
> > +{
> > +	int error;
> > +
> > +	if (!kexec_image)
> > +		return -EINVAL;
> 
> I understand where you are coming from with this implementation of
> kexec_jump but it looks like this is one of the big parts of this
> patch that have not reached their final form.
> 
> The line above is racy with sys_kexec_load.

Yes. I should use xchg(&kexec_image, NULL) as that of other kexec
related functions.

> > +	pm_prepare_console();
> > +	suspend_console();
> > +	error = device_suspend(PMSG_FREEZE);
> > +	if (error)
> > +		goto Resume_console;
> 
> This as everyone knows needs to be device_shutdown or a better hibernation
> replacement.

Yes.

> > +	error = disable_nonboot_cpus();
> > +	if (error)
> > +		goto Resume_devices;
> 
> Can't we just catch the noboot cpu's in a mutex.
> disable_nonboot_cpus is actually impossible to implement 100% reliably
> with current hardware.  But something smp_call_function so we trap them
> at a specific location and then the equivalent when we come back should
> be simple.  I guess the tricky part is bringing the cpus back up again.
> 
> Using the broken by design version of cpu hotplug really annoys me here.

I think this is not very simple. Given that we may jump back from the
kernel with SMP turned off, or from bootloader directly. But CPU hotplug
is another topic, I think it should be solved in another patch.

> > +	local_irq_disable();
> > +	/* At this point, device_suspend() has been called, but *not*
> > +	 * device_power_down(). We *must* device_power_down() now.
> > +	 * Otherwise, drivers for some devices (e.g. interrupt controllers)
> > +	 * become desynchronized with the actual state of the hardware
> > +	 * at resume time, and evil weirdness ensues.
> > +	 */
> > +	error = device_power_down(PMSG_FREEZE);
> > +	if (error)
> > +		goto Enable_irqs;
> 
> This of course should go away when we have the proper methods.
Yes.
> > +	save_processor_state();
> This line might even be reasonable.
> > +	error = machine_kexec_jump(kexec_image);
> > +	restore_processor_state();
> >
> > +	/* NOTE:  device_power_up() is just a resume() for devices
> > +	 * that suspended with irqs off ... no overall powerup.
> > +	 */
> > +	device_power_up();
> Yep this can go away.
Yes.
> > + Enable_irqs:
> > +	local_irq_enable();
> > +	enable_nonboot_cpus();
> 
> I haven't looked at the cpu start up code yet to see if it
> is generally implementable.  I would think so, but I guess
> we need to be careful with our data structures.
> 
> > + Resume_devices:
> > +	device_resume();
> This of course should change.
Yes.
> > + Resume_console:
> > +	resume_console();
> > +	pm_restore_console();
> 
> Odd.  I'm a little surprised that the console is the last
> thing we restore.  But it does make sense to treat it specially.
> 
> > +	return error;
> > +}
> > +#endif /* CONFIG_KEXEC_JUMP */

Best Regards,
Huang Ying
