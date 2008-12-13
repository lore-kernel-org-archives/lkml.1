Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbYLMCkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbYLMCkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 21:40:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbYLMCj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 21:39:59 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:46850 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331AbYLMCj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 21:39:58 -0500
Date: Fri, 12 Dec 2008 18:39:15 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, roland@redhat.com,
       bastian@waldi.eu.org, Pavel Emelyanov <xemul@openvz.org>,
       sukadev@linux.vnet.ibm.com, Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH][v2] Fix si_pid value in mqueue do_notify()
Message-ID: <20081213023915.GA4256@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Fri, 12 Dec 2008 17:50:08 -0800
Subject: [PATCH] Fix si_pid value in mqueue do_notify()

If a process registers for asynchronous notification on a POSIX message
queue, it gets a signal and a siginfo_t structure when a message arrives on
the message queue. The si_pid in the siginfo_t structure is set to the PID of
the process that sent the message to the message queue.

The principle is the following:
. when mq_notify(SIGEV_SIGNAL) is called, the caller registers for
  notification when a msg arrives. The associated pid structure is stroed into
  inode_info->notify_owner. Let's call this process P1.
. when mq_send() is called by say P2, P2 sends a signal to P1 to notify
  him about msg arrival.

The way .si_pid is set today is not correct, since it doesn't take into account
the fact that the process that is sending the message might not be in the
same namespace as the notified one.

This patch proposes to set si_pid to the sender's pid into the notify_owner
namespace.

Changelog[v2]:
        - Moved ns_of_pid() to separate patch and simplified this patch.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 ipc/mqueue.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index d9393f8..cf465ce 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -506,7 +506,8 @@ static void __do_notify(struct mqueue_inode_info *info)
 			sig_i.si_errno = 0;
 			sig_i.si_code = SI_MESGQ;
 			sig_i.si_value = info->notify.sigev_value;
-			sig_i.si_pid = task_tgid_vnr(current);
+			sig_i.si_pid = task_tgid_nr_ns(current,
+						ns_of_pid(info->notify_owner));
 			sig_i.si_uid = current_uid();
 
 			kill_pid_info(info->notify.sigev_signo,
-- 
1.5.2.5

