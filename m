Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbYAWSMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbYAWSMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 13:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbYAWSMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 13:12:20 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:1186 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbYAWSMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 13:12:17 -0500
Date: Wed, 23 Jan 2008 11:12:16 -0700
From: Alex Chiang <achiang@hp.com>
To: lenb@kernel.org, tony.luck@intel.com, anil.s.keshavamurthy@intel.com
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-hotplug@vger.kernel.org, linux-ia64@vger.kernel.org
Subject: ACPI processor hotplug broken?
Message-ID: <20080123181216.GE11311@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, lenb@kernel.org,
	tony.luck@intel.com, anil.s.keshavamurthy@intel.com,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-hotplug@vger.kernel.org, linux-ia64@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is anyone out there successfully using the ACPI processor driver
and CPU hotplug? I've been playing with it for the past few days,
and it *almost* works on my platform (ia64), but not quite.

I can offline/online a CPU successfully via the sysfs interface.
It's when I try and add ACPI into the mix that stuff starts going
wonky.

My understanding of reading the code and the stuff in
Documentation/cpu-hotplug.txt is that what should be happening is
this:

	- firmware sends ACPI_NOTIFY_BUS_CHECK or
	  ACPI_NOTIFY_EJECT_REQUEST events to
	  acpi_processor_hotplug_notify.

	- if we got an eject request, simply emit a cpu offline
	  uevent and let a udev script do the right thing (in
	  this case, echo 0 > /sys/devices/system/cpu/cpuX/online)

	- if we got a bus/device check, it gets a little hairier,
	  since the notify handler seems like it's going to
	  toggle the state of the cpu.

	  	- first, try to find the cpu on the bus. If it
		  does not exist, then call acpi_processor_device_add
		  and we're done (after emitting a cpu online
		  uevent)

		- else, we've found the cpu on the bus, so then
		  check to see if its id is in the range of
		  acceptable values. If so, we assume that it's
		  online, and that we want to offline it, so emit
		  a cpu offline uevent

		- if cpu is on the bus, but id is outside range
		  of acceptable values, then call acpi_processor_start
		  and emit a cpu online uevent

Where I'm running into difficulty is in the bus/device check
logic if the CPU has already been offlined via sysfs.

For some reason, the call to acpi_bus_get_device() succeeds, so
the "toggle" logic inside acpi_processor_hotplug_notify() thinks
that we want to offline the CPU, rather than onlining it.

We keep emitting cpu offline uevents, but really, we should be
emitting cpu online uevents.

So something seems off, and at this point, the possibilities I
can see are:

	- at some point during the sysfs offline process
	  (cpu_down and friends), platform code should have
	  removed the ACPI CPU device from the bus

	- the toggle logic inside acpi_processor_hotplug_notify
	  is broken, and the call to acpi_bus_get_device is bogus

Anyone have any hints? Anyone using this successfully? Poking
around in the x86/ tree wasn't very informative for me.

Thanks.

/ac

