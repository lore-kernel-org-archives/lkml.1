Return-Path: <linux-kernel-owner+w=401wt.eu-S1759092AbZA3BQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759092AbZA3BQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 20:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbZA3BQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 20:16:24 -0500
Received: from ozlabs.org ([203.10.76.45]:40078 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbZA3BQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 20:16:23 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] lguest fixes
Date: Fri, 30 Jan 2009 11:46:14 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, Atsushi SAKAI <sakaia@jp.fujitsu.com>,
       Tim Ansell <mithro@mithis.com>, Mark Wallis <mwallis@serialmonkey.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901301146.15493.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 18e352e4a73465349711a9324767e1b2453383e2:
  Linus Torvalds (1):
        Linux 2.6.29-rc3

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Atsushi SAKAI (1):
      lguest: typos fix

Mark Wallis (1):
      lguest: Fix a memory leak with the lg object during launcher close

Tim 'mithro' Ansell (1):
      lguest: disable the FORTIFY for lguest.

 Documentation/lguest/Makefile |    2 +-
 arch/x86/lguest/boot.c        |    4 ++--
 drivers/lguest/core.c         |    2 +-
 drivers/lguest/lguest_user.c  |    5 ++---
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/Documentation/lguest/Makefile b/Documentation/lguest/Makefile
index 725eef8..1f4f9e8 100644
--- a/Documentation/lguest/Makefile
+++ b/Documentation/lguest/Makefile
@@ -1,5 +1,5 @@
 # This creates the demonstration utility "lguest" which runs a Linux guest.
-CFLAGS:=-Wall -Wmissing-declarations -Wmissing-prototypes -O3 -I../../include -I../../arch/x86/include
+CFLAGS:=-Wall -Wmissing-declarations -Wmissing-prototypes -O3 -I../../include -I../../arch/x86/include -U_FORTIFY_SOURCE
 LDLIBS:=-lz
 
 all: lguest
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index a7ed208..92f1c6f 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -931,7 +931,7 @@ static void lguest_restart(char *reason)
  * that we can fit comfortably.
  *
  * First we need assembly templates of each of the patchable Guest operations,
- * and these are in lguest_asm.S. */
+ * and these are in i386_head.S. */
 
 /*G:060 We construct a table from the assembler templates: */
 static const struct lguest_insns
@@ -1093,7 +1093,7 @@ __init void lguest_init(void)
 	acpi_ht = 0;
 #endif
 
-	/* We set the perferred console to "hvc".  This is the "hypervisor
+	/* We set the preferred console to "hvc".  This is the "hypervisor
 	 * virtual console" driver written by the PowerPC people, which we also
 	 * adapted for lguest's use. */
 	add_preferred_console("hvc", 0, NULL);
diff --git a/drivers/lguest/core.c b/drivers/lguest/core.c
index 90663e0..60156df 100644
--- a/drivers/lguest/core.c
+++ b/drivers/lguest/core.c
@@ -224,7 +224,7 @@ int run_guest(struct lg_cpu *cpu, unsigned long __user *user)
 			break;
 
 		/* If the Guest asked to be stopped, we sleep.  The Guest's
-		 * clock timer or LHCALL_BREAK from the Waker will wake us. */
+		 * clock timer or LHREQ_BREAK from the Waker will wake us. */
 		if (cpu->halted) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			schedule();
diff --git a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
index 34bc017..b8ee103 100644
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -307,9 +307,8 @@ static int close(struct inode *inode, struct file *file)
 	 * kmalloc()ed string, either of which is ok to hand to kfree(). */
 	if (!IS_ERR(lg->dead))
 		kfree(lg->dead);
-	/* We clear the entire structure, which also marks it as free for the
-	 * next user. */
-	memset(lg, 0, sizeof(*lg));
+	/* Free the memory allocated to the lguest_struct */
+	kfree(lg);
 	/* Release lock and exit. */
 	mutex_unlock(&lguest_lock);
 
