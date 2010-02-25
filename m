Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759270Ab0BYSo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 13:44:58 -0500
Received: from mx76.mail.ru ([94.100.176.91]:57449 "EHLO mx76.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171Ab0BYSo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 13:44:57 -0500
Date: Thu, 25 Feb 2010 21:47:43 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Alex Viskovatoff <viskovatoff@imap.cc>
Subject: [PATCH] ufs: make solaris fsck happy
Message-ID: <20100225184743.GA13772@rain>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Alex Viskovatoff <viskovatoff@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Viskovatoff let me know that after copying data to solaris's ufs from
linux, solaris's fsck sees some errors in cylinder summary information.
This is because of solaris expects find some data on another places,
then curernt implementation save it.
This patch fixes this issue. It is tested by me, and also Alex
reported that it works for him.


Signed-off-by: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Alex Viskovatoff <viskovatoff@imap.cc>
---
 fs/ufs/ufs_fs.h |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ufs/ufs_fs.h b/fs/ufs/ufs_fs.h
index 54bde18..f221c5e 100644
--- a/fs/ufs/ufs_fs.h
+++ b/fs/ufs/ufs_fs.h
@@ -227,11 +227,16 @@ typedef __u16 __bitwise __fs16;
  */
 #define ufs_cbtocylno(bno) \
 	((bno) * uspi->s_nspf / uspi->s_spc)
-#define ufs_cbtorpos(bno) \
+#define ufs_cbtorpos(bno)				      \
+	((UFS_SB(sb)->s_flags & UFS_CG_SUN) ?		      \
+	 (((((bno) * uspi->s_nspf % uspi->s_spc) %	      \
+	    uspi->s_nsect) *				      \
+	   uspi->s_nrpos) / uspi->s_nsect)		      \
+	 :						      \
 	((((bno) * uspi->s_nspf % uspi->s_spc / uspi->s_nsect \
 	* uspi->s_trackskew + (bno) * uspi->s_nspf % uspi->s_spc \
 	% uspi->s_nsect * uspi->s_interleave) % uspi->s_nsect \
-	* uspi->s_nrpos) / uspi->s_npsect)
+	  * uspi->s_nrpos) / uspi->s_npsect))
 
 /*
  * The following macros optimize certain frequently calculated
-- 
1.6.5.6

-- 
/Evgeniy

