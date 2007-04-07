Return-Path: <linux-kernel-owner+w=401wt.eu-S966289AbXDGS5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966289AbXDGS5q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 14:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966300AbXDGS5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 14:57:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44938 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966289AbXDGS5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 14:57:43 -0400
Date: Sat, 7 Apr 2007 20:57:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sched.c: Remove unused variable 'relative'
Message-ID: <20070407185736.GB31725@elte.hu>
References: <200704071759.l37Hx8b2030759@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704071759.l37Hx8b2030759@hera.kernel.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Committer:  Linus Torvalds <torvalds@woody.linux-foundation.org>
> CommitDate: Sat Apr 7 10:18:33 2007 -0700
> 
>     sched.c: Remove unused variable 'relative'
>     
>     Getting rid of the p->children printout in show_task() left behind an
>     unused variable.

grumble. The warning drowned in the usual flood of gcc warnings that a 
kernel compile produces. Btw., whenever i meet a gcc false positive that 
annoys me particularly, i just fix it up and flame the gcc folks in a 
comment. That patch has grown quite a bit and can be found below. (it's 
not complete by any means, and it should rather be done as an annotation 
combined with some unflattering CONFIG_HACK_AROUND_BROKEN_GCC_WARNINGS 
option that a sane compiler could unset and avoid the runtime cost of 
needless initializations.)

	Ingo

----------->
 arch/i386/kernel/cpu/mcheck/p4.c |    2 +-
 arch/i386/kernel/efi.c           |    2 +-
 fs/block_dev.c                   |    2 +-
 fs/isofs/namei.c                 |    2 +-
 fs/jffs2/erase.c                 |    2 +-
 fs/nfsd/nfsctl.c                 |    2 +-
 ipc/msg.c                        |    2 +-
 ipc/sem.c                        |    2 +-
 kernel/audit.c                   |    2 +-
 kernel/auditfilter.c             |    2 +-
 net/core/flow.c                  |    2 +-
 net/sunrpc/svc.c                 |    2 +-
 sound/core/control_compat.c      |    2 +-
 sound/pci/pcxhr/pcxhr.c          |    2 +-
 14 files changed, 14 insertions(+), 14 deletions(-)

Index: linux/arch/i386/kernel/cpu/mcheck/p4.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mcheck/p4.c
+++ linux/arch/i386/kernel/cpu/mcheck/p4.c
@@ -155,7 +155,7 @@ static fastcall void intel_machine_check
 	u32 alow, ahigh, high, low;
 	u32 mcgstl, mcgsth;
 	int i;
-	struct intel_mce_extended_msrs dbg;
+	struct intel_mce_extended_msrs dbg = { 0, } /* shut up gcc! */;
 
 	rdmsr (MSR_IA32_MCG_STATUS, mcgstl, mcgsth);
 	if (mcgstl & (1<<0))	/* Recoverable ? */
Index: linux/arch/i386/kernel/efi.c
===================================================================
--- linux.orig/arch/i386/kernel/efi.c
+++ linux/arch/i386/kernel/efi.c
@@ -278,7 +278,7 @@ void efi_memmap_walk(efi_freemem_callbac
 	struct range {
 		unsigned long start;
 		unsigned long end;
-	} prev, curr;
+	} prev = { } /* shut up gcc */ , curr = { } /* shut up gcc */ ;
 	efi_memory_desc_t *md;
 	unsigned long start, end;
 	void *p;
