Return-Path: <linux-kernel-owner+w=401wt.eu-S1756378AbYBDQqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbYBDQqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 11:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbYBDQqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 11:46:34 -0500
Received: from merkurneu.hrz.uni-giessen.de ([134.176.2.3]:52519 "EHLO
	merkurneu.hrz.uni-giessen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754040AbYBDQqc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 11:46:32 -0500
From: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>
Organization: IAP =?iso-8859-1?q?Universit=E4t?= Giessen
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Cbe-oss-dev] LIO Target iSCSI/SE PS3-Linux / FC8 builds
Date: Mon, 4 Feb 2008 17:44:55 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: cbe-oss-dev@ozlabs.org, linux-scsi <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Open iSCSI <open-iscsi@googlegroups.com>
References: <1202134623.11265.524.camel@haakon2.linux-iscsi.org> <200802041647.06234.marc.dietrich@ap.physik.uni-giessen.de> <1202140360.11265.543.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1202140360.11265.543.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802041744.55909.marc.dietrich@ap.physik.uni-giessen.de>
X-HRZ-JLUG-MailScanner-Information: Passed JLUG virus check
X-HRZ-JLUG-MailScanner: No virus found
X-MailScanner-From: marc.dietrich@ap.physik.uni-giessen.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Nicholas,

thanks for your quick reply.

Am Montag 04 Februar 2008 16:52:40 schrieb Nicholas A. Bellinger:
> Hi Marc,
>
> You can generate the kernel RPM with 'make kernel ARCH=powerpc'.

Yes, this works. The arch detection is a little ugly. I wonder why it is 
necessary at all.

> Also, while module-assistant is supported on debian/ubuntu,
> trunk/buildtools/ currently does not support generating kernel module
> source rpms.  If you want to send a patch, I would be more than happy to
> take it.

I don't think, that it is useful to provide a kernel module rpm - kernels are 
changing to fast ;-) Better go for dkms ...

Anyway, heres a quick ugly fix for the ARCH detection code, tested on ps3.

Thanks

Marc


