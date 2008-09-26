Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbYIZGmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbYIZGmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 02:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbYIZGmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 02:42:44 -0400
Received: from colo.lackof.org ([198.49.126.79]:51617 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbYIZGmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 02:42:42 -0400
Date: Fri, 26 Sep 2008 00:42:27 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, suresh.b.siddha@intel.com,
       benh@kernel.crashing.org, jbarnes@virtuousgeek.org,
       rdunlap@xenotime.net, mtk.manpages@gmail.com,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] Rewrite MSI-HOWTO
Message-ID: <20080926064227.GA13687@colo.lackof.org>
References: <20080711005719.GO14894@parisc-linux.org> <1215738002-4961-3-git-send-email-matthew@wil.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215738002-4961-3-git-send-email-matthew@wil.cx>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 09:00:00PM -0400, Matthew Wilcox wrote:
> I didn't find the previous version very useful, so I rewrote it.
> Also move it to the PCI subdirectory of Documentation.
...

Willy
[Catching up on my email since I was on vacation in July.]

If this patch set can still be resurrected, please add:
Reviewed-by: Grant Grundler <grundler@parisc-linux.org>

...
> diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
> new file mode 100644
> index 0000000..6eb9b6a
> --- /dev/null
> +++ b/Documentation/PCI/MSI-HOWTO.txt
> @@ -0,0 +1,318 @@
> +		The MSI Driver Guide HOWTO
> +	Tom L Nguyen tom.l.nguyen@intel.com
> +			10/03/2003
> +	Revised Feb 12, 2004 by Martine Silbermann
> +		email: Martine.Silbermann@hp.com
> +	Revised Jun 25, 2004 by Tom L Nguyen
> +	Revised Jul  9, 2008 by Matthew Wilcox <willy@linux.intel.com>
> +		Copyright 2003, 2008 Intel Corporation
> +
> +1. About this guide
> +
> +This guide describes the basics of Message Signaled Interrupts (MSIs),
> +the advantages of using MSI over traditional interrupt mechanisms,
> +and how to change your driver to use MSI or MSI-X.
> +
> +
> +2. What are MSIs?
> +
> +Message Signaled Interrupt (MSI) is an optional feature for devices
> +which implement the PCI Local Bus Specification Revision 2.2 and later.
> +MSI enables a device to generate an interrupt by sending a normal write
> +to a special address in the host chipset that is translated into a CPU
> +interrupt.  MSI-X (introduced in PCI 3.0) is a more flexible scheme
> +than MSI.  It allows for greater control over what interrupts can be
> +generated and supports a greater number of interrupts.

Greater control over where interrupts can be directed (not generated)
and the granularity at which they can be allocated.

> +A device indicates MSI support by implementing the MSI or the MSI-X
> +capability in its PCI configuration space.  It may implement both the
> +MSI capability structure and the MSI-X capability structure, but only
> +one may be enabled.
> +
> +
> +3. Why use MSIs?
> +
> +Pin-based PCI interrupts are often shared amongst several devices.
> +To support this, the kernel must call each interrupt handler associated
> +with an interrupt which leads to increased latency for the interrupt
> +handlers which are registered last.
> +
> +When a device performs DMA to memory and raises a pin-based interrupt, it
> +is possible that the interrupt may arrive before all the data has arrived
> +in memory (this becomes more likely with devices behind PCI-PCI bridges).
> +In order to assure that all DMA has arrived in memory, the interrupt

"all DMA" --> "all DMA data"

> +handler must read a register on the device which raised the interrupt.
> +PCI ordering rules require that the writes be flushed to memory before
> +the value can be returned from the register.

"writes" -> "DMA writes"
"value" -> "MMIO read data"

> ... MSI avoids this problem
> +as the interrupt-generating write cannot pass the DMA writes, so by the
> +time the interrupt is raised, the driver knows that the DMA has completed.

"DMA has completed" -> "DMA data is visible to the CPU."

> +
> +Using MSI enables the device to support more interrupts, allowing
> +each interrupt to be specialised to a different purpose.  This allows
> +infrequent conditions (such as errors) to be given their own interrupt and
> +not have to check for errors during the normal interrupt handling path.

This is one use.  I'm told cciss driver does this. If so, it would be good
to point at a working example, even if it's messy.

