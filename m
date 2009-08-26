Return-Path: <linux-kernel-owner+w=401wt.eu-S1751458AbZHZPqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbZHZPqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 11:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750935AbZHZPqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 11:46:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbZHZPqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 11:46:44 -0400
Date: Wed, 26 Aug 2009 21:15:52 +0530
From: Amit Shah <amit.shah@redhat.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org,
       virtualization@lists.linux-foundation.org
Cc: brueckner@linux.vnet.ibm.com, miltonm@bga.com, alan@linux.intel.com,
       borntraeger@de.ibm.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: Extending virtio_console to support multiple ports
Message-ID: <20090826154552.GA31910@amit-x200.redhat.com>
References: <1251181044-3696-1-git-send-email-amit.shah@redhat.com> <20090826112718.GA11117@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826112718.GA11117@amit-x200.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing some people who have made some commits in hvc_console.c]

On (Wed) Aug 26 2009 [16:57:18], Amit Shah wrote:
> On (Tue) Aug 25 2009 [11:47:20], Amit Shah wrote:
> > 
> > Hello all,
> > 
> > Here is a new iteration of the patch series that implements a
> > transport for guest and host communications.
> > 
> > The code has been updated to reuse the virtio-console device instead
> > of creating a new virtio-serial device.
> 
> And the problem now is that hvc calls the put_chars function with
> spinlocks held and we now allocate pages in send_buf(), called from
> put_chars.
> 
> A few solutions:

[snip]

> - Convert hvc's usage of spinlocks to mutexes. I've no idea how this
>   will play out; I'm no expert here. But I did try doing this and so far
>   it all looks OK. No lockups, lockdep warnings, nothing. I have full
>   debugging enabled. But this doesn't mean it's right.

So just to test this further I added the capability to have more than
one hvc console spawn from virtio_console, created two consoles and did
a 'cat' of a file in each of the virtio-consoles. It's been running for
half an hour now without any badness. No spew in debug logs too.

I also checked the code in hvc_console.c that takes the spin_locks.
Nothing there that runs from (or needs to run from) interrupt context.
So the change to mutexes does seem reasonable. Also, the spinlock code
was added really long back -- git blame shows Linus' first git commit
introduced them in the git history, so it's pure legacy baggage.

Also found a bug: hvc_resize() wants to be called with a lock held
(hp->lock) but virtio_console just calls it directly.

Anyway I'm wondering whether all those locks are needed.

		Amit


diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
index d97779e..51078a3 100644
--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -35,7 +35,7 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/sched.h>
-#include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/delay.h>
 #include <linux/freezer.h>
 
@@ -81,7 +81,7 @@ static LIST_HEAD(hvc_structs);
  * Protect the list of hvc_struct instances from inserts and removals during
  * list traversal.
  */
