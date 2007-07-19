Return-Path: <linux-kernel-owner+w=401wt.eu-S938218AbXGSKXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938218AbXGSKXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763075AbXGSJ4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:56:06 -0400
Received: from mail.suse.de ([195.135.220.2]:35434 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721AbXGSJzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:41 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: thockin@google.com, ak@suse.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [48/58] x86_64: O_EXCL on /dev/mcelog
Message-Id: <20070719095534.F0B8214E05@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Tim Hockin <thockin@google.com>

Background:
 /dev/mcelog is a clear-on-read interface.  It is currently possible for
 multiple users to open and read() the device.  Users are protected from
 each other during any one read, but not across reads.

Description:
 This patch adds support for O_EXCL to /dev/mcelog.  If a user opens the
 device with O_EXCL, no other user may open the device (EBUSY).  Likewise,
 any user that tries to open the device with O_EXCL while another user has
 the device will fail (EBUSY).

Result:
 Applications can get exclusive access to /dev/mcelog.  Applications that
 do not care will be unchanged.

Alternatives:
 A simpler choice would be to only allow one open() at all, regardless of
 O_EXCL.

Testing:
 I wrote an application that opens /dev/mcelog with O_EXCL and observed
 that any other app that tried to open /dev/mcelog would fail until the
 exclusive app had closed the device.

Caveats:
 None.

Signed-off-by: Tim Hockin <thockin@google.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/mce.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

Index: linux/arch/x86_64/kernel/mce.c
===================================================================
--- linux.orig/arch/x86_64/kernel/mce.c
+++ linux/arch/x86_64/kernel/mce.c
@@ -465,6 +465,40 @@ void __cpuinit mcheck_init(struct cpuinf
  * Character device to read and clear the MCE log.
  */
 
+static DEFINE_SPINLOCK(mce_state_lock);
+static int open_count;	/* #times opened */
+static int open_exclu;	/* already open exclusive? */
+
+static int mce_open(struct inode *inode, struct file *file)
+{
+	spin_lock(&mce_state_lock);
+
+	if (open_exclu || (open_count && (file->f_flags & O_EXCL))) {
+		spin_unlock(&mce_state_lock);
+		return -EBUSY;
+	}
+
+	if (file->f_flags & O_EXCL)
+		open_exclu = 1;
+	open_count++;
+
+	spin_unlock(&mce_state_lock);
+
+	return 0;
+}
+
+static int mce_release(struct inode *inode, struct file *file)
+{
+	spin_lock(&mce_state_lock);
+
+	open_count--;
+	open_exclu = 0;
+
+	spin_unlock(&mce_state_lock);
+
+	return 0;
+}
+
 static void collect_tscs(void *data) 
 { 
 	unsigned long *cpu_tsc = (unsigned long *)data;
@@ -555,6 +589,8 @@ static int mce_ioctl(struct inode *i, st
 }
 
 static const struct file_operations mce_chrdev_ops = {
+	.open = mce_open,
+	.release = mce_release,
 	.read = mce_read,
 	.ioctl = mce_ioctl,
 };
