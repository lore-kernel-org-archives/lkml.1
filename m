Return-Path: <linux-kernel-owner+w=401wt.eu-S1752386Ab0AEJtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab0AEJtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 04:49:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486Ab0AEJtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 04:49:01 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:45633 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab0AEJtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 04:49:00 -0500
Date: Tue, 5 Jan 2010 10:48:57 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: strict copy_from_user checks issues?
Message-ID: <20100105094857.GB5480@osiris.boeblingen.de.ibm.com>
References: <20100104154345.GA5671@osiris.boeblingen.de.ibm.com>
 <20100104174308.0790757c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100104174308.0790757c@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 04, 2010 at 05:43:08PM -0800, Arjan van de Ven wrote:
> On Mon, 4 Jan 2010 16:43:45 +0100
> Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > x86 and sparc return -EFAULT in copy_from_user instead of the number
> > of not copied bytes as it should in case of a detected buffer
> > overflow. That might have unwanted side effects. I would guess that
> > is a bug.
> 
> killing the bad guy in case of a real buffer overflow is appropriate..
> this should never trigger for legitimate users.

The point I tried to make is that no caller of copy_from_user can assume
that it would ever return -EFAULT. And if any caller does so it is broken.
But then again it probably doesn't matter in this case as long as something
!= 0 is returned.

> > Warnings cannot be switched off anymore as it was the case in your
> > first version. However gcc seems to report quite a few false
> > positives so it would be good if it could be turned off again.
> 
> hmm I thought most got fixed.. I'd be surprised if this part is
> architecture specific.....
> I rather fix the few cases left than disable the warning to be honest.
> It's not many, at least not on x86.

An allyesconfig triggers 52 warnings on s390 (see below). I just checked
a few but all of them looked like false positives.

This is the patch I currently have for s390. Only differences to x86 and
sparc are the return code handling and that an allyesconfig will trigger
warnings instead of compile breakages.

---
 arch/s390/Kconfig.debug         |   25 +++++++++++++++++++++++++
 arch/s390/include/asm/uaccess.h |   14 ++++++++++++++
 arch/s390/lib/Makefile          |    2 +-
 arch/s390/lib/usercopy.c        |    8 ++++++++
 4 files changed, 48 insertions(+), 1 deletion(-)

--- a/arch/s390/include/asm/uaccess.h
+++ b/arch/s390/include/asm/uaccess.h
@@ -265,6 +265,14 @@ __copy_from_user(void *to, const void __
 		return uaccess.copy_from_user(n, from, to);
 }
 
