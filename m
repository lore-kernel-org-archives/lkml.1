Return-Path: <linux-kernel-owner+w=401wt.eu-S932553AbYBWATg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553AbYBWATg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762895AbYBWASq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:18:46 -0500
Received: from mx1.suse.de ([195.135.220.2]:42760 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762452AbYBWASo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:18:44 -0500
Date: Fri, 22 Feb 2008 16:17:23 -0800
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
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [patch 2/8] NFS: Fix a potential file corruption issue when writing
Message-ID: <20080223001723.GC27727@suse.de>
References: <20080223001123.939868182@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="nfs-fix-a-potential-file-corruption-issue-when-writing.patch"
In-Reply-To: <20080223001702.GA27727@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>

patch 5d47a35600270e7115061cb1320ee60ae9bcb6b8 in mainline.

If the inode is flagged as having an invalid mapping, then we can't rely on
the PageUptodate() flag. Ensure that we don't use the "anti-fragmentation"
write optimisation in nfs_updatepage(), since that will cause NFS to write
out areas of the page that are no longer guaranteed to be up to date.

A potential corruption could occur in the following scenario:

client 1			client 2
===============			===============
				fd=open("f",O_CREAT|O_WRONLY,0644);
				write(fd,"fubar\n",6);	// cache last page
				close(fd);
fd=open("f",O_WRONLY|O_APPEND);
write(fd,"foo\n",4);
close(fd);

				fd=open("f",O_WRONLY|O_APPEND);
				write(fd,"bar\n",4);
				close(fd);
-----
The bug may lead to the file "f" reading 'fubar\n\0\0\0\nbar\n' because
client 2 does not update the cached page after re-opening the file for
write. Instead it keeps it marked as PageUptodate() until someone calls
invaldate_inode_pages2() (typically by calling read()).

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/write.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -717,6 +717,17 @@ int nfs_flush_incompatible(struct file *
 }
 
 /*
+ * If the page cache is marked as unsafe or invalid, then we can't rely on
+ * the PageUptodate() flag. In this case, we will need to turn off
+ * write optimisations that depend on the page contents being correct.
+ */
+static int nfs_write_pageuptodate(struct page *page, struct inode *inode)
+{
+	return PageUptodate(page) &&
+		!(NFS_I(inode)->cache_validity & (NFS_INO_REVAL_PAGECACHE|NFS_INO_INVALID_DATA));
+}
+
+/*
  * Update and possibly write a cached page of an NFS file.
  *
  * XXX: Keep an eye on generic_file_read to make sure it doesn't do bad
@@ -737,10 +748,13 @@ int nfs_updatepage(struct file *file, st
 		(long long)(page_offset(page) +offset));
 
 	/* If we're not using byte range locks, and we know the page
-	 * is entirely in cache, it may be more efficient to avoid
-	 * fragmenting write requests.
+	 * is up to date, it may be more efficient to extend the write
+	 * to cover the entire page in order to avoid fragmentation
+	 * inefficiencies.
 	 */
-	if (PageUptodate(page) && inode->i_flock == NULL && !(file->f_mode & O_SYNC)) {
+	if (nfs_write_pageuptodate(page, inode) &&
+			inode->i_flock == NULL &&
+			!(file->f_mode & O_SYNC)) {
 		count = max(count + offset, nfs_page_length(page));
 		offset = 0;
 	}

-- 
