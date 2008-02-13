Return-Path: <linux-kernel-owner+w=401wt.eu-S934478AbYBMVvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934478AbYBMVvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764674AbYBMVbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:31:52 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47584 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762457AbYBMVbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:31:32 -0500
Date: Wed, 13 Feb 2008 23:31:15 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Dominik Brodowski <linux@brodo.de>
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] the long overdue pcmcia_ioctl.c removal
Message-ID: <20080213213115.GW3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcmcia_ioctl.c was scheduled for removal in 2005, and it has a 
deprecation printk() since 2005 (sic).

This patch contains the long overdue removal and the cleanups that are 
now possible.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 Documentation/feature-removal-schedule.txt |   17 
 drivers/pcmcia/Kconfig                     |   14 
 drivers/pcmcia/Makefile                    |    1 
 drivers/pcmcia/cs.c                        |   17 
 drivers/pcmcia/cs_internal.h               |    3 
 drivers/pcmcia/ds.c                        |   28 
 drivers/pcmcia/ds_internal.h               |   17 
 drivers/pcmcia/pcmcia_ioctl.c              |  806 ---------------------
 drivers/pcmcia/pcmcia_resource.c           |   15 
 drivers/pcmcia/rsrc_mgr.c                  |   80 --
 include/pcmcia/cs.h                        |    1 
 include/pcmcia/ds.h                        |   85 --
 include/pcmcia/ss.h                        |    7 
 13 files changed, 16 insertions(+), 1075 deletions(-)

25f87c367a7b15e5b9138bac2d5c35f7be0a1144 diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 7279595..4637bab 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -47,23 +47,6 @@ Who:	Mauro Carvalho Chehab <mchehab@infradead.org>
 
 ---------------------------
 
-What:	PCMCIA control ioctl (needed for pcmcia-cs [cardmgr, cardctl])
-When:	November 2005
-Files:	drivers/pcmcia/: pcmcia_ioctl.c
-Why:	With the 16-bit PCMCIA subsystem now behaving (almost) like a
-	normal hotpluggable bus, and with it using the default kernel
-	infrastructure (hotplug, driver core, sysfs) keeping the PCMCIA
-	control ioctl needed by cardmgr and cardctl from pcmcia-cs is
-	unnecessary, and makes further cleanups and integration of the
-	PCMCIA subsystem into the Linux kernel device driver model more
-	difficult. The features provided by cardmgr and cardctl are either
-	handled by the kernel itself now or are available in the new
-	pcmciautils package available at
-	http://kernel.org/pub/linux/utils/kernel/pcmcia/
-Who:	Dominik Brodowski <linux@brodo.de>
-
----------------------------
-
 What:	sys_sysctl
 When:	September 2010
 Option: CONFIG_SYSCTL_SYSCALL
diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index 8b22281..61f490d 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -68,20 +68,6 @@ config PCMCIA_LOAD_CIS
 
 	  If unsure, say Y.
 
-config PCMCIA_IOCTL
-	bool "PCMCIA control ioctl (obsolete)"
-	depends on PCMCIA
-	default y
-	help
-	  If you say Y here, the deprecated ioctl interface to the PCMCIA
-	  subsystem will be built. It is needed by cardmgr and cardctl
-	  (pcmcia-cs) to function properly.
-
-	  You should use the new pcmciautils package instead (see
-	  <file:Documentation/Changes> for location and details).
-
-	  If unsure, say Y.
-
 config CARDBUS
 	bool "32-bit CardBus support"	
 	depends on PCI
diff --git a/drivers/pcmcia/Makefile b/drivers/pcmcia/Makefile
index 6f6478b..717802b 100644
--- a/drivers/pcmcia/Makefile
+++ b/drivers/pcmcia/Makefile
@@ -11,7 +11,6 @@ pcmcia_core-$(CONFIG_CARDBUS)			+= cardbus.o
 obj-$(CONFIG_PCCARD)				+= pcmcia_core.o
 
 pcmcia-y					+= ds.o pcmcia_resource.o
-pcmcia-$(CONFIG_PCMCIA_IOCTL)			+= pcmcia_ioctl.o
 obj-$(CONFIG_PCMCIA)				+= pcmcia.o
 
 obj-$(CONFIG_PCCARD_NONSTATIC)			+= rsrc_nonstatic.o
diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
index 56230db..4ff2715 100644
--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -296,23 +296,6 @@ void pcmcia_unregister_socket(struct pcmcia_socket *socket)
 EXPORT_SYMBOL(pcmcia_unregister_socket);
 
 
-struct pcmcia_socket * pcmcia_get_socket_by_nr(unsigned int nr)
-{
-	struct pcmcia_socket *s;
-
-	down_read(&pcmcia_socket_list_rwsem);
-	list_for_each_entry(s, &pcmcia_socket_list, socket_list)
-		if (s->sock == nr) {
-			up_read(&pcmcia_socket_list_rwsem);
-			return s;
-		}
-	up_read(&pcmcia_socket_list_rwsem);
-
-	return NULL;
-
-}
-EXPORT_SYMBOL(pcmcia_get_socket_by_nr);
-
 /*
  * The central event handler.  Send_event() sends an event to the
  * 16-bit subsystem, which then calls the relevant device drivers.
diff --git a/drivers/pcmcia/cs_internal.h b/drivers/pcmcia/cs_internal.h
index 9fa207e..9c6ccb4 100644
--- a/drivers/pcmcia/cs_internal.h
+++ b/drivers/pcmcia/cs_internal.h
@@ -126,10 +126,7 @@ extern struct class_interface pccard_sysfs_interface;
 /* In cs.c */
 extern struct rw_semaphore pcmcia_socket_list_rwsem;
 extern struct list_head pcmcia_socket_list;
-int pcmcia_get_window(struct pcmcia_socket *s, window_handle_t *handle, int idx, win_req_t *req);
-int pccard_get_configuration_info(struct pcmcia_socket *s, struct pcmcia_device *p_dev, config_info_t *config);
 int pccard_reset_card(struct pcmcia_socket *skt);
