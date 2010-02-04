Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465Ab0BDQqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 11:46:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45598 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758370Ab0BDQqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 11:46:01 -0500
Date: Thu, 4 Feb 2010 08:46:08 -0800
From: Greg KH <gregkh@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>, Cong Wang <amwang@redhat.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
Message-ID: <20100204164608.GA17825@suse.de>
References: <1265283496.24455.1939.camel@laptop> <Pine.LNX.4.44L0.1002041027070.2470-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1002041027070.2470-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 11:35:28AM -0500, Alan Stern wrote:
> Greg:
> 
> You have accepted Thomas's patch "drivers/base: Convert dev->sem to
> mutex".  It generates lockdep violations galore during device probing
> and removal!  Luckily lockdep is smart enough only to print the first
> occurrence.  Here's what I get early on during bootup:

Ugh, I forgot this is why we haven't done this yet.

Thomas, you didn't see these warnings?

> [    0.149911] ACPI: EC: Look up EC in DSDT
> [    0.170665] ACPI: Executed 1 blocks of module-level executable AML code
> [    0.198111] ACPI: Interpreter enabled
> [    0.198267] ACPI: (supports S0 S3 S4 S5)
> [    0.198802] ACPI: Using IOAPIC for interrupt routing
> [    0.266493] 
> [    0.266496] =============================================
> [    0.266775] [ INFO: possible recursive locking detected ]
> [    0.266917] 2.6.33-rc6 #1
> [    0.267051] ---------------------------------------------
> [    0.267192] swapper/1 is trying to acquire lock:
> [    0.267332]  (&dev->mutex){+.+...}, at: [<c11496be>] __driver_attach+0x38/0x63
> [    0.267683] 
> [    0.267685] but task is already holding lock:
> [    0.267953]  (&dev->mutex){+.+...}, at: [<c11496b2>] __driver_attach+0x2c/0x63
> [    0.268000] 
> [    0.268000] other info that might help us debug this:
> [    0.268000] 1 lock held by swapper/1:
> [    0.268000]  #0:  (&dev->mutex){+.+...}, at: [<c11496b2>] __driver_attach+0x2c/0x63
> [    0.268000] 
> [    0.268000] stack backtrace:
> [    0.268000] Pid: 1, comm: swapper Not tainted 2.6.33-rc6 #1
> [    0.268000] Call Trace:
> [    0.268000]  [<c11c819e>] ? printk+0xf/0x11
> [    0.268000]  [<c1041c9b>] __lock_acquire+0x804/0xb47
> [    0.268000]  [<c10b2026>] ? sysfs_addrm_finish+0x19/0xe2
> [    0.268000]  [<c1042020>] lock_acquire+0x42/0x59
> [    0.268000]  [<c11496be>] ? __driver_attach+0x38/0x63
> [    0.268000]  [<c11c90c6>] __mutex_lock_common+0x39/0x38f
> [    0.268000]  [<c11496be>] ? __driver_attach+0x38/0x63
> [    0.268000]  [<c11c94ab>] mutex_lock_nested+0x2b/0x33
> [    0.268000]  [<c11496be>] ? __driver_attach+0x38/0x63
> [    0.268000]  [<c11496be>] __driver_attach+0x38/0x63
> [    0.268000]  [<c1148e0a>] bus_for_each_dev+0x3d/0x67
> [    0.268000]  [<c11494cf>] driver_attach+0x14/0x16
> [    0.268000]  [<c1149686>] ? __driver_attach+0x0/0x63
> [    0.268000]  [<c11491c1>] bus_add_driver+0x92/0x1c5
> [    0.268000]  [<c114990f>] driver_register+0x79/0xe0
> [    0.268000]  [<c1106d32>] acpi_bus_register_driver+0x3a/0x3c
> [    0.268000]  [<c131999f>] acpi_power_init+0x3f/0x5e
> [    0.268000]  [<c1319422>] acpi_init+0x28e/0x2c8
> [    0.268000]  [<c1319194>] ? acpi_init+0x0/0x2c8
> [    0.268000]  [<c1001139>] do_one_initcall+0x4c/0x136
> [    0.268000]  [<c130130b>] kernel_init+0x11c/0x16d
> [    0.268000]  [<c13011ef>] ? kernel_init+0x0/0x16d
> [    0.268000]  [<c1002cba>] kernel_thread_helper+0x6/0x10
> [    0.268485] ACPI: Power Resource [GFAN] (on)
> 
> 
> On Thu, 4 Feb 2010, Peter Zijlstra wrote:
> 
> > The device tree had the problem that we could basically hold a device
> > lock and an unspecified number of parent locks (iirc this was due to
> > device probing, where we hold the bus lock while probing/adding child
> > device, recursively). 
> > 
> > If we place each dev->lock into the same class (which would naively
> > happen), then this would lead to recursive lock warnings. The proposed
> > solution for this is to create MAX_LOCK_DEPTH classes and assign them to
> > the dev->lock depending on the depth in the device tree (Alan said that
> > MAX_LOCK_DEPTH is sufficient for all practical cases).
> > 
> > static struct lock_class_key dev_tree_classes[MAX_LOCK_DEPTH];
> > 
> > device_add() or thereabouts would have something like:
> > 
> > #ifdef CONFIG_PROVE_LOCKING
> > 	BUG_ON(dev->depth >= MAX_LOCK_DEPTH);
> > 	lockdep_set_class(dev->lock, &dev_tree_classes[dev->depth]);
> > #endif
> 
> Unfortunately this doesn't really work.  Here is a patch implementing
> the scheme:
> 
> Index: usb-2.6/drivers/base/core.c
> ===================================================================
> --- usb-2.6.orig/drivers/base/core.c
> +++ usb-2.6/drivers/base/core.c
> @@ -22,6 +22,7 @@
>  #include <linux/kallsyms.h>
>  #include <linux/mutex.h>
>  #include <linux/async.h>
> +#include <linux/sched.h>
>  
>  #include "base.h"
>  #include "power/power.h"
> @@ -671,6 +672,26 @@ static void setup_parent(struct device *
>  		dev->kobj.parent = kobj;
>  }
>  
> +#ifdef CONFIG_PROVE_LOCKING
> +static struct lock_class_key dev_tree_classes[MAX_LOCK_DEPTH];
> +
> +static void setup_mutex_depth(struct device *dev, struct device *parent)
> +{
> +	int depth = 0;
> +
> +	/* Dynamically determine the device's depth in the device tree */
> +	while (parent) {
> +		++depth;
> +		parent = parent->parent;
> +	}
> +	BUG_ON(depth > MAX_LOCK_DEPTH);
> +	lockdep_set_class(&dev->mutex, &dev_tree_classes[depth]);
> +}
> +#else
> +static inline void setup_mutex_depth(struct device *dev,
> +		struct device *parent) {}
> +#endif
> +
>  static int device_add_class_symlinks(struct device *dev)
>  {
>  	int error;
> @@ -912,6 +933,7 @@ int device_add(struct device *dev)
>  
>  	parent = get_device(dev->parent);
>  	setup_parent(dev, parent);
> +	setup_mutex_depth(dev, parent);
>  
>  	/* use parent numa_node */
>  	if (parent)
> 
> 
> This doesn't address the fact that we really have multiple device trees
> (for example, class devices are handled separately from normal
> devices).  With the above patch installed, I still get lockdep
> violations farther on during boot:
> 
> [    0.272332] pci_bus 0000:00: on NUMA node 0
> [    0.272355] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.273503] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
> [    0.279205] 
> [    0.279208] =============================================
> [    0.279485] [ INFO: possible recursive locking detected ]
> [    0.279628] 2.6.33-rc6 #2
> [    0.279763] ---------------------------------------------
> [    0.279905] swapper/1 is trying to acquire lock:
> [    0.280000]  (&dev_tree_classes[depth]#2){+.+.+.}, at: [<c1149776>] device_attach+0x14/0x6e
> [    0.280000] 
> [    0.280000] but task is already holding lock:
> [    0.280000]  (&dev_tree_classes[depth]#2){+.+.+.}, at: [<c11496de>] __driver_attach+0x2c/0x63
> [    0.280000] 
> [    0.280000] other info that might help us debug this:
> [    0.280000] 2 locks held by swapper/1:
> [    0.280000]  #0:  (&dev_tree_classes[depth]#2){+.+.+.}, at: [<c11496de>] __driver_attach+0x2c/0x63
> [    0.280000]  #1:  (&dev_tree_classes[depth]#3){+.+.+.}, at: [<c11496ea>] __driver_attach+0x38/0x63
> [    0.280000] 
> [    0.280000] stack backtrace:
> [    0.280000] Pid: 1, comm: swapper Not tainted 2.6.33-rc6 #2
> [    0.280000] Call Trace:
> [    0.280000]  [<c11c81ce>] ? printk+0xf/0x11
> [    0.280000]  [<c1041c9b>] __lock_acquire+0x804/0xb47
> [    0.280000]  [<c101a73d>] ? spin_unlock_irqrestore+0x8/0xa
> [    0.280000]  [<c101a891>] ? __wake_up+0x32/0x3b
> [    0.280000]  [<c1042020>] lock_acquire+0x42/0x59
> [    0.280000]  [<c1149776>] ? device_attach+0x14/0x6e
> [    0.280000]  [<c11c90f6>] __mutex_lock_common+0x39/0x38f
> [    0.280000]  [<c1149776>] ? device_attach+0x14/0x6e
> [    0.280000]  [<c1040e2e>] ? trace_hardirqs_on+0xb/0xd
> [    0.280000]  [<c10ed5a7>] ? kobject_uevent_env+0x2e9/0x30a
> [    0.280000]  [<c10ed5a7>] ? kobject_uevent_env+0x2e9/0x30a
> [    0.280000]  [<c11c94db>] mutex_lock_nested+0x2b/0x33
> [    0.280000]  [<c1149776>] ? device_attach+0x14/0x6e
> [    0.280000]  [<c1149776>] device_attach+0x14/0x6e
> [    0.280000]  [<c1148aa1>] bus_probe_device+0x1b/0x30
> [    0.280000]  [<c1147b6c>] device_add+0x310/0x458
> [    0.280000]  [<c10f96ac>] pci_bus_add_device+0xf/0x30
> [    0.280000]  [<c10f96f0>] pci_bus_add_devices+0x23/0xdd
> [    0.280000]  [<c11c011b>] ? acpi_pci_root_add+0x1cf/0x1ff
> [    0.280000]  [<c11088a3>] acpi_pci_root_start+0x11/0x15
> [    0.280000]  [<c1106370>] acpi_start_single_object+0x1e/0x3f
> [    0.280000]  [<c11064a9>] acpi_device_probe+0x78/0xf4
> [    0.280000]  [<c1149632>] driver_probe_device+0x87/0x107
> [    0.280000]  [<c11496f9>] __driver_attach+0x47/0x63
> [    0.280000]  [<c1148e36>] bus_for_each_dev+0x3d/0x67
> [    0.280000]  [<c11494fb>] driver_attach+0x14/0x16
> [    0.280000]  [<c11496b2>] ? __driver_attach+0x0/0x63
> [    0.280000]  [<c11491ed>] bus_add_driver+0x92/0x1c5
> [    0.280000]  [<c1319798>] ? acpi_pci_root_init+0x0/0x25
> [    0.280000]  [<c114993b>] driver_register+0x79/0xe0
> [    0.280000]  [<c1319798>] ? acpi_pci_root_init+0x0/0x25
> [    0.280000]  [<c1106d32>] acpi_bus_register_driver+0x3a/0x3c
> [    0.280000]  [<c13197ae>] acpi_pci_root_init+0x16/0x25
> [    0.280000]  [<c1001139>] do_one_initcall+0x4c/0x136
> [    0.280000]  [<c130130b>] kernel_init+0x11c/0x16d
> [    0.280000]  [<c13011ef>] ? kernel_init+0x0/0x16d
> [    0.280000]  [<c1002cba>] kernel_thread_helper+0x6/0x10
> [    0.328206] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
> [    0.329223] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
> 
> 
> > Then there was a problem were we could lock all child devices while
> > holding the parent device lock (forgot why though), this would, on
> > taking the second child dev->lock, again lead to recursive lock
> > warnings. 
> 
> AFAIK, the code that used to do this is no longer present.  There may 
> be other places where it is still done, but I'm not aware of any.
> 
> However in view of the other difficulties, it still doesn't seem
> possible to make device mutexes work with lockdep.  I suggest removing 
> Thomas's patch.

Unless Thomas or anyone else thinks of something that can solve these
problems, I will do so.

thanks,

greg k-h
