Return-Path: <linux-kernel-owner+w=401wt.eu-S1946492AbXEAFIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946492AbXEAFIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 01:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946575AbXEAFIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 01:08:12 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:61911 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946492AbXEAFIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 01:08:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:mime-version:content-type:content-transfer-encoding;
        b=cG4XDc5kLEdOMIqIl+yl0tUoL+Ho/m6NYMrLzliry7nIsbTZhjNvna0iruMQYM4z8JH4B8yUMDOgxIx//dFUlLeMpGaU3HC0PqeSPVVxOkb+FDD4lbYKGWbpCcKSzCSPU55S9Y8NIZC1y03MJRQmmZElqpIcYnAJJ1IiNTSRf8Q=
Date: Tue, 1 May 2007 08:08:06 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <1354376306.20070501080806@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
CC: kernel-discuss@handhelds.org
Subject: [RFC, PATCH 0/4] SoC base drivers
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello linux-kernel,


In contemporary systems, lots of functionality oftentimes handled by various
kinds of SoCs (system-on-chip), representing a number of deversified
controllers packaged in one chip. Handling them is arguably an ongoing 
problem, as diversity and number of devices included make it hard to
come with maintainable and reusable solution for writing drivers. Common
examples are developing one monolithic driver for all internal devices, or
making one of device drivers export functions required by others, leading
to not very clean dependencies like touchscreen driver depending on
a sound one.

Handhelds.org kernel project (dealing with Linux porting to consumer,
real-world embedded devices, and majority of our devices have different kinds
of SoCs) for few years developed a more clean approach to handling
SoCs - using the concept of "SoC base drivers". This is not the first time
we're submitting these patches, with reworking and elaborating them based on
the feedback received. We also extend supported machine base for these 
drivers (for example, asic3_base driver in the following patches is used by 
a dozen of machines).

SoC base drivers - concept
--------------------------

A SoC base driver is a special kind of driver which manages a SoC chip's 
common and shared resources and functionality, and provides interfaces
for subdevice drivers to use. This in particukar solves "tangled 
dependencies" issues mentioned above - different subdevices now depend
not on each other, but on a common foundation, forming a hierarchial 
structure.

Term "interfaces" is used intentionally, as besides offering an API adhoc
to specific SoC functionality, the intent is to reuse existing kernel
susbystems/interfaces as much as possible, essentially breaking tight
coupledness of subdevice drivers and base driver. For example, Generic
IRQ Subsystem is used to handle SoC interrupts, so subdevice drivers
just use existing generic API to request and free IRQs.

More importantly, existing driver model is used to handle subdevices 
of a SoC. For each subdevice, a standard struct device is allocated,
and LDM is used to handle driver binding and further lifecycle. So,
this is a special trair of SoC base drivers: these are the drivers
which register other devices (note that it is not a case of "legacy" 
driver where single module registers both a device and a driver
serving it - SoC base driver registers other devices to be handled by
other driver, namely SoC individual subdevices and drivers for them).
Initial implementation from few years ago registered per-SoC bus
for the purpose of attaching subdevices, but during LKML reviews it
was pointed out that there're no good reasons for that, as such bus
does not have any special functionality attached, so now platform_bus
is used instead, for good.

For the most part, subdevices are allocated dynamically, and SoC
base driver calculates/fixes up resources and parameters for them,
to be suitable for specific configuration (for example, different
base address of SoC).

What exact functionality and API a SoC base driver provides depends
largely on specific chip, there's no specific API a SoC driver should
implement. Here is a list of common tasks the driver usually would do:

1. Access handling to the chip (serialization, locking, etc.)
2. Managing common chip resources:
2.1. Interrupts control, demultiplexing, etc. (using Generic IRQ subsystem)
2.2. GPIO handling (adhoc, while eagerly waiting for an extensible GPIO API, 
we posted our implementation at http://lkml.org/lkml/2007/4/10/299 ).
2.3. Clocks (Using Platform Clock API)
2.4. Other kinds of "enable" and "power" switches (in adhoc manner or 
(ab)using the Clocks API, and waiting for generalization of it).
3. Calculating properties and registerting subdevices.

There's a helper soc-core API to help SoC base drivers with common tasks,
like registering subdevices.

The implementation and patches following is structured as follows:

1. include/linux/soc/ and drivers/soc/ directories are created to
keep namespaces clean (we have around 10 SoC base drivers now). Note
that these dirs are for base drivers only, subdevice drivers go to
one of standard dirs based on their functionality (for a example,
video driver goes to driver/video/).

2. soc-core.c, soc-core.h: helper API to calculate subdevice resources
and register them based on template definitions provided by SoC drivers.

3. asic3_base.c and associated headers: SoC base driver for HTC ASIC3,
a popular SoC for ARM-based handheld devices, currently known to be used
in 12 machines, including one machine which is already in mainline.

4. mach-3715.c: A patch for HP iPaq rx3715 machine, already in mainline,
to add ASIC3 support using asic3_base driver.


I would like to end this RFC with the fact that mainline of course 
already contains drivers for non-CPU SoC chips. arch/arm/common/sa1111.c 
and arch/arm/common/locomo.c are two examples from the ARM realm. This RFC
grows from this fact, and aims to provide consistent definition and
best prctices for handling such SoCs. 

Finally, in the beginning, term "reusability" is used, and this is not empty
word. Besides clean structural approach and improved source-level reusability
due to this, the approach proposed proved to offer immediate subdevice 
driver reusability across different SoCs. One vivid example is ds1wm driver,
for a W1 bus controller. It was found that this controller is found in few
SoC chips used in consumer handhelds (at least ASIC3, SAMCOP, HAMCOP chips),
and immediately usable, as long as base drivers prepares IRQ resources and
clocks for it.
  

-- 
Best regards,
 Paul                          mailto:pmiscml@gmail.com

