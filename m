Return-Path: <linux-kernel-owner+w=401wt.eu-S1759256AbYC1M6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256AbYC1M6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758515AbYC1Mzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:55:36 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:34541 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758477AbYC1Mzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:55:32 -0400
Date: Fri, 28 Mar 2008 07:23:46 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 1/35] W1: fix deadlocks and remove w1_control_thread
Message-ID: <20080328122346.GB3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bn2rw/3z4jIqBvZU"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:23:46 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bn2rw/3z4jIqBvZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Here is an improvement to help in a dynamic ticks kenrel.  I'm
removing w1_control_thread as it would continuously sleep for one
second intervals when it only had two tasks, reconnect slave devices
if a new family is detected (usually happens one on bootup), and when
the one wire system is being unloaded.  The majority of the time there
isn't anything to do, the ax doesn't chop out a thread this obvious
very often.

This fixes a deadlock of removing a slave device driver when a slave
is currently using it.  The slaves using that device driver needs to
be unregistered first.

Now that the slaves would be unregistered to fix that deadlock, there
was a locking order deadlock introduced.  This was resolved by adding
another argument to the search callback so it didn't need to acquire
the other lock (and it is faster as it doesn't have to search).

This fixes an infinite loop for when a slave device driver is loaded
and there will be at least two slave devices unclaimed.

w1_family.h 1.3
w1.h 1.5
The function prototype for w1_reconnect_slaves was moved to the w1.h
header as it is defined in the w1.c source file.

masters/ds1wm.c 1.2
Changes to the 1-wire search routine to pass w1_master back to the
callback.  This is untested, I don't have the hardware.

w1.c 1.2
w1_family.c 1.3
Fixed the infinite loop that happens if a slave device module is
removed from the kernel and there is a slave using that driver family.
That involves unattaching all slaves that are using that family after
the family has been removed from the list of available family drivers.
This is not a race condition, it will happen everytime.

w1.c 1.3
w1.h 1.6
w1_int.c 1.2
- w1_control_thread removed
  - 1 second wake up polling when not required
  - infinite loop with two (or more) unclaimed slave devices
  - did not handle removal of slave device drivers
- w1_reconnect_slaves enhanced
  - now does the reconnect work of w1_control
  - fixes infinite loop
  - handles removal of slave devices
- w1_detach_family removed
- w1_search_master function removed (fix deadlock from above)
- w1_slave_found_callback
  - takes the w1_master pointer so w1_search_master is not required
- w1_bus_master
  - search now takes a pointer to w1_master for the callback

w1_control just sounds to me like a bad idea.  Here is a kernel thread
that only has two things to do.  Die and respond to slave reconnect
events.  The die task is only executed when the one wire system is
unloaded (happens once in the module lifetime).  Slave reconnect
events only happen when a slave device driver is loaded and there are
four such drivers which might happen once on boot, or more frequently
for development.  Why have a kernel thread wake up 3600 times an hour
for five events that will happen during the lifetime of a normal
system operation?

The slave reconnect was incorrectly coded.  When a new slave device
driver (and family code) was available it was intended to give slaves
using the default device a chance to use the specific slave device
driver.  It was using the list_for_each_entry_safe and took the brute
force method of any device using the default device was detached and
reconnected.  If there was a slave device driver that matched the
family code it would be added back to the list with that driver,
otherwise it would be added back with the default driver.  It only
takes two devices that don't match the current set of family codes to
be added to the end of the list to get into an infinite loop of
detach, add to the end of the list, get next entry.

w1_control die cleanup has been moved to the w1_int.c
__w1_remove_master_device routine.  Now the cleanup can be executed
immediately without the maximum one second wait.                           =
     w1_destroy_master_attributes and w1_slave_detach are no longer static
so they can be called from w1_int.c.

w1_reconnect_slaves now does the work of adding a family code or
removing it instead of setting a flag for w1_control thread to check
and do later.  For an added family it will only detach slaves that
will be using that family code fixing the infinte loop.  It will also
detach devices using the family code when a family code is being
removed, reattaching them with the default driver.

w1_family.c on slave device driver unload would remove the driver from
the list of availble family codes, but it did not disconnect slaves
that might be using the driver being removed.  If a slave was using
the driver then the reference count would never become zero and
w1_unregiter_family would never return.  With the improved
w1_reconnect_slaves it will now detach slaves.

Remove previously introduced w1_detach_family and add an argument to
w1_reconnect_slaves because the two functions only differ on selecting
which slaves are detached and attached.

Deadlock (introduced when w1_control_thread was removed as the code        =
     is being executed now rather than later with a different locking
order).  Operations on the bus hold the mutex for that bus.  The bus
search holds the mutex while in progress.  When a new slave is found
the callback w1_slave_found is called which then calls
w1_search_master to search for the master device that matches the
void* argument.  It locks the w1_mlock to search through w1_masters.
On my small two device network the bus search takes 7.7 seconds which
can hold the bus mutex for quite some time.

Execute rmmod on one of the slave device drivers and part of the
family cleanup will detach slave using that family code.  The
w1_reconnect_slaves locks w1_mlock to access w1_masters, then locks
each bus mutex to scan the set of slaves.
bus search, lock mutex
rmmod slave device driver
        w1_reconnect_slaves lock w1_mlock
        block on mutex (which bus search has)
bus search finds slave
        w1_search_master block w1_mlock (which slave rmmod has)
        DEADLOCK
I should also note that on my system with the default bus search,
43.5% of the time is spent in the bus search.  That's a huge time
window for the deadlock.

Solution, remove w1_search_master and instead pass the w1_master
pointer to the find slave callback so it doesn't have to search the
w1_masters list and does not require the w1_mlock.
The callback now has the prototype,
typedef void (* w1_slave_found_callback)(struct w1_master *, u64);

w1_io.c 1.5
Added the extra w1_master pointer when calling search.

Signed-off-by: David Fries <david@fries.net>
---
 drivers/w1/masters/ds1wm.c |    6 +-
 drivers/w1/w1.c            |  145 ++++++++++------------------------------=
----
 drivers/w1/w1.h            |   19 +++++-
 drivers/w1/w1_family.c     |    6 ++-
 drivers/w1/w1_family.h     |    1 -
 drivers/w1/w1_int.c        |   13 ++++
 drivers/w1/w1_io.c         |    3 +-
 7 files changed, 71 insertions(+), 122 deletions(-)

diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index 10211e4..ea894bf 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -274,8 +274,8 @@ static u8 ds1wm_reset_bus(void *data)
 	return 0;
 }
