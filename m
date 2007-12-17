Return-Path: <linux-kernel-owner+w=401wt.eu-S1760128AbXLQOvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128AbXLQOvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 09:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbXLQOvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 09:51:14 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:10941 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbXLQOvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 09:51:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:message-id;
        b=KlKh0ushUIYv3anIy4Zl/2V7o969K2IN9tkc9MneBEmF7sEmFLOyPZeB710OZlsQmN820NOeUlY+4DuBCEatpbWTs0GO1XHLOx1eYjice22mZthE7A6Ut65tWqGP5u9J59zSitgqnnRRPREwiSFISpUXuwplIQIqwQxvB4uMoHc=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH] smallint: minimum efficiently addressable memory unit
Date: Mon, 17 Dec 2007 06:51:04 -0800
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_YzoZH95uDaKc4pI"
Message-Id: <200712170651.04333.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_YzoZH95uDaKc4pI
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi arch people, Andrew,

Proposed trivial patch introduces smallint type,
which is defined as minimal efficiently addressable
memory unit. It is intended to be primarily used for
flag variables in memory.

Random example. In arch/x86/kernel/vmi_32.c:

static int disable_pge;
static int disable_pse;
static int disable_sep;
static int disable_tsc;
static int disable_mtrr;
static int disable_noidle;
static int disable_vmi_timer;

Not only each of these variables uses 4 bytes of storage
instead of 1, but stores to these variables also use longer
instructions (store of 32-bit constant 0 or 1 on x86
still has 32-bit constant in the instruction encoding).

Therefore, say, disable_noidle alone wastes 12 bytes:
three in a variable itself and 3x3 in three places where 1
is stored into it.

Patch defines smallint to be signed byte for x86.
Other arches are trivial to add.
If arch does not define it, it defaults to int.

Patch contains the following comment which is intended
to explain when this type is useful, and when it is not
(for example, using smallint for local register variable
sometimes confuses gcc, and generated code is slightly worse):

/* Minimum efficiently addressable memory unit.
 * Recommended usage: global flag or enum variables; flag/enum struct members
 * Don't use for: local variables, members of user-visible structs
 * Guaranteed to be at least byte-sized.
 */

Comments from architecture people are sought.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_YzoZH95uDaKc4pI
Content-Type: text/x-diff;
  charset="us-ascii";
  name="smallint.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="smallint.patch"

diff -urpN linux-2.6/include/asm-x86/types.h linux-2.6.smallint/include/asm-x86/types.h
--- linux-2.6/include/asm-x86/types.h	2007-12-14 18:46:36.000000000 +0000
+++ linux-2.6.smallint/include/asm-x86/types.h	2007-12-17 14:28:23.000000000 +0000
@@ -44,6 +44,12 @@ typedef unsigned long long __u64;
 
 #ifndef __ASSEMBLY__
 
+/* For x86, minimum efficiently addressable memory unit is byte */ 
+typedef signed char smallint;
+typedef unsigned char smalluint;
+#define smallint smallint
+#define smalluint smalluint
+
 typedef signed char s8;
 typedef unsigned char u8;
 
diff -urpN linux-2.6/include/linux/types.h linux-2.6.smallint/include/linux/types.h
--- linux-2.6/include/linux/types.h	2007-12-14 18:46:36.000000000 +0000
+++ linux-2.6.smallint/include/linux/types.h	2007-12-17 14:33:46.000000000 +0000
@@ -32,6 +32,18 @@ typedef __kernel_mqd_t		mqd_t;
 #ifdef __KERNEL__
 typedef _Bool			bool;
 
+/* Minimum efficiently addressable memory unit.
+ * Recommended usage: global flag or enum variables; flag/enum struct members
+ * Don't use for: local variables, members of user-visible structs
+ * Guaranteed to be at least byte-sized.
+ */
+#ifndef smallint
+typedef int smallint;
+#endif
+#ifndef smalluint
+typedef unsigned smalluint;
+#endif
+
 typedef __kernel_uid32_t	uid_t;
 typedef __kernel_gid32_t	gid_t;
 typedef __kernel_uid16_t        uid16_t;

--Boundary-00=_YzoZH95uDaKc4pI--
