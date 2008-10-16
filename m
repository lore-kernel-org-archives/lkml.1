Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbYJPSBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbYJPSBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 14:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755361AbYJPSAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 14:00:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:36057 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254AbYJPSAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 14:00:34 -0400
Date: Thu, 16 Oct 2008 10:56:28 -0700
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
       alan@lxorguk.ukuu.org.uk, Christoph Hellwig <hch@lst.de>,
       Tim Shimmin <tes@sgi.com>
Subject: [patch 04/14] Fix barrier fail detection in XFS
Message-ID: <20081016175628.GE12850@suse.de>
References: <20081016174814.734527827@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-barrier-fail-detection-in-xfs.patch"
In-Reply-To: <20081016175525.GA12850@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Christoph Hellwig <hch@lst.de>

commit 73f6aa4d44ab6157badc456ddfa05b31e58de5f0 upstream.

Currently we disable barriers as soon as we get a buffer in xlog_iodone
that has the XBF_ORDERED flag cleared.  But this can be the case not only
for buffers where the barrier failed, but also the first buffer of a
split log write in case of a log wraparound.  Due to the disabled
barriers we can easily get directory corruption on unclean shutdowns.
So instead of using this check add a new buffer flag for failed barrier
writes.

This is a regression vs 2.6.26 caused by patch to use the right macro
to check for the ORDERED flag, as we previously got true returned for
every buffer.

Thanks to Toei Rei for reporting the bug.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
Reviewed-by: David Chinner <david@fromorbit.com>
Signed-off-by: Tim Shimmin <tes@sgi.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_buf.c |    3 ++-
 fs/xfs/linux-2.6/xfs_buf.h |    8 ++++++++
 fs/xfs/xfs_log.c           |    7 ++++---
 3 files changed, 14 insertions(+), 4 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1001,12 +1001,13 @@ xfs_buf_iodone_work(
 	 * We can get an EOPNOTSUPP to ordered writes.  Here we clear the
 	 * ordered flag and reissue them.  Because we can't tell the higher
 	 * layers directly that they should not issue ordered I/O anymore, they
-	 * need to check if the ordered flag was cleared during I/O completion.
+	 * need to check if the _XFS_BARRIER_FAILED flag was set during I/O completion.
 	 */
 	if ((bp->b_error == EOPNOTSUPP) &&
 	    (bp->b_flags & (XBF_ORDERED|XBF_ASYNC)) == (XBF_ORDERED|XBF_ASYNC)) {
 		XB_TRACE(bp, "ordered_retry", bp->b_iodone);
 		bp->b_flags &= ~XBF_ORDERED;
+		bp->b_flags |= _XFS_BARRIER_FAILED;
 		xfs_buf_iorequest(bp);
 	} else if (bp->b_iodone)
 		(*(bp->b_iodone))(bp);
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -85,6 +85,14 @@ typedef enum {
 	 * modifications being lost.
 	 */
 	_XBF_PAGE_LOCKED = (1 << 22),
+
+	/*
+	 * If we try a barrier write, but it fails we have to communicate
+	 * this to the upper layers.  Unfortunately b_error gets overwritten
+	 * when the buffer is re-issued so we have to add another flag to
+	 * keep this information.
+	 */
+	_XFS_BARRIER_FAILED = (1 << 23),
 } xfs_buf_flags_t;
 
 typedef enum {
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1033,11 +1033,12 @@ xlog_iodone(xfs_buf_t *bp)
 	l = iclog->ic_log;
 
 	/*
-	 * If the ordered flag has been removed by a lower
-	 * layer, it means the underlyin device no longer supports
+	 * If the _XFS_BARRIER_FAILED flag was set by a lower
+	 * layer, it means the underlying device no longer supports
 	 * barrier I/O. Warn loudly and turn off barriers.
 	 */
-	if ((l->l_mp->m_flags & XFS_MOUNT_BARRIER) && !XFS_BUF_ISORDERED(bp)) {
+	if (bp->b_flags & _XFS_BARRIER_FAILED) {
+		bp->b_flags &= ~_XFS_BARRIER_FAILED;
 		l->l_mp->m_flags &= ~XFS_MOUNT_BARRIER;
 		xfs_fs_cmn_err(CE_WARN, l->l_mp,
 				"xlog_iodone: Barriers are no longer supported"

-- 
