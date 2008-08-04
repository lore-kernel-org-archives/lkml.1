Return-Path: <linux-kernel-owner+w=401wt.eu-S1764835AbYHDVeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764835AbYHDVeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764631AbYHDVd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:33:57 -0400
Received: from mx1.suse.de ([195.135.220.2]:54404 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763026AbYHDVdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:33:55 -0400
Date: Mon, 4 Aug 2008 14:29:37 -0700
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
       alan@lxorguk.ukuu.org.uk, Alexander Viro <viro@zeniv.linux.org.uk>,
       Matt Waddel <matt.waddel@freescale.com>,
       Greg Ungerer <gerg@snapgear.com>
Subject: [patch 02/25] romfs_readpage: dont report errors for pages beyond
	i_size
Message-ID: <20080804212937.GB8014@suse.de>
References: <20080804203506.816201392@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="romfs_readpage-don-t-report-errors-for-pages-beyond-i_size.patch"
In-Reply-To: <20080804212725.GA7944@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 0056e65f9e28d83ee1a3fb4f7d0041e838f03c34 upstream

We zero-fill them like we are supposed to, and that's all fine.  It's
only an error if the 'romfs_copyfrom()' routine isn't able to fill the
data that is supposed to be there.

Most of the patch is really just re-organizing the code a bit, and using
separate variables for the error value and for how much of the page we
actually filled from the filesystem.

Reported-and-tested-by: Chris Fester <cfester@wms.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Matt Waddel <matt.waddel@freescale.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-of-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/romfs/inode.c |   37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

--- a/fs/romfs/inode.c
+++ b/fs/romfs/inode.c
@@ -418,7 +418,8 @@ static int
 romfs_readpage(struct file *file, struct page * page)
 {
 	struct inode *inode = page->mapping->host;
-	loff_t offset, avail, readlen;
+	loff_t offset, size;
+	unsigned long filled;
 	void *buf;
 	int result = -EIO;
 
@@ -430,21 +431,29 @@ romfs_readpage(struct file *file, struct
 
 	/* 32 bit warning -- but not for us :) */
 	offset = page_offset(page);
-	if (offset < i_size_read(inode)) {
-		avail = inode->i_size-offset;
-		readlen = min_t(unsigned long, avail, PAGE_SIZE);
-		if (romfs_copyfrom(inode, buf, ROMFS_I(inode)->i_dataoffset+offset, readlen) == readlen) {
-			if (readlen < PAGE_SIZE) {
-				memset(buf + readlen,0,PAGE_SIZE-readlen);
-			}
-			SetPageUptodate(page);
-			result = 0;
+	size = i_size_read(inode);
+	filled = 0;
+	result = 0;
+	if (offset < size) {
+		unsigned long readlen;
+
+		size -= offset;
+		readlen = size > PAGE_SIZE ? PAGE_SIZE : size;
+
+		filled = romfs_copyfrom(inode, buf, ROMFS_I(inode)->i_dataoffset+offset, readlen);
+
+		if (filled != readlen) {
+			SetPageError(page);
+			filled = 0;
+			result = -EIO;
 		}
 	}
-	if (result) {
-		memset(buf, 0, PAGE_SIZE);
-		SetPageError(page);
-	}
+
+	if (filled < PAGE_SIZE)
+		memset(buf + filled, 0, PAGE_SIZE-filled);
+
+	if (!result)
+		SetPageUptodate(page);
 	flush_dcache_page(page);
 
 	unlock_page(page);

-- 