=20
-static void ds1wm_search(void *data, u8 search_type,
-			 w1_slave_found_callback slave_found)
+static void ds1wm_search(void *data, struct w1_master *master_dev,
+			u8 search_type, w1_slave_found_callback slave_found)
 {
 	struct ds1wm_data *ds1wm_data =3D data;
 	int i;
@@ -313,7 +313,7 @@ static void ds1wm_search(void *data, u8 search_type,
 	ds1wm_write_register(ds1wm_data, DS1WM_CMD, ~DS1WM_CMD_SRA);
 	ds1wm_reset(ds1wm_data);
=20
-	slave_found(ds1wm_data, rom_id);
+	slave_found(master_dev, rom_id);
 }
=20
 /* --------------------------------------------------------------------- */
diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 7293c9b..2d11fe7 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -46,20 +46,16 @@ MODULE_AUTHOR("Evgeniy Polyakov <johnpol@2ka.mipt.ru>");
 MODULE_DESCRIPTION("Driver for 1-wire Dallas network protocol.");
=20
 static int w1_timeout =3D 10;
-static int w1_control_timeout =3D 1;
 int w1_max_slave_count =3D 10;
 int w1_max_slave_ttl =3D 10;
=20
 module_param_named(timeout, w1_timeout, int, 0);
-module_param_named(control_timeout, w1_control_timeout, int, 0);
 module_param_named(max_slave_count, w1_max_slave_count, int, 0);
 module_param_named(slave_ttl, w1_max_slave_ttl, int, 0);
=20
 DEFINE_MUTEX(w1_mlock);
 LIST_HEAD(w1_masters);
=20
-static struct task_struct *w1_control_thread;
-
 static int w1_master_match(struct device *dev, struct device_driver *drv)
 {
 	return 1;
@@ -390,7 +386,7 @@ int w1_create_master_attributes(struct w1_master *maste=
r)
 	return sysfs_create_group(&master->dev.kobj, &w1_master_defattr_group);
 }
=20
-static void w1_destroy_master_attributes(struct w1_master *master)
+void w1_destroy_master_attributes(struct w1_master *master)
 {
 	sysfs_remove_group(&master->dev.kobj, &w1_master_defattr_group);
 }
@@ -567,7 +563,7 @@ static int w1_attach_slave_device(struct w1_master *dev=
, struct w1_reg_num *rn)
 	return 0;
 }
