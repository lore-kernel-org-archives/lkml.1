Return-Path: <linux-kernel-owner+w=401wt.eu-S1764492AbZD3RRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764492AbZD3RRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764542AbZD3RHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:07:40 -0400
Received: from kroah.org ([198.145.64.141]:56331 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764354AbZD3RHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:32 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:41 2009
Message-Id: <20090430165741.705431835@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 23/88] mm: define a UNIQUE value for AS_UNEVICTABLE flag
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0030-mm-define-a-UNIQUE-value-for-AS_UNEVICTABLE-flag.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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


