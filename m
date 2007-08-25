Return-Path: <linux-kernel-owner+w=401wt.eu-S933699AbXHYSDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699AbXHYSDn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 14:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756967AbXHYSDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 14:03:35 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56950 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243AbXHYSDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 14:03:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: [PATCH] sysctl: Update sysctl_check to handle compiled out code.
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<23568.1187876026@turing-police.cc.vt.edu>
	<20070823141652.d488a6e0.akpm@linux-foundation.org>
	<m1wsvlmvu6.fsf_-_@ebiederm.dsl.xmission.com>
	<6634.1188030574@turing-police.cc.vt.edu>
	<m16433n55e.fsf@ebiederm.dsl.xmission.com>
	<2371.1188050875@turing-police.cc.vt.edu>
Date: Sat, 25 Aug 2007 12:03:19 -0600
In-Reply-To: <2371.1188050875@turing-police.cc.vt.edu> (Valdis Kletnieks's
	message of "Sat, 25 Aug 2007 10:07:55 -0400")
Message-ID: <m1sl67lcew.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Currently sysctl_check_table will complain if a strategy routine
is missing when we have sys_sysctl compiled out, or a proc_handler
is missing when we have procfs compiled out.  At least some
of the custom handlers actually expand to NULL when this is the
case so the warning is actually a problem.

Valdis.Kletnieks@vt.edu writes:
> As far as "something else wrong", I'm still seeing these in -rc3-mm1
>
> [    0.628000] sysctl table check failed: /kernel/ostype .1.1 Missing strategy
> [ 0.628000] sysctl table check failed: /kernel/osrelease .1.2 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/version .1.4 Missing strategy
> [ 0.628000] sysctl table check failed: /kernel/hostname .1.7 Missing strategy
> [ 0.628000] sysctl table check failed: /kernel/domainname .1.8 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/shmmax .1.34 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/shmall .1.41 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/shmmni .1.45 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/msgmax .1.35 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/msgmni .1.42 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/msgmnb .1.36 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/sem .1.43 Missing strategy


So don't worry about missing strategy routines, or missing proc_handler
routines when they will never be called.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/sysctl_check.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
index aa5b6f6..10dd744 100644
--- a/kernel/sysctl_check.c
+++ b/kernel/sysctl_check.c
@@ -1552,14 +1552,18 @@ int sysctl_check_table(struct ctl_table *table)
 						set_fail(&fail, table, "No max");
 				}
 			}
+#ifdef CONFIG_SYSCTL_SYSCALL
 			if (table->ctl_name && !table->strategy)
 				set_fail(&fail, table, "Missing strategy");
+#endif
 #if 0
 			if (!table->ctl_name && table->strategy)
 				set_fail(&fail, table, "Strategy without ctl_name");
 #endif
+#ifdef CONFIG_PROC_FS
 			if (table->procname && !table->proc_handler)
 				set_fail(&fail, table, "No proc_handler");
+#endif
 #if 0
 			if (!table->procname && table->proc_handler)
 				set_fail(&fail, table, "proc_handler without procname");
-- 
1.5.3.rc6.17.g1911

