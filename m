Return-Path: <linux-kernel-owner+w=401wt.eu-S934078AbZIDUOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934078AbZIDUOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934049AbZIDUOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:14:32 -0400
Received: from kroah.org ([198.145.64.141]:36195 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934030AbZIDUO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:28 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:53 2009
Message-Id: <20090904200853.572336618@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Glauber Costa <glommer@redhat.com>, avi@redhat.com
Subject: [patch 22/48] KVM: Dont destroy vcpu in case vcpu_setup fails
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=kvm-don-t-destroy-vcpu-in-case-vcpu_setup-fails.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Glauber Costa <glommer@redhat.com>

(cherry picked from commit 7d8fece678c1abc2ca3e1ceda2277c3538a9161c)

One of vcpu_setup responsibilities is to do mmu initialization.
However, in case we fail in kvm_arch_vcpu_reset, before we get the
chance to init mmu. OTOH, vcpu_destroy will attempt to destroy mmu,
triggering a bug. Keeping track of whether or not mmu is initialized
would unnecessarily complicate things. Rather, we just make return,
making sure any needed uninitialization is done before we return, in
case we fail.

Signed-off-by: Glauber Costa <glommer@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 virt/kvm/kvm_main.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1074,12 +1074,11 @@ static int kvm_vm_ioctl_create_vcpu(stru
 
 	r = kvm_arch_vcpu_setup(vcpu);
 	if (r)
-		goto vcpu_destroy;
+		return r;
 
 	mutex_lock(&kvm->lock);
 	if (kvm->vcpus[n]) {
 		r = -EEXIST;
-		mutex_unlock(&kvm->lock);
 		goto vcpu_destroy;
 	}
 	kvm->vcpus[n] = vcpu;
@@ -1095,8 +1094,8 @@ static int kvm_vm_ioctl_create_vcpu(stru
 unlink:
 	mutex_lock(&kvm->lock);
 	kvm->vcpus[n] = NULL;
-	mutex_unlock(&kvm->lock);
 vcpu_destroy:
+	mutex_unlock(&kvm->lock);
 	kvm_arch_vcpu_destroy(vcpu);
 	return r;
 }


