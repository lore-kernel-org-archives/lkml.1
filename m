Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522Ab0AWASk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab0AWASk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706Ab0AWASk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:18:40 -0500
Received: from kroah.org ([198.145.64.141]:34995 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab0AWASj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:18:39 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jan 22 16:11:10 2010
Message-Id: <20100123001110.365773434@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 16:09:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [01/29] x86, msr/cpuid: Register enough minors for the MSR and CPUID drivers
In-Reply-To: <20100123001145.GA7391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: H. Peter Anvin <hpa@zytor.com>

commit 0b962d473af32ec334df271b54ff4973cb2b4c73 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpuid.c |    5 +++--
 arch/x86/kernel/msr.c   |    4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -192,7 +192,8 @@ static int __init cpuid_init(void)
 	int i, err = 0;
 	i = 0;
 
-	if (register_chrdev(CPUID_MAJOR, "cpu/cpuid", &cpuid_fops)) {
+	if (__register_chrdev(CPUID_MAJOR, 0, NR_CPUS,
+			      "cpu/cpuid", &cpuid_fops)) {
 		printk(KERN_ERR "cpuid: unable to get major %d for cpuid\n",
 		       CPUID_MAJOR);
 		err = -EBUSY;
@@ -221,7 +222,7 @@ out_class:
 	}
 	class_destroy(cpuid_class);
 out_chrdev:
-	unregister_chrdev(CPUID_MAJOR, "cpu/cpuid");
+	__unregister_chrdev(CPUID_MAJOR, 0, NR_CPUS, "cpu/cpuid");
 out:
 	return err;
 }
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -251,7 +251,7 @@ static int __init msr_init(void)
 	int i, err = 0;
 	i = 0;
 
-	if (register_chrdev(MSR_MAJOR, "cpu/msr", &msr_fops)) {
+	if (__register_chrdev(MSR_MAJOR, 0, NR_CPUS, "cpu/msr", &msr_fops)) {
 		printk(KERN_ERR "msr: unable to get major %d for msr\n",
 		       MSR_MAJOR);
 		err = -EBUSY;
@@ -279,7 +279,7 @@ out_class:
 		msr_device_destroy(i);
 	class_destroy(msr_class);
 out_chrdev:
-	unregister_chrdev(MSR_MAJOR, "cpu/msr");
+	__unregister_chrdev(MSR_MAJOR, 0, NR_CPUS, "cpu/msr");
 out:
 	return err;
 }


