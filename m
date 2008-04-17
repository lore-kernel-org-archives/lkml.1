Return-Path: <linux-kernel-owner+w=401wt.eu-S934144AbYDQJa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934144AbYDQJa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763554AbYDQJLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:11:55 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:58967
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763410AbYDQJLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:11:14 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Xiantao Zhang <xiantao.zhang@intel.com>
Subject: [PATCH 45/45] KVM: ia64: Add a guide about how to create kvm guests on ia64
Date: Thu, 17 Apr 2008 12:10:50 +0300
Message-Id: <1208423450-29415-46-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiantao Zhang <xiantao.zhang@intel.com>

Guide for creating virtual machine on kvm/ia64.

Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 Documentation/ia64/kvm.txt |   82 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 82 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ia64/kvm.txt

diff --git a/Documentation/ia64/kvm.txt b/Documentation/ia64/kvm.txt
new file mode 100644
index 0000000..bec9d81
--- /dev/null
+++ b/Documentation/ia64/kvm.txt
@@ -0,0 +1,82 @@
+Currently, kvm module in EXPERIMENTAL stage on IA64. This means that
+interfaces are not stable enough to use. So, plase had better don't run
+critical applications in virtual machine. We will try our best to make it
+strong in future versions!
+				Guide: How to boot up guests on kvm/ia64
+
+This guide is to describe how to enable kvm support for IA-64 systems.
+
+1. Get the kvm source from git.kernel.org.
+	Userspace source:
+		git clone git://git.kernel.org/pub/scm/virt/kvm/kvm-userspace.git
+	Kernel Source:
+		git clone git://git.kernel.org/pub/scm/linux/kernel/git/xiantao/kvm-ia64.git
+
+2. Compile the source code.
+	2.1 Compile userspace code:
+		(1)cd ./kvm-userspace
+		(2)./configure
+		(3)cd kernel
+		(4)make sync LINUX= $kernel_dir (kernel_dir is the directory of kernel source.)
+		(5)cd ..
+		(6)make qemu
+		(7)cd qemu; make install
+
+	2.2 Compile kernel source code:
+		(1) cd ./$kernel_dir
+		(2) Make menuconfig
+		(3) Enter into virtualization option, and choose kvm.
+		(4) make
+		(5) Once (4) done, make modules_install
+		(6) Make initrd, and use new kernel to reboot up host machine.
+		(7) Once (6) done, cd $kernel_dir/arch/ia64/kvm
+		(8) insmod kvm.ko; insmod kvm-intel.ko
+
+Note: For step 2, please make sure that host page size == TARGET_PAGE_SIZE of qemu, otherwise, may fail.
+
+3. Get Guest Firmware named as Flash.fd, and put it under right place:
+	(1) If you have the guest firmware (binary) released by Intel Corp for Xen, use it directly.
+
+	(2) If you have no firmware at hand, Please download its source from
+		hg clone http://xenbits.xensource.com/ext/efi-vfirmware.hg
+	    you can get the firmware's binary in the directory of efi-vfirmware.hg/binaries.
+
+	(3) Rename the firware you owned to Flash.fd, and copy it to /usr/local/share/qemu
+
+4. Boot up Linux or Windows guests:
+	4.1 Create or install a image for guest boot. If you have xen experience, it should be easy.
+
+	4.2 Boot up guests use the following command.
+		/usr/local/bin/qemu-system-ia64 -smp xx -m 512 -hda $your_image
+		(xx is the number of virtual processors for the guest, now the maximum value is 4)
+
+5. Known possibile issue on some platforms with old Firmware.
+
+If meet strange host crashe issues, try to solve it through either of the following ways:
+
+(1): Upgrade your Firmware to the latest one.
+
+(2): Applying the below patch to kernel source.
+diff --git a/arch/ia64/kernel/pal.S b/arch/ia64/kernel/pal.S
+index 0b53344..f02b0f7 100644
+--- a/arch/ia64/kernel/pal.S
++++ b/arch/ia64/kernel/pal.S
+@@ -84,7 +84,8 @@ GLOBAL_ENTRY(ia64_pal_call_static)
+	mov ar.pfs = loc1
+	mov rp = loc0
+	;;
+-	srlz.d				// seralize restoration of psr.l
++	srlz.i			// seralize restoration of psr.l
++	;;
+	br.ret.sptk.many b0
+ END(ia64_pal_call_static)
+
+6. Bug report:
+	If you found any issues when use kvm/ia64, Please post the bug info to kvm-ia64-devel mailing list.
+	https://lists.sourceforge.net/lists/listinfo/kvm-ia64-devel/
+
+Thanks for your interest! Let's work together, and make kvm/ia64 stronger and stronger!
+
+
+								Xiantao Zhang <xiantao.zhang@intel.com>
+											2008.3.10
-- 
1.5.5