The other use case is to distribute both initiating IO requests and handle
IO completions on multiple CPUs as well. This is the Multi-Queue case
where each Queue pair is associated with one MSI-X. I expect several
NIC drivers could serve as examples here. I just haven't looked at
new NIC drivers in quite a while.

> +4. How to use MSIs
> +
> +PCI devices are initialised to use pin-based interrupts.  The device
> +driver has to set up the device to use MSI or MSI-X.  Not all machines
> +support MSIs correctly, and for those machines, the APIs described below
> +will simply fail and the device will continue to use pin-based interrupts.
> +
> +4.1 Include kernel support for MSIs
> +
> +To support MSI or MSI-X, the kernel must be built with the CONFIG_PCI_MSI
> +option enabled.  This option is only available on some architectures,
> +and it may depend on some other options also being set.  For example,
> +on x86, you must also enable X86_UP_APIC or SMP in order to see the
> +CONFIG_PCI_MSI option.
> +
> +4.2 Using MSI
> +
> +Most of the hard work is done for the driver in the PCI layer.  It simply
> +has to request that the PCI layer set up the MSI capability for this
> +device.
> +
> +4.2.1 pci_enable_msi
> +
> +int pci_enable_msi(struct pci_dev *dev)
> +
> +A successful call will allocate ONE interrupt to the device, regardless
> +of how many MSIs the device supports.  The device will be switched from
> +pin-based interrupt mode to MSI mode.  The dev->irq number is changed
> +to a new number which represents the message signaled interrupt.
> +This function should be called before the driver calls request_irq()
> +since enabling MSIs disables the pin-based IRQ and the driver will not
> +receive interrupts on the old interrupt.
> +
> +4.2.2 pci_enable_msi_block
> +
> +int pci_enable_msi_block(struct pci_dev *pdev, int count)
> +
> +This variation allows a device driver to request multiple MSIs.  The MSI
> +specification only allows interrupts to be allocated in powers of two,
> +up to a maximum of 2^5 (32).
> +
> +If this function returns 0, it has succeeded in allocating as many
> +interrupts as the driver requested (it may have allocated more in order
> +to satisfy the power-of-two requirement).  In this case, the function
> +enables MSI on this device and updates pdev->irq to be the lowest of
> +the new interrupts assigned to it.  The other interrupts assigned to
> +the device are in the range pdev->irq to pdev->irq + count - 1.
> +
> +If this function returns a negative number, it indicates an error and
> +the driver should not attempt to request any more MSI interrupts for
> +this device.  If this function returns a positive number, it will be
> +less than 'count' and indicate the number of interrupts that could have
> +been allocated.  In neither case will the irq value have been
> +updated, nor will the device have been switched into MSI mode.
> +
> +The device driver must decide what action to take if
> +pci_enable_msi_block() returns a value less than the number asked for.
> +Some devices can make use of fewer interrupts than the maximum they
> +request; in this case the driver should call pci_enable_msi_block()
> +again.  Note that it is not guaranteed to succeed, even when the
> +'count' has been reduced to the value returned from a previous call to
> +pci_enable_msi_block().  This is because there are multiple constraints
> +on the number of vectors that can be allocated; pci_enable_msi_block()
> +will return as soon as it finds any constraint that doesn't allow the
> +call to succeed.
> +
> +4.2.3 pci_disable_msi
> +
> +void pci_disable_msi(struct pci_dev *dev)
> +
> +This API should be used to undo the effect of pci_enable_msi() or
> +pci_enable_msi_block().  This API restores dev->irq to the pin-based
> +interrupt number and frees the previously allocated message signaled
> +interrupt(s).  The interrupt may subsequently be assigned to another
> +device, so drivers should not cache the value of pdev->irq.
> +
> +A device driver must always call free_irq() on the interrupt(s)
> +for which it has called request_irq() before calling this function.
> +Failure to do so will result in a BUG_ON(), the device will be left with
> +MSI enabled and will leak its vector.
> +
> +4.3 Using MSI-X
> +
> +The MSI-X capability is much more flexible than the MSI capability.
> +It supports up to 2048 interrupts, each of which can be separately
> +assigned.  To support this flexibility, drivers must use an array of
> +`struct msix_entry':
> +
> +struct msix_entry {
> +	u16 	vector; /* kernel uses to write alloc vector */
> +	u16	entry; /* driver uses to specify entry */
> +};
> +
> +This allows for the device to use these interrupts in a sparse fashion;
> +for example it could use interrupts 3 and 1027 and allocate only a
> +two-element array.  The driver is expected to fill in the 'entry' value
> +in each element of the array to indicate which entries it wants the kernel have
> +interrupts assigned for.  It is invalid to fill in two entries with the
> +same number.
> +
> +4.3.1 pci_enable_msix
> +
> +int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
> +
> +Calling this function asks the PCI subsystem to allocate 'nvec' MSIs.
> +The 'entries' argument is a pointer to an array of msix_entry structs
> +which should be at least 'nvec' entries in size.  On success, the
> +function will return 0 and the device will have been switched into
> +MSI-X interrupt mode.  The 'vector' elements in each entry will have
> +been filled in with the interrupt number.
> +
> +If this function returns a negative number, it indicates an error and
> +the driver should not attempt to allocate any more MSI-X interrupts for
> +this device.  If it returns a positive number, it indicates the maximum
> +number of interrupt vectors that could have been allocated.
> +
> +This function, in contrast with pci_enable_msi(), does not adjust
> +pdev->irq.  The device will not generate interrupts for this interrupt
> +number once MSI-X is enabled.  The device driver is responsible for
> +keeping track of the interrupts assigned to the MSI-X vectors so it can
> +free them again later.

I'm guessing the device driver is expected to call "request_irq()" for
each msix_entry it is allocated. And later free_irq() for each one too.
I see you've mentioned that in the "disable_msix()" description but
think request_irq() use should be called out here first.

> +
> +Device drivers should normally call this function once per device
> +during the initialization phase.
> +
> +4.3.2 pci_disable_msix
> +
> +void pci_disable_msix(struct pci_dev *dev)
> +
> +This API should be used to undo the effect of pci_enable_msix().  It frees
> +the previously allocated message signaled interrupts.  The interrupts may
> +subsequently be assigned to another device, so drivers should not cache
> +the value of the 'vector' elements over a call to pci_disable_msix().
> +
> +A device driver must always call free_irq() on the interrupt(s)
> +for which it has called request_irq() before calling this function.
> +Failure to do so will result in a BUG_ON(), the device will be left with
> +MSI enabled and will leak its vector.
> +
> +4.3.3 The MSI-X Table
> +
> +The MSI-X capability specifies a BAR and offset within that BAR for the
> +MSI-X Table.  This address is mapped by the PCI subsystem, and should be
> +considered to be off limits to the device driver.  If the driver wishes to
> +mask or unmask an interrupt, it should call disable_irq() / enable_irq().
> +
> +4.4 Handling devices implementing both MSI and MSI-X capabilities
> +
> +If a device implements both MSI and MSI-X capabilities, it can
> +run in either MSI mode or MSI-X mode but not both simultaneously.
> +This is a requirement of the PCI spec, and it is enforced by the
> +PCI layer.  Calling pci_enable_msi() when MSI-X is already enabled or
> +pci_enable_msix() when MSI is already enabled will result in an error.
> +If a device driver wishes to switch between MSI and MSI-X at runtime,
> +it must first quiesce the device, then switch it back to pin-interrupt
> +mode, before calling pci_enable_msi() or pci_enable_msix() and resuming
> +operation.  This is not expected to be a common operation but may be
> +useful for debugging or testing during development.
> +
> +4.5 Considerations when using MSIs
> +
> +4.5.1 Choosing between MSI-X and MSI
> +
> +If your device supports both MSI-X and MSI capabilities, you should use
> +the MSI-X facilities in preference to the MSI facilities.  As mentioned
> +above, MSI-X supports any number of interrupts between 1 and 2048.
> +In constrast, MSI is restricted to a maximum of 32 interrupts (and
> +must be a power of two).  In addition, the MSI interrupt vectors must
> +be allocated consecutively, so the system may not be able to allocate
> +as many vectors for MSI as it could for MSI-X.  On some platforms, MSI
> +interrupts must all be targetted at the same set of CPUs whereas MSI-X
> +interrupts can all be targetted at different CPUs.
> +
> +4.5.2 Spinlocks
> +
> +Most device drivers have a per-device spinlock which is taken in the
> +interrupt handler.  With pin-based interrupts or a single MSI, it is not
> +necessary to disable interrupts (Linux guarantees the same interrupt will
> +not be re-entered).  If a device uses multiple interrupts, the driver
> +must disable interrupts while the lock is held.  If the device sends
> +a different interrupt, the driver will deadlock trying to recursively
> +acquire the spinlock.
> +
> +There are two solutions.  The first is to take the
> +lock with spin_lock_irqsave() or spin_lock_irq() (see
> +Documentation/DocBook/kernel-locking).  The second is to specify
> +IRQF_DISABLED to request_irq() so that the kernel runs the entire
> +interrupt routine with interrupts disabled.
> +
> +If your MSI interrupt routine does not hold the lock for the whole time
> +it is running, the first solution may be best.  The second solution is
> +normally preferred as it avoids making two transitions from interrupt
> +disabled to enabled and back again.
> +
> +4.6 How to tell whether MSI/MSI-X is enabled on a device
> +
> +Using lspci -v (as root) will show some devices with "Message Signalled
> +Interrupts" and others with "MSI-X".  Each of these capabilities have an
> +'Enable' flag which will be followed with either "+" (enabled) or "-"
> +(disabled).
> +
> +
> +5. MSI quirks
> +
> +Several PCI chipsets or devices are known not to support MSI.
> +The PCI stack provides three possible ways to disable MSIs :
> +* on a single device
> +* on all devices behind a specific bridge
> +* globally
> +
> +5.1. Disabling MSI on a single device
> +
> +Under some circumstances it might be required to disable MSI on a single
> +device.  This may be achieved by either not calling pci_enable_msi()
> +for this device, or setting the pci_dev->no_msi flag before (most of
> +the time in a quirk).
> +
> +5.2. Disabling MSI below a bridge
> +
> +The vast majority of MSI quirks are required by PCI bridges not
> +being able to route MSI between busses. In this case, MSI have to be
> +disabled on all devices behind this bridge. It is achieves by setting
> +the PCI_BUS_FLAGS_NO_MSI flag in the pci_bus->bus_flags of the bridge
> +subordinate bus. There is no need to set the same flag on bridges that
> +are below the broken bridge. When pci_enable_msi() is called to enable
> +MSI on a device, pci_msi_supported() takes care of checking the NO_MSI
> +flag in all parent busses of the device.
> +
> +Some bridges actually support dynamic MSI support enabling/disabling
> +by changing some bits in their PCI configuration space (especially
> +the Hypertransport chipsets such as the nVidia nForce and Serverworks
> +HT2000). It may then be required to update the NO_MSI flag on the
> +corresponding devices in the sysfs hierarchy. To enable MSI support
> +on device "0000:00:0e", do:
> +
> +	echo 1 > /sys/bus/pci/devices/0000:00:0e/msi_bus
> +
> +To disable MSI support, echo 0 instead of 1.  It should be
> +used with caution since changing this value might break interrupts.
> +
> +5.3. Disabling MSI globally
> +
> +Some extreme cases may require to disable MSI globally on the system.
> +For now, the only known case is a Serverworks PCI-X chipsets (MSI are
> +not supported on several busses that are not all connected to the
> +chipset in the Linux PCI hierarchy). In the vast majority of other
> +cases, disabling only behind a specific bridge is enough.
> +
> +For debugging purpose, the user may also pass pci=nomsi on the kernel
> +command-line to explicitly disable MSI globally. But, once the appro-
> +priate quirks are added to the kernel, this option should not be
> +required anymore.
> +
> +5.4. Finding why MSI cannot be enabled on a device
> +
> +Assuming that MSI are not enabled on a device, you should look at
> +dmesg to find messages that quirks may output when disabling MSI
> +on some devices, some bridges or even globally.
> +Then, lspci -t gives the list of bridges above a device. Reading
> +/sys/bus/pci/devices/0000:00:0e/msi_bus will tell you whether MSI
> +are enabled (1) or disabled (0). In 0 is found in a single bridge
> +msi_bus file above the device, MSI cannot be enabled.

The remainder looked fine to me. I should re-read the original
sometime too just to compare. But I'm happy besides the nits
I pointed out.

thanks,

grant
