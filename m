Return-Path: <linux-kernel-owner+w=401wt.eu-S934155AbZDHP34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934155AbZDHP34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933905AbZDHP1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:27:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:52441 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933089AbZDHP1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:27:08 -0400
Date: Wed, 8 Apr 2009 15:25:51 GMT
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       zhaolei@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, zhaolei@cn.fujitsu.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <49CC9739.30107@cn.fujitsu.com>
References: <49CC9739.30107@cn.fujitsu.com>
Subject: [tip:core/printk] printk: add support of hh length modifier for printk
Message-ID: <tip-a4e94ef0dd391eae05bdeacd12b8da3510957a97@git.kernel.org>
Git-Commit-ID: a4e94ef0dd391eae05bdeacd12b8da3510957a97
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 15:25:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a4e94ef0dd391eae05bdeacd12b8da3510957a97
Gitweb:     http://git.kernel.org/tip/a4e94ef0dd391eae05bdeacd12b8da3510957a97
Author:     Zhaolei <zhaolei@cn.fujitsu.com>
AuthorDate: Fri, 27 Mar 2009 17:07:05 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 17:04:30 +0200

printk: add support of hh length modifier for printk

Impact: new feature, extend vsprintf format strings

hh is used as length modifier for signed char or unsigned char.
It is supported by glibc, we add kernel support now.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: torvalds@linux-foundation.org
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <49CC9739.30107@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 lib/vsprintf.c |   37 ++++++++++++++++++++++++++++++++-----
 1 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 7536ace..b56f6d0 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -408,6 +408,8 @@ enum format_type {
 	FORMAT_TYPE_LONG_LONG,
 	FORMAT_TYPE_ULONG,
 	FORMAT_TYPE_LONG,
+	FORMAT_TYPE_UBYTE,
+	FORMAT_TYPE_BYTE,
 	FORMAT_TYPE_USHORT,
 	FORMAT_TYPE_SHORT,
 	FORMAT_TYPE_UINT,
@@ -853,11 +855,15 @@ qualifier:
 	spec->qualifier = -1;
 	if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L' ||
 	    *fmt == 'Z' || *fmt == 'z' || *fmt == 't') {
-		spec->qualifier = *fmt;
-		++fmt;
-		if (spec->qualifier == 'l' && *fmt == 'l') {
-			spec->qualifier = 'L';
-			++fmt;
+		spec->qualifier = *fmt++;
+		if (unlikely(spec->qualifier == *fmt)) {
+			if (spec->qualifier == 'l') {
+				spec->qualifier = 'L';
+				++fmt;
+			} else if (spec->qualifier == 'h') {
+				spec->qualifier = 'H';
+				++fmt;
+			}
 		}
 	}
 
@@ -919,6 +925,11 @@ qualifier:
 		spec->type = FORMAT_TYPE_SIZE_T;
 	} else if (spec->qualifier == 't') {
 		spec->type = FORMAT_TYPE_PTRDIFF;
+	} else if (spec->qualifier == 'H') {
+		if (spec->flags & SIGN)
+			spec->type = FORMAT_TYPE_BYTE;
+		else
+			spec->type = FORMAT_TYPE_UBYTE;
 	} else if (spec->qualifier == 'h') {
 		if (spec->flags & SIGN)
 			spec->type = FORMAT_TYPE_SHORT;
@@ -1087,6 +1098,12 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 			case FORMAT_TYPE_PTRDIFF:
 				num = va_arg(args, ptrdiff_t);
 				break;
+			case FORMAT_TYPE_UBYTE:
+				num = (unsigned char) va_arg(args, int);
+				break;
+			case FORMAT_TYPE_BYTE:
+				num = (signed char) va_arg(args, int);
+				break;
 			case FORMAT_TYPE_USHORT:
 				num = (unsigned short) va_arg(args, int);
 				break;
@@ -1363,6 +1380,10 @@ do {									\
 			case FORMAT_TYPE_PTRDIFF:
 				save_arg(ptrdiff_t);
 				break;
+			case FORMAT_TYPE_UBYTE:
+			case FORMAT_TYPE_BYTE:
+				save_arg(char);
+				break;
 			case FORMAT_TYPE_USHORT:
 			case FORMAT_TYPE_SHORT:
 				save_arg(short);
@@ -1538,6 +1559,12 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
 			case FORMAT_TYPE_PTRDIFF:
 				num = get_arg(ptrdiff_t);
 				break;
+			case FORMAT_TYPE_UBYTE:
+				num = get_arg(unsigned char);
+				break;
+			case FORMAT_TYPE_BYTE:
+				num = get_arg(signed char);
+				break;
 			case FORMAT_TYPE_USHORT:
 				num = get_arg(unsigned short);
 				break;
