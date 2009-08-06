Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbZHFFno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbZHFFno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 01:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbZHFFnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 01:43:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44485 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326AbZHFFnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 01:43:42 -0400
From: Neil Brown <neilb@suse.de>
To: Greg KH <gregkh@suse.de>
Date: Thu, 6 Aug 2009 15:43:50 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19066.28054.65288.171564@notabene.brown>
Cc: NeilBrown <neilb@suse.de>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31rc5 RAID10 lockdep report - sysfs_nofity_dirent locking
 issue
In-Reply-To: message from Greg KH on Tuesday August 4
References: <20090804141425.GA2831@redhat.com>
	<58e2e493d0855face4e7d3fbf7ee65b9.squirrel@neil.brown.name>
	<20090804212404.GA26390@suse.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday August 4, gregkh@suse.de wrote:
> > 
> > Greg: does that look right?  If so I'll add a changelog entry and
> > submit it properly (after at least a compile test...)
> 
> Yes, it looks correct, if it passes your tests :)

Thanks.
I've tested it and documented it now and so am happy to submit it.
Thanks,
NeilBrown


From: NeilBrown <neilb@suse.de>
Date: Thu, 6 Aug 2009 15:42:08 +1000
Subject: [PATCH] Allow sysfs_notify_dirent to be called from interrupt context.

sysfs_notify_dirent is a simple atomic operation that can be used to
alert user-space that new data can be read from a sysfs attribute.

Unfortunately is cannot currently be called from non-process context
because of it's use of spin_lock which is sometimes taken with
interrupt enabled.

So change all lockers of sysfs_open_dirent_lock to disable interrupts,
thus making sysfs_notify_dirent safe to be called from non-process
context (as drivers/md does in md_safemode_timeout).

sysfs_get_open_dirent is (documented as being) only called from
process context, so it uses spin_lock_irq.  Other places
use spin_lock_irqsave.

The usage for sysfs_notify_dirent in md_safemode_timeout was
introduced in 2.6.28, so this patch is suitable for that and more
recent kernels.

Cc: stable@kernel.org
Signed-off-by: NeilBrown <neilb@suse.de>
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
1.6.3.3

