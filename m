Return-Path: <linux-kernel-owner+w=401wt.eu-S1753043AbYLBKRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbYLBKRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 05:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbYLBKRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 05:17:36 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:55685 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbYLBKRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 05:17:35 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Avi Kivity <avi@redhat.com>
Subject: [PATCH 2/2] kvm: set owner of cpu and vm file operations
Date: Tue, 2 Dec 2008 11:17:32 +0100
User-Agent: KMail/1.9.9
Cc: kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <200812021114.59050.borntraeger@de.ibm.com>
In-Reply-To: <200812021114.59050.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812021117.32521.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race between a "close of the file descriptors" and module
unload in the kvm module.

You can easily trigger this problem by applying this debug patch:
>--- kvm.orig/virt/kvm/kvm_main.c
>+++ kvm/virt/kvm/kvm_main.c
>@@ -648,10 +648,14 @@ void kvm_free_physmem(struct kvm *kvm)
>                kvm_free_physmem_slot(&kvm->memslots[i], NULL);
> }
>
>+#include <linux/delay.h>
> static void kvm_destroy_vm(struct kvm *kvm)
> {
>        struct mm_struct *mm = kvm->mm;
>
>+       printk("off1\n");
>+       msleep(5000);
>+       printk("off2\n");
>        spin_lock(&kvm_lock);
>        list_del(&kvm->vm_list);
>        spin_unlock(&kvm_lock);

and killing the userspace, followed by an rmmod.

The problem is that kvm_destroy_vm can run while the module count
is 0. That means, you can remove the module while kvm_destroy_vm
is running. But kvm_destroy_vm is part of the module text. This
causes a kerneloops. The race exists without the msleep but is much
harder to trigger.

This patch requires the fix for anon_inodes (anon_inodes: use fops->owner
for module refcount).
With this patch, we can set the owner of all anonymous KVM inodes file
operations. The VFS will then control the KVM module refcount as long as there
is an open file. kvm_destroy_vm will be called by the release function of the
last closed file - before the VFS drops the module refcount. 

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

---
 virt/kvm/kvm_main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: kvm/virt/kvm/kvm_main.c
===================================================================
--- kvm.orig/virt/kvm/kvm_main.c
+++ kvm/virt/kvm/kvm_main.c
@@ -1303,7 +1303,7 @@ static int kvm_vcpu_release(struct inode
 	return 0;
 }
 
-static const struct file_operations kvm_vcpu_fops = {
+static struct file_operations kvm_vcpu_fops = {
 	.release        = kvm_vcpu_release,
 	.unlocked_ioctl = kvm_vcpu_ioctl,
 	.compat_ioctl   = kvm_vcpu_ioctl,
@@ -1697,7 +1697,7 @@ static int kvm_vm_mmap(struct file *file
 	return 0;
 }
 
-static const struct file_operations kvm_vm_fops = {
+static struct file_operations kvm_vm_fops = {
 	.release        = kvm_vm_release,
 	.unlocked_ioctl = kvm_vm_ioctl,
 	.compat_ioctl   = kvm_vm_ioctl,
@@ -2061,6 +2061,8 @@ int kvm_init(void *opaque, unsigned int 
 	}
 
 	kvm_chardev_ops.owner = module;
+	kvm_vm_fops.owner = module;
+	kvm_vcpu_fops.owner = module;
 
 	r = misc_register(&kvm_dev);
 	if (r) {
