Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbZCCOR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbZCCOR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 09:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZCCORR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 09:17:17 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:51925 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbZCCORP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 09:17:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cHruhT5A5UuEh1cppPAEam1mUNJvMBtX6RBh3OBhSdnSsT8IBtVi/g1tBzt/v4UOpN
         jR7UpRALm70iRR2l+l7w3+XlVL5Ku3f9j5T5ExvCgtUdgYYDkwkYnKGC3asTeGGjHYOy
         NNCug9Mjm99D5fiLzwQBgCBoeMkIvrAfM2Gsc=
Date: Tue, 3 Mar 2009 15:17:01 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] Add virtual "idle" device
Message-ID: <20090303141652.GA31091@joi>
References: <1236033772-20329-2-git-send-email-marcin.slusarz@gmail.com> <10f740e80903030200y3f055c28u6a01f279a53cacc1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10f740e80903030200y3f055c28u6a01f279a53cacc1@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 11:00:04AM +0100, Geert Uytterhoeven wrote:
> On Mon, Mar 2, 2009 at 23:42, Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> > --- /dev/null
> > +++ b/drivers/char/idle.c
> > @@ -0,0 +1,445 @@
> 
> > +#ifdef DEBUG
> > +#define idle_printk(args...) printk(KERN_DEBUG "IDLEDEV: " args)
> > +#else
> > +#define idle_printk(args...) do {} while (0)
> > +#endif
> 
> Please use the standard debug interface, i.e.
> 
> #define pr_fmt(fmt) "IDLEDEV: " fmt
> 
> and use pr_debug() everywhere, to always have printf()-style format checking.

Thanks for looking at the patch!

And here's a patch implementing your request:

---
From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH] idle: convert idle_printk to pr_debug

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
 drivers/char/idle.c |   40 +++++++++++++++++++---------------------
 1 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/char/idle.c b/drivers/char/idle.c
index 5fe792d..d2b6b2b 100644
--- a/drivers/char/idle.c
+++ b/drivers/char/idle.c
@@ -13,11 +13,17 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  */
+
+/* these 2 defines must be before include linux/kernel.h */
+/*#define DEBUG*/
+#define pr_fmt(fmt) "IDLEDEV: " fmt
+
 #include <linux/bug.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/fs.h>
 #include <linux/hrtimer.h>
+#include <linux/kernel.h>
 #include <linux/keyboard.h>
 #include <linux/ktime.h>
 #include <linux/module.h>
@@ -32,14 +38,6 @@
 
 /* TODO: support all input devices */
 
-/*#define DEBUG*/
-
-#ifdef DEBUG
-#define idle_printk(args...) printk(KERN_DEBUG "IDLEDEV: " args)
-#else
-#define idle_printk(args...) do {} while (0)
-#endif
-
 /* spinlock protecting all data */
 static DEFINE_SPINLOCK(idle_events_lock);
 
@@ -66,7 +64,7 @@ static int idle_kb_event(struct notifier_block *this,
 {
 	unsigned long flags;
 
-	idle_printk("kb_event\n");
+	pr_debug("kb_event\n");
 
 	spin_lock_irqsave(&idle_events_lock, flags);
 
@@ -124,7 +122,7 @@ static enum hrtimer_restart idle_timer_timeout(struct hrtimer *timer)
 			container_of(timer, struct idle_file_data, timer);
 	unsigned long flags;
 
-	idle_printk("timeout\n");
+	pr_debug("timeout\n");
 
 	spin_lock_irqsave(&idle_events_lock, flags);
 
@@ -147,7 +145,7 @@ static int idle_get_event(struct idle_file_data *d, u8 __user *user_event)
 	bool wakeup;
 	u8 event;
 
-	idle_printk("idle_get_event\n");
+	pr_debug("idle_get_event\n");
 
 	spin_lock_irq(&idle_events_lock);
 
@@ -187,7 +185,7 @@ static int idle_set_timeout(struct idle_file_data *d, u32 secs)
 	if (ktime_compare(timeout, d->timeout) == 0)
 		return -EALREADY;
 
-	idle_printk("setting timeout to %u\n", secs);
+	pr_debug("setting timeout to %u\n", secs);
 
 	hrtimer_cancel(&d->timer);
 
@@ -204,7 +202,7 @@ static int idle_set_timeout(struct idle_file_data *d, u32 secs)
 
 static int idle_remove_timeout(struct idle_file_data *d)
 {
-	idle_printk("removing timeout\n");
+	pr_debug("removing timeout\n");
 
 	hrtimer_cancel(&d->timer);
 
@@ -260,13 +258,13 @@ static unsigned int idle_poll(struct file *f, poll_table *pt)
 	unsigned int mask = POLLOUT | POLLWRNORM;
 	struct idle_file_data *d = f->private_data;
 
-	idle_printk("idle_poll\n");
+	pr_debug("idle_poll\n");
 
 	spin_lock_irq(&idle_events_lock);
 
 	if (event_available(d)) {
 		mask |= POLLIN | POLLRDNORM;
-		idle_printk("idle data available\n");
+		pr_debug("idle data available\n");
 	}
 
 	if (d->waiting_for_wakeup)
@@ -296,7 +294,7 @@ static int idle_new_client(void)
 	mutex_lock(&open_counter_mutex);
 
 	if (open_counter == 0) {
-		idle_printk("first client connected\n");
+		pr_debug("first client connected\n");
 
 		last_input_event_time = ktime_get_real();
 
@@ -344,7 +342,7 @@ static void idle_client_leaving(void)
 	mutex_lock(&open_counter_mutex);
 
 	if (--open_counter == 0) {
-		idle_printk("last client disconnected\n");
+		pr_debug("last client disconnected\n");
 
 		WARN_ON(unregister_keyboard_notifier(&idle_nb));
 	}
@@ -381,11 +379,11 @@ static int __init idle_init(void)
 {
 	int err = 0;
 
-	idle_printk("starting\n");
+	pr_debug("starting\n");
 
 	idle_major = register_chrdev(0, "idle", &idle_ops);
 	if (idle_major < 0) {
-		idle_printk("cannot register device\n");
+		pr_debug("cannot register device\n");
 		return idle_major;
 	}
 
@@ -402,7 +400,7 @@ static int __init idle_init(void)
 		goto out_device;
 	}
 
-	idle_printk("device major: %d\n", idle_major);
+	pr_debug("device major: %d\n", idle_major);
 
 	if (daemon_mode) {
 		err = idle_new_client();
@@ -423,7 +421,7 @@ out_class:
 
 static void __exit idle_exit(void)
 {
-	idle_printk("exiting\n");
+	pr_debug("exiting\n");
 
 	if (daemon_mode)
 		idle_client_leaving();
-- 
1.6.0.6
