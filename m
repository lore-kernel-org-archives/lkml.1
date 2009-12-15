Return-Path: <linux-kernel-owner+w=401wt.eu-S933894AbZLOXTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933894AbZLOXTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761443AbZLOXTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:19:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:38455 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761224AbZLOXTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:19:14 -0500
Date: Tue, 15 Dec 2009 23:18:37 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       viro@zeniv.linux.org.uk, tiwai@suse.de, alan@lxorguk.ukuu.org.uk,
       rja@sgi.com, tj@kernel.org, tglx@linutronix.de
Reply-To: rja@sgi.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tj@kernel.org, tglx@linutronix.de,
       alan@lxorguk.ukuu.org.uk, tiwai@suse.de, viro@zeniv.linux.org.uk
In-Reply-To: <tip-*@git.kernel.org>
References: <tip-*@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, msr/cpuid: Register enough minors for the MSR and CPUID drivers
Message-ID: <tip-0b962d473af32ec334df271b54ff4973cb2b4c73@git.kernel.org>
Git-Commit-ID: 0b962d473af32ec334df271b54ff4973cb2b4c73
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0b962d473af32ec334df271b54ff4973cb2b4c73
Gitweb:     http://git.kernel.org/tip/0b962d473af32ec334df271b54ff4973cb2b4c73
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 15 Dec 2009 15:13:07 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 15 Dec 2009 15:13:07 -0800

x86, msr/cpuid: Register enough minors for the MSR and CPUID drivers

register_chrdev() hardcodes registering 256 minors, presumably to
avoid breaking old drivers.  However, we need to register enough
minors so that we have all possible CPUs.

checkpatch warns on this patch, but the patch is correct: NR_CPUS here
is a static *upper bound* on the *maximum CPU index* (not *number of
CPUs!*) and that is what we want.

Reported-and-tested-by: Russ Anderson <rja@sgi.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <tip-*@git.kernel.org>
---
 arch/x86/kernel/cpuid.c |    5 +++--
 arch/x86/kernel/msr.c   |    4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 7ef24a7..cb27fd6 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -187,7 +187,8 @@ static int __init cpuid_init(void)
 	int i, err = 0;
 	i = 0;
 
-	if (register_chrdev(CPUID_MAJOR, "cpu/cpuid", &cpuid_fops)) {
+	if (__register_chrdev(CPUID_MAJOR, 0, NR_CPUS,
+			      "cpu/cpuid", &cpuid_fops)) {
 		printk(KERN_ERR "cpuid: unable to get major %d for cpuid\n",
 		       CPUID_MAJOR);
 		err = -EBUSY;
@@ -216,7 +217,7 @@ out_class:
 	}
 	class_destroy(cpuid_class);
 out_chrdev:
-	unregister_chrdev(CPUID_MAJOR, "cpu/cpuid");
+	__unregister_chrdev(CPUID_MAJOR, 0, NR_CPUS, "cpu/cpuid");
 out:
 	return err;
 }
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 572b07e..4bd93c9 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -246,7 +246,7 @@ static int __init msr_init(void)
 	int i, err = 0;
 	i = 0;
 
-	if (register_chrdev(MSR_MAJOR, "cpu/msr", &msr_fops)) {
+	if (__register_chrdev(MSR_MAJOR, 0, NR_CPUS, "cpu/msr", &msr_fops)) {
 		printk(KERN_ERR "msr: unable to get major %d for msr\n",
 		       MSR_MAJOR);
 		err = -EBUSY;
@@ -274,7 +274,7 @@ out_class:
 		msr_device_destroy(i);
 	class_destroy(msr_class);
 out_chrdev:
-	unregister_chrdev(MSR_MAJOR, "cpu/msr");
+	__unregister_chrdev(MSR_MAJOR, 0, NR_CPUS, "cpu/msr");
 out:
 	return err;
 }
