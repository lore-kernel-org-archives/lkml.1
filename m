Return-Path: <linux-kernel-owner+w=401wt.eu-S967107AbXEGWUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967107AbXEGWUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 18:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967101AbXEGWUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 18:20:09 -0400
Received: from smtp-out.google.com ([216.239.45.13]:59003 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966631AbXEGWUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 18:20:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:user-agent:from;
	b=e5D86l2x86lU7i/3ZKle5RH8HPxFydtKybILRUctMAUzj5wYHSSm1z90aIl22oxe+
	lCJ7RwV3k4mEQxCUjrEwg==
Date: Mon, 7 May 2007 15:19:01 -0700
To: ak@suse.de, vojtech@suse.cz
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64: O_EXCL on /dev/mcelog (resend)
Message-ID: <20070507221901.GA26709@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: thockin@google.com (Tim Hockin)
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

Patch:
 This patch is against 2.6.21.

Signed-off-by: Tim Hockin <thockin@google.com>

---

This is the first version version of this patch.  The simpler alternative
of only one open() sounds better to me, but becomes a net change in
behavior.


diff -pruN linux-2.6.20+th/arch/x86_64/kernel/mce.c linux-2.6.20+th1.5/arch/x86_64/kernel/mce.c
--- linux-2.6.20+th/arch/x86_64/kernel/mce.c	2007-04-27 14:19:08.000000000 -0700
+++ linux-2.6.20+th1.5/arch/x86_64/kernel/mce.c	2007-05-01 21:53:10.000000000 -0700
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
@@ -553,6 +587,8 @@ static int mce_ioctl(struct inode *i, st
 }
 
 static const struct file_operations mce_chrdev_ops = {
+	.open = mce_open,
+	.release = mce_release,
 	.read = mce_read,
 	.ioctl = mce_ioctl,
 };
