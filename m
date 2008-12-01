Return-Path: <linux-kernel-owner+w=401wt.eu-S1755699AbYLANA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbYLANA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 08:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbYLANAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 08:00:15 -0500
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:36959 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbYLANAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 08:00:14 -0500
Date: Mon, 1 Dec 2008 05:00:05 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Alex Chiang <achiang@hp.com>
cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>
Subject: Problems with fakephp
In-Reply-To: <20081128231820.GA23578@ldl.fc.hp.com>
Message-ID: <Pine.LNX.4.58.0812010356410.2943@shell2.speakeasy.net>
References: <20081125212422.22631.69619.stgit@elm3a70.beaverton.ibm.com>
 <Pine.LNX.4.64.0811251919590.5161@t2.domain.actdsltmp> <20081126074808.GE6539@plum>
 <Pine.LNX.4.58.0811260131200.24816@shell4.speakeasy.net> <20081126181841.GF6539@plum>
 <Pine.LNX.4.58.0811261349120.24816@shell4.speakeasy.net>
 <20081126225535.GA27936@ldl.fc.hp.com> <Pine.LNX.4.58.0811261647410.24816@shell4.speakeasy.net>
 <20081128231820.GA23578@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2008, Alex Chiang wrote:
> * Trent Piepho <xyzzy@speakeasy.org>:
> Let's try and find a solution that will work for everyone. I
> don't think that going back to one entry in /sys/bus/pci/slots
> per function is a solution.
>
> Last time, Willy proposed a few ideas in this thread:
>
> 	http://lkml.org/lkml/2008/9/9/28

It looks like you weren't opposed to reverting the original patch.  I
think that should be done for 2.6.27 and 2.6.28, to restore the existing
interface.  I can made the patch.  I realize that fakephp's (ab)use of the
hotplug system doesn't fit in with your plans, and there's no reason not
to do anything about that.  But it should be done the right way.  fakephp
was perhaps not the best interface for getting linux to re-scan for PCI
devices and for removing existing ones, but none the less it was the long
established and only interface for this.

What should be done is to create a better interface for disabling PCI
devices/functions/bridges and re-scanning.  Then create a compatibility
system that will allow software the used fakephp to continue to work.  Now
fakephp can change to be more like a real hotplug driver.  At some time in
future, the compatibility layer, which will have been listed in the
feature removal schedule, can be removed.

You might also be interested to know that fakephp as it is now has a bug
in it.  Another reason to revert the change.  Removing a bridge doesn't
work so well.

# lspci -tv
           +-10.0  LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ul
           \-11.0-[0000:02]--+-00.0  Advanced Micro Devices [AMD] 79c970 [PCn
                             +-01.0  Ensoniq ES1371 [AudioPCI-97]
                             \-02.0  VMware Inc Unknown device 0770
# cat fake[6-9]/address
0000:00:11
0000:02:00
0000:02:01
0000:02:02
# echo 0 > fake6/power
# lspci -tv
           \-10.0  LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ul
[ 00:11 and everything behind it are gone, as expected ]
# ls
fake1/  fake2/  fake3/  fake4/  fake5/  fake7/  fake8/  fake9/
[ notice that fake[7-9] are still there! ]
# cat fake6/address
Segmentation fault
BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<c02089c3>] address_read_file+0x23/0x70

The problem is that fakephp's slots aren't really slots, they are devices.
If a PCI device goes away and it's not done with fakephp, then fakephp
doesn't know about it and the fakephp "slot" sticks around pointing to a
removed device.  I think I can come up with a better system that fixes
these problems.

I also noticed this in drivers/pci/probe.c:pci_scan_device()

list_for_each_entry(slot, &bus->slots, list)
	if(PCI_SLOT(devfn) == slot->number)
		dev->slot = slot;

This appears to assume that there will only one slot with a given number
on the same bus.  But if fakephp and real hotplug driver are both loaded,
this won't be the case anymore, will it?

I also have to wonder, if the bus + slot number is unique, then why not
use that to name the slot's kobject?  Instead of something like "fake123",
where the number is basically meaningless.  If you have a meaningful
unique ID, why not use that?
