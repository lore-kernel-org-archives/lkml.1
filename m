Return-Path: <linux-kernel-owner+w=401wt.eu-S932773AbXC1QNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773AbXC1QNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 12:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932787AbXC1QNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 12:13:33 -0400
Received: from twin.jikos.cz ([213.151.79.26]:46972 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932773AbXC1QNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 12:13:32 -0400
Date: Wed, 28 Mar 2007 18:12:34 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Andi Kleen <ak@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Philippe Elie <phil.el@wanadoo.fr>
Subject: Re: Linux 2.6.21-rc5
In-Reply-To: <460A8203.20207@googlemail.com>
Message-ID: <Pine.LNX.4.64.0703281809510.29565@twin.jikos.cz>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
 <46096834.5050508@googlemail.com> <200703281630.59191.ak@suse.de>
 <460A8203.20207@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007, Michal Piotrowski wrote:

> BUG: using smp_processor_id() in preemptible [00000001] code: mount/7245 
> is fixed, thanks.
> but I still get this
> [  208.523901] =================================
> [  208.529739] [ INFO: inconsistent lock state ]
> [  208.534087] 2.6.21-rc5-g28defbea-dirty #131
> [  208.538260] ---------------------------------
> [  208.542611] inconsistent {hardirq-on-W} -> {in-hardirq-W} usage.
> [  208.548600] swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:

Perhaps something like the one below?


From: Jiri Kosina <jkosina@suse.cz>

oprofile: fix potential deadlock on oprofilefs_lock

nmi_cpu_setup() is called from hardirq context and acquires oprofilefs_lock.
alloc_event_buffer() and oprofilefs_ulong_from_user() acquire this lock
without disabling irqs, which could deadlock.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

 drivers/oprofile/event_buffer.c |    5 +++--
 drivers/oprofile/oprofilefs.c   |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/oprofile/event_buffer.c b/drivers/oprofile/event_buffer.c
index 00e937e..e7fbac5 100644
--- a/drivers/oprofile/event_buffer.c
+++ b/drivers/oprofile/event_buffer.c
@@ -70,11 +70,12 @@ void wake_up_buffer_waiter(void)
 int alloc_event_buffer(void)
 {
 	int err = -ENOMEM;
+	unsigned long flags;
 
-	spin_lock(&oprofilefs_lock);
+	spin_lock_irqsave(&oprofilefs_lock, flags);
 	buffer_size = fs_buffer_size;
 	buffer_watershed = fs_buffer_watershed;
-	spin_unlock(&oprofilefs_lock);
+	spin_unlock_irqrestore(&oprofilefs_lock, flags);
  
 	if (buffer_watershed >= buffer_size)
 		return -EINVAL;
diff --git a/drivers/oprofile/oprofilefs.c b/drivers/oprofile/oprofilefs.c
index 6e67b42..8543cb2 100644
--- a/drivers/oprofile/oprofilefs.c
+++ b/drivers/oprofile/oprofilefs.c
@@ -65,6 +65,7 @@ ssize_t oprofilefs_ulong_to_user(unsigned long val, char __user * buf, size_t co
 int oprofilefs_ulong_from_user(unsigned long * val, char const __user * buf, size_t count)
 {
 	char tmpbuf[TMPBUFSIZE];
+	unsigned long flags;
 
 	if (!count)
 		return 0;
@@ -77,9 +78,9 @@ int oprofilefs_ulong_from_user(unsigned long * val, char const __user * buf, siz
 	if (copy_from_user(tmpbuf, buf, count))
 		return -EFAULT;
 
-	spin_lock(&oprofilefs_lock);
+	spin_lock_irqsave(&oprofilefs_lock, flags);
 	*val = simple_strtoul(tmpbuf, NULL, 0);
-	spin_unlock(&oprofilefs_lock);
+	spin_unlock_irqrestore(&oprofilefs_lock, flags);
 	return 0;
 }

