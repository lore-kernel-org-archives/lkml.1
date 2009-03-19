Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbZCSMBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbZCSMBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 08:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbZCSMBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 08:01:44 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44103 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbZCSMBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 08:01:43 -0400
To: Ingo Molnar <mingo@elte.hu>
CC: <linux-kernel@vger.kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 19 Mar 2009 05:01:37 -0700
Message-ID: <m1ljr1bu1q.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: mingo@elte.hu, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ingo Molnar <mingo@elte.hu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Lockdep and reference counting and waiting for something to go away.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently in the networking code we have is most easily described
as a lock ordering violation when accessing files in sysfs or
sysctl, when the methods for those files take the rtnl_lock.

I am trying to teach lockdep about the reference counting so
that it will report that lock ordering problem.

I have added what appear to be the obvious annotations but
I an not getting a lockdep warning.

To expersize both paths that have the inverse ordering I do:

# ip link add veth0 type veth peer name veth1
# echo 1 > /proc/sys/net/ipv4/conf/veth0/forwarding

This grabs the sysctl use count and then inside devinet_sysctl_forward
grabs the rtnl_lock.

# ip link del veth0

This calls unregister_netdevice with the rntl_lock held
Which then waits for the the sysctl use count to drop to zero
on the specified sysctl file.

My rough patch below has my code to date.  Ingo any chance
you could take a quick look and tell me what I am doing wrong,
and why lockdep isn't complaining to me when I run my test?

Eric


diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c5ef44f..3ac3943 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1454,12 +1454,22 @@ static struct ctl_table dev_table[] = {
 
 static DEFINE_SPINLOCK(sysctl_lock);
 
+#ifdef CONFIG_LOCKDEP
+static struct lock_class_key sysctl_lock_class_key;
+static struct lockdep_map sysctl_dep_map;
+#endif
+
 /* called under sysctl_lock */
 static int use_table(struct ctl_table_header *p)
 {
 	if (unlikely(p->unregistering))
 		return 0;
 	p->used++;
+#if 1
+	lock_acquire(&sysctl_dep_map, 0, 0, 2, 2, NULL, _RET_IP_);
+//	lock_acquire(&sysctl_dep_map, 0, 0, 0, 2, NULL, _RET_IP_);
+	lock_acquired(&sysctl_dep_map, _RET_IP_);
+#endif
 	return 1;
 }
 
@@ -1469,6 +1479,9 @@ static void unuse_table(struct ctl_table_header *p)
 	if (!--p->used)
 		if (unlikely(p->unregistering))
 			complete(p->unregistering);
+#if 1
+	lock_release(&sysctl_dep_map, 0, _RET_IP_);
+#endif
 }
 
 /* called under sysctl_lock, will reacquire if has to wait */
@@ -1478,8 +1491,14 @@ static void start_unregistering(struct ctl_table_header *p)
 	 * if p->used is 0, nobody will ever touch that entry again;
 	 * we'll eliminate all paths to it before dropping sysctl_lock
 	 */
+#if 1
+	lock_acquire(&sysctl_dep_map, 0, 0, 0, 2, NULL, _RET_IP_);
+#endif
 	if (unlikely(p->used)) {
 		struct completion wait;
+#if 1
+		lock_contended(&sysctl_dep_map, _RET_IP_);
+#endif
 		init_completion(&wait);
 		p->unregistering = &wait;
 		spin_unlock(&sysctl_lock);
@@ -1489,11 +1508,18 @@ static void start_unregistering(struct ctl_table_header *p)
 		/* anything non-NULL; we'll never dereference it */
 		p->unregistering = ERR_PTR(-EINVAL);
 	}
+#if 1
+	lock_acquired(&sysctl_dep_map, _RET_IP_);
+#endif
 	/*
 	 * do not remove from the list until nobody holds it; walking the
 	 * list in do_sysctl() relies on that.
 	 */
 	list_del_init(&p->ctl_entry);
+
+#if 1
+	lock_release(&sysctl_dep_map, 0, _RET_IP_);
+#endif
 }
 
 void sysctl_head_get(struct ctl_table_header *head)
@@ -1763,6 +1789,10 @@ static void sysctl_set_parent(struct ctl_table *parent, struct ctl_table *table)
 
 static __init int sysctl_init(void)
 {
+#ifdef CONFIG_LOCKDEP
+	lockdep_init_map(&sysctl_dep_map, "sysctl_use",
+		&sysctl_lock_class_key, 0);
+#endif
 	sysctl_set_parent(NULL, root_table);
 #ifdef CONFIG_SYSCTL_SYSCALL_CHECK
 	{
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 309997e..47f7515 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1334,11 +1334,20 @@ static int devinet_sysctl_forward(ctl_table *ctl, int write,
 	int val = *valp;
 	int ret = proc_dointvec(ctl, write, filp, buffer, lenp, ppos);
 
+#if 1
+	printk(KERN_DEBUG "%s.%d val: %d, *valp: %d *\n", __func__, __LINE__, val, *valp);
+#endif
 	if (write && *valp != val) {
 		struct net *net = ctl->extra2;
 
+#if 1
+	printk(KERN_DEBUG "%s.%d val: %d, *valp: %d\n", __func__, __LINE__, val, *valp);
+#endif
 		if (valp != &IPV4_DEVCONF_DFLT(net, FORWARDING)) {
 			rtnl_lock();
+#if 1
+	printk(KERN_DEBUG "%s.%d val: %d, *valp: %d\n", __func__, __LINE__, val, *valp);
+#endif
 			if (valp == &IPV4_DEVCONF_ALL(net, FORWARDING)) {
 				inet_forward_change(net);
 			} else if (*valp) {