-static DEFINE_SPINLOCK(hvc_structs_lock);
+static DEFINE_MUTEX(hvc_structs_lock);
 
 /*
  * This value is used to assign a tty->index value to a hvc_struct based
@@ -98,23 +98,22 @@ static int last_hvc = -1;
 static struct hvc_struct *hvc_get_by_index(int index)
 {
 	struct hvc_struct *hp;
-	unsigned long flags;
 
-	spin_lock(&hvc_structs_lock);
+	mutex_lock(&hvc_structs_lock);
 
 	list_for_each_entry(hp, &hvc_structs, next) {
-		spin_lock_irqsave(&hp->lock, flags);
+		mutex_lock(&hp->lock);
 		if (hp->index == index) {
 			kref_get(&hp->kref);
-			spin_unlock_irqrestore(&hp->lock, flags);
-			spin_unlock(&hvc_structs_lock);
+			mutex_unlock(&hp->lock);
+			mutex_unlock(&hvc_structs_lock);
 			return hp;
 		}
-		spin_unlock_irqrestore(&hp->lock, flags);
+		mutex_unlock(&hp->lock);
 	}
 	hp = NULL;
 
-	spin_unlock(&hvc_structs_lock);
+	mutex_unlock(&hvc_structs_lock);
 	return hp;
 }
 
@@ -228,15 +227,14 @@ console_initcall(hvc_console_init);
 static void destroy_hvc_struct(struct kref *kref)
 {
 	struct hvc_struct *hp = container_of(kref, struct hvc_struct, kref);
-	unsigned long flags;
 
-	spin_lock(&hvc_structs_lock);
+	mutex_lock(&hvc_structs_lock);
 
-	spin_lock_irqsave(&hp->lock, flags);
+	mutex_lock(&hp->lock);
 	list_del(&(hp->next));
-	spin_unlock_irqrestore(&hp->lock, flags);
+	mutex_unlock(&hp->lock);
 
-	spin_unlock(&hvc_structs_lock);
+	mutex_unlock(&hvc_structs_lock);
 
 	kfree(hp);
 }
@@ -302,17 +300,16 @@ static void hvc_unthrottle(struct tty_struct *tty)
 static int hvc_open(struct tty_struct *tty, struct file * filp)
 {
 	struct hvc_struct *hp;
-	unsigned long flags;
 	int rc = 0;
 
 	/* Auto increments kref reference if found. */
 	if (!(hp = hvc_get_by_index(tty->index)))
 		return -ENODEV;
 
-	spin_lock_irqsave(&hp->lock, flags);
+	mutex_lock(&hp->lock);
 	/* Check and then increment for fast path open. */
 	if (hp->count++ > 0) {
-		spin_unlock_irqrestore(&hp->lock, flags);
+		mutex_unlock(&hp->lock);
 		hvc_kick();
 		return 0;
 	} /* else count == 0 */
@@ -321,7 +318,7 @@ static int hvc_open(struct tty_struct *tty, struct file * filp)
 
 	hp->tty = tty;
 
-	spin_unlock_irqrestore(&hp->lock, flags);
+	mutex_unlock(&hp->lock);
 
 	if (hp->ops->notifier_add)
 		rc = hp->ops->notifier_add(hp, hp->data);
