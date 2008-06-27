Return-Path: <linux-kernel-owner+w=401wt.eu-S1761785AbYF0Qds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761785AbYF0Qds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 12:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbYF0Qdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 12:33:40 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50743 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbYF0Qdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 12:33:39 -0400
Date: Fri, 27 Jun 2008 11:33:36 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, serue@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CGroups: misc cleanups to write_string patchset
Message-ID: <20080627163336.GA30727@us.ibm.com>
References: <4864443E.6000607@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4864443E.6000607@google.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Menage (menage@google.com):
> CGroups: misc cleanups to write_string patchset
>
> This patch contains cleanups suggested by reviewers for the recent
> write_string() patchset:
>
> - pair cgroup_lock_live_group() with cgroup_unlock() in cgroup.c for
>  clarity, rather than directly unlocking cgroup_mutex.
>
> - make the return type of cgroup_lock_live_group() a bool
>
> - use a #define'd constant for the local buffer size in read/write functions
>
> Signed-off-by: Paul Menage <menage@google.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

The use of cgroup_unlock() really is much more readable.

thanks,
-serge

>
> ---
> include/linux/cgroup.h |    4 ++--
> kernel/cgroup.c        |   21 ++++++++++++---------
> 2 files changed, 14 insertions(+), 11 deletions(-)
>
> Index: cws2-2.6.26-rc5-mm3/include/linux/cgroup.h
> ===================================================================
> --- cws2-2.6.26-rc5-mm3.orig/include/linux/cgroup.h
> +++ cws2-2.6.26-rc5-mm3/include/linux/cgroup.h
> @@ -21,11 +21,13 @@
> struct cgroupfs_root;
> struct cgroup_subsys;
> struct inode;
> +struct cgroup;
>
> extern int cgroup_init_early(void);
> extern int cgroup_init(void);
> extern void cgroup_init_smp(void);
> extern void cgroup_lock(void);
> +extern bool cgroup_lock_live_group(struct cgroup *cgrp);
> extern void cgroup_unlock(void);
> extern void cgroup_fork(struct task_struct *p);
> extern void cgroup_fork_callbacks(struct task_struct *p);
> @@ -295,8 +297,6 @@ int cgroup_add_files(struct cgroup *cgrp
>
> int cgroup_is_removed(const struct cgroup *cgrp);
>
> -int cgroup_lock_live_group(struct cgroup *cgrp);
> -
> int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);
>
> int cgroup_task_count(const struct cgroup *cgrp);
> Index: cws2-2.6.26-rc5-mm3/kernel/cgroup.c
> ===================================================================
> --- cws2-2.6.26-rc5-mm3.orig/kernel/cgroup.c
> +++ cws2-2.6.26-rc5-mm3/kernel/cgroup.c
> @@ -1331,10 +1331,10 @@ enum cgroup_filetype {
>  * cgroup_lock_live_group - take cgroup_mutex and check that cgrp is alive.
>  * @cgrp: the cgroup to be checked for liveness
>  *
> - * Returns true (with lock held) on success, or false (with no lock
> - * held) on failure.
> + * On success, returns true; the lock should be later released with
> + * cgroup_unlock(). On failure returns false with no lock held.
>  */
> -int cgroup_lock_live_group(struct cgroup *cgrp)
> +bool cgroup_lock_live_group(struct cgroup *cgrp)
> {
> 	mutex_lock(&cgroup_mutex);
> 	if (cgroup_is_removed(cgrp)) {
> @@ -1351,7 +1351,7 @@ static int cgroup_release_agent_write(st
> 	if (!cgroup_lock_live_group(cgrp))
> 		return -ENODEV;
> 	strcpy(cgrp->root->release_agent_path, buffer);
> -	mutex_unlock(&cgroup_mutex);
> +	cgroup_unlock();
> 	return 0;
> }
>
> @@ -1362,16 +1362,19 @@ static int cgroup_release_agent_show(str
> 		return -ENODEV;
> 	seq_puts(seq, cgrp->root->release_agent_path);
> 	seq_putc(seq, '\n');
> -	mutex_unlock(&cgroup_mutex);
> +	cgroup_unlock();
> 	return 0;
> }
>
> +/* A buffer size big enough for numbers or short strings */
> +#define CGROUP_LOCAL_BUFFER_SIZE 64 +
> static ssize_t cgroup_write_X64(struct cgroup *cgrp, struct cftype *cft,
> 				struct file *file,
> 				const char __user *userbuf,
> 				size_t nbytes, loff_t *unused_ppos)
> {
> -	char buffer[64];
> +	char buffer[CGROUP_LOCAL_BUFFER_SIZE];
> 	int retval = 0;
> 	char *end;
>
> @@ -1405,7 +1408,7 @@ static ssize_t cgroup_write_string(struc
> 				   const char __user *userbuf,
> 				   size_t nbytes, loff_t *unused_ppos)
> {
> -	char local_buffer[64];
> +	char local_buffer[CGROUP_LOCAL_BUFFER_SIZE];
> 	int retval = 0;
> 	size_t max_bytes = cft->max_write_len;
> 	char *buffer = local_buffer;
> @@ -1459,7 +1462,7 @@ static ssize_t cgroup_read_u64(struct cg
> 			       char __user *buf, size_t nbytes,
> 			       loff_t *ppos)
> {
> -	char tmp[64];
> +	char tmp[CGROUP_LOCAL_BUFFER_SIZE];
> 	u64 val = cft->read_u64(cgrp, cft);
> 	int len = sprintf(tmp, "%llu\n", (unsigned long long) val);
>
> @@ -1471,7 +1474,7 @@ static ssize_t cgroup_read_s64(struct cg
> 			       char __user *buf, size_t nbytes,
> 			       loff_t *ppos)
> {
> -	char tmp[64];
> +	char tmp[CGROUP_LOCAL_BUFFER_SIZE];
> 	s64 val = cft->read_s64(cgrp, cft);
> 	int len = sprintf(tmp, "%lld\n", (long long) val);