-int pccard_get_status(struct pcmcia_socket *s, struct pcmcia_device *p_dev, cs_status_t *status);
 
 
 struct pcmcia_callback{
diff --git a/drivers/pcmcia/ds.c b/drivers/pcmcia/ds.c
index 5a85871..4128a6e 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -56,7 +56,7 @@ module_param_named(pc_debug, ds_pc_debug, int, 0644);
 #define ds_dbg(lvl, fmt, arg...) do { } while (0)
 #endif
 
-spinlock_t pcmcia_dev_list_lock;
+static spinlock_t pcmcia_dev_list_lock;
 
 /*====================================================================*/
 
@@ -367,7 +367,7 @@ EXPORT_SYMBOL(pcmcia_unregister_driver);
 
 /* pcmcia_device handling */
 
-struct pcmcia_device * pcmcia_get_dev(struct pcmcia_device *p_dev)
+static struct pcmcia_device * pcmcia_get_dev(struct pcmcia_device *p_dev)
 {
 	struct device *tmp_dev;
 	tmp_dev = get_device(&p_dev->dev);
@@ -376,7 +376,7 @@ struct pcmcia_device * pcmcia_get_dev(struct pcmcia_device *p_dev)
 	return to_pcmcia_dev(tmp_dev);
 }
 
-void pcmcia_put_dev(struct pcmcia_device *p_dev)
+static void pcmcia_put_dev(struct pcmcia_device *p_dev)
 {
 	if (p_dev)
 		put_device(&p_dev->dev);
@@ -643,7 +643,8 @@ static int pcmcia_device_query(struct pcmcia_device *p_dev)
  */
 static DEFINE_MUTEX(device_add_lock);
 
-struct pcmcia_device * pcmcia_device_add(struct pcmcia_socket *s, unsigned int function)
+static struct pcmcia_device * pcmcia_device_add(struct pcmcia_socket *s,
+						unsigned int function)
 {
 	struct pcmcia_device *p_dev, *tmp_dev;
 	unsigned long flags;
@@ -1045,15 +1046,6 @@ static int pcmcia_bus_match(struct device * dev, struct device_driver * drv) {
 	}
 	spin_unlock(&p_drv->dynids.lock);
 
-#ifdef CONFIG_PCMCIA_IOCTL
-	/* matching by cardmgr */
-	if (p_dev->cardmgr == p_drv) {
-		ds_dbg(0, "cardmgr matched %s to %s\n", dev->bus_id,
-		       drv->name);
-		return 1;
-	}
-#endif
-
 	while (did && did->match_flags) {
 		ds_dbg(3, "trying to match %s to %s\n", dev->bus_id,
 		       drv->name);
@@ -1400,13 +1392,11 @@ static int ds_event(struct pcmcia_socket *skt, event_t event, int priority)
 	case CS_EVENT_CARD_REMOVAL:
 		s->pcmcia_state.present = 0;
 		pcmcia_card_remove(skt, NULL);
-		handle_event(skt, event);
 		break;
 
 	case CS_EVENT_CARD_INSERTION:
 		s->pcmcia_state.present = 1;
 		pcmcia_card_add(skt);
-		handle_event(skt, event);
 		break;
 
 	case CS_EVENT_EJECTION_REQUEST:
@@ -1417,7 +1407,6 @@ static int ds_event(struct pcmcia_socket *skt, event_t event, int priority)
 	case CS_EVENT_RESET_PHYSICAL:
 	case CS_EVENT_CARD_RESET:
 	default:
-		handle_event(skt, event);
 		break;
     }
 
@@ -1479,9 +1468,6 @@ static int __devinit pcmcia_bus_add_socket(struct device *dev,
 	 */
 	msleep(250);
 
-#ifdef CONFIG_PCMCIA_IOCTL
-	init_waitqueue_head(&socket->queue);
-#endif
 	INIT_LIST_HEAD(&socket->devices_list);
 	INIT_WORK(&socket->device_add, pcmcia_delayed_add_device);
 	memset(&socket->pcmcia_state, 0, sizeof(u8));
@@ -1558,8 +1544,6 @@ static int __init init_pcmcia_bus(void)
 		return ret;
 	}
 
-	pcmcia_setup_ioctl();
-
 	return 0;
 }
 fs_initcall(init_pcmcia_bus); /* one level after subsys_initcall so that 
@@ -1568,8 +1552,6 @@ fs_initcall(init_pcmcia_bus); /* one level after subsys_initcall so that
 
 static void __exit exit_pcmcia_bus(void)
 {
-	pcmcia_cleanup_ioctl();
-
 	class_interface_unregister(&pcmcia_bus_interface);
 
 	bus_unregister(&pcmcia_bus_type);
diff --git a/drivers/pcmcia/ds_internal.h b/drivers/pcmcia/ds_internal.h
index 3a2b25e..921c659 100644
--- a/drivers/pcmcia/ds_internal.h
+++ b/drivers/pcmcia/ds_internal.h
@@ -1,23 +1,6 @@
 /* ds_internal.h - internal header for 16-bit PCMCIA devices management */
 
-extern spinlock_t pcmcia_dev_list_lock;
 extern struct bus_type pcmcia_bus_type;
 
-extern struct pcmcia_device * pcmcia_get_dev(struct pcmcia_device *p_dev);
-extern void pcmcia_put_dev(struct pcmcia_device *p_dev);
-
-struct pcmcia_device * pcmcia_device_add(struct pcmcia_socket *s, unsigned int function);
-
 extern int pcmcia_release_configuration(struct pcmcia_device *p_dev);
 
-#ifdef CONFIG_PCMCIA_IOCTL
-extern void __init pcmcia_setup_ioctl(void);
-extern void __exit pcmcia_cleanup_ioctl(void);
-extern void handle_event(struct pcmcia_socket *s, event_t event);
-extern int handle_request(struct pcmcia_socket *s, event_t event);
-#else
-static inline void __init pcmcia_setup_ioctl(void) { return; }
-static inline void __exit pcmcia_cleanup_ioctl(void) { return; }
-static inline void handle_event(struct pcmcia_socket *s, event_t event) { return; }
-static inline int handle_request(struct pcmcia_socket *s, event_t event) { return CS_SUCCESS; }
-#endif
diff --git a/drivers/pcmcia/pcmcia_ioctl.c b/drivers/pcmcia/pcmcia_ioctl.c
deleted file mode 100644
index 27523c5..0000000
--- a/drivers/pcmcia/pcmcia_ioctl.c
+++ /dev/null
@@ -1,806 +0,0 @@
-/*
- * pcmcia_ioctl.c -- ioctl interface for cardmgr and cardctl
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * The initial developer of the original code is David A. Hinds
- * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
- * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
- *
- * (C) 1999		David A. Hinds
- * (C) 2003 - 2004	Dominik Brodowski
- */
-
-/*
- * This file will go away soon.
- */
-
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/major.h>
-#include <linux/errno.h>
-#include <linux/ioctl.h>
-#include <linux/proc_fs.h>
-#include <linux/poll.h>
-#include <linux/pci.h>
-#include <linux/workqueue.h>
-
-#define IN_CARD_SERVICES
-#include <pcmcia/cs_types.h>
-#include <pcmcia/cs.h>
-#include <pcmcia/cistpl.h>
-#include <pcmcia/ds.h>
-#include <pcmcia/ss.h>
-
-#include "cs_internal.h"
-#include "ds_internal.h"
-
-static int major_dev = -1;
-
-
-/* Device user information */
-#define MAX_EVENTS	32
-#define USER_MAGIC	0x7ea4
-#define CHECK_USER(u) \
-    (((u) == NULL) || ((u)->user_magic != USER_MAGIC))
-
-typedef struct user_info_t {
-	u_int			user_magic;
-	int			event_head, event_tail;
-	event_t			event[MAX_EVENTS];
-	struct user_info_t	*next;
-	struct pcmcia_socket	*socket;
-} user_info_t;
-
-
-#ifdef DEBUG
-extern int ds_pc_debug;
-
-#define ds_dbg(lvl, fmt, arg...) do {		\
-	if (ds_pc_debug >= lvl)				\
-		printk(KERN_DEBUG "ds: " fmt , ## arg);		\
-} while (0)
-#else
-#define ds_dbg(lvl, fmt, arg...) do { } while (0)
-#endif
-
-static struct pcmcia_device *get_pcmcia_device(struct pcmcia_socket *s,
-						unsigned int function)
-{
-	struct pcmcia_device *p_dev = NULL;
-	unsigned long flags;
-
-	spin_lock_irqsave(&pcmcia_dev_list_lock, flags);
-	list_for_each_entry(p_dev, &s->devices_list, socket_device_list) {
-		if (p_dev->func == function) {
-			spin_unlock_irqrestore(&pcmcia_dev_list_lock, flags);
-			return pcmcia_get_dev(p_dev);
-		}
-	}
-	spin_unlock_irqrestore(&pcmcia_dev_list_lock, flags);
-	return NULL;
-}
-
-/* backwards-compatible accessing of driver --- by name! */
-
-static struct pcmcia_driver *get_pcmcia_driver(dev_info_t *dev_info)
-{
-	struct device_driver *drv;
-	struct pcmcia_driver *p_drv;
-
-	drv = driver_find((char *) dev_info, &pcmcia_bus_type);
-	if (!drv)
-		return NULL;
-
-	p_drv = container_of(drv, struct pcmcia_driver, drv);
-
-	return (p_drv);
-}
-
-
-#ifdef CONFIG_PROC_FS
-static struct proc_dir_entry *proc_pccard = NULL;
-
-static int proc_read_drivers_callback(struct device_driver *driver, void *d)
-{
-	char **p = d;
-	struct pcmcia_driver *p_drv = container_of(driver,
-						   struct pcmcia_driver, drv);
-
-	*p += sprintf(*p, "%-24.24s 1 %d\n", p_drv->drv.name,
-#ifdef CONFIG_MODULE_UNLOAD
-		      (p_drv->owner) ? module_refcount(p_drv->owner) : 1
-#else
-		      1
-#endif
-	);
-	d = (void *) p;
-
-	return 0;
-}
-
-static int proc_read_drivers(char *buf, char **start, off_t pos,
-			     int count, int *eof, void *data)
-{
-	char *p = buf;
-	int rc;
-
-	rc = bus_for_each_drv(&pcmcia_bus_type, NULL,
-			      (void *) &p, proc_read_drivers_callback);
-	if (rc < 0)
-		return rc;
-
-	return (p - buf);
-}
-#endif
-
-/*======================================================================
-
-    These manage a ring buffer of events pending for one user process
-
-======================================================================*/
-
-
-static int queue_empty(user_info_t *user)
-{
-    return (user->event_head == user->event_tail);
-}
-
-static event_t get_queued_event(user_info_t *user)
-{
-    user->event_tail = (user->event_tail+1) % MAX_EVENTS;
-    return user->event[user->event_tail];
-}
-
-static void queue_event(user_info_t *user, event_t event)
-{
-    user->event_head = (user->event_head+1) % MAX_EVENTS;
-    if (user->event_head == user->event_tail)
-	user->event_tail = (user->event_tail+1) % MAX_EVENTS;
-    user->event[user->event_head] = event;
-}
-
-void handle_event(struct pcmcia_socket *s, event_t event)
-{
-    user_info_t *user;
-    for (user = s->user; user; user = user->next)
-	queue_event(user, event);
-    wake_up_interruptible(&s->queue);
-}
-
-
-/*======================================================================
-
-    bind_request() and bind_device() are merged by now. Register_client()
-    is called right at the end of bind_request(), during the driver's
-    ->attach() call. Individual descriptions:
-
-    bind_request() connects a socket to a particular client driver.
-    It looks up the specified device ID in the list of registered
-    drivers, binds it to the socket, and tries to create an instance
-    of the device.  unbind_request() deletes a driver instance.
-
-    Bind_device() associates a device driver with a particular socket.
-    It is normally called by Driver Services after it has identified
-    a newly inserted card.  An instance of that driver will then be
-    eligible to register as a client of this socket.
-
-    Register_client() uses the dev_info_t handle to match the
-    caller with a socket.  The driver must have already been bound
-    to a socket with bind_device() -- in fact, bind_device()
-    allocates the client structure that will be used.
-
-======================================================================*/
-
-static int bind_request(struct pcmcia_socket *s, bind_info_t *bind_info)
-{
-	struct pcmcia_driver *p_drv;
-	struct pcmcia_device *p_dev;
-	int ret = 0;
-	unsigned long flags;
-
-	s = pcmcia_get_socket(s);
-	if (!s)
-		return -EINVAL;
-
-	ds_dbg(2, "bind_request(%d, '%s')\n", s->sock,
-	       (char *)bind_info->dev_info);
-
-	p_drv = get_pcmcia_driver(&bind_info->dev_info);
-	if (!p_drv) {
-		ret = -EINVAL;
-		goto err_put;
-	}
-
-	if (!try_module_get(p_drv->owner)) {
-		ret = -EINVAL;
-		goto err_put_driver;
-	}
-
-	spin_lock_irqsave(&pcmcia_dev_list_lock, flags);
-        list_for_each_entry(p_dev, &s->devices_list, socket_device_list) {
-		if (p_dev->func == bind_info->function) {
-			if ((p_dev->dev.driver == &p_drv->drv)) {
-				if (p_dev->cardmgr) {
-					/* if there's already a device
-					 * registered, and it was registered
-					 * by userspace before, we need to
-					 * return the "instance". */
-					spin_unlock_irqrestore(&pcmcia_dev_list_lock, flags);
-					bind_info->instance = p_dev;
-					ret = -EBUSY;
-					goto err_put_module;
-				} else {
-					/* the correct driver managed to bind
-					 * itself magically to the correct
-					 * device. */
-					spin_unlock_irqrestore(&pcmcia_dev_list_lock, flags);
-					p_dev->cardmgr = p_drv;
-					ret = 0;
-					goto err_put_module;
-				}
-			} else if (!p_dev->dev.driver) {
-				/* there's already a device available where
-				 * no device has been bound to yet. So we don't
-				 * need to register a device! */
-				spin_unlock_irqrestore(&pcmcia_dev_list_lock, flags);
-				goto rescan;
-			}
-		}
-	}
-	spin_unlock_irqrestore(&pcmcia_dev_list_lock, flags);
-
-	p_dev = pcmcia_device_add(s, bind_info->function);
-	if (!p_dev) {
-		ret = -EIO;
-		goto err_put_module;
-	}
-
-rescan:
-	p_dev->cardmgr = p_drv;
-
-	/* if a driver is already running, we can abort */
-	if (p_dev->dev.driver)
-		goto err_put_module;
-
-	/*
-	 * Prevent this racing with a card insertion.
-	 */
-	mutex_lock(&s->skt_mutex);
-	ret = bus_rescan_devices(&pcmcia_bus_type);
-	mutex_unlock(&s->skt_mutex);
-	if (ret)
-		goto err_put_module;
-
-	/* check whether the driver indeed matched. I don't care if this
-	 * is racy or not, because it can only happen on cardmgr access
-	 * paths...
-	 */
-	if (!(p_dev->dev.driver == &p_drv->drv))
-		p_dev->cardmgr = NULL;
-
- err_put_module:
-	module_put(p_drv->owner);
- err_put_driver:
-	put_driver(&p_drv->drv);
- err_put:
-	pcmcia_put_socket(s);
-
-	return (ret);
-} /* bind_request */
-
-#ifdef CONFIG_CARDBUS
-
-static struct pci_bus *pcmcia_lookup_bus(struct pcmcia_socket *s)
-{
-	if (!s || !(s->state & SOCKET_CARDBUS))
-		return NULL;
-
-	return s->cb_dev->subordinate;
-}
-#endif
-
-static int get_device_info(struct pcmcia_socket *s, bind_info_t *bind_info, int first)
-{
-	dev_node_t *node;
-	struct pcmcia_device *p_dev;
-	struct pcmcia_driver *p_drv;
-	unsigned long flags;
-	int ret = 0;
-
-#ifdef CONFIG_CARDBUS
-	/*
-	 * Some unbelievably ugly code to associate the PCI cardbus
-	 * device and its driver with the PCMCIA "bind" information.
-	 */
-	{
-		struct pci_bus *bus;
-
-		bus = pcmcia_lookup_bus(s);
-		if (bus) {
-			struct list_head *list;
-			struct pci_dev *dev = NULL;
-
-			list = bus->devices.next;
-			while (list != &bus->devices) {
-				struct pci_dev *pdev = pci_dev_b(list);
-				list = list->next;
-
-				if (first) {
-					dev = pdev;
-					break;
-				}
-
-				/* Try to handle "next" here some way? */
-			}
-			if (dev && dev->driver) {
-				strlcpy(bind_info->name, dev->driver->name, DEV_NAME_LEN);
-				bind_info->major = 0;
-				bind_info->minor = 0;
-				bind_info->next = NULL;
-				return 0;
-			}
-		}
-	}
-#endif
-
-	spin_lock_irqsave(&pcmcia_dev_list_lock, flags);
-	list_for_each_entry(p_dev, &s->devices_list, socket_device_list) {
-		if (p_dev->func == bind_info->function) {
-			p_dev = pcmcia_get_dev(p_dev);
-			if (!p_dev)
-				continue;
-			goto found;
-		}
-	}
-	spin_unlock_irqrestore(&pcmcia_dev_list_lock, flags);
-	return -ENODEV;
-
- found:
-	spin_unlock_irqrestore(&pcmcia_dev_list_lock, flags);
-
-	p_drv = to_pcmcia_drv(p_dev->dev.driver);
-	if (p_drv && !p_dev->_locked) {
-		ret = -EAGAIN;
-		goto err_put;
-	}
-
-	if (first)
-		node = p_dev->dev_node;
-	else
-		for (node = p_dev->dev_node; node; node = node->next)
-			if (node == bind_info->next)
-				break;
-	if (!node) {
-		ret = -ENODEV;
-		goto err_put;
-	}
-
-	strlcpy(bind_info->name, node->dev_name, DEV_NAME_LEN);
-	bind_info->major = node->major;
-	bind_info->minor = node->minor;
-	bind_info->next = node->next;
-
- err_put:
-	pcmcia_put_dev(p_dev);
-	return (ret);
-} /* get_device_info */
-
-
-static int ds_open(struct inode *inode, struct file *file)
-{
-    socket_t i = iminor(inode);
-    struct pcmcia_socket *s;
-    user_info_t *user;
-    static int warning_printed = 0;
-
-    ds_dbg(0, "ds_open(socket %d)\n", i);
-
-    s = pcmcia_get_socket_by_nr(i);
-    if (!s)
-	    return -ENODEV;
-    s = pcmcia_get_socket(s);
-    if (!s)
-	    return -ENODEV;
-
-    if ((file->f_flags & O_ACCMODE) != O_RDONLY) {
-	    if (s->pcmcia_state.busy) {
-		    pcmcia_put_socket(s);
-		    return -EBUSY;
-	    }
-	else
-	    s->pcmcia_state.busy = 1;
-    }
-
-    user = kmalloc(sizeof(user_info_t), GFP_KERNEL);
-    if (!user) {
-	    pcmcia_put_socket(s);
-	    return -ENOMEM;
-    }
-    user->event_tail = user->event_head = 0;
-    user->next = s->user;
-    user->user_magic = USER_MAGIC;
-    user->socket = s;
-    s->user = user;
-    file->private_data = user;
-
-    if (!warning_printed) {
-	    printk(KERN_INFO "pcmcia: Detected deprecated PCMCIA ioctl "
-			"usage from process: %s.\n", current->comm);
-	    printk(KERN_INFO "pcmcia: This interface will soon be removed from "
-			"the kernel; please expect breakage unless you upgrade "
-			"to new tools.\n");
-	    printk(KERN_INFO "pcmcia: see http://www.kernel.org/pub/linux/"
-			"utils/kernel/pcmcia/pcmcia.html for details.\n");
-	    warning_printed = 1;
-    }
-
-    if (s->pcmcia_state.present)
-	queue_event(user, CS_EVENT_CARD_INSERTION);
-    return 0;
-} /* ds_open */
-
-/*====================================================================*/
-
-static int ds_release(struct inode *inode, struct file *file)
-{
-    struct pcmcia_socket *s;
-    user_info_t *user, **link;
-
-    ds_dbg(0, "ds_release(socket %d)\n", iminor(inode));
-
-    user = file->private_data;
-    if (CHECK_USER(user))
-	goto out;
-
-    s = user->socket;
-
-    /* Unlink user data structure */
-    if ((file->f_flags & O_ACCMODE) != O_RDONLY) {
-	s->pcmcia_state.busy = 0;
-    }
-    file->private_data = NULL;
-    for (link = &s->user; *link; link = &(*link)->next)
-	if (*link == user) break;
-    if (link == NULL)
-	goto out;
-    *link = user->next;
-    user->user_magic = 0;
-    kfree(user);
-    pcmcia_put_socket(s);
-out:
-    return 0;
-} /* ds_release */
-
-/*====================================================================*/
-
-static ssize_t ds_read(struct file *file, char __user *buf,
-		       size_t count, loff_t *ppos)
-{
-    struct pcmcia_socket *s;
-    user_info_t *user;
-    int ret;
-
-    ds_dbg(2, "ds_read(socket %d)\n", iminor(file->f_path.dentry->d_inode));
-
-    if (count < 4)
-	return -EINVAL;
-
-    user = file->private_data;
-    if (CHECK_USER(user))
-	return -EIO;
-
-    s = user->socket;
-    if (s->pcmcia_state.dead)
-        return -EIO;
-
-    ret = wait_event_interruptible(s->queue, !queue_empty(user));
-    if (ret == 0)
-	ret = put_user(get_queued_event(user), (int __user *)buf) ? -EFAULT : 4;
-
-    return ret;
-} /* ds_read */
-
-/*====================================================================*/
-
-static ssize_t ds_write(struct file *file, const char __user *buf,
-			size_t count, loff_t *ppos)
-{
-    ds_dbg(2, "ds_write(socket %d)\n", iminor(file->f_path.dentry->d_inode));
-
-    if (count != 4)
-	return -EINVAL;
-    if ((file->f_flags & O_ACCMODE) == O_RDONLY)
-	return -EBADF;
-
-    return -EIO;
-} /* ds_write */
-
-/*====================================================================*/
-
-/* No kernel lock - fine */
-static u_int ds_poll(struct file *file, poll_table *wait)
-{
-    struct pcmcia_socket *s;
-    user_info_t *user;
-
-    ds_dbg(2, "ds_poll(socket %d)\n", iminor(file->f_path.dentry->d_inode));
-
-    user = file->private_data;
-    if (CHECK_USER(user))
-	return POLLERR;
-    s = user->socket;
-    /*
-     * We don't check for a dead socket here since that
-     * will send cardmgr into an endless spin.
-     */
-    poll_wait(file, &s->queue, wait);
-    if (!queue_empty(user))
-	return POLLIN | POLLRDNORM;
-    return 0;
-} /* ds_poll */
-
-/*====================================================================*/
-
-extern int pcmcia_adjust_resource_info(adjust_t *adj);
-
-static int ds_ioctl(struct inode * inode, struct file * file,
-		    u_int cmd, u_long arg)
-{
-    struct pcmcia_socket *s;
-    void __user *uarg = (char __user *)arg;
-    u_int size;
-    int ret, err;
-    ds_ioctl_arg_t *buf;
-    user_info_t *user;
-
-    ds_dbg(2, "ds_ioctl(socket %d, %#x, %#lx)\n", iminor(inode), cmd, arg);
-
-    user = file->private_data;
-    if (CHECK_USER(user))
-	return -EIO;
-
-    s = user->socket;
-    if (s->pcmcia_state.dead)
-        return -EIO;
-
-    size = (cmd & IOCSIZE_MASK) >> IOCSIZE_SHIFT;
-    if (size > sizeof(ds_ioctl_arg_t)) return -EINVAL;
-
-    /* Permission check */
-    if (!(cmd & IOC_OUT) && !capable(CAP_SYS_ADMIN))
-	return -EPERM;
-
-    if (cmd & IOC_IN) {
-	if (!access_ok(VERIFY_READ, uarg, size)) {
-	    ds_dbg(3, "ds_ioctl(): verify_read = %d\n", -EFAULT);
-	    return -EFAULT;
-	}
-    }
-    if (cmd & IOC_OUT) {
-	if (!access_ok(VERIFY_WRITE, uarg, size)) {
-	    ds_dbg(3, "ds_ioctl(): verify_write = %d\n", -EFAULT);
-	    return -EFAULT;
-	}
-    }
-    buf = kmalloc(sizeof(ds_ioctl_arg_t), GFP_KERNEL);
-    if (!buf)
-	return -ENOMEM;
-
-    err = ret = 0;
-
-    if (cmd & IOC_IN) {
-	if (__copy_from_user((char *)buf, uarg, size)) {
-	    err = -EFAULT;
-	    goto free_out;
-	}
-    }
-
-    switch (cmd) {
-    case DS_ADJUST_RESOURCE_INFO:
-	ret = pcmcia_adjust_resource_info(&buf->adjust);
-	break;
-    case DS_GET_CONFIGURATION_INFO:
-	if (buf->config.Function &&
-	   (buf->config.Function >= s->functions))
-	    ret = CS_BAD_ARGS;
-	else {
-	    struct pcmcia_device *p_dev = get_pcmcia_device(s, buf->config.Function);
-	    ret = pccard_get_configuration_info(s, p_dev, &buf->config);
-	    pcmcia_put_dev(p_dev);
-	}
-	break;
-    case DS_GET_FIRST_TUPLE:
-	mutex_lock(&s->skt_mutex);
-	pcmcia_validate_mem(s);
-	mutex_unlock(&s->skt_mutex);
-	ret = pccard_get_first_tuple(s, BIND_FN_ALL, &buf->tuple);
-	break;
-    case DS_GET_NEXT_TUPLE:
-	ret = pccard_get_next_tuple(s, BIND_FN_ALL, &buf->tuple);
-	break;
-    case DS_GET_TUPLE_DATA:
-	buf->tuple.TupleData = buf->tuple_parse.data;
-	buf->tuple.TupleDataMax = sizeof(buf->tuple_parse.data);
-	ret = pccard_get_tuple_data(s, &buf->tuple);
-	break;
-    case DS_PARSE_TUPLE:
-	buf->tuple.TupleData = buf->tuple_parse.data;
-	ret = pccard_parse_tuple(&buf->tuple, &buf->tuple_parse.parse);
-	break;
-    case DS_RESET_CARD:
-	ret = pccard_reset_card(s);
-	break;
-    case DS_GET_STATUS:
-	    if (buf->status.Function &&
-		(buf->status.Function >= s->functions))
-		    ret = CS_BAD_ARGS;
-	    else {
-		    struct pcmcia_device *p_dev = get_pcmcia_device(s, buf->status.Function);
-		    ret = pccard_get_status(s, p_dev, &buf->status);
-		    pcmcia_put_dev(p_dev);
-	    }
-	    break;
-    case DS_VALIDATE_CIS:
-	mutex_lock(&s->skt_mutex);
-	pcmcia_validate_mem(s);
-	mutex_unlock(&s->skt_mutex);
-	ret = pccard_validate_cis(s, BIND_FN_ALL, &buf->cisinfo);
-	break;
-    case DS_SUSPEND_CARD:
-	ret = pcmcia_suspend_card(s);
-	break;
-    case DS_RESUME_CARD:
-	ret = pcmcia_resume_card(s);
-	break;
-    case DS_EJECT_CARD:
-	err = pcmcia_eject_card(s);
-	break;
-    case DS_INSERT_CARD:
-	err = pcmcia_insert_card(s);
-	break;
-    case DS_ACCESS_CONFIGURATION_REGISTER:
-	if ((buf->conf_reg.Action == CS_WRITE) && !capable(CAP_SYS_ADMIN)) {
-	    err = -EPERM;
-	    goto free_out;
-	}
-
-	ret = CS_BAD_ARGS;
-
-	if (!(buf->conf_reg.Function &&
-	     (buf->conf_reg.Function >= s->functions))) {
-		struct pcmcia_device *p_dev = get_pcmcia_device(s, buf->conf_reg.Function);
-		if (p_dev) {
-			ret = pcmcia_access_configuration_register(p_dev, &buf->conf_reg);
-			pcmcia_put_dev(p_dev);
-		}
-	}
-	break;
-    case DS_GET_FIRST_REGION:
-    case DS_GET_NEXT_REGION:
-    case DS_BIND_MTD:
-	if (!capable(CAP_SYS_ADMIN)) {
-		err = -EPERM;
-		goto free_out;
-	} else {
-		static int printed = 0;
-		if (!printed) {
-			printk(KERN_WARNING "2.6. kernels use pcmciamtd instead of memory_cs.c and do not require special\n");
-			printk(KERN_WARNING "MTD handling any more.\n");
-			printed++;
-		}
-	}
-	err = -EINVAL;
-	goto free_out;
-	break;
-    case DS_GET_FIRST_WINDOW:
-	ret = pcmcia_get_window(s, &buf->win_info.handle, 0,
-			&buf->win_info.window);
-	break;
-    case DS_GET_NEXT_WINDOW:
-	ret = pcmcia_get_window(s, &buf->win_info.handle,
-			buf->win_info.handle->index + 1, &buf->win_info.window);
-	break;
-    case DS_GET_MEM_PAGE:
-	ret = pcmcia_get_mem_page(buf->win_info.handle,
-			   &buf->win_info.map);
-	break;
-    case DS_REPLACE_CIS:
-	ret = pcmcia_replace_cis(s, &buf->cisdump);
-	break;
-    case DS_BIND_REQUEST:
-	if (!capable(CAP_SYS_ADMIN)) {
-		err = -EPERM;
-		goto free_out;
-	}
-	err = bind_request(s, &buf->bind_info);
-	break;
-    case DS_GET_DEVICE_INFO:
-	err = get_device_info(s, &buf->bind_info, 1);
-	break;
-    case DS_GET_NEXT_DEVICE:
-	err = get_device_info(s, &buf->bind_info, 0);
-	break;
-    case DS_UNBIND_REQUEST:
-	err = 0;
-	break;
-    default:
-	err = -EINVAL;
-    }
-
-    if ((err == 0) && (ret != CS_SUCCESS)) {
-	ds_dbg(2, "ds_ioctl: ret = %d\n", ret);
-	switch (ret) {
-	case CS_BAD_SOCKET: case CS_NO_CARD:
-	    err = -ENODEV; break;
-	case CS_BAD_ARGS: case CS_BAD_ATTRIBUTE: case CS_BAD_IRQ:
-	case CS_BAD_TUPLE:
-	    err = -EINVAL; break;
-	case CS_IN_USE:
-	    err = -EBUSY; break;
-	case CS_OUT_OF_RESOURCE:
-	    err = -ENOSPC; break;
-	case CS_NO_MORE_ITEMS:
-	    err = -ENODATA; break;
-	case CS_UNSUPPORTED_FUNCTION:
-	    err = -ENOSYS; break;
-	default:
-	    err = -EIO; break;
-	}
-    }
-
-    if (cmd & IOC_OUT) {
-        if (__copy_to_user(uarg, (char *)buf, size))
-            err = -EFAULT;
-    }
-
-free_out:
-    kfree(buf);
-    return err;
-} /* ds_ioctl */
-
-/*====================================================================*/
-
-static const struct file_operations ds_fops = {
-	.owner		= THIS_MODULE,
-	.open		= ds_open,
-	.release	= ds_release,
-	.ioctl		= ds_ioctl,
-	.read		= ds_read,
-	.write		= ds_write,
-	.poll		= ds_poll,
-};
-
-void __init pcmcia_setup_ioctl(void) {
-	int i;
-
-	/* Set up character device for user mode clients */
-	i = register_chrdev(0, "pcmcia", &ds_fops);
-	if (i < 0)
-		printk(KERN_NOTICE "unable to find a free device # for "
-		       "Driver Services (error=%d)\n", i);
-	else
-		major_dev = i;
-
-#ifdef CONFIG_PROC_FS
-	proc_pccard = proc_mkdir("pccard", proc_bus);
-	if (proc_pccard)
-		create_proc_read_entry("drivers",0,proc_pccard,proc_read_drivers,NULL);
-#endif
-}
-
-
-void __exit pcmcia_cleanup_ioctl(void) {
-#ifdef CONFIG_PROC_FS
-	if (proc_pccard) {
-		remove_proc_entry("drivers", proc_pccard);
-		remove_proc_entry("pccard", proc_bus);
-	}
-#endif
-	if (major_dev != -1)
-		unregister_chrdev(major_dev, "pcmcia");
-}
diff --git a/drivers/pcmcia/pcmcia_resource.c b/drivers/pcmcia/pcmcia_resource.c
index 1d128fb..03f770c 100644
--- a/drivers/pcmcia/pcmcia_resource.c
+++ b/drivers/pcmcia/pcmcia_resource.c
@@ -198,9 +198,9 @@ int pcmcia_access_configuration_register(struct pcmcia_device *p_dev,
 EXPORT_SYMBOL(pcmcia_access_configuration_register);
 
 
-int pccard_get_configuration_info(struct pcmcia_socket *s,
-				  struct pcmcia_device *p_dev,
-				  config_info_t *config)
+static int pccard_get_configuration_info(struct pcmcia_socket *s,
+					 struct pcmcia_device *p_dev,
+					 config_info_t *config)
 {
 	config_t *c;
 
@@ -277,6 +277,7 @@ int pcmcia_get_configuration_info(struct pcmcia_device *p_dev,
 EXPORT_SYMBOL(pcmcia_get_configuration_info);
 
 
+#if 0
 /** pcmcia_get_window
  */
 int pcmcia_get_window(struct pcmcia_socket *s, window_handle_t *handle,
@@ -309,6 +310,7 @@ int pcmcia_get_window(struct pcmcia_socket *s, window_handle_t *handle,
 	return CS_SUCCESS;
 } /* pcmcia_get_window */
 EXPORT_SYMBOL(pcmcia_get_window);
+#endif  /*  0  */
 
 
 /** pccard_get_status
@@ -317,8 +319,9 @@ EXPORT_SYMBOL(pcmcia_get_window);
  * SocketState yet: I haven't seen any point for it.
  */
 
-int pccard_get_status(struct pcmcia_socket *s, struct pcmcia_device *p_dev,
-		      cs_status_t *status)
+static int pccard_get_status(struct pcmcia_socket *s,
+			     struct pcmcia_device *p_dev,
+			     cs_status_t *status)
 {
 	config_t *c;
 	int val;
@@ -379,6 +382,7 @@ EXPORT_SYMBOL(pcmcia_get_status);
 
 
 
+#if 0
 /** pcmcia_get_mem_page
  *
  * Change the card address of an already open memory window.
@@ -392,6 +396,7 @@ int pcmcia_get_mem_page(window_handle_t win, memreq_t *req)
 	return CS_SUCCESS;
 } /* pcmcia_get_mem_page */
 EXPORT_SYMBOL(pcmcia_get_mem_page);
+#endif  /*  0  */
 
 
 int pcmcia_map_mem_page(window_handle_t win, memreq_t *req)
diff --git a/drivers/pcmcia/rsrc_mgr.c b/drivers/pcmcia/rsrc_mgr.c
index ce22262..96ea95d 100644
--- a/drivers/pcmcia/rsrc_mgr.c
+++ b/drivers/pcmcia/rsrc_mgr.c
@@ -21,86 +21,6 @@
 #include "cs_internal.h"
 
 
-#ifdef CONFIG_PCMCIA_IOCTL
-
-#ifdef CONFIG_PCMCIA_PROBE
-
-static int adjust_irq(struct pcmcia_socket *s, adjust_t *adj)
-{
-	int irq;
-	u32 mask;
-
-	irq = adj->resource.irq.IRQ;
-	if ((irq < 0) || (irq > 15))
-		return CS_BAD_IRQ;
-
-	if (adj->Action != REMOVE_MANAGED_RESOURCE)
-		return 0;
-
-	mask = 1 << irq;
-
-	if (!(s->irq_mask & mask))
-		return 0;
-
-	s->irq_mask &= ~mask;
-
-	return 0;
-}
-
-#else
-
-static inline int adjust_irq(struct pcmcia_socket *s, adjust_t *adj) {
-	return CS_SUCCESS;
-}
-
-#endif
-
-
-int pcmcia_adjust_resource_info(adjust_t *adj)
-{
-	struct pcmcia_socket *s;
-	int ret = CS_UNSUPPORTED_FUNCTION;
-	unsigned long flags;
-
-	down_read(&pcmcia_socket_list_rwsem);
-	list_for_each_entry(s, &pcmcia_socket_list, socket_list) {
-
-		if (adj->Resource == RES_IRQ)
-			ret = adjust_irq(s, adj);
-
-		else if (s->resource_ops->adjust_resource) {
-
-			/* you can't use the old interface if the new
-			 * one was used before */
-			spin_lock_irqsave(&s->lock, flags);
-			if ((s->resource_setup_new) &&
-			    !(s->resource_setup_old)) {
-				spin_unlock_irqrestore(&s->lock, flags);
-				continue;
-			} else if (!(s->resource_setup_old))
-				s->resource_setup_old = 1;
-			spin_unlock_irqrestore(&s->lock, flags);
-
-			ret = s->resource_ops->adjust_resource(s, adj);
-			if (!ret) {
-				/* as there's no way we know this is the
-				 * last call to adjust_resource_info, we
-				 * always need to assume this is the latest
-				 * one... */
-				spin_lock_irqsave(&s->lock, flags);
-				s->resource_setup_done = 1;
-				spin_unlock_irqrestore(&s->lock, flags);
-			}
-		}
-	}
-	up_read(&pcmcia_socket_list_rwsem);
-
-	return (ret);
-}
-EXPORT_SYMBOL(pcmcia_adjust_resource_info);
-
-#endif
-
 int pcmcia_validate_mem(struct pcmcia_socket *s)
 {
 	if (s->resource_ops->validate_mem)
diff --git a/include/pcmcia/cs.h b/include/pcmcia/cs.h
index 87a260e..d4007e9 100644
--- a/include/pcmcia/cs.h
+++ b/include/pcmcia/cs.h
@@ -376,7 +376,6 @@ int pcmcia_get_configuration_info(struct pcmcia_device *p_dev, config_info_t *co
 int pcmcia_get_first_window(window_handle_t *win, win_req_t *req);
 int pcmcia_get_next_window(window_handle_t *win, win_req_t *req);
 int pcmcia_get_status(struct pcmcia_device *p_dev, cs_status_t *status);
-int pcmcia_get_mem_page(window_handle_t win, memreq_t *req);
 int pcmcia_map_mem_page(window_handle_t win, memreq_t *req);
 int pcmcia_modify_configuration(struct pcmcia_device *p_dev, modconf_t *mod);
 int pcmcia_release_window(window_handle_t win);
diff --git a/include/pcmcia/ds.h b/include/pcmcia/ds.h
index f047a1f..d6e8932 100644
--- a/include/pcmcia/ds.h
+++ b/include/pcmcia/ds.h
@@ -16,86 +16,9 @@
 #ifndef _LINUX_DS_H
 #define _LINUX_DS_H
 
-#ifdef __KERNEL__
 #include <linux/mod_devicetable.h>
-#endif
-
-#include <pcmcia/bulkmem.h>
-#include <pcmcia/cs_types.h>
-#include <pcmcia/device_id.h>
-
-typedef struct tuple_parse_t {
-    tuple_t		tuple;
-    cisdata_t		data[255];
-    cisparse_t		parse;
-} tuple_parse_t;
-
-typedef struct win_info_t {
-    window_handle_t	handle;
-    win_req_t		window;
-    memreq_t		map;
-} win_info_t;
-    
-typedef struct bind_info_t {
-    dev_info_t		dev_info;
-    u_char		function;
-    struct pcmcia_device *instance;
-    char		name[DEV_NAME_LEN];
-    u_short		major, minor;
-    void		*next;
-} bind_info_t;
-
-typedef struct mtd_info_t {
-    dev_info_t		dev_info;
-    u_int		Attributes;
-    u_int		CardOffset;
-} mtd_info_t;
-
-typedef union ds_ioctl_arg_t {
-    adjust_t		adjust;
-    config_info_t	config;
-    tuple_t		tuple;
-    tuple_parse_t	tuple_parse;
-    client_req_t	client_req;
-    cs_status_t		status;
-    conf_reg_t		conf_reg;
-    cisinfo_t		cisinfo;
-    region_info_t	region;
-    bind_info_t		bind_info;
-    mtd_info_t		mtd_info;
-    win_info_t		win_info;
-    cisdump_t		cisdump;
-} ds_ioctl_arg_t;
-
-#define DS_ADJUST_RESOURCE_INFO		_IOWR('d', 2, adjust_t)
-#define DS_GET_CONFIGURATION_INFO	_IOWR('d', 3, config_info_t)
-#define DS_GET_FIRST_TUPLE		_IOWR('d', 4, tuple_t)
-#define DS_GET_NEXT_TUPLE		_IOWR('d', 5, tuple_t)
-#define DS_GET_TUPLE_DATA		_IOWR('d', 6, tuple_parse_t)
-#define DS_PARSE_TUPLE			_IOWR('d', 7, tuple_parse_t)
-#define DS_RESET_CARD			_IO  ('d', 8)
-#define DS_GET_STATUS			_IOWR('d', 9, cs_status_t)
-#define DS_ACCESS_CONFIGURATION_REGISTER _IOWR('d', 10, conf_reg_t)
-#define DS_VALIDATE_CIS			_IOR ('d', 11, cisinfo_t)
-#define DS_SUSPEND_CARD			_IO  ('d', 12)
-#define DS_RESUME_CARD			_IO  ('d', 13)
-#define DS_EJECT_CARD			_IO  ('d', 14)
-#define DS_INSERT_CARD			_IO  ('d', 15)
-#define DS_GET_FIRST_REGION		_IOWR('d', 16, region_info_t)
-#define DS_GET_NEXT_REGION		_IOWR('d', 17, region_info_t)
-#define DS_REPLACE_CIS			_IOWR('d', 18, cisdump_t)
-#define DS_GET_FIRST_WINDOW		_IOR ('d', 19, win_info_t)
-#define DS_GET_NEXT_WINDOW		_IOWR('d', 20, win_info_t)
-#define DS_GET_MEM_PAGE			_IOWR('d', 21, win_info_t)
-
-#define DS_BIND_REQUEST			_IOWR('d', 60, bind_info_t)
-#define DS_GET_DEVICE_INFO		_IOWR('d', 61, bind_info_t) 
-#define DS_GET_NEXT_DEVICE		_IOWR('d', 62, bind_info_t) 
-#define DS_UNBIND_REQUEST		_IOW ('d', 63, bind_info_t)
-#define DS_BIND_MTD			_IOWR('d', 64, mtd_info_t)
-
-#ifdef __KERNEL__
 #include <linux/device.h>
+#include <pcmcia/device_id.h>
 #include <pcmcia/ss.h>
 
 typedef struct dev_node_t {
@@ -187,11 +110,6 @@ struct pcmcia_device {
 	u64			dma_mask;
 	struct device		dev;
 
-#ifdef CONFIG_PCMCIA_IOCTL
-	/* device driver wanted by cardmgr */
-	struct pcmcia_driver *	cardmgr;
-#endif
-
 	/* data private to drivers */
 	void			*priv;
 };
@@ -204,5 +122,4 @@ struct pcmcia_device {
 /* error reporting */
 void cs_error(struct pcmcia_device *handle, int func, int ret);
 
-#endif /* __KERNEL__ */
 #endif /* _LINUX_DS_H */
diff --git a/include/pcmcia/ss.h b/include/pcmcia/ss.h
index f95dca0..8ca6a4d 100644
--- a/include/pcmcia/ss.h
+++ b/include/pcmcia/ss.h
@@ -271,10 +271,6 @@ struct pcmcia_socket {
 	struct work_struct		device_add;	/* for adding further pseudo-multifunction
 							 * devices */
 
-#ifdef CONFIG_PCMCIA_IOCTL
-	struct user_info_t		*user;
-	wait_queue_head_t		queue;
-#endif
 #endif
 
 	/* cardbus (32-bit) */
@@ -289,9 +285,6 @@ struct pcmcia_socket {
 
 };
 
-struct pcmcia_socket * pcmcia_get_socket_by_nr(unsigned int nr);
-
-
 
 extern void pcmcia_parse_events(struct pcmcia_socket *socket, unsigned int events);
 extern int pcmcia_register_socket(struct pcmcia_socket *socket);