--- ostype.pm.orig      2008-02-04 17:02:48.000000000 +0100
+++ ostype.pm   2008-02-04 17:37:19.000000000 +0100
@@ -33,14 +33,10 @@

     if ($rval->{ARCH} eq "")
     {
-       my $uname = `file $root/bin/ls`;
-       $uname =~ s/\n+//g;
-
-       $rval->{ARCH}="x86_64" if ($uname =~ /64.*(AMD|Intel)/);
-       $rval->{ARCH}="i386" if ($uname =~ /32.*(AMD|Intel)/);
-       $rval->{ARCH}="ppc" if ($uname =~ /32.*(PowerPC)/);
-       $rval->{ARCH}="ppc64" if ($uname =~ /64.*(PowerPC)/);
-       $rval->{ARCH}="alpha" if ($uname =~ /64.*(Alpha)/);
+       my $uname = `uname -r`;
+       $uname =~ s/\n//g;
+       $rval->{ARCH} = readlink "/lib/modules/$uname/build/include/asm";
+       $rval->{ARCH} =~ s/asm\-(.*)/\1/g;
     }
     if ($rval->{ARCH} eq "")
     {



>
> --nab
>
> On Mon, 2008-02-04 at 16:47 +0100, Marc Dietrich wrote:
> > Hi Nicholas,
> >
> > can you please also upload a src.rpm? I'm having toubles compiling the
> > kernel code:
> >
> > # cd target/ ; ./autoconfig --write-to-file ; cat .make_autoconfig ; make
> > kernel
> > /usr/src/linux-iscsi/trunk/target/.make_autoconfig
> > ARCH?=ppc
> > AUTO_CFLAGS?= -DHAS_UTS_RELEASE -DUSE_SCSI_H
> > -I/lib/modules/2.6.24-06289-g144de36/source/drivers/scsi  -DUSE_MSLEEP
> > -DUSE_COMPAT_IOCTL -Dscsi_execute_async_address 
> > -DPYX_ISCSI_VENDOR='"Linux-iSCSI.org"' 
> > -DIQN_PREFIX='"iqn.2003-01.org.linux-iscsi"'  -DLINUX
> > -DLINUX_SCATTERLIST_HAS_PAGE -DSVN_VSN=\"209\"
> > BASENAME?=FedoraCore-R8-Werewolf.ppc
> > DISTRO?=FEDORA
> > KERNEL?=26
> > KERNEL_DIR?=/lib/modules/2.6.24-06289-g144de36/build
> > KERNEL_INCLUDE_DIR?=/lib/modules/2.6.24-06289-g144de36/source/include
> > KERNEL_SOURCE_DIR?=/lib/modules/2.6.24-06289-g144de36/source
> > KERNEL_VERSION_INFO?=LINUX_KERNEL_26
> > OSTYPE?=LINUX
> > PYX_ISCSI_VERSION?=2.9.0.209
> > RELEASE?=2.6.24-06289-g144de36
> > RELEASES?=ARRAY(0x102052d4)
> > RPM_DIR?=/usr/src/redhat
> > SNMP?=0
> > SYSTEM?=FedoraCore-R8-Werewolf
> > VERSION_IPYXD?=2.9.0.209
> > make -C target clean all
> > make[1]: Entering directory `/usr/src/linux-iscsi/trunk/target/target'
> > rm -f /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_crc.o
> > /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_debug_opcodes.o
> > /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_parameters.o
> > /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_seq_and_pdu_list
> >.o /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_serial.o
> > /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_thread_queue.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_datain_values.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_device.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_discovery.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_erl0.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_erl1.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_erl2.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_feature_obj.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_hba.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_info.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_ioctl.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_linux_proc.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_login.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_nego.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_nodeattrib.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_plugin.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_reportluns.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_scdb.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_seobj.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_tmr.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_tpg.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_transport.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_util.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target.o
> > /usr/src/linux-iscsi/trunk/target/target/div64.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_raid.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_repl.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_iblock.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_pscsi.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_rd.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_file.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_vt.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_mc.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_mib.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_mod.o
> > /usr/src/linux-iscsi/trunk/target/target/iscsi_target_mod.mod.o rm -f
> > iscsi_target_mod.ko iscsi_target_mod.mod.c
> > rm -f .*.cmd ../common/.*.cmd .make_autoconfig *~
> > rm -fr .tmp_versions
> > make -C /lib/modules/2.6.24-06289-g144de36/build
> > SUBDIRS=/usr/src/linux-iscsi/trunk/target/target modules
> > CWD=/usr/src/linux-iscsi/trunk/target/target ARCH=ppc KBUILD_VERBOSE=0
> > make[2]: Entering directory `/usr/src/ps3-linux'
> >   CC [M]  /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_crc.o
> > In file included from include/asm/mmu.h:7,
> >                  from include/asm/lppaca.h:32,
> >                  from include/asm/paca.h:20,
> >                  from include/asm/hw_irq.h:17,
> >                  from include/asm/system.h:9,
> >                  from include/linux/list.h:9,
> >                  from include/linux/preempt.h:11,
> >                  from include/linux/spinlock.h:49,
> >                  from include/linux/mmzone.h:7,
> >                  from include/linux/gfp.h:4,
> >                  from include/linux/slab.h:14,
> >
> > from /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_crc.c:29:
> > include/asm/mmu-hash64.h: In function ‘hpte_encode_v’:
> > include/asm/mmu-hash64.h:213: warning: left shift count >= width of type
> > include/asm/mmu-hash64.h: In function ‘hpte_encode_r’:
> > include/asm/mmu-hash64.h:228: warning: integer constant is too large
> > for ‘unsigned long’ type
> > include/asm/mmu-hash64.h: In function ‘hpt_va’:
> > include/asm/mmu-hash64.h:245: warning: left shift count >= width of type
> > include/asm/mmu-hash64.h:245: warning: integer constant is too large
> > for ‘unsigned long’ type
> > include/asm/mmu-hash64.h: In function ‘hpt_hash’:
> > include/asm/mmu-hash64.h:260: warning: right shift count >= width of type
> > include/asm/mmu-hash64.h:261: warning: integer constant is too large
> > for ‘unsigned long’ type
> > include/asm/mmu-hash64.h:263: warning: integer constant is too large
> > for ‘unsigned long’ type
> > include/asm/mmu-hash64.h: In function ‘get_kernel_vsid’:
> > include/asm/mmu-hash64.h:440: error: ‘SID_SHIFT’ undeclared (first use in
> > this function)
> > include/asm/mmu-hash64.h:440: error: (Each undeclared identifier is
> > reported only once
> > include/asm/mmu-hash64.h:440: error: for each function it appears in.)
> > include/asm/mmu-hash64.h:440: warning: right shift count >= width of type
> > include/asm/mmu-hash64.h:440: warning: left shift count >= width of type
> > include/asm/mmu-hash64.h:440: warning: right shift count >= width of type
> > include/asm/mmu-hash64.h:440: warning: left shift count >= width of type
> > include/asm/mmu-hash64.h:441: error: ‘SID_SHIFT_1T’ undeclared (first use
> > in this function)
> > include/asm/mmu-hash64.h: In function ‘user_segment_size’:
> > include/asm/mmu-hash64.h:448: error: ‘SID_SHIFT_1T’ undeclared (first use
> > in this function)
> > include/asm/mmu-hash64.h: In function ‘get_vsid’:
> > include/asm/mmu-hash64.h:458: error: ‘SID_SHIFT’ undeclared (first use in
> > this function)
> > include/asm/mmu-hash64.h:458: warning: right shift count >= width of type
> > include/asm/mmu-hash64.h:458: warning: left shift count >= width of type
> > include/asm/mmu-hash64.h:458: warning: right shift count >= width of type
> > include/asm/mmu-hash64.h:458: warning: left shift count >= width of type
> > include/asm/mmu-hash64.h:460: error: ‘SID_SHIFT_1T’ undeclared (first use
> > in this function)
> > In file included from include/asm/spinlock.h:25,
> >                  from include/linux/spinlock.h:87,
> >                  from include/linux/mmzone.h:7,
> >                  from include/linux/gfp.h:4,
> >                  from include/linux/slab.h:14,
> >
> > from /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_crc.c:29:
> > include/asm/iseries/hv_call.h: In function ‘HvCall_setVirtualDecr’:
> > include/asm/iseries/hv_call.h:85: warning: integer constant is too large
> > for ‘unsigned long’ type
> > include/asm/iseries/hv_call.h: In function ‘HvCall_yieldProcessor’:
> > include/asm/iseries/hv_call.h:90: warning: integer constant is too large
> > for ‘unsigned long’ type
> > include/asm/iseries/hv_call.h: In function ‘HvCall_setEnabledInterrupts’:
> > include/asm/iseries/hv_call.h:95: warning: integer constant is too large
> > for ‘unsigned long’ type
> > include/asm/iseries/hv_call.h: In
> > function ‘HvCall_setLogBufferFormatAndCodepage’:
> > include/asm/iseries/hv_call.h:101: warning: integer constant is too large
> > for ‘unsigned long’ type
> > include/asm/iseries/hv_call.h: In function ‘HvCall_sendIPI’:
> > include/asm/iseries/hv_call.h:108: warning: integer constant is too large
> > for ‘unsigned long’ type
> > In file included from include/asm/pgtable.h:13,
> >                  from include/linux/mm.h:39,
> >
> > from
> > /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_linux_defs.h:27
> >,
> >
> > from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_crc.h:21,
> >
> > from /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_crc.c:35:
> > include/asm/pgtable-ppc64.h:32:50: warning: "SID_SHIFT" is not defined
> > include/asm/pgtable-ppc64.h:33:2: error: #error TASK_SIZE_USER64 exceeds
> > user VSID range
> > In file included from include/asm/pgtable.h:13,
> >                  from include/linux/mm.h:39,
> >
> > from
> > /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_linux_defs.h:27
> >,
> >
> > from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_crc.h:21,
> >
> > from /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_crc.c:35:
> > include/asm/pgtable-ppc64.h: In function ‘find_linux_pte’:
> > include/asm/pgtable-ppc64.h:429: warning: right shift count >= width of
> > type In file included from include/asm/pgtable.h:40,
> >                  from include/linux/mm.h:39,
> >
> > from
> > /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_linux_defs.h:27
> >,
> >
> > from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_crc.h:21,
> >
> > from /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_crc.c:35:
> > include/asm-generic/pgtable.h: In function ‘pud_none_or_clear_bad’:
> > include/asm-generic/pgtable.h:181: warning: integer constant is too large
> > for ‘unsigned long’ type
> > include/asm-generic/pgtable.h:181: warning: comparison is always false
> > due to limited range of data type
> > include/asm-generic/pgtable.h: In function ‘pmd_none_or_clear_bad’:
> > include/asm-generic/pgtable.h:192: warning: integer constant is too large
> > for ‘unsigned long’ type
> > include/asm-generic/pgtable.h:192: warning: comparison is always false
> > due to limited range of data type
> > In file included
> > from
> > /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_linux_defs.h:27
> >,
> >
> > from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_crc.h:21,
> >
> > from /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_crc.c:35:
> > include/linux/mm.h: In function ‘virt_to_head_page’:
> > include/linux/mm.h:255: warning: integer constant is too large for
> > ‘unsigned long’ type
> > include/linux/mm.h:255: warning: left shift count >= width of type
> > include/linux/mm.h:255: warning: integer constant is too large for
> > ‘unsigned long’ type
> > In file included
> > from
> > /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_linux_defs.h:27
> >,
> >
> > from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_crc.h:21,
> >
> > from /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_crc.c:35:
> > include/linux/mm.h:437:2: error: #error
> > SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH
> >
> > > FLAGS_RESERVED
> >
> > In file included
> > from
> > /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_linux_defs.h:27
> >,
> >
> > from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_crc.h:21,
> >
> > from /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_crc.c:35:
> > include/linux/mm.h: In function ‘lowmem_page_address’:
> > include/linux/mm.h:539: warning: integer constant is too large for
> > ‘unsigned long’ type
> > include/linux/mm.h:539: warning: left shift count >= width of type
> > include/linux/mm.h:539: warning: integer constant is too large for
> > ‘unsigned long’ type
> > include/linux/mm.h:539: warning: cast to pointer from integer of
> > different size
> > In file included from include/linux/highmem.h:4,
> >
> > from
> > /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_linux_defs.h:36
> >,
> >
> > from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_crc.h:21,
> >
> > from /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_crc.c:35:
> > include/linux/fs.h: At top level:
> > include/linux/fs.h:911: warning: ‘struct flock64’ declared inside
> > parameter list
> > include/linux/fs.h:911: warning: its scope is only this definition or
> > declaration, which is probably not what you want
> > include/linux/fs.h:913: warning: ‘struct flock64’ declared inside
> > parameter list
> > In file included from include/asm/cputime.h:26,
> >                  from include/linux/sched.h:67,
> >                  from include/asm/uaccess.h:7,
> >                  from include/linux/uaccess.h:5,
> >                  from include/linux/highmem.h:6,
> >
> > from
> > /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_linux_defs.h:36
> >,
> >
> > from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_crc.h:21,
> >
> > from /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_crc.c:35:
> > include/asm/time.h: In function ‘get_tb’:
> > include/asm/time.h:135: error: implicit declaration of function ‘mftb’
> > In file included from include/linux/uaccess.h:5,
> >                  from include/linux/highmem.h:6,
> >
> > from
> > /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_linux_defs.h:36
> >,
> >
> > from /usr/src/linux-iscsi/trunk/target/target/../include/iscsi_crc.h:21,
> >
> > from /usr/src/linux-iscsi/trunk/target/target/../common/iscsi_crc.c:35:
> > include/asm/uaccess.h: In function ‘copy_from_user’:
> > include/asm/uaccess.h:342: warning: integer constant is too large
> > for ‘unsigned long’ type
> > include/asm/uaccess.h:342: warning: integer constant is too large
> > for ‘unsigned long’ type
> > include/asm/uaccess.h:343: warning: integer constant is too large
> > for ‘unsigned long’ type
> > include/asm/uaccess.h:343: warning: integer constant is too large
> > for ‘unsigned long’ type
> > include/asm/uaccess.h: In function ‘copy_to_user’:
> > include/asm/uaccess.h:357: warning: integer constant is too large
> > for ‘unsigned long’ type
> > include/asm/uaccess.h:357: warning: integer constant is too large
> > for ‘unsigned long’ type
> > include/asm/uaccess.h:358: warning: integer constant is too large
> > for ‘unsigned long’ type
> > include/asm/uaccess.h:358: warning: integer constant is too large
> > for ‘unsigned long’ type
> > include/asm/uaccess.h: In function ‘clear_user’:
> > include/asm/uaccess.h:452: warning: integer constant is too large
> > for ‘unsigned long’ type
> > include/asm/uaccess.h:452: warning: integer constant is too large
> > for ‘unsigned long’ type
> > include/asm/uaccess.h:453: warning: integer constant is too large
> > for ‘unsigned long’ type
> > include/asm/uaccess.h:453: warning: integer constant is too large
> > for ‘unsigned long’ type
> > make[3]: ***
> > [/usr/src/linux-iscsi/trunk/target/target/../common/iscsi_crc.o] Error 1
> > make[2]: *** [_module_/usr/src/linux-iscsi/trunk/target/target] Error 2
> > make[2]: Leaving directory `/usr/src/ps3-linux'
> > make[1]: *** [all] Error 2
> > make[1]: Leaving directory `/usr/src/linux-iscsi/trunk/target/target'
> > make: *** [kernel] Error 2
> >
> > thanks
> >
> > Marc
> >
> > Am Montag 04 Februar 2008 15:17:03 schrieb Nicholas A. Bellinger:
> > > Greetings all,
> > >
> > > I have updated the wiki at:
> > >
> > > http://linux-iscsi.org/index.php/Playstation3/iSCSI
> > >
> > > and posted the first LIO target builds on the LIO Cluster:
> > >
> > > http://linux-iscsi.org/builds/ps3-linux/
> > >
> > > I will adding the documentation for both LIO SE on PS3-Linux, and the
> > > FC8 upgrade process, as the latter can still be a bit challenging for
> > > new users.
> > >
> > > Here is the info from the README:
> > >
> > > LIO Target iSCSI/SE for PS3-Linux v2.9.0.209
> > >
> > > I) Kernel module package
> > >
> > > iscsi-target-module-2.6.24-2.9.0.209-1.powerpc.rpm
> > >
> > > This modules are built for ppc64 and built with the toolkit for Fedora
> > > Core 8 ppc. This is gcc (GCC) 4.1.2 20070925 (Red Hat 4.1.2-33)
> > >
> > > This module has been tested with the latest ps3-linux.git and built
> > > against arch/powerpc/configs/ps3_defconfig.  To use the BD-ROM, your
> > > 2.6.24 kernel must contain ps3rom-use-128-max-sector.diff.  Please see:
> > >
> > > http://git.kernel.org/?p=linux/kernel/git/geoff/ps3-linux.git;a=commit;
> > >h=e8 2112af66a39d11bcb484de9cfa45f0d214c97f
> > >
> > > This module package should work with kernel-2.6.24-20080131.ppc64.rpm
> > > from CELL-Linux-CL_20080201-ADDON.iso, but the BD-ROM will throw an
> > > exception without ps3rom-use-128-max-sector.diff.  Please see the
> > > following link for more information about the ADDON CD, and watch for
> > > an updated kernel package soon..
> > >
> > > http://www.kernel.org/pub/linux/kernel/people/geoff/cell/
> > >
> > > II) Userspace packages
> > >
> > > iscsi-target-tools-2.9.0.209-1.ppc.rpm
> > > sbe-mibs-2.9.0.209-1.ppc.rpm
> > >
> > > Note that these are 32-bit and built on Fedora Core 8.
> > >
> > > Have fun!
> > >
> > > --nab
> > >
> > > _______________________________________________
> > > cbe-oss-dev mailing list
> > > cbe-oss-dev@ozlabs.org
> > > https://ozlabs.org/mailman/listinfo/cbe-oss-dev



-- 
	"We do not want war."
		 Lord Arthur Ponsonby, "Falsehood in Wartime: Propaganda Lies of the First 
World War", 1928
