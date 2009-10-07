Return-Path: <linux-kernel-owner+w=401wt.eu-S934327AbZJGToB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934327AbZJGToB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 15:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933824AbZJGToA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 15:44:00 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:40638 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933773AbZJGToA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 15:44:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=b51pCmySt0FW8M04JxWFw7vNo1WYB00KC0kIpFMe9cMy4RZhIbZRlxRJZ1OF+lMvkD
         73Nuddw0tNt3WWL1JcVDcy2Hf0Qcs0/ZsuHNaxMpohRp9XuEjAel9sJu0VFw1/1uqtxk
         xl9FRDJ85y8FHDwfXI9XQvVXTpFy9Qdu1/GL0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Sven-Thorsten Dietrich <sdietrich@suse.de>
Subject: [PATCH] x86: Remove the bkl from msr_open()
Date: Wed,  7 Oct 2009 21:43:22 +0200
Message-Id: <1254944602-7382-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <alpine.LFD.2.00.0910072016190.15183@localhost.localdomain>
References: <alpine.LFD.2.00.0910072016190.15183@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sven-Thorsten Dietrich <sdietrich@suse.de>
---
 arch/x86/kernel/msr.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 6a3cefc..5534499 100644
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
-- 
1.6.2.3

