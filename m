Return-Path: <linux-kernel-owner+w=401wt.eu-S1763901AbXKTSek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763901AbXKTSek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761779AbXKTS1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:27:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51975 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761757AbXKTS1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:27:13 -0500
Date: Tue, 20 Nov 2007 10:24:38 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 20/29] x86: mark read_crX() asm code as volatile
Message-ID: <20071120182438.GV28611@kroah.com>
References: <20071120181733.702234406@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-mark-read-crx-volatile.patch"
In-Reply-To: <20071120182248.GA28611@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Kirill Korotaev <dev@openvz.org>

patch c1217a75ea102d4e69321f210fab60bc47b9a48e in mainline.

x86: mark read_crX() asm code as volatile

Some gcc versions (I checked at least 4.1.1 from RHEL5 & 4.1.2 from gentoo)
can generate incorrect code with read_crX()/write_crX() functions mix up,
due to cached results of read_crX().

The small app for x8664 below compiled with -O2 demonstrates this
(i686 does the same thing):

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-i386/system.h   |    2 +-
 include/asm-x86_64/system.h |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/asm-i386/system.h
+++ b/include/asm-i386/system.h
@@ -141,7 +141,7 @@ static inline unsigned long native_read_
 {
 	unsigned long val;
 	/* This could fault if %cr4 does not exist */
-	asm("1: movl %%cr4, %0		\n"
+	asm volatile("1: movl %%cr4, %0		\n"
 		"2:				\n"
 		".section __ex_table,\"a\"	\n"
 		".long 1b,2b			\n"
--- a/include/asm-x86_64/system.h
+++ b/include/asm-x86_64/system.h
@@ -85,7 +85,7 @@ static inline void write_cr0(unsigned lo
 static inline unsigned long read_cr2(void)
 {
 	unsigned long cr2;
-	asm("movq %%cr2,%0" : "=r" (cr2));
+	asm volatile("movq %%cr2,%0" : "=r" (cr2));
 	return cr2;
 }
 
@@ -97,7 +97,7 @@ static inline void write_cr2(unsigned lo
 static inline unsigned long read_cr3(void)
 { 
 	unsigned long cr3;
-	asm("movq %%cr3,%0" : "=r" (cr3));
+	asm volatile("movq %%cr3,%0" : "=r" (cr3));
 	return cr3;
 }
 
@@ -109,7 +109,7 @@ static inline void write_cr3(unsigned lo
 static inline unsigned long read_cr4(void)
 { 
 	unsigned long cr4;
-	asm("movq %%cr4,%0" : "=r" (cr4));
+	asm volatile("movq %%cr4,%0" : "=r" (cr4));
 	return cr4;
 }
 
@@ -121,7 +121,7 @@ static inline void write_cr4(unsigned lo
 static inline unsigned long read_cr8(void)
 {
 	unsigned long cr8;
-	asm("movq %%cr8,%0" : "=r" (cr8));
+	asm volatile("movq %%cr8,%0" : "=r" (cr8));
 	return cr8;
 }
 

-- 
