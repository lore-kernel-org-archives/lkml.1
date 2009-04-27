Return-Path: <linux-kernel-owner+w=401wt.eu-S1759945AbZD0Xbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945AbZD0Xbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 19:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbZD0Xbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 19:31:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49229 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755831AbZD0Xbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 19:31:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Better document some regset helper functions
To: roland@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 28 Apr 2009 00:30:21 +0100
Message-ID: <20090427233020.676.17406.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Better document some regset helper functions, namely user_regset_copyout() and
user_regset_copyin().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/regset.h |   77 +++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 69 insertions(+), 8 deletions(-)


diff --git a/include/linux/regset.h b/include/linux/regset.h
index 8abee65..ad67cb2 100644
--- a/include/linux/regset.h
+++ b/include/linux/regset.h
@@ -205,17 +205,48 @@ const struct user_regset_view *task_user_regset_view(struct task_struct *tsk);
 
 
 /*
- * These are helpers for writing regset get/set functions in arch code.
- * Because @start_pos and @end_pos are always compile-time constants,
- * these are inlined into very little code though they look large.
+ * The following functions are helpers for writing regset get/set functions in
+ * arch code.  Because @start_pos and @end_pos are always compile-time
+ * constants, these are inlined into very little code though they look large.
  *
- * Use one or more calls sequentially for each chunk of regset data stored
- * contiguously in memory.  Call with constants for @start_pos and @end_pos,
- * giving the range of byte positions in the regset that data corresponds
- * to; @end_pos can be -1 if this chunk is at the end of the regset layout.
- * Each call updates the arguments to point past its chunk.
+ * Use one or more calls sequentially for each subset of the regset data that
+ * is stored contiguously in memory.  Call with constants for @start_pos and
+ * @end_pos, giving the range of byte positions in the regset that @data
+ * corresponds to; @end_pos can be -1 if this subset is at the end of the
+ * regset layout.  Each call updates the arguments to point past its chunk.
  */
 
+/**
+ * user_regset_copyout - Retrieve data from a subset of a register set
+ * @pos:	The running position to retrieve from in the register set
+ * @count:	The running amount of data left to retrieve
+ * @kbuf:	The running kernel buffer pointer to write into (or NULL)
+ * @ubuf:	The running user buffer pointer to write into (if !*kbuf)
+ * @data:	Where the data for this subset of the register set is held
+ * @start_pos:	The offset at which this subset begins in the register set
+ * @end_pos:	The offset at which this subset ends in the register set
+ *
+ * This helper function can be called upon to retrieve the data from a subset
+ * of a register set and store it either into a kernel buffer or into a
+ * userspace buffer.
+ *
+ * The data subset being offered for retrieval by the caller is an array of
+ * @end_pos-@start_pos bytes at the @data pointer.
+ *
+ * The data subset requested for retrieval is an array of *@count bytes,
+ * beginning at *@pos bytes into the register set.
+ *
+ * If the requested subset overlaps the offered subset, then some data will be
+ * copied into the appropriate buffer, and the *@pos, *@count and the
+ * appropriate buffer pointer will be updated to reflect the amount remaining
+ * to be copied.  This allows subsequent calls to this function to cascade
+ * automatically.
+ *
+ * If the two subsets do not overlap, then no copy is made, and the running
+ * parameters are not altered.
+ *
+ * This function returns 0 if successful, and a -ve error code on error.
+ */
 static inline int user_regset_copyout(unsigned int *pos, unsigned int *count,
 				      void **kbuf,
 				      void __user **ubuf, const void *data,
@@ -241,6 +272,36 @@ static inline int user_regset_copyout(unsigned int *pos, unsigned int *count,
 	return 0;
 }
 
+/**
+ * user_regset_copyin - Store data into a subset of a register set
+ * @pos:	The running position to store to in the register set
+ * @count:	The running amount of data left to store
+ * @kbuf:	The running kernel buffer pointer to read from (or NULL)
+ * @ubuf:	The running user buffer pointer to read from (if !*kbuf)
+ * @data:	Where the data for this subset of the register set is help
+ * @start_pos:	The offset at which this subset begins in the register set
+ * @end_pos:	The offset at which this subset ends in the register set
+ *
+ * This helper function can be called upon to update the data in a subset of a
+ * register set from data either in a kernel buffer or in a userspace buffer.
+ *
+ * The data subset being offered for update by the caller is an array of
+ * @end_pos-@start_pos bytes at the @data pointer.
+ *
+ * The data subset requested to be updated is an array of *@count bytes,
+ * beginning at *@pos bytes into the register set.
+ *
+ * If the requested subset overlaps the offered subset, then some data will be
+ * copied from the appropriate buffer, and the *@pos, *@count and the
+ * appropriate buffer pointer will be updated to reflect the amount remaining
+ * to be copied.  This allows subsequent calls to this function to cascade
+ * automatically.
+ *
+ * If the two subsets do not overlap, then no copy is made, and the running
+ * parameters are not altered.
+ *
+ * This function returns 0 if successful, and a -ve error code on error.
+ */
 static inline int user_regset_copyin(unsigned int *pos, unsigned int *count,
 				     const void **kbuf,
 				     const void __user **ubuf, void *data,

