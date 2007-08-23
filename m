Return-Path: <linux-kernel-owner+w=401wt.eu-S1766009AbXHWW2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766009AbXHWW2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764904AbXHWW1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:27:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50622 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764928AbXHWW1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:27:53 -0400
Date: Thu, 23 Aug 2007 15:25:52 -0700
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
       Mark Fasheh <mark.fasheh@oracle.com>
Subject: [patch 01/28] ocfs2: Fix bad source start calculation during
	kernel writes
Message-ID: <20070823222552.GB18559@kroah.com>
References: <20070823220656.101239233@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ocfs2-fix-bad-source-start-calculation-during-kernel-writes.patch"
In-Reply-To: <20070823221811.GA18559@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Fasheh <mark.fasheh@oracle.com>

[PATCH] ocfs2: Fix bad source start calculation during kernel writes

For in-kernel writes ocfs2_get_write_source() should be starting the buffer
at a page boundary as the math in ocfs2_map_and_write_user_data() will pad
it back out to the correct write offset. Instead, we were passing the raw
offset, which caused ocfs2_map_and_write_user_data() start too far into the
buffer, resulting in corruptions from nfs client writes.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ocfs2/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1353,7 +1353,7 @@ static struct page * ocfs2_get_write_sou
 		else
 			src_page = ERR_PTR(-EFAULT);
 	} else {
-		bp->b_src_buf = buf;
+		bp->b_src_buf = (char *)((unsigned long)buf & PAGE_CACHE_MASK);
 	}
 
 	return src_page;

-- 
