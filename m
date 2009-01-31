Return-Path: <linux-kernel-owner+w=401wt.eu-S1760727AbZAaC7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727AbZAaC7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 21:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbZAaCrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:17 -0500
Received: from kroah.org ([198.145.64.141]:55153 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756178AbZAaCrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:09 -0500
Date: Fri, 30 Jan 2009 18:42:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, John McCutchan <ttb@tentacle.dhs.org>,
       Robert Love <rlove@google.com>, Vegard Nossum <vegard.nossum@gmail.com>
Subject: [patch 03/43] inotify: clean up inotify_read and fix locking
	problems
Message-ID: <20090131024219.GD12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="inotify-clean-up-inotify_read-and-fix-locking-problems.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vegard Nossum <vegard.nossum@gmail.com>

commit 3632dee2f8b8a9720329f29eeaa4ec4669a3aff8 upstream.

If userspace supplies an invalid pointer to a read() of an inotify
instance, the inotify device's event list mutex is unlocked twice.
This causes an unbalance which effectively leaves the data structure
unprotected, and we can trigger oopses by accessing the inotify
instance from different tasks concurrently.

The best fix (contributed largely by Linus) is a total rewrite
of the function in question:

On Thu, Jan 22, 2009 at 7:05 AM, Linus Torvalds wrote:
> The thing to notice is that:
>
>  - locking is done in just one place, and there is no question about it
>   not having an unlock.
>
>  - that whole double-while(1)-loop thing is gone.
>
>  - use multiple functions to make nesting and error handling sane
>
>  - do error testing after doing the things you always need to do, ie do
>   this:
>
>        mutex_lock(..)
>        ret = function_call();
>        mutex_unlock(..)
>
>        .. test ret here ..
>
>   instead of doing conditional exits with unlocking or freeing.
>
> So if the code is written in this way, it may still be buggy, but at least
> it's not buggy because of subtle "forgot to unlock" or "forgot to free"
> issues.
>
> This _always_ unlocks if it locked, and it always frees if it got a
> non-error kevent.

Cc: John McCutchan <ttb@tentacle.dhs.org>
Cc: Robert Love <rlove@google.com>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/inotify_user.c |  135 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 74 insertions(+), 61 deletions(-)

--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -427,10 +427,61 @@ static unsigned int inotify_poll(struct 
 	return ret;
 }
 
+/*
+ * Get an inotify_kernel_event if one exists and is small
+ * enough to fit in "count". Return an error pointer if
+ * not large enough.
+ *
+ * Called with the device ev_mutex held.
+ */
+static struct inotify_kernel_event *get_one_event(struct inotify_device *dev,
+						  size_t count)
+{
+	size_t event_size = sizeof(struct inotify_event);
+	struct inotify_kernel_event *kevent;
+
+	if (list_empty(&dev->events))
+		return NULL;
+
+	kevent = inotify_dev_get_event(dev);
+	if (kevent->name)
+		event_size += kevent->event.len;
+
+	if (event_size > count)
+		return ERR_PTR(-EINVAL);
+
+	remove_kevent(dev, kevent);
+	return kevent;
+}
+
+/*
+ * Copy an event to user space, returning how much we copied.
+ *
+ * We already checked that the event size is smaller than the
+ * buffer we had in "get_one_event()" above.
+ */
+static ssize_t copy_event_to_user(struct inotify_kernel_event *kevent,
+				  char __user *buf)
+{
+	size_t event_size = sizeof(struct inotify_event);
+
+	if (copy_to_user(buf, &kevent->event, event_size))
+		return -EFAULT;
+
+	if (kevent->name) {
+		buf += event_size;
+
+		if (copy_to_user(buf, kevent->name, kevent->event.len))
+			return -EFAULT;
+
+		event_size += kevent->event.len;
+	}
+	return event_size;
+}
+
 static ssize_t inotify_read(struct file *file, char __user *buf,
 			    size_t count, loff_t *pos)
 {
-	size_t event_size = sizeof (struct inotify_event);
 	struct inotify_device *dev;
 	char __user *start;
 	int ret;
@@ -440,81 +491,43 @@ static ssize_t inotify_read(struct file 
 	dev = file->private_data;
 
 	while (1) {
+		struct inotify_kernel_event *kevent;
 
 		prepare_to_wait(&dev->wq, &wait, TASK_INTERRUPTIBLE);
 
 		mutex_lock(&dev->ev_mutex);
-		if (!list_empty(&dev->events)) {
-			ret = 0;
-			break;
-		}
+		kevent = get_one_event(dev, count);
 		mutex_unlock(&dev->ev_mutex);
 
-		if (file->f_flags & O_NONBLOCK) {
-			ret = -EAGAIN;
-			break;
-		}
-
-		if (signal_pending(current)) {
-			ret = -EINTR;
-			break;
+		if (kevent) {
+			ret = PTR_ERR(kevent);
+			if (IS_ERR(kevent))
+				break;
+			ret = copy_event_to_user(kevent, buf);
+			free_kevent(kevent);
+			if (ret < 0)
+				break;
+			buf += ret;
+			count -= ret;
+			continue;
 		}
 
-		schedule();
-	}
-
-	finish_wait(&dev->wq, &wait);
-	if (ret)
-		return ret;
-
-	while (1) {
-		struct inotify_kernel_event *kevent;
-
-		ret = buf - start;
-		if (list_empty(&dev->events))
+		ret = -EAGAIN;
+		if (file->f_flags & O_NONBLOCK)
 			break;
-
-		kevent = inotify_dev_get_event(dev);
-		if (event_size + kevent->event.len > count) {
-			if (ret == 0 && count > 0) {
-				/*
-				 * could not get a single event because we
-				 * didn't have enough buffer space.
-				 */
-				ret = -EINVAL;
-			}
+		ret = -EINTR;
+		if (signal_pending(current))
 			break;
-		}
-		remove_kevent(dev, kevent);
 
-		/*
-		 * Must perform the copy_to_user outside the mutex in order
-		 * to avoid a lock order reversal with mmap_sem.
-		 */
-		mutex_unlock(&dev->ev_mutex);
-
-		if (copy_to_user(buf, &kevent->event, event_size)) {
-			ret = -EFAULT;
+		if (start != buf)
 			break;
-		}
-		buf += event_size;
-		count -= event_size;
-
-		if (kevent->name) {
-			if (copy_to_user(buf, kevent->name, kevent->event.len)){
-				ret = -EFAULT;
-				break;
-			}
-			buf += kevent->event.len;
-			count -= kevent->event.len;
-		}
 
-		free_kevent(kevent);
-
-		mutex_lock(&dev->ev_mutex);
+		schedule();
 	}
-	mutex_unlock(&dev->ev_mutex);
 
+	finish_wait(&dev->wq, &wait);
+	if (start != buf && ret != -EFAULT)
+		ret = buf - start;
 	return ret;
 }
 

