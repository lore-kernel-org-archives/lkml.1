Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbYIBQHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbYIBQHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 12:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbYIBQHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 12:07:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:48579 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbYIBQHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 12:07:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=cxRrZ6Xqp4AMU4DBO9k6/OLgl60NkFXqp5b5k4fmJfHaIRN5pqd8gONm9zRFdXTxyq
         bYgaimehNxARENb9uEvgd75hJP3ecfcagvI9chwOLh3nGd424/gXcVv159K9ikOZMIKH
         rLBU76HpzsVdprXOajLWvU0I7Bsfag9Y0QWgg=
Message-ID: <48BD64C1.8000504@panasas.com>
Date: Tue, 02 Sep 2008 19:07:29 +0300
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
Subject: Re: [PATCH 5/5 ver3] debug: BUILD_BUG_ON: error on non-const expressions
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
compilations semantics, and makes BUILD_BUG_ON behave
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
index 90fa975..f882410 100644
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
+#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int: -!!(e); }))
+
+/* Force a compilation error if condition is true */
+#define BUILD_BUG_ON(e) \
+	do { struct {int: -!!(e); } x __maybe_unused; } while (0)
 
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)
-- 
1.5.6.rc1.5.gadf6


