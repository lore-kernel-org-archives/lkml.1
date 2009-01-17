Return-Path: <linux-kernel-owner+w=401wt.eu-S932703AbZAQUlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703AbZAQUlq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 15:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764391AbZAQUlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 15:41:12 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48960 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932549AbZAQUlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 15:41:09 -0500
Date: Sat, 17 Jan 2009 12:37:53 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       bastian@waldi.eu.org
Cc: daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 7/7][v7] proc: Show SIG_DFL signals to init as "ignored"
	signals
Message-ID: <20090117203753.GH11825@us.ibm.com>
References: <20090117202638.GA11825@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117202638.GA11825@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Sat, 17 Jan 2009 09:26:26 -0800
Subject: [PATCH 7/7][v7] proc: Show SIG_DFL signals to init as "ignored" signals

Init processes ignore SIG_DFL signals unless they are from an ancestor
namespace.  Ensure /proc/pid/status correcly reports these signals.

Values for "normal" /bin/bash from /proc/pid/status:

	SigIgn: 0000000000384004
	SigCgt: 000000004b813efb

	Signals 9, 16, 19 etc are neither ignored nor caught

/bin/bash as container-init, Status viewed from outside container:

	SigIgn: 0000000000384004
	SigCgt: 000000004b813efb

	(same as 'normal')

/bin/bash as container-init, Status viewed from inside container:

	SigIgn: ffffffffb47ec104
	SigCgt: 000000004b813efb

	All "uncaught" signals, including SIGKILL(9) SIGSTOP(19) are ignored.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 fs/proc/array.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 7e4877d..16e39db 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -228,15 +228,31 @@ static void render_sigset_t(struct seq_file *m, const char *header,
 	seq_printf(m, "\n");
 }
 
+static int is_unkillable(struct task_struct *p)
+{
+	if (!(p->signal->flags & SIGNAL_UNKILLABLE))
+		return 0;
+
+	/* If caller is an ancestor, we are not unkillable */
+	if (task_pid_nr_ns(current, task_active_pid_ns(p)) <= 0)
+		return 0;
+
+	return 1;
+}
+
 static void collect_sigign_sigcatch(struct task_struct *p, sigset_t *ign,
 				    sigset_t *catch)
 {
 	struct k_sigaction *k;
 	int i;
+	int unkillable;
+	
+	unkillable = is_unkillable(p);
 
 	k = p->sighand->action;
 	for (i = 1; i <= _NSIG; ++i, ++k) {
-		if (k->sa.sa_handler == SIG_IGN)
+		if (k->sa.sa_handler == SIG_IGN ||
+				(k->sa.sa_handler == SIG_DFL && unkillable))
 			sigaddset(ign, i);
 		else if (k->sa.sa_handler != SIG_DFL)
 			sigaddset(catch, i);
-- 
1.5.2.5

