Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbYEaOHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbYEaOHx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 10:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbYEaOHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 10:07:45 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36519 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbYEaOHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 10:07:44 -0400
Date: Sat, 31 May 2008 17:07:34 +0300
From: Adrian Bunk <adrian.bunk@movial.fi>
To: Michael Hennerich <Michael.Hennerich@analog.com>, takata@linux-m32r.org
Cc: linux-m32r@ml.linux-m32r.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6.26 patch] asm-m32r/uaccess.h must #include <asm/setup.h>
Message-ID: <20080531140734.GA7347@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error caused by
commit 4016a1390d07f15b267eecb20e76a48fd5c524ef
(mm/nommu.c: return 0 from kobjsize with invalid objects):

<--  snip  -->

...
  CC      mm/nommu.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/nommu.c: In function 'kobjsize':
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/nommu.c:112: error: 'memory_end' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/nommu.c:112: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/nommu.c:112: error: for each function it appears in.)
make[2]: *** [mm/nommu.o] Error 1

<--  snip  -->

The patch also removes now no longer required memory_{start,end} 
declarations inside access_ok().

Reported-by: Adrian Bunk <adrian.bunk@movial.fi>
Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>

---

There doesn't seem to be any fixed location for memory_{start,end} among 
all architectures, but since mm/nommu.c already has an #include <asm/uaccess.h>
and the non-MMU access_ok anyway needs them this seems to be the logical 
way to fix this compile error.

 include/asm-m32r/uaccess.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

6bf3808a28c19a31ba73c0dad3798e95bddd0fbb diff --git a/include/asm-m32r/uaccess.h b/include/asm-m32r/uaccess.h
index bd8c837..1c7047b 100644
--- a/include/asm-m32r/uaccess.h
+++ b/include/asm-m32r/uaccess.h
@@ -14,6 +14,7 @@
 #include <linux/errno.h>
 #include <linux/thread_info.h>
 #include <asm/page.h>
+#include <asm/setup.h>
 
 #define VERIFY_READ 0
 #define VERIFY_WRITE 1
@@ -106,7 +107,6 @@ static inline void set_fs(mm_segment_t s)
 #else
 static inline int access_ok(int type, const void *addr, unsigned long size)
 {
-	extern unsigned long memory_start, memory_end;
 	unsigned long val = (unsigned long)addr;
 
 	return ((val >= memory_start) && ((val + size) < memory_end));

