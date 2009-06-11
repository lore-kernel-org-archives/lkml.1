Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbZFKNVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbZFKNVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 09:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbZFKNVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 09:21:23 -0400
Received: from ozlabs.org ([203.10.76.45]:60691 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbZFKNVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 09:21:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [RFC PATCH v2 00/19] virtual-bus
Date: Thu, 11 Jun 2009 22:51:20 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, lguest@ozlabs.org
References: <20090409155200.32740.19358.stgit@dev.haskins.net> <200906060025.57961.rusty@rustcorp.com.au> <20090605162553.GC6778@linux.vnet.ibm.com>
In-Reply-To: <20090605162553.GC6778@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906112251.20827.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Jun 2009 01:55:53 am Paul E. McKenney wrote:
> It is possible to get rid of the rmb() and wmb() as well, doing
> something like the following:
>
> 	struct lg_eventfds_num {
> 		unsigned int n;
> 		struct lg_eventfds a[0];
> 	}
>
> Then the rcu_dereference() gets you a pointer to a struct lg_eventfds_num,
> which has the array and its length in guaranteed synchronization without
> the need for barriers.

Yep, that's actually quite nice.  The only wart is that it needs to be
allocated even when n == 0, but IMHO worth it for barrier avoidance.

This is what I ended up with:

lguest: use eventfds for device notification

Currently, when a Guest wants to perform I/O it calls LHCALL_NOTIFY with
an address: the main Launcher process returns with this address, and figures
out what device to run.

A far nicer model is to let processes bind an eventfd to an address: if we
find one, we simply signal the eventfd.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Davide Libenzi <davidel@xmailserver.org>
---
 drivers/lguest/Kconfig          |    2 
 drivers/lguest/core.c           |    8 ++-
 drivers/lguest/lg.h             |   13 +++++
 drivers/lguest/lguest_user.c    |   98 +++++++++++++++++++++++++++++++++++++++-
 include/linux/lguest_launcher.h |    1 
 5 files changed, 116 insertions(+), 6 deletions(-)

diff --git a/drivers/lguest/Kconfig b/drivers/lguest/Kconfig
--- a/drivers/lguest/Kconfig
+++ b/drivers/lguest/Kconfig
@@ -1,6 +1,6 @@
 config LGUEST
 	tristate "Linux hypervisor example code"
-	depends on X86_32 && EXPERIMENTAL && FUTEX
+	depends on X86_32 && EXPERIMENTAL && EVENTFD
 	select HVC_DRIVER
 	---help---
 	  This is a very simple module which allows you to run
diff --git a/drivers/lguest/core.c b/drivers/lguest/core.c
--- a/drivers/lguest/core.c
+++ b/drivers/lguest/core.c
@@ -198,9 +198,11 @@ int run_guest(struct lg_cpu *cpu, unsign
 		/* It's possible the Guest did a NOTIFY hypercall to the
 		 * Launcher, in which case we return from the read() now. */
 		if (cpu->pending_notify) {
-			if (put_user(cpu->pending_notify, user))
-				return -EFAULT;
-			return sizeof(cpu->pending_notify);
+			if (!send_notify_to_eventfd(cpu)) {
+				if (put_user(cpu->pending_notify, user))
+					return -EFAULT;
+				return sizeof(cpu->pending_notify);
+			}
 		}
 
 		/* Check for signals */
diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -82,6 +82,16 @@ struct lg_cpu {
 	struct lg_cpu_arch arch;
 };
 
+struct lg_eventfd {
+	unsigned long addr;
+	struct file *event;
+};
+
+struct lg_eventfd_map {
+	unsigned int num;
+	struct lg_eventfd map[];
+};
+
 /* The private info the thread maintains about the guest. */
 struct lguest
 {
@@ -102,6 +112,8 @@ struct lguest
 	unsigned int stack_pages;
 	u32 tsc_khz;
 
+	struct lg_eventfd_map *eventfds;
+
 	/* Dead? */
 	const char *dead;
 };
@@ -154,6 +166,7 @@ void setup_default_idt_entries(struct lg
 void copy_traps(const struct lg_cpu *cpu, struct desc_struct *idt,
 		const unsigned long *def);
 void guest_set_clockevent(struct lg_cpu *cpu, unsigned long delta);
+bool send_notify_to_eventfd(struct lg_cpu *cpu);
 void init_clockdev(struct lg_cpu *cpu);
 bool check_syscall_vector(struct lguest *lg);
 int init_interrupts(void);
diff --git a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -7,6 +7,8 @@
 #include <linux/miscdevice.h>
 #include <linux/fs.h>
 #include <linux/sched.h>
+#include <linux/eventfd.h>
+#include <linux/file.h>
 #include "lg.h"
 
 /*L:055 When something happens, the Waker process needs a way to stop the
@@ -35,6 +37,81 @@ static int break_guest_out(struct lg_cpu
 	}
 }
 
+bool send_notify_to_eventfd(struct lg_cpu *cpu)
+{
+	unsigned int i;
+	struct lg_eventfd_map *map;
+
+	/* lg->eventfds is RCU-protected */
+	rcu_read_lock();
+	map = rcu_dereference(cpu->lg->eventfds);
+	for (i = 0; i < map->num; i++) {
+		if (map->map[i].addr == cpu->pending_notify) {
+			eventfd_signal(map->map[i].event, 1);
+			cpu->pending_notify = 0;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return cpu->pending_notify == 0;
+}
+
+static int add_eventfd(struct lguest *lg, unsigned long addr, int fd)
+{
+	struct lg_eventfd_map *new, *old = lg->eventfds;
+
+	if (!addr)
+		return -EINVAL;
+
+	/* Replace the old array with the new one, carefully: others can
+	 * be accessing it at the same time */
+	new = kmalloc(sizeof(*new) + sizeof(new->map[0]) * (old->num + 1),
+		      GFP_KERNEL);
+	if (!new)
+		return -ENOMEM;
+
+	/* First make identical copy. */
+	memcpy(new->map, old->map, sizeof(old->map[0]) * old->num);
+	new->num = old->num;
+
+	/* Now append new entry. */
+	new->map[new->num].addr = addr;
+	new->map[new->num].event = eventfd_fget(fd);
+	if (IS_ERR(new->map[new->num].event)) {
+		kfree(new);
+		return PTR_ERR(new->map[new->num].event);
+	}
+	new->num++;
+
+	/* Now put new one in place. */
+	rcu_assign_pointer(lg->eventfds, new);
+
+	/* We're not in a big hurry.  Wait until noone's looking at old
+	 * version, then delete it. */
+	synchronize_rcu();
+	kfree(old);
+
+	return 0;
+}
+
+static int attach_eventfd(struct lguest *lg, const unsigned long __user *input)
+{
+	unsigned long addr, fd;
+	int err;
+
+	if (get_user(addr, input) != 0)
+		return -EFAULT;
+	input++;
+	if (get_user(fd, input) != 0)
+		return -EFAULT;
+
+	mutex_lock(&lguest_lock);
+	err = add_eventfd(lg, addr, fd);
+	mutex_unlock(&lguest_lock);
+
+	return 0;
+}
+
 /*L:050 Sending an interrupt is done by writing LHREQ_IRQ and an interrupt
  * number to /dev/lguest. */
 static int user_send_irq(struct lg_cpu *cpu, const unsigned long __user *input)
@@ -184,6 +261,13 @@ static int initialize(struct file *file,
 		goto unlock;
 	}
 
+	lg->eventfds = kmalloc(sizeof(*lg->eventfds), GFP_KERNEL);
+	if (!lg->eventfds) {
+		err = -ENOMEM;
+		goto free_lg;
+	}
+	lg->eventfds->num = 0;
+
 	/* Populate the easy fields of our "struct lguest" */
 	lg->mem_base = (void __user *)args[0];
 	lg->pfn_limit = args[1];
@@ -191,7 +275,7 @@ static int initialize(struct file *file,
 	/* This is the first cpu (cpu 0) and it will start booting at args[2] */
 	err = lg_cpu_start(&lg->cpus[0], 0, args[2]);
 	if (err)
-		goto release_guest;
+		goto free_eventfds;
 
 	/* Initialize the Guest's shadow page tables, using the toplevel
 	 * address the Launcher gave us.  This allocates memory, so can fail. */
@@ -210,7 +294,9 @@ static int initialize(struct file *file,
 free_regs:
 	/* FIXME: This should be in free_vcpu */
 	free_page(lg->cpus[0].regs_page);
-release_guest:
+free_eventfds:
+	kfree(lg->eventfds);
+free_lg:
 	kfree(lg);
 unlock:
 	mutex_unlock(&lguest_lock);
@@ -260,6 +346,8 @@ static ssize_t write(struct file *file, 
 		return user_send_irq(cpu, input);
 	case LHREQ_BREAK:
 		return break_guest_out(cpu, input);
+	case LHREQ_EVENTFD:
+		return attach_eventfd(lg, input);
 	default:
 		return -EINVAL;
 	}
@@ -297,6 +385,12 @@ static int close(struct inode *inode, st
 		 * the Launcher's memory management structure. */
 		mmput(lg->cpus[i].mm);
 	}
+
+	/* Release any eventfds they registered. */
+	for (i = 0; i < lg->eventfds->num; i++)
+		fput(lg->eventfds->map[i].event);
+	kfree(lg->eventfds);
+
 	/* If lg->dead doesn't contain an error code it will be NULL or a
 	 * kmalloc()ed string, either of which is ok to hand to kfree(). */
 	if (!IS_ERR(lg->dead))
diff --git a/include/linux/lguest_launcher.h b/include/linux/lguest_launcher.h
--- a/include/linux/lguest_launcher.h
+++ b/include/linux/lguest_launcher.h
@@ -58,6 +58,7 @@ enum lguest_req
 	LHREQ_GETDMA, /* No longer used */
 	LHREQ_IRQ, /* + irq */
 	LHREQ_BREAK, /* + on/off flag (on blocks until someone does off) */
+	LHREQ_EVENTFD, /* + address, fd. */
 };
 
 /* The alignment to use between consumer and producer parts of vring.

