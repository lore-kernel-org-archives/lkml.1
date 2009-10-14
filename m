Return-Path: <linux-kernel-owner+w=401wt.eu-S1762189AbZJNXzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762189AbZJNXzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 19:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762172AbZJNXzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 19:55:04 -0400
Received: from kroah.org ([198.145.64.141]:38297 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761653AbZJNXzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 19:55:02 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>, Dan Williams <dan.j.williams@intel.com>,
       stable <stable@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/2] sysfs: Allow sysfs_notify_dirent to be called from interrupt context.
Date: Wed, 14 Oct 2009 16:51:47 -0700
Message-Id: <1255564307-9566-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <20091014230432.GB8865@kroah.com>
References: <20091014230432.GB8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Brown <neilb@suse.de>

sysfs_notify_dirent is a simple atomic operation that can be used to
alert user-space that new data can be read from a sysfs attribute.

Unfortunately it cannot currently be called from non-process context
because of its use of spin_lock which is sometimes taken with
interrupts enabled.

So change all lockers of sysfs_open_dirent_lock to disable interrupts,
thus making sysfs_notify_dirent safe to be called from non-process
context (as drivers/md does in md_safemode_timeout).

sysfs_get_open_dirent is (documented as being) only called from
process context, so it uses spin_lock_irq.  Other places
use spin_lock_irqsave.

The usage for sysfs_notify_dirent in md_safemode_timeout was
introduced in 2.6.28, so this patch is suitable for that and more
recent kernels.

Reported-by: Joel Andres Granados <jgranado@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/file.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 561a9c0..f5ea468 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -268,7 +268,7 @@ static int sysfs_get_open_dirent(struct sysfs_dirent *sd,
 	struct sysfs_open_dirent *od, *new_od = NULL;
 
  retry:
-	spin_lock(&sysfs_open_dirent_lock);
+	spin_lock_irq(&sysfs_open_dirent_lock);
 
 	if (!sd->s_attr.open && new_od) {
 		sd->s_attr.open = new_od;
@@ -281,7 +281,7 @@ static int sysfs_get_open_dirent(struct sysfs_dirent *sd,
 		list_add_tail(&buffer->list, &od->buffers);
 	}
 
-	spin_unlock(&sysfs_open_dirent_lock);
+	spin_unlock_irq(&sysfs_open_dirent_lock);
 
 	if (od) {
 		kfree(new_od);
@@ -315,8 +315,9 @@ static void sysfs_put_open_dirent(struct sysfs_dirent *sd,
 				  struct sysfs_buffer *buffer)
 {
 	struct sysfs_open_dirent *od = sd->s_attr.open;
+	unsigned long flags;
 
-	spin_lock(&sysfs_open_dirent_lock);
+	spin_lock_irqsave(&sysfs_open_dirent_lock, flags);
 
 	list_del(&buffer->list);
 	if (atomic_dec_and_test(&od->refcnt))
@@ -324,7 +325,7 @@ static void sysfs_put_open_dirent(struct sysfs_dirent *sd,
 	else
 		od = NULL;
 
-	spin_unlock(&sysfs_open_dirent_lock);
+	spin_unlock_irqrestore(&sysfs_open_dirent_lock, flags);
 
 	kfree(od);
 }
@@ -456,8 +457,9 @@ static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
 void sysfs_notify_dirent(struct sysfs_dirent *sd)
 {
 	struct sysfs_open_dirent *od;
+	unsigned long flags;
 
-	spin_lock(&sysfs_open_dirent_lock);
+	spin_lock_irqsave(&sysfs_open_dirent_lock, flags);
 
 	od = sd->s_attr.open;
 	if (od) {
@@ -465,7 +467,7 @@ void sysfs_notify_dirent(struct sysfs_dirent *sd)
 		wake_up_interruptible(&od->poll);
 	}
 
-	spin_unlock(&sysfs_open_dirent_lock);
+	spin_unlock_irqrestore(&sysfs_open_dirent_lock, flags);
 }
 EXPORT_SYMBOL_GPL(sysfs_notify_dirent);
 
-- 
1.6.4.2

