Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758200AbYLQCHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbYLQCHR (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 21:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbYLQCHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 21:07:01 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:47099 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbYLQCHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 21:07:00 -0500
Date: Tue, 16 Dec 2008 18:06:01 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com
Cc: daniel@hozac.com, bastian@waldi.eu.org, xemul@openvz.org,
        containers@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] SEND_SIG_NOINFO: Set si_pid to tgid instead of pid
Message-ID: <20081217020601.GB2866@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Tue, 16 Dec 2008 17:07:17 -0800
Subject: [PATCH] SEND_SIG_NOINFO: Set si_pid to tgid instead of pid

POSIX requires the si_pid to be the process id of the sender, so ->si_pid
should really be set to 'tgid'. This change does have following changes
in behavior:

	- When sending pdeath_signal on re-parent to a sub-thread, ->si_pid
	  cannot be used to identify the thread that did the re-parent since
	  it will now show the tgid instead of thread id.

	- A multi-threaded application that expects to find the specific
	  thread that encountered a SIGPIPE using the ->si_pid will now
	  break.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 kernel/signal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index d11e5f8..700d767 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -856,7 +856,7 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			q->info.si_signo = sig;
 			q->info.si_errno = 0;
 			q->info.si_code = SI_USER;
-			q->info.si_pid = task_pid_nr_ns(current,
+			q->info.si_pid = task_tgid_nr_ns(current,
 							task_active_pid_ns(t));
 			q->info.si_uid = current_uid();
 			break;
-- 
1.5.2.5

