Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbZJDCYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbZJDCYS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 22:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756829AbZJDCYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 22:24:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756828AbZJDCYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 22:24:17 -0400
Date: Sun, 4 Oct 2009 04:19:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Daniel Lezcano <dlezcano@fr.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] signals: SEND_SIG_NOINFO should be considered as
	SI_FROMUSER()
Message-ID: <20091004021918.GB21006@redhat.com>
References: <4AC608BE.9020805@fr.ibm.com> <20091003171029.GA30442@us.ibm.com> <20091004021844.GA21006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091004021844.GA21006@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No changes in compiled code. The patch adds the new helper, si_fromuser()
and changes check_kill_permission() to use this helper.

The real effect of this patch is that from now we "officially" consider
SEND_SIG_NOINFO signal as "from user-space" signals. This is already true
if we look at the code which uses SEND_SIG_NOINFO, except __send_signal()
has another opinion - see the next patch.

The naming of these special SEND_SIG_XXX siginfo's is really bad imho.
>From __send_signal()'s pov they mean

	SEND_SIG_NOINFO		from user
	SEND_SIG_PRIV		from kernel
	SEND_SIG_FORCED		no info

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h |    5 -----
 kernel/signal.c       |   16 +++++++++++++---
 2 files changed, 13 insertions(+), 8 deletions(-)

--- TTT_32/include/linux/sched.h~FU_1_HELPER	2009-09-24 21:38:54.000000000 +0200
+++ TTT_32/include/linux/sched.h	2009-10-04 02:21:49.000000000 +0200
@@ -2081,11 +2081,6 @@ static inline int kill_cad_pid(int sig, 
 #define SEND_SIG_PRIV	((struct siginfo *) 1)
 #define SEND_SIG_FORCED	((struct siginfo *) 2)
 
-static inline int is_si_special(const struct siginfo *info)
-{
-	return info <= SEND_SIG_FORCED;
-}
-
 /* True if we are on the alternate signal stack.  */
 
 static inline int on_sig_stack(unsigned long sp)
--- TTT_32/kernel/signal.c~FU_1_HELPER	2009-09-24 21:38:54.000000000 +0200
+++ TTT_32/kernel/signal.c	2009-10-04 02:21:55.000000000 +0200
@@ -584,6 +584,17 @@ static int rm_from_queue(unsigned long m
 	return 1;
 }
 
+static inline int is_si_special(const struct siginfo *info)
+{
+	return info <= SEND_SIG_FORCED;
+}
+
+static inline bool si_fromuser(const struct siginfo *info)
+{
+	return info == SEND_SIG_NOINFO ||
+		(!is_si_special(info) && SI_FROMUSER(info));
+}
+
 /*
  * Bad permissions for sending the signal
  * - the caller must hold at least the RCU read lock
@@ -598,7 +609,7 @@ static int check_kill_permission(int sig
 	if (!valid_signal(sig))
 		return -EINVAL;
 
-	if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
+	if (!si_fromuser(info))
 		return 0;
 
 	error = audit_signal_info(sig, t); /* Let audit system see the signal */
@@ -1156,8 +1167,7 @@ int kill_pid_info_as_uid(int sig, struct
 		goto out_unlock;
 	}
 	pcred = __task_cred(p);
-	if ((info == SEND_SIG_NOINFO ||
-	     (!is_si_special(info) && SI_FROMUSER(info))) &&
+	if (si_fromuser(info) &&
 	    euid != pcred->suid && euid != pcred->uid &&
 	    uid  != pcred->suid && uid  != pcred->uid) {
 		ret = -EPERM;

