Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbZDWXJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbZDWXJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 19:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756494AbZDWXIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 19:08:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50432 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756281AbZDWXIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 19:08:53 -0400
Date: Fri, 24 Apr 2009 01:02:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: [PATCH 2/2] check_unsafe_exec: s/lock_task_sighand/rcu_read_lock/
Message-ID: <20090423230245.GB31302@redhat.com>
References: <Pine.LNX.4.64.0904010106310.16500@blonde.anvils> <20090401023849.GW28946@ZenIV.linux.org.uk> <20090401030339.GX28946@ZenIV.linux.org.uk> <20090406153127.GA21220@redhat.com> <Pine.LNX.4.64.0904191710320.9099@blonde.anvils> <20090421161006.GC5402@redhat.com> <alpine.LFD.2.00.0904210924270.2199@localhost.localdomain> <20090421171530.GA12014@redhat.com> <alpine.LFD.2.00.0904211032191.2199@localhost.localdomain> <Pine.LNX.4.64.0904212031120.10256@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904212031120.10256@blonde.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write_lock(&current->fs->lock) guarantees we can't wrongly miss
LSM_UNSAFE_SHARE, this is what we care about. Use rcu_read_lock()
instead of ->siglock to iterate over the sub-threads. We must see
all CLONE_THREAD|CLONE_FS threads which didn't pass exit_fs(), it
takes fs->lock too.

With or without this patch we can miss the freshly cloned thread
and set LSM_UNSAFE_SHARE, we don't care.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- PTRACE/fs/exec.c~2_NO_SIGLOCK	2009-04-24 00:01:53.000000000 +0200
+++ PTRACE/fs/exec.c	2009-04-24 00:36:22.000000000 +0200
@@ -1060,7 +1060,6 @@ EXPORT_SYMBOL(install_exec_creds);
 int check_unsafe_exec(struct linux_binprm *bprm)
 {
 	struct task_struct *p = current, *t;
-	unsigned long flags;
 	unsigned n_fs;
 	int res = 0;
 
@@ -1068,11 +1067,12 @@ int check_unsafe_exec(struct linux_binpr
 
 	n_fs = 1;
 	write_lock(&p->fs->lock);
-	lock_task_sighand(p, &flags);
+	rcu_read_lock();
 	for (t = next_thread(p); t != p; t = next_thread(t)) {
 		if (t->fs == p->fs)
 			n_fs++;
 	}
+	rcu_read_lock();
 
 	if (p->fs->users > n_fs) {
 		bprm->unsafe |= LSM_UNSAFE_SHARE;
@@ -1083,8 +1083,6 @@ int check_unsafe_exec(struct linux_binpr
 			res = 1;
 		}
 	}
-
-	unlock_task_sighand(p, &flags);
 	write_unlock(&p->fs->lock);
 
 	return res;

