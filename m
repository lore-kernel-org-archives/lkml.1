Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758008AbYLQCFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbYLQCFq (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 21:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbYLQCFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 21:05:36 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:59870 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbYLQCFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 21:05:35 -0500
Date: Tue, 16 Dec 2008 18:04:35 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com
Cc: daniel@hozac.com, bastian@waldi.eu.org, xemul@openvz.org,
        containers@lists.osdl.org, linux-kernel@vger.kernel.org,
        sukadev@us.ibm.com
Subject: [RFC][PATCH][v2] SEND_SIG_NOINFO: Masquerade si_pid when crossing
	pid-ns boundary
Message-ID: <20081217020435.GA2866@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Fri, 12 Dec 2008 17:51:43 -0800
Subject: [PATCH] SEND_SIG_NOINFO: Masquerade si_pid when crossing pid-ns boundary

For SEND_SIG_NOINFO, si_pid is currently set to the pid of sender
in sender's active pid namespace. But if the receiver is in a
different namespace, that given pid number would be incorrect.
Eg: when parent sends the 'pdeath_signal' to a child that is in
a descendant pid namespace, we should set si_pid 0.

Changelog[v2]
	- Moved change from task_pid() to task_tgid() to separate patch

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 kernel/signal.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 2a64304..d11e5f8 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -856,7 +856,8 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			q->info.si_signo = sig;
 			q->info.si_errno = 0;
 			q->info.si_code = SI_USER;
-			q->info.si_pid = task_pid_vnr(current);
+			q->info.si_pid = task_pid_nr_ns(current,
+							task_active_pid_ns(t));
 			q->info.si_uid = current_uid();
 			break;
 		case (unsigned long) SEND_SIG_PRIV:
-- 
1.5.2.5

