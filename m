Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbYLABK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbYLABK3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 20:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbYLABKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 20:10:16 -0500
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:60399 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbYLABKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 20:10:14 -0500
Date: Sun, 30 Nov 2008 17:10:12 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Matthew Wilcox <matthew@wil.cx>
cc: Alex Chiang <achiang@hp.com>, "Darrick J. Wong" <djwong@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>
Subject: Problems with fakephp
In-Reply-To: <20081128213041.GW25548@parisc-linux.org>
Message-ID: <Pine.LNX.4.58.0811301353070.30153@shell4.speakeasy.net>
References: <20081126074808.GE6539@plum> <Pine.LNX.4.58.0811260131200.24816@shell4.speakeasy.net>
 <20081126181841.GF6539@plum> <Pine.LNX.4.58.0811261349120.24816@shell4.speakeasy.net>
 <20081126225535.GA27936@ldl.fc.hp.com> <Pine.LNX.4.58.0811261647410.24816@shell4.speakeasy.net>
 <20081127024204.GJ25548@parisc-linux.org> <Pine.LNX.4.58.0811280151230.24816@shell4.speakeasy.net>
 <20081128185722.GU25548@parisc-linux.org> <Pine.LNX.4.58.0811281310050.30153@shell4.speakeasy.net>
 <20081128213041.GW25548@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2008, Matthew Wilcox wrote:
> On Fri, Nov 28, 2008 at 01:21:22PM -0800, Trent Piepho wrote:
> > Sometimes I just want to give up on Linux.  Is there a different interface
> > that isn't wantonly changed without warning?  No?  Do you not see the
> > problem this creates for developers?  Do you not care?
>
> You see, we didn't know that anyone was using fakephp for real work.
> It's marketed as being a way for developers to test their device drivers
> with hotplug slots even if they don't have a real hotplug machine.
> If we'd known, we'd've done a better job.
>
> BTW, cut the crap about "Sometimes I just want to give up on Linux".
> We're putting in a lot of work that you get to use for free.  That doesn't
> give you the right to be abusive.  And if you stopped using Linux, we'd
> have one fewer person complaining, so I don't personally find it a huge
> motivator to drop everything and attend to your whims.

I apologize if I've come off as being abusive.  I think what's been done to
fakephp is a real problem and being told "too bad" in not so many words or
"you're wrong" when I'm not is very discouraging.

I've been contributing code to open source projects for over a dozen years
and have fixed more than a few bugs in the linux kernel.  When I had the
same problem Darrick Wong did with resource assignment, I didn't whine
about it, I made a patch and fixed it.  But when someone thinks removing an
interface, that's been around for years, with no warning is ok, or assumes
that because they don't know someone they can't have a clue what they're
talking about, how can I patch that?

> > So the race condition doesn't matter?  Alex Chiang wasn't even aware
>
> There is no race condition.  You can't remove a fakephp slot.

Please take a glance at fakephp before telling me I'm wrong, as you'll see
that I'm not.

> > So maybe this better interface should be created before breaking the
> > existing one?
>
> Hey, I have a great idea.  Why don't you help instead of just bitching?

When you get told, "your fix is unacceptable because it fixes a problem I
don't care about," it's clear than any fix to the problem will have the
same failing, so what's the point of even trying?

I was under the impression that you and Alex Chiang knew there were "real"
users of fakephp and just didn't care.  But it looks like I was mistaken
about that, so maybe it's not hopeless.

As a token of goodwill, have this spare PCI patch:


>From d962157b2b36f2c54d147a296921553b4aefcf7b Mon Sep 17 00:00:00 2001
From: Trent Piepho <xyzzy@speakeasy.org>
Date: Sun, 30 Nov 2008 16:51:29 -0800
Subject: [PATCH] PCI: Make settable sysfs attributes more consistent

PCI devices have three settable boolean attributes, enable,
broken_parity_status, and msi_bus.

