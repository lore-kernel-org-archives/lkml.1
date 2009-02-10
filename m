Return-Path: <linux-kernel-owner+w=401wt.eu-S1755612AbZBJTEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbZBJTEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:04:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754596AbZBJTD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:03:27 -0500
Received: from kroah.org ([198.145.64.141]:53573 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754548AbZBJTD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:03:26 -0500
Date: Tue, 10 Feb 2009 10:59:43 -0800
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
       alan@lxorguk.ukuu.org.uk, Carsten Otte <cotte@de.ibm.com>,
       Nick Piggin <npiggin@suse.de>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 02/53] do_wp_page: fix regression with execute in place
Message-ID: <20090210185943.GC14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="do_wp_page-fix-regression-with-execute-in-place.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Carsten Otte <cotte@de.ibm.com>

commit ab92661d5d9514647346047f30f67a7f35ffea67 upstream.

Fix do_wp_page for VM_MIXEDMAP mappings.

In the case where pfn_valid returns 0 for a pfn at the beginning of
do_wp_page and the mapping is not shared writable, the code branches to
label `gotten:' with old_page == NULL.

In case the vma is locked (vma->vm_flags & VM_LOCKED), lock_page,
clear_page_mlock, and unlock_page try to access the old_page.

This patch checks whether old_page is valid before it is dereferenced.

The regression was introduced by "mlock: mlocked pages are unevictable"
(commit b291f000393f5a0b679012b39d79fbc85c018233).

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1881,7 +1881,7 @@ gotten:
 	 * Don't let another task, with possibly unlocked vma,
 	 * keep the mlocked page.
 	 */
-	if (vma->vm_flags & VM_LOCKED) {
+	if ((vma->vm_flags & VM_LOCKED) && old_page) {
 		lock_page(old_page);	/* for LRU manipulation */
 		clear_page_mlock(old_page);
 		unlock_page(old_page);

