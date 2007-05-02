Return-Path: <linux-kernel-owner+w=401wt.eu-S2992713AbXEBE2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992713AbXEBE2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 00:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992714AbXEBE2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 00:28:24 -0400
Received: from smtp-out.google.com ([216.239.45.13]:24798 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992713AbXEBE2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 00:28:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=BMYKCUU3g42u6fLj0zFxM1gYgO5C8S72WxyzY8Mbp1WHWkzE/cv22QALOmsKxy7GL
	IVgpA+leHiLm9wcpJKr2w==
Date: Tue, 1 May 2007 21:28:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [patch 01/10] compiler: define __attribute_unused__
Message-ID: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For all supported versions of gcc (major version 3 and above), functions
and variables may be declared with __attribute__((unused)) to suppress
warnings if they are declared but unused.

This shouldn't be confused with functions being declared with
__attribute__((used)).  This specifies that the function code shall still
be emitted even if it appears to be unreferenced, normally used if
embedded in inline assembly.  For gcc 3.4 and later, unreferenced static
variables and functions are not emitted so this attribute is necessary to
force variables and functions to be output.  Earlier versions of gcc can
simply use __attribute__((unused)) to suppress warnings about such
variables: we do not require any special classification to ensure they are
emitted.

We introduce __attribute_unused__ for variables that should not produce a
compile warning if they can, due to preprocessor macros, go unreferenced.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/compiler-gcc.h |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -37,3 +37,19 @@
 #define  noinline			__attribute__((noinline))
 #define __attribute_pure__		__attribute__((pure))
 #define __attribute_const__		__attribute__((__const__))
+
+/*
+ * __attribute_unused__ shall be used for functions or variables to suppress
+ * warnings when they may be declared but, due to preprocessor macros,
+ * commenting, etc., go unreferenced.
+ *
+ * In contrast, __attribute_used__ shall be used only for functions.  gcc <3.4
+ * emits code for static functions that are unreferenced and outputs a warning.
+ * __attribute_used__ will correctly suppress this warning.  gcc >=3.4 does not
+ * emit code for static functions that are unreferenced (and thus there is no
+ * warning), but __attribute_used__ forces the function code to be output.  Use
+ * __attribute_unused__ to suppress warnings about functions being unused or
+ * __attribute_used__ to ensure code is emitted when it is referenced only in
+ * inline assembly.
+ */
+#define __attribute_unused__		__attribute__((unused))
