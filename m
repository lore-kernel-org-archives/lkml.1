Return-Path: <linux-kernel-owner+w=401wt.eu-S934651AbZJNPrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934651AbZJNPrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934643AbZJNPrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:47:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:33977 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934590AbZJNPrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:47:01 -0400
Date: Wed, 14 Oct 2009 15:46:04 GMT
From: tip-bot for John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, jkacur@redhat.com, vapier@gentoo.org,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkacur@redhat.com, fweisbec@gmail.com, vapier@gentoo.org,
       tglx@linutronix.de
In-Reply-To: <alpine.LFD.2.00.0910130007240.3658@localhost.localdomain>
References: <alpine.LFD.2.00.0910130007240.3658@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/arch] blackfin: Remove the BKL from sys_execve
Message-ID: <tip-25708a5fe7467dcc69d9b92c1701aad4a0c71887@git.kernel.org>
Git-Commit-ID: 25708a5fe7467dcc69d9b92c1701aad4a0c71887
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:46:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  25708a5fe7467dcc69d9b92c1701aad4a0c71887
Gitweb:     http://git.kernel.org/tip/25708a5fe7467dcc69d9b92c1701aad4a0c71887
Author:     John Kacur <jkacur@redhat.com>
AuthorDate: Mon, 12 Oct 2009 22:44:40 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 17:18:14 +0200

blackfin: Remove the BKL from sys_execve

This looks like a cut-and-paste job. For example, compare this
function to sys_execve in arch/x86/kernel/process_64.c and it is
almost line by line the same, except the one in x86 nolonger has the
big kernel lock. All of the functions called between the lock are
generic and not specific to blackfin - thus, I believe it is safe to
remove the bkl here.

Signed-off-by: John Kacur <jkacur@redhat.com>
Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Mike Frysinger <vapier@gentoo.org>
LKML-Reference: <alpine.LFD.2.00.0910130007240.3658@localhost.localdomain>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/blackfin/kernel/process.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 430ae39..7d9c975 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -215,22 +215,18 @@ copy_thread(unsigned long clone_flags,
 /*
  * sys_execve() executes a new program.
  */
-
 asmlinkage int sys_execve(char __user *name, char __user * __user *argv, char __user * __user *envp)
 {
 	int error;
 	char *filename;
 	struct pt_regs *regs = (struct pt_regs *)((&name) + 6);
 
-	lock_kernel();
 	filename = getname(name);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
-		goto out;
+		return error;
 	error = do_execve(filename, argv, envp, regs);
 	putname(filename);
- out:
-	unlock_kernel();
 	return error;
 }
 
