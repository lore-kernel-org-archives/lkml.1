Return-Path: <linux-kernel-owner+w=401wt.eu-S1756633AbXFUEaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbXFUEaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 00:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755978AbXFUEan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 00:30:43 -0400
Received: from ns.suse.de ([195.135.220.2]:41696 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755817AbXFUEam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 00:30:42 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 21 Jun 2007 14:30:31 +1000
Message-Id: <1070621043031.1048@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: J "." Bruce Fields <bfields@citi.umich.edu>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Marc Eshel <eshel@almaden.ibm.com>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 001 of 8] knfsd: lockd: nfsd4: use same grace period for lockd and nfsd4
References: <20070621142604.727.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "J. Bruce Fields" <bfields@fieldses.org>

Both lockd and (in the nfsv4 case) nfsd enforce a "grace period" after
reboot, during which clients may reclaim locks from the previous server
instance, but may not acquire new locks.

Currently the lockd and nfsd enforce grace periods of different lengths.
This may cause problems when we reboot a server with both v2/v3 and v4
clients.  For example, if the lockd grace period is shorter (as is likely
the case), then a v3 client might acquire a new lock that conflicts with a
lock already held (but not yet reclaimed) by a v4 client.

This patch calculates a lease time that lockd and nfsd can both use.

Signed-off-by: Marc Eshel <eshel@almaden.ibm.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/lockd/svc.c             |   27 ++++++++++++++++++++-------
 ./fs/nfsd/lockd.c            |    1 +
 ./fs/nfsd/nfs4state.c        |   16 ++++++++++++----
 ./include/linux/lockd/bind.h |    9 +++++++++
 4 files changed, 42 insertions(+), 11 deletions(-)

diff .prev/fs/lockd/svc.c ./fs/lockd/svc.c
--- .prev/fs/lockd/svc.c	2007-06-21 14:08:51.000000000 +1000
+++ ./fs/lockd/svc.c	2007-06-21 13:52:05.000000000 +1000
@@ -76,18 +76,31 @@ static const int		nlm_port_min = 0, nlm_
 
 static struct ctl_table_header * nlm_sysctl_table;
 
-static unsigned long set_grace_period(void)
+static unsigned long get_lockd_grace_period(void)
 {
-	unsigned long grace_period;
-
 	/* Note: nlm_timeout should always be nonzero */
 	if (nlm_grace_period)
-		grace_period = ((nlm_grace_period + nlm_timeout - 1)
-				/ nlm_timeout) * nlm_timeout * HZ;
+		return roundup(nlm_grace_period, nlm_timeout) * HZ;
 	else
-		grace_period = nlm_timeout * 5 * HZ;
+		return nlm_timeout * 5 * HZ;
+}
+
+unsigned long get_nfs_grace_period(void)
+{
+	unsigned long lockdgrace = get_lockd_grace_period();
+	unsigned long nfsdgrace = 0;
+
+	if (nlmsvc_ops)
+		nfsdgrace = nlmsvc_ops->get_grace_period();
+
+	return max(lockdgrace, nfsdgrace);
+}
+EXPORT_SYMBOL(get_nfs_grace_period);
+
+static unsigned long set_grace_period(void)
+{
 	nlmsvc_grace_period = 1;
-	return grace_period + jiffies;
+	return get_nfs_grace_period() + jiffies;
 }
 
 static inline void clear_grace_period(void)

diff .prev/fs/nfsd/lockd.c ./fs/nfsd/lockd.c
--- .prev/fs/nfsd/lockd.c	2007-06-21 14:08:51.000000000 +1000
+++ ./fs/nfsd/lockd.c	2007-06-21 13:46:56.000000000 +1000
@@ -65,6 +65,7 @@ nlm_fclose(struct file *filp)
 static struct nlmsvc_binding	nfsd_nlm_ops = {
 	.fopen		= nlm_fopen,		/* open file for locking */
 	.fclose		= nlm_fclose,		/* close file */
+	.get_grace_period = get_nfs4_grace_period,
 };
 
 void

diff .prev/fs/nfsd/nfs4state.c ./fs/nfsd/nfs4state.c
--- .prev/fs/nfsd/nfs4state.c	2007-06-21 14:08:51.000000000 +1000
+++ ./fs/nfsd/nfs4state.c	2007-06-21 14:09:23.000000000 +1000
@@ -51,6 +51,7 @@
 #include <linux/namei.h>
 #include <linux/mutex.h>
 #include <linux/lockd/bind.h>
+#include <linux/module.h>
 
 #define NFSDDBG_FACILITY                NFSDDBG_PROC
 
@@ -3191,20 +3192,27 @@ nfsd4_load_reboot_recovery_data(void)
 		printk("NFSD: Failure reading reboot recovery data\n");
 }
 
+unsigned long
+get_nfs4_grace_period(void)
+{
+	return max(user_lease_time, lease_time) * HZ;
+}
+
 /* initialization to perform when the nfsd service is started: */
 
 static void
 __nfs4_state_start(void)
 {
-	time_t grace_time;
+	unsigned long grace_time;
 
 	boot_time = get_seconds();
-	grace_time = max(user_lease_time, lease_time);
+	grace_time = get_nfs_grace_period();
 	lease_time = user_lease_time;
 	in_grace = 1;
-	printk("NFSD: starting %ld-second grace period\n", grace_time);
+	printk(KERN_INFO "NFSD: starting %ld-second grace period\n",
+	       grace_time/HZ);
 	laundry_wq = create_singlethread_workqueue("nfsd4");
-	queue_delayed_work(laundry_wq, &laundromat_work, grace_time*HZ);
+	queue_delayed_work(laundry_wq, &laundromat_work, grace_time);
 }
 
 int

diff .prev/include/linux/lockd/bind.h ./include/linux/lockd/bind.h
--- .prev/include/linux/lockd/bind.h	2007-06-21 14:08:51.000000000 +1000
+++ ./include/linux/lockd/bind.h	2007-06-21 13:46:56.000000000 +1000
@@ -27,6 +27,7 @@ struct nlmsvc_binding {
 						struct nfs_fh *,
 						struct file **);
 	void			(*fclose)(struct file *);
+	unsigned long		(*get_grace_period)(void);
 };
 
 extern struct nlmsvc_binding *	nlmsvc_ops;
@@ -38,4 +39,12 @@ extern int	nlmclnt_proc(struct inode *, 
 extern int	lockd_up(int proto);
 extern void	lockd_down(void);
 
+unsigned long get_nfs_grace_period(void);
+
+#ifdef CONFIG_NFSD_V4
+unsigned long get_nfs4_grace_period(void);
+#else
+static inline unsigned long get_nfs4_grace_period(void) {return 0;}
+#endif
+
 #endif /* LINUX_LOCKD_BIND_H */
