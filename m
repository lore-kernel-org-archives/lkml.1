Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbZDWHil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbZDWHil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756252AbZDWHaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:30:01 -0400
Received: from sous-sol.org ([216.99.217.87]:48609 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756236AbZDWHaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:30:00 -0400
Message-Id: <20090423072415.893880995@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:51 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: [patch 031/100] mm: define a UNIQUE value for AS_UNEVICTABLE flag
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=mm-define-a-unique-value-for-as_unevictable-flag.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

upstream commit: 9a896c9a48ac6704c0ce8ee081b836644d0afe40

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
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 include/linux/pagemap.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
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

