Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbZCVTkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbZCVTkr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 15:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755875AbZCVTkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 15:40:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:40803 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755512AbZCVTkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 15:40:19 -0400
Date: Sun, 22 Mar 2009 19:39:28 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       mingo@redhat.com, lethal@linux-sh.org, tglx@linutronix.de,
       sfr@canb.auug.org.au, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, sfr@canb.auug.org.au, tglx@linutronix.de,
       lethal@linux-sh.org, mingo@elte.hu
In-Reply-To: <20090320110602.86351a91.sfr@canb.auug.org.au>
References: <20090320110602.86351a91.sfr@canb.auug.org.au>
Subject: [tip:tracing/core] tracing, Text Edit Lock - kprobes architecture independent support, nommu fix
Message-ID: <tip-505f2b970b2269ce4cb669b3ff4f6479d379cec2@git.kernel.org>
Git-Commit-ID: 505f2b970b2269ce4cb669b3ff4f6479d379cec2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 22 Mar 2009 19:39:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  505f2b970b2269ce4cb669b3ff4f6479d379cec2
Gitweb:     http://git.kernel.org/tip/505f2b970b2269ce4cb669b3ff4f6479d379cec2
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 20 Mar 2009 11:05:04 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Mar 2009 11:09:27 +0100

tracing, Text Edit Lock - kprobes architecture independent support, nommu fix

Impact: build fix on SH !CONFIG_MMU

Stephen Rothwell reported this linux-next build failure on the SH
architecture:

  kernel/built-in.o: In function `disable_all_kprobes':
  kernel/kprobes.c:1382: undefined reference to `text_mutex'
  [...]

And observed:

| Introduced by commit 4460fdad85becd569f11501ad5b91814814335ff ("tracing,
| Text Edit Lock - kprobes architecture independent support") from the
| tracing tree.  text_mutex is defined in mm/memory.c which is only built
| if CONFIG_MMU is defined, which is not true for sh allmodconfig.

Move this lock to kernel/extable.c (which is already home to various
kernel text related routines), which file is always built-in.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
LKML-Reference: <20090320110602.86351a91.sfr@canb.auug.org.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/extable.c |   14 ++++++++++++--
 mm/memory.c      |    8 --------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/kernel/extable.c b/kernel/extable.c
index 0df6253..25d39b0 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -15,11 +15,21 @@
     along with this program; if not, write to the Free Software
     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
+#include <linux/ftrace.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/init.h>
-#include <linux/ftrace.h>
-#include <asm/uaccess.h>
+
 #include <asm/sections.h>
+#include <asm/uaccess.h>
+
+/*
+ * mutex protecting text section modification (dynamic code patching).
+ * some users need to sleep (allocating memory...) while they hold this lock.
+ *
+ * NOT exported to modules - patching kernel text is a really delicate matter.
+ */
+DEFINE_MUTEX(text_mutex);
 
 extern struct exception_table_entry __start___ex_table[];
 extern struct exception_table_entry __stop___ex_table[];
diff --git a/mm/memory.c b/mm/memory.c
index 05fab3b..dfc9e4e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -101,14 +101,6 @@ int randomize_va_space __read_mostly =
 					2;
 #endif
 
-/*
- * mutex protecting text section modification (dynamic code patching).
- * some users need to sleep (allocating memory...) while they hold this lock.
- *
- * NOT exported to modules - patching kernel text is a really delicate matter.
- */
-DEFINE_MUTEX(text_mutex);
-
 static int __init disable_randmaps(char *s)
 {
 	randomize_va_space = 0;
