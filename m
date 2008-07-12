Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001AbYGLUPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbYGLUPK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 16:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbYGLUO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 16:14:58 -0400
Received: from sullivan.realtime.net ([205.238.132.226]:4229 "EHLO
	sullivan.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbYGLUO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 16:14:57 -0400
Date: Sat, 12 Jul 2008 15:02:22 -0500 (CDT)
From: Milton Miller <miltonm@bga.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, <linux-pci@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Brian King <brking@us.ibm.com>, Jean Delvare <khali@linux-fr.org>,
       Tejun Heo <htejun@gmail.com>, Michael Ellerman <michael@ellerman.id.au>,
       Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <for-27-patch9@bga.com>
References: <for-27-patch1-0@bga.com>,
	<for-27-patch9@bga.com>
Message-Id: <for-27-patch9-fix@bga.com>
Subject: [PATCH/RESEND] pci: dynids.use_driver_data considered harmful
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I typo'd on the cc to linux-kernel the first time, and wanted to take make a
second pass at the long narritive of my debug session promoting this patch.
I think I got the new linux-pci list, but google doesn't seem to find any
archives of the new list or this patch.

Andrew,
	Thanks for picking this up and the expanded cc list.  I took the
patch from mmotm and only changed the changlog.  Please update your copy.

Jesse,
	I don't care if you commit this version with the full narritive
or just the part through the footnote.

I can supply the debug patch if someone is intrested, but it just did
the classification in __pci_regsiter_driver.

Thanks,
milton

=== cut here ===

The driver flag dynids.use_driver_data is almost consistently not set, and
causes more problems than it solves.  The only use of this flag is to
prevent the system administrator from telling a pci driver additional data
when adding a dynamic match table entry via sysfs.

We do not as a policy protect the kernel from bad acts by root.

If we are worried about drivers doing the wrong thing due the match data, we
should be setting a taint flag, not attempting to cut off the admin.

[1] Searching the next-20080709 tree shows the bit is set by exactly
3 pci drivers.  However, the use of per-match-entry driver data is
much more prevalent: A boot of allyesconfig on a PowerPC64 pSeries
with a debug patch shows 27 drivers apparently use the field for a
pointer, 14 use it for setting flags, and 98 use it as a table
index.  (Pointers are defined as values above>PAGE_OFFSET, aka in
the 64 bit kernel linear mapping.  Flags are defined as the maximum
value exceeds the number of entries in the match table.  Any other
nonzero value is classified as an index).

This behavior actually caused me several hours of debug recently.

I was working working with a cxgb3 card in an environment based on mainline,
at the time on the 2.6.24 kernel.  I was told a version of the driver was
working on a distro kernel with this card and the necessary support should
be upstream.  I configured the driver into the kernel, inserted the the card
into the system, and booted, but the card was not recognized by the driver.
Assuming the card had some unique device id, I tried adding a the vendor and
device via sysfs, and the kernel crashed.  I then looked closer at the
driver, and discovered the vendor and device were listed, but the match
table also expected the subsystem device id (owned by the subsystem vendor,
not the silicon vendor) was being matched to the value 1.  I also noted the
driver used the id match table driver data field.  I peeked at the pci sysfs
code to find out which parameter would be driver data, rebooted, and tried
again.   The kernel crashed again.

Ok supporting this card isn't going to be trivial.   I then acquired a card
for my own setup instead of trying to debug using remote access to a user's
machine across the country.  After a few days to locate a card in town,
specificly one that had been tested with the distro kernel driver to rule
out faulty hardware, I replicated the failure.  Digging further into the
crash, I quickly determined the crash was a branch to what appeared to be
ascii text from somewhere in the device probe routine.  I looked at what had
been put in 2.6.25 (this was after the merge window, but still early -rc
time frame), and saw the driver id table match was relaxed, and some other
changes.  However, they didn't appear to be related, and, due to net wide
changes, would require some time to backport.

Seeing the corruption was ascii, I figured the problem was some data
dependent overwrite or buffer overflow, probably trashing the stack.
Perhaps the problem was reading the vpd, parsing it, or some endian issue
reading a size somewhere.  The vpd parsing code uses some macros to grab
data out of a structure, sounds suspicious, something probably doesn't line
up.

I looked at the assembly code around the return address and could tell the
call was through a function pointer, but, like many probe functions full of
calls to use-once functions, it was not clear which pointer was being
dereferenced, only that it was some large offset into some driver structure.

This was on PowerPC64, so the function pointer is a descriptor pointer.  The
pointer itself looks valid, but instead of pointing to a descriptor with a
code address and a constant pool, it points to random kernel data.  Of
course, when debugging, one sees some pointer that looks valid, but points
to ascii garbage instead of the code and toc.  What function should be
there?  Was a pointer used uninitialized?

I looked closer at the failure point, unraveling the code flow and few
non-pointer function calles and determined it was past the vpd parsing, and
definitely into the port initialization code, but not clear which function
was breaking.

I tried sprinkling printk and even while(1) into the driver (debugging with
tools to inspect memory without the cpu) and the called port enable
functions, but couldn't track it down, it seemed like it worked as expected
and I couldn't find any memory corruption, yet the loop didn't reach its
exit point.

Eventually I found both the device pointer and the port pointer, and
unraveled the offset of the port pointer nested in several large structures
of driver data was pointing to the second port.  Huh? I told it this was a
card that only had one port.  Is the loop control on the stack getting
stomped upon?  No, the structure says it has two ports.  I double checked
the match table index, yes that was correct.  I double checked the parse of
new_id, yes, I am using the right parameter.

I eventually determined the following sequence of events had occurred:

The pci driver sysfs code took my id, but since dynids.use_driver_data was
not set, filled the driver data field with 0.  It then re-scanned the
devices and found the new match, and called the driver probe routine.  The
driver took the driver data and performed a range check.  It then indexed
into a table, and (since it was given 0 when I specified 2), it incorrectly
determined the card should have two ports instead of one.  It then copied
the vpd into an array, and indexed into the array based on a template of
what it thought the vpd would contain (as opposed to parsing the tags in the
vpd with their length fields).  The code then searched in the vpd for
descriptions of the phy on each possible port.  It found the phy on physical
port 0, indexed into another table and filled out its pointers.  It then
searched for the non-existent card port 1, looping to find the next port
with a non-zero value for the type of phy.  Because the card actually only
had one port, it went off the end of the vpd data and found some random
number in memory.  It then used that random value as the type to index into
its second array, again ran well beyond the end of the array, and filled out
the function pointers to be used for the second port.  It happened to land
on kernel data containting a pointer, so the function descriptor looked to
be a valid pointer.  It proceeded on, in the same function after inlining,
to iterate over the ports on the card to initialize each port.  It calls the
function for the first port, all goes well.  It advances a pointer to point
to the next port, calls the first function, dereferences the function
descriptor to get the code address, and dies with a branch to nowhere.

Only after careful analysis of the driver data structure did I find it was
looking for more ports.  After all, I had told the driver to use slot two,
and that said to expect the card to only have one port described in the vpd.

While there is could certainly be more defensive coding in the driver (eg:
parse the vpd instead of relying on knowing the tag layout, only search
until the end of the field in the vpd data, range check the port type before
indexing into an array), the whole session should have been avoided once I
looked at the driver and carefully set the driver data to entry 2, to match
the other users of the silicon.

Signed-off-by: Milton Miller <miltonm@bga.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Brian King <brking@us.ibm.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-amd756.c |    1 -
 drivers/i2c/busses/i2c-viapro.c |    1 -
 drivers/pci/pci-driver.c        |    3 +--
 drivers/scsi/ipr.c              |    1 -
 include/linux/pci.h             |    1 -
 5 files changed, 1 insertion(+), 6 deletions(-)

diff -puN drivers/i2c/busses/i2c-amd756.c~pci-dynidsuse_driver_data-considered-harmful drivers/i2c/busses/i2c-amd756.c
--- a/drivers/i2c/busses/i2c-amd756.c~pci-dynidsuse_driver_data-considered-harmful
+++ a/drivers/i2c/busses/i2c-amd756.c
@@ -412,7 +412,6 @@ static struct pci_driver amd756_driver =
 	.id_table	= amd756_ids,
 	.probe		= amd756_probe,
 	.remove		= __devexit_p(amd756_remove),
-	.dynids.use_driver_data = 1,
 };
 
 static int __init amd756_init(void)
