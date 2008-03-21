Return-Path: <linux-kernel-owner+w=401wt.eu-S1765148AbYCUXRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765148AbYCUXRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763343AbYCUXBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 19:01:04 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:49213 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160AbYCUXBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 19:01:00 -0400
Message-Id: <20080321224412.552492999@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:33 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>, Tony Luck <tony.luck@intel.com>,
       Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>,
       Adrian Bunk <bunk@stusta.de>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Pagano <mpagano@gentoo.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 43/76] moduleparam: fix alpha, ia64 and ppc64 compile failures
Content-Disposition: inline; filename=moduleparam-fix-alpha-ia64-and-ppc64-compile-failures.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

[upstream commit: 91d35dd9]

On alpha, ia64 and ppc64 only relocations to local data can go into
read-only sections. The vast majority of module parameters use the global
generic param_set_*/param_get_* functions, so the 'const' attribute for
struct kernel_param is not only useless, but it also causes compile
failures due to 'section type conflict' in those rare cases where
param_set/get are local functions.

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=8964

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Pagano <mpagano@gentoo.org>
[chrisw@sous-sol.org: backport to 2.6.24.3]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/moduleparam.h |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -62,6 +62,16 @@ struct kparam_array
 	void *elem;
 };
 
+/* On alpha, ia64 and ppc64 relocations to global data cannot go into
+   read-only sections (which is part of respective UNIX ABI on these
+   platforms). So 'const' makes no sense and even causes compile failures
+   with some compilers. */
+#if defined(CONFIG_ALPHA) || defined(CONFIG_IA64) || defined(CONFIG_PPC64)
+#define __moduleparam_const
+#else
+#define __moduleparam_const const
+#endif
+
 /* This is the fundamental function for registering boot/module
    parameters.  perm sets the visibility in sysfs: 000 means it's
    not there, read bits mean it's readable, write bits mean it's
@@ -71,7 +81,7 @@ struct kparam_array
 	static int __param_perm_check_##name __attribute__((unused)) =	\
 	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2));	\
 	static const char __param_str_##name[] = prefix #name;		\
-	static struct kernel_param const __param_##name			\
+	static struct kernel_param __moduleparam_const __param_##name	\
 	__attribute_used__						\
     __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
 	= { __param_str_##name, perm, set, get, { arg } }

-- 