=20
-static void w1_slave_detach(struct w1_slave *sl)
+void w1_slave_detach(struct w1_slave *sl)
 {
 	struct w1_netlink_msg msg;
=20
@@ -591,24 +587,6 @@ static void w1_slave_detach(struct w1_slave *sl)
 	kfree(sl);
 }
=20
-static struct w1_master *w1_search_master(void *data)
-{
-	struct w1_master *dev;
-	int found =3D 0;
-
-	mutex_lock(&w1_mlock);
-	list_for_each_entry(dev, &w1_masters, w1_master_entry) {
-		if (dev->bus_master->data =3D=3D data) {
-			found =3D 1;
-			atomic_inc(&dev->refcnt);
-			break;
-		}
-	}
-	mutex_unlock(&w1_mlock);
-
-	return (found)?dev:NULL;
-}
-
 struct w1_master *w1_search_master_id(u32 id)
 {
 	struct w1_master *dev;
@@ -656,34 +634,48 @@ struct w1_slave *w1_search_slave(struct w1_reg_num *i=
d)
 	return (found)?sl:NULL;
 }
=20
-void w1_reconnect_slaves(struct w1_family *f)
+void w1_reconnect_slaves(struct w1_family *f, int attach)
 {
+	struct w1_slave *sl, *sln;
 	struct w1_master *dev;
=20
 	mutex_lock(&w1_mlock);
 	list_for_each_entry(dev, &w1_masters, w1_master_entry) {
-		dev_dbg(&dev->dev, "Reconnecting slaves in %s into new family %02x.\n",
-				dev->name, f->fid);
-		set_bit(W1_MASTER_NEED_RECONNECT, &dev->flags);
+		dev_dbg(&dev->dev, "Reconnecting slaves in device %s for family %02x.\n",
+			dev->name, f->fid);
+		mutex_lock(&dev->mutex);
+		list_for_each_entry_safe(sl, sln, &dev->slist, w1_slave_entry) {
+			/* If it is a new family, slaves with the default
+			 * family driver and are that family will be
+			 * connected.  If the family is going away, devices
+			 * matching that family are reconneced.
+			 */
+			if((attach && sl->family->fid =3D=3D W1_FAMILY_DEFAULT
+				&& sl->reg_num.family =3D=3D f->fid) ||
+				(!attach && sl->family->fid =3D=3D f->fid)) {
+				struct w1_reg_num rn;
+
+				memcpy(&rn, &sl->reg_num, sizeof(rn));
+				w1_slave_detach(sl);
+
+				w1_attach_slave_device(dev, &rn);
+			}
+		}
+		dev_dbg(&dev->dev, "Reconnecting slaves in device %s has been finished.\=
n", dev->name);
+		mutex_unlock(&dev->mutex);
 	}
 	mutex_unlock(&w1_mlock);
 }
=20
-static void w1_slave_found(void *data, u64 rn)
+static void w1_slave_found(struct w1_master *dev, u64 rn)
 {
 	int slave_count;
 	struct w1_slave *sl;
 	struct list_head *ent;
 	struct w1_reg_num *tmp;
-	struct w1_master *dev;
 	u64 rn_le =3D cpu_to_le64(rn);
=20
-	dev =3D w1_search_master(data);
-	if (!dev) {
-		printk(KERN_ERR "Failed to find w1 master device for data %p, "
-		       "it is impossible.\n", data);
-		return;
-	}
+	atomic_inc(&dev->refcnt);
=20
 	tmp =3D (struct w1_reg_num *) &rn;
=20
@@ -785,76 +777,11 @@ void w1_search(struct w1_master *dev, u8 search_type,=
 w1_slave_found_callback cb
 			if ( (desc_bit =3D=3D last_zero) || (last_zero < 0))
 				last_device =3D 1;
 			desc_bit =3D last_zero;
-			cb(dev->bus_master->data, rn);
+			cb(dev, rn);
 		}
 	}
 }
