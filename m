Return-Path: <linux-kernel-owner+w=401wt.eu-S934316AbZAOUy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934316AbZAOUy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932091AbZAOUDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:03:12 -0500
Received: from kroah.org ([198.145.64.141]:49844 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763746AbZAOUDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:03:05 -0500
Date: Thu, 15 Jan 2009 12:00:37 -0800
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
       alan@lxorguk.ukuu.org.uk, Nick Piggin <npiggin@suse.de>
Subject: [patch 88/94] mm lockless pagecache barrier fix
Message-ID: <20090115200037.GJ14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mm-lockless-pagecache-barrier-fix.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nick Piggin <npiggin@suse.de>

commit e8c82c2e23e3527e0c9dc195e432c16784d270fa upstream.

An XFS workload showed up a bug in the lockless pagecache patch. Basically it
would go into an "infinite" loop, although it would sometimes be able to break
out of the loop! The reason is a missing compiler barrier in the "increment
reference count unless it was zero" case of the lockless pagecache protocol in
the gang lookup functions.

This would cause the compiler to use a cached value of struct page pointer to
retry the operation with, rather than reload it. So the page might have been
removed from pagecache and freed (refcount==0) but the lookup would not correctly
notice the page is no longer in pagecache, and keep attempting to increment the
refcount and failing, until the page gets reallocated for something else. This
isn't a data corruption because the condition will be detected if the page has
been reallocated. However it can result in a lockup.

Linus points out that ACCESS_ONCE is also required in that pointer load, even
if it's absence is not causing a bug on our particular build. The most general
way to solve this is just to put an rcu_dereference in radix_tree_deref_slot.

Assembly of find_get_pages,
before:
.L220:
        movq    (%rbx), %rax    #* ivtmp.1162, tmp82
        movq    (%rax), %rdi    #, prephitmp.1149
.L218:
        testb   $1, %dil        #, prephitmp.1149
        jne     .L217   #,
        testq   %rdi, %rdi      # prephitmp.1149
        je      .L203   #,
        cmpq    $-1, %rdi       #, prephitmp.1149
        je      .L217   #,
        movl    8(%rdi), %esi   # <variable>._count.counter, c
        testl   %esi, %esi      # c
        je      .L218   #,

after:
.L212:
        movq    (%rbx), %rax    #* ivtmp.1109, tmp81
        movq    (%rax), %rdi    #, ret
        testb   $1, %dil        #, ret
        jne     .L211   #,
        testq   %rdi, %rdi      # ret
        je      .L197   #,
        cmpq    $-1, %rdi       #, ret
        je      .L211   #,
        movl    8(%rdi), %esi   # <variable>._count.counter, c
        testl   %esi, %esi      # c
        je      .L212   #,

(notice the obvious infinite loop in the first example, if page->count remains 0)

Signed-off-by: Nick Piggin <npiggin@suse.de>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/radix-tree.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -136,7 +136,7 @@ do {									\
  */
 static inline void *radix_tree_deref_slot(void **pslot)
 {
-	void *ret = *pslot;
+	void *ret = rcu_dereference(*pslot);
 	if (unlikely(radix_tree_is_indirect_ptr(ret)))
 		ret = RADIX_TREE_RETRY;
 	return ret;

