Return-Path: <linux-kernel-owner+w=401wt.eu-S1764112AbZD3Riv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764112AbZD3Riv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764675AbZD3RId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:33 -0400
Received: from kroah.org ([198.145.64.141]:56829 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764672AbZD3RIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:08:15 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:48 2009
Message-Id: <20090430165748.405971071@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:57 -0700
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
       alan@lxorguk.ukuu.org.uk, mtosatti@redhat.com, avi@redhat.com
Subject: [patch 68/88] KVM: Advertise the bug in memory region destruction as fixed
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=kvm-advertise-the-bug-in-memory-region-destruction-as-fixed.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Avi Kivity <avi@redhat.com>

(cherry picked from 1a811b6167089bcdb84284f2dc9fd0b4d0f1899d)

Userspace might need to act differently.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kvm.h |    2 ++
 virt/kvm/kvm_main.c |   13 ++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -387,6 +387,8 @@ struct kvm_trace_rec {
 #define KVM_CAP_DEVICE_ASSIGNMENT 17
 #endif
 #define KVM_CAP_IOMMU 18
+/* Bug in KVM_SET_USER_MEMORY_REGION fixed: */
+#define KVM_CAP_DESTROY_MEMORY_REGION_WORKS 21
 
 /*
  * ioctls for VM fds
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1715,6 +1715,17 @@ static int kvm_dev_ioctl_create_vm(void)
 	return fd;
 }
 
+static long kvm_dev_ioctl_check_extension_generic(long arg)
+{
+	switch (arg) {
+	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
+		return 1;
+	default:
+		break;
+	}
+	return kvm_dev_ioctl_check_extension(arg);
+}
+
 static long kvm_dev_ioctl(struct file *filp,
 			  unsigned int ioctl, unsigned long arg)
 {
@@ -1734,7 +1745,7 @@ static long kvm_dev_ioctl(struct file *f
 		r = kvm_dev_ioctl_create_vm();
 		break;
 	case KVM_CHECK_EXTENSION:
-		r = kvm_dev_ioctl_check_extension(arg);
+		r = kvm_dev_ioctl_check_extension_generic(arg);
 		break;
 	case KVM_GET_VCPU_MMAP_SIZE:
 		r = -EINVAL;


