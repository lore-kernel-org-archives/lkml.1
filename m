Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbZJBB45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbZJBB45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbZJBBcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:32:53 -0400
Received: from kroah.org ([198.145.64.141]:33000 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204AbZJBBct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:49 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:10 2009
Message-Id: <20091002012410.183180872@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ian Schram <ischram@telenet.be>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [029/136] perf_counter: Fix perf_copy_attr() pointer arithmetic
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=perf_counter-fix-perf_copy_attr-pointer-arithmetic.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ian Schram <ischram@telenet.be>

commit cdf8073d6b2c6c5a3cd6ce0e6c1297157f7f99ba upstream.

There is still some weird code in per_copy_attr(). Which supposedly
checks that all bytes trailing a struct are zero.

It doesn't seem to get pointer arithmetic right. Since it
increments an iterating pointer by sizeof(unsigned long) rather
than 1.

Signed-off-by: Ian Schram <ischram@telenet.be>
[ v2: clean up the messy PTR_ALIGN logic as well. ]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4AB3DEE2.3030600@telenet.be>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/perf_counter.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -4143,8 +4143,8 @@ done:
 static int perf_copy_attr(struct perf_counter_attr __user *uattr,
 			  struct perf_counter_attr *attr)
 {
-	int ret;
 	u32 size;
+	int ret;
 
 	if (!access_ok(VERIFY_WRITE, uattr, PERF_ATTR_SIZE_VER0))
 		return -EFAULT;
@@ -4169,19 +4169,19 @@ static int perf_copy_attr(struct perf_co
 
 	/*
 	 * If we're handed a bigger struct than we know of,
-	 * ensure all the unknown bits are 0.
+	 * ensure all the unknown bits are 0 - i.e. new
+	 * user-space does not rely on any kernel feature
+	 * extensions we dont know about yet.
 	 */
 	if (size > sizeof(*attr)) {
-		unsigned long val;
-		unsigned long __user *addr;
-		unsigned long __user *end;
-
-		addr = PTR_ALIGN((void __user *)uattr + sizeof(*attr),
-				sizeof(unsigned long));
-		end  = PTR_ALIGN((void __user *)uattr + size,
-				sizeof(unsigned long));
+		unsigned char __user *addr;
+		unsigned char __user *end;
+		unsigned char val;
+
+		addr = (void __user *)uattr + sizeof(*attr);
+		end  = (void __user *)uattr + size;
 
-		for (; addr < end; addr += sizeof(unsigned long)) {
+		for (; addr < end; addr++) {
 			ret = get_user(val, addr);
 			if (ret)
 				return ret;


