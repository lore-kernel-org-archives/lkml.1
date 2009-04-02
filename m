Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbZDBQsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbZDBQsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932081AbZDBQrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:47:22 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:39687 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765958AbZDBQrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:47:21 -0400
Subject: [PATCH]  Define a UNIQUE value for AS_UNEVICTABLE flag
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, stable <stable@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Howells <dhowells@redhat.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Thu, 02 Apr 2009 12:47:15 -0400
Message-Id: <1238690835.7359.16.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] Define UNIQUE value of AS_UNEVICTABLE

Needed in 2.6.28, 2.6.29, ...

A new "address_space flag"--AS_MM_ALL_LOCKS--was defined to use the next
available AS flag while the Unevictable LRU was under development.  The
Unevictable LRU was using the same flag and "no one" noticed.  Current 
mainline, since 2.6.28, has same value for two symbolic flag names.

So, define a unique flag value for AS_UNEVICTABLE--up close to the other
flags, [at the cost of an additional #ifdef] so we'll notice next time.
Note that #ifdef is not actually required, if we don't mind having the 
unused flag value defined.

Replace #defines with an enum.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>

 include/linux/pagemap.h |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

Index: linux-2.6.29/include/linux/pagemap.h
===================================================================
--- linux-2.6.29.orig/include/linux/pagemap.h	2009-03-23 19:12:14.000000000 -0400
+++ linux-2.6.29/include/linux/pagemap.h	2009-04-02 11:56:27.000000000 -0400
@@ -18,9 +18,14 @@
  * Bits in mapping->flags.  The lower __GFP_BITS_SHIFT bits are the page
  * allocation mode flags.
  */
-#define	AS_EIO		(__GFP_BITS_SHIFT + 0)	/* IO error on async write */
-#define AS_ENOSPC	(__GFP_BITS_SHIFT + 1)	/* ENOSPC on async write */
-#define AS_MM_ALL_LOCKS	(__GFP_BITS_SHIFT + 2)	/* under mm_take_all_locks() */
+enum mapping_flags {
+	AS_EIO		= __GFP_BITS_SHIFT + 0,	/* IO error on async write */
+	AS_ENOSPC	= __GFP_BITS_SHIFT + 1,	/* ENOSPC on async write */
+	AS_MM_ALL_LOCKS	= __GFP_BITS_SHIFT + 2,	/* under mm_take_all_locks() */
+#ifdef CONFIG_UNEVICTABLE_LRU
+	AS_UNEVICTABLE	= __GFP_BITS_SHIFT + 3,	/* e.g., ramdisk, SHM_LOCK */
+#endif
+};
 
 static inline void mapping_set_error(struct address_space *mapping, int error)
 {
@@ -33,7 +38,6 @@ static inline void mapping_set_error(str
 }
 
 #ifdef CONFIG_UNEVICTABLE_LRU
-#define AS_UNEVICTABLE	(__GFP_BITS_SHIFT + 2)	/* e.g., ramdisk, SHM_LOCK */
 
 static inline void mapping_set_unevictable(struct address_space *mapping)
 {