@@ -333,9 +330,9 @@ static int hvc_open(struct tty_struct *tty, struct file * filp)
 	 * tty fields and return the kref reference.
 	 */
 	if (rc) {
-		spin_lock_irqsave(&hp->lock, flags);
+		mutex_lock(&hp->lock);
 		hp->tty = NULL;
-		spin_unlock_irqrestore(&hp->lock, flags);
+		mutex_unlock(&hp->lock);
 		tty->driver_data = NULL;
 		kref_put(&hp->kref, destroy_hvc_struct);
 		printk(KERN_ERR "hvc_open: request_irq failed with rc %d.\n", rc);
@@ -349,7 +346,6 @@ static int hvc_open(struct tty_struct *tty, struct file * filp)
 static void hvc_close(struct tty_struct *tty, struct file * filp)
 {
 	struct hvc_struct *hp;
-	unsigned long flags;
 
 	if (tty_hung_up_p(filp))
 		return;
@@ -363,12 +359,12 @@ static void hvc_close(struct tty_struct *tty, struct file * filp)
 		return;
 
 	hp = tty->driver_data;
-	spin_lock_irqsave(&hp->lock, flags);
+	mutex_lock(&hp->lock);
 
 	if (--hp->count == 0) {
 		/* We are done with the tty pointer now. */
 		hp->tty = NULL;
-		spin_unlock_irqrestore(&hp->lock, flags);
+		mutex_unlock(&hp->lock);
 
 		if (hp->ops->notifier_del)
 			hp->ops->notifier_del(hp, hp->data);
@@ -386,7 +382,7 @@ static void hvc_close(struct tty_struct *tty, struct file * filp)
 		if (hp->count < 0)
 			printk(KERN_ERR "hvc_close %X: oops, count is %d\n",
 				hp->vtermno, hp->count);
-		spin_unlock_irqrestore(&hp->lock, flags);
+		mutex_unlock(&hp->lock);
 	}
 
 	kref_put(&hp->kref, destroy_hvc_struct);
@@ -395,7 +391,6 @@ static void hvc_close(struct tty_struct *tty, struct file * filp)
 static void hvc_hangup(struct tty_struct *tty)
 {
 	struct hvc_struct *hp = tty->driver_data;
-	unsigned long flags;
 	int temp_open_count;
 
 	if (!hp)
@@ -404,7 +399,7 @@ static void hvc_hangup(struct tty_struct *tty)
 	/* cancel pending tty resize work */
 	cancel_work_sync(&hp->tty_resize);
 
-	spin_lock_irqsave(&hp->lock, flags);
+	mutex_lock(&hp->lock);
 
 	/*
 	 * The N_TTY line discipline has problems such that in a close vs
@@ -412,7 +407,7 @@ static void hvc_hangup(struct tty_struct *tty)
 	 * that from happening for now.
 	 */
 	if (hp->count <= 0) {
-		spin_unlock_irqrestore(&hp->lock, flags);
+		mutex_unlock(&hp->lock);
 		return;
 	}
 
@@ -421,7 +416,7 @@ static void hvc_hangup(struct tty_struct *tty)
 	hp->n_outbuf = 0;
 	hp->tty = NULL;
 
-	spin_unlock_irqrestore(&hp->lock, flags);
+	mutex_unlock(&hp->lock);
 
 	if (hp->ops->notifier_hangup)
 			hp->ops->notifier_hangup(hp, hp->data);
@@ -462,7 +457,6 @@ static int hvc_push(struct hvc_struct *hp)
 static int hvc_write(struct tty_struct *tty, const unsigned char *buf, int count)
 {
 	struct hvc_struct *hp = tty->driver_data;
-	unsigned long flags;
 	int rsize, written = 0;
 
 	/* This write was probably executed during a tty close. */
@@ -472,7 +466,7 @@ static int hvc_write(struct tty_struct *tty, const unsigned char *buf, int count
 	if (hp->count <= 0)
 		return -EIO;
 
-	spin_lock_irqsave(&hp->lock, flags);
+	mutex_lock(&hp->lock);
 
 	/* Push pending writes */
 	if (hp->n_outbuf > 0)
@@ -488,7 +482,7 @@ static int hvc_write(struct tty_struct *tty, const unsigned char *buf, int count
 		written += rsize;
 		hvc_push(hp);
 	}
-	spin_unlock_irqrestore(&hp->lock, flags);
+	mutex_unlock(&hp->lock);
 
 	/*
 	 * Racy, but harmless, kick thread if there is still pending data.
@@ -511,7 +505,6 @@ static int hvc_write(struct tty_struct *tty, const unsigned char *buf, int count
 static void hvc_set_winsz(struct work_struct *work)
 {
 	struct hvc_struct *hp;
-	unsigned long hvc_flags;
 	struct tty_struct *tty;
 	struct winsize ws;
 
@@ -519,14 +512,14 @@ static void hvc_set_winsz(struct work_struct *work)
 	if (!hp)
 		return;
 
-	spin_lock_irqsave(&hp->lock, hvc_flags);
+	mutex_lock(&hp->lock);
 	if (!hp->tty) {
-		spin_unlock_irqrestore(&hp->lock, hvc_flags);
+		mutex_unlock(&hp->lock);
 		return;
 	}
 	ws  = hp->ws;
 	tty = tty_kref_get(hp->tty);
-	spin_unlock_irqrestore(&hp->lock, hvc_flags);
+	mutex_unlock(&hp->lock);
 
 	tty_do_resize(tty, &ws);
 	tty_kref_put(tty);
@@ -576,11 +569,10 @@ int hvc_poll(struct hvc_struct *hp)
 	struct tty_struct *tty;
 	int i, n, poll_mask = 0;
 	char buf[N_INBUF] __ALIGNED__;
-	unsigned long flags;
 	int read_total = 0;
 	int written_total = 0;
 
-	spin_lock_irqsave(&hp->lock, flags);
+	mutex_lock(&hp->lock);
 
 	/* Push pending writes */
 	if (hp->n_outbuf > 0)
@@ -622,9 +614,9 @@ int hvc_poll(struct hvc_struct *hp)
 		if (n <= 0) {
 			/* Hangup the tty when disconnected from host */
 			if (n == -EPIPE) {
-				spin_unlock_irqrestore(&hp->lock, flags);
+				mutex_unlock(&hp->lock);
 				tty_hangup(tty);
-				spin_lock_irqsave(&hp->lock, flags);
+				mutex_lock(&hp->lock);
 			} else if ( n == -EAGAIN ) {
 				/*
 				 * Some back-ends can only ensure a certain min
@@ -665,7 +657,7 @@ int hvc_poll(struct hvc_struct *hp)
 		tty_wakeup(tty);
 	}
  bail:
-	spin_unlock_irqrestore(&hp->lock, flags);
+	mutex_unlock(&hp->lock);
 
 	if (read_total) {
 		/* Activity is occurring, so reset the polling backoff value to
@@ -714,11 +706,11 @@ static int khvcd(void *unused)
 		try_to_freeze();
 		wmb();
 		if (!cpus_are_in_xmon()) {
-			spin_lock(&hvc_structs_lock);
+			mutex_lock(&hvc_structs_lock);
 			list_for_each_entry(hp, &hvc_structs, next) {
 				poll_mask |= hvc_poll(hp);
 			}
-			spin_unlock(&hvc_structs_lock);
+			mutex_unlock(&hvc_structs_lock);
 		} else
 			poll_mask |= HVC_POLL_READ;
 		if (hvc_kicked)
@@ -777,8 +769,8 @@ struct hvc_struct __devinit *hvc_alloc(uint32_t vtermno, int data,
 	kref_init(&hp->kref);
 
 	INIT_WORK(&hp->tty_resize, hvc_set_winsz);
-	spin_lock_init(&hp->lock);
-	spin_lock(&hvc_structs_lock);
+	mutex_init(&hp->lock);
+	mutex_lock(&hvc_structs_lock);
 
 	/*
 	 * find index to use:
@@ -796,7 +788,7 @@ struct hvc_struct __devinit *hvc_alloc(uint32_t vtermno, int data,
 	hp->index = i;
 
 	list_add_tail(&(hp->next), &hvc_structs);
-	spin_unlock(&hvc_structs_lock);
+	mutex_unlock(&hvc_structs_lock);
 
 	return hp;
 }
@@ -804,10 +796,9 @@ EXPORT_SYMBOL_GPL(hvc_alloc);
 
 int hvc_remove(struct hvc_struct *hp)
 {
-	unsigned long flags;
 	struct tty_struct *tty;
 
-	spin_lock_irqsave(&hp->lock, flags);
+	mutex_lock(&hp->lock);
 	tty = hp->tty;
 
 	if (hp->index < MAX_NR_HVC_CONSOLES)
@@ -815,7 +806,7 @@ int hvc_remove(struct hvc_struct *hp)
 
 	/* Don't whack hp->irq because tty_hangup() will need to free the irq. */
 
-	spin_unlock_irqrestore(&hp->lock, flags);
+	mutex_unlock(&hp->lock);
 
 	/*
 	 * We 'put' the instance that was grabbed when the kref instance
diff --git a/drivers/char/hvc_console.h b/drivers/char/hvc_console.h
index 3c85d78..3c086f8 100644
--- a/drivers/char/hvc_console.h
+++ b/drivers/char/hvc_console.h
@@ -45,7 +45,7 @@
 #define HVC_ALLOC_TTY_ADAPTERS	8
 
 struct hvc_struct {
-	spinlock_t lock;
+	struct mutex lock;
 	int index;
 	struct tty_struct *tty;
 	int count;
