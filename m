Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbYJQMr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbYJQMr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbYJQMrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:47:47 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:5209 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbYJQMrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:47:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=GQz67hZxfeX7WtdrqDeyCr17WWvpD4SbhaLTRB0ztPPiyWiPo328t5OuN2xkfA5Mnv
         tPZD9VsOhOGGF9dbqLIog45TJXeSzKCMvc/Napjod/lpJf2FXM6Yw6qtnQV9C0xLfLdY
         27eKz3aSXK99Cwc+EpeF7ketwENLB29JMChos=
Date: Fri, 17 Oct 2008 16:50:49 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 22/31] proc: move /proc/pagetypeinfo boilerplate to
	mm/vmstat.c
Message-ID: <20081017125049.GW22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 0093dbad83ac77a2b8026ebae5b31e1e6ee83037 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Mon, 6 Oct 2008 04:15:36 +0400
Subject: [PATCH 22/31] proc: move /proc/pagetypeinfo boilerplate to mm/vmstat.c

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/proc_misc.c    |   13 -------------
 include/linux/vmstat.h |    1 -
 mm/vmstat.c            |   15 ++++++++++++++-
 3 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 21a7c2a..828436f 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -56,18 +56,6 @@
 #include <asm/div64.h>
 #include "internal.h"
 
-static int pagetypeinfo_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &pagetypeinfo_op);
-}
-
-static const struct file_operations pagetypeinfo_file_ops = {
-	.open		= pagetypeinfo_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
-
 static int zoneinfo_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &zoneinfo_op);
@@ -256,7 +244,6 @@ void __init proc_misc_init(void)
 	proc_symlink("mounts", NULL, "self/mounts");
 
 	/* And now for trickier ones */
-	proc_create("pagetypeinfo", S_IRUGO, NULL, &pagetypeinfo_file_ops);
 	proc_create("vmstat", S_IRUGO, NULL, &proc_vmstat_file_operations);
 	proc_create("zoneinfo", S_IRUGO, NULL, &proc_zoneinfo_file_operations);
 #ifdef CONFIG_BLOCK
diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 0940109..e34e3ed 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -44,7 +44,6 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		NR_VM_EVENT_ITEMS
 };
 
-extern const struct seq_operations pagetypeinfo_op;
 extern const struct seq_operations zoneinfo_op;
 extern const struct seq_operations vmstat_op;
 extern int sysctl_stat_interval;
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 2fa5a4e..f8f37a2 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -600,13 +600,25 @@ static const struct file_operations fragmentation_file_operations = {
 	.release	= seq_release,
 };
 
-const struct seq_operations pagetypeinfo_op = {
+static const struct seq_operations pagetypeinfo_op = {
 	.start	= frag_start,
 	.next	= frag_next,
 	.stop	= frag_stop,
 	.show	= pagetypeinfo_show,
 };
 
+static int pagetypeinfo_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &pagetypeinfo_op);
+}
+
+static const struct file_operations pagetypeinfo_file_ops = {
+	.open		= pagetypeinfo_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 #ifdef CONFIG_ZONE_DMA
 #define TEXT_FOR_DMA(xx) xx "_dma",
 #else
@@ -904,6 +916,7 @@ static int __init setup_vmstat(void)
 #endif
 #ifdef CONFIG_PROC_FS
 	proc_create("buddyinfo", S_IRUGO, NULL, &fragmentation_file_operations);
+	proc_create("pagetypeinfo", S_IRUGO, NULL, &pagetypeinfo_file_ops);
 #endif
 	return 0;
 }
-- 
1.5.6.5

