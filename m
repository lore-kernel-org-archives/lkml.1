Return-Path: <linux-kernel-owner+w=401wt.eu-S1761230AbYG3XhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761230AbYG3XhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 19:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761138AbYG3Xg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 19:36:58 -0400
Received: from mail.suse.de ([195.135.220.2]:35755 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761123AbYG3Xg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 19:36:56 -0400
Date: Wed, 30 Jul 2008 16:27:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Nickolay Vinogradov <nickolay@protei.ru>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [patch 13/29] ARM: fix fls() for 64-bit arguments
Message-ID: <20080730232710.GN30670@suse.de>
References: <20080730231003.655833364@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="arm-fix-fls-for-64-bit-arguments.patch"
In-Reply-To: <20080730232451.GA30670@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Andrew Morton <akpm@linux-foundation.org>

commit 0c65f459ce6c8bd873a61b3ae1e57858ab1debf3 upstream

arm's fls() is implemented as a macro, causing it to misbehave when passed
64-bit arguments.  Fix.

Cc: Nickolay Vinogradov <nickolay@protei.ru>
Tested-by: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-arm/bitops.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/include/asm-arm/bitops.h
+++ b/include/asm-arm/bitops.h
@@ -277,9 +277,16 @@ static inline int constant_fls(int x)
  * the clz instruction for much better code efficiency.
  */
 
-#define fls(x) \
+#define __fls(x) \
 	( __builtin_constant_p(x) ? constant_fls(x) : \
 	  ({ int __r; asm("clz\t%0, %1" : "=r"(__r) : "r"(x) : "cc"); 32-__r; }) )
+
+/* Implement fls() in C so that 64-bit args are suitably truncated */
+static inline int fls(int x)
+{
+	return __fls(x);
+}
+
 #define ffs(x) ({ unsigned long __t = (x); fls(__t & -__t); })
 #define __ffs(x) (ffs(x) - 1)
 #define ffz(x) __ffs( ~(x) )

-- 
