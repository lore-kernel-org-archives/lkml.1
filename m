Return-Path: <linux-kernel-owner+w=401wt.eu-S934226AbXJPRsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934226AbXJPRsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 13:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbXJPRry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 13:47:54 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:47801 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbXJPRry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 13:47:54 -0400
Date: Tue, 16 Oct 2007 23:10:16 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: Build breakage if !SYSFS
Message-ID: <20071016174016.GC5693@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071016130231.GA10778@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016130231.GA10778@linux-mips.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 02:02:31PM +0100, Ralf Baechle wrote:
> Changeset 5cb350baf580017da38199625b7365b1763d7180 causes build breakage
> if sysfs support is disabled:
> 
> kernel/built-in.o: In function `uids_kobject_init':
> (.init.text+0x1488): undefined reference to `kernel_subsys'
> kernel/built-in.o: In function `uids_kobject_init':
> (.init.text+0x1490): undefined reference to `kernel_subsys'
> kernel/built-in.o: In function `uids_kobject_init':
> (.init.text+0x1480): undefined reference to `kernel_subsys'
> kernel/built-in.o: In function `uids_kobject_init':
> (.init.text+0x1494): undefined reference to `kernel_subsys'
> 
> This breaks for example mipssim_defconfig.
> 
>   Ralf

Hi Ralf,

Can you try this and confirm if it works?

--

When CONFIG_SYSFS is not set, CONFIG_FAIR_USER_SCHED fails to build
with

kernel/built-in.o: In function `uids_kobject_init':
(.init.text+0x1488): undefined reference to `kernel_subsys'
kernel/built-in.o: In function `uids_kobject_init':
(.init.text+0x1490): undefined reference to `kernel_subsys'
kernel/built-in.o: In function `uids_kobject_init':
(.init.text+0x1480): undefined reference to `kernel_subsys'
kernel/built-in.o: In function `uids_kobject_init':
(.init.text+0x1494): undefined reference to `kernel_subsys'

This patch fixes this build error.

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

---
 include/linux/sched.h |    2 ++
 kernel/user.c         |   23 +++++++++++++++--------
 2 files changed, 17 insertions(+), 8 deletions(-)

Index: current/include/linux/sched.h
===================================================================
--- current.orig/include/linux/sched.h
+++ current/include/linux/sched.h
@@ -602,10 +602,12 @@ struct user_struct {
 
 #ifdef CONFIG_FAIR_USER_SCHED
 	struct task_group *tg;
+#ifdef CONFIG_SYSFS
 	struct kset kset;
 	struct subsys_attribute user_attr;
 	struct work_struct work;
 #endif
+#endif
 };
 
 #ifdef CONFIG_FAIR_USER_SCHED
Index: current/kernel/user.c
===================================================================
--- current.orig/kernel/user.c
+++ current/kernel/user.c
@@ -87,9 +87,6 @@ static inline struct user_struct *uid_ha
 
 #ifdef CONFIG_FAIR_USER_SCHED
 
-static struct kobject uids_kobject; /* represents /sys/kernel/uids directory */
-static DEFINE_MUTEX(uids_mutex);
-
 static void sched_destroy_user(struct user_struct *up)
 {
 	sched_destroy_group(up->tg);
@@ -111,6 +108,19 @@ static void sched_switch_user(struct tas
 	sched_move_task(p);
 }
 
+#else	/* CONFIG_FAIR_USER_SCHED */
+
+static void sched_destroy_user(struct user_struct *up) { }
+static int sched_create_user(struct user_struct *up) { return 0; }
+static void sched_switch_user(struct task_struct *p) { }
+
+#endif	/* CONFIG_FAIR_USER_SCHED */
+
+#if defined(CONFIG_FAIR_USER_SCHED) && defined(CONFIG_SYSFS)
+
+static struct kobject uids_kobject; /* represents /sys/kernel/uids directory */
+static DEFINE_MUTEX(uids_mutex);
+
 static inline void uids_mutex_lock(void)
 {
 	mutex_lock(&uids_mutex);
@@ -257,11 +267,8 @@ static inline void free_user(struct user
 	schedule_work(&up->work);
 }
 
-#else	/* CONFIG_FAIR_USER_SCHED */
+#else	/* CONFIG_FAIR_USER_SCHED && CONFIG_SYSFS */
 
-static void sched_destroy_user(struct user_struct *up) { }
-static int sched_create_user(struct user_struct *up) { return 0; }
-static void sched_switch_user(struct task_struct *p) { }
 static inline int user_kobject_create(struct user_struct *up) { return 0; }
 static inline void uids_mutex_lock(void) { }
 static inline void uids_mutex_unlock(void) { }
@@ -280,7 +287,7 @@ static inline void free_user(struct user
 	kmem_cache_free(uid_cachep, up);
 }
 
-#endif	/* CONFIG_FAIR_USER_SCHED */
+#endif
 
 /*
  * Locate the user_struct for the passed UID.  If found, take a ref on it.  The

-- 
regards,
Dhaval
