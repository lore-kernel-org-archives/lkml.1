Return-Path: <linux-kernel-owner+w=401wt.eu-S933826AbYCFPP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933826AbYCFPP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 10:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764263AbYCFPPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 10:15:08 -0500
Received: from verein.lst.de ([213.95.11.210]:46255 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764826AbYCFPPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 10:15:01 -0500
Date: Thu, 6 Mar 2008 16:14:02 +0100
From: Christoph Hellwig <hch@lst.de>
To: Roland Dreier <rdreier@cisco.com>
Cc: Davide Libenzi <davidel@xmailserver.org>, Christoph Hellwig <hch@lst.de>,
       linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH/RFC 1/2] anon-inodes: Remove fd_install() from anon_inode_getfd()
Message-ID: <20080306151402.GA17077@lst.de>
References: <20080225191043.GA32342@lst.de> <adak5kqyzv1.fsf@cisco.com> <Pine.LNX.4.64.0802271138170.377@alien.or.mcafeemobile.com> <adabq62yx5r.fsf@cisco.com> <Pine.LNX.4.64.0802271218210.377@alien.or.mcafeemobile.com> <ada7igqyurw.fsf@cisco.com> <adar6eyx8y5.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adar6eyx8y5.fsf@cisco.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 03:42:42PM -0800, Roland Dreier wrote:
>  > http://git.kernel.org/?p=linux/kernel/git/viro/vfs-2.6.git;a=commit;h=49be4f8114e6ff0efdab10ebba2493fb67bc3034
> 
> Actually, looking closer at the kvm changes here, I think that
> create_vcpu_fd() needs the same treatment as kvm_dev_ioctl_create_vm()
> gets in the patch because of the race I mentioned in the changelog
> for my patch: otherwise kvm_vcpu_release() could drop the last
> reference to vcpu->kvm->filp before the get_file() gets an extra
> reference.

Actually using the file pointer for reference counting in kvm is quite
stupid and risky, it should use a normal reference count instead.
See untested patch below.

> I'm beginning to think that moving the fd_install() out of
> anon_inode_getfd() really is worth it to make a safer interface.

No, the best interface is one where the driver doesn't even see
inode or file.  Of course that's not actually possible in a few
nasty cases like the infiniband code, and for those it might be
better to do the fd_isntall themselves.



Index: linux-2.6/include/linux/kvm_host.h
===================================================================
--- linux-2.6.orig/include/linux/kvm_host.h	2008-02-23 20:28:14.000000000 +0100
+++ linux-2.6/include/linux/kvm_host.h	2008-02-23 20:36:20.000000000 +0100
@@ -113,7 +113,7 @@ struct kvm {
 					KVM_PRIVATE_MEM_SLOTS];
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 	struct list_head vm_list;
-	struct file *filp;
+	int refcount;
 	struct kvm_io_bus mmio_bus;
 	struct kvm_io_bus pio_bus;
 	struct kvm_vm_stat stat;
Index: linux-2.6/virt/kvm/kvm_main.c
===================================================================
--- linux-2.6.orig/virt/kvm/kvm_main.c	2008-02-23 20:29:12.000000000 +0100
+++ linux-2.6/virt/kvm/kvm_main.c	2008-02-24 02:34:44.000000000 +0100
@@ -169,6 +169,8 @@ static struct kvm *kvm_create_vm(void)
 	kvm_io_bus_init(&kvm->pio_bus);
 	mutex_init(&kvm->lock);
 	kvm_io_bus_init(&kvm->mmio_bus);
+	kvm->refcount = 1;
+
 	spin_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
 	spin_unlock(&kvm_lock);
@@ -201,11 +203,16 @@ void kvm_free_physmem(struct kvm *kvm)
 		kvm_free_physmem_slot(&kvm->memslots[i], NULL);
 }
 
-static void kvm_destroy_vm(struct kvm *kvm)
+static void kvm_put_vm(struct kvm *kvm)
 {
 	struct mm_struct *mm = kvm->mm;
 
 	spin_lock(&kvm_lock);
+	if (--kvm->refcount) {
+		spin_lock(&kvm_lock);
+		return;
+	}
+
 	list_del(&kvm->vm_list);
 	spin_unlock(&kvm_lock);
 	kvm_io_bus_destroy(&kvm->pio_bus);
@@ -216,9 +223,7 @@ static void kvm_destroy_vm(struct kvm *k
 
 static int kvm_vm_release(struct inode *inode, struct file *filp)
 {
-	struct kvm *kvm = filp->private_data;
-
-	kvm_destroy_vm(kvm);
+	kvm_put_vm(filp->private_data);
 	return 0;
 }
 
@@ -700,7 +705,7 @@ static int kvm_vcpu_release(struct inode
 {
 	struct kvm_vcpu *vcpu = filp->private_data;
 
-	fput(vcpu->kvm->filp);
+	kvm_put_vm(vcpu->kvm);
 	return 0;
 }
 
@@ -724,7 +729,16 @@ static int create_vcpu_fd(struct kvm_vcp
 			     "kvm-vcpu", &kvm_vcpu_fops, vcpu);
 	if (r)
 		return r;
-	atomic_inc(&vcpu->kvm->filp->f_count);
+
+	/*
+	 * It is guaranteed that the refcount is non-zero here because
+	 * this function is only called as ioctl method on an open
+	 * file that has a reference to it.
+	 */
+	spin_lock(&kvm_lock);
+	vcpu->kvm->refcount++;
+	spin_unlock(&kvm_lock);
+
 	return fd;
 }
 
@@ -1023,12 +1037,10 @@ static int kvm_dev_ioctl_create_vm(void)
 		return PTR_ERR(kvm);
 	r = anon_inode_getfd(&fd, &inode, &file, "kvm-vm", &kvm_vm_fops, kvm);
 	if (r) {
-		kvm_destroy_vm(kvm);
+		kvm_put_vm(kvm);
 		return r;
 	}
 
-	kvm->filp = file;
-
 	return fd;
 }
 
