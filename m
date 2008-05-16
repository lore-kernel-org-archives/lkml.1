Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbYEPMsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbYEPMsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 08:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYEPMsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 08:48:15 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:35857 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754068AbYEPMsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 08:48:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4EAOceLUhMROPA/2dsb2JhbACBVaxD
Date: Fri, 16 May 2008 08:48:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] Fix immediate asm constraint for gcc 3 x86_64
Message-ID: <20080516124811.GC4226@Krystal>
References: <482AB6C5.4060604@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <482AB6C5.4060604@goop.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:17:42 up 77 days,  7:28,  2 users,  load average: 0.16, 0.42,
	0.35
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> I'm getting this when I build for x86-64 with
>
> jeremy@cosworth:~/hg/xen/paravirt/linux-x86_64$ gcc -v
> Reading specs from /usr/lib/gcc/x86_64-linux/3.4.4/specs
> Configured with: ../src/configure -v 
> --enable-languages=c,c++,java,f77,pascal,objc,ada,treelang --prefix=/usr 
> --libexecdir=/usr/lib --with-gxx-include-dir=/usr/include/c++/3.4 
> --enable-shared --with-system-zlib --enable-nls --without-included-gettext 
> --program-suffix=-3.4 --enable-__cxa_atexit --enable-libstdcxx-allocator=mt 
> --enable-clocale=gnu --enable-libstdcxx-debug --enable-java-gc=boehm 
> --enable-java-awt=gtk --disable-werror x86_64-linux
> Thread model: posix
> gcc version 3.4.4 20050314 (prerelease) (Debian 3.4.3-13)
>
>
>  CC      kernel/sched.o
> /home/jeremy/hg/xen/paravirt/linux/kernel/sched_trace.h: In function 
> `wait_task_inactive':
> /home/jeremy/hg/xen/paravirt/linux/kernel/sched_trace.h:5: warning: asm 
> operand 1 probably doesn't match constraints
> /home/jeremy/hg/xen/paravirt/linux/kernel/sched_trace.h:5: error: 
> impossible constraint in `asm'
> /home/jeremy/hg/xen/paravirt/linux/kernel/sched_trace.h:5: warning: 'value' 
> might be used uninitialized in this function
> /home/jeremy/hg/xen/paravirt/linux/kernel/sched.c: At top level:
> /home/jeremy/hg/xen/paravirt/linux/kernel/sched_fair.c:1167: warning: 
> 'wakeup_preempt_entity' defined but not used
> make[3]: *** [kernel/sched.o] Error 1
>
>

It seems that include/asm-x86/immediate.h in sched-devel.git causes
this. gcc-3.4 does not seem to like the "i" (&name##__imv) constraint. I
have seen no such problem with gcc-4.1. This is weird. It seems that
relaxing the constraint helps fixing this, but it's not clear whether
fixing the code or gcc-3.4 is the correct solution... here is the fix :

Fix immediate asm constraint for gcc 3 x86_64

make CC=gcc-3.4 HOSTCC=gcc-3.4 causes this problem with immediate values on
x86_64 :

kernel/sched_trace.h: In function `wait_task_inactive':
kernel/sched_trace.h:5: warning: asm operand 1 probably doesn't match constraints
kernel/sched_trace.h:5: error: impossible constraint in `asm'
kernel/sched_trace.h:5: warning: 'value' might be used uninitialized in this function
make[1]: *** [kernel/sched.o] Error 1
make: *** [kernel/] Error 2

gcc-4.1 does not have this problem.

Fix this by changing the "i" (&name##__imv) for a "g" (&name##__imv) constraint.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>
---
 include/asm-x86/immediate.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6-sched-devel/include/asm-x86/immediate.h
===================================================================
--- linux-2.6-sched-devel.orig/include/asm-x86/immediate.h	2008-05-16 05:07:55.000000000 -0400
+++ linux-2.6-sched-devel/include/asm-x86/immediate.h	2008-05-16 05:08:29.000000000 -0400
@@ -63,7 +63,7 @@
 				"mov $0,%0\n\t"				\
 				"3:\n\t"				\
 				: "=q" (value)				\
-				: "i" (&name##__imv),			\
+				: "g" (&name##__imv),			\
 				  "i" (sizeof(value)));			\
 			break;						\
 		case 2:							\
@@ -81,7 +81,7 @@
 				"mov $0,%0\n\t"				\
 				"3:\n\t"				\
 				: "=r" (value)				\
-				: "i" (&name##__imv),			\
+				: "g" (&name##__imv),			\
 				  "i" (sizeof(value)));			\
 			break;						\
 		case 8:							\
@@ -102,7 +102,7 @@
 				"mov $0xFEFEFEFE01010101,%0\n\t" 	\
 				"3:\n\t"				\
 				: "=r" (value)				\
-				: "i" (&name##__imv),			\
+				: "g" (&name##__imv),			\
 				  "i" (sizeof(value)));			\
 			break;						\
 		};							\
@@ -143,7 +143,7 @@
 			"mov $0,%0\n\t"					\
 			"3:\n\t"					\
 			: "=a" (value)					\
-			: "i" (&name##__imv),				\
+			: "g" (&name##__imv),				\
 			  "i" (sizeof(value)),				\
 			  "i" (sizeof(__typeof__(name##__imv))));	\
 		value;							\




> Turning CONFIG_MARKER off avoids the problem.
>
>    J

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
