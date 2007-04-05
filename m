Return-Path: <linux-kernel-owner+w=401wt.eu-S1945956AbXDEGpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945956AbXDEGpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 02:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945961AbXDEGpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 02:45:08 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:15811 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945956AbXDEGpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 02:45:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=HJ/jUhsbiT9EbNK0Xb6vkmt9/1m4VqOweEyaihhB/qxI9EeqzPmRaEqC8z9fAb1s1XCExDgvM3UBQNCH+MprAv1OLSrJlpIkxsdyqdPTKfZOyrwSZmrsIe96NPk4ujVOudLdnAmnPljMeJU4/kJxarATipwOxoXTb0XtFAAaIV0=
Date: Thu, 5 Apr 2007 14:41:40 +0800
From: lepton <ytht.net@gmail.com>
To: lkm <linux-kernel@vger.kernel.org>
Subject: [PATCH] 2.6.20.4 fix kernel panic on corrupted reiserfs directory
Message-ID: <20070405064140.GA19620@router.lepton.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  When reading corrupted reiserfs directory data, d_reclen
  could be a negative number, then memcpy will overflow
  kernel stack. This can lead to kernel panic.
  The following patch adds a sanity check. (against 2.6.20.4)
 
Signed-off-by: Lepton Wu <ytht.net@gmail.com>

diff -pru linux-2.6/fs/reiserfs/dir.c linux-2.6-lepton/fs/reiserfs/dir.c
--- linux-2.6/fs/reiserfs/dir.c	2007-02-20 14:34:32.000000000 +0800
+++ linux-2.6-lepton/fs/reiserfs/dir.c	2007-04-05 14:35:58.000000000 +0800
@@ -121,6 +121,11 @@ static int reiserfs_readdir(struct file 
 					/* it is hidden entry */
 					continue;
 				d_reclen = entry_length(bh, ih, entry_num);
+				if (d_reclen < 0) {
+					pathrelse(&path_to_entry);
+					ret = -EIO;
+					goto out;
+				}
 				d_name = B_I_DEH_ENTRY_FILE_NAME(bh, ih, deh);
 				if (!d_name[d_reclen - 1])
 					d_reclen = strlen(d_name);
O
