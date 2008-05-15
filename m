Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbYEOBhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbYEOBhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 21:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbYEOBhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 21:37:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:42098 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbYEOBhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 21:37:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,489,1204531200"; 
   d="scan'208";a="247018590"
Subject: Re: [PATCH -mm] kexec jump -v9
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <m13aok1pt1.fsf@frodo.ebiederm.org>
References: <1204773188.4707.109.camel@caritas-dev.intel.com>
	 <m13aok1pt1.fsf@frodo.ebiederm.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 15 May 2008 09:42:19 +0800
Message-ID: <1210815739.23707.74.camel@caritas-dev.intel.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 15 May 2008 01:35:53.0721 (UTC) FILETIME=[03B72690:01C8B62C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-14 at 15:30 -0700, Eric W. Biederman wrote:
[...]
> >  
> > +	if (image->preserve_context) {
> > +		KJUMP_MAGIC(control_page) = KJUMP_MAGIC_NUMBER;
> > +		if (kexec_jump_save_cpu(control_page)) {
> > +			image->start = KJUMP_ENTRY(control_page);
> > +			return;
> 
> Tricky, and I expect unnecessary.
> We should be able to just have relocate_new_kernel return?

OK, I will check this. Maybe we can move CPU state saving code into
relocate_new_kernel.

[...]
> > -static void kernel_kexec(void)
> > +static int kernel_kexec(void)
> >  {
> > +	int ret = -ENOSYS;
> >  #ifdef CONFIG_KEXEC
> > -	struct kimage *image;
> > -	image = xchg(&kexec_image, NULL);
> > -	if (!image)
> > -		return;
> > -	kernel_restart_prepare(NULL);
> > -	printk(KERN_EMERG "Starting new kernel\n");
> > -	machine_shutdown();
> > -	machine_kexec(image);
> > +	if (xchg(&kexec_lock, 1))
> > +		return -EBUSY;
> > +	if (!kexec_image) {
> > +		ret = -EINVAL;
> > +		goto unlock;
> > +	}
> > +	if (!kexec_image->preserve_context) {
> > +		kernel_restart_prepare(NULL);
> > +		printk(KERN_EMERG "Starting new kernel\n");
> > +		machine_shutdown();
> > +	}
> > +	ret = kexec_jump(kexec_image);
> > +unlock:
> > +	xchg(&kexec_lock, 0);
> >  #endif
> 
> Ugh.  No.  Not sharing the shutdown methods with reboot and
> the normal kexec path looks like a recipe for failure to me.
> 
> This looks like where we really need to have the conversation.
> What methods do we use to shutdown the system.
> 
> My take on the situation is this.  For proper handling we
> need driver device_detach and device_reattach methods.
> 
> With the following semantics.  The device_detach methods
> will disable DMA and place the hardware in a sane state
> from which the device driver can reclaim and reinitialize it,
> but the hardware will not be touched.
> 
> device_reattach reattaches the driver to the hardware.

Yes. Current device PM callback is not suitable for hibernation (kexec
based or original). I think we can collaborate with Rafael J. Wysocki on
the new device drivers hibernation callbacks.

> So looking at this patch I see two very productive directions
> we can go.
> 1) A patch that just fixes up the kexec infrastructure code
>    so it implements the swap page and provides the kernel
>    reentry point.  And doesn't handle the upper layer
>    user interface portion.
> 
> 2) A patch that renames device_shutdown to device_detach.
>    And starts implementing the driver hooks needed from
>    a resumable kexec.

OK. I can separate the patch into two patches.

Best Regards,
Huang Ying