Index: linux/fs/block_dev.c
===================================================================
--- linux.orig/fs/block_dev.c
+++ linux/fs/block_dev.c
@@ -950,7 +950,7 @@ static int bd_claim_by_kobject(struct bl
 				struct kobject *kobj)
 {
 	int res;
-	struct bd_holder *bo, *found;
+	struct bd_holder *bo, *found = NULL /* shut up GCC */;
 
 	if (!kobj)
 		return -EINVAL;
Index: linux/fs/isofs/namei.c
===================================================================
--- linux.orig/fs/isofs/namei.c
+++ linux/fs/isofs/namei.c
@@ -158,7 +158,7 @@ isofs_find_entry(struct inode *dir, stru
 struct dentry *isofs_lookup(struct inode * dir, struct dentry * dentry, struct nameidata *nd)
 {
 	int found;
-	unsigned long block, offset;
+	unsigned long block = 0, offset = 0 /* avoid stupid gcc warning */;
 	struct inode *inode;
 	struct page *page;
 
Index: linux/fs/jffs2/erase.c
===================================================================
--- linux.orig/fs/jffs2/erase.c
+++ linux/fs/jffs2/erase.c
@@ -364,7 +364,7 @@ static void jffs2_mark_erased_block(stru
 {
 	size_t retlen;
 	int ret;
-	uint32_t bad_offset;
+	uint32_t bad_offset = 0 /* shut up gcc */;
 
 	switch (jffs2_block_check_erase(c, jeb, &bad_offset)) {
 	case -EAGAIN:	goto refile;
Index: linux/fs/nfsd/nfsctl.c
===================================================================
--- linux.orig/fs/nfsd/nfsctl.c
+++ linux/fs/nfsd/nfsctl.c
@@ -299,7 +299,7 @@ static ssize_t write_filehandle(struct f
 	 * qword quoting is used, so filehandle will be \x....
 	 */
 	char *dname, *path;
-	int maxsize;
+	int maxsize = 0;
 	char *mesg = buf;
 	int len;
 	struct auth_domain *dom;
Index: linux/ipc/msg.c
===================================================================
--- linux.orig/ipc/msg.c
+++ linux/ipc/msg.c
@@ -387,7 +387,7 @@ copy_msqid_from_user(struct msq_setbuf *
 asmlinkage long sys_msgctl(int msqid, int cmd, struct msqid_ds __user *buf)
 {
 	struct kern_ipc_perm *ipcp;
-	struct msq_setbuf setbuf;
+	struct msq_setbuf setbuf = { /* shut up gcc warning */ };
 	struct msg_queue *msq;
 	int err, version;
 	struct ipc_namespace *ns;
Index: linux/ipc/sem.c
===================================================================
--- linux.orig/ipc/sem.c
+++ linux/ipc/sem.c
@@ -859,7 +859,7 @@ static int semctl_down(struct ipc_namesp
 {
 	struct sem_array *sma;
 	int err;
-	struct sem_setbuf setbuf;
+	struct sem_setbuf setbuf = { /* shut up gcc warning */ };
 	struct kern_ipc_perm *ipcp;
 
 	if(cmd == IPC_SET) {
Index: linux/kernel/audit.c
===================================================================
--- linux.orig/kernel/audit.c
+++ linux/kernel/audit.c
@@ -969,7 +969,7 @@ struct audit_buffer *audit_log_start(str
 {
 	struct audit_buffer	*ab	= NULL;
 	struct timespec		t;
-	unsigned int		serial;
+	unsigned int		serial = 0 /* shut up gcc */;
 	int reserve;
 	unsigned long timeout_start = jiffies;
 
Index: linux/kernel/auditfilter.c
===================================================================
--- linux.orig/kernel/auditfilter.c
+++ linux/kernel/auditfilter.c
@@ -1168,7 +1168,7 @@ static inline int audit_add_rule(struct 
 	struct audit_entry *e;
 	struct audit_field *inode_f = entry->rule.inode_f;
 	struct audit_watch *watch = entry->rule.watch;
-	struct nameidata *ndp, *ndw;
+	struct nameidata *ndp = NULL, *ndw = NULL /* shut up gcc */;
 	int h, err, putnd_needed = 0;
 #ifdef CONFIG_AUDITSYSCALL
 	int dont_count = 0;
Index: linux/net/core/flow.c
===================================================================
--- linux.orig/net/core/flow.c
+++ linux/net/core/flow.c
@@ -172,7 +172,7 @@ static int flow_key_compare(struct flowi
 void *flow_cache_lookup(struct flowi *key, u16 family, u8 dir,
 			flow_resolve_t resolver)
 {
-	struct flow_cache_entry *fle, **head;
+	struct flow_cache_entry *fle, **head = NULL /* shut up GCC */;
 	unsigned int hash;
 	int cpu;
 
Index: linux/net/sunrpc/svc.c
===================================================================
--- linux.orig/net/sunrpc/svc.c
+++ linux/net/sunrpc/svc.c
@@ -547,7 +547,7 @@ __svc_create_thread(svc_thread_fn func, 
 	struct svc_rqst	*rqstp;
 	int		error = -ENOMEM;
 	int		have_oldmask = 0;
-	cpumask_t	oldmask;
+	cpumask_t	oldmask = CPU_MASK_NONE /* shut up GCC */;
 
 	rqstp = kzalloc(sizeof(*rqstp), GFP_KERNEL);
 	if (!rqstp)
Index: linux/sound/core/control_compat.c
===================================================================
--- linux.orig/sound/core/control_compat.c
+++ linux/sound/core/control_compat.c
@@ -219,7 +219,7 @@ static int copy_ctl_value_from_user(stru
 				    struct snd_ctl_elem_value32 __user *data32,
 				    int *typep, int *countp)
 {
-	int i, type, count, size;
+	int i, type, count = 0 /* shut up gcc warning */, size;
 	unsigned int indirect;
 
 	if (copy_from_user(&data->id, &data32->id, sizeof(data->id)))
Index: linux/sound/pci/pcxhr/pcxhr.c
===================================================================
--- linux.orig/sound/pci/pcxhr/pcxhr.c
+++ linux/sound/pci/pcxhr/pcxhr.c
@@ -637,7 +637,7 @@ static void pcxhr_trigger_tasklet(unsign
  */
 static int pcxhr_trigger(struct snd_pcm_substream *subs, int cmd)
 {
-	struct pcxhr_stream *stream;
+	struct pcxhr_stream *stream = NULL /* shut up gcc */;
 	struct list_head *pos;
 	struct snd_pcm_substream *s;
 	int i;
