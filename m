Return-Path: <linux-kernel-owner+w=401wt.eu-S1757437AbYHMUCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbYHMUCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbYHMUC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:02:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871AbYHMUC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:02:26 -0400
Date: Wed, 13 Aug 2008 13:01:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>
Cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       genanr@emsphone.com
Subject: Re: [Bugme-new] [Bug 11323] New: /proc/diskstats does not contain
 all disk devices
Message-Id: <20080813130158.c94c370d.akpm@linux-foundation.org>
In-Reply-To: <bug-11323-10286@http.bugzilla.kernel.org/>
References: <bug-11323-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 12:12:44 -0700 (PDT)
bugme-daemon@bugzilla.kernel.org wrote:

> 
> http://bugzilla.kernel.org/show_bug.cgi?id=11323
> 
>            Summary: /proc/diskstats does not contain all disk devices
>            Product: File System
>            Version: 2.5
>      KernelVersion: 2.6.27-rcX
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: fs_other@kernel-bugs.osdl.org
>         ReportedBy: genanr@emsphone.com
> 
> 
> Latest working kernel version: 2.6.26
> Earliest failing kernel version: 2.6.27-rc1

Post-2.6.26 regression.

> Distribution: Debian
> Hardware Environment: Dell
> Software Environment:
> Problem Description: /proc/diskstats does not contain all the block devices it
> should. /sys/block has all the devices, but /proc/diskstats does not.
> 
> Steps to reproduce: boot a system with >9 (10?) disk devices (24 block
> devices?)

The below would be a prime suspect.

Unfortunately a simple revert results in an uncompilable kernel.


(It drives me up the wall and across the ceiling how the patch has a
commit "date" of three months prior to the 2.6.26 release, however it
wasn't present in 2.6.26.  What a dumb feature.  How do I make it stop
doing this?  gitk kind of gets it right, but isn't useful across DSL)



commit 27f302519148f311307637d4c9a6d0fd87d07e4c
Author: Greg Kroah-Hartman <gregkh@suse.de>
Date:   Thu May 22 17:21:08 2008 -0400

    block: make /proc/partitions and /proc/diskstats use class_find_device()
    
    Use the proper class iterator function instead of mucking around in the
    internals of the class structures.
    
    Cc: Kay Sievers <kay.sievers@vrfy.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/block/genhd.c b/block/genhd.c
index 70f1d70..c13cc77 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -317,17 +317,21 @@ static void *part_start(struct seq_file 
 	return NULL;
 }
 
+static int find_next(struct device *dev, void *data)
+{
+	if (dev->type == &disk_type)
+		return 1;
+	return 0;
+}
+
 static void *part_next(struct seq_file *part, void *v, loff_t *pos)
 {
 	struct gendisk *gp = v;
 	struct device *dev;
 	++*pos;
-	list_for_each_entry(dev, &gp->dev.node, node) {
-		if (&dev->node == &block_class.devices)
-			return NULL;
-		if (dev->type == &disk_type)
-			return dev_to_disk(dev);
-	}
+	dev = class_find_device(&block_class, &gp->dev, NULL, find_next);
+	if (dev)
+		return dev_to_disk(dev);
 	return NULL;
 }
 
@@ -578,12 +582,9 @@ static void *diskstats_next(struct seq_f
 	struct device *dev;
 
 	++*pos;
-	list_for_each_entry(dev, &gp->dev.node, node) {
-		if (&dev->node == &block_class.devices)
-			return NULL;
-		if (dev->type == &disk_type)
-			return dev_to_disk(dev);
-	}
+	dev = class_find_device(&block_class, &gp->dev, NULL, find_next);
+	if (dev)
+		return dev_to_disk(dev);
 	return NULL;
 }
 

