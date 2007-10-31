Return-Path: <linux-kernel-owner+w=401wt.eu-S1760076AbXJaWVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760076AbXJaWVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbXJaWVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:21:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbXJaWVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:21:42 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, kvm-devel@lists.sourceforge.net, zach@vmware.com,
       tglx@linutronix.de, jun.nakajima@intel.com, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 12/16] tweak io_64.h for paravirt.
Date: Wed, 31 Oct 2007 16:14:57 -0300
Message-Id: <11938581663639-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11938581612389-git-send-email-gcosta@redhat.com>
References: <1193858101367-git-send-email-gcosta@redhat.com> <11938581073775-git-send-email-gcosta@redhat.com> <11938581133479-git-send-email-gcosta@redhat.com> <1193858118284-git-send-email-gcosta@redhat.com> <11938581242810-git-send-email-gcosta@redhat.com> <1193858130443-git-send-email-gcosta@redhat.com> <11938581351064-git-send-email-gcosta@redhat.com> <11938581403478-git-send-email-gcosta@redhat.com> <11938581451804-git-send-email-gcosta@redhat.com> <11938581512730-git-send-email-gcosta@redhat.com> <11938581562552-git-send-email-gcosta@redhat.com> <11938581612389-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We need something here because we can't call in and out instructions
directly. However, we have to be careful, because no indirections are
allowed in misc_64.c , and paravirt_ops is a kind of one. So just
call it directly there

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/boot/compressed/misc_64.c |    6 +++++
 include/asm-x86/io_64.h            |   37 +++++++++++++++++++++++++++++------
 2 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/arch/x86/boot/compressed/misc_64.c b/arch/x86/boot/compressed/misc_64.c
index 6ea015a..6640a17 100644
--- a/arch/x86/boot/compressed/misc_64.c
+++ b/arch/x86/boot/compressed/misc_64.c
@@ -9,6 +9,12 @@
  * High loaded stuff by Hans Lermen & Werner Almesberger, Feb. 1996
  */
 
+/*
+ * we have to be careful, because no indirections are allowed here, and
+ * paravirt_ops is a kind of one. As it will only run in baremetal anyway,
+ * we just keep it from happening
+ */
+#undef CONFIG_PARAVIRT
 #define _LINUX_STRING_H_ 1
 #define __LINUX_BITMAP_H 1
 
diff --git a/include/asm-x86/io_64.h b/include/asm-x86/io_64.h
index a037b07..57fcdd9 100644
--- a/include/asm-x86/io_64.h
+++ b/include/asm-x86/io_64.h
@@ -35,12 +35,24 @@
   *  - Arnaldo Carvalho de Melo <acme@conectiva.com.br>
   */
 
-#define __SLOW_DOWN_IO "\noutb %%al,$0x80"
+static inline void native_io_delay(void)
+{
+	asm volatile("outb %%al,$0x80" : : : "memory");
+}
 
-#ifdef REALLY_SLOW_IO
-#define __FULL_SLOW_DOWN_IO __SLOW_DOWN_IO __SLOW_DOWN_IO __SLOW_DOWN_IO __SLOW_DOWN_IO
+#if defined(CONFIG_PARAVIRT)
+#include <asm/paravirt.h>
 #else
-#define __FULL_SLOW_DOWN_IO __SLOW_DOWN_IO
+
+static inline void slow_down_io(void)
+{
+	native_io_delay();
+#ifdef REALLY_SLOW_IO
+	native_io_delay();
+	native_io_delay();
+	native_io_delay();
+#endif
+}
 #endif
 
 /*
@@ -52,9 +64,15 @@ static inline void out##s(unsigned x value, unsigned short port) {
 #define __OUT2(s,s1,s2) \
 __asm__ __volatile__ ("out" #s " %" s1 "0,%" s2 "1"
 
+#ifndef REALLY_SLOW_IO
+#define REALLY_SLOW_IO
+#define UNSET_REALLY_SLOW_IO
+#endif
+
 #define __OUT(s,s1,x) \
 __OUT1(s,x) __OUT2(s,s1,"w") : : "a" (value), "Nd" (port)); } \
-__OUT1(s##_p,x) __OUT2(s,s1,"w") __FULL_SLOW_DOWN_IO : : "a" (value), "Nd" (port));} \
+__OUT1(s##_p, x) __OUT2(s, s1, "w") : : "a" (value), "Nd" (port)); \
+		slow_down_io(); }
 
 #define __IN1(s) \
 static inline RETURN_TYPE in##s(unsigned short port) { RETURN_TYPE _v;
@@ -63,8 +81,13 @@ static inline RETURN_TYPE in##s(unsigned short port) { RETURN_TYPE _v;
 __asm__ __volatile__ ("in" #s " %" s2 "1,%" s1 "0"
 
 #define __IN(s,s1,i...) \
-__IN1(s) __IN2(s,s1,"w") : "=a" (_v) : "Nd" (port) ,##i ); return _v; } \
-__IN1(s##_p) __IN2(s,s1,"w") __FULL_SLOW_DOWN_IO : "=a" (_v) : "Nd" (port) ,##i ); return _v; } \
+__IN1(s) __IN2(s, s1, "w") : "=a" (_v) : "Nd" (port), ##i); return _v; } \
+__IN1(s##_p) __IN2(s, s1, "w") : "=a" (_v) : "Nd" (port), ##i);	  \
+				slow_down_io(); return _v; }
+
+#ifdef UNSET_REALLY_SLOW_IO
+#undef REALLY_SLOW_IO
+#endif
 
 #define __INS(s) \
 static inline void ins##s(unsigned short port, void * addr, unsigned long count) \
-- 
1.4.4.2

