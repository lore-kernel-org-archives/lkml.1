Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbXCXUdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbXCXUdN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 16:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbXCXUdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 16:33:12 -0400
Received: from www17.your-server.de ([213.133.104.17]:1108 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbXCXUdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 16:33:12 -0400
Message-ID: <46058B47.60204@m3y3r.de>
Date: Sat, 24 Mar 2007 21:34:15 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>	<20070323185022.GQ752@stusta.de> <46055A3B.6050107@m3y3r.de>	<m1slbu4j0p.fsf@ebiederm.dsl.xmission.com> <46056BF3.3070707@m3y3r.de> <m1odmi4gx5.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1odmi4gx5.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman schrieb:
>
> Odd.  I would have thought the oops happened in the first resume, not
> the second. 
>
> Hmm.  It may have something to do with the ``managed'' driver
> aspect of this as well..
>   
No. I don't think so. The problem is caused by this sequence: (the info
is always before entry of a function and before the exit of a function):

1.) Normal boot
[kernel] ahci 0000:00:1f.2: version 2.1
[kernel] pci_enable_device: dev= c1a59000
[kernel] pci_enable_device: irq= 0
[kernel] pci_enable_device: msi_enabled= 0
[kernel] PCI: Enabling device 0000:00:1f.2 (0005 -> 0007)
[kernel] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) ->
IRQ 19
[kernel] pci_enable_device: dev= c1a59000
[kernel] pci_enable_device: irq= 19
[kernel] pci_enable_device: msi_enabled= 0

2.) msi irq 218 gets assigned

3) First suspend to disk. Consists of
3a) Suspend devices
[kernel] ahci 0000:00:1f.2: freeze
[kernel] pci_disable_device: dev= c1a59000
[kernel] pci_disable_device: irq= 218
[kernel] pci_disable_device: msi_enabled= 1
[kernel] ACPI: PCI interrupt for device 0000:00:1f.2 disabled
[kernel] pci_disable_device: dev= c1a59000
[kernel] pci_disable_device: irq= 218
[kernel] pci_disable_device: msi_enabled= 1

3b) Disable non-boot cpus
3c) Snapshot memory
3d) Enable non-boot cpus
3e) Resume devices (after snapshot!)
[kernel] ahci 0000:00:1f.2: resuming
[kernel] PM: Writing back config space on device 0000:00:1f.2 at offset
1 (was 2b00403, writing 2b00407)
[kernel] pci_enable_device: dev= c1a59000
[kernel] pci_enable_device: irq= 218
[kernel] pci_enable_device: msi_enabled= 1
[kernel] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) ->
IRQ 19
[kernel] pci_enable_device: dev= c1a59000
[kernel] pci_enable_device: irq= 19
[kernel] pci_enable_device: msi_enabled= 1

3f) Write memory image
3g) Power down + reboot

4a) Normal start and restore memory image
4b) Enable non-boot cpus
4c) Resume devices
[kernel] ahci 0000:00:1f.2: resuming
[kernel] PM: Writing back config space on device 0000:00:1f.2 at offset
1 (was 2b00403, writing 2b00407)
[kernel] pci_enable_device: dev= c1a59000
[kernel] pci_enable_device: irq= 218
[kernel] pci_enable_device: msi_enabled= 1
[kernel] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) ->
IRQ 19
[kernel] pci_enable_device: dev= c1a59000
[kernel] pci_enable_device: irq= 19
[kernel] pci_enable_device: msi_enabled= 1
Now the system is running with irq=19 and msi enabled=1. So let's
suspend again:

5) Second suspend to disk consists of
5a) Suspend devices
[kernel] ahci 0000:00:1f.2: freeze
[kernel] pci_disable_device: dev= c1a59000
[kernel] pci_disable_device: irq= 19
[kernel] pci_disable_device: msi_enabled= 1
[kernel] ACPI: PCI interrupt for device 0000:00:1f.2 disabled
[kernel] pci_disable_device: dev= c1a59000
[kernel] pci_disable_device: irq= 19
[kernel] pci_disable_device: msi_enabled= 1

5b) Disable non-boot cpus
5c) Snapshot memory
5d) Enable non-boot cpus
5e) Resume devices
[kernel] pci_enable_device: dev= c1a59000
[kernel] pci_enable_device: irq= 19
[kernel] pci_enable_device: msi_enabled= 1

-> OOPS in restore_msi because it tries to access msi structure for irq
19 and not 218.

So i guess this has nothing to do with the managed pci functions?

