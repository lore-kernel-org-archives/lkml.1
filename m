Return-Path: <linux-kernel-owner+w=401wt.eu-S1758319AbYG0BMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319AbYG0BMb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 21:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756871AbYG0BMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 21:12:23 -0400
Received: from ns2.suse.de ([195.135.220.15]:53937 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756836AbYG0BMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 21:12:17 -0400
Date: Sun, 27 Jul 2008 03:12:09 +0200
From: Karsten Keil <kkeil@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] Add mISDN core files
Message-ID: <20080727011209.GC3415@pingi.kke.suse.de>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add mISDN core files

Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 drivers/isdn/mISDN/Kconfig     |    9 +
 drivers/isdn/mISDN/Makefile    |    9 +
 drivers/isdn/mISDN/core.c      |  244 +++++
 drivers/isdn/mISDN/core.h      |   77 ++
 drivers/isdn/mISDN/fsm.c       |  183 ++++
 drivers/isdn/mISDN/fsm.h       |   67 ++
 drivers/isdn/mISDN/hwchannel.c |  365 +++++++
 drivers/isdn/mISDN/layer1.c    |  403 ++++++++
 drivers/isdn/mISDN/layer1.h    |   26 +
 drivers/isdn/mISDN/layer2.c    | 2216 ++++++++++++++++++++++++++++++++++++++++
 drivers/isdn/mISDN/layer2.h    |  140 +++
 drivers/isdn/mISDN/socket.c    |  781 ++++++++++++++
 drivers/isdn/mISDN/stack.c     |  674 ++++++++++++
 drivers/isdn/mISDN/tei.c       | 1340 ++++++++++++++++++++++++
 drivers/isdn/mISDN/timerdev.c  |  301 ++++++
 include/linux/mISDNhw.h        |  193 ++++
 include/linux/mISDNif.h        |  487 +++++++++
 17 files changed, 7515 insertions(+), 0 deletions(-)
 create mode 100644 drivers/isdn/mISDN/Kconfig
 create mode 100644 drivers/isdn/mISDN/Makefile
 create mode 100644 drivers/isdn/mISDN/core.c
 create mode 100644 drivers/isdn/mISDN/core.h
 create mode 100644 drivers/isdn/mISDN/fsm.c
 create mode 100644 drivers/isdn/mISDN/fsm.h
 create mode 100644 drivers/isdn/mISDN/hwchannel.c
 create mode 100644 drivers/isdn/mISDN/layer1.c
 create mode 100644 drivers/isdn/mISDN/layer1.h
 create mode 100644 drivers/isdn/mISDN/layer2.c
 create mode 100644 drivers/isdn/mISDN/layer2.h
 create mode 100644 drivers/isdn/mISDN/socket.c
 create mode 100644 drivers/isdn/mISDN/stack.c
 create mode 100644 drivers/isdn/mISDN/tei.c
 create mode 100644 drivers/isdn/mISDN/timerdev.c
 create mode 100644 include/linux/mISDNhw.h
 create mode 100644 include/linux/mISDNif.h