The store functions for these would silently interpret "0x01" as false,
"1llogical" as true, and "true" would be (silently!) ignored and do
nothing.

This is inconsistent with typical sysfs handling of settable attributes,
and just plain doesn't make much sense.

So, use strict_strtoul(), which was created for this purpose.  The store
functions will treat a value of 0 as false, non-zero as true, and return
-EINVAL for a parse failure.

Additionally, is_enabled_store() and msi_bus_store() return -EPERM if
CAP_SYS_ADMIN is lacking, rather than silently doing nothing.  This is more
typical behavior for sysfs attributes that need a capability.

And msi_bus_store() will only print the "forced subordinate bus ..."
warning if the MSI flag was actually forced to a different value.

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>
---
 drivers/pci/pci-sysfs.c |   48 +++++++++++++++++++++++++++-------------------
 1 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 5d72866..9a5bdc0 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -58,13 +58,14 @@ static ssize_t broken_parity_status_store(struct device *dev,
 					  const char *buf, size_t count)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	ssize_t consumed = -EINVAL;
+	unsigned long val;

-	if ((count > 0) && (*buf == '0' || *buf == '1')) {
-		pdev->broken_parity_status = *buf == '1' ? 1 : 0;
-		consumed = count;
-	}
-	return consumed;
+	if (strict_strtoul(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	pdev->broken_parity_status = !!val;
+
+	return count;
 }

 static ssize_t local_cpus_show(struct device *dev,
@@ -133,19 +134,23 @@ static ssize_t is_enabled_store(struct device *dev,
 				struct device_attribute *attr, const char *buf,
 				size_t count)
 {
-	ssize_t result = -EINVAL;
 	struct pci_dev *pdev = to_pci_dev(dev);
+	unsigned long val;
+	ssize_t result = strict_strtoul(buf, 0, &val);
+
+	if (result < 0)
+		return result;

 	/* this can crash the machine when done on the "wrong" device */
 	if (!capable(CAP_SYS_ADMIN))
-		return count;
+		return -EPERM;

-	if (*buf == '0') {
+	if (!val) {
 		if (atomic_read(&pdev->enable_cnt) != 0)
 			pci_disable_device(pdev);
 		else
 			result = -EIO;
-	} else if (*buf == '1')
+	} else
 		result = pci_enable_device(pdev);

 	return result < 0 ? result : count;
@@ -185,25 +190,28 @@ msi_bus_store(struct device *dev, struct device_attribute *attr,
 	      const char *buf, size_t count)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
+	unsigned long val;
+
+	if (strict_strtoul(buf, 0, &val) < 0)
+		return -EINVAL;

 	/* bad things may happen if the no_msi flag is changed
 	 * while some drivers are loaded */
 	if (!capable(CAP_SYS_ADMIN))
-		return count;
+		return -EPERM;

+	/* Maybe pci devices without subordinate busses shouldn't even have this
+	 * attribute in the first place?  */
 	if (!pdev->subordinate)
 		return count;

-	if (*buf == '0') {
-		pdev->subordinate->bus_flags |= PCI_BUS_FLAGS_NO_MSI;
-		dev_warn(&pdev->dev, "forced subordinate bus to not support MSI,"
-			 " bad things could happen.\n");
-	}
+	/* Is the flag going to change, or keep the value it already had? */
+	if (!(pdev->subordinate->bus_flags & PCI_BUS_FLAGS_NO_MSI) ^
+	    !!val) {
+		pdev->subordinate->bus_flags ^= PCI_BUS_FLAGS_NO_MSI;

-	if (*buf == '1') {
-		pdev->subordinate->bus_flags &= ~PCI_BUS_FLAGS_NO_MSI;
-		dev_warn(&pdev->dev, "forced subordinate bus to support MSI,"
-			 " bad things could happen.\n");
+		dev_warn(&pdev->dev, "forced subordinate bus to%s support MSI,"
+			 " bad things could happen\n", val ? "" : " not");
 	}

 	return count;
-- 
1.5.4.1

