Return-Path: <linux-kernel-owner+w=401wt.eu-S964968AbXJPTXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964968AbXJPTXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 15:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965484AbXJPTX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 15:23:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49318 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965483AbXJPTX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 15:23:27 -0400
Subject: [git pull] lockdep for v2.6.24
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.0.999.0710151813390.6887@woody.linux-foundation.org>
References: <1192469455.27435.87.camel@twins>
	 <alpine.LFD.0.999.0710151813390.6887@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 16 Oct 2007 21:23:23 +0200
Message-Id: <1192562603.27435.106.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please re-pull

  git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git v2.6.24-lockdep

[ I just commited the two new patches to the end of the branch you
  pulled before, and assumed git will be smart enough to not try and
  again merge the patches you pulled before ]

in order to receive:

Peter Zijlstra (2):
      lockdep: fixup the inode dir annotation
      lockdep: fix fault vs irq tracing

 arch/x86/mm/fault_32.c |   10 ++++++++++
 arch/x86/mm/fault_64.c |   10 ++++++++++
 fs/inode.c             |   18 +++++++++---------
 3 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index fcb38e7..c0cba93 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -308,6 +308,16 @@ fastcall void __kprobes do_page_fault(struct pt_regs *regs,
 	int write, si_code;
 	int fault;
 
+#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
+	/*
+	 * We can fault from pretty much anywhere, fix up the IRQ state.
+	 */
+	if (raw_irqs_disabled())
+		trace_hardirqs_off();
+	else
+		trace_hardirqs_on();
+#endif
+
 	/* get the address */
         address = read_cr2();
 
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index 54816ad..162bddd 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -311,6 +311,16 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
 	unsigned long flags;
 	siginfo_t info;
 
+#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
+	/*
+	 * We can fault from pretty much anywhere, fix up the IRQ state.
+	 */
+	if (raw_irqs_disabled())
+		trace_hardirqs_off();
+	else
+		trace_hardirqs_on();
+#endif
+
 	tsk = current;
 	mm = tsk->mm;
 	prefetchw(&mm->mmap_sem);
diff --git a/fs/inode.c b/fs/inode.c
index f97de0a..21dab18 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -568,16 +568,16 @@ EXPORT_SYMBOL(new_inode);
 void unlock_new_inode(struct inode *inode)
 {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct file_system_type *type = inode->i_sb->s_type;
-	/*
-	 * ensure nobody is actually holding i_mutex
-	 */
-	mutex_destroy(&inode->i_mutex);
-	mutex_init(&inode->i_mutex);
-	if (inode->i_mode & S_IFDIR)
+	if (inode->i_mode & S_IFDIR) {
+		struct file_system_type *type = inode->i_sb->s_type;
+
+		/*
+		 * ensure nobody is actually holding i_mutex
+		 */
+		mutex_destroy(&inode->i_mutex);
+		mutex_init(&inode->i_mutex);
 		lockdep_set_class(&inode->i_mutex, &type->i_mutex_dir_key);
-	else
-		lockdep_set_class(&inode->i_mutex, &type->i_mutex_key);
+	}
 #endif
 	/*
 	 * This is special!  We do not need the spinlock


