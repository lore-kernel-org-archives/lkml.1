Return-Path: <linux-kernel-owner+w=401wt.eu-S1763270AbZEFWNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763270AbZEFWNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760657AbZEFVzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:55:04 -0400
Received: from kroah.org ([198.145.64.141]:57318 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761525AbZEFVy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:57 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:48:01 2009
Message-Id: <20090506214801.282196228@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:46:11 -0700
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
       alan@lxorguk.ukuu.org.uk, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>, Hugh Dickins <hugh@veritas.com>
Subject: [patch 43/58] check_unsafe_exec: s/lock_task_sighand/rcu_read_lock/
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=check_unsafe_exec-s-lock_task_sighand-rcu_read_lock.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 437f7fdb607f32b737e4da9f14bebcfdac2c90c3 upstream.

write_lock(&current->fs->lock) guarantees we can't wrongly miss
LSM_UNSAFE_SHARE, this is what we care about. Use rcu_read_lock()
instead of ->siglock to iterate over the sub-threads. We must see
all CLONE_THREAD|CLONE_FS threads which didn't pass exit_fs(), it
takes fs->lock too.

With or without this patch we can miss the freshly cloned thread
and set LSM_UNSAFE_SHARE, we don't care.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
[ Fixed lock/unlock typo  - Hugh ]
Acked-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/exec.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1052,7 +1052,6 @@ EXPORT_SYMBOL(install_exec_creds);
 int check_unsafe_exec(struct linux_binprm *bprm)
 {
 	struct task_struct *p = current, *t;
-	unsigned long flags;
 	unsigned n_fs;
 	int res = 0;
 
@@ -1060,11 +1059,12 @@ int check_unsafe_exec(struct linux_binpr
 
 	n_fs = 1;
 	write_lock(&p->fs->lock);
-	lock_task_sighand(p, &flags);
+	rcu_read_lock();
 	for (t = next_thread(p); t != p; t = next_thread(t)) {
 		if (t->fs == p->fs)
 			n_fs++;
 	}
+	rcu_read_unlock();
 
 	if (p->fs->users > n_fs) {
 		bprm->unsafe |= LSM_UNSAFE_SHARE;
@@ -1075,8 +1075,6 @@ int check_unsafe_exec(struct linux_binpr
 			res = 1;
 		}
 	}
-
-	unlock_task_sighand(p, &flags);
 	write_unlock(&p->fs->lock);
 
 	return res;


