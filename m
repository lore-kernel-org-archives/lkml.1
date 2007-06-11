Return-Path: <linux-kernel-owner+w=401wt.eu-S1760817AbXFKHSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760817AbXFKHSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 03:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbXFKHR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 03:17:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:34314 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbXFKHR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 03:17:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=k13vZ8MC3mNOgyV0xtkaSBWyzf1v70QCLE96Qopif4QNL6v1w0by9u44O2TPHHqAbhPBdS8DuiuQSEyn/IMwaDeYs8bh0Ow8YfXo8rgl26ew0kTq0i8erHJvkc2ZBHXU1Wq6ls+pACSxkglCFK8iruHxiuZZbtkoymbBTwIDuEw=
Message-ID: <466CF71B.2000907@gmail.com>
Date: Mon, 11 Jun 2007 16:17:47 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc4-mm2: GPF during suspend to RAM on HPC nx6325
References: <200706110102.52946.rjw@sisk.pl>
In-Reply-To: <200706110102.52946.rjw@sisk.pl>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------050301020803010704060709"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050301020803010704060709
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

Hello, Rafael.

Rafael J. Wysocki wrote:
> gregkh-driver-sysfs-use-singly-linked-list-for-sysfs_dirent-tree.patch breaks
> suspend to RAM on HPC nx6325 (x86_64).
> 
> With this patch applied I get a general protection fault in mutex_lock+0x15
> (kernel/mutex.c:91), called by sysfs_hash_and_remove() (fs/sysfs/inode.c:298),
> called by threshold_cpu_callback(), called from _cpu_down().

I'm not sure whether this is bug in sysfs or in sysfs handling code in
mce_amd and I can't test mce_amd here.  Can you please apply the
attached patch and post the resulting dmesg including oops?

Thanks.

-- 
tejun

--------------050301020803010704060709
Content-Type: text/x-patch;
 name="debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="debug.patch"

diff --git a/arch/x86_64/kernel/mce_amd.c b/arch/x86_64/kernel/mce_amd.c
index 03356e6..96da4aa 100644
--- a/arch/x86_64/kernel/mce_amd.c
+++ b/arch/x86_64/kernel/mce_amd.c
@@ -434,6 +434,7 @@ static __cpuinit int allocate_threshold_blocks(unsigned int cpu,
 	kobject_set_name(&b->kobj, "misc%i", block);
 	b->kobj.parent = &per_cpu(threshold_banks, cpu)[bank]->kobj;
 	b->kobj.ktype = &threshold_ktype;
+	printk("XXX%d registering %s (%p)\n", cpu, kobject_name(&b->kobj), &b->kobj);
 	err = kobject_register(&b->kobj);
 	if (err)
 		goto out_free;
@@ -454,6 +455,7 @@ recurse:
 
 out_free:
 	if (b) {
+		printk("XXX%d unregistering %s (%p)\n", cpu, kobject_name(&b->kobj), &b->kobj);
 		kobject_unregister(&b->kobj);
 		kfree(b);
 	}
@@ -511,6 +513,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 #else
 	b->cpus = cpu_core_map[cpu];
 #endif
+	printk("XXX%d registering %s (%p)\n", cpu, kobject_name(&b->kobj), &b->kobj);
 	err = kobject_register(&b->kobj);
 	if (err)
 		goto out_free;
@@ -580,6 +583,7 @@ static void deallocate_threshold_block(unsigned int cpu,
 		return;
 
 	list_for_each_entry_safe(pos, tmp, &head->blocks->miscj, miscj) {
+		printk("XXX%d unregistering %s (%p)\n", cpu, kobject_name(&pos->kobj), &pos->kobj);
 		kobject_unregister(&pos->kobj);
 		list_del(&pos->miscj);
 		kfree(pos);
@@ -626,6 +630,7 @@ static void threshold_remove_bank(unsigned int cpu, int bank)
 	deallocate_threshold_block(cpu, bank);
 
 free_out:
+	printk("XXX%d unregistering %s (%p)\n", cpu, kobject_name(&b->kobj), &b->kobj);
 	kobject_unregister(&b->kobj);
 	kfree(b);
 	per_cpu(threshold_banks, cpu)[bank] = NULL;

--------------050301020803010704060709--
