Return-Path: <linux-kernel-owner+w=401wt.eu-S1760142AbXK1Nds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142AbXK1Nds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 08:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbXK1Ndi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 08:33:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:64432 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbXK1Ndh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 08:33:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: 2.6.24-rc3-mm2 - Build Failure on powerpc timerfd() undeclared
Date: Wed, 28 Nov 2007 14:32:07 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>
References: <20071128034140.648383f0.akpm@linux-foundation.org> <474D61CF.6080400@linux.vnet.ibm.com>
In-Reply-To: <474D61CF.6080400@linux.vnet.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711281432.09178.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX191VRdsYI4+as2ssaVAUjCo6YB2OtWUomI/ysf
 fZSsI8S4HUVhZbbVwL6wO6p5whWfcmRnvG79QuTubufQQ1CNo7
 R/yV1wG1xELT8Zf+FnhuQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 November 2007, Kamalesh Babulal wrote:
> Kernel build fails, with build error
> 
>   CC      arch/powerpc/platforms/cell/spu_callbacks.o
> In file included from arch/powerpc/platforms/cell/spu_callbacks.c:49:
> include/asm/systbl.h:312: error: ‘sys_timerfd’ undeclared here (not in a function)
> make[2]: *** [arch/powerpc/platforms/cell/spu_callbacks.o] Error 1
> make[1]: *** [arch/powerpc/platforms/cell] Error 2
> make: *** [arch/powerpc/platforms] Error 2
> 

I guess all architectures except x86 are currently broken because they
reference the old sys_timerfd function. This patch should add the missing
bits to powerpc.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

---

Disclaimer: Not tested at all, just applied common sense.
Disclaimer2: conflicts with the sys_indirect kernel implementation
sent by paulus last week.

diff --git a/include/asm-powerpc/systbl.h b/include/asm-powerpc/systbl.h
index 11d5383..b029368 100644
--- a/include/asm-powerpc/systbl.h
+++ b/include/asm-powerpc/systbl.h
@@ -309,7 +309,9 @@ SYSCALL_SPU(getcpu)
 COMPAT_SYS(epoll_pwait)
 COMPAT_SYS_SPU(utimensat)
 COMPAT_SYS_SPU(signalfd)
-COMPAT_SYS_SPU(timerfd)
+COMPAT_SYS_SPU(timerfd_create)
 SYSCALL_SPU(eventfd)
 COMPAT_SYS_SPU(sync_file_range2)
 COMPAT_SYS(fallocate)
+COMPAT_SYS_SPU(sys_timerfd_settime)
+COMPAT_SYS_SPU(sys_timerfd_gettime)
diff --git a/include/asm-powerpc/unistd.h b/include/asm-powerpc/unistd.h
index 97d82b6..4ba2d20 100644
--- a/include/asm-powerpc/unistd.h
+++ b/include/asm-powerpc/unistd.h
@@ -328,14 +328,16 @@
 #define __NR_epoll_pwait	303
 #define __NR_utimensat		304
 #define __NR_signalfd		305
-#define __NR_timerfd		306
+#define __NR_timerfd_create	306
 #define __NR_eventfd		307
 #define __NR_sync_file_range2	308
 #define __NR_fallocate		309
+#define __NR_sys_timerfd_settime 310
+#define __NR_sys_timerfd_gettime 311
 
 #ifdef __KERNEL__
 
-#define __NR_syscalls		310
+#define __NR_syscalls		312
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
