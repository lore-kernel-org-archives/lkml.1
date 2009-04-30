Return-Path: <linux-kernel-owner+w=401wt.eu-S933512AbZD3RiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933512AbZD3RiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764676AbZD3RIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:32 -0400
Received: from kroah.org ([198.145.64.141]:56816 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764668AbZD3RIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:08:14 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:48 2009
Message-Id: <20090430165748.263011145@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Christian Borntraeger <borntraeger@de.ibm.com>, mtosatti@redhat.com,
       avi@redhat.com
Subject: [patch 67/88] KVM: set owner of cpu and vm file operations
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=kvm-set-owner-of-cpu-and-vm-file-operations.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christian Borntraeger <borntraeger@de.ibm.com>

(cherry picked from 3d3aab1b973b01bd2a1aa46307e94a1380b1d802)

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
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 virt/kvm/kvm_main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1299,7 +1299,7 @@ static int kvm_vcpu_release(struct inode
 	return 0;
 }
 
-static const struct file_operations kvm_vcpu_fops = {
+static struct file_operations kvm_vcpu_fops = {
 	.release        = kvm_vcpu_release,
 	.unlocked_ioctl = kvm_vcpu_ioctl,
 	.compat_ioctl   = kvm_vcpu_ioctl,
@@ -1693,7 +1693,7 @@ static int kvm_vm_mmap(struct file *file
 	return 0;
 }
 
-static const struct file_operations kvm_vm_fops = {
+static struct file_operations kvm_vm_fops = {
 	.release        = kvm_vm_release,
 	.unlocked_ioctl = kvm_vm_ioctl,
 	.compat_ioctl   = kvm_vm_ioctl,
@@ -2057,6 +2057,8 @@ int kvm_init(void *opaque, unsigned int 
 	}
 
 	kvm_chardev_ops.owner = module;
+	kvm_vm_fops.owner = module;
+	kvm_vcpu_fops.owner = module;
 
 	r = misc_register(&kvm_dev);
 	if (r) {


