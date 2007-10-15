Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbXJOFGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbXJOFGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 01:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbXJOFF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 01:05:56 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:38309 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbXJOFFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 01:05:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=if8w4z12mRpSsnTbyattrObD7eI4tJ9knBKlVM8vMqnLad1efxKovJJKDJMDE9RHKpMh9vWtpfx6Cb15aDrsdrBWVmm6ReLdXV6zLbRLRyI7b7TGpiVB4j6+XD6Xm1SlhuIPl1y0GmZqdzBDWR3Bgl/tChkbM4vSaY+r7sceGec=
Message-ID: <4712F52D.2070405@gmail.com>
Date: Sun, 14 Oct 2007 23:05:49 -0600
From: Jim Cromie <jim.cromie@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Linux kernel <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: [ patch .24-rc0 1/5 ] SuperIO locks coordinator - add the module
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

01 - adds superio_locks module

User-drivers specify the sio-port characteristics they can support
device-ids, sio-port-addrs, enter & exit sequences, etc in 
a struct superio_search (in __devinit, preferably). 

superio_find() then searches existing slots/shared-reservations 
for a matching sio-port, and returns it if found. 
Otherwize it probes port-addrs, specified by find() user, 
and makes and returns a new reservation.

    superio_find()	finds and reserves the slot, 
			returned as ptr or null
    superio_release()	relinguishes the slot (ref-counted)

Once theyve got the reservation in struct superio * gate 
(as named in patches 2-5) they *may* use

    superio_lock(gate)
    superio_enter/exit(gate)
    superio_inb/w(gate, regaddr),
    superio_outb/w(gate, regaddr, val)

or they can do it themselves with inb/outb, by using gate->sioaddr, etc.

