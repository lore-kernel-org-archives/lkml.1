Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbZJGV0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbZJGV0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbZJGV0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:26:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:57339 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983AbZJGV0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:26:45 -0400
Date: Wed, 7 Oct 2009 21:10:16 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jkacur@redhat.com, sdietrich@suse.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, jkacur@redhat.com, tglx@linutronix.de,
       sdietrich@suse.de, mingo@elte.hu
In-Reply-To: <1254944602-7382-1-git-send-email-fweisbec@gmail.com>
References: <1254944602-7382-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, msr: Remove the bkl from msr_open()
Message-ID: <tip-d6c304055b3cecd4ca865769ac7cea97a320727b@git.kernel.org>
Git-Commit-ID: d6c304055b3cecd4ca865769ac7cea97a320727b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 07 Oct 2009 21:10:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d6c304055b3cecd4ca865769ac7cea97a320727b
Gitweb:     http://git.kernel.org/tip/d6c304055b3cecd4ca865769ac7cea97a320727b
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 7 Oct 2009 21:43:22 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 7 Oct 2009 13:47:19 -0700

x86, msr: Remove the bkl from msr_open()

Remove the big kernel lock from msr_open() as it doesn't protect
anything there.

The only racy event that can happen here is a concurrent cpu shutdown.

So let's look at what could be racy during/after the above event:

- The cpu_online() check is racy, but the bkl doesn't help about
  that anyway it disables preemption but we may be chcking another
  cpu than the current one.
  Also the cpu can still become offlined between open and read calls.

- The cpu_data(cpu) returns a safe pointer too. It won't be released on
  cpu offlining. But some fields can be changed from
  arch/x86/kernel/smpboot.c:remove_siblinginfo() :

	- phys_proc_id
	- cpu_core_id

  Those are not read from msr_open(). What we are checking is the
  x86_capability that is left untouched on offlining.

So this removal looks safe.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sven-Thorsten Dietrich <sdietrich@suse.de>
LKML-Reference: <1254944602-7382-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/msr.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 7dd9500..c006109 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -174,21 +174,17 @@ static int msr_open(struct inode *inode, struct file *file)
 {
 	unsigned int cpu = iminor(file->f_path.dentry->d_inode);
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
-	int ret = 0;
 
-	lock_kernel();
 	cpu = iminor(file->f_path.dentry->d_inode);
 
-	if (cpu >= nr_cpu_ids || !cpu_online(cpu)) {
-		ret = -ENXIO;	/* No such CPU */
-		goto out;
-	}
+	if (cpu >= nr_cpu_ids || !cpu_online(cpu))
+		return -ENXIO;	/* No such CPU */
+
 	c = &cpu_data(cpu);
 	if (!cpu_has(c, X86_FEATURE_MSR))
-		ret = -EIO;	/* MSR not supported */
-out:
-	unlock_kernel();
-	return ret;
+		return -EIO;	/* MSR not supported */
+
+	return 0;
 }
 
 /*
