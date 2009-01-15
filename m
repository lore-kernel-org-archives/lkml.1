Return-Path: <linux-kernel-owner+w=401wt.eu-S934887AbZAOWci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934887AbZAOWci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933702AbZAOWDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:03:30 -0500
Received: from kroah.org ([198.145.64.141]:38780 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761282AbZAOWD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:03:28 -0500
Date: Thu, 15 Jan 2009 14:00:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 54/85] [PATCH 34/44] [CVE-2009-0029] System call wrappers
	part 24
Message-ID: <20090115220058.GC17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0034--CVE-2009-0029-System-call-wrappers-part-24.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit e48fbb699f82ef1e80bd7126046394d2dc9ca7e6 upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 ipc/msg.c    |   12 ++++++------
 kernel/sys.c |   13 +++++++------
 2 files changed, 13 insertions(+), 12 deletions(-)

--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -309,7 +309,7 @@ static inline int msg_security(struct ke
 	return security_msg_queue_associate(msq, msgflg);
 }
 
-asmlinkage long sys_msgget(key_t key, int msgflg)
+SYSCALL_DEFINE2(msgget, key_t, key, int, msgflg)
 {
 	struct ipc_namespace *ns;
 	struct ipc_ops msg_ops;
@@ -466,7 +466,7 @@ out_up:
 	return err;
 }
 
-asmlinkage long sys_msgctl(int msqid, int cmd, struct msqid_ds __user *buf)
+SYSCALL_DEFINE3(msgctl, int, msqid, int, cmd, struct msqid_ds __user *, buf)
 {
 	struct msg_queue *msq;
 	int err, version;
@@ -723,8 +723,8 @@ out_free:
 	return err;
 }
 
-asmlinkage long
-sys_msgsnd(int msqid, struct msgbuf __user *msgp, size_t msgsz, int msgflg)
+SYSCALL_DEFINE4(msgsnd, int, msqid, struct msgbuf __user *, msgp, size_t, msgsz,
+		int, msgflg)
 {
 	long mtype;
 
@@ -904,8 +904,8 @@ out_unlock:
 	return msgsz;
 }
 
-asmlinkage long sys_msgrcv(int msqid, struct msgbuf __user *msgp, size_t msgsz,
-			   long msgtyp, int msgflg)
+SYSCALL_DEFINE5(msgrcv, int, msqid, struct msgbuf __user *, msgp, size_t, msgsz,
+		long, msgtyp, int, msgflg)
 {
 	long err, mtype;
 
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1329,7 +1329,7 @@ EXPORT_SYMBOL(in_egroup_p);
 
 DECLARE_RWSEM(uts_sem);
 
-asmlinkage long sys_newuname(struct new_utsname __user * name)
+SYSCALL_DEFINE1(newuname, struct new_utsname __user *, name)
 {
 	int errno = 0;
 
@@ -1406,7 +1406,7 @@ SYSCALL_DEFINE2(setdomainname, char __us
 	return errno;
 }
 
-asmlinkage long sys_getrlimit(unsigned int resource, struct rlimit __user *rlim)
+SYSCALL_DEFINE2(getrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 {
 	if (resource >= RLIM_NLIMITS)
 		return -EINVAL;
@@ -1425,7 +1425,8 @@ asmlinkage long sys_getrlimit(unsigned i
  *	Back compatibility for getrlimit. Needed for some apps.
  */
  
-asmlinkage long sys_old_getrlimit(unsigned int resource, struct rlimit __user *rlim)
+SYSCALL_DEFINE2(old_getrlimit, unsigned int, resource,
+		struct rlimit __user *, rlim)
 {
 	struct rlimit x;
 	if (resource >= RLIM_NLIMITS)
@@ -1443,7 +1444,7 @@ asmlinkage long sys_old_getrlimit(unsign
 
 #endif
 
-asmlinkage long sys_setrlimit(unsigned int resource, struct rlimit __user *rlim)
+SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 {
 	struct rlimit new_rlim, *old_rlim;
 	unsigned long it_prof_secs;
@@ -1619,7 +1620,7 @@ int getrusage(struct task_struct *p, int
 	return copy_to_user(ru, &r, sizeof(r)) ? -EFAULT : 0;
 }
 
-asmlinkage long sys_getrusage(int who, struct rusage __user *ru)
+SYSCALL_DEFINE2(getrusage, int, who, struct rusage __user *, ru)
 {
 	if (who != RUSAGE_SELF && who != RUSAGE_CHILDREN &&
 	    who != RUSAGE_THREAD)
@@ -1627,7 +1628,7 @@ asmlinkage long sys_getrusage(int who, s
 	return getrusage(current, who, ru);
 }
 
-asmlinkage long sys_umask(int mask)
+SYSCALL_DEFINE1(umask, int, mask)
 {
 	mask = xchg(&current->fs->umask, mask & S_IRWXUGO);
 	return mask;

