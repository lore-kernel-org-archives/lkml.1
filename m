Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbYLXLzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbYLXLzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 06:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbYLXLzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 06:55:04 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34285 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbYLXLzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 06:55:03 -0500
Date: Wed, 24 Dec 2008 03:53:31 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       bastian@waldi.eu.org
Cc: daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 7/7][v4] SI_TKILL: Masquerade si_pid when crossing pid
	ns boundary
Message-ID: <20081224115331.GG8020@us.ibm.com>
References: <20081224114414.GA7879@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081224114414.GA7879@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: [RFC][PATCH 7/7][v4] SI_TKILL: Masquerade si_pid when crossing pid ns boundary

When sending a signal to a process in a descendant namespace, ->si_pid
must be set to the pid of sender in receiver's namespace. But if the
receiver is exiting (theoretically, ns == NULL), just set ->si_pid to
active pid namespace of sender (receiver won't see the signal anyway ?).

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 kernel/signal.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 5a6aea8..e263c23 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2385,17 +2385,22 @@ static int do_tkill(pid_t tgid, pid_t pid, int sig)
 	struct siginfo info;
 	struct task_struct *p;
 	unsigned long flags;
+	struct pid_namespace *ns;
 
 	error = -ESRCH;
 	info.si_signo = sig;
 	info.si_errno = 0;
 	info.si_code = SI_TKILL;
-	info.si_pid = task_tgid_vnr(current);
 	info.si_uid = current_uid();
 
 	rcu_read_lock();
 	p = find_task_by_vpid(pid);
 	if (p && (tgid <= 0 || task_tgid_vnr(p) == tgid)) {
+		ns = task_active_pid_ns(p);
+		if (ns)
+			info.si_pid = task_tgid_nr_ns(current, ns);
+		else
+			info.si_pid = task_tgid_vnr(current);
 		error = check_kill_permission(sig, &info, p);
 		/*
 		 * The null signal is a permissions and process existence
-- 
1.5.2.5