=20
-static int w1_control(void *data)
-{
-	struct w1_slave *sl, *sln;
-	struct w1_master *dev, *n;
-	int have_to_wait =3D 0;
-
-	set_freezable();
-	while (!kthread_should_stop() || have_to_wait) {
-		have_to_wait =3D 0;
-
-		try_to_freeze();
-		msleep_interruptible(w1_control_timeout * 1000);
-
-		list_for_each_entry_safe(dev, n, &w1_masters, w1_master_entry) {
-			if (!kthread_should_stop() && !dev->flags)
-				continue;
-			/*
-			 * Little race: we can create thread but not set the flag.
-			 * Get a chance for external process to set flag up.
-			 */
-			if (!dev->initialized) {
-				have_to_wait =3D 1;
-				continue;
-			}
-
-			if (kthread_should_stop() || test_bit(W1_MASTER_NEED_EXIT, &dev->flags)=
) {
-				set_bit(W1_MASTER_NEED_EXIT, &dev->flags);
-
-				mutex_lock(&w1_mlock);
-				list_del(&dev->w1_master_entry);
-				mutex_unlock(&w1_mlock);
-
-				mutex_lock(&dev->mutex);
-				list_for_each_entry_safe(sl, sln, &dev->slist, w1_slave_entry) {
-					w1_slave_detach(sl);
-				}
-				w1_destroy_master_attributes(dev);
-				mutex_unlock(&dev->mutex);
-				atomic_dec(&dev->refcnt);
-				continue;
-			}
-
-			if (test_bit(W1_MASTER_NEED_RECONNECT, &dev->flags)) {
-				dev_dbg(&dev->dev, "Reconnecting slaves in device %s.\n", dev->name);
-				mutex_lock(&dev->mutex);
-				list_for_each_entry_safe(sl, sln, &dev->slist, w1_slave_entry) {
-					if (sl->family->fid =3D=3D W1_FAMILY_DEFAULT) {
-						struct w1_reg_num rn;
-
-						memcpy(&rn, &sl->reg_num, sizeof(rn));
-						w1_slave_detach(sl);
-
-						w1_attach_slave_device(dev, &rn);
-					}
-				}
-				dev_dbg(&dev->dev, "Reconnecting slaves in device %s has been finished=
=2E\n", dev->name);
-				clear_bit(W1_MASTER_NEED_RECONNECT, &dev->flags);
-				mutex_unlock(&dev->mutex);
-			}
-		}
-	}
-
-	return 0;
-}
-
 void w1_search_process(struct w1_master *dev, u8 search_type)
 {
 	struct w1_slave *sl, *sln;
@@ -932,18 +859,13 @@ static int w1_init(void)
 		goto err_out_master_unregister;
 	}
=20
-	w1_control_thread =3D kthread_run(w1_control, NULL, "w1_control");
-	if (IS_ERR(w1_control_thread)) {
-		retval =3D PTR_ERR(w1_control_thread);
-		printk(KERN_ERR "Failed to create control thread. err=3D%d\n",
-			retval);
-		goto err_out_slave_unregister;
-	}
-
 	return 0;
=20
+#if 0
+/* For undoing the slave register if there was a step after it. */
 err_out_slave_unregister:
 	driver_unregister(&w1_slave_driver);
+#endif
=20
 err_out_master_unregister:
 	driver_unregister(&w1_master_driver);
@@ -959,13 +881,12 @@ static void w1_fini(void)
 {
 	struct w1_master *dev;
=20
+	/* Set netlink removal messages and some cleanup */
 	list_for_each_entry(dev, &w1_masters, w1_master_entry)
 		__w1_remove_master_device(dev);
=20
 	w1_fini_netlink();
=20
-	kthread_stop(w1_control_thread);
-
 	driver_unregister(&w1_slave_driver);
 	driver_unregister(&w1_master_driver);
 	bus_unregister(&w1_bus_type);
diff --git a/drivers/w1/w1.h b/drivers/w1/w1.h
index f1df534..1533cb3 100644
--- a/drivers/w1/w1.h
+++ b/drivers/w1/w1.h
@@ -77,7 +77,7 @@ struct w1_slave
 	struct completion	released;
 };
=20
-typedef void (* w1_slave_found_callback)(void *, u64);
+typedef void (* w1_slave_found_callback)(struct w1_master *, u64);
=20
=20
 /**
@@ -142,12 +142,14 @@ struct w1_bus_master
 	 */
 	u8		(*reset_bus)(void *);
=20
-	/** Really nice hardware can handles the different types of ROM search */
-	void		(*search)(void *, u8, w1_slave_found_callback);
+	/** Really nice hardware can handles the different types of ROM search
+	 *  w1_master* is passed to the slave found callback.
+	 */
+	void		(*search)(void *, struct w1_master *,
+		u8, w1_slave_found_callback);
 };
=20
 #define W1_MASTER_NEED_EXIT		0
-#define W1_MASTER_NEED_RECONNECT	1
=20
 struct w1_master
 {
@@ -181,12 +183,21 @@ struct w1_master
 };
=20
 int w1_create_master_attributes(struct w1_master *);
