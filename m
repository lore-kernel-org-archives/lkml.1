Return-Path: <linux-kernel-owner+w=401wt.eu-S1761457AbXIXQ3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761457AbXIXQ3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760444AbXIXQZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:25:41 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47318 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759123AbXIXQZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:25:38 -0400
Date: Mon, 24 Sep 2007 09:20:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jason Lunz <lunz@falooley.org>, David Woodhouse <dwmw2@infradead.org>
Subject: [14/50] JFFS2: fix write deadlock regression
Message-ID: <20070924162041.GO13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="jffs2-fix-write-deadlock-regression.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Lunz <lunz@falooley.org>

Changeset fc0e01974ccccc7530b7634a63ee3fcc57b845ea from mainline.


I've bisected the deadlock when many small appends are done on jffs2 down to
this commit:

commit 6fe6900e1e5b6fa9e5c59aa5061f244fe3f467e2
Author: Nick Piggin <npiggin@suse.de>
Date:   Sun May 6 14:49:04 2007 -0700

    mm: make read_cache_page synchronous

    Ensure pages are uptodate after returning from read_cache_page, which allows
    us to cut out most of the filesystem-internal PageUptodate calls.

    I didn't have a great look down the call chains, but this appears to fixes 7
    possible use-before uptodate in hfs, 2 in hfsplus, 1 in jfs, a few in
    ecryptfs, 1 in jffs2, and a possible cleared data overwritten with readpage in
    block2mtd.  All depending on whether the filler is async and/or can return
    with a !uptodate page.

It introduced a wait to read_cache_page, as well as a
read_cache_page_async function equivalent to the old read_cache_page
without any callers.

Switching jffs2_gc_fetch_page to read_cache_page_async for the old
behavior makes the deadlocks go away, but maybe reintroduces the
use-before-uptodate problem? I don't understand the mm/fs interaction
well enough to say.

[It's fine. dwmw2.]

Signed-off-by: Jason Lunz <lunz@falooley.org>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jffs2/fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -627,7 +627,7 @@ unsigned char *jffs2_gc_fetch_page(struc
 	struct inode *inode = OFNI_EDONI_2SFFJ(f);
 	struct page *pg;
 
-	pg = read_cache_page(inode->i_mapping, offset >> PAGE_CACHE_SHIFT,
+	pg = read_cache_page_async(inode->i_mapping, offset >> PAGE_CACHE_SHIFT,
 			     (void *)jffs2_do_readpage_unlock, inode);
 	if (IS_ERR(pg))
 		return (void *)pg;

-- 
