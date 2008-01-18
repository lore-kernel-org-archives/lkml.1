Return-Path: <linux-kernel-owner+w=401wt.eu-S1764071AbYARSOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764071AbYARSOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761464AbYARSOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:14:10 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:58414 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761198AbYARSOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:14:08 -0500
Message-ID: <4790EC2D.4050201@vmware.com>
Date: Fri, 18 Jan 2008 10:13:01 -0800
From: Daniel Arai <arai@vmware.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060524)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: ACPI CPU hot removal: Problem with automatic scripting in response
 to hotplug events
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an x86_64 system that's capable of doing ACPI CPU hot removal.
One issue that's worrying me right now is that there isn't enough
information to automatically script CPU removal when it's requested by
the hardware platform.

I'm doing my testing with 2.6.24-rc8 from kernel.org.  I have applied
the patch series from http://bugzilla.kernel.org/show_bug.cgi?id=2884
to avoid running into deadlocks on CPU removal.  This issue is almost
certainly independent of these patches.

/sbin/hotplug does get invoked for CPU ejection requests that are sent
from the platform.  It only gets a pointer to the ACPI /sys node
describing the ACPI processor object for which ejection has been
requested.  There doesn't seem to be a way to map from this device
node to a CPU number so the processor can be taken offline before
actually requesting removal of the physical processor.  An online
processor cannot be removed from the system, so it's a requirement
that I first offline the CPU.

Here's the environment that gets passed to /sbin/hotplug when an eject
request comes in:

SUBSYSTEM=acpi
DRIVER=processor
DEVPATH=/devices/LNXSYSTM:00/device:00/ACPI0007:02
PATH=/sbin:/bin:/usr/sbin:/usr/bin
ACTION=offline
MODALIAS=acpi:ACPI0007:
PWD=/
SHLVL=1
HOME=/
PHYSDEVDRIVER=processor
PHYSDEVBUS=acpi
SEQNUM=1437
_=/usr/bin/env

And the argument vector contains:
ARGV[0] acpi

There is a path node under the processor's object node that contains
the ACPI path to the processor device.  However, the ACPI processor
number does not necessarily correspond to the CPU number Linux assigns
to the CPU.

The kernel does have the CPU number available in the device object,
but I don't see any place that this CPU number is made available to
user space.

The code that invokes /sbin/hotplug is in
devices/acpi/processor_core.c:

	case ACPI_NOTIFY_EJECT_REQUEST:
		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
				  "received ACPI_NOTIFY_EJECT_REQUEST\n"));

		if (acpi_bus_get_device(handle, &device)) {
			printk(KERN_ERR PREFIX
				    "Device don't exist, dropping EJECT\n");
			break;
		}
		pr = acpi_driver_data(device);
		if (!pr) {
			printk(KERN_ERR PREFIX
				    "Driver data is NULL, dropping EJECT\n");
			return;
		}

		if ((pr->id < NR_CPUS) && (cpu_present(pr->id)))
			kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
		break;

I see three reasonable ways of fixing this problem.  There are
probably more ways as well.

1. Automatically take a CPU offline if it is online when ejection is
requested.  I don't see any particular drawback to this approach, but
maybe someone out there knows why this is not done.  Presumably, both
offlining the CPU and requesting ejection require root access, so I
don't think that there are any security implications.  And if someone
is attempting to eject a CPU, they almost certainly meant to offline it
anyway.  This seems slightly more friendly than failing the eject
request.

2. Provide the CPU number in the environment passed to /sbin/hotplug
when an eject request comes from the platform.  This definitely seems
like the easiest solution.  You would basically have to replace the
call to kobject_uevent above with a call to kobject_uevent_env, with
an additional environment variable set giving the CPU number or the
path to the CPU sys node.  The drawback I see to this approach is that
it may be useful in general to be able to look up the correlation
between ACPI object and CPU number at runtime, and not just when an
eject request comes in.

3. Provide a symbolic link from the ACPI device tree to the
appropriate CPU device, and possibly the reverse link as well.  This
would enable /sbin/hotplug to find the appropriate CPU node to take
the CPU offline by itself, and would also be usefil for a system
administrator who needs to know the mapping from ACPI device to CPU
number.  What I don't know is how hard it is to construct these new
nodes.  It also gets slightly messy because ACPI processor objects can
appear at different levels in the /sys node hierarchy depending on how
they're represented in the ACPI tables, so constructing relative
symlinks isn't a trivial matter.

I think that overall the third approach seems the most appealing,
because it provides additional information to the system administrator
without adding special information just there for /sbin/hotplug.  I
think #1 is probably a nice thing to have just in general, though I
don't understand the rationale for the code being the way it is now.
Sadly, #2 is the only one I'm sure I know how to implement.

So any suggestions on the best way to go about solving this problem?

I've also noticed one other minor anomaly.  CPUs get device nodes
named ACPI0007:00, ACPI0007:01, ACPI0007:02, etc.  If I remove a CPU
from the system, then add another cpu to the system, the removed
device node goes away, but its number doesn't get reused.  So if I
remove and then re-add the same CPU over and over, I end up getting
nodes named ACPI0007:03, then that gets deleted, then I get
ACPI0007:04, and so on.  Is this supposed to happen?  What happens if
I remove and add the same CPU more than 99 times?

Dan.
