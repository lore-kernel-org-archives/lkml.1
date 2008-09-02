Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbYIBP5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbYIBP5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 11:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYIBP5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 11:57:38 -0400
Received: from qb-out-0506.google.com ([72.14.204.227]:41742 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbYIBP5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 11:57:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=jNeAmI3C3U0yANRz3y02Rag20F+3yy+r1f4QwY7cQ4P8YqKj4dwXIaSsGO2mlLjMqn
         HUXU+YdUy4rVKVE7lCHfOKLZJ7jfqtp6siC5y0doOj0FSJkZYusWI2PBhawbavhJVYQK
         Z6BsrIyuxwDvCHzajkr4ejCrbxM6Q8Q0fUdQM=
Message-ID: <48BD626B.6070705@panasas.com>
Date: Tue, 02 Sep 2008 18:57:31 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       "David S. Miller" <davem@davemloft.net>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5 ver2] debug: BUILD_BUG_ON: error on non-const expressions
References: <48BBE77D.7070007@panasas.com> <48BBEE04.30903@panasas.com>
In-Reply-To: <48BBEE04.30903@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix BUILD_BUG_ON to not silently drop non-compile-time
visible expressions. It will now produce a compilation
error if so.

The code to BUILD_BUG_ON_ZERO was done by:
Jan Beulich <jbeulich@novell.com>

The code to BUILD_BUG_ON is a small variation to Jan's
code inspired by Rusty Russell. Which gives me better
compilation semantics, and makes BUILD_BUG_ON behave
more like BUG_ON.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
TO: Jan Beulich <jbeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Theodore Tso <tytso@mit.edu>
CC: David S. Miller <davem@davemloft.net>
---
 include/linux/compiler.h |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 90fa975..23dc269 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -194,14 +194,15 @@ extern void __chk_io_ptr(const volatile void __iomem *);
  */
 #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
 
-/* Force a compilation error if condition is true */
-#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
-
 /* Force a compilation error if condition is true, but also produce a
    result (of value 0 and type size_t), so the expression can be used
-   e.g. in a structure initializer (or where-ever else comma expressions
+   e.g. in a structure initializer (or where-ever full statements
    aren't permitted). */
-#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
+#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
+
+/* Force a compilation error if condition is true */
+#define BUILD_BUG_ON(e) \
+	do { struct {int:-!!(e); } x __maybe_unused;} while(0)
 
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)
-- 
1.5.6.rc1.5.gadf6


