Return-Path: <linux-kernel-owner+w=401wt.eu-S1759908AbZAWADZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908AbZAWADZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 19:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbZAWADS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 19:03:18 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:37749 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755667AbZAWADR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 19:03:17 -0500
Date: Fri, 23 Jan 2009 11:02:03 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Eric Sesterhenn <snakebyte@gmx.de>,
       Pavel Machek <pavel@suse.cz>, Chris Mason <chris.mason@oracle.com>,
       linux-kernel@vger.kernel.org, npiggin@yahoo.com.au, xfs@oss.sgi.com
Subject: Re: [PATCH] Re: Corrupted XFS log replay oops.
Message-ID: <20090123000203.GC32390@disturbed>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Eric Sesterhenn <snakebyte@gmx.de>, Pavel Machek <pavel@suse.cz>,
	Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
	npiggin@yahoo.com.au, xfs@oss.sgi.com
References: <20090113142147.GE16333@alice> <20090120173455.GC21339@alice> <20090121035703.GH10158@disturbed> <200901211503.07308.nickpiggin@yahoo.com.au> <20090122043747.GU10158@disturbed> <20090122061158.GA31104@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122061158.GA31104@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 01:11:58AM -0500, Christoph Hellwig wrote:
> On Thu, Jan 22, 2009 at 03:37:47PM +1100, Dave Chinner wrote:
> >  xfs_buf_t *
> >  xlog_get_bp(
> >  	xlog_t		*log,
> > -	int		num_bblks)
> > +	int		nbblks)
> 
> Any reason for reanming this variable?  That causes quite a bit of
> churn.
> 
> >  {
> > -	ASSERT(num_bblks > 0);
> > +	if (nbblks <= 0 || nbblks > log->l_logBBsize) {
> > +		xlog_warn("XFS: Invalid block length (0x%x) given for buffer", nbblks);
> 
> And doesn't prevent this line from needing a linebreak to stay under 80
> characters :)

And now with line breaks.

------

[XFS] Check buffer lengths in log recovery

Before trying to obtain, read or write a buffer,
check that the buffer length is actually valid. If
it is not valid, then something read in the recovery
process has been corrupted and we should abort
recovery.

Reported-by: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Tested-by: Eric Sesterhenn <snakebyte@gmx.de>
---
 fs/xfs/xfs_log_recover.c |   34 ++++++++++++++++++++++++++++------
 1 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 35cca98..a37e4aa 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -70,16 +70,22 @@ STATIC void	xlog_recover_check_summary(xlog_t *);
 xfs_buf_t *
 xlog_get_bp(
 	xlog_t		*log,
-	int		num_bblks)
+	int		nbblks)
 {
-	ASSERT(num_bblks > 0);
+	if (nbblks <= 0 || nbblks > log->l_logBBsize) {
+		xlog_warn("XFS: Invalid block length (0x%x) given for buffer",
+					nbblks);
+		XFS_ERROR_REPORT("xlog_get_bp(1)",
+					XFS_ERRLEVEL_HIGH, log->l_mp);
+		return NULL;
+	}
 
 	if (log->l_sectbb_log) {
-		if (num_bblks > 1)
-			num_bblks += XLOG_SECTOR_ROUNDUP_BBCOUNT(log, 1);
-		num_bblks = XLOG_SECTOR_ROUNDUP_BBCOUNT(log, num_bblks);
+		if (nbblks > 1)
+			nbblks += XLOG_SECTOR_ROUNDUP_BBCOUNT(log, 1);
+		nbblks = XLOG_SECTOR_ROUNDUP_BBCOUNT(log, nbblks);
 	}
-	return xfs_buf_get_noaddr(BBTOB(num_bblks), log->l_mp->m_logdev_targp);
+	return xfs_buf_get_noaddr(BBTOB(nbblks), log->l_mp->m_logdev_targp);
 }
 
 void
@@ -102,6 +108,14 @@ xlog_bread(
 {
 	int		error;
 
+	if (nbblks <= 0 || nbblks > log->l_logBBsize) {
+		xlog_warn("XFS: Invalid block length (0x%x) given for buffer",
+					nbblks);
+		XFS_ERROR_REPORT("xlog_bread(1)",
+					XFS_ERRLEVEL_HIGH, log->l_mp);
+		return EFSCORRUPTED;
+	}
+
 	if (log->l_sectbb_log) {
 		blk_no = XLOG_SECTOR_ROUNDDOWN_BLKNO(log, blk_no);
 		nbblks = XLOG_SECTOR_ROUNDUP_BBCOUNT(log, nbblks);
@@ -139,6 +153,14 @@ xlog_bwrite(
 {
 	int		error;
 
+	if (nbblks <= 0 || nbblks > log->l_logBBsize) {
+		xlog_warn("XFS: Invalid block length (0x%x) given for buffer",
+					nbblks);
+		XFS_ERROR_REPORT("xlog_bwrite(1)",
+					XFS_ERRLEVEL_HIGH, log->l_mp);
+		return EFSCORRUPTED;
+	}
+
 	if (log->l_sectbb_log) {
 		blk_no = XLOG_SECTOR_ROUNDDOWN_BLKNO(log, blk_no);
 		nbblks = XLOG_SECTOR_ROUNDUP_BBCOUNT(log, nbblks);
