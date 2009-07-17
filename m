Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbZGQUmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbZGQUmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757004AbZGQUmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:42:31 -0400
Received: from kroah.org ([198.145.64.141]:50637 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756685AbZGQUkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:40:55 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jul 17 13:38:24 2009
Message-Id: <20090717203824.188879834@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 17 Jul 2009 13:37:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Julien Tinnes <jt@cr0.org>, Tavis Ormandy <taviso@sdf.lonestar.org>,
       Christoph Hellwig <hch@infradead.org>, Kees Cook <kees@ubuntu.com>,
       Eugene Teo <eugene@redhat.com>
Subject: [patch 2/8] personality: fix PER_CLEAR_ON_SETID (CVE-2009-1895)
References: <20090717203718.637372453@mini.kroah.org>
Content-Disposition: inline; filename=personality-fix-per_clear_on_setid.patch
In-Reply-To: <20090717203935.GA5641@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Julien Tinnes <jt@cr0.org>

commit f9fabcb58a6d26d6efde842d1703ac7cfa9427b6 upstream.

We have found that the current PER_CLEAR_ON_SETID mask on Linux doesn't
include neither ADDR_COMPAT_LAYOUT, nor MMAP_PAGE_ZERO.

The current mask is READ_IMPLIES_EXEC|ADDR_NO_RANDOMIZE.

We believe it is important to add MMAP_PAGE_ZERO, because by using this
personality it is possible to have the first page mapped inside a
process running as setuid root.  This could be used in those scenarios:

 - Exploiting a NULL pointer dereference issue in a setuid root binary
 - Bypassing the mmap_min_addr restrictions of the Linux kernel: by
   running a setuid binary that would drop privileges before giving us
   control back (for instance by loading a user-supplied library), we
   could get the first page mapped in a process we control.  By further
   using mremap and mprotect on this mapping, we can then completely
   bypass the mmap_min_addr restrictions.

Less importantly, we believe ADDR_COMPAT_LAYOUT should also be added
since on x86 32bits it will in practice disable most of the address
space layout randomization (only the stack will remain randomized).

Signed-off-by: Julien Tinnes <jt@cr0.org>
Signed-off-by: Tavis Ormandy <taviso@sdf.lonestar.org>
Acked-by: Christoph Hellwig <hch@infradead.org>
Acked-by: Kees Cook <kees@ubuntu.com>
Acked-by: Eugene Teo <eugene@redhat.com>
[ Shortened lines and fixed whitespace as per Christophs' suggestion ]
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/personality.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/personality.h
+++ b/include/linux/personality.h
@@ -40,7 +40,10 @@ enum {
  * Security-relevant compatibility flags that must be
  * cleared upon setuid or setgid exec:
  */
-#define PER_CLEAR_ON_SETID (READ_IMPLIES_EXEC|ADDR_NO_RANDOMIZE)
+#define PER_CLEAR_ON_SETID (READ_IMPLIES_EXEC  | \
+			    ADDR_NO_RANDOMIZE  | \
+			    ADDR_COMPAT_LAYOUT | \
+			    MMAP_PAGE_ZERO)
 
 /*
  * Personality types.


