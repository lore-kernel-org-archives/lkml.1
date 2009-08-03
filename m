Return-Path: <linux-kernel-owner+w=401wt.eu-S1752394AbZHCFKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbZHCFKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 01:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbZHCFKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 01:10:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:38659 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbZHCFKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 01:10:34 -0400
Message-ID: <4A767133.1030207@kernel.org>
Date: Mon, 03 Aug 2009 14:10:11 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] x86,percpu: fix DECLARE/DEFINE_PER_CPU_PAGE_ALIGNED()
References: <200907311813.n6VIDe9S023442@voreg.hos.anvin.org> <alpine.LFD.2.01.0907311218080.3161@localhost.localdomain> <20090731195705.GA12270@elte.hu> <alpine.LFD.2.01.0908011214330.3304@localhost.localdomain> <4A76421E.3040005@kernel.org> <alpine.LFD.2.01.0908021913130.3352@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0908021913130.3352@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 03 Aug 2009 05:10:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DECLARE/DEFINE_PER_CPU_PAGE_ALIGNED() put percpu variables in
.page_aligned section without adding any alignment restrictions.
Currently, this doesn't cause any problem because all users of the
macros have explicit page alignment and page-sized but it's much safer
to enforce page alignment from the macros.  After all, it's what they
claim to do.

Add __aligned(PAGE_SIZE) to DECLARE/DEFINE_PER_CPU_PAGE_ALIGNED() and
drop explicit alignment from it users.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
This doesn't cause any problem for the current tree.  No need to push
it hastily.

 arch/x86/kernel/cpu/common.c |    3 +--
 include/linux/percpu-defs.h  |    8 +++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f1961c0..12493c5 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1008,8 +1008,7 @@ static const unsigned int exception_stack_sizes[N_EXCEPTION_STACKS] = {
 };

 static DEFINE_PER_CPU_PAGE_ALIGNED(char, exception_stacks
-	[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ + DEBUG_STKSZ])
-	__aligned(PAGE_SIZE);
+	[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ + DEBUG_STKSZ]);

 /* May not be marked __init: used by software suspend */
 void syscall_init(void)
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index aefc2f1..18d3147 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -117,11 +117,13 @@
 /*
  * Declaration/definition used for per-CPU variables that must be page aligned.
  */
-#define DECLARE_PER_CPU_PAGE_ALIGNED(type, name)				\
-	DECLARE_PER_CPU_SECTION(type, name, ".page_aligned")
+#define DECLARE_PER_CPU_PAGE_ALIGNED(type, name)			\
+	DECLARE_PER_CPU_SECTION(type, name, ".page_aligned")		\
+	__aligned(PAGE_SIZE)

 #define DEFINE_PER_CPU_PAGE_ALIGNED(type, name)				\
-	DEFINE_PER_CPU_SECTION(type, name, ".page_aligned")
+	DEFINE_PER_CPU_SECTION(type, name, ".page_aligned")		\
+	__aligned(PAGE_SIZE)

 /*
  * Intermodule exports for per-CPU variables.
-- 
1.6.0.2

