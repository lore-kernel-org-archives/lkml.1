Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbYLIKI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbYLIKI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 05:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbYLIKIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 05:08:45 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:41121 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbYLIKIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 05:08:43 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 0/2] module_refcounting and anonymous inodes
Date: Tue, 9 Dec 2008 11:08:39 +0100
User-Agent: KMail/1.9.9
Cc: Sheng Yang <sheng@linux.intel.com>, kvm@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <200812021114.59050.borntraeger@de.ibm.com> <200812091743.26586.sheng@linux.intel.com> <493E3F8B.7070603@redhat.com>
In-Reply-To: <493E3F8B.7070603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812091108.39145.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 9. Dezember 2008 schrieb Avi Kivity:
> Sheng Yang wrote:
> > Should we push the first patch to 2.6.28? 
> 
> It's not a recent regression, so no.
> 
> > I got some trouble with the separate 
> > 2nd patch, for I am using Linus' tree and make KVM as modules, so the 
> > reference count reduced to negative now... (Oh Avi, I know you suggest to 
use 
> > in kernel rather than modules, but module is indeed convenient. :) )
> >   
> 
> Right, that would affect everyone.  What we need is to hack the second 
> patch for external modules on <2.6.29.

Oh this is tricky. Both patches belong together, patch 2 depends on patch 1.
For base kernels which do not contain patch1, this additional (untested) patch 
would probably help:

---
 virt/kvm/kvm_main.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

Index: kvm/virt/kvm/kvm_main.c
===================================================================
--- kvm.orig/virt/kvm/kvm_main.c
+++ kvm/virt/kvm/kvm_main.c
@@ -1501,9 +1501,15 @@ static struct file_operations kvm_vcpu_f
  */
 static int create_vcpu_fd(struct kvm_vcpu *vcpu)
 {
-	int fd = anon_inode_getfd("kvm-vcpu", &kvm_vcpu_fops, vcpu, 0);
-	if (fd < 0)
+	int fd;
+
+	if (!try_module_get(kvm_vcpu_fops.owner))
+		return -ENOENT;
+	fd = anon_inode_getfd("kvm-vcpu", &kvm_vcpu_fops, vcpu, 0);
+	if (fd < 0) {
 		kvm_put_kvm(vcpu->kvm);
+		module_put(kvm_vcpu_fops.owner);
+	}
 	return fd;
 }
 
@@ -1895,12 +1901,19 @@ static int kvm_dev_ioctl_create_vm(void)
 	int fd;
 	struct kvm *kvm;
 
+	if (!try_module_get(kvm_vm_fops.owner))
+		return -ENOENT;
+
 	kvm = kvm_create_vm();
-	if (IS_ERR(kvm))
+	if (IS_ERR(kvm)) {
+		module_put(kvm_vm_fops.owner);
 		return PTR_ERR(kvm);
+	}
 	fd = anon_inode_getfd("kvm-vm", &kvm_vm_fops, kvm, 0);
-	if (fd < 0)
+	if (fd < 0) {
 		kvm_put_kvm(kvm);
+		module_put(kvm_vm_fops.owner);
+	}
 
 	return fd;
 }


The problem is, how do you detect if the base kernel has patch1 applied?

Christian
