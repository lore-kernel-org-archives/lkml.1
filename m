Return-Path: <linux-kernel-owner+w=401wt.eu-S935316AbYGCHMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935316AbYGCHMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbYGCG60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:58:26 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:58159 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbYGCFiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 01:38:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18540.26117.5299.993598@frecb006361.adech.frec.bull.fr>
Date: Thu, 3 Jul 2008 07:39:17 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <Solofo.Ramangalahy@bull.net>, linux-kernel@vger.kernel.org,
       matthltc@us.ibm.com, cmm@us.ibm.com, Nadia.Derbey@bull.net,
       manfred@colorfullife.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH -mm 0/3] sysv ipc: increase msgmnb with the number of
 cpus
In-Reply-To: <20080701151650.f27a425a.akpm@linux-foundation.org>
References: <20080624093452.946878437@bull.net>
	<20080701151650.f27a425a.akpm@linux-foundation.org>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
From: Solofo.Ramangalahy@bull.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:
 > I'm afraid I've lost track of what's happening here.  Did we come up
 > with an alternative to "magical positive-versus-negative number trick"?

Yes, several proposals:
1. /proc/sys/kernel/automatic-msgmnb
   (attempt attached).

2. a variation /sys/kernel/automatic/msgmn*
   as a mean to alleviate the doubling of the interface.

 > Your patch #1 adds and uses recompute_msgmnb() without adding the
 > declaration to a header file.  Your patch #2 does add the
 > recompute_msgmnb() to a header file, so we have a window in which the
 > build is broken, which is bad.

Sorry. Another fix needed to my quilt workflow.
Thanks.

 > recompute_msgmnb() isn't a terribly good globally-visible identifier,
 > btw.  It is nice to add some subsystem identifer as a prefix.  There's
 > little chance of this symbol colliding with anything else, so this is a
 > minor cosmetic thing in this case.

ok. msg_recompute_msgmnb seems to be the better name.

-- 
solofo

Index: b/ipc/msg.c
===================================================================
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -38,6 +38,7 @@
 #include <linux/rwsem.h>
 #include <linux/nsproxy.h>
 #include <linux/ipc_namespace.h>
+#include <linux/cpumask.h>

 #include <asm/current.h>
 #include <asm/uaccess.h>
