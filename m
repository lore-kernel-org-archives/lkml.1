Return-Path: <linux-kernel-owner+w=401wt.eu-S1763258AbYCDAKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763258AbYCDAKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 19:10:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbYCDAHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 19:07:40 -0500
Received: from relay1.sgi.com ([192.48.171.29]:40089 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752654AbYCDAHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 19:07:35 -0500
Message-Id: <20080304000732.535399640@sgi.com>
References: <20080304000452.514878384@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 03 Mar 2008 16:04:54 -0800
From: Christoph Lameter <clameter@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: apw@shadowen.org
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org
Subject: [rfc 02/10] Pageflags: Introduce macros to generate page flag functions
Content-Disposition: inline; filename=pageflags-add-macros
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a set of macros that generate functions to handle page flags.


A page flag function group typically starts with either

	SETPAGEFLAG(<part of function name>,<part of PG_ flagname>)

to create a set of page flag operations that are atomic. Or

	__SETPAGEFLAG(<part of function name>,<part of PG_ flagname)

to create a set of page flag operations that are not atomic.


Then additional operations can be added using the following macros

TESTSCFLAG		Create additional atomic test-and-set and
			test-and-clear functions

TESTSETFLAG		Create additional test and set function
TESTCLEARFLAG		Create additional test and clear function
SETPAGEFLAG		Create additional atomic set function
CLEARPAGEFLAG		Create additional atomic clear function
__TESTPAGEFLAG		Create additional non atomic set function
__SETPAGEFLAG		Create additional non atomic clear function

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/page-flags.h |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

Index: linux-2.6/include/linux/page-flags.h
===================================================================
--- linux-2.6.orig/include/linux/page-flags.h	2008-03-03 15:45:20.895497292 -0800
+++ linux-2.6/include/linux/page-flags.h	2008-03-03 15:45:56.827992817 -0800
@@ -105,6 +105,47 @@ enum pageflags {
 };
 
 /*
+ * Macros to create function definitions for page flags
+ */
+#define TESTPAGEFLAG(uname, lname)					\
+static inline int Page##uname(struct page *page) 			\
+			{ return test_bit(PG_##lname, page); }
+
+#define SETPAGEFLAG(uname, lname)					\
+static inline void SetPage##uname(struct page *page)			\
+			{ set_bit(PG_##lname, page); }
+
+#define CLEARPAGEFLAG(uname, lname)					\
+static inline void ClearPage##uname(struct page *page)			\
+			{ clear_bit(PG_##lname, page); }
+
+#define __SETPAGEFLAG(uname, lname)					\
+static inline void __SetPage##uname(struct page *page)			\
+			{ __set_bit(PG_##lname, page); }
+
+#define __CLEARPAGEFLAG(uname, lname)					\
+static inline void __ClearPage##uname(struct page *page)		\
+			{ __clear_bit(PG_##lname, page); }
+
+#define TESTSETFLAG(uname, lname)					\
+static inline int TestSetPage##uname(struct page *page)			\
+		{ return test_and_set_bit(PG_##lname, &page->flags); }
+
+#define TESTCLEARFLAG(uname, lname)					\
+static inline int TestClearPage##uname(struct page *page)		\
+		{ return test_and_clear_bit(PG_##lname, &page->flags); }
+
+
+#define PAGEFLAG(uname, lname) TESTPAGEFLAG(uname, lname)		\
+	SETPAGEFLAG(uname, lname) CLEARPAGEFLAG(uname, lname)
+
+#define __PAGEFLAG(uname, lname) TESTPAGEFLAG(uname, lname)		\
+	__SETPAGEFLAG(uname, lname)  __CLEARPAGEFLAG(uname, lname)
+
+#define TESTSCFLAG(uname, lname)					\
+	TESTSETFLAG(uname, lname) TESTCLEARFLAG(uname, lname)
+
+/*
  * Manipulation of page state flags
  */
 #define PageLocked(page)		\

-- 
