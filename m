Return-Path: <linux-kernel-owner+w=401wt.eu-S1761361AbYGKBD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761361AbYGKBD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761267AbYGKBDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 21:03:42 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:39782 "EHLO
	mail-09.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761256AbYGKBDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 21:03:37 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, suresh.b.siddha@intel.com,
       benh@kernel.crashing.org, jbarnes@virtuousgeek.org,
       rdunlap@xenotime.net, mtk.manpages@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH] Rewrite MSI-HOWTO
Date: Thu, 10 Jul 2008 21:00:00 -0400
Message-Id: <1215738002-4961-3-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <20080711005719.GO14894@parisc-linux.org>
References: <20080711005719.GO14894@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't find the previous version very useful, so I rewrote it.
Also move it to the PCI subdirectory of Documentation.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 Documentation/MSI-HOWTO.txt     |  511 ---------------------------------------
 Documentation/PCI/MSI-HOWTO.txt |  318 ++++++++++++++++++++++++
 2 files changed, 318 insertions(+), 511 deletions(-)
 delete mode 100644 Documentation/MSI-HOWTO.txt
 create mode 100644 Documentation/PCI/MSI-HOWTO.txt

diff --git a/Documentation/MSI-HOWTO.txt b/Documentation/MSI-HOWTO.txt
deleted file mode 100644
index a51f693..0000000
--- a/Documentation/MSI-HOWTO.txt
+++ /dev/null
@@ -1,511 +0,0 @@
-		The MSI Driver Guide HOWTO
-	Tom L Nguyen tom.l.nguyen@intel.com
-			10/03/2003
-	Revised Feb 12, 2004 by Martine Silbermann
-		email: Martine.Silbermann@hp.com
-	Revised Jun 25, 2004 by Tom L Nguyen
-
-1. About this guide
-
-This guide describes the basics of Message Signaled Interrupts (MSI),
-the advantages of using MSI over traditional interrupt mechanisms,
-and how to enable your driver to use MSI or MSI-X. Also included is
-a Frequently Asked Questions (FAQ) section.
-
-1.1 Terminology
-
-PCI devices can be single-function or multi-function.  In either case,
-when this text talks about enabling or disabling MSI on a "device
-function," it is referring to one specific PCI device and function and
-not to all functions on a PCI device (unless the PCI device has only
-one function).
-
-2. Copyright 2003 Intel Corporation
-
-3. What is MSI/MSI-X?
-
-Message Signaled Interrupt (MSI), as described in the PCI Local Bus
-Specification Revision 2.3 or later, is an optional feature, and a
-required feature for PCI Express devices. MSI enables a device function
-to request service by sending an Inbound Memory Write on its PCI bus to
-the FSB as a Message Signal Interrupt transaction. Because MSI is
-generated in the form of a Memory Write, all transaction conditions,
-such as a Retry, Master-Abort, Target-Abort or normal completion, are
-supported.
-
-A PCI device that supports MSI must also support pin IRQ assertion
-interrupt mechanism to provide backward compatibility for systems that
-do not support MSI. In systems which support MSI, the bus driver is
-responsible for initializing the message address and message data of
-the device function's MSI/MSI-X capability structure during device
-initial configuration.
-
-An MSI capable device function indicates MSI support by implementing
-the MSI/MSI-X capability structure in its PCI capability list. The
-device function may implement both the MSI capability structure and
-the MSI-X capability structure; however, the bus driver should not
-enable both.
-
-The MSI capability structure contains Message Control register,
-Message Address register and Message Data register. These registers
-provide the bus driver control over MSI. The Message Control register
-indicates the MSI capability supported by the device. The Message
-Address register specifies the target address and the Message Data
-register specifies the characteristics of the message. To request
-service, the device function writes the content of the Message Data
-register to the target address. The device and its software driver
-are prohibited from writing to these registers.
-
-The MSI-X capability structure is an optional extension to MSI. It
-uses an independent and separate capability structure. There are
-some key advantages to implementing the MSI-X capability structure
-over the MSI capability structure as described below.
-
-	- Support a larger maximum number of vectors per function.
-
-	- Provide the ability for system software to configure
-	each vector with an independent message address and message
-	data, specified by a table that resides in Memory Space.
-
-        - MSI and MSI-X both support per-vector masking. Per-vector
-	masking is an optional extension of MSI but a required
-	feature for MSI-X. Per-vector masking provides the kernel the
-	ability to mask/unmask a single MSI while running its
-	interrupt service routine. If per-vector masking is
-	not supported, then the device driver should provide the
-	hardware/software synchronization to ensure that the device
-	generates MSI when the driver wants it to do so.
-
-4. Why use MSI?
-
-As a benefit to the simplification of board design, MSI allows board
-designers to remove out-of-band interrupt routing. MSI is another
-step towards a legacy-free environment.
-
-Due to increasing pressure on chipset and processor packages to
-reduce pin count, the need for interrupt pins is expected to
-diminish over time. Devices, due to pin constraints, may implement
-messages to increase performance.
-
-PCI Express endpoints uses INTx emulation (in-band messages) instead
-of IRQ pin assertion. Using INTx emulation requires interrupt
-sharing among devices connected to the same node (PCI bridge) while
-MSI is unique (non-shared) and does not require BIOS configuration
-support. As a result, the PCI Express technology requires MSI
-support for better interrupt performance.
-
-Using MSI enables the device functions to support two or more
-vectors, which can be configured to target different CPUs to
-increase scalability.
-
-5. Configuring a driver to use MSI/MSI-X
-
-By default, the kernel will not enable MSI/MSI-X on all devices that
-support this capability. The CONFIG_PCI_MSI kernel option
-must be selected to enable MSI/MSI-X support.
-
-5.1 Including MSI/MSI-X support into the kernel
-
-To allow MSI/MSI-X capable device drivers to selectively enable
-MSI/MSI-X (using pci_enable_msi()/pci_enable_msix() as described
-below), the VECTOR based scheme needs to be enabled by setting
-CONFIG_PCI_MSI during kernel config.
-
-Since the target of the inbound message is the local APIC, providing
-CONFIG_X86_LOCAL_APIC must be enabled as well as CONFIG_PCI_MSI.
-
-5.2 Configuring for MSI support
-
-Due to the non-contiguous fashion in vector assignment of the
-existing Linux kernel, this version does not support multiple
-messages regardless of a device function is capable of supporting
-more than one vector. To enable MSI on a device function's MSI
-capability structure requires a device driver to call the function
-pci_enable_msi() explicitly.
-
-5.2.1 API pci_enable_msi
-
-int pci_enable_msi(struct pci_dev *dev)
-
-With this new API, a device driver that wants to have MSI
-enabled on its device function must call this API to enable MSI.
-A successful call will initialize the MSI capability structure
-with ONE vector, regardless of whether a device function is
-capable of supporting multiple messages. This vector replaces the
-pre-assigned dev->irq with a new MSI vector. To avoid a conflict
-of the new assigned vector with existing pre-assigned vector requires
-a device driver to call this API before calling request_irq().
-
-5.2.2 API pci_disable_msi
-
-void pci_disable_msi(struct pci_dev *dev)
-
-This API should always be used to undo the effect of pci_enable_msi()
-when a device driver is unloading. This API restores dev->irq with
-the pre-assigned IOAPIC vector and switches a device's interrupt
-mode to PCI pin-irq assertion/INTx emulation mode.
-
-Note that a device driver should always call free_irq() on the MSI vector
-that it has done request_irq() on before calling this API. Failure to do
-so results in a BUG_ON() and a device will be left with MSI enabled and
-leaks its vector.
-
-5.2.3 MSI mode vs. legacy mode diagram
-
-The below diagram shows the events which switch the interrupt
-mode on the MSI-capable device function between MSI mode and
-PIN-IRQ assertion mode.
-
-	 ------------   pci_enable_msi 	 ------------------------
-	|	     | <===============	| 			 |
-	| MSI MODE   |	  	     	| PIN-IRQ ASSERTION MODE |
-	| 	     | ===============>	|			 |
- 	 ------------	pci_disable_msi  ------------------------
-
-
-Figure 1. MSI Mode vs. Legacy Mode
-
-In Figure 1, a device operates by default in legacy mode. Legacy
-in this context means PCI pin-irq assertion or PCI-Express INTx
-emulation. A successful MSI request (using pci_enable_msi()) switches
-a device's interrupt mode to MSI mode. A pre-assigned IOAPIC vector
-stored in dev->irq will be saved by the PCI subsystem and a new
-assigned MSI vector will replace dev->irq.
-
-To return back to its default mode, a device driver should always call
-pci_disable_msi() to undo the effect of pci_enable_msi(). Note that a
-device driver should always call free_irq() on the MSI vector it has
-done request_irq() on before calling pci_disable_msi(). Failure to do
-so results in a BUG_ON() and a device will be left with MSI enabled and
-leaks its vector. Otherwise, the PCI subsystem restores a device's
-dev->irq with a pre-assigned IOAPIC vector and marks the released
-MSI vector as unused.
-
-Once being marked as unused, there is no guarantee that the PCI
-subsystem will reserve this MSI vector for a device. Depending on
-the availability of current PCI vector resources and the number of
-MSI/MSI-X requests from other drivers, this MSI may be re-assigned.
-
-For the case where the PCI subsystem re-assigns this MSI vector to
-another driver, a request to switch back to MSI mode may result
-in being assigned a different MSI vector or a failure if no more
-vectors are available.
-
-5.3 Configuring for MSI-X support
-
-Due to the ability of the system software to configure each vector of
-the MSI-X capability structure with an independent message address
-and message data, the non-contiguous fashion in vector assignment of
-the existing Linux kernel has no impact on supporting multiple
-messages on an MSI-X capable device functions. To enable MSI-X on
-a device function's MSI-X capability structure requires its device
-driver to call the function pci_enable_msix() explicitly.
-
-The function pci_enable_msix(), once invoked, enables either
-all or nothing, depending on the current availability of PCI vector
-resources. If the PCI vector resources are available for the number
-of vectors requested by a device driver, this function will configure
-the MSI-X table of the MSI-X capability structure of a device with
-requested messages. To emphasize this reason, for example, a device
-may be capable for supporting the maximum of 32 vectors while its
-software driver usually may request 4 vectors. It is recommended
-that the device driver should call this function once during the
-initialization phase of the device driver.
-
-Unlike the function pci_enable_msi(), the function pci_enable_msix()
-does not replace the pre-assigned IOAPIC dev->irq with a new MSI
-vector because the PCI subsystem writes the 1:1 vector-to-entry mapping
-into the field vector of each element contained in a second argument.
-Note that the pre-assigned IOAPIC dev->irq is valid only if the device
-operates in PIN-IRQ assertion mode. In MSI-X mode, any attempt at
-using dev->irq by the device driver to request for interrupt service
-may result in unpredictable behavior.
-
-For each MSI-X vector granted, a device driver is responsible for calling
-other functions like request_irq(), enable_irq(), etc. to enable
-this vector with its corresponding interrupt service handler. It is
-a device driver's choice to assign all vectors with the same
-interrupt service handler or each vector with a unique interrupt
-service handler.
-
-5.3.1 Handling MMIO address space of MSI-X Table
-
-The PCI 3.0 specification has implementation notes that MMIO address
-space for a device's MSI-X structure should be isolated so that the
-software system can set different pages for controlling accesses to the
-MSI-X structure. The implementation of MSI support requires the PCI
-subsystem, not a device driver, to maintain full control of the MSI-X
-table/MSI-X PBA (Pending Bit Array) and MMIO address space of the MSI-X
-table/MSI-X PBA.  A device driver is prohibited from requesting the MMIO
-address space of the MSI-X table/MSI-X PBA. Otherwise, the PCI subsystem
-will fail enabling MSI-X on its hardware device when it calls the function
-pci_enable_msix().
-
-5.3.2 API pci_enable_msix
-
-int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
-
-This API enables a device driver to request the PCI subsystem
-to enable MSI-X messages on its hardware device. Depending on
-the availability of PCI vectors resources, the PCI subsystem enables
-either all or none of the requested vectors.
-
-Argument 'dev' points to the device (pci_dev) structure.
-
-Argument 'entries' is a pointer to an array of msix_entry structs.
-The number of entries is indicated in argument 'nvec'.
-struct msix_entry is defined in /driver/pci/msi.h:
-
-struct msix_entry {
-	u16 	vector; /* kernel uses to write alloc vector */
-	u16	entry; /* driver uses to specify entry */
-};
-
-A device driver is responsible for initializing the field 'entry' of
-each element with a unique entry supported by MSI-X table. Otherwise,
--EINVAL will be returned as a result. A successful return of zero
-indicates the PCI subsystem completed initializing each of the requested
-entries of the MSI-X table with message address and message data.
-Last but not least, the PCI subsystem will write the 1:1
-vector-to-entry mapping into the field 'vector' of each element. A
-device driver is responsible for keeping track of allocated MSI-X
-vectors in its internal data structure.
-
-A return of zero indicates that the number of MSI-X vectors was
-successfully allocated. A return of greater than zero indicates
-MSI-X vector shortage. Or a return of less than zero indicates
-a failure. This failure may be a result of duplicate entries
-specified in second argument, or a result of no available vector,
-or a result of failing to initialize MSI-X table entries.
-
-5.3.3 API pci_disable_msix
-
-void pci_disable_msix(struct pci_dev *dev)
-
-This API should always be used to undo the effect of pci_enable_msix()
-when a device driver is unloading. Note that a device driver should
-always call free_irq() on all MSI-X vectors it has done request_irq()
-on before calling this API. Failure to do so results in a BUG_ON() and
-a device will be left with MSI-X enabled and leaks its vectors.
-
-5.3.4 MSI-X mode vs. legacy mode diagram
-
-The below diagram shows the events which switch the interrupt
-mode on the MSI-X capable device function between MSI-X mode and
-PIN-IRQ assertion mode (legacy).
-
-	 ------------   pci_enable_msix(,,n) ------------------------
-	|	     | <===============	    | 			     |
-	| MSI-X MODE |	  	     	    | PIN-IRQ ASSERTION MODE |
-	| 	     | ===============>	    |			     |
- 	 ------------	pci_disable_msix     ------------------------
-
-Figure 2. MSI-X Mode vs. Legacy Mode
-
-In Figure 2, a device operates by default in legacy mode. A
-successful MSI-X request (using pci_enable_msix()) switches a
-device's interrupt mode to MSI-X mode. A pre-assigned IOAPIC vector
-stored in dev->irq will be saved by the PCI subsystem; however,
-unlike MSI mode, the PCI subsystem will not replace dev->irq with
-assigned MSI-X vector because the PCI subsystem already writes the 1:1
-vector-to-entry mapping into the field 'vector' of each element
-specified in second argument.
-
-To return back to its default mode, a device driver should always call
-pci_disable_msix() to undo the effect of pci_enable_msix(). Note that
-a device driver should always call free_irq() on all MSI-X vectors it
-has done request_irq() on before calling pci_disable_msix(). Failure
-to do so results in a BUG_ON() and a device will be left with MSI-X
-enabled and leaks its vectors. Otherwise, the PCI subsystem switches a
-device function's interrupt mode from MSI-X mode to legacy mode and
-marks all allocated MSI-X vectors as unused.
-
-Once being marked as unused, there is no guarantee that the PCI
-subsystem will reserve these MSI-X vectors for a device. Depending on
-the availability of current PCI vector resources and the number of
-MSI/MSI-X requests from other drivers, these MSI-X vectors may be
-re-assigned.
-
-For the case where the PCI subsystem re-assigned these MSI-X vectors
-to other drivers, a request to switch back to MSI-X mode may result
-being assigned with another set of MSI-X vectors or a failure if no
-more vectors are available.
-
-5.4 Handling function implementing both MSI and MSI-X capabilities
-
-For the case where a function implements both MSI and MSI-X
-capabilities, the PCI subsystem enables a device to run either in MSI
-mode or MSI-X mode but not both. A device driver determines whether it
-wants MSI or MSI-X enabled on its hardware device. Once a device
-driver requests for MSI, for example, it is prohibited from requesting
-MSI-X; in other words, a device driver is not permitted to ping-pong
-between MSI mod MSI-X mode during a run-time.
-
-5.5 Hardware requirements for MSI/MSI-X support
-
-MSI/MSI-X support requires support from both system hardware and
-individual hardware device functions.
-
-5.5.1 Required x86 hardware support
-
-Since the target of MSI address is the local APIC CPU, enabling
-MSI/MSI-X support in the Linux kernel is dependent on whether existing
-system hardware supports local APIC. Users should verify that their
-system supports local APIC operation by testing that it runs when
-CONFIG_X86_LOCAL_APIC=y.
-
-In SMP environment, CONFIG_X86_LOCAL_APIC is automatically set;
-however, in UP environment, users must manually set
-CONFIG_X86_LOCAL_APIC. Once CONFIG_X86_LOCAL_APIC=y, setting
-CONFIG_PCI_MSI enables the VECTOR based scheme and the option for
-MSI-capable device drivers to selectively enable MSI/MSI-X.
-
-Note that CONFIG_X86_IO_APIC setting is irrelevant because MSI/MSI-X
-vector is allocated new during runtime and MSI/MSI-X support does not
-depend on BIOS support. This key independency enables MSI/MSI-X
-support on future IOxAPIC free platforms.
-
-5.5.2 Device hardware support
-
-The hardware device function supports MSI by indicating the
-MSI/MSI-X capability structure on its PCI capability list. By
-default, this capability structure will not be initialized by
-the kernel to enable MSI during the system boot. In other words,
-the device function is running on its default pin assertion mode.
-Note that in many cases the hardware supporting MSI have bugs,
-which may result in system hangs. The software driver of specific
-MSI-capable hardware is responsible for deciding whether to call
-pci_enable_msi or not. A return of zero indicates the kernel
-successfully initialized the MSI/MSI-X capability structure of the
-device function. The device function is now running on MSI/MSI-X mode.
-
-5.6 How to tell whether MSI/MSI-X is enabled on device function
-
-At the driver level, a return of zero from the function call of
-pci_enable_msi()/pci_enable_msix() indicates to a device driver that
-its device function is initialized successfully and ready to run in
-MSI/MSI-X mode.
-
-At the user level, users can use the command 'cat /proc/interrupts'
-to display the vectors allocated for devices and their interrupt
-MSI/MSI-X modes ("PCI-MSI"/"PCI-MSI-X"). Below shows MSI mode is
-enabled on a SCSI Adaptec 39320D Ultra320 controller.
-
-           CPU0       CPU1
-  0:     324639          0    IO-APIC-edge  timer
-  1:       1186          0    IO-APIC-edge  i8042
-  2:          0          0          XT-PIC  cascade
- 12:       2797          0    IO-APIC-edge  i8042
- 14:       6543          0    IO-APIC-edge  ide0
- 15:          1          0    IO-APIC-edge  ide1
-169:          0          0   IO-APIC-level  uhci-hcd
-185:          0          0   IO-APIC-level  uhci-hcd
-193:        138         10         PCI-MSI  aic79xx
-201:         30          0         PCI-MSI  aic79xx
-225:         30          0   IO-APIC-level  aic7xxx
-233:         30          0   IO-APIC-level  aic7xxx
-NMI:          0          0
-LOC:     324553     325068
-ERR:          0
-MIS:          0
-
-6. MSI quirks
-
-Several PCI chipsets or devices are known to not support MSI.
-The PCI stack provides 3 possible levels of MSI disabling:
-* on a single device
-* on all devices behind a specific bridge
-* globally
-
-6.1. Disabling MSI on a single device
-
-Under some circumstances it might be required to disable MSI on a
-single device.  This may be achieved by either not calling pci_enable_msi()
-or all, or setting the pci_dev->no_msi flag before (most of the time
-in a quirk).
-
-6.2. Disabling MSI below a bridge
-
-The vast majority of MSI quirks are required by PCI bridges not
-being able to route MSI between busses. In this case, MSI have to be
-disabled on all devices behind this bridge. It is achieves by setting
-the PCI_BUS_FLAGS_NO_MSI flag in the pci_bus->bus_flags of the bridge
-subordinate bus. There is no need to set the same flag on bridges that
-are below the broken bridge. When pci_enable_msi() is called to enable
-MSI on a device, pci_msi_supported() takes care of checking the NO_MSI
-flag in all parent busses of the device.
-
-Some bridges actually support dynamic MSI support enabling/disabling
-by changing some bits in their PCI configuration space (especially
-the Hypertransport chipsets such as the nVidia nForce and Serverworks
-HT2000). It may then be required to update the NO_MSI flag on the
-corresponding devices in the sysfs hierarchy. To enable MSI support
-on device "0000:00:0e", do:
-
-	echo 1 > /sys/bus/pci/devices/0000:00:0e/msi_bus
-
-To disable MSI support, echo 0 instead of 1. Note that it should be
-used with caution since changing this value might break interrupts.
-
-6.3. Disabling MSI globally
-
-Some extreme cases may require to disable MSI globally on the system.
-For now, the only known case is a Serverworks PCI-X chipsets (MSI are
-not supported on several busses that are not all connected to the
-chipset in the Linux PCI hierarchy). In the vast majority of other
-cases, disabling only behind a specific bridge is enough.
-
-For debugging purpose, the user may also pass pci=nomsi on the kernel
-command-line to explicitly disable MSI globally. But, once the appro-
-priate quirks are added to the kernel, this option should not be
-required anymore.
-
-6.4. Finding why MSI cannot be enabled on a device
-
-Assuming that MSI are not enabled on a device, you should look at
-dmesg to find messages that quirks may output when disabling MSI
-on some devices, some bridges or even globally.
-Then, lspci -t gives the list of bridges above a device. Reading
-/sys/bus/pci/devices/0000:00:0e/msi_bus will tell you whether MSI
-are enabled (1) or disabled (0). In 0 is found in a single bridge
-msi_bus file above the device, MSI cannot be enabled.
-
-7. FAQ
-
-Q1. Are there any limitations on using the MSI?
-
-A1. If the PCI device supports MSI and conforms to the
-specification and the platform supports the APIC local bus,
-then using MSI should work.
-
-Q2. Will it work on all the Pentium processors (P3, P4, Xeon,
-AMD processors)? In P3 IPI's are transmitted on the APIC local
-bus and in P4 and Xeon they are transmitted on the system
-bus. Are there any implications with this?
-
-A2. MSI support enables a PCI device sending an inbound
-memory write (0xfeexxxxx as target address) on its PCI bus
-directly to the FSB. Since the message address has a
-redirection hint bit cleared, it should work.
-
-Q3. The target address 0xfeexxxxx will be translated by the
-Host Bridge into an interrupt message. Are there any
-limitations on the chipsets such as Intel 8xx, Intel e7xxx,
-or VIA?
-
-A3. If these chipsets support an inbound memory write with
-target address set as 0xfeexxxxx, as conformed to PCI
-specification 2.3 or latest, then it should work.
-
-Q4. From the driver point of view, if the MSI is lost because
-of errors occurring during inbound memory write, then it may
-wait forever. Is there a mechanism for it to recover?
-
-A4. Since the target of the transaction is an inbound memory
-write, all transaction termination conditions (Retry,
-Master-Abort, Target-Abort, or normal completion) are
-supported. A device sending an MSI must abide by all the PCI
-rules and conditions regarding that inbound memory write. So,
-if a retry is signaled it must retry, etc... We believe that
-the recommendation for Abort is also a retry (refer to PCI
-specification 2.3 or latest).
diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
new file mode 100644
index 0000000..6eb9b6a
--- /dev/null
+++ b/Documentation/PCI/MSI-HOWTO.txt
@@ -0,0 +1,318 @@
+		The MSI Driver Guide HOWTO
+	Tom L Nguyen tom.l.nguyen@intel.com
+			10/03/2003
+	Revised Feb 12, 2004 by Martine Silbermann
+		email: Martine.Silbermann@hp.com
+	Revised Jun 25, 2004 by Tom L Nguyen
+	Revised Jul  9, 2008 by Matthew Wilcox <willy@linux.intel.com>
+		Copyright 2003, 2008 Intel Corporation
+
+1. About this guide
+
+This guide describes the basics of Message Signaled Interrupts (MSIs),
+the advantages of using MSI over traditional interrupt mechanisms,
+and how to change your driver to use MSI or MSI-X.
+
+
+2. What are MSIs?
+
+Message Signaled Interrupt (MSI) is an optional feature for devices
+which implement the PCI Local Bus Specification Revision 2.2 and later.
+MSI enables a device to generate an interrupt by sending a normal write
+to a special address in the host chipset that is translated into a CPU
+interrupt.  MSI-X (introduced in PCI 3.0) is a more flexible scheme
+than MSI.  It allows for greater control over what interrupts can be
+generated and supports a greater number of interrupts.
+
+A device indicates MSI support by implementing the MSI or the MSI-X
+capability in its PCI configuration space.  It may implement both the
+MSI capability structure and the MSI-X capability structure, but only
+one may be enabled.
+
+
+3. Why use MSIs?
+
+Pin-based PCI interrupts are often shared amongst several devices.
+To support this, the kernel must call each interrupt handler associated
+with an interrupt which leads to increased latency for the interrupt
+handlers which are registered last.
+
+When a device performs DMA to memory and raises a pin-based interrupt, it
+is possible that the interrupt may arrive before all the data has arrived
+in memory (this becomes more likely with devices behind PCI-PCI bridges).
+In order to assure that all DMA has arrived in memory, the interrupt
+handler must read a register on the device which raised the interrupt.
+PCI ordering rules require that the writes be flushed to memory before
+the value can be returned from the register.  MSI avoids this problem
+as the interrupt-generating write cannot pass the DMA writes, so by the
+time the interrupt is raised, the driver knows that the DMA has completed.
+
+Using MSI enables the device to support more interrupts, allowing
+each interrupt to be specialised to a different purpose.  This allows
+infrequent conditions (such as errors) to be given their own interrupt and
+not have to check for errors during the normal interrupt handling path.
+
+
+4. How to use MSIs
+
+PCI devices are initialised to use pin-based interrupts.  The device
+driver has to set up the device to use MSI or MSI-X.  Not all machines
+support MSIs correctly, and for those machines, the APIs described below
+will simply fail and the device will continue to use pin-based interrupts.
+
+4.1 Include kernel support for MSIs
+
+To support MSI or MSI-X, the kernel must be built with the CONFIG_PCI_MSI
+option enabled.  This option is only available on some architectures,
+and it may depend on some other options also being set.  For example,
+on x86, you must also enable X86_UP_APIC or SMP in order to see the
+CONFIG_PCI_MSI option.
+
+4.2 Using MSI
+
+Most of the hard work is done for the driver in the PCI layer.  It simply
+has to request that the PCI layer set up the MSI capability for this
+device.
+
+4.2.1 pci_enable_msi
+
+int pci_enable_msi(struct pci_dev *dev)
+
+A successful call will allocate ONE interrupt to the device, regardless
+of how many MSIs the device supports.  The device will be switched from
+pin-based interrupt mode to MSI mode.  The dev->irq number is changed
+to a new number which represents the message signaled interrupt.
+This function should be called before the driver calls request_irq()
+since enabling MSIs disables the pin-based IRQ and the driver will not
+receive interrupts on the old interrupt.
+
+4.2.2 pci_enable_msi_block
+
+int pci_enable_msi_block(struct pci_dev *pdev, int count)
+
+This variation allows a device driver to request multiple MSIs.  The MSI
+specification only allows interrupts to be allocated in powers of two,
+up to a maximum of 2^5 (32).
+
+If this function returns 0, it has succeeded in allocating as many
+interrupts as the driver requested (it may have allocated more in order
+to satisfy the power-of-two requirement).  In this case, the function
+enables MSI on this device and updates pdev->irq to be the lowest of
+the new interrupts assigned to it.  The other interrupts assigned to
+the device are in the range pdev->irq to pdev->irq + count - 1.
+
+If this function returns a negative number, it indicates an error and
+the driver should not attempt to request any more MSI interrupts for
+this device.  If this function returns a positive number, it will be
+less than 'count' and indicate the number of interrupts that could have
+been allocated.  In neither case will the irq value have been
+updated, nor will the device have been switched into MSI mode.
+
+The device driver must decide what action to take if
+pci_enable_msi_block() returns a value less than the number asked for.
+Some devices can make use of fewer interrupts than the maximum they
+request; in this case the driver should call pci_enable_msi_block()
+again.  Note that it is not guaranteed to succeed, even when the
+'count' has been reduced to the value returned from a previous call to
+pci_enable_msi_block().  This is because there are multiple constraints
+on the number of vectors that can be allocated; pci_enable_msi_block()
+will return as soon as it finds any constraint that doesn't allow the
+call to succeed.
+
+4.2.3 pci_disable_msi
+
+void pci_disable_msi(struct pci_dev *dev)
+
+This API should be used to undo the effect of pci_enable_msi() or
+pci_enable_msi_block().  This API restores dev->irq to the pin-based
+interrupt number and frees the previously allocated message signaled
+interrupt(s).  The interrupt may subsequently be assigned to another
+device, so drivers should not cache the value of pdev->irq.
+
+A device driver must always call free_irq() on the interrupt(s)
+for which it has called request_irq() before calling this function.
+Failure to do so will result in a BUG_ON(), the device will be left with
+MSI enabled and will leak its vector.
+
+4.3 Using MSI-X
+
+The MSI-X capability is much more flexible than the MSI capability.
+It supports up to 2048 interrupts, each of which can be separately
+assigned.  To support this flexibility, drivers must use an array of
+`struct msix_entry':
+
+struct msix_entry {
+	u16 	vector; /* kernel uses to write alloc vector */
+	u16	entry; /* driver uses to specify entry */
+};
+
+This allows for the device to use these interrupts in a sparse fashion;
+for example it could use interrupts 3 and 1027 and allocate only a
+two-element array.  The driver is expected to fill in the 'entry' value
+in each element of the array to indicate which entries it wants the kernel have
+interrupts assigned for.  It is invalid to fill in two entries with the
+same number.
+
+4.3.1 pci_enable_msix
+
+int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
+
+Calling this function asks the PCI subsystem to allocate 'nvec' MSIs.
+The 'entries' argument is a pointer to an array of msix_entry structs
+which should be at least 'nvec' entries in size.  On success, the
+function will return 0 and the device will have been switched into
+MSI-X interrupt mode.  The 'vector' elements in each entry will have
+been filled in with the interrupt number.
+
+If this function returns a negative number, it indicates an error and
+the driver should not attempt to allocate any more MSI-X interrupts for
+this device.  If it returns a positive number, it indicates the maximum
+number of interrupt vectors that could have been allocated.
+
+This function, in contrast with pci_enable_msi(), does not adjust
+pdev->irq.  The device will not generate interrupts for this interrupt
+number once MSI-X is enabled.  The device driver is responsible for
+keeping track of the interrupts assigned to the MSI-X vectors so it can
+free them again later.
+
+Device drivers should normally call this function once per device
+during the initialization phase.
+
+4.3.2 pci_disable_msix
+
+void pci_disable_msix(struct pci_dev *dev)
+
+This API should be used to undo the effect of pci_enable_msix().  It frees
+the previously allocated message signaled interrupts.  The interrupts may
+subsequently be assigned to another device, so drivers should not cache
+the value of the 'vector' elements over a call to pci_disable_msix().
+
+A device driver must always call free_irq() on the interrupt(s)
+for which it has called request_irq() before calling this function.
+Failure to do so will result in a BUG_ON(), the device will be left with
+MSI enabled and will leak its vector.
+
+4.3.3 The MSI-X Table
+
+The MSI-X capability specifies a BAR and offset within that BAR for the
+MSI-X Table.  This address is mapped by the PCI subsystem, and should be
+considered to be off limits to the device driver.  If the driver wishes to
+mask or unmask an interrupt, it should call disable_irq() / enable_irq().
+
+4.4 Handling devices implementing both MSI and MSI-X capabilities
+
+If a device implements both MSI and MSI-X capabilities, it can
+run in either MSI mode or MSI-X mode but not both simultaneously.
+This is a requirement of the PCI spec, and it is enforced by the
+PCI layer.  Calling pci_enable_msi() when MSI-X is already enabled or
+pci_enable_msix() when MSI is already enabled will result in an error.
+If a device driver wishes to switch between MSI and MSI-X at runtime,
+it must first quiesce the device, then switch it back to pin-interrupt
+mode, before calling pci_enable_msi() or pci_enable_msix() and resuming
+operation.  This is not expected to be a common operation but may be
+useful for debugging or testing during development.
+
+4.5 Considerations when using MSIs
+
+4.5.1 Choosing between MSI-X and MSI
+
+If your device supports both MSI-X and MSI capabilities, you should use
+the MSI-X facilities in preference to the MSI facilities.  As mentioned
+above, MSI-X supports any number of interrupts between 1 and 2048.
+In constrast, MSI is restricted to a maximum of 32 interrupts (and
+must be a power of two).  In addition, the MSI interrupt vectors must
+be allocated consecutively, so the system may not be able to allocate
+as many vectors for MSI as it could for MSI-X.  On some platforms, MSI
+interrupts must all be targetted at the same set of CPUs whereas MSI-X
+interrupts can all be targetted at different CPUs.
+
+4.5.2 Spinlocks
+
+Most device drivers have a per-device spinlock which is taken in the
+interrupt handler.  With pin-based interrupts or a single MSI, it is not
+necessary to disable interrupts (Linux guarantees the same interrupt will
+not be re-entered).  If a device uses multiple interrupts, the driver
+must disable interrupts while the lock is held.  If the device sends
+a different interrupt, the driver will deadlock trying to recursively
+acquire the spinlock.
+
+There are two solutions.  The first is to take the
+lock with spin_lock_irqsave() or spin_lock_irq() (see
+Documentation/DocBook/kernel-locking).  The second is to specify
+IRQF_DISABLED to request_irq() so that the kernel runs the entire
+interrupt routine with interrupts disabled.
+
+If your MSI interrupt routine does not hold the lock for the whole time
+it is running, the first solution may be best.  The second solution is
+normally preferred as it avoids making two transitions from interrupt
+disabled to enabled and back again.
+
+4.6 How to tell whether MSI/MSI-X is enabled on a device
+
+Using lspci -v (as root) will show some devices with "Message Signalled
+Interrupts" and others with "MSI-X".  Each of these capabilities have an
+'Enable' flag which will be followed with either "+" (enabled) or "-"
+(disabled).
+
+
+5. MSI quirks
+
+Several PCI chipsets or devices are known not to support MSI.
+The PCI stack provides three possible ways to disable MSIs :
+* on a single device
+* on all devices behind a specific bridge
+* globally
+
+5.1. Disabling MSI on a single device
+
+Under some circumstances it might be required to disable MSI on a single
+device.  This may be achieved by either not calling pci_enable_msi()
+for this device, or setting the pci_dev->no_msi flag before (most of
+the time in a quirk).
+
+5.2. Disabling MSI below a bridge
+
+The vast majority of MSI quirks are required by PCI bridges not
+being able to route MSI between busses. In this case, MSI have to be
+disabled on all devices behind this bridge. It is achieves by setting
+the PCI_BUS_FLAGS_NO_MSI flag in the pci_bus->bus_flags of the bridge
+subordinate bus. There is no need to set the same flag on bridges that
+are below the broken bridge. When pci_enable_msi() is called to enable
+MSI on a device, pci_msi_supported() takes care of checking the NO_MSI
+flag in all parent busses of the device.
+
+Some bridges actually support dynamic MSI support enabling/disabling
+by changing some bits in their PCI configuration space (especially
+the Hypertransport chipsets such as the nVidia nForce and Serverworks
+HT2000). It may then be required to update the NO_MSI flag on the
+corresponding devices in the sysfs hierarchy. To enable MSI support
+on device "0000:00:0e", do:
+
+	echo 1 > /sys/bus/pci/devices/0000:00:0e/msi_bus
+
+To disable MSI support, echo 0 instead of 1.  It should be
+used with caution since changing this value might break interrupts.
+
+5.3. Disabling MSI globally
+
+Some extreme cases may require to disable MSI globally on the system.
+For now, the only known case is a Serverworks PCI-X chipsets (MSI are
+not supported on several busses that are not all connected to the
+chipset in the Linux PCI hierarchy). In the vast majority of other
+cases, disabling only behind a specific bridge is enough.
+
+For debugging purpose, the user may also pass pci=nomsi on the kernel
+command-line to explicitly disable MSI globally. But, once the appro-
+priate quirks are added to the kernel, this option should not be
+required anymore.
+
+5.4. Finding why MSI cannot be enabled on a device
+
+Assuming that MSI are not enabled on a device, you should look at
+dmesg to find messages that quirks may output when disabling MSI
+on some devices, some bridges or even globally.
+Then, lspci -t gives the list of bridges above a device. Reading
+/sys/bus/pci/devices/0000:00:0e/msi_bus will tell you whether MSI
+are enabled (1) or disabled (0). In 0 is found in a single bridge
+msi_bus file above the device, MSI cannot be enabled.
+
-- 
1.5.5.4