+extern void copy_from_user_overflow(void)
+#ifdef CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
+__compiletime_warning("copy_from_user() buffer size is not provably correct")
+#else
+__compiletime_error("copy_from_user() buffer size is not provably correct")
+#endif
+;
+
 /**
  * copy_from_user: - Copy a block of data from user space.
  * @to:   Destination address, in kernel space.
@@ -284,7 +292,13 @@ __copy_from_user(void *to, const void __
 static inline unsigned long __must_check
 copy_from_user(void *to, const void __user *from, unsigned long n)
 {
+	unsigned int sz = __compiletime_object_size(to);
+
 	might_fault();
+	if (unlikely(sz != -1 && sz < n)) {
+		copy_from_user_overflow();
+		return n;
+	}
 	if (access_ok(VERIFY_READ, from, n))
 		n = __copy_from_user(to, from, n);
 	else
--- a/arch/s390/Kconfig.debug
+++ b/arch/s390/Kconfig.debug
@@ -6,4 +6,29 @@ config TRACE_IRQFLAGS_SUPPORT
 
 source "lib/Kconfig.debug"
 
+choice
+	prompt "Strict copy size checks"
+	depends on DEBUG_KERNEL && !TRACE_BRANCH_PROFILING
+
+config DEBUG_STRICT_USER_COPY_CHECKS
+	bool "Enabled - compile time warnings"
+	---help---
+	  Enabling this option adds a certain set of sanity checks for user
+	  copy operations.
+
+	  The copy_from_user() etc checks are there to help test if there
+	  are sufficient security checks on the length argument of
+	  the copy operation, by having gcc prove that the argument is
+	  within bounds.
+	  If gcc cannot prove that security checks are sufficient runtime
+	  checks will be added.
+
+config DEBUG_STRICT_USER_COPY_CHECKS_WARN
+	bool "Enabled - compile time errors"
+	---help---
+	  Enabling this option turns a certain set of sanity checks for user
+	  copy operations into compile time warnings.
+
+endchoice
+
 endmenu
--- a/arch/s390/lib/Makefile
+++ b/arch/s390/lib/Makefile
@@ -2,7 +2,7 @@
 # Makefile for s390-specific library files..
 #
 
-lib-y += delay.o string.o uaccess_std.o uaccess_pt.o
+lib-y += delay.o string.o uaccess_std.o uaccess_pt.o usercopy.o
 obj-$(CONFIG_32BIT) += div64.o qrnnd.o ucmpdi2.o
 lib-$(CONFIG_64BIT) += uaccess_mvcos.o
 lib-$(CONFIG_SMP) += spinlock.o
--- /dev/null
+++ b/arch/s390/lib/usercopy.c
@@ -0,0 +1,8 @@
+#include <linux/module.h>
+#include <linux/bug.h>
+
+void copy_from_user_overflow(void)
+{
+	WARN(1, "Buffer overflow detected!\n");
+}
+EXPORT_SYMBOL(copy_from_user_overflow);


Warnings generated with an allyesconfig build:

In file included from /home2/heicarst/cfu/arch/s390/include/asm/mmu_context.h:13,
                 from /home2/heicarst/cfu/arch/s390/include/asm/elf.h:133,
                 from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from fs/debugfs/file.c:16:
In function 'copy_from_user',
    inlined from 'write_file_bool' at fs/debugfs/file.c:415:
/home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In file included from /home2/heicarst/cfu/arch/s390/include/asm/mmu_context.h:13,
                 from /home2/heicarst/cfu/arch/s390/include/asm/elf.h:133,
                 from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from kernel/kprobes.c:39:
In function 'copy_from_user',
    inlined from 'write_enabled_file_bool' at kernel/kprobes.c:1527:
/home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In file included from /home2/heicarst/cfu/arch/s390/include/asm/mmu_context.h:13,
                 from /home2/heicarst/cfu/arch/s390/include/asm/elf.h:133,
                 from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from drivers/s390/crypto/zcrypt_api.c:30:
In function 'copy_from_user',
    inlined from 'zcrypt_rsa_crt' at drivers/s390/crypto/zcrypt_api.c:401:
/home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In file included from /home2/heicarst/cfu/arch/s390/include/asm/mmu_context.h:13,
                 from /home2/heicarst/cfu/arch/s390/include/asm/elf.h:133,
                 from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from include/linux/sysdev.h:25,
                 from include/linux/cpu.h:22,
                 from kernel/perf_event.c:14:
In function 'copy_from_user',
    inlined from 'perf_copy_attr' at kernel/perf_event.c:4563,
    inlined from 'SYSC_perf_event_open' at kernel/perf_event.c:4668,
    inlined from 'SyS_perf_event_open' at kernel/perf_event.c:4653:
/home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In file included from /home2/heicarst/cfu/arch/s390/include/asm/mmu_context.h:13,
                 from /home2/heicarst/cfu/arch/s390/include/asm/elf.h:133,
                 from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from drivers/net/tun.c:42:
In function 'copy_from_user',
    inlined from '__tun_chr_ioctl' at drivers/net/tun.c:1124:
/home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In file included from /home2/heicarst/cfu/arch/s390/include/asm/mmu_context.h:13,
                 from /home2/heicarst/cfu/arch/s390/include/asm/elf.h:133,
                 from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from net/can/raw.c:44:
In function 'copy_from_user',
    inlined from 'raw_setsockopt' at net/can/raw.c:447:
/home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In file included from /home2/heicarst/cfu/arch/s390/include/asm/mmu_context.h:13,
                 from /home2/heicarst/cfu/arch/s390/include/asm/elf.h:133,
                 from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from net/core/pktgen.c:120:
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:866:
/home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1084:
/home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1185:
/home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1207:
/home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1231:
/home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1254:
/home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1277:
/home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1298:
/home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1319:
/home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1340:
/home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1367:
/home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1409:
/home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_thread_write' at net/core/pktgen.c:1739:
/home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_thread_write' at net/core/pktgen.c:1770:
/home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In file included from /home2/heicarst/cfu/arch/s390/include/asm/mmu_context.h:13,
                 from /home2/heicarst/cfu/arch/s390/include/asm/elf.h:133,
                 from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from drivers/scsi/sg.c:31:
In function 'copy_from_user',
    inlined from 'sg_proc_write_dressz' at drivers/scsi/sg.c:2381:
/home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'sg_proc_write_adio' at drivers/scsi/sg.c:2358:
/home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In file included from /home2/heicarst/cfu/arch/s390/include/asm/mmu_context.h:13,
                 from /home2/heicarst/cfu/arch/s390/include/asm/elf.h:133,
                 from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from include/linux/textsearch.h:7,
                 from include/linux/skbuff.h:27,
                 from include/linux/if_ether.h:124,
                 from include/linux/netdevice.h:29,
                 from net/packet/af_packet.c:58:
In function 'copy_from_user',
    inlined from 'packet_getsockopt' at net/packet/af_packet.c:1880:
/home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In file included from /home2/heicarst/cfu/arch/s390/include/asm/mmu_context.h:13,
                 from /home2/heicarst/cfu/arch/s390/include/asm/elf.h:133,
                 from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from net/netfilter/ipvs/ip_vs_ctl.c:24:
In function 'copy_from_user',
    inlined from 'do_ip_vs_get_ctl' at net/netfilter/ipvs/ip_vs_ctl.c:2365:
/home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'do_ip_vs_set_ctl' at net/netfilter/ipvs/ip_vs_ctl.c:2086:
/home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In file included from /home2/heicarst/cfu/arch/s390/include/asm/mmu_context.h:13,
                 from /home2/heicarst/cfu/arch/s390/include/asm/elf.h:133,
                 from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from include/linux/textsearch.h:7,
                 from include/linux/skbuff.h:27,
                 from include/linux/icmpv6.h:82,
                 from net/compat.c:18:
In function 'copy_from_user',
    inlined from 'compat_sys_socketcall' at net/compat.c:785:
/home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