The API names (superio_find etc) were chosen to fit the idiom 
used in hwmon/*.c, patches 2-5 remove the per-user-driver
copies of the superio_*() fns.

I added the module to /drivers/hwmon, mostly cuz thats where
Ive used it - perhaps drivers/isa is better ?


Signed-off-by:  Jim Cromie <jim.cromie@gmail.com>
---
hwmon-superio-module
 drivers/hwmon/Kconfig         |    9 +
 drivers/hwmon/Makefile        |    1 
 drivers/hwmon/superio_locks.c |  235 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/superio-locks.h |  112 ++++++++++++++++++++
 4 files changed, 357 insertions(+)

diff -ruNp -X dontdiff -X exclude-diffs hwmon-fan-push-offset/drivers/hwmon/Kconfig hwmon-superio.old/drivers/hwmon/Kconfig
--- hwmon-fan-push-offset/drivers/hwmon/Kconfig	2007-10-14 13:00:24.000000000 -0600
+++ hwmon-superio.old/drivers/hwmon/Kconfig	2007-10-14 17:22:23.000000000 -0600
@@ -750,4 +765,13 @@ config HWMON_DEBUG_CHIP
 	  a problem with I2C support and want to see more of what is going
 	  on.
 
+config SUPERIO_LOCKS
+	tristate "Super-IO port sharing"
+	default n
+	help
+	  This module provides a shared reservation for use by drivers
+	  which need to share access to a multi-function device via
+	  its superio port, and which register that port.
+
 endif # HWMON
+
diff -ruNp -X dontdiff -X exclude-diffs hwmon-fan-push-offset/drivers/hwmon/Makefile hwmon-superio.old/drivers/hwmon/Makefile
--- hwmon-fan-push-offset/drivers/hwmon/Makefile	2007-10-14 13:00:24.000000000 -0600
+++ hwmon-superio.old/drivers/hwmon/Makefile	2007-10-14 17:22:23.000000000 -0600
@@ -72,3 +72,4 @@ ifeq ($(CONFIG_HWMON_DEBUG_CHIP),y)
 EXTRA_CFLAGS += -DDEBUG
 endif
 
+obj-$(CONFIG_SUPERIO_LOCKS)	+= superio_locks.o
diff -ruNp -X dontdiff -X exclude-diffs hwmon-fan-push-offset/drivers/hwmon/superio_locks.c hwmon-superio.old/drivers/hwmon/superio_locks.c
--- hwmon-fan-push-offset/drivers/hwmon/superio_locks.c	1969-12-31 17:00:00.000000000 -0700
+++ hwmon-superio.old/drivers/hwmon/superio_locks.c	2007-10-14 20:27:49.000000000 -0600
@@ -0,0 +1,235 @@
+
+#define DRVNAME "superio_locks"
+#define DEBUG 1
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/mutex.h>
+#include <linux/ioport.h>
+#include <linux/superio-locks.h>
+
+MODULE_AUTHOR("Jim Cromie <jim.cromie@gmail.com");
+MODULE_LICENSE("GPL");
+
+/*
+ * This module allows multiple driver modules to coordinate their use
+ * of a Super-IO port to control the multiple logical devices behind
+ * it.  Drivers will superio_find() their port, and 2 such modules
+ * will share a slot containing the lock.
+ */
+static int max_locks = 3;	/* 3 is enough for 90% uses */
+module_param(max_locks, int, 0);
+MODULE_PARM_DESC(max_locks,
+		 " Number of sio-lock clients to serve (default=3)");
+
+static int paranoid;
+module_param(paranoid, int, 0);
+MODULE_PARM_DESC(paranoid,
+		 " when true, fails if superio-port region is claimed");
+
+static struct superio *sio_locks;
+static struct mutex reservation_lock;
+
+#define SIO_DEVID_ADDR_STD 0x20
+#define SIO_LDN_ADDR_STD 0x07
+
+struct superio* superio_probe_reserve(const struct superio_search * const where,
+				      int cmd_addr, int want_devid)
+{
+	struct superio *gate;
+	u16 devid_addr = where->devid_addr;
+	u16 mydevid;
+	int slot, rc, i;
+
+	if (!devid_addr)
+		devid_addr = SIO_DEVID_ADDR_STD;
+
+
+	/* send superio-enter sequence for devices which need them */
+	for (i = 0; i < SEQ_SZ && where->enter_seq[i]; i++)
+		outb(where->enter_seq[i], cmd_addr);
+
+	outb(devid_addr, cmd_addr);
+
+	/* sanity check that cmd-reg remembers the val just written
+	rc = inb(cmd_addr);
+	if (rc != (devid_addr & 0xFF)) {
+		pr_debug("cmd-reg absent at %x, got %x\n", cmd_addr, rc);
+		return NULL;
+	}
+	*/
+	/* Read the device-id register(s), using cmd written above */
+	if (!where->devid_word) {
+		mydevid = inb(cmd_addr+1);
+	} else {
+		/* want 16 bit devid, so get it */
+		mydevid = inb(cmd_addr+1) << 8;
+		outb(devid_addr+1, cmd_addr);
+		mydevid |= inb(cmd_addr+1);
+	}
+
+	/* test for the desired device id value */
+	mydevid &= ~ where->devid_mask;
+	if (mydevid != want_devid) {
+		pr_debug("got devid %x, want %x\n", mydevid, want_devid);
+		return NULL;
+	}
+	/* find 1st unused slot */
+	for (slot = 0; slot < max_locks; slot++)
+		if (!sio_locks[slot].users) {
+			gate = &sio_locks[slot];
+			break;
+		}
+	if (slot >= max_locks) {
+		printk(KERN_ERR DRVNAME
+		       ": No superio-locks left. increase max_locks\n");
+		return NULL;
+	}
+	/* grab the io-port region */
+	if (!request_region(cmd_addr, 2, DRVNAME)) {
+		printk(KERN_ERR DRVNAME
+		       ": superio port region already claimed\n");
+		if (paranoid)
+			return NULL;
+	}
+
+	pr_debug("allocating slot %d, addr %x for device %x\n",
+		 slot, cmd_addr, want_devid);
+
+	gate->sioaddr = cmd_addr;
+	gate->devid = want_devid;
+	gate->users = 1;
+
+	return gate;
+}
+/*
+ * superio_get() checks whether the desired SuperIO device has been
+ * reserved, and shares that reservation.  Otherwize it calls
+ * superio_probe_reserve to make a new reservation.
+ */
+static struct superio* superio_get(const struct superio_search * const where,
+				   int cmd_addr, int want_devid)
+{
+	int slot;
+	struct superio *gate;
+
+	/* share any already allocated lock for this cmd_addr, device-id */
+	for (slot = 0; slot < max_locks; slot++) {
+		gate = &sio_locks[slot];
+
+		if (gate->users && cmd_addr == gate->sioaddr
+		    && want_devid == gate->devid) {
+
+			if (gate->users >= 255) {
+				pr_info("too many drivers sharing port %x\n",
+					gate->sioaddr);
+				return NULL;
+			}
+			gate->users++;
+			pr_debug("sharing port:%x dev:%x users:%d\n",
+				gate->sioaddr, gate->devid, gate->users);
+			return gate;
+		}
+	}
+	/* no existing reservation found */
+	return superio_probe_reserve(where, cmd_addr, want_devid);
+}
+
+/**
+ * superio_find: find a superio-port, share a reservation on it.
+ * @search-criterion : device-id addrs, values that driver supports.
+ * Description: searches for a superio-port with one of the specified
+ * device-ids at one of the command-addresses.  If port is found,
+ * creates an sio-locks reservation, or shares the one previously
+ * created (by another user-driver)
+ */
+struct superio* superio_find(const struct superio_search * const where)
+{
+	int ci, di;
+	struct superio* gate = NULL;
+
+	mutex_lock(&reservation_lock);
+
+	for (ci = 0; ci < ARRAY_SIZE(where->cmdreg_addrs)
+	       && where->cmdreg_addrs[ci]; ci++) {
+	     
+		for (di = 0; di < ARRAY_SIZE(where->device_ids)
+		       && where->device_ids[di]; di++) {
+			
+			gate = superio_get(where, where->cmdreg_addrs[ci],
+					   where->device_ids[di]);
+			if (!gate) {
+				pr_debug("no devid:%x at port:%x\n",
+					where->device_ids[di],
+					where->cmdreg_addrs[ci]);
+			} else
+				goto OUT;
+		}
+	}
+OUT:
+	if (gate)
+		pr_info("found devid:%x port:%x users:%d\n",
+			gate->devid, gate->sioaddr, gate->users);
+
+	mutex_unlock(&reservation_lock);
+	return gate;
+}
+EXPORT_SYMBOL_GPL(superio_find);
+
+/**
+ * superio_release:
+ * @gate : sio-lock reservation
+ * Description: releases the sio-lock reservation taken previously.
+ */
+void superio_release(struct superio* const gate)
+{
+	mutex_lock(&reservation_lock);
+
+	if (gate < &sio_locks[0] || gate >= &sio_locks[max_locks]) {
+		printk(KERN_ERR
+		       " superio: attempt to release corrupted superio-lock"
+		       " %p vs %p\n", gate, &sio_locks);
+		mutex_unlock(&reservation_lock);
+		return;
+	}
+	if (!(--gate->users)) {
+		release_region(gate->sioaddr, 2);
+		pr_debug("releasing last user of superio-port %x\n",
+			gate->sioaddr);
+	} else
+		pr_debug("released superio-port %x user, now have %d\n",
+			 gate->sioaddr, gate->users);
+
+
+	mutex_unlock(&reservation_lock);
+	return;
+}
+EXPORT_SYMBOL_GPL(superio_release);
+
+static int superio_locks_init_module(void)
+{
+	int i;
+
+	pr_debug("initializing with %d reservation slots\n", max_locks);
+	sio_locks = kzalloc(max_locks*sizeof(struct superio), GFP_KERNEL);
+	if (!sio_locks) {
+		printk(KERN_ERR "superio: no memory\n");
+		return -ENOMEM;
+	}
+	for (i = 0; i < max_locks; i++)
+		mutex_init(&sio_locks[i].lock);
+
+	mutex_init(&reservation_lock);
+	return 0;
+}
+
+static void superio_locks_cleanup_module(void)
+{
+	pr_debug("releasing %d superio reservation slots\n", max_locks);
+	kfree(sio_locks);
+}
+
+module_init(superio_locks_init_module);
+module_exit(superio_locks_cleanup_module);
diff -ruNp -X dontdiff -X exclude-diffs hwmon-fan-push-offset/include/linux/superio-locks.h hwmon-superio.old/include/linux/superio-locks.h
--- hwmon-fan-push-offset/include/linux/superio-locks.h	1969-12-31 17:00:00.000000000 -0700
+++ hwmon-superio.old/include/linux/superio-locks.h	2007-10-14 17:22:23.000000000 -0600
@@ -0,0 +1,112 @@
+#include <linux/mutex.h>
+#include <asm/io.h>
+
+#define SEQ_SZ 8
+
+/* Super-IO ports are found in low-pin-count hardware (typically ISA,
+ * any others ?).  They usually provide access to many functional
+ * units, so many drivers must share the superio port.  This struct
+ * provides a lock that allows the drivers to coordinate access to
+ * that port.
+ */
+struct superio {
+	struct mutex lock;	/* lock shared amongst user drivers */
+	u16 sioaddr;		/* port's tested cmd-address */
+	u16 devid;		/* devid found by the registering driver */
+	u16 users;		/* count client drivers */
+	u8  enter_seq[SEQ_SZ];  /* activate the superio-port */
+	u8  exit_seq[SEQ_SZ];   /* idle the superio-port */
+	u8  devid_word;		/* some devices have 2 byte device id */
+	u8  ldn_addr;		/* logical device select reg */  
+};
+
+struct superio_search {
+	u16 cmdreg_addrs[4];	/* maybe default to 0x2e, 0x4e */
+	u16 device_ids[8];	/* 0 ends scan early */
+	u16 devid_addr;		/* LSB of device-id. default addr: 0x20 */
+	u16 devid_mask;		/* dont-care bits */
+	u8  enter_seq[SEQ_SZ];  /* activate the superio-port */
+	u8  exit_seq[SEQ_SZ];   /* idle the superio-port */
+	u8  devid_word;		/* some devices have 2 byte device id */
+	u8  ldn_addr;		/* logical device select reg */  
+};
+
+struct superio* superio_find(const struct superio_search * const where);
+void superio_release(struct superio* const gate);
+
+/* superio_inb(), superio_outb() are also former client funcs */
+
+static inline int superio_inb(struct superio * const sio_port, u8 reg)
+{
+	outb(reg, sio_port->sioaddr);
+	return inb(sio_port->sioaddr+1);
+}
+
+static inline void superio_outb(struct superio * const sio_port, u8 reg, u8 val)
+{
+	outb(reg, sio_port->sioaddr);
+	outb(val, sio_port->sioaddr+1);
+}
+
+static inline int superio_inw(struct superio * const sio_port, u8 reg)
+{
+	int val;
+
+	outb(reg++, sio_port->sioaddr);
+	val = inb(sio_port->sioaddr) << 8;
+	outb(reg, sio_port->sioaddr);
+	val |= inb(sio_port->sioaddr+1);
+
+	return val;
+}
+
+/* superio_enter() and superio_exit() were formerly implemented in the
+ * client drivers, and managed the superio port by sending idling &
+ * activation sequences, which differ per device.  However, the
+ * protection was incomplete, since any driver would activate the port
+ * before using it, thus defeating the idling done by another driver
+ * to 'lock' the port.  We therefore claim 'eminent domain', and
+ * re-implement them here to properly manage the mutex.
+ */
+
+static inline void superio_enter(struct superio * const gate)
+{
+	int i;
+	mutex_lock(&gate->lock);
+	for (i = 0; i < SEQ_SZ && gate->enter_seq[i]; i++)
+		outb(gate->enter_seq[i], gate->sioaddr);
+}
+
+static inline void superio_exit(struct superio * const gate)
+{
+	int i;
+	for (i = 0; i < SEQ_SZ && gate->enter_seq[i]; i++)
+		outb(gate->exit_seq[i], gate->sioaddr);
+	mutex_unlock(&gate->lock);
+}
+
+/* maybe dont need these 2 */
+
+static inline void superio_lock(struct superio * const sio_port)
+{
+	mutex_lock(&sio_port->lock);
+}
+
+static inline void superio_unlock(struct superio * const sio_port)
+{
+	mutex_unlock(&sio_port->lock);
+}
+
+
+static inline u16 superio_devid(struct superio * const gate)
+{
+	return gate->devid;
+}
+
+#define LPC_LDN        0x07    /* Logical device select register */
+
+static inline void superio_select(struct superio * const gate, int ld)
+{
+	superio_outb(gate, (gate->ldn_addr) ? gate->ldn_addr : LPC_LDN, ld);
+}
+

 

