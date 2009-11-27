Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbZK0XIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbZK0XIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 18:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbZK0XIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 18:08:14 -0500
Received: from server1.wserver.cz ([82.113.45.157]:60484 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbZK0XGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 18:06:07 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org, oleg@redhat.com,
       James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 20/27] FS: use helpers for rlimits
Date: Sat, 28 Nov 2009 00:06:00 +0100
Message-Id: <1259363167-9347-20-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
References: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure compiler won't do weird things with limits. E.g. fetching
them twice may return 2 different values after writable limits are
implemented.

I.e. either use newly added rlimit helpers or ACCESS_ONCE if not
applicable.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: James Morris <jmorris@namei.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/attr.c        |    2 +-
 fs/binfmt_aout.c |    2 +-
 fs/binfmt_flat.c |    2 +-
 fs/exec.c        |    8 ++++----
 fs/fcntl.c       |    2 +-
 fs/file.c        |    2 +-
 fs/proc/array.c  |    4 ++--
 fs/select.c      |    2 +-
 8 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 96d394b..3554042 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -82,7 +82,7 @@ int inode_newsize_ok(const struct inode *inode, loff_t offset)
 	if (inode->i_size < offset) {
 		unsigned long limit;
 
-		limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
+		limit = rlim_get_cur(RLIMIT_FSIZE);
 		if (limit != RLIM_INFINITY && offset > limit)
 			goto out_sig;
 		if (offset > inode->i_sb->s_maxbytes)
diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index b639dcf..dc3f316 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -246,7 +246,7 @@ static int load_aout_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 	 * size limits imposed on them by creating programs with large
 	 * arrays in the data or bss.
 	 */
-	rlim = current->signal->rlim[RLIMIT_DATA].rlim_cur;
+	rlim = rlim_get_cur(RLIMIT_DATA);
 	if (rlim >= RLIM_INFINITY)
 		rlim = ~0;
 	if (ex.a_data + ex.a_bss > rlim)
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index a279665..0161f3c 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -501,7 +501,7 @@ static int load_flat_file(struct linux_binprm * bprm,
 	 * size limits imposed on them by creating programs with large
 	 * arrays in the data or bss.
 	 */
-	rlim = current->signal->rlim[RLIMIT_DATA].rlim_cur;
+	rlim = rlim_get_cur(RLIMIT_DATA);
 	if (rlim >= RLIM_INFINITY)
 		rlim = ~0;
 	if (data_len + bss_len > rlim) {
diff --git a/fs/exec.c b/fs/exec.c
index ba112bd..08dd798 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -196,7 +196,7 @@ static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
 		 *    to work from.
 		 */
 		rlim = current->signal->rlim;
-		if (size > rlim[RLIMIT_STACK].rlim_cur / 4) {
+		if (size > ACCESS_ONCE(rlim[RLIMIT_STACK].rlim_cur) / 4) {
 			put_page(page);
 			return NULL;
 		}
@@ -575,7 +575,7 @@ int setup_arg_pages(struct linux_binprm *bprm,
 
 #ifdef CONFIG_STACK_GROWSUP
 	/* Limit stack size to 1GB */
-	stack_base = current->signal->rlim[RLIMIT_STACK].rlim_max;
+	stack_base = rlim_get_max(RLIMIT_STACK);
 	if (stack_base > (1 << 30))
 		stack_base = 1 << 30;
 
@@ -1503,7 +1503,7 @@ static int format_corename(char *corename, long signr)
 			/* core limit size */
 			case 'c':
 				rc = snprintf(out_ptr, out_end - out_ptr,
-					      "%lu", current->signal->rlim[RLIMIT_CORE].rlim_cur);
+					"%lu", rlim_get_cur(RLIMIT_CORE));
 				if (rc > out_end - out_ptr)
 					goto out;
 				out_ptr += rc;
@@ -1762,7 +1762,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	int retval = 0;
 	int flag = 0;
 	int ispipe = 0;
-	unsigned long core_limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
+	unsigned long core_limit = rlim_get_cur(RLIMIT_CORE);
 	char **helper_argv = NULL;
 	int helper_argc = 0;
 	int dump_count = 0;
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 2cf93ec..8dd4b4f 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -344,7 +344,7 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 	switch (cmd) {
 	case F_DUPFD:
 	case F_DUPFD_CLOEXEC:
-		if (arg >= current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
+		if (arg >= rlim_get_cur(RLIMIT_NOFILE))
 			break;
 		err = alloc_fd(arg, cmd == F_DUPFD_CLOEXEC ? O_CLOEXEC : 0);
 		if (err >= 0) {
diff --git a/fs/file.c b/fs/file.c
index 87e1290..0a472ff 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -257,7 +257,7 @@ int expand_files(struct files_struct *files, int nr)
 	 * N.B. For clone tasks sharing a files structure, this test
 	 * will limit the total number of files that can be opened.
 	 */
-	if (nr >= current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
+	if (nr >= rlim_get_cur(RLIMIT_NOFILE))
 		return -EMFILE;
 
 	/* Do we need to expand? */
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 822c2d5..54ba2d6 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -266,7 +266,7 @@ static inline void task_sig(struct seq_file *m, struct task_struct *p)
 		collect_sigign_sigcatch(p, &ignored, &caught);
 		num_threads = atomic_read(&p->signal->count);
 		qsize = atomic_read(&__task_cred(p)->user->sigpending);
-		qlim = p->signal->rlim[RLIMIT_SIGPENDING].rlim_cur;
+		qlim = task_rlim_get_cur(p, RLIMIT_SIGPENDING);
 		unlock_task_sighand(p, &flags);
 	}
 
@@ -491,7 +491,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		cutime = sig->cutime;
 		cstime = sig->cstime;
 		cgtime = sig->cgtime;
-		rsslim = sig->rlim[RLIMIT_RSS].rlim_cur;
+		rsslim = ACCESS_ONCE(sig->rlim[RLIMIT_RSS].rlim_cur);
 
 		/* add up live thread stats at the group level */
 		if (whole) {
diff --git a/fs/select.c b/fs/select.c
index fd38ce2..ab34a88 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -821,7 +821,7 @@ int do_sys_poll(struct pollfd __user *ufds, unsigned int nfds,
  	struct poll_list *walk = head;
  	unsigned long todo = nfds;
 
-	if (nfds > current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
+	if (nfds > rlim_get_cur(RLIMIT_NOFILE))
 		return -EINVAL;
 
 	len = min_t(unsigned int, nfds, N_STACK_PPS);
-- 
1.6.5.3

