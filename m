Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbZJDVbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbZJDVbK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 17:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758031AbZJDVbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 17:31:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:52135 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758023AbZJDVbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 17:31:07 -0400
Subject: Re: F_SETOWN_EX and F_GETLK64 conflict
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Joseph S. Myers" <joseph@codesourcery.com>
Cc: linux-api@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <onestero@redhat.com>,
       Stephane Eranian <eranian@googlemail.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0910041229300.20203@digraph.polyomino.org.uk>
References: <Pine.LNX.4.64.0910041229300.20203@digraph.polyomino.org.uk>
Content-Type: text/plain
Date: Sun, 04 Oct 2009 23:30:22 +0200
Message-Id: <1254691822.21044.9.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-04 at 12:35 +0000, Joseph S. Myers wrote:
> In asm-generic/fcntl.h, F_SETOWN_EX and F_GETLK64 both have value 12, and 
> F_GETOWN_EX and F_SETLK64 both have value 13.  I don't see how this is 
> going to work correctly.  See 
> <http://sourceware.org/ml/libc-ports/2009-10/msg00013.html>.


Ugh,.. yeah, non obvious collision that.

How about something like:

---
 arch/alpha/include/asm/fcntl.h |    4 ++--
 include/asm-generic/fcntl.h    |   19 +++++++++++--------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/alpha/include/asm/fcntl.h b/arch/alpha/include/asm/fcntl.h
index e42823e..73126e4 100644
--- a/arch/alpha/include/asm/fcntl.h
+++ b/arch/alpha/include/asm/fcntl.h
@@ -26,8 +26,8 @@
 #define F_GETOWN	6	/*  for sockets. */
 #define F_SETSIG	10	/*  for sockets. */
 #define F_GETSIG	11	/*  for sockets. */
-#define F_SETOWN_EX	12
-#define F_GETOWN_EX	13
+#define F_SETOWN_EX	15
+#define F_GETOWN_EX	16
 
 /* for posix fcntl() and lockf() */
 #define F_RDLCK		1
diff --git a/include/asm-generic/fcntl.h b/include/asm-generic/fcntl.h
index 0c3dd86..cd2d789 100644
--- a/include/asm-generic/fcntl.h
+++ b/include/asm-generic/fcntl.h
@@ -73,9 +73,18 @@
 #define F_SETSIG	10	/* for sockets. */
 #define F_GETSIG	11	/* for sockets. */
 #endif
+
+#ifndef CONFIG_64BIT
+#ifndef F_GETLK64
+#define F_GETLK64	12	/*  using 'struct flock64' */
+#define F_SETLK64	13
+#define F_SETLKW64	14
+#endif
+#endif
+
 #ifndef F_SETOWN_EX
-#define F_SETOWN_EX	12
-#define F_GETOWN_EX	13
+#define F_SETOWN_EX	15
+#define F_GETOWN_EX	16
 #endif
 
 #define F_OWNER_TID	0
@@ -139,12 +148,6 @@ struct flock {
 
 #ifndef CONFIG_64BIT
 
-#ifndef F_GETLK64
-#define F_GETLK64	12	/*  using 'struct flock64' */
-#define F_SETLK64	13
-#define F_SETLKW64	14
-#endif
-
 #ifndef HAVE_ARCH_STRUCT_FLOCK64
 #ifndef __ARCH_FLOCK64_PAD
 #define __ARCH_FLOCK64_PAD


