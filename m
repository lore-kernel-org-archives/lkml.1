Return-Path: <linux-kernel-owner+w=401wt.eu-S1751890AbZH2H1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbZH2H1s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 03:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbZH2H1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 03:27:47 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:45652 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbZH2H1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 03:27:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=HI+vcCD8IvmZg31TX9BT+NdkS2k+DVXJwYzuE/hKax0azu1rEvhnOezVBiipylp88D
         gGk9WAOiUsLcFCKhDOXiboVXQtnHdqt+6ef1nDdPxdq3QO3OnbEEW6mkz7BAHrRs6Jvo
         PWUTMCL1Zz6XWhsstN4ARylAukoSBQG6wglf0=
MIME-Version: 1.0
Date: Sat, 29 Aug 2009 16:20:22 +0900
Message-ID: <f76951a90908290020x5c4f8c8cjaba919e3f934fa85@mail.gmail.com>
Subject: [PATCH] proc: let task status file print utime and stime.
From: Tatsuhiro Aoshima <tatsu.pc@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tatsu.pc@gmail.com, yoshfuji@linux-ipv6.org,
       kosaki.motohiro@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tatsuhiro Aoshima <tatsu.pc@gmail.com>
Subject: [PATCH] proc: let task status file print utime and stime.

The task status file in proc file system did not contain
user-time and system-time. Thus, users could not get
those information of running task easily. I think
these values should be provived in human readable format.
By this patch, users can get stime and utime very easily.

Signed-off-by: Tatsuhiro Aoshima <tatsu.pc@gmail.com>
Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/proc/array.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 725a650..29afa68 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -162,6 +162,7 @@ static inline void task_state(struct seq_file *m,
struct pid_namespace *ns,
       struct fdtable *fdt = NULL;
       const struct cred *cred;
       pid_t ppid, tpid;
+       struct timeval utime, stime;

       rcu_read_lock();
       ppid = pid_alive(p) ?
@@ -173,6 +174,8 @@ static inline void task_state(struct seq_file *m,
struct pid_namespace *ns,
                       tpid = task_pid_nr_ns(tracer, ns);
       }
       cred = get_cred((struct cred *) __task_cred(p));
+       cputime_to_timeval(task_utime(p), &utime);
+       cputime_to_timeval(task_stime(p), &stime);
       seq_printf(m,
               "State:\t%s\n"
               "Tgid:\t%d\n"
@@ -180,13 +183,17 @@ static inline void task_state(struct seq_file
*m, struct pid_namespace *ns,
               "PPid:\t%d\n"
               "TracerPid:\t%d\n"
               "Uid:\t%d\t%d\t%d\t%d\n"
-               "Gid:\t%d\t%d\t%d\t%d\n",
+               "Gid:\t%d\t%d\t%d\t%d\n"
+               "Utime:\t%lu.%06lu\n"
+               "Stime:\t%lu.%06lu\n",
               get_task_state(p),
               task_tgid_nr_ns(p, ns),
               pid_nr_ns(pid, ns),
               ppid, tpid,
               cred->uid, cred->euid, cred->suid, cred->fsuid,
-               cred->gid, cred->egid, cred->sgid, cred->fsgid);
+               cred->gid, cred->egid, cred->sgid, cred->fsgid,
+               (unsigned long) utime.tv_sec, (unsigned long) utime.tv_usec,
+               (unsigned long) stime.tv_sec, (unsigned long) stime.tv_usec);

       task_lock(p);
       if (p->files)