+void w1_destroy_master_attributes(struct w1_master *master);
 void w1_search(struct w1_master *dev, u8 search_type, w1_slave_found_callb=
ack cb);
 void w1_search_devices(struct w1_master *dev, u8 search_type, w1_slave_fou=
nd_callback cb);
 struct w1_slave *w1_search_slave(struct w1_reg_num *id);
 void w1_search_process(struct w1_master *dev, u8 search_type);
 struct w1_master *w1_search_master_id(u32 id);
=20
+/* Disconnect and reconnect devices in the given family.  Used for finding
+ * unclaimed devices after a family has been registered or releasing devic=
es
+ * after a family has been unregistered.  Set attach to 1 when a new family
+ * has just been registered, to 0 when it has been unregistered.
+ */
+void w1_reconnect_slaves(struct w1_family *f, int attach);
+void w1_slave_detach(struct w1_slave *sl);
+
 u8 w1_triplet(struct w1_master *dev, int bdir);
 void w1_write_8(struct w1_master *, u8);
 int w1_reset_bus(struct w1_master *);
diff --git a/drivers/w1/w1_family.c b/drivers/w1/w1_family.c
index a3c95bd..8c35f9c 100644
--- a/drivers/w1/w1_family.c
+++ b/drivers/w1/w1_family.c
@@ -53,7 +53,8 @@ int w1_register_family(struct w1_family *newf)
 	}
 	spin_unlock(&w1_flock);
=20
-	w1_reconnect_slaves(newf);
+	/* check default devices against the new set of drivers */
+	w1_reconnect_slaves(newf, 1);
=20
 	return ret;
 }
@@ -77,6 +78,9 @@ void w1_unregister_family(struct w1_family *fent)
=20
 	spin_unlock(&w1_flock);
=20
+	/* deatch devices using this family code */
+	w1_reconnect_slaves(fent, 0);
+
 	while (atomic_read(&fent->refcnt)) {
 		printk(KERN_INFO "Waiting for family %u to become free: refcnt=3D%d.\n",
 				fent->fid, atomic_read(&fent->refcnt));
diff --git a/drivers/w1/w1_family.h b/drivers/w1/w1_family.h
index ef1e1da..296a87e 100644
--- a/drivers/w1/w1_family.h
+++ b/drivers/w1/w1_family.h
@@ -63,6 +63,5 @@ void __w1_family_get(struct w1_family *);
 struct w1_family * w1_family_registered(u8);
 void w1_unregister_family(struct w1_family *);
 int w1_register_family(struct w1_family *);
-void w1_reconnect_slaves(struct w1_family *f);
=20
 #endif /* __W1_FAMILY_H */
diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index 6840dfe..15a798f 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -148,10 +148,23 @@ err_out_free_dev:
 void __w1_remove_master_device(struct w1_master *dev)
 {
 	struct w1_netlink_msg msg;
+	struct w1_slave *sl, *sln;
=20
 	set_bit(W1_MASTER_NEED_EXIT, &dev->flags);
 	kthread_stop(dev->thread);
=20
+	mutex_lock(&w1_mlock);
+	list_del(&dev->w1_master_entry);
+	mutex_unlock(&w1_mlock);
+
+	mutex_lock(&dev->mutex);
+	list_for_each_entry_safe(sl, sln, &dev->slist, w1_slave_entry) {
+		w1_slave_detach(sl);
+	}
+	w1_destroy_master_attributes(dev);
+	mutex_unlock(&dev->mutex);
+	atomic_dec(&dev->refcnt);
+
 	while (atomic_read(&dev->refcnt)) {
 		dev_info(&dev->dev, "Waiting for %s to become free: refcnt=3D%d.\n",
 				dev->name, atomic_read(&dev->refcnt));
diff --git a/drivers/w1/w1_io.c b/drivers/w1/w1_io.c
index 30b6fbf..0056ef6 100644
--- a/drivers/w1/w1_io.c
+++ b/drivers/w1/w1_io.c
@@ -277,7 +277,8 @@ void w1_search_devices(struct w1_master *dev, u8 search=
_type, w1_slave_found_cal
 {
 	dev->attempts++;
 	if (dev->bus_master->search)
-		dev->bus_master->search(dev->bus_master->data, search_type, cb);
+		dev->bus_master->search(dev->bus_master->data, dev,
+			search_type, cb);
 	else
 		w1_search(dev, search_type, cb);
 }
--=20
1.4.4.4

--Bn2rw/3z4jIqBvZU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7ONSAI852cse6PARAhWWAJ9o2KzswFTFNRhqrz0/vXX+Z5/fbwCfVGTW
eOcmLaherPdVSCv3lABfh1Q=
=bzR3
-----END PGP SIGNATURE-----

--Bn2rw/3z4jIqBvZU--