@@ -90,9 +91,11 @@ void recompute_msgmni(struct ipc_namespa
        unsigned long allowed;
        int nb_ns;

+       if (!ns->msg_ctlmni_activated)
+               return;
        si_meminfo(&i);
        allowed = (((i.totalram - i.totalhigh) / MSG_MEM_SCALE) * i.mem_unit)
-               / MSGMNB;
+               / ns->msg_ctlmnb;
        nb_ns = atomic_read(&nr_ipc_ns);
        allowed /= nb_ns;

@@ -108,11 +111,23 @@ void recompute_msgmni(struct ipc_namespa

        ns->msg_ctlmni = allowed;
 }
+/*
+ * Scale msgmnb with the number of online cpus, up to 4x MSGMNB.
+ */
+void msg_recompute_msgmnb(struct ipc_namespace *ns)
+{
+       if (!ns->msg_ctlmnb_activated)
+               return;
+       ns->msg_ctlmnb =
+               min(MSGMNB * num_online_cpus(), MSGMNB * MSG_CPU_SCALE);
+}

 void msg_init_ns(struct ipc_namespace *ns)
 {
        ns->msg_ctlmax = MSGMAX;
-       ns->msg_ctlmnb = MSGMNB;
+       ns->msg_ctlmnb_activated = 1;
+       ns->msg_ctlmni_activated = 1;
+       msg_recompute_msgmnb(ns);

        recompute_msgmni(ns);

@@ -132,8 +147,8 @@ void __init msg_init(void)
 {
        msg_init_ns(&init_ipc_ns);

-       printk(KERN_INFO "msgmni has been set to %d\n",
-               init_ipc_ns.msg_ctlmni);
+       printk(KERN_INFO "msgmni has been set to %d, msgmnb to %d\n",
+              init_ipc_ns.msg_ctlmni, init_ipc_ns.msg_ctlmnb);

        ipc_init_proc_interface("sysvipc/msg",
                                "       key      msqid perms      cbytes       qnum lspid lrpid   uid   gid  cuid  cgid      stime      rtime      ctime\n",
Index: b/include/linux/msg.h
===================================================================
--- a/include/linux/msg.h
+++ b/include/linux/msg.h
@@ -58,6 +58,12 @@ struct msginfo {
  * more than 16 GB : msgmni = 32K (IPCMNI)
  */
 #define MSG_MEM_SCALE 32
+/*
+ * Scaling factor to compute msgmnb: ns->msg_ctlmnb is between MSGMNB
+ * and MSGMNB * MSG_CPU_SCALE. This leads to a max msgmnb value of
+ * 65536 which is an already used and recommended value.
+ */
+#define MSG_CPU_SCALE 4

 #define MSGMNI    16   /* <= IPCMNI */     /* max # of msg queue identifiers */
 #define MSGMAX  8192   /* <= INT_MAX */   /* max size of message (bytes) */
Index: b/ipc/ipc_sysctl.c
===================================================================
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -31,19 +31,22 @@ static void *get_ipc(ctl_table *table)
  * hand and it has a callback routine registered on the ipc namespace notifier
  * chain: we don't want such tunables to be recomputed anymore upon memory
  * add/remove or ipc namespace creation/removal.
- * They can come back to a recomputable state by being set to a <0 value.
  */
-static void tunable_set_callback(int val)
+static void tunable_set_callback(int val, ctl_table *table)
 {
-       if (val >= 0)
-               unregister_ipcns_notifier(current->nsproxy->ipc_ns);
-       else {
-               /*
-                * Re-enable automatic recomputing only if not already
-                * enabled.
-                */
-               recompute_msgmni(current->nsproxy->ipc_ns);
-               cond_register_ipcns_notifier(current->nsproxy->ipc_ns);
+       int tunable = table->ctl_name;
+
+       switch (tunable) {
+       case KERN_MSGMNB:
+               current->nsproxy->ipc_ns->msg_ctlmnb_activated = 0;
+               break;
+       case KERN_MSGMNI:
+               current->nsproxy->ipc_ns->msg_ctlmni_activated = 0;
+               break;
+       default:
+               printk(KERN_ERR "ipc: unexpected value %s\n",
+                      table->procname);
+               break;
        }
 }

@@ -70,9 +73,10 @@ static int proc_ipc_callback_dointvec(ct

        rc = proc_dointvec(&ipc_table, write, filp, buffer, lenp, ppos);

-       if (write && !rc && lenp_bef == *lenp)
-               tunable_set_callback(*((int *)(ipc_table.data)));
-
+       if (write && !rc && lenp_bef == *lenp) {
+               BUG_ON(table == NULL);
+               tunable_set_callback(*((int *)(ipc_table.data)), table);
+       }
        return rc;
 }

@@ -147,8 +151,8 @@ static int sysctl_ipc_registered_data(ct
                 * Tunable has successfully been changed from userland
                 */
                int *data = get_ipc(table);
-
-               tunable_set_callback(*data);
+               BUG_ON(table == NULL);
+               tunable_set_callback(*data, table);
        }

        return rc;
@@ -210,6 +214,15 @@ static struct ctl_table ipc_kern_table[]
                .data           = &init_ipc_ns.msg_ctlmnb,
                .maxlen         = sizeof (init_ipc_ns.msg_ctlmnb),
                .mode           = 0644,
+               .proc_handler   = proc_ipc_callback_dointvec,
+               .strategy       = sysctl_ipc_registered_data,
+       },
+       {
+               .ctl_name       = KERN_AUTOMATIC_MSGMNB,
+               .procname       = "automatic_msgmnb",
+               .data           = &init_ipc_ns.msg_ctlmnb_activated,
+               .maxlen         = sizeof (init_ipc_ns.msg_ctlmnb_activated),
+               .mode           = 0644,
                .proc_handler   = proc_ipc_dointvec,
                .strategy       = sysctl_ipc_data,
        },
Index: b/include/linux/ipc_namespace.h
===================================================================
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -12,6 +12,7 @@
 #define IPCNS_MEMCHANGED   0x00000001   /* Notify lowmem size changed */
 #define IPCNS_CREATED  0x00000002   /* Notify new ipc namespace created */
 #define IPCNS_REMOVED  0x00000003   /* Notify ipc namespace removed */
+#define IPCNS_CPUCHANGED  0x00000004   /* Notify cpu hotplug addition/removal */

 #define IPCNS_CALLBACK_PRI 0

@@ -33,7 +34,9 @@ struct ipc_namespace {

        int             msg_ctlmax;
        int             msg_ctlmnb;
+       int             msg_ctlmnb_activated;
        int             msg_ctlmni;
+       int             msg_ctlmni_activated;
        atomic_t        msg_bytes;
        atomic_t        msg_hdrs;

@@ -52,7 +55,6 @@ extern atomic_t nr_ipc_ns;
 #define INIT_IPC_NS(ns)                .ns             = &init_ipc_ns,

 extern int register_ipcns_notifier(struct ipc_namespace *);
-extern int cond_register_ipcns_notifier(struct ipc_namespace *);
 extern int unregister_ipcns_notifier(struct ipc_namespace *);
 extern int ipcns_notify(unsigned long);

Index: b/ipc/util.c
===================================================================
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -34,6 +34,7 @@
 #include <linux/nsproxy.h>
 #include <linux/rwsem.h>
 #include <linux/memory.h>
+#include <linux/cpu.h>
 #include <linux/ipc_namespace.h>

 #include <asm/unistd.h>
@@ -96,6 +97,32 @@ static int ipc_memory_callback(struct no

 #endif /* CONFIG_MEMORY_HOTPLUG */

+#ifdef CONFIG_HOTPLUG_CPU
+
+static void ipc_cpu_notifier(struct work_struct *work)
+{
+       ipcns_notify(IPCNS_CPUCHANGED);
+}
+
+static DECLARE_WORK(ipc_cpu_wq, ipc_cpu_notifier);
+
+static int __cpuinit ipc_cpu_callback(struct notifier_block *nfb,
+                                   unsigned long action, void *hcpu)
+{
+       switch (action) {
+       case CPU_ONLINE:
+       case CPU_ONLINE_FROZEN:
+       case CPU_DEAD:
+       case CPU_DEAD_FROZEN:
+               schedule_work(&ipc_cpu_wq);
+               break;
+       default:
+               break;
+       }
+       return NOTIFY_OK;
+}
+
+#endif /* CONFIG_HOTPLUG_CPU */
 /**
  *     ipc_init        -       initialise IPC subsystem
  *
@@ -112,6 +139,7 @@ static int __init ipc_init(void)
        msg_init();
        shm_init();
        hotplug_memory_notifier(ipc_memory_callback, IPC_CALLBACK_PRI);
+       hotcpu_notifier(ipc_cpu_callback, IPC_CALLBACK_PRI);
        register_ipcns_notifier(&init_ipc_ns);
        return 0;
 }
Index: b/ipc/ipcns_notifier.c
===================================================================
--- a/ipc/ipcns_notifier.c
+++ b/ipc/ipcns_notifier.c
@@ -26,16 +26,20 @@ static int ipcns_callback(struct notifie
                                unsigned long action, void *arg)
 {
        struct ipc_namespace *ns;
-
+       ns = container_of(self, struct ipc_namespace, ipcns_nb);
        switch (action) {
+       case IPCNS_CPUCHANGED:
+               /*
+                * Fall through.
+                * We do not scale msgmnb with IPC namespace
+                * add/remove for simplicity (adjustment of the
+                * message pool is done indirectly via msgmni).
+                */
+               msg_recompute_msgmnb(ns);
        case IPCNS_MEMCHANGED:   /* amount of lowmem has changed */
        case IPCNS_CREATED:
        case IPCNS_REMOVED:
                /*
-                * It's time to recompute msgmni
-                */
-               ns = container_of(self, struct ipc_namespace, ipcns_nb);
-               /*
                 * No need to get a reference on the ns: the 1st job of
                 * free_ipc_ns() is to unregister the callback routine.
                 * blocking_notifier_chain_unregister takes the wr lock to do
@@ -61,15 +65,6 @@ int register_ipcns_notifier(struct ipc_n
        return blocking_notifier_chain_register(&ipcns_chain, &ns->ipcns_nb);
 }

-int cond_register_ipcns_notifier(struct ipc_namespace *ns)
-{
-       memset(&ns->ipcns_nb, 0, sizeof(ns->ipcns_nb));
-       ns->ipcns_nb.notifier_call = ipcns_callback;
-       ns->ipcns_nb.priority = IPCNS_CALLBACK_PRI;
-       return blocking_notifier_chain_cond_register(&ipcns_chain,
-                                                       &ns->ipcns_nb);
-}
-
 int unregister_ipcns_notifier(struct ipc_namespace *ns)
 {
        return blocking_notifier_chain_unregister(&ipcns_chain,
Index: b/ipc/util.h
===================================================================
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -122,6 +122,7 @@ extern struct msg_msg *load_msg(const vo
 extern int store_msg(void __user *dest, struct msg_msg *msg, int len);

 extern void recompute_msgmni(struct ipc_namespace *);
+extern void msg_recompute_msgmnb(struct ipc_namespace *);

 static inline int ipc_buildid(int id, int seq)
 {
Index: b/include/linux/sysctl.h
===================================================================
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -163,6 +163,7 @@ enum
        KERN_MAX_LOCK_DEPTH=74,
        KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
        KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
+       KERN_AUTOMATIC_MSGMNB=77, /* int: automatic msgmnb computation */
 };


Index: b/kernel/sysctl_check.c
===================================================================
--- a/kernel/sysctl_check.c
+++ b/kernel/sysctl_check.c
@@ -104,6 +104,7 @@ static const struct trans_ctl_table tran
        { KERN_MAX_LOCK_DEPTH,          "max_lock_depth" },
        { KERN_NMI_WATCHDOG,            "nmi_watchdog" },
        { KERN_PANIC_ON_NMI,            "panic_on_unrecovered_nmi" },
+       { KERN_AUTOMATIC_MSGMNB,        "automatic_msgmnb" },
        {}
 };
