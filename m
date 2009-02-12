Return-Path: <linux-kernel-owner+w=401wt.eu-S1759724AbZBLSQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759724AbZBLSQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 13:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757850AbZBLSQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 13:16:12 -0500
Received: from byss.tchmachines.com ([208.76.80.75]:60107 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954AbZBLSQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 13:16:11 -0500
Date: Thu, 12 Feb 2009 10:16:05 -0800
From: Josh Hunt <josh@scalex86.org>
To: sam@ravnborg.org
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       kiran@scalex86.org, mingo@elte.hu
Subject: [PATCH] Fix 'make rpm' when CONFIG_LOCALVERSION_AUTO=y and using
	SCM tree
Message-ID: <20090212181605.GA7696@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running 'make rpm' fails when CONFIG_LOCALVERSION_AUTO=y and using a kernel source
tree under SCM.  This is due to KERNELRELEASE being different when the initial make
is run and when make is run from rpmbuild.

mkspec creates kernel.spec using KERNELRELEASE:

<mkspec>
echo "%files"
echo '%defattr (-, root, root)'
echo "%dir /lib/modules"
echo "/lib/modules/$KERNELRELEASE"
echo "/lib/firmware"
echo "/boot/*"
echo ""
</mkspec>

When CONFIG_LOCALVERSION_AUTO=y scripts/setlocalversion is called and grabs any
additional version info from SCM.  Next, the srctree is tarred up and SCM
information is excluded.

rpmbuild reruns make and in the process generates a new include/config/kernel.release
and thus a new KERNELRELEASE.  However this time the SCM information is gone so
KERNELRELEASE no longer has the additional version information.  When "make modules_install"
runs, it uses the new KERNELRELEASE value to determine where to install the modules.
This conflicts with where the spec file assumes they are going because of the
mis-matching KERNELRELEASE versions.

<snippet>
+ INSTALL_MOD_PATH=/var/tmp/kernel-2.6.29rc4tip01479g5d85422-root
+ make -j16 modules_install
  INSTALL crypto/aead.ko
  INSTALL crypto/cbc.ko
  INSTALL crypto/chainiv.ko
  INSTALL crypto/crc32c.ko
  INSTALL crypto/crypto_algapi.ko
  INSTALL crypto/crypto_blkcipher.ko
  INSTALL crypto/crypto_hash.ko
  INSTALL crypto/cryptomgr.ko
  INSTALL crypto/ecb.ko
  INSTALL crypto/eseqiv.ko
  INSTALL crypto/krng.ko
  INSTALL crypto/md5.ko
  INSTALL crypto/pcbc.ko
  INSTALL crypto/rng.ko
  INSTALL drivers/block/cciss.ko
  INSTALL drivers/hid/hid-dummy.ko
  INSTALL drivers/scsi/iscsi_tcp.ko
  INSTALL drivers/scsi/libiscsi.ko
  INSTALL drivers/scsi/libiscsi_tcp.ko
  INSTALL drivers/scsi/scsi_transport_iscsi.ko
  INSTALL drivers/scsi/scsi_wait_scan.ko
  INSTALL fs/lockd/lockd.ko
  INSTALL fs/nfs/nfs.ko
  INSTALL fs/nfsd/nfsd.ko
  INSTALL lib/libcrc32c.ko
  INSTALL net/sunrpc/sunrpc.ko
  DEPMOD  2.6.29-rc4-tip
+ cp arch/x86/boot/bzImage
/var/tmp/kernel-2.6.29rc4tip01479g5d85422-root/boot/vmlinuz-2.6.29-rc4-tip-01479-g5d85422
+ cp System.map
/var/tmp/kernel-2.6.29rc4tip01479g5d85422-root/boot/System.map-2.6.29-rc4-tip-01479-g5d85422
+ cp .config
/var/tmp/kernel-2.6.29rc4tip01479g5d85422-root/boot/config-2.6.29-rc4-tip-01479-g5d85422
+ cp vmlinux vmlinux.orig
+ bzip2 -9 vmlinux
+ mv vmlinux.bz2
/var/tmp/kernel-2.6.29rc4tip01479g5d85422-root/boot/vmlinux-2.6.29-rc4-tip-01479-g5d85422.bz2
+ mv vmlinux.orig vmlinux
+ /usr/lib/rpm/brp-compress
Processing files: kernel-2.6.29rc4tip01479g5d85422-2
error: File not found:
/var/tmp/kernel-2.6.29rc4tip01479g5d85422-root/lib/modules/2.6.29-rc4-tip-01479-g5d85422


RPM build errors:
    File not found:
/var/tmp/kernel-2.6.29rc4tip01479g5d85422-root/lib/modules/2.6.29-rc4-tip-01479-g5d85422
make[1]: *** [rpm] Error 1
make: *** [rpm] Error 2
</snippet>

I have tested this patch on git -tip, Linus' git tree, and the kernel.org tar files, both
with and without CONFIG_LOCALVERSION_AUTO=y.

Signed-off-by: Josh Hunt <josh@scalex86.org>

Index: linux-2.6/Makefile
===================================================================
--- linux-2.6.orig/Makefile     2009-02-10 12:09:16.000000000 -0800
+++ linux-2.6/Makefile  2009-02-11 15:01:33.000000000 -0800
@@ -907,8 +907,17 @@
 # Other SCMs can edit scripts/setlocalversion and add the appropriate
 # checks as needed.
 ifdef CONFIG_LOCALVERSION_AUTO
-       _localver-auto = $(shell $(CONFIG_SHELL) \
+
+
+scmversion = $(shell cat .autoversion 2> /dev/null)
+
+ifeq ($(scmversion),)
+       _localver-auto = $(shell  $(CONFIG_SHELL) \
                          $(srctree)/scripts/setlocalversion
$(srctree))
+else
+       _localver-auto = $(shell cat .autoversion 2> /dev/null)
+endif
+
        localver-auto  = $(LOCALVERSION)$(_localver-auto)
 endif

Index: linux-2.6/scripts/package/Makefile
===================================================================
--- linux-2.6.orig/scripts/package/Makefile     2009-02-10
12:09:50.000000000 -0800
+++ linux-2.6/scripts/package/Makefile  2009-02-11 16:33:55.000000000
-0800
@@ -35,10 +35,17 @@
 rpm-pkg rpm: $(objtree)/kernel.spec FORCE
        $(MAKE) clean
        $(PREV) ln -sf $(srctree) $(KERNELPATH)
+
+       set -e; \
+       $(CONFIG_SHELL) $(srctree)/scripts/setlocalversion >
$(objtree)/.autoversion
+
        $(PREV) tar -cz $(RCS_TAR_IGNORE) -f $(KERNELPATH).tar.gz
$(KERNELPATH)/.
        $(PREV) rm $(KERNELPATH)

        set -e; \
+       rm $(objtree)/.autoversion
+
+       set -e; \
        $(CONFIG_SHELL) $(srctree)/scripts/mkversion >
$(objtree)/.tmp_version
        set -e; \
        mv -f $(objtree)/.tmp_version $(objtree)/.version

