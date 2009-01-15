Return-Path: <linux-kernel-owner+w=401wt.eu-S935582AbZAOWdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935582AbZAOWdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933925AbZAOWDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:03:31 -0500
Received: from kroah.org ([198.145.64.141]:38796 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933701AbZAOWD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:03:29 -0500
Date: Thu, 15 Jan 2009 14:01:00 -0800
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
Subject: [patch 55/85] [PATCH 35/44] [CVE-2009-0029] System call wrappers
	part 25
Message-ID: <20090115220100.GD17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0035--CVE-2009-0029-System-call-wrappers-part-25.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit d5460c9974a321a194aded4a8c4daaac68ea8171 upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 ipc/mqueue.c |    6 +++---
 ipc/sem.c    |    9 +++++----
 ipc/shm.c    |    8 ++++----
 3 files changed, 12 insertions(+), 11 deletions(-)

--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -647,8 +647,8 @@ static int oflag2acc[O_ACCMODE] = { MAY_
 	return dentry_open(dentry, mqueue_mnt, oflag);
 }
 
-asmlinkage long sys_mq_open(const char __user *u_name, int oflag, mode_t mode,
-				struct mq_attr __user *u_attr)
+SYSCALL_DEFINE4(mq_open, const char __user *, u_name, int, oflag, mode_t, mode,
+		struct mq_attr __user *, u_attr)
 {
 	struct dentry *dentry;
 	struct file *filp;
@@ -715,7 +715,7 @@ out_putname:
 	return fd;
 }
 
-asmlinkage long sys_mq_unlink(const char __user *u_name)
+SYSCALL_DEFINE1(mq_unlink, const char __user *, u_name)
 {
 	int err;
 	char *name;
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -308,7 +308,7 @@ static inline int sem_more_checks(struct
 	return 0;
 }
 
-asmlinkage long sys_semget(key_t key, int nsems, int semflg)
+SYSCALL_DEFINE3(semget, key_t, key, int, nsems, int, semflg)
 {
 	struct ipc_namespace *ns;
 	struct ipc_ops sem_ops;
@@ -1055,8 +1055,8 @@ out:
 	return un;
 }
 
-asmlinkage long sys_semtimedop(int semid, struct sembuf __user *tsops,
-			unsigned nsops, const struct timespec __user *timeout)
+SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
+		unsigned, nsops, const struct timespec __user *, timeout)
 {
 	int error = -EINVAL;
 	struct sem_array *sma;
@@ -1233,7 +1233,8 @@ out_free:
 	return error;
 }
 
-asmlinkage long sys_semop (int semid, struct sembuf __user *tsops, unsigned nsops)
+SYSCALL_DEFINE3(semop, int, semid, struct sembuf __user *, tsops,
+		unsigned, nsops)
 {
 	return sys_semtimedop(semid, tsops, nsops, NULL);
 }
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -440,7 +440,7 @@ static inline int shm_more_checks(struct
 	return 0;
 }
 
-asmlinkage long sys_shmget (key_t key, size_t size, int shmflg)
+SYSCALL_DEFINE3(shmget, key_t, key, size_t, size, int, shmflg)
 {
 	struct ipc_namespace *ns;
 	struct ipc_ops shm_ops;
@@ -621,7 +621,7 @@ out_up:
 	return err;
 }
 
-asmlinkage long sys_shmctl(int shmid, int cmd, struct shmid_ds __user *buf)
+SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
 {
 	struct shmid_kernel *shp;
 	int err, version;
@@ -941,7 +941,7 @@ out_put_dentry:
 	goto out_nattch;
 }
 
-asmlinkage long sys_shmat(int shmid, char __user *shmaddr, int shmflg)
+SYSCALL_DEFINE3(shmat, int, shmid, char __user *, shmaddr, int, shmflg)
 {
 	unsigned long ret;
 	long err;
@@ -957,7 +957,7 @@ asmlinkage long sys_shmat(int shmid, cha
  * detach and kill segment if marked destroyed.
  * The work is done in shm_close.
  */
-asmlinkage long sys_shmdt(char __user *shmaddr)
+SYSCALL_DEFINE1(shmdt, char __user *, shmaddr)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *next;