diff --git a/drivers/isdn/mISDN/Kconfig b/drivers/isdn/mISDN/Kconfig
new file mode 100644
index 0000000..231bd0d
--- /dev/null
+++ b/drivers/isdn/mISDN/Kconfig
@@ -0,0 +1,9 @@
+#
+# modularer ISDN driver
+#
+
+menuconfig MISDN
+	tristate "Modular ISDN driver"
+	help
+	  Enable support for the modular ISDN driver.
+
diff --git a/drivers/isdn/mISDN/Makefile b/drivers/isdn/mISDN/Makefile
new file mode 100644
index 0000000..87c563d
--- /dev/null
+++ b/drivers/isdn/mISDN/Makefile
@@ -0,0 +1,9 @@
+#
+# Makefile for the modular ISDN driver
+#
+
+obj-$(CONFIG_MISDN) += mISDN_core.o
+
+# multi objects
+
+mISDN_core-objs := core.o fsm.o socket.o hwchannel.o stack.o layer1.o layer2.o tei.o timerdev.o
diff --git a/drivers/isdn/mISDN/core.c b/drivers/isdn/mISDN/core.c
new file mode 100644
index 0000000..3306817
--- /dev/null
+++ b/drivers/isdn/mISDN/core.c
@@ -0,0 +1,244 @@
+/*
+ * Copyright 2008  by Karsten Keil <kkeil@novell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/stddef.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/mISDNif.h>
+#include "core.h"
+
+static u_int debug;
+
+MODULE_AUTHOR("Karsten Keil");
+MODULE_LICENSE("GPL");
+module_param(debug, uint, S_IRUGO | S_IWUSR);
+
+static LIST_HEAD(devices);
+DEFINE_RWLOCK(device_lock);
+static u64		device_ids;
+#define MAX_DEVICE_ID	63
+
+static LIST_HEAD(Bprotocols);
+DEFINE_RWLOCK(bp_lock);
+
+struct mISDNdevice
+*get_mdevice(u_int id)
+{
+	struct mISDNdevice	*dev;
+
+	read_lock(&device_lock);
+	list_for_each_entry(dev, &devices, D.list)
+		if (dev->id == id) {
+			read_unlock(&device_lock);
+			return dev;
+		}
+	read_unlock(&device_lock);
+	return NULL;
+}
+
+int
+get_mdevice_count(void)
+{
+	struct mISDNdevice	*dev;
+	int			cnt = 0;
+
+	read_lock(&device_lock);
+	list_for_each_entry(dev, &devices, D.list)
+		cnt++;
+	read_unlock(&device_lock);
+	return cnt;
+}
+
+static int
+get_free_devid(void)
+{
+	u_int	i;
+
+	for (i = 0; i <= MAX_DEVICE_ID; i++)
+		if (!test_and_set_bit(i, (u_long *)&device_ids))
+			return i;
+	return -1;
+}
+
+int
+mISDN_register_device(struct mISDNdevice *dev, char *name)
+{
+	u_long	flags;
+	int	err;
+
+	dev->id = get_free_devid();
+	if (dev->id < 0)
+		return -EBUSY;
+	if (name && name[0])
+		strcpy(dev->name, name);
+	else
+		sprintf(dev->name, "mISDN%d", dev->id);
+	if (debug & DEBUG_CORE)
+		printk(KERN_DEBUG "mISDN_register %s %d\n",
+			dev->name, dev->id);
+	err = create_stack(dev);
+	if (err)
+		return err;
+	write_lock_irqsave(&device_lock, flags);
+	list_add_tail(&dev->D.list, &devices);
+	write_unlock_irqrestore(&device_lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL(mISDN_register_device);
+
+void
+mISDN_unregister_device(struct mISDNdevice *dev) {
+	u_long	flags;
+
+	if (debug & DEBUG_CORE)
+		printk(KERN_DEBUG "mISDN_unregister %s %d\n",
+			dev->name, dev->id);
+	write_lock_irqsave(&device_lock, flags);
+	list_del(&dev->D.list);
+	write_unlock_irqrestore(&device_lock, flags);
+	test_and_clear_bit(dev->id, (u_long *)&device_ids);
+	delete_stack(dev);
+}
+EXPORT_SYMBOL(mISDN_unregister_device);
+
+u_int
+get_all_Bprotocols(void)
+{
+	struct Bprotocol	*bp;
+	u_int	m = 0;
+
+	read_lock(&bp_lock);
+	list_for_each_entry(bp, &Bprotocols, list)
+		m |= bp->Bprotocols;
+	read_unlock(&bp_lock);
+	return m;
+}
+
+struct Bprotocol *
+get_Bprotocol4mask(u_int m)
+{
+	struct Bprotocol	*bp;
+
+	read_lock(&bp_lock);
+	list_for_each_entry(bp, &Bprotocols, list)
+		if (bp->Bprotocols & m) {
+			read_unlock(&bp_lock);
+			return bp;
+		}
+	read_unlock(&bp_lock);
+	return NULL;
+}
+
+struct Bprotocol *
+get_Bprotocol4id(u_int id)
+{
+	u_int	m;
+
+	if (id < ISDN_P_B_START || id > 63) {
+		printk(KERN_WARNING "%s id not in range  %d\n",
+		    __func__, id);
+		return NULL;
+	}
+	m = 1 << (id & ISDN_P_B_MASK);
+	return get_Bprotocol4mask(m);
+}
+
+int
+mISDN_register_Bprotocol(struct Bprotocol *bp)
+{
+	u_long			flags;
+	struct Bprotocol	*old;
+
+	if (debug & DEBUG_CORE)
+		printk(KERN_DEBUG "%s: %s/%x\n", __func__,
+		    bp->name, bp->Bprotocols);
+	old = get_Bprotocol4mask(bp->Bprotocols);
+	if (old) {
+		printk(KERN_WARNING
+		    "register duplicate protocol old %s/%x new %s/%x\n",
+		    old->name, old->Bprotocols, bp->name, bp->Bprotocols);
+		return -EBUSY;
+	}
+	write_lock_irqsave(&bp_lock, flags);
+	list_add_tail(&bp->list, &Bprotocols);
+	write_unlock_irqrestore(&bp_lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL(mISDN_register_Bprotocol);
+
+void
+mISDN_unregister_Bprotocol(struct Bprotocol *bp)
+{
+	u_long	flags;
+
+	if (debug & DEBUG_CORE)
+		printk(KERN_DEBUG "%s: %s/%x\n", __func__, bp->name,
+			bp->Bprotocols);
+	write_lock_irqsave(&bp_lock, flags);
+	list_del(&bp->list);
+	write_unlock_irqrestore(&bp_lock, flags);
+}
+EXPORT_SYMBOL(mISDN_unregister_Bprotocol);
+
+int
+mISDNInit(void)
+{
+	int	err;
+
+	printk(KERN_INFO "Modular ISDN core version %d.%d.%d\n",
+		MISDN_MAJOR_VERSION, MISDN_MINOR_VERSION, MISDN_RELEASE);
+	mISDN_initstack(&debug);
+	err = mISDN_inittimer(&debug);
+	if (err)
+		goto error;
+	err = l1_init(&debug);
+	if (err) {
+		mISDN_timer_cleanup();
+		goto error;
+	}
+	err = Isdnl2_Init(&debug);
+	if (err) {
+		mISDN_timer_cleanup();
+		l1_cleanup();
+		goto error;
+	}
+	err = misdn_sock_init(&debug);
+	if (err) {
+		mISDN_timer_cleanup();
+		l1_cleanup();
+		Isdnl2_cleanup();
+	}
+error:
+	return err;
+}
+
+void mISDN_cleanup(void)
+{
+	misdn_sock_cleanup();
+	mISDN_timer_cleanup();
+	l1_cleanup();
+	Isdnl2_cleanup();
+
+	if (!list_empty(&devices))
+		printk(KERN_ERR "%s devices still registered\n", __func__);
+
+	if (!list_empty(&Bprotocols))
+		printk(KERN_ERR "%s Bprotocols still registered\n", __func__);
+	printk(KERN_DEBUG "mISDNcore unloaded\n");
+}
+
+module_init(mISDNInit);
+module_exit(mISDN_cleanup);
+
diff --git a/drivers/isdn/mISDN/core.h b/drivers/isdn/mISDN/core.h
new file mode 100644
index 0000000..7da7233
--- /dev/null
+++ b/drivers/isdn/mISDN/core.h
@@ -0,0 +1,77 @@
+/*
+ * Copyright 2008  by Karsten Keil <kkeil@novell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef mISDN_CORE_H
+#define mISDN_CORE_H
+
+extern struct mISDNdevice	*get_mdevice(u_int);
+extern int			get_mdevice_count(void);
+
+/* stack status flag */
+#define mISDN_STACK_ACTION_MASK		0x0000ffff
+#define mISDN_STACK_COMMAND_MASK	0x000f0000
+#define mISDN_STACK_STATUS_MASK		0xfff00000
+/* action bits 0-15 */
+#define mISDN_STACK_WORK	0
+#define mISDN_STACK_SETUP	1
+#define mISDN_STACK_CLEARING	2
+#define mISDN_STACK_RESTART	3
+#define mISDN_STACK_WAKEUP	4
+#define mISDN_STACK_ABORT	15
+/* command bits 16-19 */
+#define mISDN_STACK_STOPPED	16
+#define mISDN_STACK_INIT	17
+#define mISDN_STACK_THREADSTART	18
+/* status bits 20-31 */
+#define mISDN_STACK_BCHANNEL	20
+#define mISDN_STACK_ACTIVE      29
+#define mISDN_STACK_RUNNING     30
+#define mISDN_STACK_KILLED      31
+
+
+/* manager options */
+#define MGR_OPT_USER		24
+#define MGR_OPT_NETWORK		25
+
+extern int	connect_Bstack(struct mISDNdevice *, struct mISDNchannel *,
+			u_int, struct sockaddr_mISDN *);
+extern int	connect_layer1(struct mISDNdevice *, struct mISDNchannel *,
+			u_int, struct sockaddr_mISDN *);
+extern int	create_l2entity(struct mISDNdevice *, struct mISDNchannel *,
+			u_int, struct sockaddr_mISDN *);
+
+extern int	create_stack(struct mISDNdevice *);
+extern int	create_teimanager(struct mISDNdevice *);
+extern void	delete_teimanager(struct mISDNchannel *);
+extern void	delete_channel(struct mISDNchannel *);
+extern void	delete_stack(struct mISDNdevice *);
+extern void	mISDN_initstack(u_int *);
+extern int      misdn_sock_init(u_int *);
+extern void     misdn_sock_cleanup(void);
+extern void	add_layer2(struct mISDNchannel *, struct mISDNstack *);
+extern void	__add_layer2(struct mISDNchannel *, struct mISDNstack *);
+
+extern u_int		get_all_Bprotocols(void);
+struct Bprotocol	*get_Bprotocol4mask(u_int);
+struct Bprotocol	*get_Bprotocol4id(u_int);
+
+extern int	mISDN_inittimer(u_int *);
+extern void	mISDN_timer_cleanup(void);
+
+extern int	l1_init(u_int *);
+extern void	l1_cleanup(void);
+extern int 	Isdnl2_Init(u_int *);
+extern void	Isdnl2_cleanup(void);
+
+#endif
diff --git a/drivers/isdn/mISDN/fsm.c b/drivers/isdn/mISDN/fsm.c
new file mode 100644
index 0000000..b5d6553
--- /dev/null
+++ b/drivers/isdn/mISDN/fsm.c
@@ -0,0 +1,183 @@
+/*
+ * finite state machine implementation
+ *
+ * Author       Karsten Keil <kkeil@novell.com>
+ *
+ * Thanks to    Jan den Ouden
+ *              Fritz Elfert
+ * Copyright 2008  by Karsten Keil <kkeil@novell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include "fsm.h"
+
+#define FSM_TIMER_DEBUG 0
+
+void
+mISDN_FsmNew(struct Fsm *fsm,
+       struct FsmNode *fnlist, int fncount)
+{
+	int i;
+
+	fsm->jumpmatrix = kzalloc(sizeof(FSMFNPTR) * fsm->state_count *
+		fsm->event_count, GFP_KERNEL);
+
+	for (i = 0; i < fncount; i++)
+		if ((fnlist[i].state >= fsm->state_count) ||
+		    (fnlist[i].event >= fsm->event_count)) {
+			printk(KERN_ERR
+			    "mISDN_FsmNew Error: %d st(%ld/%ld) ev(%ld/%ld)\n",
+			    i, (long)fnlist[i].state, (long)fsm->state_count,
+			    (long)fnlist[i].event, (long)fsm->event_count);
+		} else
+			fsm->jumpmatrix[fsm->state_count * fnlist[i].event +
+			    fnlist[i].state] = (FSMFNPTR) fnlist[i].routine;
+}
+EXPORT_SYMBOL(mISDN_FsmNew);
+
+void
+mISDN_FsmFree(struct Fsm *fsm)
+{
+	kfree((void *) fsm->jumpmatrix);
+}
+EXPORT_SYMBOL(mISDN_FsmFree);
+
+int
+mISDN_FsmEvent(struct FsmInst *fi, int event, void *arg)
+{
+	FSMFNPTR r;
+
+	if ((fi->state >= fi->fsm->state_count) ||
+	    (event >= fi->fsm->event_count)) {
+		printk(KERN_ERR
+		    "mISDN_FsmEvent Error st(%ld/%ld) ev(%d/%ld)\n",
+		    (long)fi->state, (long)fi->fsm->state_count, event,
+		    (long)fi->fsm->event_count);
+		return 1;
+	}
+	r = fi->fsm->jumpmatrix[fi->fsm->state_count * event + fi->state];
+	if (r) {
+		if (fi->debug)
+			fi->printdebug(fi, "State %s Event %s",
+				fi->fsm->strState[fi->state],
+				fi->fsm->strEvent[event]);
+		r(fi, event, arg);
+		return 0;
+	} else {
+		if (fi->debug)
+			fi->printdebug(fi, "State %s Event %s no action",
+				fi->fsm->strState[fi->state],
+				fi->fsm->strEvent[event]);
+		return 1;
+	}
+}
+EXPORT_SYMBOL(mISDN_FsmEvent);
+
+void
+mISDN_FsmChangeState(struct FsmInst *fi, int newstate)
+{
+	fi->state = newstate;
+	if (fi->debug)
+		fi->printdebug(fi, "ChangeState %s",
+			fi->fsm->strState[newstate]);
+}
+EXPORT_SYMBOL(mISDN_FsmChangeState);
+
+static void
+FsmExpireTimer(struct FsmTimer *ft)
+{
+#if FSM_TIMER_DEBUG
+	if (ft->fi->debug)
+		ft->fi->printdebug(ft->fi, "FsmExpireTimer %lx", (long) ft);
+#endif
+	mISDN_FsmEvent(ft->fi, ft->event, ft->arg);
+}
+
+void
+mISDN_FsmInitTimer(struct FsmInst *fi, struct FsmTimer *ft)
+{
+	ft->fi = fi;
+	ft->tl.function = (void *) FsmExpireTimer;
+	ft->tl.data = (long) ft;
+#if FSM_TIMER_DEBUG
+	if (ft->fi->debug)
+		ft->fi->printdebug(ft->fi, "mISDN_FsmInitTimer %lx", (long) ft);
+#endif
+	init_timer(&ft->tl);
+}
+EXPORT_SYMBOL(mISDN_FsmInitTimer);
+
+void
+mISDN_FsmDelTimer(struct FsmTimer *ft, int where)
+{
+#if FSM_TIMER_DEBUG
+	if (ft->fi->debug)
+		ft->fi->printdebug(ft->fi, "mISDN_FsmDelTimer %lx %d",
+			(long) ft, where);
+#endif
+	del_timer(&ft->tl);
+}
+EXPORT_SYMBOL(mISDN_FsmDelTimer);
+
+int
+mISDN_FsmAddTimer(struct FsmTimer *ft,
+	    int millisec, int event, void *arg, int where)
+{
+
+#if FSM_TIMER_DEBUG
+	if (ft->fi->debug)
+		ft->fi->printdebug(ft->fi, "mISDN_FsmAddTimer %lx %d %d",
+			(long) ft, millisec, where);
+#endif
+
+	if (timer_pending(&ft->tl)) {
+		if (ft->fi->debug) {
+			printk(KERN_WARNING
+				"mISDN_FsmAddTimer: timer already active!\n");
+			ft->fi->printdebug(ft->fi,
+				"mISDN_FsmAddTimer already active!");
+		}
+		return -1;
+	}
+	init_timer(&ft->tl);
+	ft->event = event;
+	ft->arg = arg;
+	ft->tl.expires = jiffies + (millisec * HZ) / 1000;
+	add_timer(&ft->tl);
+	return 0;
+}
+EXPORT_SYMBOL(mISDN_FsmAddTimer);
+
+void
+mISDN_FsmRestartTimer(struct FsmTimer *ft,
+	    int millisec, int event, void *arg, int where)
+{
+
+#if FSM_TIMER_DEBUG
+	if (ft->fi->debug)
+		ft->fi->printdebug(ft->fi, "mISDN_FsmRestartTimer %lx %d %d",
+			(long) ft, millisec, where);
+#endif
+
+	if (timer_pending(&ft->tl))
+		del_timer(&ft->tl);
+	init_timer(&ft->tl);
+	ft->event = event;
+	ft->arg = arg;
+	ft->tl.expires = jiffies + (millisec * HZ) / 1000;
+	add_timer(&ft->tl);
+}
+EXPORT_SYMBOL(mISDN_FsmRestartTimer);
diff --git a/drivers/isdn/mISDN/fsm.h b/drivers/isdn/mISDN/fsm.h
new file mode 100644
index 0000000..928f5be
--- /dev/null
+++ b/drivers/isdn/mISDN/fsm.h
@@ -0,0 +1,67 @@
+/*
+ *
+ * Author       Karsten Keil <kkeil@novell.com>
+ *
+ * Thanks to    Jan den Ouden
+ *              Fritz Elfert
+ * Copyright 2008  by Karsten Keil <kkeil@novell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _MISDN_FSM_H
+#define _MISDN_FSM_H
+
+#include <linux/timer.h>
+
+/* Statemachine */
+
+struct FsmInst;
+
+typedef void (*FSMFNPTR)(struct FsmInst *, int, void *);
+
+struct Fsm {
+	FSMFNPTR *jumpmatrix;
+	int state_count, event_count;
+	char **strEvent, **strState;
+};
+
+struct FsmInst {
+	struct Fsm *fsm;
+	int state;
+	int debug;
+	void *userdata;
+	int userint;
+	void (*printdebug) (struct FsmInst *, char *, ...);
+};
+
+struct FsmNode {
+	int state, event;
+	void (*routine) (struct FsmInst *, int, void *);
+};
+
+struct FsmTimer {
+	struct FsmInst *fi;
+	struct timer_list tl;
+	int event;
+	void *arg;
+};
+
+extern void mISDN_FsmNew(struct Fsm *, struct FsmNode *, int);
+extern void mISDN_FsmFree(struct Fsm *);
+extern int mISDN_FsmEvent(struct FsmInst *, int , void *);
+extern void mISDN_FsmChangeState(struct FsmInst *, int);
+extern void mISDN_FsmInitTimer(struct FsmInst *, struct FsmTimer *);
+extern int mISDN_FsmAddTimer(struct FsmTimer *, int, int, void *, int);
+extern void mISDN_FsmRestartTimer(struct FsmTimer *, int, int, void *, int);
+extern void mISDN_FsmDelTimer(struct FsmTimer *, int);
+
+#endif
diff --git a/drivers/isdn/mISDN/hwchannel.c b/drivers/isdn/mISDN/hwchannel.c
new file mode 100644
index 0000000..2596fba
--- /dev/null
+++ b/drivers/isdn/mISDN/hwchannel.c
@@ -0,0 +1,365 @@
+/*
+ *
+ * Author	Karsten Keil <kkeil@novell.com>
+ *
+ * Copyright 2008  by Karsten Keil <kkeil@novell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/mISDNhw.h>
+
+static void
+dchannel_bh(struct work_struct *ws)
+{
+	struct dchannel	*dch  = container_of(ws, struct dchannel, workq);
+	struct sk_buff	*skb;
+	int		err;
+
+	if (test_and_clear_bit(FLG_RECVQUEUE, &dch->Flags)) {
+		while ((skb = skb_dequeue(&dch->rqueue))) {
+			if (likely(dch->dev.D.peer)) {
+				err = dch->dev.D.recv(dch->dev.D.peer, skb);
+				if (err)
+					dev_kfree_skb(skb);
+			} else
+				dev_kfree_skb(skb);
+		}
+	}
+	if (test_and_clear_bit(FLG_PHCHANGE, &dch->Flags)) {
+		if (dch->phfunc)
+			dch->phfunc(dch);
+	}
+}
+
+static void
+bchannel_bh(struct work_struct *ws)
+{
+	struct bchannel	*bch  = container_of(ws, struct bchannel, workq);
+	struct sk_buff	*skb;
+	int		err;
+
+	if (test_and_clear_bit(FLG_RECVQUEUE, &bch->Flags)) {
+		while ((skb = skb_dequeue(&bch->rqueue))) {
+			if (bch->rcount >= 64)
+				printk(KERN_WARNING "B-channel %p receive "
+					"queue if full, but empties...\n", bch);
+			bch->rcount--;
+			if (likely(bch->ch.peer)) {
+				err = bch->ch.recv(bch->ch.peer, skb);
+				if (err)
+					dev_kfree_skb(skb);
+			} else
+				dev_kfree_skb(skb);
+		}
+	}
+}
+
+int
+mISDN_initdchannel(struct dchannel *ch, int maxlen, void *phf)
+{
+	test_and_set_bit(FLG_HDLC, &ch->Flags);
+	ch->maxlen = maxlen;
+	ch->hw = NULL;
+	ch->rx_skb = NULL;
+	ch->tx_skb = NULL;
+	ch->tx_idx = 0;
+	ch->phfunc = phf;
+	skb_queue_head_init(&ch->squeue);
+	skb_queue_head_init(&ch->rqueue);
+	INIT_LIST_HEAD(&ch->dev.bchannels);
+	INIT_WORK(&ch->workq, dchannel_bh);
+	return 0;
+}
+EXPORT_SYMBOL(mISDN_initdchannel);
+
+int
+mISDN_initbchannel(struct bchannel *ch, int maxlen)
+{
+	ch->Flags = 0;
+	ch->maxlen = maxlen;
+	ch->hw = NULL;
+	ch->rx_skb = NULL;
+	ch->tx_skb = NULL;
+	ch->tx_idx = 0;
+	skb_queue_head_init(&ch->rqueue);
+	ch->rcount = 0;
+	ch->next_skb = NULL;
+	INIT_WORK(&ch->workq, bchannel_bh);
+	return 0;
+}
+EXPORT_SYMBOL(mISDN_initbchannel);
+
+int
+mISDN_freedchannel(struct dchannel *ch)
+{
+	if (ch->tx_skb) {
+		dev_kfree_skb(ch->tx_skb);
+		ch->tx_skb = NULL;
+	}
+	if (ch->rx_skb) {
+		dev_kfree_skb(ch->rx_skb);
+		ch->rx_skb = NULL;
+	}
+	skb_queue_purge(&ch->squeue);
+	skb_queue_purge(&ch->rqueue);
+	flush_scheduled_work();
+	return 0;
+}
+EXPORT_SYMBOL(mISDN_freedchannel);
+
+int
+mISDN_freebchannel(struct bchannel *ch)
+{
+	if (ch->tx_skb) {
+		dev_kfree_skb(ch->tx_skb);
+		ch->tx_skb = NULL;
+	}
+	if (ch->rx_skb) {
+		dev_kfree_skb(ch->rx_skb);
+		ch->rx_skb = NULL;
+	}
+	if (ch->next_skb) {
+		dev_kfree_skb(ch->next_skb);
+		ch->next_skb = NULL;
+	}
+	skb_queue_purge(&ch->rqueue);
+	ch->rcount = 0;
+	flush_scheduled_work();
+	return 0;
+}
+EXPORT_SYMBOL(mISDN_freebchannel);
+
+static inline u_int
+get_sapi_tei(u_char *p)
+{
+	u_int	sapi, tei;
+
+	sapi = *p >> 2;
+	tei = p[1] >> 1;
+	return sapi | (tei << 8);
+}
+
+void
+recv_Dchannel(struct dchannel *dch)
+{
+	struct mISDNhead *hh;
+
+	if (dch->rx_skb->len < 2) { /* at least 2 for sapi / tei */
+		dev_kfree_skb(dch->rx_skb);
+		dch->rx_skb = NULL;
+		return;
+	}
+	hh = mISDN_HEAD_P(dch->rx_skb);
+	hh->prim = PH_DATA_IND;
+	hh->id = get_sapi_tei(dch->rx_skb->data);
+	skb_queue_tail(&dch->rqueue, dch->rx_skb);
+	dch->rx_skb = NULL;
+	schedule_event(dch, FLG_RECVQUEUE);
+}
+EXPORT_SYMBOL(recv_Dchannel);
+
+void
+recv_Bchannel(struct bchannel *bch)
+{
+	struct mISDNhead *hh;
+
+	hh = mISDN_HEAD_P(bch->rx_skb);
+	hh->prim = PH_DATA_IND;
+	hh->id = MISDN_ID_ANY;
+	if (bch->rcount >= 64) {
+		dev_kfree_skb(bch->rx_skb);
+		bch->rx_skb = NULL;
+		return;
+	}
+	bch->rcount++;
+	skb_queue_tail(&bch->rqueue, bch->rx_skb);
+	bch->rx_skb = NULL;
+	schedule_event(bch, FLG_RECVQUEUE);
+}
+EXPORT_SYMBOL(recv_Bchannel);
+
+void
+recv_Dchannel_skb(struct dchannel *dch, struct sk_buff *skb)
+{
+	skb_queue_tail(&dch->rqueue, skb);
+	schedule_event(dch, FLG_RECVQUEUE);
+}
+EXPORT_SYMBOL(recv_Dchannel_skb);
+
+void
+recv_Bchannel_skb(struct bchannel *bch, struct sk_buff *skb)
+{
+	if (bch->rcount >= 64) {
+		dev_kfree_skb(skb);
+		return;
+	}
+	bch->rcount++;
+	skb_queue_tail(&bch->rqueue, skb);
+	schedule_event(bch, FLG_RECVQUEUE);
+}
+EXPORT_SYMBOL(recv_Bchannel_skb);
+
+static void
+confirm_Dsend(struct dchannel *dch)
+{
+	struct sk_buff	*skb;
+
+	skb = _alloc_mISDN_skb(PH_DATA_CNF, mISDN_HEAD_ID(dch->tx_skb),
+	    0, NULL, GFP_ATOMIC);
+	if (!skb) {
+		printk(KERN_ERR "%s: no skb id %x\n", __func__,
+		    mISDN_HEAD_ID(dch->tx_skb));
+		return;
+	}
+	skb_queue_tail(&dch->rqueue, skb);
+	schedule_event(dch, FLG_RECVQUEUE);
+}
+
+int
+get_next_dframe(struct dchannel *dch)
+{
+	dch->tx_idx = 0;
+	dch->tx_skb = skb_dequeue(&dch->squeue);
+	if (dch->tx_skb) {
+		confirm_Dsend(dch);
+		return 1;
+	}
+	dch->tx_skb = NULL;
+	test_and_clear_bit(FLG_TX_BUSY, &dch->Flags);
+	return 0;
+}
+EXPORT_SYMBOL(get_next_dframe);
+
+void
+confirm_Bsend(struct bchannel *bch)
+{
+	struct sk_buff	*skb;
+
+	if (bch->rcount >= 64)
+		return;
+	skb = _alloc_mISDN_skb(PH_DATA_CNF, mISDN_HEAD_ID(bch->tx_skb),
+	    0, NULL, GFP_ATOMIC);
+	if (!skb) {
+		printk(KERN_ERR "%s: no skb id %x\n", __func__,
+		    mISDN_HEAD_ID(bch->tx_skb));
+		return;
+	}
+	bch->rcount++;
+	skb_queue_tail(&bch->rqueue, skb);
+	schedule_event(bch, FLG_RECVQUEUE);
+}
+EXPORT_SYMBOL(confirm_Bsend);
+
+int
+get_next_bframe(struct bchannel *bch)
+{
+	bch->tx_idx = 0;
+	if (test_bit(FLG_TX_NEXT, &bch->Flags)) {
+		bch->tx_skb = bch->next_skb;
+		if (bch->tx_skb) {
+			bch->next_skb = NULL;
+			test_and_clear_bit(FLG_TX_NEXT, &bch->Flags);
+			if (!test_bit(FLG_TRANSPARENT, &bch->Flags))
+				confirm_Bsend(bch); /* not for transparent */
+			return 1;
+		} else {
+			test_and_clear_bit(FLG_TX_NEXT, &bch->Flags);
+			printk(KERN_WARNING "B TX_NEXT without skb\n");
+		}
+	}
+	bch->tx_skb = NULL;
+	test_and_clear_bit(FLG_TX_BUSY, &bch->Flags);
+	return 0;
+}
+EXPORT_SYMBOL(get_next_bframe);
+
+void
+queue_ch_frame(struct mISDNchannel *ch, u_int pr, int id, struct sk_buff *skb)
+{
+	struct mISDNhead *hh;
+
+	if (!skb) {
+		_queue_data(ch, pr, id, 0, NULL, GFP_ATOMIC);
+	} else {
+		if (ch->peer) {
+			hh = mISDN_HEAD_P(skb);
+			hh->prim = pr;
+			hh->id = id;
+			if (!ch->recv(ch->peer, skb))
+				return;
+		}
+		dev_kfree_skb(skb);
+	}
+}
+EXPORT_SYMBOL(queue_ch_frame);
+
+int
+dchannel_senddata(struct dchannel *ch, struct sk_buff *skb)
+{
+	/* check oversize */
+	if (skb->len <= 0) {
+		printk(KERN_WARNING "%s: skb too small\n", __func__);
+		return -EINVAL;
+	}
+	if (skb->len > ch->maxlen) {
+		printk(KERN_WARNING "%s: skb too large(%d/%d)\n",
+			__func__, skb->len, ch->maxlen);
+		return -EINVAL;
+	}
+	/* HW lock must be obtained */
+	if (test_and_set_bit(FLG_TX_BUSY, &ch->Flags)) {
+		skb_queue_tail(&ch->squeue, skb);
+		return 0;
+	} else {
+		/* write to fifo */
+		ch->tx_skb = skb;
+		ch->tx_idx = 0;
+		return 1;
+	}
+}
+EXPORT_SYMBOL(dchannel_senddata);
+
+int
+bchannel_senddata(struct bchannel *ch, struct sk_buff *skb)
+{
+
+	/* check oversize */
+	if (skb->len <= 0) {
+		printk(KERN_WARNING "%s: skb too small\n", __func__);
+		return -EINVAL;
+	}
+	if (skb->len > ch->maxlen) {
+		printk(KERN_WARNING "%s: skb too large(%d/%d)\n",
+			__func__, skb->len, ch->maxlen);
+		return -EINVAL;
+	}
+	/* HW lock must be obtained */
+	/* check for pending next_skb */
+	if (ch->next_skb) {
+		printk(KERN_WARNING
+		    "%s: next_skb exist ERROR (skb->len=%d next_skb->len=%d)\n",
+		    __func__, skb->len, ch->next_skb->len);
+		return -EBUSY;
+	}
+	if (test_and_set_bit(FLG_TX_BUSY, &ch->Flags)) {
+		test_and_set_bit(FLG_TX_NEXT, &ch->Flags);
+		ch->next_skb = skb;
+		return 0;
+	} else {
+		/* write to fifo */
+		ch->tx_skb = skb;
+		ch->tx_idx = 0;
+		return 1;
+	}
+}
+EXPORT_SYMBOL(bchannel_senddata);
diff --git a/drivers/isdn/mISDN/layer1.c b/drivers/isdn/mISDN/layer1.c
new file mode 100644
index 0000000..fced1a2
--- /dev/null
+++ b/drivers/isdn/mISDN/layer1.c
@@ -0,0 +1,403 @@
+/*
+ *
+ * Author	Karsten Keil <kkeil@novell.com>
+ *
+ * Copyright 2008  by Karsten Keil <kkeil@novell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+
+#include <linux/module.h>
+#include <linux/mISDNhw.h>
+#include "layer1.h"
+#include "fsm.h"
+
+static int *debug;
+
+struct layer1 {
+	u_long			Flags;
+	struct FsmInst		l1m;
+	struct FsmTimer 	timer;
+	int			delay;
+	struct dchannel		*dch;
+	dchannel_l1callback	*dcb;
+};
+
+#define TIMER3_VALUE 7000
+
+static
+struct Fsm l1fsm_s = {NULL, 0, 0, NULL, NULL};
+
+enum {
+	ST_L1_F2,
+	ST_L1_F3,
+	ST_L1_F4,
+	ST_L1_F5,
+	ST_L1_F6,
+	ST_L1_F7,
+	ST_L1_F8,
+};
+
+#define L1S_STATE_COUNT (ST_L1_F8+1)
+
+static char *strL1SState[] =
+{
+	"ST_L1_F2",
+	"ST_L1_F3",
+	"ST_L1_F4",
+	"ST_L1_F5",
+	"ST_L1_F6",
+	"ST_L1_F7",
+	"ST_L1_F8",
+};
+
+enum {
+	EV_PH_ACTIVATE,
+	EV_PH_DEACTIVATE,
+	EV_RESET_IND,
+	EV_DEACT_CNF,
+	EV_DEACT_IND,
+	EV_POWER_UP,
+	EV_ANYSIG_IND,
+	EV_INFO2_IND,
+	EV_INFO4_IND,
+	EV_TIMER_DEACT,
+	EV_TIMER_ACT,
+	EV_TIMER3,
+};
+
+#define L1_EVENT_COUNT (EV_TIMER3 + 1)
+
+static char *strL1Event[] =
+{
+	"EV_PH_ACTIVATE",
+	"EV_PH_DEACTIVATE",
+	"EV_RESET_IND",
+	"EV_DEACT_CNF",
+	"EV_DEACT_IND",
+	"EV_POWER_UP",
+	"EV_ANYSIG_IND",
+	"EV_INFO2_IND",
+	"EV_INFO4_IND",
+	"EV_TIMER_DEACT",
+	"EV_TIMER_ACT",
+	"EV_TIMER3",
+};
+
+static void
+l1m_debug(struct FsmInst *fi, char *fmt, ...)
+{
+	struct layer1 *l1 = fi->userdata;
+	va_list va;
+
+	va_start(va, fmt);
+	printk(KERN_DEBUG "%s: ", l1->dch->dev.name);
+	vprintk(fmt, va);
+	printk("\n");
+	va_end(va);
+}
+
+static void
+l1_reset(struct FsmInst *fi, int event, void *arg)
+{
+	mISDN_FsmChangeState(fi, ST_L1_F3);
+}
+
+static void
+l1_deact_cnf(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer1 *l1 = fi->userdata;
+
+	mISDN_FsmChangeState(fi, ST_L1_F3);
+	if (test_bit(FLG_L1_ACTIVATING, &l1->Flags))
+		l1->dcb(l1->dch, HW_POWERUP_REQ);
+}
+
+static void
+l1_deact_req_s(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer1 *l1 = fi->userdata;
+
+	mISDN_FsmChangeState(fi, ST_L1_F3);
+	mISDN_FsmRestartTimer(&l1->timer, 550, EV_TIMER_DEACT, NULL, 2);
+	test_and_set_bit(FLG_L1_DEACTTIMER, &l1->Flags);
+}
+
+static void
+l1_power_up_s(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer1 *l1 = fi->userdata;
+
+	if (test_bit(FLG_L1_ACTIVATING, &l1->Flags)) {
+		mISDN_FsmChangeState(fi, ST_L1_F4);
+		l1->dcb(l1->dch, INFO3_P8);
+	} else
+		mISDN_FsmChangeState(fi, ST_L1_F3);
+}
+
+static void
+l1_go_F5(struct FsmInst *fi, int event, void *arg)
+{
+	mISDN_FsmChangeState(fi, ST_L1_F5);
+}
+
+static void
+l1_go_F8(struct FsmInst *fi, int event, void *arg)
+{
+	mISDN_FsmChangeState(fi, ST_L1_F8);
+}
+
+static void
+l1_info2_ind(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer1 *l1 = fi->userdata;
+
+	mISDN_FsmChangeState(fi, ST_L1_F6);
+	l1->dcb(l1->dch, INFO3_P8);
+}
+
+static void
+l1_info4_ind(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer1 *l1 = fi->userdata;
+
+	mISDN_FsmChangeState(fi, ST_L1_F7);
+	l1->dcb(l1->dch, INFO3_P8);
+	if (test_and_clear_bit(FLG_L1_DEACTTIMER, &l1->Flags))
+		mISDN_FsmDelTimer(&l1->timer, 4);
+	if (!test_bit(FLG_L1_ACTIVATED, &l1->Flags)) {
+		if (test_and_clear_bit(FLG_L1_T3RUN, &l1->Flags))
+			mISDN_FsmDelTimer(&l1->timer, 3);
+		mISDN_FsmRestartTimer(&l1->timer, 110, EV_TIMER_ACT, NULL, 2);
+		test_and_set_bit(FLG_L1_ACTTIMER, &l1->Flags);
+	}
+}
+
+static void
+l1_timer3(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer1 *l1 = fi->userdata;
+
+	test_and_clear_bit(FLG_L1_T3RUN, &l1->Flags);
+	if (test_and_clear_bit(FLG_L1_ACTIVATING, &l1->Flags)) {
+		if (test_and_clear_bit(FLG_L1_DBLOCKED, &l1->Flags))
+			l1->dcb(l1->dch, HW_D_NOBLOCKED);
+		l1->dcb(l1->dch, PH_DEACTIVATE_IND);
+	}
+	if (l1->l1m.state != ST_L1_F6) {
+		mISDN_FsmChangeState(fi, ST_L1_F3);
+		l1->dcb(l1->dch, HW_POWERUP_REQ);
+	}
+}
+
+static void
+l1_timer_act(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer1 *l1 = fi->userdata;
+
+	test_and_clear_bit(FLG_L1_ACTTIMER, &l1->Flags);
+	test_and_set_bit(FLG_L1_ACTIVATED, &l1->Flags);
+	l1->dcb(l1->dch, PH_ACTIVATE_IND);
+}
+
+static void
+l1_timer_deact(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer1 *l1 = fi->userdata;
+
+	test_and_clear_bit(FLG_L1_DEACTTIMER, &l1->Flags);
+	test_and_clear_bit(FLG_L1_ACTIVATED, &l1->Flags);
+	if (test_and_clear_bit(FLG_L1_DBLOCKED, &l1->Flags))
+		l1->dcb(l1->dch, HW_D_NOBLOCKED);
+	l1->dcb(l1->dch, PH_DEACTIVATE_IND);
+	l1->dcb(l1->dch, HW_DEACT_REQ);
+}
+
+static void
+l1_activate_s(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer1 *l1 = fi->userdata;
+
+	mISDN_FsmRestartTimer(&l1->timer, TIMER3_VALUE, EV_TIMER3, NULL, 2);
+	test_and_set_bit(FLG_L1_T3RUN, &l1->Flags);
+	l1->dcb(l1->dch, HW_RESET_REQ);
+}
+
+static void
+l1_activate_no(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer1 *l1 = fi->userdata;
+
+	if ((!test_bit(FLG_L1_DEACTTIMER, &l1->Flags)) &&
+	    (!test_bit(FLG_L1_T3RUN, &l1->Flags))) {
+		test_and_clear_bit(FLG_L1_ACTIVATING, &l1->Flags);
+		if (test_and_clear_bit(FLG_L1_DBLOCKED, &l1->Flags))
+			l1->dcb(l1->dch, HW_D_NOBLOCKED);
+		l1->dcb(l1->dch, PH_DEACTIVATE_IND);
+	}
+}
+
+static struct FsmNode L1SFnList[] =
+{
+	{ST_L1_F3, EV_PH_ACTIVATE, l1_activate_s},
+	{ST_L1_F6, EV_PH_ACTIVATE, l1_activate_no},
+	{ST_L1_F8, EV_PH_ACTIVATE, l1_activate_no},
+	{ST_L1_F3, EV_RESET_IND, l1_reset},
+	{ST_L1_F4, EV_RESET_IND, l1_reset},
+	{ST_L1_F5, EV_RESET_IND, l1_reset},
+	{ST_L1_F6, EV_RESET_IND, l1_reset},
+	{ST_L1_F7, EV_RESET_IND, l1_reset},
+	{ST_L1_F8, EV_RESET_IND, l1_reset},
+	{ST_L1_F3, EV_DEACT_CNF, l1_deact_cnf},
+	{ST_L1_F4, EV_DEACT_CNF, l1_deact_cnf},
+	{ST_L1_F5, EV_DEACT_CNF, l1_deact_cnf},
+	{ST_L1_F6, EV_DEACT_CNF, l1_deact_cnf},
+	{ST_L1_F7, EV_DEACT_CNF, l1_deact_cnf},
+	{ST_L1_F8, EV_DEACT_CNF, l1_deact_cnf},
+	{ST_L1_F6, EV_DEACT_IND, l1_deact_req_s},
+	{ST_L1_F7, EV_DEACT_IND, l1_deact_req_s},
+	{ST_L1_F8, EV_DEACT_IND, l1_deact_req_s},
+	{ST_L1_F3, EV_POWER_UP,  l1_power_up_s},
+	{ST_L1_F4, EV_ANYSIG_IND, l1_go_F5},
+	{ST_L1_F6, EV_ANYSIG_IND, l1_go_F8},
+	{ST_L1_F7, EV_ANYSIG_IND, l1_go_F8},
+	{ST_L1_F3, EV_INFO2_IND, l1_info2_ind},
+	{ST_L1_F4, EV_INFO2_IND, l1_info2_ind},
+	{ST_L1_F5, EV_INFO2_IND, l1_info2_ind},
+	{ST_L1_F7, EV_INFO2_IND, l1_info2_ind},
+	{ST_L1_F8, EV_INFO2_IND, l1_info2_ind},
+	{ST_L1_F3, EV_INFO4_IND, l1_info4_ind},
+	{ST_L1_F4, EV_INFO4_IND, l1_info4_ind},
+	{ST_L1_F5, EV_INFO4_IND, l1_info4_ind},
+	{ST_L1_F6, EV_INFO4_IND, l1_info4_ind},
+	{ST_L1_F8, EV_INFO4_IND, l1_info4_ind},
+	{ST_L1_F3, EV_TIMER3, l1_timer3},
+	{ST_L1_F4, EV_TIMER3, l1_timer3},
+	{ST_L1_F5, EV_TIMER3, l1_timer3},
+	{ST_L1_F6, EV_TIMER3, l1_timer3},
+	{ST_L1_F8, EV_TIMER3, l1_timer3},
+	{ST_L1_F7, EV_TIMER_ACT, l1_timer_act},
+	{ST_L1_F3, EV_TIMER_DEACT, l1_timer_deact},
+	{ST_L1_F4, EV_TIMER_DEACT, l1_timer_deact},
+	{ST_L1_F5, EV_TIMER_DEACT, l1_timer_deact},
+	{ST_L1_F6, EV_TIMER_DEACT, l1_timer_deact},
+	{ST_L1_F7, EV_TIMER_DEACT, l1_timer_deact},
+	{ST_L1_F8, EV_TIMER_DEACT, l1_timer_deact},
+};
+
+static void
+release_l1(struct layer1 *l1) {
+	mISDN_FsmDelTimer(&l1->timer, 0);
+	if (l1->dch)
+		l1->dch->l1 = NULL;
+	module_put(THIS_MODULE);
+	kfree(l1);
+}
+
+int
+l1_event(struct layer1 *l1, u_int event)
+{
+	int		err = 0;
+
+	if (!l1)
+		return -EINVAL;
+	switch (event) {
+	case HW_RESET_IND:
+		mISDN_FsmEvent(&l1->l1m, EV_RESET_IND, NULL);
+		break;
+	case HW_DEACT_IND:
+		mISDN_FsmEvent(&l1->l1m, EV_DEACT_IND, NULL);
+		break;
+	case HW_POWERUP_IND:
+		mISDN_FsmEvent(&l1->l1m, EV_POWER_UP, NULL);
+		break;
+	case HW_DEACT_CNF:
+		mISDN_FsmEvent(&l1->l1m, EV_DEACT_CNF, NULL);
+		break;
+	case ANYSIGNAL:
+		mISDN_FsmEvent(&l1->l1m, EV_ANYSIG_IND, NULL);
+		break;
+	case LOSTFRAMING:
+		mISDN_FsmEvent(&l1->l1m, EV_ANYSIG_IND, NULL);
+		break;
+	case INFO2:
+		mISDN_FsmEvent(&l1->l1m, EV_INFO2_IND, NULL);
+		break;
+	case INFO4_P8:
+		mISDN_FsmEvent(&l1->l1m, EV_INFO4_IND, NULL);
+		break;
+	case INFO4_P10:
+		mISDN_FsmEvent(&l1->l1m, EV_INFO4_IND, NULL);
+		break;
+	case PH_ACTIVATE_REQ:
+		if (test_bit(FLG_L1_ACTIVATED, &l1->Flags))
+			l1->dcb(l1->dch, PH_ACTIVATE_IND);
+		else {
+			test_and_set_bit(FLG_L1_ACTIVATING, &l1->Flags);
+			mISDN_FsmEvent(&l1->l1m, EV_PH_ACTIVATE, NULL);
+		}
+		break;
+	case CLOSE_CHANNEL:
+		release_l1(l1);
+		break;
+	default:
+		if (*debug & DEBUG_L1)
+			printk(KERN_DEBUG "%s %x unhandled\n",
+			    __func__, event);
+		err = -EINVAL;
+	}
+	return err;
+}
+EXPORT_SYMBOL(l1_event);
+
+int
+create_l1(struct dchannel *dch, dchannel_l1callback *dcb) {
+	struct layer1	*nl1;
+
+	nl1 = kzalloc(sizeof(struct layer1), GFP_ATOMIC);
+	if (!nl1) {
+		printk(KERN_ERR "kmalloc struct layer1 failed\n");
+		return -ENOMEM;
+	}
+	nl1->l1m.fsm = &l1fsm_s;
+	nl1->l1m.state = ST_L1_F3;
+	nl1->Flags = 0;
+	nl1->l1m.debug = *debug & DEBUG_L1_FSM;
+	nl1->l1m.userdata = nl1;
+	nl1->l1m.userint = 0;
+	nl1->l1m.printdebug = l1m_debug;
+	nl1->dch = dch;
+	nl1->dcb = dcb;
+	mISDN_FsmInitTimer(&nl1->l1m, &nl1->timer);
+	__module_get(THIS_MODULE);
+	dch->l1 = nl1;
+	return 0;
+}
+EXPORT_SYMBOL(create_l1);
+
+int
+l1_init(u_int *deb)
+{
+	debug = deb;
+	l1fsm_s.state_count = L1S_STATE_COUNT;
+	l1fsm_s.event_count = L1_EVENT_COUNT;
+	l1fsm_s.strEvent = strL1Event;
+	l1fsm_s.strState = strL1SState;
+	mISDN_FsmNew(&l1fsm_s, L1SFnList, ARRAY_SIZE(L1SFnList));
+	return 0;
+}
+
+void
+l1_cleanup(void)
+{
+	mISDN_FsmFree(&l1fsm_s);
+}
diff --git a/drivers/isdn/mISDN/layer1.h b/drivers/isdn/mISDN/layer1.h
new file mode 100644
index 0000000..9c8125f
--- /dev/null
+++ b/drivers/isdn/mISDN/layer1.h
@@ -0,0 +1,26 @@
+/*
+ *
+ * Layer 1 defines
+ *
+ * Copyright 2008  by Karsten Keil <kkeil@novell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#define FLG_L1_ACTIVATING	1
+#define FLG_L1_ACTIVATED	2
+#define FLG_L1_DEACTTIMER	3
+#define FLG_L1_ACTTIMER		4
+#define FLG_L1_T3RUN		5
+#define FLG_L1_PULL_REQ		6
+#define FLG_L1_UINT		7
+#define FLG_L1_DBLOCKED		8
+
diff --git a/drivers/isdn/mISDN/layer2.c b/drivers/isdn/mISDN/layer2.c
new file mode 100644
index 0000000..f5ad888
--- /dev/null
+++ b/drivers/isdn/mISDN/layer2.c
@@ -0,0 +1,2216 @@
+/*
+ *
+ * Author	Karsten Keil <kkeil@novell.com>
+ *
+ * Copyright 2008  by Karsten Keil <kkeil@novell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include "fsm.h"
+#include "layer2.h"
+
+static int *debug;
+
+static
+struct Fsm l2fsm = {NULL, 0, 0, NULL, NULL};
+
+static char *strL2State[] =
+{
+	"ST_L2_1",
+	"ST_L2_2",
+	"ST_L2_3",
+	"ST_L2_4",
+	"ST_L2_5",
+	"ST_L2_6",
+	"ST_L2_7",
+	"ST_L2_8",
+};
+
+enum {
+	EV_L2_UI,
+	EV_L2_SABME,
+	EV_L2_DISC,
+	EV_L2_DM,
+	EV_L2_UA,
+	EV_L2_FRMR,
+	EV_L2_SUPER,
+	EV_L2_I,
+	EV_L2_DL_DATA,
+	EV_L2_ACK_PULL,
+	EV_L2_DL_UNITDATA,
+	EV_L2_DL_ESTABLISH_REQ,
+	EV_L2_DL_RELEASE_REQ,
+	EV_L2_MDL_ASSIGN,
+	EV_L2_MDL_REMOVE,
+	EV_L2_MDL_ERROR,
+	EV_L1_DEACTIVATE,
+	EV_L2_T200,
+	EV_L2_T203,
+	EV_L2_SET_OWN_BUSY,
+	EV_L2_CLEAR_OWN_BUSY,
+	EV_L2_FRAME_ERROR,
+};
+
+#define L2_EVENT_COUNT (EV_L2_FRAME_ERROR+1)
+
+static char *strL2Event[] =
+{
+	"EV_L2_UI",
+	"EV_L2_SABME",
+	"EV_L2_DISC",
+	"EV_L2_DM",
+	"EV_L2_UA",
+	"EV_L2_FRMR",
+	"EV_L2_SUPER",
+	"EV_L2_I",
+	"EV_L2_DL_DATA",
+	"EV_L2_ACK_PULL",
+	"EV_L2_DL_UNITDATA",
+	"EV_L2_DL_ESTABLISH_REQ",
+	"EV_L2_DL_RELEASE_REQ",
+	"EV_L2_MDL_ASSIGN",
+	"EV_L2_MDL_REMOVE",
+	"EV_L2_MDL_ERROR",
+	"EV_L1_DEACTIVATE",
+	"EV_L2_T200",
+	"EV_L2_T203",
+	"EV_L2_SET_OWN_BUSY",
+	"EV_L2_CLEAR_OWN_BUSY",
+	"EV_L2_FRAME_ERROR",
+};
+
+static void
+l2m_debug(struct FsmInst *fi, char *fmt, ...)
+{
+	struct layer2 *l2 = fi->userdata;
+	va_list va;
+
+	if (!(*debug & DEBUG_L2_FSM))
+		return;
+	va_start(va, fmt);
+	printk(KERN_DEBUG "l2 (tei %d): ", l2->tei);
+	vprintk(fmt, va);
+	printk("\n");
+	va_end(va);
+}
+
+inline u_int
+l2headersize(struct layer2 *l2, int ui)
+{
+	return ((test_bit(FLG_MOD128, &l2->flag) && (!ui)) ? 2 : 1) +
+		(test_bit(FLG_LAPD, &l2->flag) ? 2 : 1);
+}
+
+inline u_int
+l2addrsize(struct layer2 *l2)
+{
+	return test_bit(FLG_LAPD, &l2->flag) ? 2 : 1;
+}
+
+static u_int
+l2_newid(struct layer2 *l2)
+{
+	u_int	id;
+
+	id = l2->next_id++;
+	if (id == 0x7fff)
+		l2->next_id = 1;
+	id <<= 16;
+	id |= l2->tei << 8;
+	id |= l2->sapi;
+	return id;
+}
+
+static void
+l2up(struct layer2 *l2, u_int prim, struct sk_buff *skb)
+{
+	int	err;
+
+	if (!l2->up)
+		return;
+	mISDN_HEAD_PRIM(skb) = prim;
+	mISDN_HEAD_ID(skb) = (l2->ch.nr << 16) | l2->ch.addr;
+	err = l2->up->send(l2->up, skb);
+	if (err) {
+		printk(KERN_WARNING "%s: err=%d\n", __func__, err);
+		dev_kfree_skb(skb);
+	}
+}
+
+static void
+l2up_create(struct layer2 *l2, u_int prim, int len, void *arg)
+{
+	struct sk_buff	*skb;
+	struct mISDNhead *hh;
+	int		err;
+
+	if (!l2->up)
+		return;
+	skb = mI_alloc_skb(len, GFP_ATOMIC);
+	if (!skb)
+		return;
+	hh = mISDN_HEAD_P(skb);
+	hh->prim = prim;
+	hh->id = (l2->ch.nr << 16) | l2->ch.addr;
+	if (len)
+		memcpy(skb_put(skb, len), arg, len);
+	err = l2->up->send(l2->up, skb);
+	if (err) {
+		printk(KERN_WARNING "%s: err=%d\n", __func__, err);
+		dev_kfree_skb(skb);
+	}
+}
+
+static int
+l2down_skb(struct layer2 *l2, struct sk_buff *skb) {
+	int ret;
+
+	ret = l2->ch.recv(l2->ch.peer, skb);
+	if (ret && (*debug & DEBUG_L2_RECV))
+		printk(KERN_DEBUG "l2down_skb: ret(%d)\n", ret);
+	return ret;
+}
+
+static int
+l2down_raw(struct layer2 *l2, struct sk_buff *skb)
+{
+	struct mISDNhead *hh = mISDN_HEAD_P(skb);
+
+	if (hh->prim == PH_DATA_REQ) {
+		if (test_and_set_bit(FLG_L1_NOTREADY, &l2->flag)) {
+			skb_queue_tail(&l2->down_queue, skb);
+			return 0;
+		}
+		l2->down_id = mISDN_HEAD_ID(skb);
+	}
+	return l2down_skb(l2, skb);
+}
+
+static int
+l2down(struct layer2 *l2, u_int prim, u_int id, struct sk_buff *skb)
+{
+	struct mISDNhead *hh = mISDN_HEAD_P(skb);
+
+	hh->prim = prim;
+	hh->id = id;
+	return l2down_raw(l2, skb);
+}
+
+static int
+l2down_create(struct layer2 *l2, u_int prim, u_int id, int len, void *arg)
+{
+	struct sk_buff	*skb;
+	int		err;
+	struct mISDNhead *hh;
+
+	skb = mI_alloc_skb(len, GFP_ATOMIC);
+	if (!skb)
+		return -ENOMEM;
+	hh = mISDN_HEAD_P(skb);
+	hh->prim = prim;
+	hh->id = id;
+	if (len)
+		memcpy(skb_put(skb, len), arg, len);
+	err = l2down_raw(l2, skb);
+	if (err)
+		dev_kfree_skb(skb);
+	return err;
+}
+
+static int
+ph_data_confirm(struct layer2 *l2, struct mISDNhead *hh, struct sk_buff *skb) {
+	struct sk_buff *nskb = skb;
+	int ret = -EAGAIN;
+
+	if (test_bit(FLG_L1_NOTREADY, &l2->flag)) {
+		if (hh->id == l2->down_id) {
+			nskb = skb_dequeue(&l2->down_queue);
+			if (nskb) {
+				l2->down_id = mISDN_HEAD_ID(nskb);
+				if (l2down_skb(l2, nskb)) {
+					dev_kfree_skb(nskb);
+					l2->down_id = MISDN_ID_NONE;
+				}
+			} else
+				l2->down_id = MISDN_ID_NONE;
+			if (ret) {
+				dev_kfree_skb(skb);
+				ret = 0;
+			}
+			if (l2->down_id == MISDN_ID_NONE) {
+				test_and_clear_bit(FLG_L1_NOTREADY, &l2->flag);
+				mISDN_FsmEvent(&l2->l2m, EV_L2_ACK_PULL, NULL);
+			}
+		}
+	}
+	if (!test_and_set_bit(FLG_L1_NOTREADY, &l2->flag)) {
+		nskb = skb_dequeue(&l2->down_queue);
+		if (nskb) {
+			l2->down_id = mISDN_HEAD_ID(nskb);
+			if (l2down_skb(l2, nskb)) {
+				dev_kfree_skb(nskb);
+				l2->down_id = MISDN_ID_NONE;
+				test_and_clear_bit(FLG_L1_NOTREADY, &l2->flag);
+			}
+		} else
+			test_and_clear_bit(FLG_L1_NOTREADY, &l2->flag);
+	}
+	return ret;
+}
+
+static int
+l2mgr(struct layer2 *l2, u_int prim, void *arg) {
+	long c = (long)arg;
+
+	printk(KERN_WARNING
+	    "l2mgr: addr:%x prim %x %c\n", l2->id, prim, (char)c);
+	if (test_bit(FLG_LAPD, &l2->flag) &&
+		!test_bit(FLG_FIXED_TEI, &l2->flag)) {
+		switch (c) {
+		case 'C':
+		case 'D':
+		case 'G':
+		case 'H':
+			l2_tei(l2, prim, (u_long)arg);
+			break;
+		}
+	}
+	return 0;
+}
+
+static void
+set_peer_busy(struct layer2 *l2) {
+	test_and_set_bit(FLG_PEER_BUSY, &l2->flag);
+	if (skb_queue_len(&l2->i_queue) || skb_queue_len(&l2->ui_queue))
+		test_and_set_bit(FLG_L2BLOCK, &l2->flag);
+}
+
+static void
+clear_peer_busy(struct layer2 *l2) {
+	if (test_and_clear_bit(FLG_PEER_BUSY, &l2->flag))
+		test_and_clear_bit(FLG_L2BLOCK, &l2->flag);
+}
+
+static void
+InitWin(struct layer2 *l2)
+{
+	int i;
+
+	for (i = 0; i < MAX_WINDOW; i++)
+		l2->windowar[i] = NULL;
+}
+
+static int
+freewin(struct layer2 *l2)
+{
+	int i, cnt = 0;
+
+	for (i = 0; i < MAX_WINDOW; i++) {
+		if (l2->windowar[i]) {
+			cnt++;
+			dev_kfree_skb(l2->windowar[i]);
+			l2->windowar[i] = NULL;
+		}
+	}
+	return cnt;
+}
+
+static void
+ReleaseWin(struct layer2 *l2)
+{
+	int cnt = freewin(l2);
+
+	if (cnt)
+		printk(KERN_WARNING
+		    "isdnl2 freed %d skbuffs in release\n", cnt);
+}
+
+inline unsigned int
+cansend(struct layer2 *l2)
+{
+	unsigned int p1;
+
+	if (test_bit(FLG_MOD128, &l2->flag))
+		p1 = (l2->vs - l2->va) % 128;
+	else
+		p1 = (l2->vs - l2->va) % 8;
+	return (p1 < l2->window) && !test_bit(FLG_PEER_BUSY, &l2->flag);
+}
+
+inline void
+clear_exception(struct layer2 *l2)
+{
+	test_and_clear_bit(FLG_ACK_PEND, &l2->flag);
+	test_and_clear_bit(FLG_REJEXC, &l2->flag);
+	test_and_clear_bit(FLG_OWN_BUSY, &l2->flag);
+	clear_peer_busy(l2);
+}
+
+static int
+sethdraddr(struct layer2 *l2, u_char *header, int rsp)
+{
+	u_char *ptr = header;
+	int crbit = rsp;
+
+	if (test_bit(FLG_LAPD, &l2->flag)) {
+		if (test_bit(FLG_LAPD_NET, &l2->flag))
+			crbit = !crbit;
+		*ptr++ = (l2->sapi << 2) | (crbit ? 2 : 0);
+		*ptr++ = (l2->tei << 1) | 1;
+		return 2;
+	} else {
+		if (test_bit(FLG_ORIG, &l2->flag))
+			crbit = !crbit;
+		if (crbit)
+			*ptr++ = l2->addr.B;
+		else
+			*ptr++ = l2->addr.A;
+		return 1;
+	}
+}
+
+static inline void
+enqueue_super(struct layer2 *l2, struct sk_buff *skb)
+{
+	if (l2down(l2, PH_DATA_REQ, l2_newid(l2), skb))
+		dev_kfree_skb(skb);
+}
+
+static inline void
+enqueue_ui(struct layer2 *l2, struct sk_buff *skb)
+{
+	if (l2->tm)
+		l2_tei(l2, MDL_STATUS_UI_IND, 0);
+	if (l2down(l2, PH_DATA_REQ, l2_newid(l2), skb))
+		dev_kfree_skb(skb);
+}
+
+inline int
+IsUI(u_char *data)
+{
+	return (data[0] & 0xef) == UI;
+}
+
+inline int
+IsUA(u_char *data)
+{
+	return (data[0] & 0xef) == UA;
+}
+
+inline int
+IsDM(u_char *data)
+{
+	return (data[0] & 0xef) == DM;
+}
+
+inline int
+IsDISC(u_char *data)
+{
+	return (data[0] & 0xef) == DISC;
+}
+
+inline int
+IsRR(u_char *data, struct layer2 *l2)
+{
+	if (test_bit(FLG_MOD128, &l2->flag))
+		return data[0] == RR;
+	else
+		return (data[0] & 0xf) == 1;
+}
+
+inline int
+IsSFrame(u_char *data, struct layer2 *l2)
+{
+	register u_char d = *data;
+
+	if (!test_bit(FLG_MOD128, &l2->flag))
+		d &= 0xf;
+	return ((d & 0xf3) == 1) && ((d & 0x0c) != 0x0c);
+}
+
+inline int
+IsSABME(u_char *data, struct layer2 *l2)
+{
+	u_char d = data[0] & ~0x10;
+
+	return test_bit(FLG_MOD128, &l2->flag) ? d == SABME : d == SABM;
+}
+
+inline int
+IsREJ(u_char *data, struct layer2 *l2)
+{
+	return test_bit(FLG_MOD128, &l2->flag) ?
+		data[0] == REJ : (data[0] & 0xf) == REJ;
+}
+
+inline int
+IsFRMR(u_char *data)
+{
+	return (data[0] & 0xef) == FRMR;
+}
+
+inline int
+IsRNR(u_char *data, struct layer2 *l2)
+{
+	return test_bit(FLG_MOD128, &l2->flag) ?
+	    data[0] == RNR : (data[0] & 0xf) == RNR;
+}
+
+int
+iframe_error(struct layer2 *l2, struct sk_buff *skb)
+{
+	u_int	i;
+	int	rsp = *skb->data & 0x2;
+
+	i = l2addrsize(l2) + (test_bit(FLG_MOD128, &l2->flag) ? 2 : 1);
+	if (test_bit(FLG_ORIG, &l2->flag))
+		rsp = !rsp;
+	if (rsp)
+		return 'L';
+	if (skb->len < i)
+		return 'N';
+	if ((skb->len - i) > l2->maxlen)
+		return 'O';
+	return 0;
+}
+
+int
+super_error(struct layer2 *l2, struct sk_buff *skb)
+{
+	if (skb->len != l2addrsize(l2) +
+	    (test_bit(FLG_MOD128, &l2->flag) ? 2 : 1))
+		return 'N';
+	return 0;
+}
+
+int
+unnum_error(struct layer2 *l2, struct sk_buff *skb, int wantrsp)
+{
+	int rsp = (*skb->data & 0x2) >> 1;
+	if (test_bit(FLG_ORIG, &l2->flag))
+		rsp = !rsp;
+	if (rsp != wantrsp)
+		return 'L';
+	if (skb->len != l2addrsize(l2) + 1)
+		return 'N';
+	return 0;
+}
+
+int
+UI_error(struct layer2 *l2, struct sk_buff *skb)
+{
+	int rsp = *skb->data & 0x2;
+	if (test_bit(FLG_ORIG, &l2->flag))
+		rsp = !rsp;
+	if (rsp)
+		return 'L';
+	if (skb->len > l2->maxlen + l2addrsize(l2) + 1)
+		return 'O';
+	return 0;
+}
+
+int
+FRMR_error(struct layer2 *l2, struct sk_buff *skb)
+{
+	u_int	headers = l2addrsize(l2) + 1;
+	u_char	*datap = skb->data + headers;
+	int	rsp = *skb->data & 0x2;
+
+	if (test_bit(FLG_ORIG, &l2->flag))
+		rsp = !rsp;
+	if (!rsp)
+		return 'L';
+	if (test_bit(FLG_MOD128, &l2->flag)) {
+		if (skb->len < headers + 5)
+			return 'N';
+		else if (*debug & DEBUG_L2)
+			l2m_debug(&l2->l2m,
+			    "FRMR information %2x %2x %2x %2x %2x",
+			    datap[0], datap[1], datap[2], datap[3], datap[4]);
+	} else {
+		if (skb->len < headers + 3)
+			return 'N';
+		else if (*debug & DEBUG_L2)
+			l2m_debug(&l2->l2m,
+			    "FRMR information %2x %2x %2x",
+			    datap[0], datap[1], datap[2]);
+	}
+	return 0;
+}
+
+static unsigned int
+legalnr(struct layer2 *l2, unsigned int nr)
+{
+	if (test_bit(FLG_MOD128, &l2->flag))
+		return ((nr - l2->va) % 128) <= ((l2->vs - l2->va) % 128);
+	else
+		return ((nr - l2->va) % 8) <= ((l2->vs - l2->va) % 8);
+}
+
+static void
+setva(struct layer2 *l2, unsigned int nr)
+{
+	struct sk_buff	*skb;
+
+	while (l2->va != nr) {
+		l2->va++;
+		if (test_bit(FLG_MOD128, &l2->flag))
+			l2->va %= 128;
+		else
+			l2->va %= 8;
+		if (l2->windowar[l2->sow]) {
+			skb_trim(l2->windowar[l2->sow], 0);
+			skb_queue_tail(&l2->tmp_queue, l2->windowar[l2->sow]);
+			l2->windowar[l2->sow] = NULL;
+		}
+		l2->sow = (l2->sow + 1) % l2->window;
+	}
+	skb = skb_dequeue(&l2->tmp_queue);
+	while (skb) {
+		dev_kfree_skb(skb);
+		skb = skb_dequeue(&l2->tmp_queue);
+	}
+}
+
+static void
+send_uframe(struct layer2 *l2, struct sk_buff *skb, u_char cmd, u_char cr)
+{
+	u_char tmp[MAX_L2HEADER_LEN];
+	int i;
+
+	i = sethdraddr(l2, tmp, cr);
+	tmp[i++] = cmd;
+	if (skb)
+		skb_trim(skb, 0);
+	else {
+		skb = mI_alloc_skb(i, GFP_ATOMIC);
+		if (!skb) {
+			printk(KERN_WARNING "%s: can't alloc skbuff\n",
+				__func__);
+			return;
+		}
+	}
+	memcpy(skb_put(skb, i), tmp, i);
+	enqueue_super(l2, skb);
+}
+
+
+inline u_char
+get_PollFlag(struct layer2 *l2, struct sk_buff *skb)
+{
+	return skb->data[l2addrsize(l2)] & 0x10;
+}
+
+inline u_char
+get_PollFlagFree(struct layer2 *l2, struct sk_buff *skb)
+{
+	u_char PF;
+
+	PF = get_PollFlag(l2, skb);
+	dev_kfree_skb(skb);
+	return PF;
+}
+
+inline void
+start_t200(struct layer2 *l2, int i)
+{
+	mISDN_FsmAddTimer(&l2->t200, l2->T200, EV_L2_T200, NULL, i);
+	test_and_set_bit(FLG_T200_RUN, &l2->flag);
+}
+
+inline void
+restart_t200(struct layer2 *l2, int i)
+{
+	mISDN_FsmRestartTimer(&l2->t200, l2->T200, EV_L2_T200, NULL, i);
+	test_and_set_bit(FLG_T200_RUN, &l2->flag);
+}
+
+inline void
+stop_t200(struct layer2 *l2, int i)
+{
+	if (test_and_clear_bit(FLG_T200_RUN, &l2->flag))
+		mISDN_FsmDelTimer(&l2->t200, i);
+}
+
+inline void
+st5_dl_release_l2l3(struct layer2 *l2)
+{
+	int pr;
+
+	if (test_and_clear_bit(FLG_PEND_REL, &l2->flag))
+		pr = DL_RELEASE_CNF;
+	else
+		pr = DL_RELEASE_IND;
+	l2up_create(l2, pr, 0, NULL);
+}
+
+inline void
+lapb_dl_release_l2l3(struct layer2 *l2, int f)
+{
+	if (test_bit(FLG_LAPB, &l2->flag))
+		l2down_create(l2, PH_DEACTIVATE_REQ, l2_newid(l2), 0, NULL);
+	l2up_create(l2, f, 0, NULL);
+}
+
+static void
+establishlink(struct FsmInst *fi)
+{
+	struct layer2 *l2 = fi->userdata;
+	u_char cmd;
+
+	clear_exception(l2);
+	l2->rc = 0;
+	cmd = (test_bit(FLG_MOD128, &l2->flag) ? SABME : SABM) | 0x10;
+	send_uframe(l2, NULL, cmd, CMD);
+	mISDN_FsmDelTimer(&l2->t203, 1);
+	restart_t200(l2, 1);
+	test_and_clear_bit(FLG_PEND_REL, &l2->flag);
+	freewin(l2);
+	mISDN_FsmChangeState(fi, ST_L2_5);
+}
+
+static void
+l2_mdl_error_ua(struct FsmInst *fi, int event, void *arg)
+{
+	struct sk_buff *skb = arg;
+	struct layer2 *l2 = fi->userdata;
+
+	if (get_PollFlagFree(l2, skb))
+		l2mgr(l2, MDL_ERROR_IND, (void *) 'C');
+	else
+		l2mgr(l2, MDL_ERROR_IND, (void *) 'D');
+
+}
+
+static void
+l2_mdl_error_dm(struct FsmInst *fi, int event, void *arg)
+{
+	struct sk_buff *skb = arg;
+	struct layer2 *l2 = fi->userdata;
+
+	if (get_PollFlagFree(l2, skb))
+		l2mgr(l2, MDL_ERROR_IND, (void *) 'B');
+	else {
+		l2mgr(l2, MDL_ERROR_IND, (void *) 'E');
+		establishlink(fi);
+		test_and_clear_bit(FLG_L3_INIT, &l2->flag);
+	}
+}
+
+static void
+l2_st8_mdl_error_dm(struct FsmInst *fi, int event, void *arg)
+{
+	struct sk_buff *skb = arg;
+	struct layer2 *l2 = fi->userdata;
+
+	if (get_PollFlagFree(l2, skb))
+		l2mgr(l2, MDL_ERROR_IND, (void *) 'B');
+	else
+		l2mgr(l2, MDL_ERROR_IND, (void *) 'E');
+	establishlink(fi);
+	test_and_clear_bit(FLG_L3_INIT, &l2->flag);
+}
+
+static void
+l2_go_st3(struct FsmInst *fi, int event, void *arg)
+{
+	dev_kfree_skb((struct sk_buff *)arg);
+	mISDN_FsmChangeState(fi, ST_L2_3);
+}
+
+static void
+l2_mdl_assign(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2	*l2 = fi->userdata;
+
+	mISDN_FsmChangeState(fi, ST_L2_3);
+	dev_kfree_skb((struct sk_buff *)arg);
+	l2_tei(l2, MDL_ASSIGN_IND, 0);
+}
+
+static void
+l2_queue_ui_assign(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+	struct sk_buff *skb = arg;
+
+	skb_queue_tail(&l2->ui_queue, skb);
+	mISDN_FsmChangeState(fi, ST_L2_2);
+	l2_tei(l2, MDL_ASSIGN_IND, 0);
+}
+
+static void
+l2_queue_ui(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+	struct sk_buff *skb = arg;
+
+	skb_queue_tail(&l2->ui_queue, skb);
+}
+
+static void
+tx_ui(struct layer2 *l2)
+{
+	struct sk_buff *skb;
+	u_char header[MAX_L2HEADER_LEN];
+	int i;
+
+	i = sethdraddr(l2, header, CMD);
+	if (test_bit(FLG_LAPD_NET, &l2->flag))
+		header[1] = 0xff; /* tei 127 */
+	header[i++] = UI;
+	while ((skb = skb_dequeue(&l2->ui_queue))) {
+		memcpy(skb_push(skb, i), header, i);
+		enqueue_ui(l2, skb);
+	}
+}
+
+static void
+l2_send_ui(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+	struct sk_buff *skb = arg;
+
+	skb_queue_tail(&l2->ui_queue, skb);
+	tx_ui(l2);
+}
+
+static void
+l2_got_ui(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+	struct sk_buff *skb = arg;
+
+	skb_pull(skb, l2headersize(l2, 1));
+/*
+ *		in states 1-3 for broadcast
+ */
+
+	if (l2->tm)
+		l2_tei(l2, MDL_STATUS_UI_IND, 0);
+	l2up(l2, DL_UNITDATA_IND, skb);
+}
+
+static void
+l2_establish(struct FsmInst *fi, int event, void *arg)
+{
+	struct sk_buff *skb = arg;
+	struct layer2 *l2 = fi->userdata;
+
+	establishlink(fi);
+	test_and_set_bit(FLG_L3_INIT, &l2->flag);
+	dev_kfree_skb(skb);
+}
+
+static void
+l2_discard_i_setl3(struct FsmInst *fi, int event, void *arg)
+{
+	struct sk_buff *skb = arg;
+	struct layer2 *l2 = fi->userdata;
+
+	skb_queue_purge(&l2->i_queue);
+	test_and_set_bit(FLG_L3_INIT, &l2->flag);
+	test_and_clear_bit(FLG_PEND_REL, &l2->flag);
+	dev_kfree_skb(skb);
+}
+
+static void
+l2_l3_reestablish(struct FsmInst *fi, int event, void *arg)
+{
+	struct sk_buff *skb = arg;
+	struct layer2 *l2 = fi->userdata;
+
+	skb_queue_purge(&l2->i_queue);
+	establishlink(fi);
+	test_and_set_bit(FLG_L3_INIT, &l2->flag);
+	dev_kfree_skb(skb);
+}
+
+static void
+l2_release(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+	struct sk_buff *skb = arg;
+
+	skb_trim(skb, 0);
+	l2up(l2, DL_RELEASE_CNF, skb);
+}
+
+static void
+l2_pend_rel(struct FsmInst *fi, int event, void *arg)
+{
+	struct sk_buff *skb = arg;
+	struct layer2 *l2 = fi->userdata;
+
+	test_and_set_bit(FLG_PEND_REL, &l2->flag);
+	dev_kfree_skb(skb);
+}
+
+static void
+l2_disconnect(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+	struct sk_buff *skb = arg;
+
+	skb_queue_purge(&l2->i_queue);
+	freewin(l2);
+	mISDN_FsmChangeState(fi, ST_L2_6);
+	l2->rc = 0;
+	send_uframe(l2, NULL, DISC | 0x10, CMD);
+	mISDN_FsmDelTimer(&l2->t203, 1);
+	restart_t200(l2, 2);
+	if (skb)
+		dev_kfree_skb(skb);
+}
+
+static void
+l2_start_multi(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2	*l2 = fi->userdata;
+	struct sk_buff	*skb = arg;
+
+	l2->vs = 0;
+	l2->va = 0;
+	l2->vr = 0;
+	l2->sow = 0;
+	clear_exception(l2);
+	send_uframe(l2, NULL, UA | get_PollFlag(l2, skb), RSP);
+	mISDN_FsmChangeState(fi, ST_L2_7);
+	mISDN_FsmAddTimer(&l2->t203, l2->T203, EV_L2_T203, NULL, 3);
+	skb_trim(skb, 0);
+	l2up(l2, DL_ESTABLISH_IND, skb);
+	if (l2->tm)
+		l2_tei(l2, MDL_STATUS_UP_IND, 0);
+}
+
+static void
+l2_send_UA(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+	struct sk_buff *skb = arg;
+
+	send_uframe(l2, skb, UA | get_PollFlag(l2, skb), RSP);
+}
+
+static void
+l2_send_DM(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+	struct sk_buff *skb = arg;
+
+	send_uframe(l2, skb, DM | get_PollFlag(l2, skb), RSP);
+}
+
+static void
+l2_restart_multi(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2	*l2 = fi->userdata;
+	struct sk_buff	*skb = arg;
+	int		est = 0;
+
+	send_uframe(l2, skb, UA | get_PollFlag(l2, skb), RSP);
+
+	l2mgr(l2, MDL_ERROR_IND, (void *) 'F');
+
+	if (l2->vs != l2->va) {
+		skb_queue_purge(&l2->i_queue);
+		est = 1;
+	}
+
+	clear_exception(l2);
+	l2->vs = 0;
+	l2->va = 0;
+	l2->vr = 0;
+	l2->sow = 0;
+	mISDN_FsmChangeState(fi, ST_L2_7);
+	stop_t200(l2, 3);
+	mISDN_FsmRestartTimer(&l2->t203, l2->T203, EV_L2_T203, NULL, 3);
+
+	if (est)
+		l2up_create(l2, DL_ESTABLISH_IND, 0, NULL);
+/*		mISDN_queue_data(&l2->inst, l2->inst.id | MSG_BROADCAST,
+ *		    MGR_SHORTSTATUS | INDICATION, SSTATUS_L2_ESTABLISHED,
+ *		    0, NULL, 0);
+ */
+	if (skb_queue_len(&l2->i_queue) && cansend(l2))
+		mISDN_FsmEvent(fi, EV_L2_ACK_PULL, NULL);
+}
+
+static void
+l2_stop_multi(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2	*l2 = fi->userdata;
+	struct sk_buff	*skb = arg;
+
+	mISDN_FsmChangeState(fi, ST_L2_4);
+	mISDN_FsmDelTimer(&l2->t203, 3);
+	stop_t200(l2, 4);
+
+	send_uframe(l2, skb, UA | get_PollFlag(l2, skb), RSP);
+	skb_queue_purge(&l2->i_queue);
+	freewin(l2);
+	lapb_dl_release_l2l3(l2, DL_RELEASE_IND);
+	if (l2->tm)
+		l2_tei(l2, MDL_STATUS_DOWN_IND, 0);
+}
+
+static void
+l2_connected(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2	*l2 = fi->userdata;
+	struct sk_buff	*skb = arg;
+	int pr = -1;
+
+	if (!get_PollFlag(l2, skb)) {
+		l2_mdl_error_ua(fi, event, arg);
+		return;
+	}
+	dev_kfree_skb(skb);
+	if (test_and_clear_bit(FLG_PEND_REL, &l2->flag))
+		l2_disconnect(fi, event, NULL);
+	if (test_and_clear_bit(FLG_L3_INIT, &l2->flag)) {
+		pr = DL_ESTABLISH_CNF;
+	} else if (l2->vs != l2->va) {
+		skb_queue_purge(&l2->i_queue);
+		pr = DL_ESTABLISH_IND;
+	}
+	stop_t200(l2, 5);
+	l2->vr = 0;
+	l2->vs = 0;
+	l2->va = 0;
+	l2->sow = 0;
+	mISDN_FsmChangeState(fi, ST_L2_7);
+	mISDN_FsmAddTimer(&l2->t203, l2->T203, EV_L2_T203, NULL, 4);
+	if (pr != -1)
+		l2up_create(l2, pr, 0, NULL);
+
+	if (skb_queue_len(&l2->i_queue) && cansend(l2))
+		mISDN_FsmEvent(fi, EV_L2_ACK_PULL, NULL);
+
+	if (l2->tm)
+		l2_tei(l2, MDL_STATUS_UP_IND, 0);
+}
+
+static void
+l2_released(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+	struct sk_buff *skb = arg;
+
+	if (!get_PollFlag(l2, skb)) {
+		l2_mdl_error_ua(fi, event, arg);
+		return;
+	}
+	dev_kfree_skb(skb);
+	stop_t200(l2, 6);
+	lapb_dl_release_l2l3(l2, DL_RELEASE_CNF);
+	mISDN_FsmChangeState(fi, ST_L2_4);
+	if (l2->tm)
+		l2_tei(l2, MDL_STATUS_DOWN_IND, 0);
+}
+
+static void
+l2_reestablish(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+	struct sk_buff *skb = arg;
+
+	if (!get_PollFlagFree(l2, skb)) {
+		establishlink(fi);
+		test_and_set_bit(FLG_L3_INIT, &l2->flag);
+	}
+}
+
+static void
+l2_st5_dm_release(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+	struct sk_buff *skb = arg;
+
+	if (get_PollFlagFree(l2, skb)) {
+		stop_t200(l2, 7);
+		if (!test_bit(FLG_L3_INIT, &l2->flag))
+			skb_queue_purge(&l2->i_queue);
+		if (test_bit(FLG_LAPB, &l2->flag))
+			l2down_create(l2, PH_DEACTIVATE_REQ,
+				l2_newid(l2), 0, NULL);
+		st5_dl_release_l2l3(l2);
+		mISDN_FsmChangeState(fi, ST_L2_4);
+		if (l2->tm)
+			l2_tei(l2, MDL_STATUS_DOWN_IND, 0);
+	}
+}
+
+static void
+l2_st6_dm_release(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+	struct sk_buff *skb = arg;
+
+	if (get_PollFlagFree(l2, skb)) {
+		stop_t200(l2, 8);
+		lapb_dl_release_l2l3(l2, DL_RELEASE_CNF);
+		mISDN_FsmChangeState(fi, ST_L2_4);
+		if (l2->tm)
+			l2_tei(l2, MDL_STATUS_DOWN_IND, 0);
+	}
+}
+
+void
+enquiry_cr(struct layer2 *l2, u_char typ, u_char cr, u_char pf)
+{
+	struct sk_buff *skb;
+	u_char tmp[MAX_L2HEADER_LEN];
+	int i;
+
+	i = sethdraddr(l2, tmp, cr);
+	if (test_bit(FLG_MOD128, &l2->flag)) {
+		tmp[i++] = typ;
+		tmp[i++] = (l2->vr << 1) | (pf ? 1 : 0);
+	} else
+		tmp[i++] = (l2->vr << 5) | typ | (pf ? 0x10 : 0);
+	skb = mI_alloc_skb(i, GFP_ATOMIC);
+	if (!skb) {
+		printk(KERN_WARNING
+		    "isdnl2 can't alloc sbbuff for enquiry_cr\n");
+		return;
+	}
+	memcpy(skb_put(skb, i), tmp, i);
+	enqueue_super(l2, skb);
+}
+
+inline void
+enquiry_response(struct layer2 *l2)
+{
+	if (test_bit(FLG_OWN_BUSY, &l2->flag))
+		enquiry_cr(l2, RNR, RSP, 1);
+	else
+		enquiry_cr(l2, RR, RSP, 1);
+	test_and_clear_bit(FLG_ACK_PEND, &l2->flag);
+}
+
+inline void
+transmit_enquiry(struct layer2 *l2)
+{
+	if (test_bit(FLG_OWN_BUSY, &l2->flag))
+		enquiry_cr(l2, RNR, CMD, 1);
+	else
+		enquiry_cr(l2, RR, CMD, 1);
+	test_and_clear_bit(FLG_ACK_PEND, &l2->flag);
+	start_t200(l2, 9);
+}
+
+
+static void
+nrerrorrecovery(struct FsmInst *fi)
+{
+	struct layer2 *l2 = fi->userdata;
+
+	l2mgr(l2, MDL_ERROR_IND, (void *) 'J');
+	establishlink(fi);
+	test_and_clear_bit(FLG_L3_INIT, &l2->flag);
+}
+
+static void
+invoke_retransmission(struct layer2 *l2, unsigned int nr)
+{
+	u_int	p1;
+
+	if (l2->vs != nr) {
+		while (l2->vs != nr) {
+			(l2->vs)--;
+			if (test_bit(FLG_MOD128, &l2->flag)) {
+				l2->vs %= 128;
+				p1 = (l2->vs - l2->va) % 128;
+			} else {
+				l2->vs %= 8;
+				p1 = (l2->vs - l2->va) % 8;
+			}
+			p1 = (p1 + l2->sow) % l2->window;
+			if (l2->windowar[p1])
+				skb_queue_head(&l2->i_queue, l2->windowar[p1]);
+			else
+				printk(KERN_WARNING
+				    "%s: windowar[%d] is NULL\n",
+				    __func__, p1);
+			l2->windowar[p1] = NULL;
+		}
+		mISDN_FsmEvent(&l2->l2m, EV_L2_ACK_PULL, NULL);
+	}
+}
+
+static void
+l2_st7_got_super(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+	struct sk_buff *skb = arg;
+	int PollFlag, rsp, typ = RR;
+	unsigned int nr;
+
+	rsp = *skb->data & 0x2;
+	if (test_bit(FLG_ORIG, &l2->flag))
+		rsp = !rsp;
+
+	skb_pull(skb, l2addrsize(l2));
+	if (IsRNR(skb->data, l2)) {
+		set_peer_busy(l2);
+		typ = RNR;
+	} else
+		clear_peer_busy(l2);
+	if (IsREJ(skb->data, l2))
+		typ = REJ;
+
+	if (test_bit(FLG_MOD128, &l2->flag)) {
+		PollFlag = (skb->data[1] & 0x1) == 0x1;
+		nr = skb->data[1] >> 1;
+	} else {
+		PollFlag = (skb->data[0] & 0x10);
+		nr = (skb->data[0] >> 5) & 0x7;
+	}
+	dev_kfree_skb(skb);
+
+	if (PollFlag) {
+		if (rsp)
+			l2mgr(l2, MDL_ERROR_IND, (void *) 'A');
+		else
+			enquiry_response(l2);
+	}
+	if (legalnr(l2, nr)) {
+		if (typ == REJ) {
+			setva(l2, nr);
+			invoke_retransmission(l2, nr);
+			stop_t200(l2, 10);
+			if (mISDN_FsmAddTimer(&l2->t203, l2->T203,
+					EV_L2_T203, NULL, 6))
+				l2m_debug(&l2->l2m, "Restart T203 ST7 REJ");
+		} else if ((nr == l2->vs) && (typ == RR)) {
+			setva(l2, nr);
+			stop_t200(l2, 11);
+			mISDN_FsmRestartTimer(&l2->t203, l2->T203,
+					EV_L2_T203, NULL, 7);
+		} else if ((l2->va != nr) || (typ == RNR)) {
+			setva(l2, nr);
+			if (typ != RR)
+				mISDN_FsmDelTimer(&l2->t203, 9);
+			restart_t200(l2, 12);
+		}
+		if (skb_queue_len(&l2->i_queue) && (typ == RR))
+			mISDN_FsmEvent(fi, EV_L2_ACK_PULL, NULL);
+	} else
+		nrerrorrecovery(fi);
+}
+
+static void
+l2_feed_i_if_reest(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+	struct sk_buff *skb = arg;
+
+	if (!test_bit(FLG_L3_INIT, &l2->flag))
+		skb_queue_tail(&l2->i_queue, skb);
+	else
+		dev_kfree_skb(skb);
+}
+
+static void
+l2_feed_i_pull(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+	struct sk_buff *skb = arg;
+
+	skb_queue_tail(&l2->i_queue, skb);
+	mISDN_FsmEvent(fi, EV_L2_ACK_PULL, NULL);
+}
+
+static void
+l2_feed_iqueue(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+	struct sk_buff *skb = arg;
+
+	skb_queue_tail(&l2->i_queue, skb);
+}
+
+static void
+l2_got_iframe(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2	*l2 = fi->userdata;
+	struct sk_buff	*skb = arg;
+	int		PollFlag, i;
+	u_int		ns, nr;
+
+	i = l2addrsize(l2);
+	if (test_bit(FLG_MOD128, &l2->flag)) {
+		PollFlag = ((skb->data[i + 1] & 0x1) == 0x1);
+		ns = skb->data[i] >> 1;
+		nr = (skb->data[i + 1] >> 1) & 0x7f;
+	} else {
+		PollFlag = (skb->data[i] & 0x10);
+		ns = (skb->data[i] >> 1) & 0x7;
+		nr = (skb->data[i] >> 5) & 0x7;
+	}
+	if (test_bit(FLG_OWN_BUSY, &l2->flag)) {
+		dev_kfree_skb(skb);
+		if (PollFlag)
+			enquiry_response(l2);
+	} else {
+		if (l2->vr == ns) {
+			l2->vr++;
+			if (test_bit(FLG_MOD128, &l2->flag))
+				l2->vr %= 128;
+			else
+				l2->vr %= 8;
+			test_and_clear_bit(FLG_REJEXC, &l2->flag);
+			if (PollFlag)
+				enquiry_response(l2);
+			else
+				test_and_set_bit(FLG_ACK_PEND, &l2->flag);
+			skb_pull(skb, l2headersize(l2, 0));
+			l2up(l2, DL_DATA_IND, skb);
+		} else {
+			/* n(s)!=v(r) */
+			dev_kfree_skb(skb);
+			if (test_and_set_bit(FLG_REJEXC, &l2->flag)) {
+				if (PollFlag)
+					enquiry_response(l2);
+			} else {
+				enquiry_cr(l2, REJ, RSP, PollFlag);
+				test_and_clear_bit(FLG_ACK_PEND, &l2->flag);
+			}
+		}
+	}
+	if (legalnr(l2, nr)) {
+		if (!test_bit(FLG_PEER_BUSY, &l2->flag) &&
+		    (fi->state == ST_L2_7)) {
+			if (nr == l2->vs) {
+				stop_t200(l2, 13);
+				mISDN_FsmRestartTimer(&l2->t203, l2->T203,
+						EV_L2_T203, NULL, 7);
+			} else if (nr != l2->va)
+				restart_t200(l2, 14);
+		}
+		setva(l2, nr);
+	} else {
+		nrerrorrecovery(fi);
+		return;
+	}
+	if (skb_queue_len(&l2->i_queue) && (fi->state == ST_L2_7))
+		mISDN_FsmEvent(fi, EV_L2_ACK_PULL, NULL);
+	if (test_and_clear_bit(FLG_ACK_PEND, &l2->flag))
+		enquiry_cr(l2, RR, RSP, 0);
+}
+
+static void
+l2_got_tei(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2	*l2 = fi->userdata;
+	u_int		info;
+
+	l2->tei = (signed char)(long)arg;
+	set_channel_address(&l2->ch, l2->sapi, l2->tei);
+	info = DL_INFO_L2_CONNECT;
+	l2up_create(l2, DL_INFORMATION_IND, sizeof(info), &info);
+	if (fi->state == ST_L2_3) {
+		establishlink(fi);
+		test_and_set_bit(FLG_L3_INIT, &l2->flag);
+	} else
+		mISDN_FsmChangeState(fi, ST_L2_4);
+	if (skb_queue_len(&l2->ui_queue))
+		tx_ui(l2);
+}
+
+static void
+l2_st5_tout_200(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+
+	if (test_bit(FLG_LAPD, &l2->flag) &&
+		test_bit(FLG_DCHAN_BUSY, &l2->flag)) {
+		mISDN_FsmAddTimer(&l2->t200, l2->T200, EV_L2_T200, NULL, 9);
+	} else if (l2->rc == l2->N200) {
+		mISDN_FsmChangeState(fi, ST_L2_4);
+		test_and_clear_bit(FLG_T200_RUN, &l2->flag);
+		skb_queue_purge(&l2->i_queue);
+		l2mgr(l2, MDL_ERROR_IND, (void *) 'G');
+		if (test_bit(FLG_LAPB, &l2->flag))
+			l2down_create(l2, PH_DEACTIVATE_REQ,
+				l2_newid(l2), 0, NULL);
+		st5_dl_release_l2l3(l2);
+		if (l2->tm)
+			l2_tei(l2, MDL_STATUS_DOWN_IND, 0);
+	} else {
+		l2->rc++;
+		mISDN_FsmAddTimer(&l2->t200, l2->T200, EV_L2_T200, NULL, 9);
+		send_uframe(l2, NULL, (test_bit(FLG_MOD128, &l2->flag) ?
+			SABME : SABM) | 0x10, CMD);
+	}
+}
+
+static void
+l2_st6_tout_200(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+
+	if (test_bit(FLG_LAPD, &l2->flag) &&
+		test_bit(FLG_DCHAN_BUSY, &l2->flag)) {
+		mISDN_FsmAddTimer(&l2->t200, l2->T200, EV_L2_T200, NULL, 9);
+	} else if (l2->rc == l2->N200) {
+		mISDN_FsmChangeState(fi, ST_L2_4);
+		test_and_clear_bit(FLG_T200_RUN, &l2->flag);
+		l2mgr(l2, MDL_ERROR_IND, (void *) 'H');
+		lapb_dl_release_l2l3(l2, DL_RELEASE_CNF);
+		if (l2->tm)
+			l2_tei(l2, MDL_STATUS_DOWN_IND, 0);
+	} else {
+		l2->rc++;
+		mISDN_FsmAddTimer(&l2->t200, l2->T200, EV_L2_T200,
+			    NULL, 9);
+		send_uframe(l2, NULL, DISC | 0x10, CMD);
+	}
+}
+
+static void
+l2_st7_tout_200(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+
+	if (test_bit(FLG_LAPD, &l2->flag) &&
+		test_bit(FLG_DCHAN_BUSY, &l2->flag)) {
+		mISDN_FsmAddTimer(&l2->t200, l2->T200, EV_L2_T200, NULL, 9);
+		return;
+	}
+	test_and_clear_bit(FLG_T200_RUN, &l2->flag);
+	l2->rc = 0;
+	mISDN_FsmChangeState(fi, ST_L2_8);
+	transmit_enquiry(l2);
+	l2->rc++;
+}
+
+static void
+l2_st8_tout_200(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+
+	if (test_bit(FLG_LAPD, &l2->flag) &&
+		test_bit(FLG_DCHAN_BUSY, &l2->flag)) {
+		mISDN_FsmAddTimer(&l2->t200, l2->T200, EV_L2_T200, NULL, 9);
+		return;
+	}
+	test_and_clear_bit(FLG_T200_RUN, &l2->flag);
+	if (l2->rc == l2->N200) {
+		l2mgr(l2, MDL_ERROR_IND, (void *) 'I');
+		establishlink(fi);
+		test_and_clear_bit(FLG_L3_INIT, &l2->flag);
+	} else {
+		transmit_enquiry(l2);
+		l2->rc++;
+	}
+}
+
+static void
+l2_st7_tout_203(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+
+	if (test_bit(FLG_LAPD, &l2->flag) &&
+		test_bit(FLG_DCHAN_BUSY, &l2->flag)) {
+		mISDN_FsmAddTimer(&l2->t203, l2->T203, EV_L2_T203, NULL, 9);
+		return;
+	}
+	mISDN_FsmChangeState(fi, ST_L2_8);
+	transmit_enquiry(l2);
+	l2->rc = 0;
+}
+
+static void
+l2_pull_iqueue(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2	*l2 = fi->userdata;
+	struct sk_buff	*skb, *nskb, *oskb;
+	u_char		header[MAX_L2HEADER_LEN];
+	u_int		i, p1;
+
+	if (!cansend(l2))
+		return;
+
+	skb = skb_dequeue(&l2->i_queue);
+	if (!skb)
+		return;
+
+	if (test_bit(FLG_MOD128, &l2->flag))
+		p1 = (l2->vs - l2->va) % 128;
+	else
+		p1 = (l2->vs - l2->va) % 8;
+	p1 = (p1 + l2->sow) % l2->window;
+	if (l2->windowar[p1]) {
+		printk(KERN_WARNING "isdnl2 try overwrite ack queue entry %d\n",
+		    p1);
+		dev_kfree_skb(l2->windowar[p1]);
+	}
+	l2->windowar[p1] = skb;
+	i = sethdraddr(l2, header, CMD);
+	if (test_bit(FLG_MOD128, &l2->flag)) {
+		header[i++] = l2->vs << 1;
+		header[i++] = l2->vr << 1;
+		l2->vs = (l2->vs + 1) % 128;
+	} else {
+		header[i++] = (l2->vr << 5) | (l2->vs << 1);
+		l2->vs = (l2->vs + 1) % 8;
+	}
+
+	nskb = skb_clone(skb, GFP_ATOMIC);
+	p1 = skb_headroom(nskb);
+	if (p1 >= i)
+		memcpy(skb_push(nskb, i), header, i);
+	else {
+		printk(KERN_WARNING
+		    "isdnl2 pull_iqueue skb header(%d/%d) too short\n", i, p1);
+		oskb = nskb;
+		nskb = mI_alloc_skb(oskb->len + i, GFP_ATOMIC);
+		if (!nskb) {
+			dev_kfree_skb(oskb);
+			printk(KERN_WARNING "%s: no skb mem\n", __func__);
+			return;
+		}
+		memcpy(skb_put(nskb, i), header, i);
+		memcpy(skb_put(nskb, oskb->len), oskb->data, oskb->len);
+		dev_kfree_skb(oskb);
+	}
+	l2down(l2, PH_DATA_REQ, l2_newid(l2), nskb);
+	test_and_clear_bit(FLG_ACK_PEND, &l2->flag);
+	if (!test_and_set_bit(FLG_T200_RUN, &l2->flag)) {
+		mISDN_FsmDelTimer(&l2->t203, 13);
+		mISDN_FsmAddTimer(&l2->t200, l2->T200, EV_L2_T200, NULL, 11);
+	}
+}
+
+static void
+l2_st8_got_super(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+	struct sk_buff *skb = arg;
+	int PollFlag, rsp, rnr = 0;
+	unsigned int nr;
+
+	rsp = *skb->data & 0x2;
+	if (test_bit(FLG_ORIG, &l2->flag))
+		rsp = !rsp;
+
+	skb_pull(skb, l2addrsize(l2));
+
+	if (IsRNR(skb->data, l2)) {
+		set_peer_busy(l2);
+		rnr = 1;
+	} else
+		clear_peer_busy(l2);
+
+	if (test_bit(FLG_MOD128, &l2->flag)) {
+		PollFlag = (skb->data[1] & 0x1) == 0x1;
+		nr = skb->data[1] >> 1;
+	} else {
+		PollFlag = (skb->data[0] & 0x10);
+		nr = (skb->data[0] >> 5) & 0x7;
+	}
+	dev_kfree_skb(skb);
+	if (rsp && PollFlag) {
+		if (legalnr(l2, nr)) {
+			if (rnr) {
+				restart_t200(l2, 15);
+			} else {
+				stop_t200(l2, 16);
+				mISDN_FsmAddTimer(&l2->t203, l2->T203,
+					    EV_L2_T203, NULL, 5);
+				setva(l2, nr);
+			}
+			invoke_retransmission(l2, nr);
+			mISDN_FsmChangeState(fi, ST_L2_7);
+			if (skb_queue_len(&l2->i_queue) && cansend(l2))
+				mISDN_FsmEvent(fi, EV_L2_ACK_PULL, NULL);
+		} else
+			nrerrorrecovery(fi);
+	} else {
+		if (!rsp && PollFlag)
+			enquiry_response(l2);
+		if (legalnr(l2, nr))
+			setva(l2, nr);
+		else
+			nrerrorrecovery(fi);
+	}
+}
+
+static void
+l2_got_FRMR(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+	struct sk_buff *skb = arg;
+
+	skb_pull(skb, l2addrsize(l2) + 1);
+
+	if (!(skb->data[0] & 1) || ((skb->data[0] & 3) == 1) || /* I or S */
+	    (IsUA(skb->data) && (fi->state == ST_L2_7))) {
+		l2mgr(l2, MDL_ERROR_IND, (void *) 'K');
+		establishlink(fi);
+		test_and_clear_bit(FLG_L3_INIT, &l2->flag);
+	}
+	dev_kfree_skb(skb);
+}
+
+static void
+l2_st24_tei_remove(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+
+	skb_queue_purge(&l2->ui_queue);
+	l2->tei = GROUP_TEI;
+	mISDN_FsmChangeState(fi, ST_L2_1);
+}
+
+static void
+l2_st3_tei_remove(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+
+	skb_queue_purge(&l2->ui_queue);
+	l2->tei = GROUP_TEI;
+	l2up_create(l2, DL_RELEASE_IND, 0, NULL);
+	mISDN_FsmChangeState(fi, ST_L2_1);
+}
+
+static void
+l2_st5_tei_remove(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+
+	skb_queue_purge(&l2->i_queue);
+	skb_queue_purge(&l2->ui_queue);
+	freewin(l2);
+	l2->tei = GROUP_TEI;
+	stop_t200(l2, 17);
+	st5_dl_release_l2l3(l2);
+	mISDN_FsmChangeState(fi, ST_L2_1);
+}
+
+static void
+l2_st6_tei_remove(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+
+	skb_queue_purge(&l2->ui_queue);
+	l2->tei = GROUP_TEI;
+	stop_t200(l2, 18);
+	l2up_create(l2, DL_RELEASE_IND, 0, NULL);
+	mISDN_FsmChangeState(fi, ST_L2_1);
+}
+
+static void
+l2_tei_remove(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+
+	skb_queue_purge(&l2->i_queue);
+	skb_queue_purge(&l2->ui_queue);
+	freewin(l2);
+	l2->tei = GROUP_TEI;
+	stop_t200(l2, 17);
+	mISDN_FsmDelTimer(&l2->t203, 19);
+	l2up_create(l2, DL_RELEASE_IND, 0, NULL);
+/*	mISDN_queue_data(&l2->inst, l2->inst.id | MSG_BROADCAST,
+ *		MGR_SHORTSTATUS_IND, SSTATUS_L2_RELEASED,
+ *		0, NULL, 0);
+ */
+	mISDN_FsmChangeState(fi, ST_L2_1);
+}
+
+static void
+l2_st14_persistant_da(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+	struct sk_buff *skb = arg;
+
+	skb_queue_purge(&l2->i_queue);
+	skb_queue_purge(&l2->ui_queue);
+	if (test_and_clear_bit(FLG_ESTAB_PEND, &l2->flag))
+		l2up(l2, DL_RELEASE_IND, skb);
+	else
+		dev_kfree_skb(skb);
+}
+
+static void
+l2_st5_persistant_da(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+	struct sk_buff *skb = arg;
+
+	skb_queue_purge(&l2->i_queue);
+	skb_queue_purge(&l2->ui_queue);
+	freewin(l2);
+	stop_t200(l2, 19);
+	st5_dl_release_l2l3(l2);
+	mISDN_FsmChangeState(fi, ST_L2_4);
+	if (l2->tm)
+		l2_tei(l2, MDL_STATUS_DOWN_IND, 0);
+	dev_kfree_skb(skb);
+}
+
+static void
+l2_st6_persistant_da(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+	struct sk_buff *skb = arg;
+
+	skb_queue_purge(&l2->ui_queue);
+	stop_t200(l2, 20);
+	l2up(l2, DL_RELEASE_CNF, skb);
+	mISDN_FsmChangeState(fi, ST_L2_4);
+	if (l2->tm)
+		l2_tei(l2, MDL_STATUS_DOWN_IND, 0);
+}
+
+static void
+l2_persistant_da(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+	struct sk_buff *skb = arg;
+
+	skb_queue_purge(&l2->i_queue);
+	skb_queue_purge(&l2->ui_queue);
+	freewin(l2);
+	stop_t200(l2, 19);
+	mISDN_FsmDelTimer(&l2->t203, 19);
+	l2up(l2, DL_RELEASE_IND, skb);
+	mISDN_FsmChangeState(fi, ST_L2_4);
+	if (l2->tm)
+		l2_tei(l2, MDL_STATUS_DOWN_IND, 0);
+}
+
+static void
+l2_set_own_busy(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+	struct sk_buff *skb = arg;
+
+	if (!test_and_set_bit(FLG_OWN_BUSY, &l2->flag)) {
+		enquiry_cr(l2, RNR, RSP, 0);
+		test_and_clear_bit(FLG_ACK_PEND, &l2->flag);
+	}
+	if (skb)
+		dev_kfree_skb(skb);
+}
+
+static void
+l2_clear_own_busy(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+	struct sk_buff *skb = arg;
+
+	if (!test_and_clear_bit(FLG_OWN_BUSY, &l2->flag)) {
+		enquiry_cr(l2, RR, RSP, 0);
+		test_and_clear_bit(FLG_ACK_PEND, &l2->flag);
+	}
+	if (skb)
+		dev_kfree_skb(skb);
+}
+
+static void
+l2_frame_error(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+
+	l2mgr(l2, MDL_ERROR_IND, arg);
+}
+
+static void
+l2_frame_error_reest(struct FsmInst *fi, int event, void *arg)
+{
+	struct layer2 *l2 = fi->userdata;
+
+	l2mgr(l2, MDL_ERROR_IND, arg);
+	establishlink(fi);
+	test_and_clear_bit(FLG_L3_INIT, &l2->flag);
+}
+
+static struct FsmNode L2FnList[] =
+{
+	{ST_L2_1, EV_L2_DL_ESTABLISH_REQ, l2_mdl_assign},
+	{ST_L2_2, EV_L2_DL_ESTABLISH_REQ, l2_go_st3},
+	{ST_L2_4, EV_L2_DL_ESTABLISH_REQ, l2_establish},
+	{ST_L2_5, EV_L2_DL_ESTABLISH_REQ, l2_discard_i_setl3},
+	{ST_L2_7, EV_L2_DL_ESTABLISH_REQ, l2_l3_reestablish},
+	{ST_L2_8, EV_L2_DL_ESTABLISH_REQ, l2_l3_reestablish},
+	{ST_L2_4, EV_L2_DL_RELEASE_REQ, l2_release},
+	{ST_L2_5, EV_L2_DL_RELEASE_REQ, l2_pend_rel},
+	{ST_L2_7, EV_L2_DL_RELEASE_REQ, l2_disconnect},
+	{ST_L2_8, EV_L2_DL_RELEASE_REQ, l2_disconnect},
+	{ST_L2_5, EV_L2_DL_DATA, l2_feed_i_if_reest},
+	{ST_L2_7, EV_L2_DL_DATA, l2_feed_i_pull},
+	{ST_L2_8, EV_L2_DL_DATA, l2_feed_iqueue},
+	{ST_L2_1, EV_L2_DL_UNITDATA, l2_queue_ui_assign},
+	{ST_L2_2, EV_L2_DL_UNITDATA, l2_queue_ui},
+	{ST_L2_3, EV_L2_DL_UNITDATA, l2_queue_ui},
+	{ST_L2_4, EV_L2_DL_UNITDATA, l2_send_ui},
+	{ST_L2_5, EV_L2_DL_UNITDATA, l2_send_ui},
+	{ST_L2_6, EV_L2_DL_UNITDATA, l2_send_ui},
+	{ST_L2_7, EV_L2_DL_UNITDATA, l2_send_ui},
+	{ST_L2_8, EV_L2_DL_UNITDATA, l2_send_ui},
+	{ST_L2_1, EV_L2_MDL_ASSIGN, l2_got_tei},
+	{ST_L2_2, EV_L2_MDL_ASSIGN, l2_got_tei},
+	{ST_L2_3, EV_L2_MDL_ASSIGN, l2_got_tei},
+	{ST_L2_2, EV_L2_MDL_ERROR, l2_st24_tei_remove},
+	{ST_L2_3, EV_L2_MDL_ERROR, l2_st3_tei_remove},
+	{ST_L2_4, EV_L2_MDL_REMOVE, l2_st24_tei_remove},
+	{ST_L2_5, EV_L2_MDL_REMOVE, l2_st5_tei_remove},
+	{ST_L2_6, EV_L2_MDL_REMOVE, l2_st6_tei_remove},
+	{ST_L2_7, EV_L2_MDL_REMOVE, l2_tei_remove},
+	{ST_L2_8, EV_L2_MDL_REMOVE, l2_tei_remove},
+	{ST_L2_4, EV_L2_SABME, l2_start_multi},
+	{ST_L2_5, EV_L2_SABME, l2_send_UA},
+	{ST_L2_6, EV_L2_SABME, l2_send_DM},
+	{ST_L2_7, EV_L2_SABME, l2_restart_multi},
+	{ST_L2_8, EV_L2_SABME, l2_restart_multi},
+	{ST_L2_4, EV_L2_DISC, l2_send_DM},
+	{ST_L2_5, EV_L2_DISC, l2_send_DM},
+	{ST_L2_6, EV_L2_DISC, l2_send_UA},
+	{ST_L2_7, EV_L2_DISC, l2_stop_multi},
+	{ST_L2_8, EV_L2_DISC, l2_stop_multi},
+	{ST_L2_4, EV_L2_UA, l2_mdl_error_ua},
+	{ST_L2_5, EV_L2_UA, l2_connected},
+	{ST_L2_6, EV_L2_UA, l2_released},
+	{ST_L2_7, EV_L2_UA, l2_mdl_error_ua},
+	{ST_L2_8, EV_L2_UA, l2_mdl_error_ua},
+	{ST_L2_4, EV_L2_DM, l2_reestablish},
+	{ST_L2_5, EV_L2_DM, l2_st5_dm_release},
+	{ST_L2_6, EV_L2_DM, l2_st6_dm_release},
+	{ST_L2_7, EV_L2_DM, l2_mdl_error_dm},
+	{ST_L2_8, EV_L2_DM, l2_st8_mdl_error_dm},
+	{ST_L2_1, EV_L2_UI, l2_got_ui},
+	{ST_L2_2, EV_L2_UI, l2_got_ui},
+	{ST_L2_3, EV_L2_UI, l2_got_ui},
+	{ST_L2_4, EV_L2_UI, l2_got_ui},
+	{ST_L2_5, EV_L2_UI, l2_got_ui},
+	{ST_L2_6, EV_L2_UI, l2_got_ui},
+	{ST_L2_7, EV_L2_UI, l2_got_ui},
+	{ST_L2_8, EV_L2_UI, l2_got_ui},
+	{ST_L2_7, EV_L2_FRMR, l2_got_FRMR},
+	{ST_L2_8, EV_L2_FRMR, l2_got_FRMR},
+	{ST_L2_7, EV_L2_SUPER, l2_st7_got_super},
+	{ST_L2_8, EV_L2_SUPER, l2_st8_got_super},
+	{ST_L2_7, EV_L2_I, l2_got_iframe},
+	{ST_L2_8, EV_L2_I, l2_got_iframe},
+	{ST_L2_5, EV_L2_T200, l2_st5_tout_200},
+	{ST_L2_6, EV_L2_T200, l2_st6_tout_200},
+	{ST_L2_7, EV_L2_T200, l2_st7_tout_200},
+	{ST_L2_8, EV_L2_T200, l2_st8_tout_200},
+	{ST_L2_7, EV_L2_T203, l2_st7_tout_203},
+	{ST_L2_7, EV_L2_ACK_PULL, l2_pull_iqueue},
+	{ST_L2_7, EV_L2_SET_OWN_BUSY, l2_set_own_busy},
+	{ST_L2_8, EV_L2_SET_OWN_BUSY, l2_set_own_busy},
+	{ST_L2_7, EV_L2_CLEAR_OWN_BUSY, l2_clear_own_busy},
+	{ST_L2_8, EV_L2_CLEAR_OWN_BUSY, l2_clear_own_busy},
+	{ST_L2_4, EV_L2_FRAME_ERROR, l2_frame_error},
+	{ST_L2_5, EV_L2_FRAME_ERROR, l2_frame_error},
+	{ST_L2_6, EV_L2_FRAME_ERROR, l2_frame_error},
+	{ST_L2_7, EV_L2_FRAME_ERROR, l2_frame_error_reest},
+	{ST_L2_8, EV_L2_FRAME_ERROR, l2_frame_error_reest},
+	{ST_L2_1, EV_L1_DEACTIVATE, l2_st14_persistant_da},
+	{ST_L2_2, EV_L1_DEACTIVATE, l2_st24_tei_remove},
+	{ST_L2_3, EV_L1_DEACTIVATE, l2_st3_tei_remove},
+	{ST_L2_4, EV_L1_DEACTIVATE, l2_st14_persistant_da},
+	{ST_L2_5, EV_L1_DEACTIVATE, l2_st5_persistant_da},
+	{ST_L2_6, EV_L1_DEACTIVATE, l2_st6_persistant_da},
+	{ST_L2_7, EV_L1_DEACTIVATE, l2_persistant_da},
+	{ST_L2_8, EV_L1_DEACTIVATE, l2_persistant_da},
+};
+
+#define L2_FN_COUNT (sizeof(L2FnList)/sizeof(struct FsmNode))
+
+static int
+ph_data_indication(struct layer2 *l2, struct mISDNhead *hh, struct sk_buff *skb)
+{
+	u_char	*datap = skb->data;
+	int	ret = -EINVAL;
+	int	psapi, ptei;
+	u_int	l;
+	int	c = 0;
+
+	l = l2addrsize(l2);
+	if (skb->len <= l) {
+		mISDN_FsmEvent(&l2->l2m, EV_L2_FRAME_ERROR, (void *) 'N');
+		return ret;
+	}
+	if (test_bit(FLG_LAPD, &l2->flag)) { /* Maybe not needed */
+		psapi = *datap++;
+		ptei = *datap++;
+		if ((psapi & 1) || !(ptei & 1)) {
+			printk(KERN_WARNING
+			    "l2 D-channel frame wrong EA0/EA1\n");
+			return ret;
+		}
+		psapi >>= 2;
+		ptei >>= 1;
+		if (psapi != l2->sapi) {
+			/* not our bussiness
+			 * printk(KERN_DEBUG "%s: sapi %d/%d sapi mismatch\n",
+			 *  __func__,
+			 *	psapi, l2->sapi);
+			 */
+			dev_kfree_skb(skb);
+			return 0;
+		}
+		if ((ptei != l2->tei) && (ptei != GROUP_TEI)) {
+			/* not our bussiness
+			 * printk(KERN_DEBUG "%s: tei %d/%d sapi %d mismatch\n",
+			 *  __func__,
+			 *	ptei, l2->tei, psapi);
+			 */
+			dev_kfree_skb(skb);
+			return 0;
+		}
+	} else
+		datap += l;
+	if (!(*datap & 1)) {	/* I-Frame */
+		c = iframe_error(l2, skb);
+		if (!c)
+			ret = mISDN_FsmEvent(&l2->l2m, EV_L2_I, skb);
+	} else if (IsSFrame(datap, l2)) {	/* S-Frame */
+		c = super_error(l2, skb);
+		if (!c)
+			ret = mISDN_FsmEvent(&l2->l2m, EV_L2_SUPER, skb);
+	} else if (IsUI(datap)) {
+		c = UI_error(l2, skb);
+		if (!c)
+			ret = mISDN_FsmEvent(&l2->l2m, EV_L2_UI, skb);
+	} else if (IsSABME(datap, l2)) {
+		c = unnum_error(l2, skb, CMD);
+		if (!c)
+			ret = mISDN_FsmEvent(&l2->l2m, EV_L2_SABME, skb);
+	} else if (IsUA(datap)) {
+		c = unnum_error(l2, skb, RSP);
+		if (!c)
+			ret = mISDN_FsmEvent(&l2->l2m, EV_L2_UA, skb);
+	} else if (IsDISC(datap)) {
+		c = unnum_error(l2, skb, CMD);
+		if (!c)
+			ret = mISDN_FsmEvent(&l2->l2m, EV_L2_DISC, skb);
+	} else if (IsDM(datap)) {
+		c = unnum_error(l2, skb, RSP);
+		if (!c)
+			ret = mISDN_FsmEvent(&l2->l2m, EV_L2_DM, skb);
+	} else if (IsFRMR(datap)) {
+		c = FRMR_error(l2, skb);
+		if (!c)
+			ret = mISDN_FsmEvent(&l2->l2m, EV_L2_FRMR, skb);
+	} else
+		c = 'L';
+	if (c) {
+		printk(KERN_WARNING "l2 D-channel frame error %c\n", c);
+		mISDN_FsmEvent(&l2->l2m, EV_L2_FRAME_ERROR, (void *)(long)c);
+	}
+	return ret;
+}
+
+static int
+l2_send(struct mISDNchannel *ch, struct sk_buff *skb)
+{
+	struct layer2		*l2 = container_of(ch, struct layer2, ch);
+	struct mISDNhead	*hh =  mISDN_HEAD_P(skb);
+	int 			ret = -EINVAL;
+
+	if (*debug & DEBUG_L2_RECV)
+		printk(KERN_DEBUG "%s: prim(%x) id(%x) tei(%d)\n",
+		    __func__, hh->prim, hh->id, l2->tei);
+	switch (hh->prim) {
+	case PH_DATA_IND:
+		ret = ph_data_indication(l2, hh, skb);
+		break;
+	case PH_DATA_CNF:
+		ret = ph_data_confirm(l2, hh, skb);
+		break;
+	case PH_ACTIVATE_IND:
+		test_and_set_bit(FLG_L1_ACTIV, &l2->flag);
+		l2up_create(l2, MPH_ACTIVATE_IND, 0, NULL);
+		if (test_and_clear_bit(FLG_ESTAB_PEND, &l2->flag))
+			ret = mISDN_FsmEvent(&l2->l2m,
+				EV_L2_DL_ESTABLISH_REQ, skb);
+		break;
+	case PH_DEACTIVATE_IND:
+		test_and_clear_bit(FLG_L1_ACTIV, &l2->flag);
+		l2up_create(l2, MPH_DEACTIVATE_IND, 0, NULL);
+		ret = mISDN_FsmEvent(&l2->l2m, EV_L1_DEACTIVATE, skb);
+		break;
+	case MPH_INFORMATION_IND:
+		if (!l2->up)
+			break;
+		ret = l2->up->send(l2->up, skb);
+		break;
+	case DL_DATA_REQ:
+		ret = mISDN_FsmEvent(&l2->l2m, EV_L2_DL_DATA, skb);
+		break;
+	case DL_UNITDATA_REQ:
+		ret = mISDN_FsmEvent(&l2->l2m, EV_L2_DL_UNITDATA, skb);
+		break;
+	case DL_ESTABLISH_REQ:
+		if (test_bit(FLG_LAPB, &l2->flag))
+			test_and_set_bit(FLG_ORIG, &l2->flag);
+		if (test_bit(FLG_L1_ACTIV, &l2->flag)) {
+			if (test_bit(FLG_LAPD, &l2->flag) ||
+				test_bit(FLG_ORIG, &l2->flag))
+				ret = mISDN_FsmEvent(&l2->l2m,
+					EV_L2_DL_ESTABLISH_REQ, skb);
+		} else {
+			if (test_bit(FLG_LAPD, &l2->flag) ||
+				test_bit(FLG_ORIG, &l2->flag)) {
+				test_and_set_bit(FLG_ESTAB_PEND,
+					&l2->flag);
+			}
+			ret = l2down(l2, PH_ACTIVATE_REQ, l2_newid(l2),
+			    skb);
+		}
+		break;
+	case DL_RELEASE_REQ:
+		if (test_bit(FLG_LAPB, &l2->flag))
+			l2down_create(l2, PH_DEACTIVATE_REQ,
+				l2_newid(l2), 0, NULL);
+		ret = mISDN_FsmEvent(&l2->l2m, EV_L2_DL_RELEASE_REQ,
+		    skb);
+		break;
+	default:
+		if (*debug & DEBUG_L2)
+			l2m_debug(&l2->l2m, "l2 unknown pr %04x",
+			    hh->prim);
+	}
+	if (ret) {
+		dev_kfree_skb(skb);
+		ret = 0;
+	}
+	return ret;
+}
+
+int
+tei_l2(struct layer2 *l2, u_int cmd, u_long arg)
+{
+	int		ret = -EINVAL;
+
+	if (*debug & DEBUG_L2_TEI)
+		printk(KERN_DEBUG "%s: cmd(%x)\n", __func__, cmd);
+	switch (cmd) {
+	case (MDL_ASSIGN_REQ):
+		ret = mISDN_FsmEvent(&l2->l2m, EV_L2_MDL_ASSIGN, (void *)arg);
+		break;
+	case (MDL_REMOVE_REQ):
+		ret = mISDN_FsmEvent(&l2->l2m, EV_L2_MDL_REMOVE, NULL);
+		break;
+	case (MDL_ERROR_IND):
+		ret = mISDN_FsmEvent(&l2->l2m, EV_L2_MDL_ERROR, NULL);
+		break;
+	case (MDL_ERROR_RSP):
+		/* ETS 300-125 5.3.2.1 Test: TC13010 */
+		printk(KERN_NOTICE "MDL_ERROR|REQ (tei_l2)\n");
+		ret = mISDN_FsmEvent(&l2->l2m, EV_L2_MDL_ERROR, NULL);
+		break;
+	}
+	return ret;
+}
+
+static void
+release_l2(struct layer2 *l2)
+{
+	mISDN_FsmDelTimer(&l2->t200, 21);
+	mISDN_FsmDelTimer(&l2->t203, 16);
+	skb_queue_purge(&l2->i_queue);
+	skb_queue_purge(&l2->ui_queue);
+	skb_queue_purge(&l2->down_queue);
+	ReleaseWin(l2);
+	if (test_bit(FLG_LAPD, &l2->flag)) {
+		release_tei(l2);
+		if (l2->ch.st)
+			l2->ch.st->dev->D.ctrl(&l2->ch.st->dev->D,
+			    CLOSE_CHANNEL, NULL);
+	}
+	kfree(l2);
+}
+
+static int
+l2_ctrl(struct mISDNchannel *ch, u_int cmd, void *arg)
+{
+	struct layer2		*l2 = container_of(ch, struct layer2, ch);
+	u_int			info;
+
+	if (*debug & DEBUG_L2_CTRL)
+		printk(KERN_DEBUG "%s:(%x)\n", __func__, cmd);
+
+	switch (cmd) {
+	case OPEN_CHANNEL:
+		if (test_bit(FLG_LAPD, &l2->flag)) {
+			set_channel_address(&l2->ch, l2->sapi, l2->tei);
+			info = DL_INFO_L2_CONNECT;
+			l2up_create(l2, DL_INFORMATION_IND,
+			    sizeof(info), &info);
+		}
+		break;
+	case CLOSE_CHANNEL:
+		if (l2->ch.peer)
+			l2->ch.peer->ctrl(l2->ch.peer, CLOSE_CHANNEL, NULL);
+		release_l2(l2);
+		break;
+	}
+	return 0;
+}
+
+struct layer2 *
+create_l2(struct mISDNchannel *ch, u_int protocol, u_long options, u_long arg)
+{
+	struct layer2		*l2;
+	struct channel_req	rq;
+
+	l2 = kzalloc(sizeof(struct layer2), GFP_KERNEL);
+	if (!l2) {
+		printk(KERN_ERR "kzalloc layer2 failed\n");
+		return NULL;
+	}
+	l2->next_id = 1;
+	l2->down_id = MISDN_ID_NONE;
+	l2->up = ch;
+	l2->ch.st = ch->st;
+	l2->ch.send = l2_send;
+	l2->ch.ctrl = l2_ctrl;
+	switch (protocol) {
+	case ISDN_P_LAPD_NT:
+		test_and_set_bit(FLG_LAPD, &l2->flag);
+		test_and_set_bit(FLG_LAPD_NET, &l2->flag);
+		test_and_set_bit(FLG_MOD128, &l2->flag);
+		l2->sapi = 0;
+		l2->maxlen = MAX_DFRAME_LEN;
+		if (test_bit(OPTION_L2_PMX, &options))
+			l2->window = 7;
+		else
+			l2->window = 1;
+		if (test_bit(OPTION_L2_PTP, &options))
+			test_and_set_bit(FLG_PTP, &l2->flag);
+		if (test_bit(OPTION_L2_FIXEDTEI, &options))
+			test_and_set_bit(FLG_FIXED_TEI, &l2->flag);
+		l2->tei = (u_int)arg;
+		l2->T200 = 1000;
+		l2->N200 = 3;
+		l2->T203 = 10000;
+		if (test_bit(OPTION_L2_PMX, &options))
+			rq.protocol = ISDN_P_NT_E1;
+		else
+			rq.protocol = ISDN_P_NT_S0;
+		rq.adr.channel = 0;
+		l2->ch.st->dev->D.ctrl(&l2->ch.st->dev->D, OPEN_CHANNEL, &rq);
+		break;
+	case ISDN_P_LAPD_TE:
+		test_and_set_bit(FLG_LAPD, &l2->flag);
+		test_and_set_bit(FLG_MOD128, &l2->flag);
+		test_and_set_bit(FLG_ORIG, &l2->flag);
+		l2->sapi = 0;
+		l2->maxlen = MAX_DFRAME_LEN;
+		if (test_bit(OPTION_L2_PMX, &options))
+			l2->window = 7;
+		else
+			l2->window = 1;
+		if (test_bit(OPTION_L2_PTP, &options))
+			test_and_set_bit(FLG_PTP, &l2->flag);
+		if (test_bit(OPTION_L2_FIXEDTEI, &options))
+			test_and_set_bit(FLG_FIXED_TEI, &l2->flag);
+		l2->tei = (u_int)arg;
+		l2->T200 = 1000;
+		l2->N200 = 3;
+		l2->T203 = 10000;
+		if (test_bit(OPTION_L2_PMX, &options))
+			rq.protocol = ISDN_P_TE_E1;
+		else
+			rq.protocol = ISDN_P_TE_S0;
+		rq.adr.channel = 0;
+		l2->ch.st->dev->D.ctrl(&l2->ch.st->dev->D, OPEN_CHANNEL, &rq);
+		break;
+	case ISDN_P_B_X75SLP:
+		test_and_set_bit(FLG_LAPB, &l2->flag);
+		l2->window = 7;
+		l2->maxlen = MAX_DATA_SIZE;
+		l2->T200 = 1000;
+		l2->N200 = 4;
+		l2->T203 = 5000;
+		l2->addr.A = 3;
+		l2->addr.B = 1;
+		break;
+	default:
+		printk(KERN_ERR "layer2 create failed prt %x\n",
+			protocol);
+		kfree(l2);
+		return NULL;
+	}
+	skb_queue_head_init(&l2->i_queue);
+	skb_queue_head_init(&l2->ui_queue);
+	skb_queue_head_init(&l2->down_queue);
+	skb_queue_head_init(&l2->tmp_queue);
+	InitWin(l2);
+	l2->l2m.fsm = &l2fsm;
+	if (test_bit(FLG_LAPB, &l2->flag) ||
+		test_bit(FLG_PTP, &l2->flag) ||
+		test_bit(FLG_LAPD_NET, &l2->flag))
+		l2->l2m.state = ST_L2_4;
+	else
+		l2->l2m.state = ST_L2_1;
+	l2->l2m.debug = *debug;
+	l2->l2m.userdata = l2;
+	l2->l2m.userint = 0;
+	l2->l2m.printdebug = l2m_debug;
+
+	mISDN_FsmInitTimer(&l2->l2m, &l2->t200);
+	mISDN_FsmInitTimer(&l2->l2m, &l2->t203);
+	return l2;
+}
+
+static int
+x75create(struct channel_req *crq)
+{
+	struct layer2	*l2;
+
+	if (crq->protocol != ISDN_P_B_X75SLP)
+		return -EPROTONOSUPPORT;
+	l2 = create_l2(crq->ch, crq->protocol, 0, 0);
+	if (!l2)
+		return -ENOMEM;
+	crq->ch = &l2->ch;
+	crq->protocol = ISDN_P_B_HDLC;
+	return 0;
+}
+
+static struct Bprotocol X75SLP = {
+	.Bprotocols = (1 << (ISDN_P_B_X75SLP & ISDN_P_B_MASK)),
+	.name = "X75SLP",
+	.create = x75create
+};
+
+int
+Isdnl2_Init(u_int *deb)
+{
+	debug = deb;
+	mISDN_register_Bprotocol(&X75SLP);
+	l2fsm.state_count = L2_STATE_COUNT;
+	l2fsm.event_count = L2_EVENT_COUNT;
+	l2fsm.strEvent = strL2Event;
+	l2fsm.strState = strL2State;
+	mISDN_FsmNew(&l2fsm, L2FnList, ARRAY_SIZE(L2FnList));
+	TEIInit(deb);
+	return 0;
+}
+
+void
+Isdnl2_cleanup(void)
+{
+	mISDN_unregister_Bprotocol(&X75SLP);
+	TEIFree();
+	mISDN_FsmFree(&l2fsm);
+}
+
diff --git a/drivers/isdn/mISDN/layer2.h b/drivers/isdn/mISDN/layer2.h
new file mode 100644
index 0000000..de2dd02
--- /dev/null
+++ b/drivers/isdn/mISDN/layer2.h
@@ -0,0 +1,140 @@
+/*
+ * Layer 2 defines
+ *
+ * Copyright 2008  by Karsten Keil <kkeil@novell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/mISDNif.h>
+#include <linux/skbuff.h>
+#include "fsm.h"
+
+#define MAX_WINDOW	8
+
+struct manager {
+	struct mISDNchannel	ch;
+	struct mISDNchannel	bcast;
+	u_long			options;
+	struct list_head	layer2;
+	rwlock_t		lock;
+	struct FsmInst		deact;
+	struct FsmTimer		datimer;
+	struct sk_buff_head	sendq;
+	struct mISDNchannel	*up;
+	u_int			nextid;
+	u_int			lastid;
+};
+
+struct teimgr {
+	int			ri;
+	int			rcnt;
+	struct FsmInst		tei_m;
+	struct FsmTimer		timer;
+	int			tval, nval;
+	struct layer2		*l2;
+	struct manager		*mgr;
+};
+
+struct laddr {
+	u_char	A;
+	u_char	B;
+};
+
+struct layer2 {
+	struct list_head	list;
+	struct mISDNchannel	ch;
+	u_long			flag;
+	int			id;
+	struct mISDNchannel	*up;
+	signed char		sapi;
+	signed char		tei;
+	struct laddr		addr;
+	u_int			maxlen;
+	struct teimgr		*tm;
+	u_int			vs, va, vr;
+	int			rc;
+	u_int			window;
+	u_int			sow;
+	struct FsmInst		l2m;
+	struct FsmTimer		t200, t203;
+	int			T200, N200, T203;
+	u_int			next_id;
+	u_int			down_id;
+	struct sk_buff		*windowar[MAX_WINDOW];
+	struct sk_buff_head	i_queue;
+	struct sk_buff_head	ui_queue;
+	struct sk_buff_head	down_queue;
+	struct sk_buff_head	tmp_queue;
+};
+
+enum {
+	ST_L2_1,
+	ST_L2_2,
+	ST_L2_3,
+	ST_L2_4,
+	ST_L2_5,
+	ST_L2_6,
+	ST_L2_7,
+	ST_L2_8,
+};
+
+#define L2_STATE_COUNT (ST_L2_8+1)
+
+extern struct layer2	*create_l2(struct mISDNchannel *, u_int,
+				u_long, u_long);
+extern int		tei_l2(struct layer2 *, u_int, u_long arg);
+
+
+/* from tei.c */
+extern int 		l2_tei(struct layer2 *, u_int, u_long arg);
+extern void 		release_tei(struct layer2 *);
+extern int 		TEIInit(u_int *);
+extern void 		TEIFree(void);
+
+#define MAX_L2HEADER_LEN 4
+
+#define RR	0x01
+#define RNR	0x05
+#define REJ	0x09
+#define SABME	0x6f
+#define SABM	0x2f
+#define DM	0x0f
+#define UI	0x03
+#define DISC	0x43
+#define UA	0x63
+#define FRMR	0x87
+#define XID	0xaf
+
+#define CMD	0
+#define RSP	1
+
+#define LC_FLUSH_WAIT 1
+
+#define FLG_LAPB	0
+#define FLG_LAPD	1
+#define FLG_ORIG	2
+#define FLG_MOD128	3
+#define FLG_PEND_REL	4
+#define FLG_L3_INIT	5
+#define FLG_T200_RUN	6
+#define FLG_ACK_PEND	7
+#define FLG_REJEXC	8
+#define FLG_OWN_BUSY	9
+#define FLG_PEER_BUSY	10
+#define FLG_DCHAN_BUSY	11
+#define FLG_L1_ACTIV	12
+#define FLG_ESTAB_PEND	13
+#define FLG_PTP		14
+#define FLG_FIXED_TEI	15
+#define FLG_L2BLOCK	16
+#define FLG_L1_NOTREADY	17
+#define FLG_LAPD_NET	18
diff --git a/drivers/isdn/mISDN/socket.c b/drivers/isdn/mISDN/socket.c
new file mode 100644
index 0000000..4ba4cc3
--- /dev/null
+++ b/drivers/isdn/mISDN/socket.c
@@ -0,0 +1,781 @@
+/*
+ *
+ * Author	Karsten Keil <kkeil@novell.com>
+ *
+ * Copyright 2008  by Karsten Keil <kkeil@novell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/mISDNif.h>
+#include "core.h"
+
+static int	*debug;
+
+static struct proto mISDN_proto = {
+	.name		= "misdn",
+	.owner		= THIS_MODULE,
+	.obj_size	= sizeof(struct mISDN_sock)
+};
+
+#define _pms(sk)	((struct mISDN_sock *)sk)
+
+static struct mISDN_sock_list	data_sockets = {
+	.lock = __RW_LOCK_UNLOCKED(data_sockets.lock)
+};
+
+static struct mISDN_sock_list	base_sockets = {
+	.lock = __RW_LOCK_UNLOCKED(base_sockets.lock)
+};
+
+#define L2_HEADER_LEN	4
+
+static inline struct sk_buff *
+_l2_alloc_skb(unsigned int len, gfp_t gfp_mask)
+{
+	struct sk_buff  *skb;
+
+	skb = alloc_skb(len + L2_HEADER_LEN, gfp_mask);
+	if (likely(skb))
+		skb_reserve(skb, L2_HEADER_LEN);
+	return skb;
+}
+
+static void
+mISDN_sock_link(struct mISDN_sock_list *l, struct sock *sk)
+{
+	write_lock_bh(&l->lock);
+	sk_add_node(sk, &l->head);
+	write_unlock_bh(&l->lock);
+}
+
+static void mISDN_sock_unlink(struct mISDN_sock_list *l, struct sock *sk)
+{
+	write_lock_bh(&l->lock);
+	sk_del_node_init(sk);
+	write_unlock_bh(&l->lock);
+}
+
+static int
+mISDN_send(struct mISDNchannel *ch, struct sk_buff *skb)
+{
+	struct mISDN_sock *msk;
+	int	err;
+
+	msk = container_of(ch, struct mISDN_sock, ch);
+	if (*debug & DEBUG_SOCKET)
+		printk(KERN_DEBUG "%s len %d %p\n", __func__, skb->len, skb);
+	if (msk->sk.sk_state == MISDN_CLOSED)
+		return -EUNATCH;
+	__net_timestamp(skb);
+	err = sock_queue_rcv_skb(&msk->sk, skb);
+	if (err)
+		printk(KERN_WARNING "%s: error %d\n", __func__, err);
+	return err;
+}
+
+static int
+mISDN_ctrl(struct mISDNchannel *ch, u_int cmd, void *arg)
+{
+	struct mISDN_sock *msk;
+
+	msk = container_of(ch, struct mISDN_sock, ch);
+	if (*debug & DEBUG_SOCKET)
+		printk(KERN_DEBUG "%s(%p, %x, %p)\n", __func__, ch, cmd, arg);
+	switch (cmd) {
+	case CLOSE_CHANNEL:
+		msk->sk.sk_state = MISDN_CLOSED;
+		break;
+	}
+	return 0;
+}
+
+static inline void
+mISDN_sock_cmsg(struct sock *sk, struct msghdr *msg, struct sk_buff *skb)
+{
+	struct timeval	tv;
+
+	if (_pms(sk)->cmask & MISDN_TIME_STAMP) {
+		skb_get_timestamp(skb, &tv);
+		put_cmsg(msg, SOL_MISDN, MISDN_TIME_STAMP, sizeof(tv), &tv);
+	}
+}
+
+static int
+mISDN_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
+    struct msghdr *msg, size_t len, int flags)
+{
+	struct sk_buff		*skb;
+	struct sock		*sk = sock->sk;
+	struct sockaddr_mISDN	*maddr;
+
+	int		copied, err;
+
+	if (*debug & DEBUG_SOCKET)
+		printk(KERN_DEBUG "%s: len %d, flags %x ch.nr %d, proto %x\n",
+			__func__, (int)len, flags, _pms(sk)->ch.nr,
+			sk->sk_protocol);
+	if (flags & (MSG_OOB))
+		return -EOPNOTSUPP;
+
+	if (sk->sk_state == MISDN_CLOSED)
+		return 0;
+
+	skb = skb_recv_datagram(sk, flags, flags & MSG_DONTWAIT, &err);
+	if (!skb)
+		return err;
+
+	if (msg->msg_namelen >= sizeof(struct sockaddr_mISDN)) {
+		msg->msg_namelen = sizeof(struct sockaddr_mISDN);
+		maddr = (struct sockaddr_mISDN *)msg->msg_name;
+		maddr->family = AF_ISDN;
+		maddr->dev = _pms(sk)->dev->id;
+		if ((sk->sk_protocol == ISDN_P_LAPD_TE) ||
+		    (sk->sk_protocol == ISDN_P_LAPD_NT)) {
+			maddr->channel = (mISDN_HEAD_ID(skb) >> 16) & 0xff;
+			maddr->tei =  (mISDN_HEAD_ID(skb) >> 8) & 0xff;
+			maddr->sapi = mISDN_HEAD_ID(skb) & 0xff;
+		} else {
+			maddr->channel = _pms(sk)->ch.nr;
+			maddr->sapi = _pms(sk)->ch.addr & 0xFF;
+			maddr->tei =  (_pms(sk)->ch.addr >> 8) & 0xFF;
+		}
+	} else {
+		if (msg->msg_namelen)
+			printk(KERN_WARNING "%s: too small namelen %d\n",
+			    __func__, msg->msg_namelen);
+		msg->msg_namelen = 0;
+	}
+
+	copied = skb->len + MISDN_HEADER_LEN;
+	if (len < copied) {
+		if (flags & MSG_PEEK)
+			atomic_dec(&skb->users);
+		else
+			skb_queue_head(&sk->sk_receive_queue, skb);
+		return -ENOSPC;
+	}
+	memcpy(skb_push(skb, MISDN_HEADER_LEN), mISDN_HEAD_P(skb),
+	    MISDN_HEADER_LEN);
+
+	err = skb_copy_datagram_iovec(skb, 0, msg->msg_iov, copied);
+
+	mISDN_sock_cmsg(sk, msg, skb);
+
+	skb_free_datagram(sk, skb);
+
+	return err ? : copied;
+}
+
+static int
+mISDN_sock_sendmsg(struct kiocb *iocb, struct socket *sock,
+    struct msghdr *msg, size_t len)
+{
+	struct sock		*sk = sock->sk;
+	struct sk_buff		*skb;
+	int			err = -ENOMEM;
+	struct sockaddr_mISDN	*maddr;
+
+	if (*debug & DEBUG_SOCKET)
+		printk(KERN_DEBUG "%s: len %d flags %x ch %d proto %x\n",
+		     __func__, (int)len, msg->msg_flags, _pms(sk)->ch.nr,
+		     sk->sk_protocol);
+
+	if (msg->msg_flags & MSG_OOB)
+		return -EOPNOTSUPP;
+
+	if (msg->msg_flags & ~(MSG_DONTWAIT|MSG_NOSIGNAL|MSG_ERRQUEUE))
+		return -EINVAL;
+
+	if (len < MISDN_HEADER_LEN)
+		return -EINVAL;
+
+	if (sk->sk_state != MISDN_BOUND)
+		return -EBADFD;
+
+	lock_sock(sk);
+
+	skb = _l2_alloc_skb(len, GFP_KERNEL);
+	if (!skb)
+		goto done;
+
+	if (memcpy_fromiovec(skb_put(skb, len), msg->msg_iov, len)) {
+		err = -EFAULT;
+		goto drop;
+	}
+
+	memcpy(mISDN_HEAD_P(skb), skb->data, MISDN_HEADER_LEN);
+	skb_pull(skb, MISDN_HEADER_LEN);
+
+	if (msg->msg_namelen >= sizeof(struct sockaddr_mISDN)) {
+		/* if we have a address, we use it */
+		maddr = (struct sockaddr_mISDN *)msg->msg_name;
+		mISDN_HEAD_ID(skb) = maddr->channel;
+	} else { /* use default for L2 messages */
+		if ((sk->sk_protocol == ISDN_P_LAPD_TE) ||
+		    (sk->sk_protocol == ISDN_P_LAPD_NT))
+		    mISDN_HEAD_ID(skb) = _pms(sk)->ch.nr;
+	}
+
+	if (*debug & DEBUG_SOCKET)
+		printk(KERN_DEBUG "%s: ID:%x\n",
+		     __func__, mISDN_HEAD_ID(skb));
+
+	err = -ENODEV;
+	if (!_pms(sk)->ch.peer ||
+	    (err = _pms(sk)->ch.recv(_pms(sk)->ch.peer, skb)))
+		goto drop;
+
+	err = len;
+
+done:
+	release_sock(sk);
+	return err;
+
+drop:
+	kfree_skb(skb);
+	goto done;
+}
+
+static int
+data_sock_release(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+
+	if (*debug & DEBUG_SOCKET)
+		printk(KERN_DEBUG "%s(%p) sk=%p\n", __func__, sock, sk);
+	if (!sk)
+		return 0;
+	switch (sk->sk_protocol) {
+	case ISDN_P_TE_S0:
+	case ISDN_P_NT_S0:
+	case ISDN_P_TE_E1:
+	case ISDN_P_NT_E1:
+		if (sk->sk_state == MISDN_BOUND)
+			delete_channel(&_pms(sk)->ch);
+		else
+			mISDN_sock_unlink(&data_sockets, sk);
+		break;
+	case ISDN_P_LAPD_TE:
+	case ISDN_P_LAPD_NT:
+	case ISDN_P_B_RAW:
+	case ISDN_P_B_HDLC:
+	case ISDN_P_B_X75SLP:
+	case ISDN_P_B_L2DTMF:
+	case ISDN_P_B_L2DSP:
+	case ISDN_P_B_L2DSPHDLC:
+		delete_channel(&_pms(sk)->ch);
+		mISDN_sock_unlink(&data_sockets, sk);
+		break;
+	}
+
+	lock_sock(sk);
+
+	sock_orphan(sk);
+	skb_queue_purge(&sk->sk_receive_queue);
+
+	release_sock(sk);
+	sock_put(sk);
+
+	return 0;
+}
+
+static int
+data_sock_ioctl_bound(struct sock *sk, unsigned int cmd, void __user *p)
+{
+	struct mISDN_ctrl_req	cq;
+	int			err = -EINVAL, val;
+	struct mISDNchannel	*bchan, *next;
+
+	lock_sock(sk);
+	if (!_pms(sk)->dev) {
+		err = -ENODEV;
+		goto done;
+	}
+	switch (cmd) {
+	case IMCTRLREQ:
+		if (copy_from_user(&cq, p, sizeof(cq))) {
+			err = -EFAULT;
+			break;
+		}
+		if ((sk->sk_protocol & ~ISDN_P_B_MASK) == ISDN_P_B_START) {
+			list_for_each_entry_safe(bchan, next,
+				&_pms(sk)->dev->bchannels, list) {
+				if (bchan->nr == cq.channel) {
+					err = bchan->ctrl(bchan,
+						CONTROL_CHANNEL, &cq);
+					break;
+				}
+			}
+		} else
+			err = _pms(sk)->dev->D.ctrl(&_pms(sk)->dev->D,
+				CONTROL_CHANNEL, &cq);
+		if (err)
+			break;
+		if (copy_to_user(p, &cq, sizeof(cq)))
+			err = -EFAULT;
+		break;
+	case IMCLEAR_L2:
+		if (sk->sk_protocol != ISDN_P_LAPD_NT) {
+			err = -EINVAL;
+			break;
+		}
+		if (get_user(val, (int __user *)p)) {
+			err = -EFAULT;
+			break;
+		}
+		err = _pms(sk)->dev->teimgr->ctrl(_pms(sk)->dev->teimgr,
+		    CONTROL_CHANNEL, &val);
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	}
+done:
+	release_sock(sk);
+	return err;
+}
+
+static int
+data_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
+{
+	int 			err = 0, id;
+	struct sock		*sk = sock->sk;
+	struct mISDNdevice	*dev;
+	struct mISDNversion	ver;
+
+	switch (cmd) {
+	case IMGETVERSION:
+		ver.major = MISDN_MAJOR_VERSION;
+		ver.minor = MISDN_MINOR_VERSION;
+		ver.release = MISDN_RELEASE;
+		if (copy_to_user((void __user *)arg, &ver, sizeof(ver)))
+			err = -EFAULT;
+		break;
+	case IMGETCOUNT:
+		id = get_mdevice_count();
+		if (put_user(id, (int __user *)arg))
+			err = -EFAULT;
+		break;
+	case IMGETDEVINFO:
+		if (get_user(id, (int __user *)arg)) {
+			err = -EFAULT;
+			break;
+		}
+		dev = get_mdevice(id);
+		if (dev) {
+			struct mISDN_devinfo di;
+
+			di.id = dev->id;
+			di.Dprotocols = dev->Dprotocols;
+			di.Bprotocols = dev->Bprotocols | get_all_Bprotocols();
+			di.protocol = dev->D.protocol;
+			memcpy(di.channelmap, dev->channelmap,
+				MISDN_CHMAP_SIZE * 4);
+			di.nrbchan = dev->nrbchan;
+			strcpy(di.name, dev->name);
+			if (copy_to_user((void __user *)arg, &di, sizeof(di)))
+				err = -EFAULT;
+		} else
+			err = -ENODEV;
+		break;
+	default:
+		if (sk->sk_state == MISDN_BOUND)
+			err = data_sock_ioctl_bound(sk, cmd,
+				(void __user *)arg);
+		else
+			err = -ENOTCONN;
+	}
+	return err;
+}
+
+static int data_sock_setsockopt(struct socket *sock, int level, int optname,
+	char __user *optval, int len)
+{
+	struct sock *sk = sock->sk;
+	int err = 0, opt = 0;
+
+	if (*debug & DEBUG_SOCKET)
+		printk(KERN_DEBUG "%s(%p, %d, %x, %p, %d)\n", __func__, sock,
+		    level, optname, optval, len);
+
+	lock_sock(sk);
+
+	switch (optname) {
+	case MISDN_TIME_STAMP:
+		if (get_user(opt, (int __user *)optval)) {
+			err = -EFAULT;
+			break;
+		}
+
+		if (opt)
+			_pms(sk)->cmask |= MISDN_TIME_STAMP;
+		else
+			_pms(sk)->cmask &= ~MISDN_TIME_STAMP;
+		break;
+	default:
+		err = -ENOPROTOOPT;
+		break;
+	}
+	release_sock(sk);
+	return err;
+}
+
+static int data_sock_getsockopt(struct socket *sock, int level, int optname,
+	char __user *optval, int __user *optlen)
+{
+	struct sock *sk = sock->sk;
+	int len, opt;
+
+	if (get_user(len, optlen))
+		return -EFAULT;
+
+	switch (optname) {
+	case MISDN_TIME_STAMP:
+		if (_pms(sk)->cmask & MISDN_TIME_STAMP)
+			opt = 1;
+		else
+			opt = 0;
+
+		if (put_user(opt, optval))
+			return -EFAULT;
+		break;
+	default:
+		return -ENOPROTOOPT;
+	}
+
+	return 0;
+}
+
+static int
+data_sock_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
+{
+	struct sockaddr_mISDN *maddr = (struct sockaddr_mISDN *) addr;
+	struct sock *sk = sock->sk;
+	int err = 0;
+
+	if (*debug & DEBUG_SOCKET)
+		printk(KERN_DEBUG "%s(%p) sk=%p\n", __func__, sock, sk);
+	if (addr_len != sizeof(struct sockaddr_mISDN))
+		return -EINVAL;
+	if (!maddr || maddr->family != AF_ISDN)
+		return -EINVAL;
+
+	lock_sock(sk);
+
+	if (_pms(sk)->dev) {
+		err = -EALREADY;
+		goto done;
+	}
+	_pms(sk)->dev = get_mdevice(maddr->dev);
+	if (!_pms(sk)->dev) {
+		err = -ENODEV;
+		goto done;
+	}
+	_pms(sk)->ch.send = mISDN_send;
+	_pms(sk)->ch.ctrl = mISDN_ctrl;
+
+	switch (sk->sk_protocol) {
+	case ISDN_P_TE_S0:
+	case ISDN_P_NT_S0:
+	case ISDN_P_TE_E1:
+	case ISDN_P_NT_E1:
+		mISDN_sock_unlink(&data_sockets, sk);
+		err = connect_layer1(_pms(sk)->dev, &_pms(sk)->ch,
+		    sk->sk_protocol, maddr);
+		if (err)
+			mISDN_sock_link(&data_sockets, sk);
+		break;
+	case ISDN_P_LAPD_TE:
+	case ISDN_P_LAPD_NT:
+		err = create_l2entity(_pms(sk)->dev, &_pms(sk)->ch,
+		    sk->sk_protocol, maddr);
+		break;
+	case ISDN_P_B_RAW:
+	case ISDN_P_B_HDLC:
+	case ISDN_P_B_X75SLP:
+	case ISDN_P_B_L2DTMF:
+	case ISDN_P_B_L2DSP:
+	case ISDN_P_B_L2DSPHDLC:
+		err = connect_Bstack(_pms(sk)->dev, &_pms(sk)->ch,
+		    sk->sk_protocol, maddr);
+		break;
+	default:
+		err = -EPROTONOSUPPORT;
+	}
+	if (err)
+		goto done;
+	sk->sk_state = MISDN_BOUND;
+	_pms(sk)->ch.protocol = sk->sk_protocol;
+
+done:
+	release_sock(sk);
+	return err;
+}
+
+static int
+data_sock_getname(struct socket *sock, struct sockaddr *addr,
+    int *addr_len, int peer)
+{
+	struct sockaddr_mISDN 	*maddr = (struct sockaddr_mISDN *) addr;
+	struct sock		*sk = sock->sk;
+
+	if (!_pms(sk)->dev)
+		return -EBADFD;
+
+	lock_sock(sk);
+
+	*addr_len = sizeof(*maddr);
+	maddr->dev = _pms(sk)->dev->id;
+	maddr->channel = _pms(sk)->ch.nr;
+	maddr->sapi = _pms(sk)->ch.addr & 0xff;
+	maddr->tei = (_pms(sk)->ch.addr >> 8) & 0xff;
+	release_sock(sk);
+	return 0;
+}
+
+static const struct proto_ops data_sock_ops = {
+	.family		= PF_ISDN,
+	.owner		= THIS_MODULE,
+	.release	= data_sock_release,
+	.ioctl		= data_sock_ioctl,
+	.bind		= data_sock_bind,
+	.getname	= data_sock_getname,
+	.sendmsg	= mISDN_sock_sendmsg,
+	.recvmsg	= mISDN_sock_recvmsg,
+	.poll		= datagram_poll,
+	.listen		= sock_no_listen,
+	.shutdown	= sock_no_shutdown,
+	.setsockopt	= data_sock_setsockopt,
+	.getsockopt	= data_sock_getsockopt,
+	.connect	= sock_no_connect,
+	.socketpair	= sock_no_socketpair,
+	.accept		= sock_no_accept,
+	.mmap		= sock_no_mmap
+};
+
+static int
+data_sock_create(struct net *net, struct socket *sock, int protocol)
+{
+	struct sock *sk;
+
+	if (sock->type != SOCK_DGRAM)
+		return -ESOCKTNOSUPPORT;
+
+	sk = sk_alloc(net, PF_ISDN, GFP_KERNEL, &mISDN_proto);
+	if (!sk)
+		return -ENOMEM;
+
+	sock_init_data(sock, sk);
+
+	sock->ops = &data_sock_ops;
+	sock->state = SS_UNCONNECTED;
+	sock_reset_flag(sk, SOCK_ZAPPED);
+
+	sk->sk_protocol = protocol;
+	sk->sk_state    = MISDN_OPEN;
+	mISDN_sock_link(&data_sockets, sk);
+
+	return 0;
+}
+
+static int
+base_sock_release(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+
+	printk(KERN_DEBUG "%s(%p) sk=%p\n", __func__, sock, sk);
+	if (!sk)
+		return 0;
+
+	mISDN_sock_unlink(&base_sockets, sk);
+	sock_orphan(sk);
+	sock_put(sk);
+
+	return 0;
+}
+
+static int
+base_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
+{
+	int 			err = 0, id;
+	struct mISDNdevice	*dev;
+	struct mISDNversion	ver;
+
+	switch (cmd) {
+	case IMGETVERSION:
+		ver.major = MISDN_MAJOR_VERSION;
+		ver.minor = MISDN_MINOR_VERSION;
+		ver.release = MISDN_RELEASE;
+		if (copy_to_user((void __user *)arg, &ver, sizeof(ver)))
+			err = -EFAULT;
+		break;
+	case IMGETCOUNT:
+		id = get_mdevice_count();
+		if (put_user(id, (int __user *)arg))
+			err = -EFAULT;
+		break;
+	case IMGETDEVINFO:
+		if (get_user(id, (int __user *)arg)) {
+			err = -EFAULT;
+			break;
+		}
+		dev = get_mdevice(id);
+		if (dev) {
+			struct mISDN_devinfo di;
+
+			di.id = dev->id;
+			di.Dprotocols = dev->Dprotocols;
+			di.Bprotocols = dev->Bprotocols | get_all_Bprotocols();
+			di.protocol = dev->D.protocol;
+			memcpy(di.channelmap, dev->channelmap,
+				MISDN_CHMAP_SIZE * 4);
+			di.nrbchan = dev->nrbchan;
+			strcpy(di.name, dev->name);
+			if (copy_to_user((void __user *)arg, &di, sizeof(di)))
+				err = -EFAULT;
+		} else
+			err = -ENODEV;
+		break;
+	default:
+		err = -EINVAL;
+	}
+	return err;
+}
+
+static int
+base_sock_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
+{
+	struct sockaddr_mISDN *maddr = (struct sockaddr_mISDN *) addr;
+	struct sock *sk = sock->sk;
+	int err = 0;
+
+	if (!maddr || maddr->family != AF_ISDN)
+		return -EINVAL;
+
+	lock_sock(sk);
+
+	if (_pms(sk)->dev) {
+		err = -EALREADY;
+		goto done;
+	}
+
+	_pms(sk)->dev = get_mdevice(maddr->dev);
+	if (!_pms(sk)->dev) {
+		err = -ENODEV;
+		goto done;
+	}
+	sk->sk_state = MISDN_BOUND;
+
+done:
+	release_sock(sk);
+	return err;
+}
+
+static const struct proto_ops base_sock_ops = {
+	.family		= PF_ISDN,
+	.owner		= THIS_MODULE,
+	.release	= base_sock_release,
+	.ioctl		= base_sock_ioctl,
+	.bind		= base_sock_bind,
+	.getname	= sock_no_getname,
+	.sendmsg	= sock_no_sendmsg,
+	.recvmsg	= sock_no_recvmsg,
+	.poll		= sock_no_poll,
+	.listen		= sock_no_listen,
+	.shutdown	= sock_no_shutdown,
+	.setsockopt	= sock_no_setsockopt,
+	.getsockopt	= sock_no_getsockopt,
+	.connect	= sock_no_connect,
+	.socketpair	= sock_no_socketpair,
+	.accept		= sock_no_accept,
+	.mmap		= sock_no_mmap
+};
+
+
+static int
+base_sock_create(struct net *net, struct socket *sock, int protocol)
+{
+	struct sock *sk;
+
+	if (sock->type != SOCK_RAW)
+		return -ESOCKTNOSUPPORT;
+
+	sk = sk_alloc(net, PF_ISDN, GFP_KERNEL, &mISDN_proto);
+	if (!sk)
+		return -ENOMEM;
+
+	sock_init_data(sock, sk);
+	sock->ops = &base_sock_ops;
+	sock->state = SS_UNCONNECTED;
+	sock_reset_flag(sk, SOCK_ZAPPED);
+	sk->sk_protocol = protocol;
+	sk->sk_state    = MISDN_OPEN;
+	mISDN_sock_link(&base_sockets, sk);
+
+	return 0;
+}
+
+static int
+mISDN_sock_create(struct net *net, struct socket *sock, int proto)
+{
+	int err = -EPROTONOSUPPORT;
+
+	switch	(proto) {
+	case ISDN_P_BASE:
+		err = base_sock_create(net, sock, proto);
+		break;
+	case ISDN_P_TE_S0:
+	case ISDN_P_NT_S0:
+	case ISDN_P_TE_E1:
+	case ISDN_P_NT_E1:
+	case ISDN_P_LAPD_TE:
+	case ISDN_P_LAPD_NT:
+	case ISDN_P_B_RAW:
+	case ISDN_P_B_HDLC:
+	case ISDN_P_B_X75SLP:
+	case ISDN_P_B_L2DTMF:
+	case ISDN_P_B_L2DSP:
+	case ISDN_P_B_L2DSPHDLC:
+		err = data_sock_create(net, sock, proto);
+		break;
+	default:
+		return err;
+	}
+
+	return err;
+}
+
+static struct
+net_proto_family mISDN_sock_family_ops = {
+	.owner  = THIS_MODULE,
+	.family = PF_ISDN,
+	.create = mISDN_sock_create,
+};
+
+int
+misdn_sock_init(u_int *deb)
+{
+	int err;
+
+	debug = deb;
+	err = sock_register(&mISDN_sock_family_ops);
+	if (err)
+		printk(KERN_ERR "%s: error(%d)\n", __func__, err);
+	return err;
+}
+
+void
+misdn_sock_cleanup(void)
+{
+	sock_unregister(PF_ISDN);
+}
+
diff --git a/drivers/isdn/mISDN/stack.c b/drivers/isdn/mISDN/stack.c
new file mode 100644
index 0000000..54cfddc
--- /dev/null
+++ b/drivers/isdn/mISDN/stack.c
@@ -0,0 +1,674 @@
+/*
+ *
+ * Author	Karsten Keil <kkeil@novell.com>
+ *
+ * Copyright 2008  by Karsten Keil <kkeil@novell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/mISDNif.h>
+#include <linux/kthread.h>
+#include "core.h"
+
+static u_int	*debug;
+
+static inline void
+_queue_message(struct mISDNstack *st, struct sk_buff *skb)
+{
+	struct mISDNhead	*hh = mISDN_HEAD_P(skb);
+
+	if (*debug & DEBUG_QUEUE_FUNC)
+		printk(KERN_DEBUG "%s prim(%x) id(%x) %p\n",
+		    __func__, hh->prim, hh->id, skb);
+	skb_queue_tail(&st->msgq, skb);
+	if (likely(!test_bit(mISDN_STACK_STOPPED, &st->status))) {
+		test_and_set_bit(mISDN_STACK_WORK, &st->status);
+		wake_up_interruptible(&st->workq);
+	}
+}
+
+int
+mISDN_queue_message(struct mISDNchannel *ch, struct sk_buff *skb)
+{
+	_queue_message(ch->st, skb);
+	return 0;
+}
+
+static struct mISDNchannel *
+get_channel4id(struct mISDNstack *st, u_int id)
+{
+	struct mISDNchannel	*ch;
+
+	mutex_lock(&st->lmutex);
+	list_for_each_entry(ch, &st->layer2, list) {
+		if (id == ch->nr)
+			goto unlock;
+	}
+	ch = NULL;
+unlock:
+	mutex_unlock(&st->lmutex);
+	return ch;
+}
+
+static void
+send_socklist(struct mISDN_sock_list *sl, struct sk_buff *skb)
+{
+	struct hlist_node	*node;
+	struct sock		*sk;
+	struct sk_buff		*cskb = NULL;
+
+	read_lock(&sl->lock);
+	sk_for_each(sk, node, &sl->head) {
+		if (sk->sk_state != MISDN_BOUND)
+			continue;
+		if (!cskb)
+			cskb = skb_copy(skb, GFP_KERNEL);
+		if (!cskb) {
+			printk(KERN_WARNING "%s no skb\n", __func__);
+			break;
+		}
+		if (!sock_queue_rcv_skb(sk, cskb))
+			cskb = NULL;
+	}
+	read_unlock(&sl->lock);
+	if (cskb)
+		dev_kfree_skb(cskb);
+}
+
+static void
+send_layer2(struct mISDNstack *st, struct sk_buff *skb)
+{
+	struct sk_buff		*cskb;
+	struct mISDNhead	*hh = mISDN_HEAD_P(skb);
+	struct mISDNchannel	*ch;
+	int			ret;
+
+	if (!st)
+		return;
+	mutex_lock(&st->lmutex);
+	if ((hh->id & MISDN_ID_ADDR_MASK) == MISDN_ID_ANY) { /* L2 for all */
+		list_for_each_entry(ch, &st->layer2, list) {
+			if (list_is_last(&ch->list, &st->layer2)) {
+				cskb = skb;
+				skb = NULL;
+			} else {
+				cskb = skb_copy(skb, GFP_KERNEL);
+			}
+			if (cskb) {
+				ret = ch->send(ch, cskb);
+				if (ret) {
+					if (*debug & DEBUG_SEND_ERR)
+						printk(KERN_DEBUG
+						    "%s ch%d prim(%x) addr(%x)"
+						    " err %d\n",
+						    __func__, ch->nr,
+						    hh->prim, ch->addr, ret);
+					dev_kfree_skb(cskb);
+				}
+			} else {
+				printk(KERN_WARNING "%s ch%d addr %x no mem\n",
+				    __func__, ch->nr, ch->addr);
+				goto out;
+			}
+		}
+	} else {
+		list_for_each_entry(ch, &st->layer2, list) {
+			if ((hh->id & MISDN_ID_ADDR_MASK) == ch->addr) {
+				ret = ch->send(ch, skb);
+				if (!ret)
+					skb = NULL;
+				goto out;
+			}
+		}
+		ret = st->dev->teimgr->ctrl(st->dev->teimgr, CHECK_DATA, skb);
+		if (!ret)
+			skb = NULL;
+		else if (*debug & DEBUG_SEND_ERR)
+			printk(KERN_DEBUG
+			    "%s ch%d mgr prim(%x) addr(%x) err %d\n",
+			    __func__, ch->nr, hh->prim, ch->addr, ret);
+	}
+out:
+	mutex_unlock(&st->lmutex);
+	if (skb)
+		dev_kfree_skb(skb);
+}
+
+static inline int
+send_msg_to_layer(struct mISDNstack *st, struct sk_buff *skb)
+{
+	struct mISDNhead	*hh = mISDN_HEAD_P(skb);
+	struct mISDNchannel	*ch;
+	int	lm;
+
+	lm = hh->prim & MISDN_LAYERMASK;
+	if (*debug & DEBUG_QUEUE_FUNC)
+		printk(KERN_DEBUG "%s prim(%x) id(%x) %p\n",
+		    __func__, hh->prim, hh->id, skb);
+	if (lm == 0x1) {
+		if (!hlist_empty(&st->l1sock.head)) {
+			__net_timestamp(skb);
+			send_socklist(&st->l1sock, skb);
+		}
+		return st->layer1->send(st->layer1, skb);
+	} else if (lm == 0x2) {
+		if (!hlist_empty(&st->l1sock.head))
+			send_socklist(&st->l1sock, skb);
+		send_layer2(st, skb);
+		return 0;
+	} else if (lm == 0x4) {
+		ch = get_channel4id(st, hh->id);
+		if (ch)
+			return ch->send(ch, skb);
+		else
+			printk(KERN_WARNING
+			    "%s: dev(%s) prim(%x) id(%x) no channel\n",
+			    __func__, st->dev->name, hh->prim, hh->id);
+	} else if (lm == 0x8) {
+		WARN_ON(lm == 0x8);
+		ch = get_channel4id(st, hh->id);
+		if (ch)
+			return ch->send(ch, skb);
+		else
+			printk(KERN_WARNING
+			    "%s: dev(%s) prim(%x) id(%x) no channel\n",
+			    __func__, st->dev->name, hh->prim, hh->id);
+	} else {
+		/* broadcast not handled yet */
+		printk(KERN_WARNING "%s: dev(%s) prim %x not delivered\n",
+		    __func__, st->dev->name, hh->prim);
+	}
+	return -ESRCH;
+}
+
+static void
+do_clear_stack(struct mISDNstack *st)
+{
+}
+
+static int
+mISDNStackd(void *data)
+{
+	struct mISDNstack *st = data;
+	int err = 0;
+
+#ifdef CONFIG_SMP
+	lock_kernel();
+#endif
+	sigfillset(&current->blocked);
+#ifdef CONFIG_SMP
+	unlock_kernel();
+#endif
+	if (*debug & DEBUG_MSG_THREAD)
+		printk(KERN_DEBUG "mISDNStackd %s started\n", st->dev->name);
+
+	if (st->notify != NULL) {
+		complete(st->notify);
+		st->notify = NULL;
+	}
+
+	for (;;) {
+		struct sk_buff	*skb;
+
+		if (unlikely(test_bit(mISDN_STACK_STOPPED, &st->status))) {
+			test_and_clear_bit(mISDN_STACK_WORK, &st->status);
+			test_and_clear_bit(mISDN_STACK_RUNNING, &st->status);
+		} else
+			test_and_set_bit(mISDN_STACK_RUNNING, &st->status);
+		while (test_bit(mISDN_STACK_WORK, &st->status)) {
+			skb = skb_dequeue(&st->msgq);
+			if (!skb) {
+				test_and_clear_bit(mISDN_STACK_WORK,
+					&st->status);
+				/* test if a race happens */
+				skb = skb_dequeue(&st->msgq);
+				if (!skb)
+					continue;
+				test_and_set_bit(mISDN_STACK_WORK,
+				    &st->status);
+			}
+#ifdef MISDN_MSG_STATS
+			st->msg_cnt++;
+#endif
+			err = send_msg_to_layer(st, skb);
+			if (unlikely(err)) {
+				if (*debug & DEBUG_SEND_ERR)
+					printk(KERN_DEBUG
+					    "%s: %s prim(%x) id(%x) "
+					    "send call(%d)\n",
+					    __func__, st->dev->name,
+					    mISDN_HEAD_PRIM(skb),
+					    mISDN_HEAD_ID(skb), err);
+				dev_kfree_skb(skb);
+				continue;
+			}
+			if (unlikely(test_bit(mISDN_STACK_STOPPED,
+			    &st->status))) {
+				test_and_clear_bit(mISDN_STACK_WORK,
+				    &st->status);
+				test_and_clear_bit(mISDN_STACK_RUNNING,
+				    &st->status);
+				break;
+			}
+		}
+		if (test_bit(mISDN_STACK_CLEARING, &st->status)) {
+			test_and_set_bit(mISDN_STACK_STOPPED, &st->status);
+			test_and_clear_bit(mISDN_STACK_RUNNING, &st->status);
+			do_clear_stack(st);
+			test_and_clear_bit(mISDN_STACK_CLEARING, &st->status);
+			test_and_set_bit(mISDN_STACK_RESTART, &st->status);
+		}
+		if (test_and_clear_bit(mISDN_STACK_RESTART, &st->status)) {
+			test_and_clear_bit(mISDN_STACK_STOPPED, &st->status);
+			test_and_set_bit(mISDN_STACK_RUNNING, &st->status);
+			if (!skb_queue_empty(&st->msgq))
+				test_and_set_bit(mISDN_STACK_WORK,
+				    &st->status);
+		}
+		if (test_bit(mISDN_STACK_ABORT, &st->status))
+			break;
+		if (st->notify != NULL) {
+			complete(st->notify);
+			st->notify = NULL;
+		}
+#ifdef MISDN_MSG_STATS
+		st->sleep_cnt++;
+#endif
+		test_and_clear_bit(mISDN_STACK_ACTIVE, &st->status);
+		wait_event_interruptible(st->workq, (st->status &
+		    mISDN_STACK_ACTION_MASK));
+		if (*debug & DEBUG_MSG_THREAD)
+			printk(KERN_DEBUG "%s: %s wake status %08lx\n",
+			    __func__, st->dev->name, st->status);
+		test_and_set_bit(mISDN_STACK_ACTIVE, &st->status);
+
+		test_and_clear_bit(mISDN_STACK_WAKEUP, &st->status);
+
+		if (test_bit(mISDN_STACK_STOPPED, &st->status)) {
+			test_and_clear_bit(mISDN_STACK_RUNNING, &st->status);
+#ifdef MISDN_MSG_STATS
+			st->stopped_cnt++;
+#endif
+		}
+	}
+#ifdef MISDN_MSG_STATS
+	printk(KERN_DEBUG "mISDNStackd daemon for %s proceed %d "
+	    "msg %d sleep %d stopped\n",
+	    st->dev->name, st->msg_cnt, st->sleep_cnt, st->stopped_cnt);
+	printk(KERN_DEBUG
+	    "mISDNStackd daemon for %s utime(%ld) stime(%ld)\n",
+	    st->dev->name, st->thread->utime, st->thread->stime);
+	printk(KERN_DEBUG
+	    "mISDNStackd daemon for %s nvcsw(%ld) nivcsw(%ld)\n",
+	    st->dev->name, st->thread->nvcsw, st->thread->nivcsw);
+	printk(KERN_DEBUG "mISDNStackd daemon for %s killed now\n",
+	    st->dev->name);
+#endif
+	test_and_set_bit(mISDN_STACK_KILLED, &st->status);
+	test_and_clear_bit(mISDN_STACK_RUNNING, &st->status);
+	test_and_clear_bit(mISDN_STACK_ACTIVE, &st->status);
+	test_and_clear_bit(mISDN_STACK_ABORT, &st->status);
+	skb_queue_purge(&st->msgq);
+	st->thread = NULL;
+	if (st->notify != NULL) {
+		complete(st->notify);
+		st->notify = NULL;
+	}
+	return 0;
+}
+
+static int
+l1_receive(struct mISDNchannel *ch, struct sk_buff *skb)
+{
+	if (!ch->st)
+		return -ENODEV;
+	__net_timestamp(skb);
+	_queue_message(ch->st, skb);
+	return 0;
+}
+
+void
+set_channel_address(struct mISDNchannel *ch, u_int sapi, u_int tei)
+{
+	ch->addr = sapi | (tei << 8);
+}
+
+void
+__add_layer2(struct mISDNchannel *ch, struct mISDNstack *st)
+{
+	list_add_tail(&ch->list, &st->layer2);
+}
+
+void
+add_layer2(struct mISDNchannel *ch, struct mISDNstack *st)
+{
+	mutex_lock(&st->lmutex);
+	__add_layer2(ch, st);
+	mutex_unlock(&st->lmutex);
+}
+
+static int
+st_own_ctrl(struct mISDNchannel *ch, u_int cmd, void *arg)
+{
+	if (!ch->st || ch->st->layer1)
+		return -EINVAL;
+	return ch->st->layer1->ctrl(ch->st->layer1, cmd, arg);
+}
+
+int
+create_stack(struct mISDNdevice *dev)
+{
+	struct mISDNstack	*newst;
+	int			err;
+	DECLARE_COMPLETION_ONSTACK(done);
+
+	newst = kzalloc(sizeof(struct mISDNstack), GFP_KERNEL);
+	if (!newst) {
+		printk(KERN_ERR "kmalloc mISDN_stack failed\n");
+		return -ENOMEM;
+	}
+	newst->dev = dev;
+	INIT_LIST_HEAD(&newst->layer2);
+	INIT_HLIST_HEAD(&newst->l1sock.head);
+	rwlock_init(&newst->l1sock.lock);
+	init_waitqueue_head(&newst->workq);
+	skb_queue_head_init(&newst->msgq);
+	mutex_init(&newst->lmutex);
+	dev->D.st = newst;
+	err = create_teimanager(dev);
+	if (err) {
+		printk(KERN_ERR "kmalloc teimanager failed\n");
+		kfree(newst);
+		return err;
+	}
+	dev->teimgr->peer = &newst->own;
+	dev->teimgr->recv = mISDN_queue_message;
+	dev->teimgr->st = newst;
+	newst->layer1 = &dev->D;
+	dev->D.recv = l1_receive;
+	dev->D.peer = &newst->own;
+	newst->own.st = newst;
+	newst->own.ctrl = st_own_ctrl;
+	newst->own.send = mISDN_queue_message;
+	newst->own.recv = mISDN_queue_message;
+	if (*debug & DEBUG_CORE_FUNC)
+		printk(KERN_DEBUG "%s: st(%s)\n", __func__, newst->dev->name);
+	newst->notify = &done;
+	newst->thread = kthread_run(mISDNStackd, (void *)newst, "mISDN_%s",
+		newst->dev->name);
+	if (IS_ERR(newst->thread)) {
+		err = PTR_ERR(newst->thread);
+		printk(KERN_ERR
+			"mISDN:cannot create kernel thread for %s (%d)\n",
+			newst->dev->name, err);
+		delete_teimanager(dev->teimgr);
+		kfree(newst);
+	} else
+		wait_for_completion(&done);
+	return err;
+}
+
+int
+connect_layer1(struct mISDNdevice *dev, struct mISDNchannel *ch,
+		u_int protocol, struct sockaddr_mISDN *adr)
+{
+	struct mISDN_sock	*msk = container_of(ch, struct mISDN_sock, ch);
+	struct channel_req	rq;
+	int			err;
+
+
+	if (*debug &  DEBUG_CORE_FUNC)
+		printk(KERN_DEBUG "%s: %s proto(%x) adr(%d %d %d %d)\n",
+			__func__, dev->name, protocol, adr->dev, adr->channel,
+			 adr->sapi, adr->tei);
+	switch (protocol) {
+	case ISDN_P_NT_S0:
+	case ISDN_P_NT_E1:
+	case ISDN_P_TE_S0:
+	case ISDN_P_TE_E1:
+#ifdef PROTOCOL_CHECK
+		/* this should be enhanced */
+		if (!list_empty(&dev->D.st->layer2)
+			&& dev->D.protocol != protocol)
+			return -EBUSY;
+		if (!hlist_empty(&dev->D.st->l1sock.head)
+			&& dev->D.protocol != protocol)
+			return -EBUSY;
+#endif
+		ch->recv = mISDN_queue_message;
+		ch->peer = &dev->D.st->own;
+		ch->st = dev->D.st;
+		rq.protocol = protocol;
+		rq.adr.channel = 0;
+		err = dev->D.ctrl(&dev->D, OPEN_CHANNEL, &rq);
+		printk(KERN_DEBUG "%s: ret 1 %d\n", __func__, err);
+		if (err)
+			return err;
+		write_lock_bh(&dev->D.st->l1sock.lock);
+		sk_add_node(&msk->sk, &dev->D.st->l1sock.head);
+		write_unlock_bh(&dev->D.st->l1sock.lock);
+		break;
+	default:
+		return -ENOPROTOOPT;
+	}
+	return 0;
+}
+
+int
+connect_Bstack(struct mISDNdevice *dev, struct mISDNchannel *ch,
+    u_int protocol, struct sockaddr_mISDN *adr)
+{
+	struct channel_req	rq, rq2;
+	int			pmask, err;
+	struct Bprotocol	*bp;
+
+	if (*debug &  DEBUG_CORE_FUNC)
+		printk(KERN_DEBUG "%s: %s proto(%x) adr(%d %d %d %d)\n",
+			__func__, dev->name, protocol,
+			adr->dev, adr->channel, adr->sapi,
+			adr->tei);
+	ch->st = dev->D.st;
+	pmask = 1 << (protocol & ISDN_P_B_MASK);
+	if (pmask & dev->Bprotocols) {
+		rq.protocol = protocol;
+		rq.adr = *adr;
+		err = dev->D.ctrl(&dev->D, OPEN_CHANNEL, &rq);
+		if (err)
+			return err;
+		ch->recv = rq.ch->send;
+		ch->peer = rq.ch;
+		rq.ch->recv = ch->send;
+		rq.ch->peer = ch;
+		rq.ch->st = dev->D.st;
+	} else {
+		bp = get_Bprotocol4mask(pmask);
+		if (!bp)
+			return -ENOPROTOOPT;
+		rq2.protocol = protocol;
+		rq2.adr = *adr;
+		rq2.ch = ch;
+		err = bp->create(&rq2);
+		if (err)
+			return err;
+		ch->recv = rq2.ch->send;
+		ch->peer = rq2.ch;
+		rq2.ch->st = dev->D.st;
+		rq.protocol = rq2.protocol;
+		rq.adr = *adr;
+		err = dev->D.ctrl(&dev->D, OPEN_CHANNEL, &rq);
+		if (err) {
+			rq2.ch->ctrl(rq2.ch, CLOSE_CHANNEL, NULL);
+			return err;
+		}
+		rq2.ch->recv = rq.ch->send;
+		rq2.ch->peer = rq.ch;
+		rq.ch->recv = rq2.ch->send;
+		rq.ch->peer = rq2.ch;
+		rq.ch->st = dev->D.st;
+	}
+	ch->protocol = protocol;
+	ch->nr = rq.ch->nr;
+	return 0;
+}
+
+int
+create_l2entity(struct mISDNdevice *dev, struct mISDNchannel *ch,
+    u_int protocol, struct sockaddr_mISDN *adr)
+{
+	struct channel_req	rq;
+	int			err;
+
+	if (*debug &  DEBUG_CORE_FUNC)
+		printk(KERN_DEBUG "%s: %s proto(%x) adr(%d %d %d %d)\n",
+			__func__, dev->name, protocol,
+			adr->dev, adr->channel, adr->sapi,
+			adr->tei);
+	rq.protocol = ISDN_P_TE_S0;
+	if (dev->Dprotocols & (1 << ISDN_P_TE_E1))
+		rq.protocol = ISDN_P_TE_E1;
+	switch (protocol) {
+	case ISDN_P_LAPD_NT:
+		rq.protocol = ISDN_P_NT_S0;
+		if (dev->Dprotocols & (1 << ISDN_P_NT_E1))
+			rq.protocol = ISDN_P_NT_E1;
+	case ISDN_P_LAPD_TE:
+#ifdef PROTOCOL_CHECK
+		/* this should be enhanced */
+		if (!list_empty(&dev->D.st->layer2)
+			&& dev->D.protocol != protocol)
+			return -EBUSY;
+		if (!hlist_empty(&dev->D.st->l1sock.head)
+			&& dev->D.protocol != protocol)
+			return -EBUSY;
+#endif
+		ch->recv = mISDN_queue_message;
+		ch->peer = &dev->D.st->own;
+		ch->st = dev->D.st;
+		rq.adr.channel = 0;
+		err = dev->D.ctrl(&dev->D, OPEN_CHANNEL, &rq);
+		printk(KERN_DEBUG "%s: ret 1 %d\n", __func__, err);
+		if (err)
+			break;
+		rq.protocol = protocol;
+		rq.adr = *adr;
+		rq.ch = ch;
+		err = dev->teimgr->ctrl(dev->teimgr, OPEN_CHANNEL, &rq);
+		printk(KERN_DEBUG "%s: ret 2 %d\n", __func__, err);
+		if (!err) {
+			if ((protocol == ISDN_P_LAPD_NT) && !rq.ch)
+				break;
+			add_layer2(rq.ch, dev->D.st);
+			rq.ch->recv = mISDN_queue_message;
+			rq.ch->peer = &dev->D.st->own;
+			rq.ch->ctrl(rq.ch, OPEN_CHANNEL, NULL); /* can't fail */
+		}
+		break;
+	default:
+		err = -EPROTONOSUPPORT;
+	}
+	return err;
+}
+
+void
+delete_channel(struct mISDNchannel *ch)
+{
+	struct mISDN_sock	*msk = container_of(ch, struct mISDN_sock, ch);
+	struct mISDNchannel	*pch;
+
+	if (!ch->st) {
+		printk(KERN_WARNING "%s: no stack\n", __func__);
+		return;
+	}
+	if (*debug & DEBUG_CORE_FUNC)
+		printk(KERN_DEBUG "%s: st(%s) protocol(%x)\n", __func__,
+		    ch->st->dev->name, ch->protocol);
+	if (ch->protocol >= ISDN_P_B_START) {
+		if (ch->peer) {
+			ch->peer->ctrl(ch->peer, CLOSE_CHANNEL, NULL);
+			ch->peer = NULL;
+		}
+		return;
+	}
+	switch (ch->protocol) {
+	case ISDN_P_NT_S0:
+	case ISDN_P_TE_S0:
+	case ISDN_P_NT_E1:
+	case ISDN_P_TE_E1:
+		write_lock_bh(&ch->st->l1sock.lock);
+		sk_del_node_init(&msk->sk);
+		write_unlock_bh(&ch->st->l1sock.lock);
+		ch->st->dev->D.ctrl(&ch->st->dev->D, CLOSE_CHANNEL, NULL);
+		break;
+	case ISDN_P_LAPD_TE:
+		pch = get_channel4id(ch->st, ch->nr);
+		if (pch) {
+			mutex_lock(&ch->st->lmutex);
+			list_del(&pch->list);
+			mutex_unlock(&ch->st->lmutex);
+			pch->ctrl(pch, CLOSE_CHANNEL, NULL);
+			pch = ch->st->dev->teimgr;
+			pch->ctrl(pch, CLOSE_CHANNEL, NULL);
+		} else
+			printk(KERN_WARNING "%s: no l2 channel\n",
+			    __func__);
+		break;
+	case ISDN_P_LAPD_NT:
+		pch = ch->st->dev->teimgr;
+		if (pch) {
+			pch->ctrl(pch, CLOSE_CHANNEL, NULL);
+		} else
+			printk(KERN_WARNING "%s: no l2 channel\n",
+			    __func__);
+		break;
+	default:
+		break;
+	}
+	return;
+}
+
+void
+delete_stack(struct mISDNdevice *dev)
+{
+	struct mISDNstack	*st = dev->D.st;
+	DECLARE_COMPLETION_ONSTACK(done);
+
+	if (*debug & DEBUG_CORE_FUNC)
+		printk(KERN_DEBUG "%s: st(%s)\n", __func__,
+		    st->dev->name);
+	if (dev->teimgr)
+		delete_teimanager(dev->teimgr);
+	if (st->thread) {
+		if (st->notify) {
+			printk(KERN_WARNING "%s: notifier in use\n",
+			    __func__);
+				complete(st->notify);
+		}
+		st->notify = &done;
+		test_and_set_bit(mISDN_STACK_ABORT, &st->status);
+		test_and_set_bit(mISDN_STACK_WAKEUP, &st->status);
+		wake_up_interruptible(&st->workq);
+		wait_for_completion(&done);
+	}
+	if (!list_empty(&st->layer2))
+		printk(KERN_WARNING "%s: layer2 list not empty\n",
+		    __func__);
+	if (!hlist_empty(&st->l1sock.head))
+		printk(KERN_WARNING "%s: layer1 list not empty\n",
+		    __func__);
+	kfree(st);
+}
+
+void
+mISDN_initstack(u_int *dp)
+{
+	debug = dp;
+}
diff --git a/drivers/isdn/mISDN/tei.c b/drivers/isdn/mISDN/tei.c
new file mode 100644
index 0000000..56a76a0
--- /dev/null
+++ b/drivers/isdn/mISDN/tei.c
@@ -0,0 +1,1340 @@
+/*
+ *
+ * Author	Karsten Keil <kkeil@novell.com>
+ *
+ * Copyright 2008  by Karsten Keil <kkeil@novell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#include "layer2.h"
+#include <linux/random.h>
+#include "core.h"
+
+#define ID_REQUEST	1
+#define ID_ASSIGNED	2
+#define ID_DENIED	3
+#define ID_CHK_REQ	4
+#define ID_CHK_RES	5
+#define ID_REMOVE	6
+#define ID_VERIFY	7
+
+#define TEI_ENTITY_ID	0xf
+
+#define MGR_PH_ACTIVE	16
+#define MGR_PH_NOTREADY	17
+
+#define DATIMER_VAL	10000
+
+static 	u_int	*debug;
+
+static struct Fsm deactfsm = {NULL, 0, 0, NULL, NULL};
+static struct Fsm teifsmu = {NULL, 0, 0, NULL, NULL};
+static struct Fsm teifsmn = {NULL, 0, 0, NULL, NULL};
+
+enum {
+	ST_L1_DEACT,
+	ST_L1_DEACT_PENDING,
+	ST_L1_ACTIV,
+};
+#define DEACT_STATE_COUNT (ST_L1_ACTIV+1)
+
+static char *strDeactState[] =
+{
+	"ST_L1_DEACT",
+	"ST_L1_DEACT_PENDING",
+	"ST_L1_ACTIV",
+};
+
+enum {
+	EV_ACTIVATE,
+	EV_ACTIVATE_IND,
+	EV_DEACTIVATE,
+	EV_DEACTIVATE_IND,
+	EV_UI,
+	EV_DATIMER,
+};
+
+#define DEACT_EVENT_COUNT (EV_DATIMER+1)
+
+static char *strDeactEvent[] =
+{
+	"EV_ACTIVATE",
+	"EV_ACTIVATE_IND",
+	"EV_DEACTIVATE",
+	"EV_DEACTIVATE_IND",
+	"EV_UI",
+	"EV_DATIMER",
+};
+
+static void
+da_debug(struct FsmInst *fi, char *fmt, ...)
+{
+	struct manager	*mgr = fi->userdata;
+	va_list va;
+
+	if (!(*debug & DEBUG_L2_TEIFSM))
+		return;
+	va_start(va, fmt);
+	printk(KERN_DEBUG "mgr(%d): ", mgr->ch.st->dev->id);
+	vprintk(fmt, va);
+	printk("\n");
+	va_end(va);
+}
+
+static void
+da_activate(struct FsmInst *fi, int event, void *arg)
+{
+	struct manager	*mgr = fi->userdata;
+
+	if (fi->state == ST_L1_DEACT_PENDING)
+		mISDN_FsmDelTimer(&mgr->datimer, 1);
+	mISDN_FsmChangeState(fi, ST_L1_ACTIV);
+}
+
+static void
+da_deactivate_ind(struct FsmInst *fi, int event, void *arg)
+{
+	mISDN_FsmChangeState(fi, ST_L1_DEACT);
+}
+
+static void
+da_deactivate(struct FsmInst *fi, int event, void *arg)
+{
+	struct manager	*mgr = fi->userdata;
+	struct layer2	*l2;
+	u_long		flags;
+
+	read_lock_irqsave(&mgr->lock, flags);
+	list_for_each_entry(l2, &mgr->layer2, list) {
+		if (l2->l2m.state > ST_L2_4) {
+			/* have still activ TEI */
+			read_unlock_irqrestore(&mgr->lock, flags);
+			return;
+		}
+	}
+	read_unlock_irqrestore(&mgr->lock, flags);
+	/* All TEI are inactiv */
+	mISDN_FsmAddTimer(&mgr->datimer, DATIMER_VAL, EV_DATIMER, NULL, 1);
+	mISDN_FsmChangeState(fi, ST_L1_DEACT_PENDING);
+}
+
+static void
+da_ui(struct FsmInst *fi, int event, void *arg)
+{
+	struct manager	*mgr = fi->userdata;
+
+	/* restart da timer */
+	mISDN_FsmDelTimer(&mgr->datimer, 2);
+	mISDN_FsmAddTimer(&mgr->datimer, DATIMER_VAL, EV_DATIMER, NULL, 2);
+
+}
+
+static void
+da_timer(struct FsmInst *fi, int event, void *arg)
+{
+	struct manager	*mgr = fi->userdata;
+	struct layer2	*l2;
+	u_long		flags;
+
+	/* check again */
+	read_lock_irqsave(&mgr->lock, flags);
+	list_for_each_entry(l2, &mgr->layer2, list) {
+		if (l2->l2m.state > ST_L2_4) {
+			/* have still activ TEI */
+			read_unlock_irqrestore(&mgr->lock, flags);
+			mISDN_FsmChangeState(fi, ST_L1_ACTIV);
+			return;
+		}
+	}
+	read_unlock_irqrestore(&mgr->lock, flags);
+	/* All TEI are inactiv */
+	mISDN_FsmChangeState(fi, ST_L1_DEACT);
+	_queue_data(&mgr->ch, PH_DEACTIVATE_REQ, MISDN_ID_ANY, 0, NULL,
+	    GFP_ATOMIC);
+}
+
+static struct FsmNode DeactFnList[] =
+{
+	{ST_L1_DEACT, EV_ACTIVATE_IND, da_activate},
+	{ST_L1_ACTIV, EV_DEACTIVATE_IND, da_deactivate_ind},
+	{ST_L1_ACTIV, EV_DEACTIVATE, da_deactivate},
+	{ST_L1_DEACT_PENDING, EV_ACTIVATE, da_activate},
+	{ST_L1_DEACT_PENDING, EV_UI, da_ui},
+	{ST_L1_DEACT_PENDING, EV_DATIMER, da_timer},
+};
+
+enum {
+	ST_TEI_NOP,
+	ST_TEI_IDREQ,
+	ST_TEI_IDVERIFY,
+};
+
+#define TEI_STATE_COUNT (ST_TEI_IDVERIFY+1)
+
+static char *strTeiState[] =
+{
+	"ST_TEI_NOP",
+	"ST_TEI_IDREQ",
+	"ST_TEI_IDVERIFY",
+};
+
+enum {
+	EV_IDREQ,
+	EV_ASSIGN,
+	EV_ASSIGN_REQ,
+	EV_DENIED,
+	EV_CHKREQ,
+	EV_CHKRESP,
+	EV_REMOVE,
+	EV_VERIFY,
+	EV_TIMER,
+};
+
+#define TEI_EVENT_COUNT (EV_TIMER+1)
+
+static char *strTeiEvent[] =
+{
+	"EV_IDREQ",
+	"EV_ASSIGN",
+	"EV_ASSIGN_REQ",
+	"EV_DENIED",
+	"EV_CHKREQ",
+	"EV_CHKRESP",
+	"EV_REMOVE",
+	"EV_VERIFY",
+	"EV_TIMER",
+};
+
+static void
+tei_debug(struct FsmInst *fi, char *fmt, ...)
+{
+	struct teimgr	*tm = fi->userdata;
+	va_list va;
+
+	if (!(*debug & DEBUG_L2_TEIFSM))
+		return;
+	va_start(va, fmt);
+	printk(KERN_DEBUG "tei(%d): ", tm->l2->tei);
+	vprintk(fmt, va);
+	printk("\n");
+	va_end(va);
+}
+
+
+
+static int
+get_free_id(struct manager *mgr)
+{
+	u64		ids = 0;
+	int		i;
+	struct layer2	*l2;
+
+	list_for_each_entry(l2, &mgr->layer2, list) {
+		if (l2->ch.nr > 63) {
+			printk(KERN_WARNING
+			    "%s: more as 63 layer2 for one device\n",
+			    __func__);
+			return -EBUSY;
+		}
+		test_and_set_bit(l2->ch.nr, (u_long *)&ids);
+	}
+	for (i = 1; i < 64; i++)
+		if (!test_bit(i, (u_long *)&ids))
+			return i;
+	printk(KERN_WARNING "%s: more as 63 layer2 for one device\n",
+	    __func__);
+	return -EBUSY;
+}
+
+static int
+get_free_tei(struct manager *mgr)
+{
+	u64		ids = 0;
+	int		i;
+	struct layer2	*l2;
+
+	list_for_each_entry(l2, &mgr->layer2, list) {
+		if (l2->ch.nr == 0)
+			continue;
+		if ((l2->ch.addr & 0xff) != 0)
+			continue;
+		i = l2->ch.addr >> 8;
+		if (i < 64)
+			continue;
+		i -= 64;
+
+		test_and_set_bit(i, (u_long *)&ids);
+	}
+	for (i = 0; i < 64; i++)
+		if (!test_bit(i, (u_long *)&ids))
+			return i + 64;
+	printk(KERN_WARNING "%s: more as 63 dynamic tei for one device\n",
+	    __func__);
+	return -1;
+}
+
+static void
+teiup_create(struct manager *mgr, u_int prim, int len, void *arg)
+{
+	struct sk_buff	*skb;
+	struct mISDNhead *hh;
+	int		err;
+
+	skb = mI_alloc_skb(len, GFP_ATOMIC);
+	if (!skb)
+		return;
+	hh = mISDN_HEAD_P(skb);
+	hh->prim = prim;
+	hh->id = (mgr->ch.nr << 16) | mgr->ch.addr;
+	if (len)
+		memcpy(skb_put(skb, len), arg, len);
+	err = mgr->up->send(mgr->up, skb);
+	if (err) {
+		printk(KERN_WARNING "%s: err=%d\n", __func__, err);
+		dev_kfree_skb(skb);
+	}
+}
+
+static u_int
+new_id(struct manager *mgr)
+{
+	u_int	id;
+
+	id = mgr->nextid++;
+	if (id == 0x7fff)
+		mgr->nextid = 1;
+	id <<= 16;
+	id |= GROUP_TEI << 8;
+	id |= TEI_SAPI;
+	return id;
+}
+
+static void
+do_send(struct manager *mgr)
+{
+	if (!test_bit(MGR_PH_ACTIVE, &mgr->options))
+		return;
+
+	if (!test_and_set_bit(MGR_PH_NOTREADY, &mgr->options)) {
+		struct sk_buff	*skb = skb_dequeue(&mgr->sendq);
+
+		if (!skb) {
+			test_and_clear_bit(MGR_PH_NOTREADY, &mgr->options);
+			return;
+		}
+		mgr->lastid = mISDN_HEAD_ID(skb);
+		mISDN_FsmEvent(&mgr->deact, EV_UI, NULL);
+		if (mgr->ch.recv(mgr->ch.peer, skb)) {
+			dev_kfree_skb(skb);
+			test_and_clear_bit(MGR_PH_NOTREADY, &mgr->options);
+			mgr->lastid = MISDN_ID_NONE;
+		}
+	}
+}
+
+static void
+do_ack(struct manager *mgr, u_int id)
+{
+	if (test_bit(MGR_PH_NOTREADY, &mgr->options)) {
+		if (id == mgr->lastid) {
+			if (test_bit(MGR_PH_ACTIVE, &mgr->options)) {
+				struct sk_buff	*skb;
+
+				skb = skb_dequeue(&mgr->sendq);
+				if (skb) {
+					mgr->lastid = mISDN_HEAD_ID(skb);
+					if (!mgr->ch.recv(mgr->ch.peer, skb))
+						return;
+					dev_kfree_skb(skb);
+				}
+			}
+			mgr->lastid = MISDN_ID_NONE;
+			test_and_clear_bit(MGR_PH_NOTREADY, &mgr->options);
+		}
+	}
+}
+
+static void
+mgr_send_down(struct manager *mgr, struct sk_buff *skb)
+{
+	skb_queue_tail(&mgr->sendq, skb);
+	if (!test_bit(MGR_PH_ACTIVE, &mgr->options)) {
+		_queue_data(&mgr->ch, PH_ACTIVATE_REQ, MISDN_ID_ANY, 0,
+		    NULL, GFP_KERNEL);
+	} else {
+		do_send(mgr);
+	}
+}
+
+static int
+dl_unit_data(struct manager *mgr, struct sk_buff *skb)
+{
+	if (!test_bit(MGR_OPT_NETWORK, &mgr->options)) /* only net send UI */
+		return -EINVAL;
+	if (!test_bit(MGR_PH_ACTIVE, &mgr->options))
+		_queue_data(&mgr->ch, PH_ACTIVATE_REQ, MISDN_ID_ANY, 0,
+		    NULL, GFP_KERNEL);
+	skb_push(skb, 3);
+	skb->data[0] = 0x02; /* SAPI 0 C/R = 1 */
+	skb->data[1] = 0xff; /* TEI 127 */
+	skb->data[2] = UI;   /* UI frame */
+	mISDN_HEAD_PRIM(skb) = PH_DATA_REQ;
+	mISDN_HEAD_ID(skb) = new_id(mgr);
+	skb_queue_tail(&mgr->sendq, skb);
+	do_send(mgr);
+	return 0;
+}
+
+unsigned int
+random_ri(void)
+{
+	u16 x;
+
+	get_random_bytes(&x, sizeof(x));
+	return x;
+}
+
+static struct layer2 *
+findtei(struct manager *mgr, int tei)
+{
+	struct layer2	*l2;
+	u_long		flags;
+
+	read_lock_irqsave(&mgr->lock, flags);
+	list_for_each_entry(l2, &mgr->layer2, list) {
+		if ((l2->sapi == 0) && (l2->tei > 0) &&
+		    (l2->tei != GROUP_TEI) && (l2->tei == tei))
+			goto done;
+	}
+	l2 = NULL;
+done:
+	read_unlock_irqrestore(&mgr->lock, flags);
+	return l2;
+}
+
+static void
+put_tei_msg(struct manager *mgr, u_char m_id, unsigned int ri, u_char tei)
+{
+	struct sk_buff *skb;
+	u_char bp[8];
+
+	bp[0] = (TEI_SAPI << 2);
+	if (test_bit(MGR_OPT_NETWORK, &mgr->options))
+		bp[0] |= 2; /* CR:=1 for net command */
+	bp[1] = (GROUP_TEI << 1) | 0x1;
+	bp[2] = UI;
+	bp[3] = TEI_ENTITY_ID;
+	bp[4] = ri >> 8;
+	bp[5] = ri & 0xff;
+	bp[6] = m_id;
+	bp[7] = (tei << 1) | 1;
+	skb = _alloc_mISDN_skb(PH_DATA_REQ, new_id(mgr),
+	    8, bp, GFP_ATOMIC);
+	if (!skb) {
+		printk(KERN_WARNING "%s: no skb for tei msg\n", __func__);
+		return;
+	}
+	mgr_send_down(mgr, skb);
+}
+
+static void
+tei_id_request(struct FsmInst *fi, int event, void *arg)
+{
+	struct teimgr *tm = fi->userdata;
+
+	if (tm->l2->tei != GROUP_TEI) {
+		tm->tei_m.printdebug(&tm->tei_m,
+			"assign request for allready assigned tei %d",
+			tm->l2->tei);
+		return;
+	}
+	tm->ri = random_ri();
+	if (*debug & DEBUG_L2_TEI)
+		tm->tei_m.printdebug(&tm->tei_m,
+			"assign request ri %d", tm->ri);
+	put_tei_msg(tm->mgr, ID_REQUEST, tm->ri, GROUP_TEI);
+	mISDN_FsmChangeState(fi, ST_TEI_IDREQ);
+	mISDN_FsmAddTimer(&tm->timer, tm->tval, EV_TIMER, NULL, 1);
+	tm->nval = 3;
+}
+
+static void
+tei_id_assign(struct FsmInst *fi, int event, void *arg)
+{
+	struct teimgr	*tm = fi->userdata;
+	struct layer2	*l2;
+	u_char *dp = arg;
+	int ri, tei;
+
+	ri = ((unsigned int) *dp++ << 8);
+	ri += *dp++;
+	dp++;
+	tei = *dp >> 1;
+	if (*debug & DEBUG_L2_TEI)
+		tm->tei_m.printdebug(fi, "identity assign ri %d tei %d",
+			ri, tei);
+	l2 = findtei(tm->mgr, tei);
+	if (l2) {	/* same tei is in use */
+		if (ri != l2->tm->ri) {
+			tm->tei_m.printdebug(fi,
+				"possible duplicate assignment tei %d", tei);
+			tei_l2(l2, MDL_ERROR_RSP, 0);
+		}
+	} else if (ri == tm->ri) {
+		mISDN_FsmDelTimer(&tm->timer, 1);
+		mISDN_FsmChangeState(fi, ST_TEI_NOP);
+		tei_l2(tm->l2, MDL_ASSIGN_REQ, tei);
+	}
+}
+
+static void
+tei_id_test_dup(struct FsmInst *fi, int event, void *arg)
+{
+	struct teimgr	*tm = fi->userdata;
+	struct layer2	*l2;
+	u_char *dp = arg;
+	int tei, ri;
+
+	ri = ((unsigned int) *dp++ << 8);
+	ri += *dp++;
+	dp++;
+	tei = *dp >> 1;
+	if (*debug & DEBUG_L2_TEI)
+		tm->tei_m.printdebug(fi, "foreign identity assign ri %d tei %d",
+			ri, tei);
+	l2 = findtei(tm->mgr, tei);
+	if (l2) {	/* same tei is in use */
+		if (ri != l2->tm->ri) {	/* and it wasn't our request */
+			tm->tei_m.printdebug(fi,
+				"possible duplicate assignment tei %d", tei);
+			mISDN_FsmEvent(&l2->tm->tei_m, EV_VERIFY, NULL);
+		}
+	}
+}
+
+static void
+tei_id_denied(struct FsmInst *fi, int event, void *arg)
+{
+	struct teimgr *tm = fi->userdata;
+	u_char *dp = arg;
+	int ri, tei;
+
+	ri = ((unsigned int) *dp++ << 8);
+	ri += *dp++;
+	dp++;
+	tei = *dp >> 1;
+	if (*debug & DEBUG_L2_TEI)
+		tm->tei_m.printdebug(fi, "identity denied ri %d tei %d",
+			ri, tei);
+}
+
+static void
+tei_id_chk_req(struct FsmInst *fi, int event, void *arg)
+{
+	struct teimgr *tm = fi->userdata;
+	u_char *dp = arg;
+	int tei;
+
+	tei = *(dp+3) >> 1;
+	if (*debug & DEBUG_L2_TEI)
+		tm->tei_m.printdebug(fi, "identity check req tei %d", tei);
+	if ((tm->l2->tei != GROUP_TEI) && ((tei == GROUP_TEI) ||
+	    (tei == tm->l2->tei))) {
+		mISDN_FsmDelTimer(&tm->timer, 4);
+		mISDN_FsmChangeState(&tm->tei_m, ST_TEI_NOP);
+		put_tei_msg(tm->mgr, ID_CHK_RES, random_ri(), tm->l2->tei);
+	}
+}
+
+static void
+tei_id_remove(struct FsmInst *fi, int event, void *arg)
+{
+	struct teimgr *tm = fi->userdata;
+	u_char *dp = arg;
+	int tei;
+
+	tei = *(dp+3) >> 1;
+	if (*debug & DEBUG_L2_TEI)
+		tm->tei_m.printdebug(fi, "identity remove tei %d", tei);
+	if ((tm->l2->tei != GROUP_TEI) &&
+	    ((tei == GROUP_TEI) || (tei == tm->l2->tei))) {
+		mISDN_FsmDelTimer(&tm->timer, 5);
+		mISDN_FsmChangeState(&tm->tei_m, ST_TEI_NOP);
+		tei_l2(tm->l2, MDL_REMOVE_REQ, 0);
+	}
+}
+
+static void
+tei_id_verify(struct FsmInst *fi, int event, void *arg)
+{
+	struct teimgr *tm = fi->userdata;
+
+	if (*debug & DEBUG_L2_TEI)
+		tm->tei_m.printdebug(fi, "id verify request for tei %d",
+			tm->l2->tei);
+	put_tei_msg(tm->mgr, ID_VERIFY, 0, tm->l2->tei);
+	mISDN_FsmChangeState(&tm->tei_m, ST_TEI_IDVERIFY);
+	mISDN_FsmAddTimer(&tm->timer, tm->tval, EV_TIMER, NULL, 2);
+	tm->nval = 2;
+}
+
+static void
+tei_id_req_tout(struct FsmInst *fi, int event, void *arg)
+{
+	struct teimgr *tm = fi->userdata;
+
+	if (--tm->nval) {
+		tm->ri = random_ri();
+		if (*debug & DEBUG_L2_TEI)
+			tm->tei_m.printdebug(fi, "assign req(%d) ri %d",
+				4 - tm->nval, tm->ri);
+		put_tei_msg(tm->mgr, ID_REQUEST, tm->ri, GROUP_TEI);
+		mISDN_FsmAddTimer(&tm->timer, tm->tval, EV_TIMER, NULL, 3);
+	} else {
+		tm->tei_m.printdebug(fi, "assign req failed");
+		tei_l2(tm->l2, MDL_ERROR_RSP, 0);
+		mISDN_FsmChangeState(fi, ST_TEI_NOP);
+	}
+}
+
+static void
+tei_id_ver_tout(struct FsmInst *fi, int event, void *arg)
+{
+	struct teimgr *tm = fi->userdata;
+
+	if (--tm->nval) {
+		if (*debug & DEBUG_L2_TEI)
+			tm->tei_m.printdebug(fi,
+				"id verify req(%d) for tei %d",
+				3 - tm->nval, tm->l2->tei);
+		put_tei_msg(tm->mgr, ID_VERIFY, 0, tm->l2->tei);
+		mISDN_FsmAddTimer(&tm->timer, tm->tval, EV_TIMER, NULL, 4);
+	} else {
+		tm->tei_m.printdebug(fi, "verify req for tei %d failed",
+			tm->l2->tei);
+		tei_l2(tm->l2, MDL_REMOVE_REQ, 0);
+		mISDN_FsmChangeState(fi, ST_TEI_NOP);
+	}
+}
+
+static struct FsmNode TeiFnListUser[] =
+{
+	{ST_TEI_NOP, EV_IDREQ, tei_id_request},
+	{ST_TEI_NOP, EV_ASSIGN, tei_id_test_dup},
+	{ST_TEI_NOP, EV_VERIFY, tei_id_verify},
+	{ST_TEI_NOP, EV_REMOVE, tei_id_remove},
+	{ST_TEI_NOP, EV_CHKREQ, tei_id_chk_req},
+	{ST_TEI_IDREQ, EV_TIMER, tei_id_req_tout},
+	{ST_TEI_IDREQ, EV_ASSIGN, tei_id_assign},
+	{ST_TEI_IDREQ, EV_DENIED, tei_id_denied},
+	{ST_TEI_IDVERIFY, EV_TIMER, tei_id_ver_tout},
+	{ST_TEI_IDVERIFY, EV_REMOVE, tei_id_remove},
+	{ST_TEI_IDVERIFY, EV_CHKREQ, tei_id_chk_req},
+};
+
+static void
+tei_l2remove(struct layer2 *l2)
+{
+	put_tei_msg(l2->tm->mgr, ID_REMOVE, 0, l2->tei);
+	tei_l2(l2, MDL_REMOVE_REQ, 0);
+	list_del(&l2->ch.list);
+	l2->ch.ctrl(&l2->ch, CLOSE_CHANNEL, NULL);
+}
+
+static void
+tei_assign_req(struct FsmInst *fi, int event, void *arg)
+{
+	struct teimgr *tm = fi->userdata;
+	u_char *dp = arg;
+
+	if (tm->l2->tei == GROUP_TEI) {
+		tm->tei_m.printdebug(&tm->tei_m,
+			"net tei assign request without tei");
+		return;
+	}
+	tm->ri = ((unsigned int) *dp++ << 8);
+	tm->ri += *dp++;
+	if (*debug & DEBUG_L2_TEI)
+		tm->tei_m.printdebug(&tm->tei_m,
+			"net assign request ri %d teim %d", tm->ri, *dp);
+	put_tei_msg(tm->mgr, ID_ASSIGNED, tm->ri, tm->l2->tei);
+	mISDN_FsmChangeState(fi, ST_TEI_NOP);
+}
+
+static void
+tei_id_chk_req_net(struct FsmInst *fi, int event, void *arg)
+{
+	struct teimgr	*tm = fi->userdata;
+
+	if (*debug & DEBUG_L2_TEI)
+		tm->tei_m.printdebug(fi, "id check request for tei %d",
+		    tm->l2->tei);
+	tm->rcnt = 0;
+	put_tei_msg(tm->mgr, ID_CHK_REQ, 0, tm->l2->tei);
+	mISDN_FsmChangeState(&tm->tei_m, ST_TEI_IDVERIFY);
+	mISDN_FsmAddTimer(&tm->timer, tm->tval, EV_TIMER, NULL, 2);
+	tm->nval = 2;
+}
+
+static void
+tei_id_chk_resp(struct FsmInst *fi, int event, void *arg)
+{
+	struct teimgr *tm = fi->userdata;
+	u_char *dp = arg;
+	int tei;
+
+	tei = dp[3] >> 1;
+	if (*debug & DEBUG_L2_TEI)
+		tm->tei_m.printdebug(fi, "identity check resp tei %d", tei);
+	if (tei == tm->l2->tei)
+		tm->rcnt++;
+}
+
+static void
+tei_id_verify_net(struct FsmInst *fi, int event, void *arg)
+{
+	struct teimgr *tm = fi->userdata;
+	u_char *dp = arg;
+	int tei;
+
+	tei = dp[3] >> 1;
+	if (*debug & DEBUG_L2_TEI)
+		tm->tei_m.printdebug(fi, "identity verify req tei %d/%d",
+		    tei, tm->l2->tei);
+	if (tei == tm->l2->tei)
+		tei_id_chk_req_net(fi, event, arg);
+}
+
+static void
+tei_id_ver_tout_net(struct FsmInst *fi, int event, void *arg)
+{
+	struct teimgr *tm = fi->userdata;
+
+	if (tm->rcnt == 1) {
+		if (*debug & DEBUG_L2_TEI)
+			tm->tei_m.printdebug(fi,
+			    "check req for tei %d sucessful\n", tm->l2->tei);
+		mISDN_FsmChangeState(fi, ST_TEI_NOP);
+	} else if (tm->rcnt > 1) {
+		/* duplicate assignment; remove */
+		tei_l2remove(tm->l2);
+	} else if (--tm->nval) {
+		if (*debug & DEBUG_L2_TEI)
+			tm->tei_m.printdebug(fi,
+				"id check req(%d) for tei %d",
+				3 - tm->nval, tm->l2->tei);
+		put_tei_msg(tm->mgr, ID_CHK_REQ, 0, tm->l2->tei);
+		mISDN_FsmAddTimer(&tm->timer, tm->tval, EV_TIMER, NULL, 4);
+	} else {
+		tm->tei_m.printdebug(fi, "check req for tei %d failed",
+			tm->l2->tei);
+		mISDN_FsmChangeState(fi, ST_TEI_NOP);
+		tei_l2remove(tm->l2);
+	}
+}
+
+static struct FsmNode TeiFnListNet[] =
+{
+	{ST_TEI_NOP, EV_ASSIGN_REQ, tei_assign_req},
+	{ST_TEI_NOP, EV_VERIFY, tei_id_verify_net},
+	{ST_TEI_NOP, EV_CHKREQ, tei_id_chk_req_net},
+	{ST_TEI_IDVERIFY, EV_TIMER, tei_id_ver_tout_net},
+	{ST_TEI_IDVERIFY, EV_CHKRESP, tei_id_chk_resp},
+};
+
+static void
+tei_ph_data_ind(struct teimgr *tm, u_int mt, u_char *dp, int len)
+{
+	if (test_bit(FLG_FIXED_TEI, &tm->l2->flag))
+		return;
+	if (*debug & DEBUG_L2_TEI)
+		tm->tei_m.printdebug(&tm->tei_m, "tei handler mt %x", mt);
+	if (mt == ID_ASSIGNED)
+		mISDN_FsmEvent(&tm->tei_m, EV_ASSIGN, dp);
+	else if (mt == ID_DENIED)
+		mISDN_FsmEvent(&tm->tei_m, EV_DENIED, dp);
+	else if (mt == ID_CHK_REQ)
+		mISDN_FsmEvent(&tm->tei_m, EV_CHKREQ, dp);
+	else if (mt == ID_REMOVE)
+		mISDN_FsmEvent(&tm->tei_m, EV_REMOVE, dp);
+	else if (mt == ID_VERIFY)
+		mISDN_FsmEvent(&tm->tei_m, EV_VERIFY, dp);
+	else if (mt == ID_CHK_RES)
+		mISDN_FsmEvent(&tm->tei_m, EV_CHKRESP, dp);
+}
+
+static struct layer2 *
+create_new_tei(struct manager *mgr, int tei)
+{
+	u_long		opt = 0;
+	u_long		flags;
+	int		id;
+	struct layer2	*l2;
+
+	if (!mgr->up)
+		return NULL;
+	if (tei < 64)
+		test_and_set_bit(OPTION_L2_FIXEDTEI, &opt);
+	if (mgr->ch.st->dev->Dprotocols
+	  & ((1 << ISDN_P_TE_E1) | (1 << ISDN_P_NT_E1)))
+		test_and_set_bit(OPTION_L2_PMX, &opt);
+	l2 = create_l2(mgr->up, ISDN_P_LAPD_NT, (u_int)opt, (u_long)tei);
+	if (!l2) {
+		printk(KERN_WARNING "%s:no memory for layer2\n", __func__);
+		return NULL;
+	}
+	l2->tm = kzalloc(sizeof(struct teimgr), GFP_KERNEL);
+	if (!l2->tm) {
+		kfree(l2);
+		printk(KERN_WARNING "%s:no memory for teimgr\n", __func__);
+		return NULL;
+	}
+	l2->tm->mgr = mgr;
+	l2->tm->l2 = l2;
+	l2->tm->tei_m.debug = *debug & DEBUG_L2_TEIFSM;
+	l2->tm->tei_m.userdata = l2->tm;
+	l2->tm->tei_m.printdebug = tei_debug;
+	l2->tm->tei_m.fsm = &teifsmn;
+	l2->tm->tei_m.state = ST_TEI_NOP;
+	l2->tm->tval = 2000; /* T202  2 sec */
+	mISDN_FsmInitTimer(&l2->tm->tei_m, &l2->tm->timer);
+	write_lock_irqsave(&mgr->lock, flags);
+	id = get_free_id(mgr);
+	list_add_tail(&l2->list, &mgr->layer2);
+	write_unlock_irqrestore(&mgr->lock, flags);
+	if (id < 0) {
+		l2->ch.ctrl(&l2->ch, CLOSE_CHANNEL, NULL);
+		printk(KERN_WARNING "%s:no free id\n", __func__);
+		return NULL;
+	} else {
+		l2->ch.nr = id;
+		__add_layer2(&l2->ch, mgr->ch.st);
+		l2->ch.recv = mgr->ch.recv;
+		l2->ch.peer = mgr->ch.peer;
+		l2->ch.ctrl(&l2->ch, OPEN_CHANNEL, NULL);
+	}
+	return l2;
+}
+
+static void
+new_tei_req(struct manager *mgr, u_char *dp)
+{
+	int		tei, ri;
+	struct layer2	*l2;
+
+	ri = dp[0] << 8;
+	ri += dp[1];
+	if (!mgr->up)
+		goto denied;
+	tei = get_free_tei(mgr);
+	if (tei < 0) {
+		printk(KERN_WARNING "%s:No free tei\n", __func__);
+		goto denied;
+	}
+	l2 = create_new_tei(mgr, tei);
+	if (!l2)
+		goto denied;
+	else
+		mISDN_FsmEvent(&l2->tm->tei_m, EV_ASSIGN_REQ, dp);
+	return;
+denied:
+	put_tei_msg(mgr, ID_DENIED, ri, GROUP_TEI);
+}
+
+static int
+ph_data_ind(struct manager *mgr, struct sk_buff *skb)
+{
+	int		ret = -EINVAL;
+	struct layer2	*l2;
+	u_long		flags;
+	u_char		mt;
+
+	if (skb->len < 8) {
+		if (*debug  & DEBUG_L2_TEI)
+			printk(KERN_DEBUG "%s: short mgr frame %d/8\n",
+			    __func__, skb->len);
+		goto done;
+	}
+	if (*debug  & DEBUG_L2_TEI)
+
+	if ((skb->data[0] >> 2) != TEI_SAPI) /* not for us */
+		goto done;
+	if (skb->data[0] & 1) /* EA0 formal error */
+		goto done;
+	if (!(skb->data[1] & 1)) /* EA1 formal error */
+		goto done;
+	if ((skb->data[1] >> 1) != GROUP_TEI) /* not for us */
+		goto done;
+	if ((skb->data[2] & 0xef) != UI) /* not UI */
+		goto done;
+	if (skb->data[3] != TEI_ENTITY_ID) /* not tei entity */
+		goto done;
+	mt = skb->data[6];
+	switch (mt) {
+	case ID_REQUEST:
+	case ID_CHK_RES:
+	case ID_VERIFY:
+		if (!test_bit(MGR_OPT_NETWORK, &mgr->options))
+			goto done;
+		break;
+	case ID_ASSIGNED:
+	case ID_DENIED:
+	case ID_CHK_REQ:
+	case ID_REMOVE:
+		if (test_bit(MGR_OPT_NETWORK, &mgr->options))
+			goto done;
+		break;
+	default:
+		goto done;
+	}
+	ret = 0;
+	if (mt == ID_REQUEST) {
+		new_tei_req(mgr, &skb->data[4]);
+		goto done;
+	}
+	read_lock_irqsave(&mgr->lock, flags);
+	list_for_each_entry(l2, &mgr->layer2, list) {
+		tei_ph_data_ind(l2->tm, mt, &skb->data[4], skb->len - 4);
+	}
+	read_unlock_irqrestore(&mgr->lock, flags);
+done:
+	return ret;
+}
+
+int
+l2_tei(struct layer2 *l2, u_int cmd, u_long arg)
+{
+	struct teimgr	*tm = l2->tm;
+
+	if (test_bit(FLG_FIXED_TEI, &l2->flag))
+		return 0;
+	if (*debug & DEBUG_L2_TEI)
+		printk(KERN_DEBUG "%s: cmd(%x)\n", __func__, cmd);
+	switch (cmd) {
+	case MDL_ASSIGN_IND:
+		mISDN_FsmEvent(&tm->tei_m, EV_IDREQ, NULL);
+		break;
+	case MDL_ERROR_IND:
+		if (test_bit(MGR_OPT_NETWORK, &tm->mgr->options))
+			mISDN_FsmEvent(&tm->tei_m, EV_CHKREQ, &l2->tei);
+		if (test_bit(MGR_OPT_USER, &tm->mgr->options))
+			mISDN_FsmEvent(&tm->tei_m, EV_VERIFY, NULL);
+		break;
+	case MDL_STATUS_UP_IND:
+		if (test_bit(MGR_OPT_NETWORK, &tm->mgr->options))
+			mISDN_FsmEvent(&tm->mgr->deact, EV_ACTIVATE, NULL);
+		break;
+	case MDL_STATUS_DOWN_IND:
+		if (test_bit(MGR_OPT_NETWORK, &tm->mgr->options))
+			mISDN_FsmEvent(&tm->mgr->deact, EV_DEACTIVATE, NULL);
+		break;
+	case MDL_STATUS_UI_IND:
+		if (test_bit(MGR_OPT_NETWORK, &tm->mgr->options))
+			mISDN_FsmEvent(&tm->mgr->deact, EV_UI, NULL);
+		break;
+	}
+	return 0;
+}
+
+void
+release_tei(struct layer2 *l2)
+{
+	struct teimgr	*tm = l2->tm;
+	u_long		flags;
+
+	mISDN_FsmDelTimer(&tm->timer, 1);
+	write_lock_irqsave(&tm->mgr->lock, flags);
+	list_del(&l2->list);
+	write_unlock_irqrestore(&tm->mgr->lock, flags);
+	l2->tm = NULL;
+	kfree(tm);
+}
+
+static int
+create_teimgr(struct manager *mgr, struct channel_req *crq)
+{
+	struct layer2	*l2;
+	u_long 		opt = 0;
+	u_long		flags;
+	int		id;
+
+	if (*debug & DEBUG_L2_TEI)
+		printk(KERN_DEBUG "%s: %s proto(%x) adr(%d %d %d %d)\n",
+			__func__, mgr->ch.st->dev->name, crq->protocol,
+			crq->adr.dev, crq->adr.channel, crq->adr.sapi,
+			crq->adr.tei);
+	if (crq->adr.sapi != 0) /* not supported yet */
+		return -EINVAL;
+	if (crq->adr.tei > GROUP_TEI)
+		return -EINVAL;
+	if (crq->adr.tei < 64)
+		test_and_set_bit(OPTION_L2_FIXEDTEI, &opt);
+	if (crq->adr.tei == 0)
+		test_and_set_bit(OPTION_L2_PTP, &opt);
+	if (test_bit(MGR_OPT_NETWORK, &mgr->options)) {
+		if (crq->protocol == ISDN_P_LAPD_TE)
+			return -EPROTONOSUPPORT;
+		if ((crq->adr.tei != 0) && (crq->adr.tei != 127))
+			return -EINVAL;
+		if (mgr->up) {
+			printk(KERN_WARNING
+			    "%s: only one network manager is allowed\n",
+			    __func__);
+			return -EBUSY;
+		}
+	} else if (test_bit(MGR_OPT_USER, &mgr->options)) {
+		if (crq->protocol == ISDN_P_LAPD_NT)
+			return -EPROTONOSUPPORT;
+		if ((crq->adr.tei >= 64) && (crq->adr.tei < GROUP_TEI))
+			return -EINVAL; /* dyn tei */
+	} else {
+		if (crq->protocol == ISDN_P_LAPD_NT)
+			test_and_set_bit(MGR_OPT_NETWORK, &mgr->options);
+		if (crq->protocol == ISDN_P_LAPD_TE)
+			test_and_set_bit(MGR_OPT_USER, &mgr->options);
+	}
+	if (mgr->ch.st->dev->Dprotocols
+	  & ((1 << ISDN_P_TE_E1) | (1 << ISDN_P_NT_E1)))
+		test_and_set_bit(OPTION_L2_PMX, &opt);
+	if ((crq->protocol == ISDN_P_LAPD_NT) && (crq->adr.tei == 127)) {
+		mgr->up = crq->ch;
+		id = DL_INFO_L2_CONNECT;
+		teiup_create(mgr, DL_INFORMATION_IND, sizeof(id), &id);
+		crq->ch = NULL;
+		if (!list_empty(&mgr->layer2)) {
+			read_lock_irqsave(&mgr->lock, flags);
+			list_for_each_entry(l2, &mgr->layer2, list) {
+				l2->up = mgr->up;
+				l2->ch.ctrl(&l2->ch, OPEN_CHANNEL, NULL);
+			}
+			read_unlock_irqrestore(&mgr->lock, flags);
+		}
+		return 0;
+	}
+	l2 = create_l2(crq->ch, crq->protocol, (u_int)opt,
+		(u_long)crq->adr.tei);
+	if (!l2)
+		return -ENOMEM;
+	l2->tm = kzalloc(sizeof(struct teimgr), GFP_KERNEL);
+	if (!l2->tm) {
+		kfree(l2);
+		printk(KERN_ERR "kmalloc teimgr failed\n");
+		return -ENOMEM;
+	}
+	l2->tm->mgr = mgr;
+	l2->tm->l2 = l2;
+	l2->tm->tei_m.debug = *debug & DEBUG_L2_TEIFSM;
+	l2->tm->tei_m.userdata = l2->tm;
+	l2->tm->tei_m.printdebug = tei_debug;
+	if (crq->protocol == ISDN_P_LAPD_TE) {
+		l2->tm->tei_m.fsm = &teifsmu;
+		l2->tm->tei_m.state = ST_TEI_NOP;
+		l2->tm->tval = 1000; /* T201  1 sec */
+	} else {
+		l2->tm->tei_m.fsm = &teifsmn;
+		l2->tm->tei_m.state = ST_TEI_NOP;
+		l2->tm->tval = 2000; /* T202  2 sec */
+	}
+	mISDN_FsmInitTimer(&l2->tm->tei_m, &l2->tm->timer);
+	write_lock_irqsave(&mgr->lock, flags);
+	id = get_free_id(mgr);
+	list_add_tail(&l2->list, &mgr->layer2);
+	write_unlock_irqrestore(&mgr->lock, flags);
+	if (id < 0) {
+		l2->ch.ctrl(&l2->ch, CLOSE_CHANNEL, NULL);
+	} else {
+		l2->ch.nr = id;
+		l2->up->nr = id;
+		crq->ch = &l2->ch;
+		id = 0;
+	}
+	return id;
+}
+
+static int
+mgr_send(struct mISDNchannel *ch, struct sk_buff *skb)
+{
+	struct manager	*mgr;
+	struct mISDNhead	*hh =  mISDN_HEAD_P(skb);
+	int			ret = -EINVAL;
+
+	mgr = container_of(ch, struct manager, ch);
+	if (*debug & DEBUG_L2_RECV)
+		printk(KERN_DEBUG "%s: prim(%x) id(%x)\n",
+		    __func__, hh->prim, hh->id);
+	switch (hh->prim) {
+	case PH_DATA_IND:
+		mISDN_FsmEvent(&mgr->deact, EV_UI, NULL);
+		ret = ph_data_ind(mgr, skb);
+		break;
+	case PH_DATA_CNF:
+		do_ack(mgr, hh->id);
+		ret = 0;
+		break;
+	case PH_ACTIVATE_IND:
+		test_and_set_bit(MGR_PH_ACTIVE, &mgr->options);
+		mISDN_FsmEvent(&mgr->deact, EV_ACTIVATE_IND, NULL);
+		do_send(mgr);
+		ret = 0;
+		break;
+	case PH_DEACTIVATE_IND:
+		test_and_clear_bit(MGR_PH_ACTIVE, &mgr->options);
+		mISDN_FsmEvent(&mgr->deact, EV_DEACTIVATE_IND, NULL);
+		ret = 0;
+		break;
+	case DL_UNITDATA_REQ:
+		return dl_unit_data(mgr, skb);
+	}
+	if (!ret)
+		dev_kfree_skb(skb);
+	return ret;
+}
+
+static int
+free_teimanager(struct manager *mgr)
+{
+	struct layer2	*l2, *nl2;
+
+	if (test_bit(MGR_OPT_NETWORK, &mgr->options)) {
+		/* not locked lock is taken in release tei */
+		mgr->up = NULL;
+		if (test_bit(OPTION_L2_CLEANUP, &mgr->options)) {
+			list_for_each_entry_safe(l2, nl2, &mgr->layer2, list) {
+				put_tei_msg(mgr, ID_REMOVE, 0, l2->tei);
+				mutex_lock(&mgr->ch.st->lmutex);
+				list_del(&l2->ch.list);
+				mutex_unlock(&mgr->ch.st->lmutex);
+				l2->ch.ctrl(&l2->ch, CLOSE_CHANNEL, NULL);
+			}
+			test_and_clear_bit(MGR_OPT_NETWORK, &mgr->options);
+		} else {
+			list_for_each_entry_safe(l2, nl2, &mgr->layer2, list) {
+				l2->up = NULL;
+			}
+		}
+	}
+	if (test_bit(MGR_OPT_USER, &mgr->options)) {
+		if (list_empty(&mgr->layer2))
+			test_and_clear_bit(MGR_OPT_USER, &mgr->options);
+	}
+	mgr->ch.st->dev->D.ctrl(&mgr->ch.st->dev->D, CLOSE_CHANNEL, NULL);
+	return 0;
+}
+
+static int
+ctrl_teimanager(struct manager *mgr, void *arg)
+{
+	/* currently we only have one option */
+	int	clean = *((int *)arg);
+
+	if (clean)
+		test_and_set_bit(OPTION_L2_CLEANUP, &mgr->options);
+	else
+		test_and_clear_bit(OPTION_L2_CLEANUP, &mgr->options);
+	return 0;
+}
+
+/* This function does create a L2 for fixed TEI in NT Mode */
+static int
+check_data(struct manager *mgr, struct sk_buff *skb)
+{
+	struct mISDNhead	*hh =  mISDN_HEAD_P(skb);
+	int			ret, tei;
+	struct layer2		*l2;
+
+	if (*debug & DEBUG_L2_CTRL)
+		printk(KERN_DEBUG "%s: prim(%x) id(%x)\n",
+		    __func__, hh->prim, hh->id);
+	if (test_bit(MGR_OPT_USER, &mgr->options))
+		return -ENOTCONN;
+	if (hh->prim != PH_DATA_IND)
+		return -ENOTCONN;
+	if (skb->len != 3)
+		return -ENOTCONN;
+	if (skb->data[0] != 0)
+		/* only SAPI 0 command */
+		return -ENOTCONN;
+	if (!(skb->data[1] & 1)) /* invalid EA1 */
+		return -EINVAL;
+	tei = skb->data[1] >> 0;
+	if (tei > 63) /* not a fixed tei */
+		return -ENOTCONN;
+	if ((skb->data[2] & ~0x10) != SABME)
+		return -ENOTCONN;
+	/* We got a SABME for a fixed TEI */
+	l2 = create_new_tei(mgr, tei);
+	if (!l2)
+		return -ENOMEM;
+	ret = l2->ch.send(&l2->ch, skb);
+	return ret;
+}
+
+void
+delete_teimanager(struct mISDNchannel *ch)
+{
+	struct manager	*mgr;
+	struct layer2	*l2, *nl2;
+
+	mgr = container_of(ch, struct manager, ch);
+	/* not locked lock is taken in release tei */
+	list_for_each_entry_safe(l2, nl2, &mgr->layer2, list) {
+		mutex_lock(&mgr->ch.st->lmutex);
+		list_del(&l2->ch.list);
+		mutex_unlock(&mgr->ch.st->lmutex);
+		l2->ch.ctrl(&l2->ch, CLOSE_CHANNEL, NULL);
+	}
+	list_del(&mgr->ch.list);
+	list_del(&mgr->bcast.list);
+	skb_queue_purge(&mgr->sendq);
+	kfree(mgr);
+}
+
+static int
+mgr_ctrl(struct mISDNchannel *ch, u_int cmd, void *arg)
+{
+	struct manager	*mgr;
+	int		ret = -EINVAL;
+
+	mgr = container_of(ch, struct manager, ch);
+	if (*debug & DEBUG_L2_CTRL)
+		printk(KERN_DEBUG "%s(%x, %p)\n", __func__, cmd, arg);
+	switch (cmd) {
+	case OPEN_CHANNEL:
+		ret = create_teimgr(mgr, arg);
+		break;
+	case CLOSE_CHANNEL:
+		ret = free_teimanager(mgr);
+		break;
+	case CONTROL_CHANNEL:
+		ret = ctrl_teimanager(mgr, arg);
+		break;
+	case CHECK_DATA:
+		ret = check_data(mgr, arg);
+		break;
+	}
+	return ret;
+}
+
+static int
+mgr_bcast(struct mISDNchannel *ch, struct sk_buff *skb)
+{
+	struct manager		*mgr = container_of(ch, struct manager, bcast);
+	struct mISDNhead	*hh = mISDN_HEAD_P(skb);
+	struct sk_buff		*cskb = NULL;
+	struct layer2		*l2;
+	u_long			flags;
+	int			ret;
+
+	read_lock_irqsave(&mgr->lock, flags);
+	list_for_each_entry(l2, &mgr->layer2, list) {
+		if ((hh->id & MISDN_ID_SAPI_MASK) ==
+		    (l2->ch.addr & MISDN_ID_SAPI_MASK)) {
+			if (list_is_last(&l2->list, &mgr->layer2)) {
+				cskb = skb;
+				skb = NULL;
+			} else {
+				if (!cskb)
+					cskb = skb_copy(skb, GFP_KERNEL);
+			}
+			if (cskb) {
+				ret = l2->ch.send(&l2->ch, cskb);
+				if (ret) {
+					if (*debug & DEBUG_SEND_ERR)
+						printk(KERN_DEBUG
+						    "%s ch%d prim(%x) addr(%x)"
+						    " err %d\n",
+						    __func__, l2->ch.nr,
+						    hh->prim, l2->ch.addr, ret);
+				} else
+					cskb = NULL;
+			} else {
+				printk(KERN_WARNING "%s ch%d addr %x no mem\n",
+				    __func__, ch->nr, ch->addr);
+				goto out;
+			}
+		}
+	}
+out:
+	read_unlock_irqrestore(&mgr->lock, flags);
+	if (cskb)
+		dev_kfree_skb(cskb);
+	if (skb)
+		dev_kfree_skb(skb);
+	return 0;
+}
+
+static int
+mgr_bcast_ctrl(struct mISDNchannel *ch, u_int cmd, void *arg)
+{
+
+	return -EINVAL;
+}
+
+int
+create_teimanager(struct mISDNdevice *dev)
+{
+	struct manager *mgr;
+
+	mgr = kzalloc(sizeof(struct manager), GFP_KERNEL);
+	if (!mgr)
+		return -ENOMEM;
+	INIT_LIST_HEAD(&mgr->layer2);
+	mgr->lock = __RW_LOCK_UNLOCKED(mgr->lock);
+	skb_queue_head_init(&mgr->sendq);
+	mgr->nextid = 1;
+	mgr->lastid = MISDN_ID_NONE;
+	mgr->ch.send = mgr_send;
+	mgr->ch.ctrl = mgr_ctrl;
+	mgr->ch.st = dev->D.st;
+	set_channel_address(&mgr->ch, TEI_SAPI, GROUP_TEI);
+	add_layer2(&mgr->ch, dev->D.st);
+	mgr->bcast.send = mgr_bcast;
+	mgr->bcast.ctrl = mgr_bcast_ctrl;
+	mgr->bcast.st = dev->D.st;
+	set_channel_address(&mgr->bcast, 0, GROUP_TEI);
+	add_layer2(&mgr->bcast, dev->D.st);
+	mgr->deact.debug = *debug & DEBUG_MANAGER;
+	mgr->deact.userdata = mgr;
+	mgr->deact.printdebug = da_debug;
+	mgr->deact.fsm = &deactfsm;
+	mgr->deact.state = ST_L1_DEACT;
+	mISDN_FsmInitTimer(&mgr->deact, &mgr->datimer);
+	dev->teimgr = &mgr->ch;
+	return 0;
+}
+
+int TEIInit(u_int *deb)
+{
+	debug = deb;
+	teifsmu.state_count = TEI_STATE_COUNT;
+	teifsmu.event_count = TEI_EVENT_COUNT;
+	teifsmu.strEvent = strTeiEvent;
+	teifsmu.strState = strTeiState;
+	mISDN_FsmNew(&teifsmu, TeiFnListUser, ARRAY_SIZE(TeiFnListUser));
+	teifsmn.state_count = TEI_STATE_COUNT;
+	teifsmn.event_count = TEI_EVENT_COUNT;
+	teifsmn.strEvent = strTeiEvent;
+	teifsmn.strState = strTeiState;
+	mISDN_FsmNew(&teifsmn, TeiFnListNet, ARRAY_SIZE(TeiFnListNet));
+	deactfsm.state_count =  DEACT_STATE_COUNT;
+	deactfsm.event_count = DEACT_EVENT_COUNT;
+	deactfsm.strEvent = strDeactEvent;
+	deactfsm.strState = strDeactState;
+	mISDN_FsmNew(&deactfsm, DeactFnList, ARRAY_SIZE(DeactFnList));
+	return 0;
+}
+
+void TEIFree(void)
+{
+	mISDN_FsmFree(&teifsmu);
+	mISDN_FsmFree(&teifsmn);
+	mISDN_FsmFree(&deactfsm);
+}
diff --git a/drivers/isdn/mISDN/timerdev.c b/drivers/isdn/mISDN/timerdev.c
new file mode 100644
index 0000000..b5fabc7
--- /dev/null
+++ b/drivers/isdn/mISDN/timerdev.c
@@ -0,0 +1,301 @@
+/*
+ *
+ * general timer device for using in ISDN stacks
+ *
+ * Author	Karsten Keil <kkeil@novell.com>
+ *
+ * Copyright 2008  by Karsten Keil <kkeil@novell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/poll.h>
+#include <linux/vmalloc.h>
+#include <linux/timer.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/mISDNif.h>
+
+static int	*debug;
+
+
+struct mISDNtimerdev {
+	int			next_id;
+	struct list_head	pending;
+	struct list_head	expired;
+	wait_queue_head_t	wait;
+	u_int			work;
+	spinlock_t		lock; /* protect lists */
+};
+
+struct mISDNtimer {
+	struct list_head	list;
+	struct  mISDNtimerdev	*dev;
+	struct timer_list	tl;
+	int			id;
+};
+
+static int
+mISDN_open(struct inode *ino, struct file *filep)
+{
+	struct mISDNtimerdev	*dev;
+
+	if (*debug & DEBUG_TIMER)
+		printk(KERN_DEBUG "%s(%p,%p)\n", __func__, ino, filep);
+	dev = kmalloc(sizeof(struct mISDNtimerdev) , GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+	dev->next_id = 1;
+	INIT_LIST_HEAD(&dev->pending);
+	INIT_LIST_HEAD(&dev->expired);
+	spin_lock_init(&dev->lock);
+	dev->work = 0;
+	init_waitqueue_head(&dev->wait);
+	filep->private_data = dev;
+	__module_get(THIS_MODULE);
+	return 0;
+}
+
+static int
+mISDN_close(struct inode *ino, struct file *filep)
+{
+	struct mISDNtimerdev	*dev = filep->private_data;
+	struct mISDNtimer	*timer, *next;
+
+	if (*debug & DEBUG_TIMER)
+		printk(KERN_DEBUG "%s(%p,%p)\n", __func__, ino, filep);
+	list_for_each_entry_safe(timer, next, &dev->pending, list) {
+		del_timer(&timer->tl);
+		kfree(timer);
+	}
+	list_for_each_entry_safe(timer, next, &dev->expired, list) {
+		kfree(timer);
+	}
+	kfree(dev);
+	module_put(THIS_MODULE);
+	return 0;
+}
+
+static ssize_t
+mISDN_read(struct file *filep, char *buf, size_t count, loff_t *off)
+{
+	struct mISDNtimerdev	*dev = filep->private_data;
+	struct mISDNtimer	*timer;
+	u_long	flags;
+	int	ret = 0;
+
+	if (*debug & DEBUG_TIMER)
+		printk(KERN_DEBUG "%s(%p, %p, %d, %p)\n", __func__,
+			filep, buf, (int)count, off);
+	if (*off != filep->f_pos)
+		return -ESPIPE;
+
+	if (list_empty(&dev->expired) && (dev->work == 0)) {
+		if (filep->f_flags & O_NONBLOCK)
+			return -EAGAIN;
+		wait_event_interruptible(dev->wait, (dev->work ||
+		    !list_empty(&dev->expired)));
+		if (signal_pending(current))
+			return -ERESTARTSYS;
+	}
+	if (count < sizeof(int))
+		return -ENOSPC;
+	if (dev->work)
+		dev->work = 0;
+	if (!list_empty(&dev->expired)) {
+		spin_lock_irqsave(&dev->lock, flags);
+		timer = (struct mISDNtimer *)dev->expired.next;
+		list_del(&timer->list);
+		spin_unlock_irqrestore(&dev->lock, flags);
+		if (put_user(timer->id, (int *)buf))
+			ret = -EFAULT;
+		else
+			ret = sizeof(int);
+		kfree(timer);
+	}
+	return ret;
+}
+
+static loff_t
+mISDN_llseek(struct file *filep, loff_t offset, int orig)
+{
+	return -ESPIPE;
+}
+
+static ssize_t
+mISDN_write(struct file *filep, const char *buf, size_t count, loff_t *off)
+{
+	return -EOPNOTSUPP;
+}
+
+static unsigned int
+mISDN_poll(struct file *filep, poll_table *wait)
+{
+	struct mISDNtimerdev	*dev = filep->private_data;
+	unsigned int		mask = POLLERR;
+
+	if (*debug & DEBUG_TIMER)
+		printk(KERN_DEBUG "%s(%p, %p)\n", __func__, filep, wait);
+	if (dev) {
+		poll_wait(filep, &dev->wait, wait);
+		mask = 0;
+		if (dev->work || !list_empty(&dev->expired))
+			mask |= (POLLIN | POLLRDNORM);
+		if (*debug & DEBUG_TIMER)
+			printk(KERN_DEBUG "%s work(%d) empty(%d)\n", __func__,
+				dev->work, list_empty(&dev->expired));
+	}
+	return mask;
+}
+
+static void
+dev_expire_timer(struct mISDNtimer *timer)
+{
+	u_long			flags;
+
+	spin_lock_irqsave(&timer->dev->lock, flags);
+	list_del(&timer->list);
+	list_add_tail(&timer->list, &timer->dev->expired);
+	spin_unlock_irqrestore(&timer->dev->lock, flags);
+	wake_up_interruptible(&timer->dev->wait);
+}
+
+static int
+misdn_add_timer(struct mISDNtimerdev *dev, int timeout)
+{
+	int 			id;
+	u_long			flags;
+	struct mISDNtimer	*timer;
+
+	if (!timeout) {
+		dev->work = 1;
+		wake_up_interruptible(&dev->wait);
+		id = 0;
+	} else {
+		timer = kzalloc(sizeof(struct mISDNtimer), GFP_KERNEL);
+		if (!timer)
+			return -ENOMEM;
+		spin_lock_irqsave(&dev->lock, flags);
+		timer->id = dev->next_id++;
+		if (dev->next_id < 0)
+			dev->next_id = 1;
+		list_add_tail(&timer->list, &dev->pending);
+		spin_unlock_irqrestore(&dev->lock, flags);
+		timer->dev = dev;
+		timer->tl.data = (long)timer;
+		timer->tl.function = (void *) dev_expire_timer;
+		init_timer(&timer->tl);
+		timer->tl.expires = jiffies + ((HZ * (u_long)timeout) / 1000);
+		add_timer(&timer->tl);
+		id = timer->id;
+	}
+	return id;
+}
+
+static int
+misdn_del_timer(struct mISDNtimerdev *dev, int id)
+{
+	u_long			flags;
+	struct mISDNtimer	*timer;
+	int			ret = 0;
+
+	spin_lock_irqsave(&dev->lock, flags);
+	list_for_each_entry(timer, &dev->pending, list) {
+		if (timer->id == id) {
+			list_del_init(&timer->list);
+			del_timer(&timer->tl);
+			ret = timer->id;
+			kfree(timer);
+			goto unlock;
+		}
+	}
+unlock:
+	spin_unlock_irqrestore(&dev->lock, flags);
+	return ret;
+}
+
+static int
+mISDN_ioctl(struct inode *inode, struct file *filep, unsigned int cmd,
+    unsigned long arg)
+{
+	struct mISDNtimerdev	*dev = filep->private_data;
+	int			id, tout, ret = 0;
+
+
+	if (*debug & DEBUG_TIMER)
+		printk(KERN_DEBUG "%s(%p, %x, %lx)\n", __func__,
+		    filep, cmd, arg);
+	switch (cmd) {
+	case IMADDTIMER:
+		if (get_user(tout, (int __user *)arg)) {
+			ret = -EFAULT;
+			break;
+		}
+		id = misdn_add_timer(dev, tout);
+		if (*debug & DEBUG_TIMER)
+			printk(KERN_DEBUG "%s add %d id %d\n", __func__,
+			    tout, id);
+		if (id < 0) {
+			ret = id;
+			break;
+		}
+		if (put_user(id, (int __user *)arg))
+			ret = -EFAULT;
+		break;
+	case IMDELTIMER:
+		if (get_user(id, (int __user *)arg)) {
+			ret = -EFAULT;
+			break;
+		}
+		if (*debug & DEBUG_TIMER)
+			printk(KERN_DEBUG "%s del id %d\n", __func__, id);
+		id = misdn_del_timer(dev, id);
+		if (put_user(id, (int __user *)arg))
+			ret = -EFAULT;
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+static struct file_operations mISDN_fops = {
+	.llseek		= mISDN_llseek,
+	.read		= mISDN_read,
+	.write		= mISDN_write,
+	.poll		= mISDN_poll,
+	.ioctl		= mISDN_ioctl,
+	.open		= mISDN_open,
+	.release	= mISDN_close,
+};
+
+static struct miscdevice mISDNtimer = {
+	.minor	= MISC_DYNAMIC_MINOR,
+	.name	= "mISDNtimer",
+	.fops	= &mISDN_fops,
+};
+
+int
+mISDN_inittimer(int *deb)
+{
+	int	err;
+
+	debug = deb;
+	err = misc_register(&mISDNtimer);
+	if (err)
+		printk(KERN_WARNING "mISDN: Could not register timer device\n");
+	return err;
+}
+
+void mISDN_timer_cleanup(void)
+{
+	misc_deregister(&mISDNtimer);
+}
diff --git a/include/linux/mISDNhw.h b/include/linux/mISDNhw.h
new file mode 100644
index 0000000..e794dfb
--- /dev/null
+++ b/include/linux/mISDNhw.h
@@ -0,0 +1,193 @@
+/*
+ *
+ * Author	Karsten Keil <kkeil@novell.com>
+ *
+ *   Basic declarations for the mISDN HW channels
+ *
+ * Copyright 2008  by Karsten Keil <kkeil@novell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef MISDNHW_H
+#define MISDNHW_H
+#include <linux/mISDNif.h>
+#include <linux/timer.h>
+
+/*
+ * HW DEBUG 0xHHHHGGGG
+ * H - hardware driver specific bits
+ * G - for all drivers
+ */
+
+#define DEBUG_HW		0x00000001
+#define DEBUG_HW_OPEN		0x00000002
+#define DEBUG_HW_DCHANNEL	0x00000100
+#define DEBUG_HW_DFIFO		0x00000200
+#define DEBUG_HW_BCHANNEL	0x00001000
+#define DEBUG_HW_BFIFO		0x00002000
+
+#define MAX_DFRAME_LEN_L1	300
+#define MAX_MON_FRAME		32
+#define MAX_LOG_SPACE		2048
+#define MISDN_COPY_SIZE		32
+
+/* channel->Flags bit field */
+#define FLG_TX_BUSY		0	/* tx_buf in use */
+#define FLG_TX_NEXT		1	/* next_skb in use */
+#define FLG_L1_BUSY		2	/* L1 is permanent busy */
+#define FLG_L2_ACTIVATED	3	/* activated from L2 */
+#define FLG_OPEN		5	/* channel is in use */
+#define FLG_ACTIVE		6	/* channel is activated */
+#define FLG_BUSY_TIMER		7
+/* channel type */
+#define FLG_DCHANNEL		8	/* channel is D-channel */
+#define FLG_BCHANNEL		9	/* channel is B-channel */
+#define FLG_ECHANNEL		10	/* channel is E-channel */
+#define FLG_TRANSPARENT		12	/* channel use transparent data */
+#define FLG_HDLC		13	/* channel use hdlc data */
+#define FLG_L2DATA		14	/* channel use L2 DATA primitivs */
+#define FLG_ORIGIN		15	/* channel is on origin site */
+/* channel specific stuff */
+/* arcofi specific */
+#define FLG_ARCOFI_TIMER	16
+#define FLG_ARCOFI_ERROR	17
+/* isar specific */
+#define FLG_INITIALIZED		16
+#define FLG_DLEETX		17
+#define FLG_LASTDLE		18
+#define FLG_FIRST		19
+#define FLG_LASTDATA		20
+#define FLG_NMD_DATA		21
+#define FLG_FTI_RUN		22
+#define FLG_LL_OK		23
+#define FLG_LL_CONN		24
+#define FLG_DTMFSEND		25
+
+/* workq events */
+#define FLG_RECVQUEUE		30
+#define	FLG_PHCHANGE		31
+
+#define schedule_event(s, ev)	do { \
+					test_and_set_bit(ev, &((s)->Flags)); \
+					schedule_work(&((s)->workq)); \
+				} while (0)
+
+struct dchannel {
+	struct mISDNdevice	dev;
+	u_long			Flags;
+	struct work_struct	workq;
+	void			(*phfunc) (struct dchannel *);
+	u_int			state;
+	void			*l1;
+	/* HW access */
+	u_char			(*read_reg) (void *, u_char);
+	void			(*write_reg) (void *, u_char, u_char);
+	void			(*read_fifo) (void *, u_char *, int);
+	void			(*write_fifo) (void *, u_char *, int);
+	void			*hw;
+	int			slot;	/* multiport card channel slot */
+	struct timer_list	timer;
+	/* receive data */
+	struct sk_buff		*rx_skb;
+	int			maxlen;
+	/* send data */
+	struct sk_buff_head	squeue;
+	struct sk_buff_head	rqueue;
+	struct sk_buff		*tx_skb;
+	int			tx_idx;
+	int			debug;
+	/* statistics */
+	int			err_crc;
+	int			err_tx;
+	int			err_rx;
+};
+
+typedef int	(dchannel_l1callback)(struct dchannel *, u_int);
+extern int	create_l1(struct dchannel *, dchannel_l1callback *);
+
+/* private L1 commands */
+#define INFO0		0x8002
+#define INFO1		0x8102
+#define INFO2		0x8202
+#define INFO3_P8	0x8302
+#define INFO3_P10	0x8402
+#define INFO4_P8	0x8502
+#define INFO4_P10	0x8602
+#define LOSTFRAMING	0x8702
+#define ANYSIGNAL	0x8802
+#define HW_POWERDOWN	0x8902
+#define HW_RESET_REQ	0x8a02
+#define HW_POWERUP_REQ	0x8b02
+#define HW_DEACT_REQ	0x8c02
+#define HW_ACTIVATE_REQ	0x8e02
+#define HW_D_NOBLOCKED  0x8f02
+#define HW_RESET_IND	0x9002
+#define HW_POWERUP_IND	0x9102
+#define HW_DEACT_IND	0x9202
+#define HW_ACTIVATE_IND	0x9302
+#define HW_DEACT_CNF	0x9402
+#define HW_TESTLOOP	0x9502
+#define HW_TESTRX_RAW	0x9602
+#define HW_TESTRX_HDLC	0x9702
+#define HW_TESTRX_OFF	0x9802
+
+struct layer1;
+extern int	l1_event(struct layer1 *, u_int);
+
+
+struct bchannel {
+	struct mISDNchannel	ch;
+	int			nr;
+	u_long			Flags;
+	struct work_struct	workq;
+	u_int			state;
+	/* HW access */
+	u_char			(*read_reg) (void *, u_char);
+	void			(*write_reg) (void *, u_char, u_char);
+	void			(*read_fifo) (void *, u_char *, int);
+	void			(*write_fifo) (void *, u_char *, int);
+	void			*hw;
+	int			slot;	/* multiport card channel slot */
+	struct timer_list	timer;
+	/* receive data */
+	struct sk_buff		*rx_skb;
+	int			maxlen;
+	/* send data */
+	struct sk_buff		*next_skb;
+	struct sk_buff		*tx_skb;
+	struct sk_buff_head	rqueue;
+	int			rcount;
+	int			tx_idx;
+	int			debug;
+	/* statistics */
+	int			err_crc;
+	int			err_tx;
+	int			err_rx;
+};
+
+extern int	mISDN_initdchannel(struct dchannel *, int, void *);
+extern int	mISDN_initbchannel(struct bchannel *, int);
+extern int	mISDN_freedchannel(struct dchannel *);
+extern int	mISDN_freebchannel(struct bchannel *);
+extern void	queue_ch_frame(struct mISDNchannel *, u_int,
+			int, struct sk_buff *);
+extern int	dchannel_senddata(struct dchannel *, struct sk_buff *);
+extern int	bchannel_senddata(struct bchannel *, struct sk_buff *);
+extern void	recv_Dchannel(struct dchannel *);
+extern void	recv_Bchannel(struct bchannel *);
+extern void	recv_Dchannel_skb(struct dchannel *, struct sk_buff *);
+extern void	recv_Bchannel_skb(struct bchannel *, struct sk_buff *);
+extern void	confirm_Bsend(struct bchannel *bch);
+extern int	get_next_bframe(struct bchannel *);
+extern int	get_next_dframe(struct dchannel *);
+
+#endif
diff --git a/include/linux/mISDNif.h b/include/linux/mISDNif.h
new file mode 100644
index 0000000..5c948f3
--- /dev/null
+++ b/include/linux/mISDNif.h
@@ -0,0 +1,487 @@
+/*
+ *
+ * Author	Karsten Keil <kkeil@novell.com>
+ *
+ * Copyright 2008  by Karsten Keil <kkeil@novell.com>
+ *
+ * This code is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU LESSER GENERAL PUBLIC LICENSE
+ * version 2.1 as published by the Free Software Foundation.
+ *
+ * This code is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU LESSER GENERAL PUBLIC LICENSE for more details.
+ *
+ */
+
+#ifndef mISDNIF_H
+#define mISDNIF_H
+
+#include <stdarg.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/socket.h>
+
+/*
+ * ABI Version 32 bit
+ *
+ * <8 bit> Major version
+ *		- changed if any interface become backwards incompatible
+ *
+ * <8 bit> Minor version
+ *              - changed if any interface is extended but backwards compatible
+ *
+ * <16 bit> Release number
+ *              - should be incremented on every checkin
+ */
+#define	MISDN_MAJOR_VERSION	1
+#define	MISDN_MINOR_VERSION	0
+#define MISDN_RELEASE		18
+
+/* primitives for information exchange
+ * generell format
+ * <16  bit  0 >
+ * <8  bit command>
+ *    BIT 8 = 1 LAYER private
+ *    BIT 7 = 1 answer
+ *    BIT 6 = 1 DATA
+ * <8  bit target layer mask>
+ *
+ * Layer = 00 is reserved for general commands
+   Layer = 01  L2 -> HW
+   Layer = 02  HW -> L2
+   Layer = 04  L3 -> L2
+   Layer = 08  L2 -> L3
+ * Layer = FF is reserved for broadcast commands
+ */
+
+#define MISDN_CMDMASK		0xff00
+#define MISDN_LAYERMASK		0x00ff
+
+/* generell commands */
+#define OPEN_CHANNEL		0x0100
+#define CLOSE_CHANNEL		0x0200
+#define CONTROL_CHANNEL		0x0300
+#define CHECK_DATA		0x0400
+
+/* layer 2 -> layer 1 */
+#define PH_ACTIVATE_REQ		0x0101
+#define PH_DEACTIVATE_REQ	0x0201
+#define PH_DATA_REQ		0x2001
+#define MPH_ACTIVATE_REQ	0x0501
+#define MPH_DEACTIVATE_REQ	0x0601
+#define MPH_INFORMATION_REQ	0x0701
+#define PH_CONTROL_REQ		0x0801
+
+/* layer 1 -> layer 2 */
+#define PH_ACTIVATE_IND		0x0102
+#define PH_ACTIVATE_CNF		0x4102
+#define PH_DEACTIVATE_IND	0x0202
+#define PH_DEACTIVATE_CNF	0x4202
+#define PH_DATA_IND		0x2002
+#define MPH_ACTIVATE_IND	0x0502
+#define MPH_DEACTIVATE_IND	0x0602
+#define MPH_INFORMATION_IND	0x0702
+#define PH_DATA_CNF		0x6002
+#define PH_CONTROL_IND		0x0802
+#define PH_CONTROL_CNF		0x4802
+
+/* layer 3 -> layer 2 */
+#define DL_ESTABLISH_REQ	0x1004
+#define DL_RELEASE_REQ		0x1104
+#define DL_DATA_REQ		0x3004
+#define DL_UNITDATA_REQ		0x3104
+#define DL_INFORMATION_REQ	0x0004
+
+/* layer 2 -> layer 3 */
+#define DL_ESTABLISH_IND	0x1008
+#define DL_ESTABLISH_CNF	0x5008
+#define DL_RELEASE_IND		0x1108
+#define DL_RELEASE_CNF		0x5108
+#define DL_DATA_IND		0x3008
+#define DL_UNITDATA_IND		0x3108
+#define DL_INFORMATION_IND	0x0008
+
+/* intern layer 2 managment */
+#define MDL_ASSIGN_REQ		0x1804
+#define MDL_ASSIGN_IND		0x1904
+#define MDL_REMOVE_REQ		0x1A04
+#define MDL_REMOVE_IND		0x1B04
+#define MDL_STATUS_UP_IND	0x1C04
+#define MDL_STATUS_DOWN_IND	0x1D04
+#define MDL_STATUS_UI_IND	0x1E04
+#define MDL_ERROR_IND		0x1F04
+#define MDL_ERROR_RSP		0x5F04
+
+/* DL_INFORMATION_IND types */
+#define DL_INFO_L2_CONNECT	0x0001
+#define DL_INFO_L2_REMOVED	0x0002
+
+/* PH_CONTROL types */
+/* TOUCH TONE IS 0x20XX  XX "0"..."9", "A","B","C","D","*","#" */
+#define DTMF_TONE_VAL		0x2000
+#define DTMF_TONE_MASK		0x007F
+#define DTMF_TONE_START		0x2100
+#define DTMF_TONE_STOP		0x2200
+#define DTMF_HFC_COEF		0x4000
+#define DSP_CONF_JOIN		0x2403
+#define DSP_CONF_SPLIT		0x2404
+#define DSP_RECEIVE_OFF		0x2405
+#define DSP_RECEIVE_ON		0x2406
+#define DSP_ECHO_ON		0x2407
+#define DSP_ECHO_OFF		0x2408
+#define DSP_MIX_ON		0x2409
+#define DSP_MIX_OFF		0x240a
+#define DSP_DELAY		0x240b
+#define DSP_JITTER		0x240c
+#define DSP_TXDATA_ON		0x240d
+#define DSP_TXDATA_OFF		0x240e
+#define DSP_TX_DEJITTER		0x240f
+#define DSP_TX_DEJ_OFF		0x2410
+#define DSP_TONE_PATT_ON	0x2411
+#define DSP_TONE_PATT_OFF	0x2412
+#define DSP_VOL_CHANGE_TX	0x2413
+#define DSP_VOL_CHANGE_RX	0x2414
+#define DSP_BF_ENABLE_KEY	0x2415
+#define DSP_BF_DISABLE		0x2416
+#define DSP_BF_ACCEPT		0x2416
+#define DSP_BF_REJECT		0x2417
+#define DSP_PIPELINE_CFG	0x2418
+#define HFC_VOL_CHANGE_TX	0x2601
+#define HFC_VOL_CHANGE_RX	0x2602
+#define HFC_SPL_LOOP_ON		0x2603
+#define HFC_SPL_LOOP_OFF	0x2604
+
+/* DSP_TONE_PATT_ON parameter */
+#define TONE_OFF			0x0000
+#define TONE_GERMAN_DIALTONE		0x0001
+#define TONE_GERMAN_OLDDIALTONE		0x0002
+#define TONE_AMERICAN_DIALTONE		0x0003
+#define TONE_GERMAN_DIALPBX		0x0004
+#define TONE_GERMAN_OLDDIALPBX		0x0005
+#define TONE_AMERICAN_DIALPBX		0x0006
+#define TONE_GERMAN_RINGING		0x0007
+#define TONE_GERMAN_OLDRINGING		0x0008
+#define TONE_AMERICAN_RINGPBX		0x000b
+#define TONE_GERMAN_RINGPBX		0x000c
+#define TONE_GERMAN_OLDRINGPBX		0x000d
+#define TONE_AMERICAN_RINGING		0x000e
+#define TONE_GERMAN_BUSY		0x000f
+#define TONE_GERMAN_OLDBUSY		0x0010
+#define TONE_AMERICAN_BUSY		0x0011
+#define TONE_GERMAN_HANGUP		0x0012
+#define TONE_GERMAN_OLDHANGUP		0x0013
+#define TONE_AMERICAN_HANGUP		0x0014
+#define TONE_SPECIAL_INFO		0x0015
+#define TONE_GERMAN_GASSENBESETZT	0x0016
+#define TONE_GERMAN_AUFSCHALTTON	0x0016
+
+/* MPH_INFORMATION_IND */
+#define L1_SIGNAL_LOS_OFF	0x0010
+#define L1_SIGNAL_LOS_ON	0x0011
+#define L1_SIGNAL_AIS_OFF	0x0012
+#define L1_SIGNAL_AIS_ON	0x0013
+#define L1_SIGNAL_RDI_OFF	0x0014
+#define L1_SIGNAL_RDI_ON	0x0015
+#define L1_SIGNAL_SLIP_RX	0x0020
+#define L1_SIGNAL_SLIP_TX	0x0021
+
+/*
+ * protocol ids
+ * D channel 1-31
+ * B channel 33 - 63
+ */
+
+#define ISDN_P_NONE		0
+#define ISDN_P_BASE		0
+#define ISDN_P_TE_S0		0x01
+#define ISDN_P_NT_S0  		0x02
+#define ISDN_P_TE_E1		0x03
+#define ISDN_P_NT_E1  		0x04
+#define ISDN_P_LAPD_TE		0x10
+#define	ISDN_P_LAPD_NT		0x11
+
+#define ISDN_P_B_MASK		0x1f
+#define ISDN_P_B_START		0x20
+
+#define ISDN_P_B_RAW		0x21
+#define ISDN_P_B_HDLC		0x22
+#define ISDN_P_B_X75SLP		0x23
+#define ISDN_P_B_L2DTMF		0x24
+#define ISDN_P_B_L2DSP		0x25
+#define ISDN_P_B_L2DSPHDLC	0x26
+
+#define OPTION_L2_PMX		1
+#define OPTION_L2_PTP		2
+#define OPTION_L2_FIXEDTEI	3
+#define OPTION_L2_CLEANUP	4
+
+/* should be in sync with linux/kobject.h:KOBJ_NAME_LEN */
+#define MISDN_MAX_IDLEN		20
+
+struct mISDNhead {
+	unsigned int	prim;
+	unsigned int	id;
+}  __attribute__((packed));
+
+#define MISDN_HEADER_LEN	sizeof(struct mISDNhead)
+#define MAX_DATA_SIZE		2048
+#define MAX_DATA_MEM		(MAX_DATA_SIZE + MISDN_HEADER_LEN)
+#define MAX_DFRAME_LEN		260
+
+#define MISDN_ID_ADDR_MASK	0xFFFF
+#define MISDN_ID_TEI_MASK	0xFF00
+#define MISDN_ID_SAPI_MASK	0x00FF
+#define MISDN_ID_TEI_ANY	0x7F00
+
+#define MISDN_ID_ANY		0xFFFF
+#define MISDN_ID_NONE		0xFFFE
+
+#define GROUP_TEI		127
+#define TEI_SAPI		63
+#define CTRL_SAPI		0
+
+#define MISDN_CHMAP_SIZE	4
+
+#define SOL_MISDN	0
+
+struct sockaddr_mISDN {
+	sa_family_t    family;
+	unsigned char	dev;
+	unsigned char	channel;
+	unsigned char	sapi;
+	unsigned char	tei;
+};
+
+/* timer device ioctl */
+#define IMADDTIMER	_IOR('I', 64, int)
+#define IMDELTIMER	_IOR('I', 65, int)
+/* socket ioctls */
+#define	IMGETVERSION	_IOR('I', 66, int)
+#define	IMGETCOUNT	_IOR('I', 67, int)
+#define IMGETDEVINFO	_IOR('I', 68, int)
+#define IMCTRLREQ	_IOR('I', 69, int)
+#define IMCLEAR_L2	_IOR('I', 70, int)
+
+struct mISDNversion {
+	unsigned char	major;
+	unsigned char	minor;
+	unsigned short	release;
+};
+
+struct mISDN_devinfo {
+	u_int			id;
+	u_int			Dprotocols;
+	u_int			Bprotocols;
+	u_int			protocol;
+	u_long			channelmap[MISDN_CHMAP_SIZE];
+	u_int			nrbchan;
+	char			name[MISDN_MAX_IDLEN];
+};
+
+/* CONTROL_CHANNEL parameters */
+#define MISDN_CTRL_GETOP		0x0000
+#define MISDN_CTRL_LOOP			0x0001
+#define MISDN_CTRL_CONNECT		0x0002
+#define MISDN_CTRL_DISCONNECT		0x0004
+#define MISDN_CTRL_PCMCONNECT		0x0010
+#define MISDN_CTRL_PCMDISCONNECT	0x0020
+#define MISDN_CTRL_SETPEER		0x0040
+#define MISDN_CTRL_UNSETPEER		0x0080
+#define MISDN_CTRL_RX_OFF		0x0100
+#define MISDN_CTRL_HW_FEATURES_OP	0x2000
+#define MISDN_CTRL_HW_FEATURES		0x2001
+#define MISDN_CTRL_HFC_OP		0x4000
+#define MISDN_CTRL_HFC_PCM_CONN		0x4001
+#define MISDN_CTRL_HFC_PCM_DISC		0x4002
+#define MISDN_CTRL_HFC_CONF_JOIN	0x4003
+#define MISDN_CTRL_HFC_CONF_SPLIT	0x4004
+#define MISDN_CTRL_HFC_RECEIVE_OFF	0x4005
+#define MISDN_CTRL_HFC_RECEIVE_ON	0x4006
+#define MISDN_CTRL_HFC_ECHOCAN_ON 	0x4007
+#define MISDN_CTRL_HFC_ECHOCAN_OFF 	0x4008
+
+
+/* socket options */
+#define MISDN_TIME_STAMP		0x0001
+
+struct mISDN_ctrl_req {
+	int		op;
+	int		channel;
+	int		p1;
+	int		p2;
+};
+
+/* muxer options */
+#define MISDN_OPT_ALL		1
+#define MISDN_OPT_TEIMGR	2
+
+#ifdef __KERNEL__
+#include <linux/list.h>
+#include <linux/skbuff.h>
+#include <linux/net.h>
+#include <net/sock.h>
+#include <linux/completion.h>
+
+#define DEBUG_CORE		0x000000ff
+#define DEBUG_CORE_FUNC		0x00000002
+#define DEBUG_SOCKET		0x00000004
+#define DEBUG_MANAGER		0x00000008
+#define DEBUG_SEND_ERR		0x00000010
+#define DEBUG_MSG_THREAD	0x00000020
+#define DEBUG_QUEUE_FUNC	0x00000040
+#define DEBUG_L1		0x0000ff00
+#define DEBUG_L1_FSM		0x00000200
+#define DEBUG_L2		0x00ff0000
+#define DEBUG_L2_FSM		0x00020000
+#define DEBUG_L2_CTRL		0x00040000
+#define DEBUG_L2_RECV		0x00080000
+#define DEBUG_L2_TEI		0x00100000
+#define DEBUG_L2_TEIFSM		0x00200000
+#define DEBUG_TIMER		0x01000000
+
+#define mISDN_HEAD_P(s)		((struct mISDNhead *)&s->cb[0])
+#define mISDN_HEAD_PRIM(s)	(((struct mISDNhead *)&s->cb[0])->prim)
+#define mISDN_HEAD_ID(s)	(((struct mISDNhead *)&s->cb[0])->id)
+
+/* socket states */
+#define MISDN_OPEN	1
+#define MISDN_BOUND	2
+#define MISDN_CLOSED	3
+
+struct mISDNchannel;
+struct mISDNdevice;
+struct mISDNstack;
+
+struct channel_req {
+	u_int			protocol;
+	struct sockaddr_mISDN	adr;
+	struct mISDNchannel	*ch;
+};
+
+typedef	int	(ctrl_func_t)(struct mISDNchannel *, u_int, void *);
+typedef	int	(send_func_t)(struct mISDNchannel *, struct sk_buff *);
+typedef int	(create_func_t)(struct channel_req *);
+
+struct Bprotocol {
+	struct list_head	list;
+	char			*name;
+	u_int			Bprotocols;
+	create_func_t		*create;
+};
+
+struct mISDNchannel {
+	struct list_head	list;
+	u_int			protocol;
+	u_int			nr;
+	u_long			opt;
+	u_int			addr;
+	struct mISDNstack	*st;
+	struct mISDNchannel	*peer;
+	send_func_t		*send;
+	send_func_t		*recv;
+	ctrl_func_t		*ctrl;
+};
+
+struct mISDN_sock_list {
+	struct hlist_head	head;
+	rwlock_t		lock;
+};
+
+struct mISDN_sock {
+	struct sock		sk;
+	struct mISDNchannel	ch;
+	u_int			cmask;
+	struct mISDNdevice	*dev;
+};
+
+
+
+struct mISDNdevice {
+	struct mISDNchannel	D;
+	u_int			id;
+	char			name[MISDN_MAX_IDLEN];
+	u_int			Dprotocols;
+	u_int			Bprotocols;
+	u_int			nrbchan;
+	u_long			channelmap[MISDN_CHMAP_SIZE];
+	struct list_head	bchannels;
+	struct mISDNchannel	*teimgr;
+	struct device		dev;
+};
+
+struct mISDNstack {
+	u_long			status;
+	struct mISDNdevice	*dev;
+	struct task_struct	*thread;
+	struct completion	*notify;
+	wait_queue_head_t	workq;
+	struct sk_buff_head	msgq;
+	struct list_head	layer2;
+	struct mISDNchannel	*layer1;
+	struct mISDNchannel	own;
+	struct mutex		lmutex; /* protect lists */
+	struct mISDN_sock_list	l1sock;
+#ifdef MISDN_MSG_STATS
+	u_int			msg_cnt;
+	u_int			sleep_cnt;
+	u_int			stopped_cnt;
+#endif
+};
+
+/* global alloc/queue dunctions */
+
+static inline struct sk_buff *
+mI_alloc_skb(unsigned int len, gfp_t gfp_mask)
+{
+	struct sk_buff	*skb;
+
+	skb = alloc_skb(len + MISDN_HEADER_LEN, gfp_mask);
+	if (likely(skb))
+		skb_reserve(skb, MISDN_HEADER_LEN);
+	return skb;
+}
+
+static inline struct sk_buff *
+_alloc_mISDN_skb(u_int prim, u_int id, u_int len, void *dp, gfp_t gfp_mask)
+{
+	struct sk_buff	*skb = mI_alloc_skb(len, gfp_mask);
+	struct mISDNhead *hh;
+
+	if (!skb)
+		return NULL;
+	if (len)
+		memcpy(skb_put(skb, len), dp, len);
+	hh = mISDN_HEAD_P(skb);
+	hh->prim = prim;
+	hh->id = id;
+	return skb;
+}
+
+static inline void
+_queue_data(struct mISDNchannel *ch, u_int prim,
+    u_int id, u_int len, void *dp, gfp_t gfp_mask)
+{
+	struct sk_buff		*skb;
+
+	if (!ch->peer)
+		return;
+	skb = _alloc_mISDN_skb(prim, id, len, dp, gfp_mask);
+	if (!skb)
+		return;
+	if (ch->recv(ch->peer, skb))
+		dev_kfree_skb(skb);
+}
+
+/* global register/unregister functions */
+
+extern int	mISDN_register_device(struct mISDNdevice *, char *name);
+extern void	mISDN_unregister_device(struct mISDNdevice *);
+extern int	mISDN_register_Bprotocol(struct Bprotocol *);
+extern void	mISDN_unregister_Bprotocol(struct Bprotocol *);
+
+extern void	set_channel_address(struct mISDNchannel *, u_int, u_int);
+
+#endif /* __KERNEL__ */
+#endif /* mISDNIF_H */
-- 
1.5.6.4


-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
