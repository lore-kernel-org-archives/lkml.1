Return-Path: <linux-kernel-owner+w=401wt.eu-S1759367AbYFDUIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367AbYFDUIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 16:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbYFDUIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 16:08:34 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:15020 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbYFDUIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 16:08:32 -0400
Date: Wed, 4 Jun 2008 14:08:29 -0600
From: Alex Chiang <achiang@hp.com>
To: jbarnes@virtuousgeek.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       kaneshige.kenji@jp.fujitsu.com
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       kristen.c.accardi@intel.com, greg@kroah.com, lenb@kernel.org,
       pbadari@us.ibm.com, linux-pci@vger.kernel.org,
       pcihpd-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4, v14] PCI, ACPI: Physical PCI slot objects
Message-ID: <20080604200829.GC379@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	kaneshige.kenji@jp.fujitsu.com, Matthew Wilcox <matthew@wil.cx>,
	Andrew Morton <akpm@linux-foundation.org>,
	kristen.c.accardi@intel.com, greg@kroah.com, lenb@kernel.org,
	pbadari@us.ibm.com, linux-pci@vger.kernel.org,
	pcihpd-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse, Ben, Kenji-san,

This is v14 of the physical PCI slot series.

This patchset has been kicking around -mm for the past few
months, and they were getting clobbered on a continual basis, so
let's say I'm quite motivated to get them into mainline. ;)

This mail describes two things:

	- an update for handling pSeries
	- explanation of how I did not regress Kenji-san's latest
	  changes

Review comments are much appreciated.

-----------------------
pSeries-related changes
-----------------------
The most recent outstanding issue with this series was breakage
with pSeries. In a nutshell, the problem was:

	- pci_hp_register() interface changed to require a devfn
	  when registering a slot

	- pSeries doesn't necessarily know the devfn of an
	  unpopulated slot

There are more details, of course, and they are in the archives.
I can dig them up if people want more context.

After working offline with BenH and Willy, we thought that the
best way forward was for the new infrastructure to provide a new
API, pci_update_slot_number(), which can be used by callers to
modify the slot number after slot creation. 

This change goes hand in hand with modifying the semantics of
pci_hp_register() where callers are now allowed to pass -1 for
slot_nr to create a 'placeholder' slot.

The third related change is that the infrastructure will only
display an 'address' value of 'dddd:bb' (domain:bus) when the
device is -1. In the normal case, the full address of dddd:bb:dd
is displayed.

I did fold an earlier -mm fixup patch into these changes to
improve future bisectability.

I added kerneldoc to explain the APIs.

-----------------------------
maintaining Kenji-san's fixes
-----------------------------
Finally, this patch series slightly changes the logic introduced
by Kenji-san's patches:

	9e4f2e8d4ddb04ad16a3828cd9a369a5a5287009
	a86161b3134465f072d965ca7508ec9c1e2e52c7

For a86161b31344, the check against registering a slot with the
same name multiple times is removed. That check prevents a
scenario where multiple pcihp drivers try to claim the same slot.

The check is removed because the new code allows multiple callers
of pci_create_slot(). One callsite is pci_hp_register(), the
other is in the ACPI slot detection driver provided in patch 4/4.
In the case of multiple legitimate callers, the correct thing to
do is refcount the struct pci_slot's kobj.

In the case of two pcihp drivers attempting to claim the same
slot, pci_hp_register() returns -EBUSY to indicate it has already
been claimed. This logic has been part of the patch series from
the beginning.

Thus, the end behavior introduced by a86161b31344 is preserved,
although in a slightly different implementation.

The firmware defect that Kenji-san is trying to fix with
9e4f2e8d4d is the case where broken firmware will present the
kernel with slots like bb1:dd1, name "A" and bb2:dd2, name "A".

In other words, two different busses or two different devices on
the same bus, but both have the same name.

In this case, pci_create_slot() thinks they are two different
physical slots (which is true), and tries to register them with
the kobject core, which will then complain about registering two
objects with the same name. -EEXIST will be returned back up
through the pcihp core and back to pciehp, which will then printk
the message added by 9e4f2e8d4d.

Thus, the condition Kenji-san is trying to warn about with
9e4f2e8d4d is preserved.

Thanks,

/ac

