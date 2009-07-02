Return-Path: <linux-kernel-owner+w=401wt.eu-S1752515AbZGBAUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbZGBAUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 20:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbZGBAUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 20:20:38 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:4274
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752149AbZGBAUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 20:20:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvMBAIiaS0p8qMex/2dsb2JhbAAI0DGEEQWBOA
X-IronPort-AV: E=Sophos;i="4.42,329,1243785600"; 
   d="scan'208";a="432005056"
Subject: Re: [PATCH v2] gpiolib: allow poll(2) on gpio value
From: Ben Nizette <bn@niasdigital.com>
To: David Brownell <david-b@pacbell.net>
Cc: Daniel =?ISO-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
       linux-kernel@vger.kernel.org, Jani Nikula <ext-jani.1.nikula@nokia.com>
In-Reply-To: <200907011605.31154.david-b@pacbell.net>
References: <1244212590-15620-1-git-send-email-dg@emlix.com>
	 <1244637376-24666-1-git-send-email-dg@emlix.com>
	 <200907011605.31154.david-b@pacbell.net>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 02 Jul 2009 10:19:41 +1000
Message-Id: <1246493981.2980.35.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-01 at 16:05 -0700, David Brownell wrote:
> On Wednesday 10 June 2009, Daniel Glöckner wrote:
> > Many gpio chips allow to generate interrupts when the value of a pin
> > changes. This patch gives usermode application the opportunity to make
> > use of this feature by calling poll(2) on the /sys/class/gpio/gpioN/value
> > sysfs file. The edge to trigger can be set in the edge file in the same
> > directory. Possible values are "none", "rising", "falling", and "both".
> 
> Looks pretty clean.  Comments from anyone else?

FWIW I like it, though packing id in to upper bits of ->flags has a
certain appeal to me.

> 
> Presumably you tested this on Real Hardware(tm).  At one point
> I thought sysfs poll() support looked a bit flakey ... was it
> acting OK for you in the face of repeated triggers of events?

Has worked OK for me though of course there's no way to know how many
triggers occurred between polls

> 
> 
> > Using level triggers is not possible with current sysfs as poll will
> > not return if the value did not change. On the other hand edge triggers
> > are relative to the last read by the application and not to the start
> > of poll. So if there was an event between read and poll, poll will
> > return immediately.
> > 
> > Changes compared to v1:
> > - use workqueue to call sysfs_notify_dirent as it takes a spinlock
> 
> Do you mean "mutex"?  IRQ handing code can grab most
> spinocks ... so long as they're irq-safe spinlocks.
> Either way, if you need a mutex, add a comment saying
> why the work_struct is needed.

No, spinlock.  sysfs_notify() takes the sysfs mutex but if you've
already got a reference to the dirent and call sysfs_notify_dirent()
directly it just takes the sysfs_open_dirent_lock spinlock.

This can be taken from interrupt if you go through and make a few
s/spin_lock/spin_lock_irqsave/ (and _irqrestore) throughout the sysfs
infrastructure but prolly just moving to workqueue is easier.

> 
> 
> > - move reconfiguration into separate function
> > - allocate work_struct & co. as needed
> > - wrap additional element in gpio_desc in #ifdef CONFIG_GPIO_SYSFS
> > - rename poll_edge to edge
> > - update Documentation/ABI/testing/sysfs-gpio as well
> > - refer to poll syscall as "poll(2)"
> > - use BIT() and define trigger mask for more readable expressions
> > - whitespace changes
> 
> Even so, I have a few cosmetic comments.  :)
> 
>  
> > Signed-off-by: Daniel Glöckner <dg@emlix.com>
> > ---
> >  Documentation/ABI/testing/sysfs-gpio |    1 +
> >  Documentation/gpio.txt               |    7 ++
> >  drivers/gpio/gpiolib.c               |  176 +++++++++++++++++++++++++++++++++-
> >  3 files changed, 180 insertions(+), 4 deletions(-)
> > 
> > 
> > Due to the need for a work_struct (16 bytes) per polled pin I created a
> > poll_desc structure which also keeps the sysfs_dirent pointer. The memory
> > requirement in gpio_desc is still 4 bytes. Is this acceptable?
> 
> It's more like "one pointer" not "4 bytes" ... although most
> systems wanting this will be using 32-bit embedded CPUs.
> 
> So the additional *fixed* overhead is ARCH_NR_GPIOS*sizeof(void*),
> or 1 KByte on most systems.
> 
> 
> > I have looked into IDRs to store the pointer to the poll_desc structure.
> > It appears the interface is not designed to allow allocation of specific
> > numbers. One would have to rely on idr_get_new_above to return the number
> > passed in.

Which it will unless it's already allocated.  But yeah, it don't 'spose
it's documented behaviour.

>  Another possibility would be to use some of the 25 unused bits
> > of the flags variable to store the ID.

Not a bad plan methinks.

> 
> The reason to want to allocate about log2(ARCH_NR_GPIOS) of those
> bits would be to save that 1KByte.  This stuff isn't critical path,
> and most of that KByte will never be used... few systems will use
> more than two GPIOs for such event triggering.  An IDR would take
> less than 1KB in such a case, I think.
> 
> So the call isn't quite straightforward.  Maybe other folk have
> some feedback.

IDR will take less than 1K and it'll be nicely lost in the heap.
Packing in to upper bits of flags will take nothing at all - a nice
trick if you can pull it off.

	--Ben.