diff -puN drivers/i2c/busses/i2c-viapro.c~pci-dynidsuse_driver_data-considered-harmful drivers/i2c/busses/i2c-viapro.c
--- a/drivers/i2c/busses/i2c-viapro.c~pci-dynidsuse_driver_data-considered-harmful
+++ a/drivers/i2c/busses/i2c-viapro.c
@@ -468,7 +468,6 @@ static struct pci_driver vt596_driver = 
 	.name		= "vt596_smbus",
 	.id_table	= vt596_ids,
 	.probe		= vt596_probe,
-	.dynids.use_driver_data = 1,
 };
 
 static int __init i2c_vt596_init(void)
diff -puN drivers/pci/pci-driver.c~pci-dynidsuse_driver_data-considered-harmful drivers/pci/pci-driver.c
--- a/drivers/pci/pci-driver.c~pci-dynidsuse_driver_data-considered-harmful
+++ a/drivers/pci/pci-driver.c
@@ -65,8 +65,7 @@ store_new_id(struct device_driver *drive
 	dynid->id.subdevice = subdevice;
 	dynid->id.class = class;
 	dynid->id.class_mask = class_mask;
-	dynid->id.driver_data = pdrv->dynids.use_driver_data ?
-		driver_data : 0UL;
+	dynid->id.driver_data = driver_data;
 
 	spin_lock(&pdrv->dynids.lock);
 	list_add_tail(&dynid->node, &pdrv->dynids.list);
diff -puN drivers/scsi/ipr.c~pci-dynidsuse_driver_data-considered-harmful drivers/scsi/ipr.c
--- a/drivers/scsi/ipr.c~pci-dynidsuse_driver_data-considered-harmful
+++ a/drivers/scsi/ipr.c
@@ -7854,7 +7854,6 @@ static struct pci_driver ipr_driver = {
 	.remove = ipr_remove,
 	.shutdown = ipr_shutdown,
 	.err_handler = &ipr_err_handler,
-	.dynids.use_driver_data = 1
 };
 
 /**
diff -puN include/linux/pci.h~pci-dynidsuse_driver_data-considered-harmful include/linux/pci.h
--- a/include/linux/pci.h~pci-dynidsuse_driver_data-considered-harmful
+++ a/include/linux/pci.h
@@ -339,7 +339,6 @@ struct pci_bus_region {
 struct pci_dynids {
 	spinlock_t lock;            /* protects list, index */
 	struct list_head list;      /* for IDs added at runtime */
-	unsigned int use_driver_data:1; /* pci_device_id->driver_data is used */
 };
 
 /* ---------------------------------------------------------------- */
_
