Return-Path: <linux-kernel-owner+w=401wt.eu-S1753414AbYHOCC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbYHOCC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 22:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbYHOCCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 22:02:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbYHOCCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 22:02:17 -0400
From: Neil Brown <neilb@suse.de>
To: dmitry.torokhov@gmail.com
Date: Fri, 15 Aug 2008 12:02:09 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18596.58273.713075.332009@notabene.brown>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH/RFC]  Resolve 2 year old issue with different demands on EVIOCGRAB
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'll let the comments in the patch below to most of the talking.
This came up because I wanted to use EVIOCGRAB in some code on an
Openmoko Freerunner, and found that EVIOCGRAG does different things on
that kernel to elsewhere.  I looked into why, and found that there was
a good reason but that the issues hadn't been completely resolved.  I
hope to help resolve the issues so that EVIOCGRAB can behave the same
everywhere, and still meet everybody's needs.

I would have Cc:ed to Magnus Vigerlof who wrote the original patch on
which this is based, but his Email address doesn't appear in lkml.org.

NeilBrown



Support multiple styles of input device GRABbing with EVIOCGRAB

From: NeilBrown <neilb@suse.de>

This is a 2 year old issue (almost to the day!) which does not
appear to have been properly resolved yet.
See http://lkml.org/lkml/2006/8/12/64

An input device (e.g. touch pad, key board) can be attached to
multiple handlers (/dev/mouseX, console, etc) one of which can be
evdev which provides the /dev/input/event* files.
evdev can support multiple clients on a single device, as multiple
processes can open /dev/input/eventX.  They each get to see all the
events.

EVIOCGRAB is an ioctl on an evdev device which causes all events to go
to that handler, and that client, exclusively.

It is being used for two distinct purposes.

1/ Stop events going to other handlers, so that e.g. absolute touchpad 
   events don't get mapped to relative mouse events.  Keyboard events
   processed by X server don't get processed by console and control-C
   kills the X server.
2/ Stop events going to any other client, so they can temporarily be
   used for a different purpose.  e.g. GRAB all events when putting a
   device partially to sleep (e.g. screen blank) so the events can
   cause a wakeup without being processed by any application.

So there are three levels of grab that are required:

 0/ no grab : all events go to all handlers and all clients
 1/ evdev grab: events only go to evdev, but can then go to any
       client of evdev
 2/ total grab:  events only go to the specific evdev client that
       requested the grab.


0 is the default
mainline allows you to select 2 but not 1.
There is a patch floating around (in the above mail thread, and
in the Openmoko kernel for example) that allows you to select 1, but not 2.

It seems that the "obvious" thing to do is to interpret the argument
to EVIOCGRAB to select between these options.
We cannot use 0, 1, 2 as above - despite the fact that it makes sense
- because that would be a regression in mainline: working programs could break.
Maybe it's best to use 0, 2, 1 and document it clearly.  The chance of
anyone using 2 already has got to be very close to zero.

With this patch in place, clients that are interested in purpose '1'
above would need to be changed to pass '2' to EVIOCGRAB, then (I
think) everyone would be happy.

Note that this patch causes any value other than 0, 1, 2 to return
EINVAL.  I believe this is appropriate defensive practice in general
to allow for future enhancements.  However it does mean that any
current code which uses a value other than 0 or 1 would break.  Is
there any such code?

Note also that it is not possible to switch between '1' and '2'.  A
client must always release the grab first.  Such a switch could be
implemented, but there doesn't seem much point.

Signed-off-by: NeilBrown <neilb@suse.de>

---

 drivers/input/evdev.c |   53 ++++++++++++++++++++++++++++++++++++++++---------
 include/linux/input.h |   10 ++++++++-
 2 files changed, 52 insertions(+), 11 deletions(-)


diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 2d65411..ff4169f 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -29,6 +29,7 @@ struct evdev {
 	struct input_handle handle;
 	wait_queue_head_t wait;
 	struct evdev_client *grab;
+	int grabcnt;
 	struct list_head client_list;
 	spinlock_t client_lock; /* protects client_list */
 	struct mutex mutex;
@@ -39,6 +40,7 @@ struct evdev_client {
 	struct input_event buffer[EVDEV_BUFFER_SIZE];
 	int head;
 	int tail;
+	int grab;
 	spinlock_t buffer_lock; /* protects access to buffer, head and tail */
 	struct fasync_struct *fasync;
 	struct evdev *evdev;
@@ -129,17 +131,38 @@ static void evdev_free(struct device *dev)
 }
 
 /*
+ * Grabs an underlying input device for use by evdev only.
+ */
+static int evdev_shared_grab(struct evdev *evdev, struct evdev_client *client)
+{
+	int error;
+
+	if (client->grab)
+		return -EBUSY;
+
+	if (!evdev->grabcnt) {
+	    error = input_grab_device(&evdev->handle);
+	    if (error)
+		    return error;
+	}
+	evdev->grabcnt++;
+	client->grab = 1;
+
+	return 0;
+}
+
+/*
  * Grabs an event device (along with underlying input device).
  * This function is called with evdev->mutex taken.
  */
-static int evdev_grab(struct evdev *evdev, struct evdev_client *client)
+static int evdev_exclusive_grab(struct evdev *evdev, struct evdev_client *client)
 {
 	int error;
 
 	if (evdev->grab)
 		return -EBUSY;
 
-	error = input_grab_device(&evdev->handle);
+	error = evdev_shared_grab(evdev, client);
 	if (error)
 		return error;
 
@@ -151,12 +174,17 @@ static int evdev_grab(struct evdev *evdev, struct evdev_client *client)
 
 static int evdev_ungrab(struct evdev *evdev, struct evdev_client *client)
 {
-	if (evdev->grab != client)
+	if (!client->grab)
 		return  -EINVAL;
 
-	rcu_assign_pointer(evdev->grab, NULL);
-	synchronize_rcu();
-	input_release_device(&evdev->handle);
+	if (evdev->grab == client) {
+		rcu_assign_pointer(evdev->grab, NULL);
+		synchronize_rcu();
+	}
+
+	if (!--evdev->grabcnt && evdev->exist)
+		input_release_device(&evdev->handle);
+	client->grab = 0;
 
 	return 0;
 }
@@ -231,7 +259,7 @@ static int evdev_release(struct inode *inode, struct file *file)
 	struct evdev *evdev = client->evdev;
 
 	mutex_lock(&evdev->mutex);
-	if (evdev->grab == client)
+	if (client->grab)
 		evdev_ungrab(evdev, client);
 	mutex_unlock(&evdev->mutex);
 
@@ -721,10 +749,15 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 		return 0;
 
 	case EVIOCGRAB:
-		if (p)
-			return evdev_grab(evdev, client);
-		else
+		switch ((unsigned long)p) {
+		case EVG_NONE:
 			return evdev_ungrab(evdev, client);
+		case EVG_EXCLUSIVE:
+			return evdev_exclusive_grab(evdev, client);
+		case EVG_SHARED:
+			return evdev_shared_grab(evdev, client);
+		default: return -EINVAL;
+		}
 
 	default:
 
diff --git a/include/linux/input.h b/include/linux/input.h
index a5802c9..d1e6a8a 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -79,7 +79,7 @@ struct input_absinfo {
 #define EVIOCRMFF		_IOW('E', 0x81, int)			/* Erase a force effect */
 #define EVIOCGEFFECTS		_IOR('E', 0x84, int)			/* Report number of effects playable at the same time */
 
-#define EVIOCGRAB		_IOW('E', 0x90, int)			/* Grab/Release device */
+#define EVIOCGRAB		_IOW('E', 0x90, int)			/* Grab/Release device. See GRAB types below */
 
 /*
  * Event types
@@ -108,6 +108,14 @@ struct input_absinfo {
 #define SYN_CONFIG		1
 
 /*
+ * GRAB types
+ */
+#define	EVG_NONE		0	/* release any active GRAB */
+#define	EVG_EXCLUSIVE		1	/* No other handler or evdev gets events */
+#define	EVG_SHARED		2	/* No other handler gets events, but other
+					 * evdev clients still do.
+					 */
+/*
  * Keys and buttons
  *
  * Most of the keys/buttons are modeled after USB HUT 1.12
