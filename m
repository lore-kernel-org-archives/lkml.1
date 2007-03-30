Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbXC3VU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbXC3VU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbXC3VKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:10:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58239 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbXC3VJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:09:55 -0400
Date: Fri, 30 Mar 2007 14:04:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Dike <jdike@addtoit.com>,
       Paolo Blaisorblade Giarrusso <blaisorblade@yahoo.it>
Subject: [patch 08/37] uml: fix unreasonably long udelay
Message-ID: <20070330210419.GJ29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="uml-fix-unreasonably-long-udelay.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>

Currently we have a confused udelay implementation.

* __const_udelay does not accept usecs but xloops in i386 and x86_64
* our implementation requires usecs as arg
* it gets a xloops count when called by asm/arch/delay.h

Bugs related to this (extremely long shutdown times) where reported by some
x86_64 users, especially using Device Mapper.

To hit this bug, a compile-time constant time parameter must be passed - that's
why UML seems to work most times.
Fix this with a simple udelay implementation.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/sys-i386/delay.c   |   11 -----------
 arch/um/sys-x86_64/delay.c |   11 -----------
 include/asm-um/delay.h     |   17 ++++++++++++++---
 3 files changed, 14 insertions(+), 25 deletions(-)

--- a/arch/um/sys-i386/delay.c
+++ b/arch/um/sys-i386/delay.c
@@ -27,14 +27,3 @@ void __udelay(unsigned long usecs)
 }
 
 EXPORT_SYMBOL(__udelay);
-
-void __const_udelay(unsigned long usecs)
-{
-	int i, n;
-
-	n = (loops_per_jiffy * HZ * usecs) / MILLION;
-        for(i=0;i<n;i++)
-                cpu_relax();
-}
-
-EXPORT_SYMBOL(__const_udelay);
--- a/arch/um/sys-x86_64/delay.c
+++ b/arch/um/sys-x86_64/delay.c
@@ -28,14 +28,3 @@ void __udelay(unsigned long usecs)
 }
 
 EXPORT_SYMBOL(__udelay);
-
-void __const_udelay(unsigned long usecs)
-{
-	unsigned long i, n;
-
-	n = (loops_per_jiffy * HZ * usecs) / MILLION;
-        for(i=0;i<n;i++)
-                cpu_relax();
-}
-
-EXPORT_SYMBOL(__const_udelay);
--- a/include/asm-um/delay.h
+++ b/include/asm-um/delay.h
@@ -1,9 +1,20 @@
 #ifndef __UM_DELAY_H
 #define __UM_DELAY_H
 
-#include "asm/arch/delay.h"
-#include "asm/archparam.h"
-
 #define MILLION 1000000
 
+/* Undefined on purpose */
+extern void __bad_udelay(void);
+
+extern void __udelay(unsigned long usecs);
+extern void __delay(unsigned long loops);
+
+#define udelay(n) ((__builtin_constant_p(n) && (n) > 20000) ? \
+	__bad_udelay() : __udelay(n))
+
+/* It appears that ndelay is not used at all for UML, and has never been
+ * implemented. */
+extern void __unimplemented_ndelay(void);
+#define ndelay(n) __unimplemented_ndelay()
+
 #endif

-- 
