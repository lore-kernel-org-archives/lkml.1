Return-Path: <linux-kernel-owner+w=401wt.eu-S1751815AbZHaPDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbZHaPDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 11:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbZHaPDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 11:03:38 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:18092 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750872AbZHaPDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 11:03:37 -0400
X-Trace: 255419715/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.31.213/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.31.213
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4EAMeCm0pQKR/V/2dsb2JhbACBU45OAcgOhBoF
X-IronPort-AV: E=Sophos;i="4.44,305,1249254000"; 
   d="scan'208";a="255419715"
Date: Mon, 31 Aug 2009 16:03:02 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <ak@linux.intel.com>, Dave Hansen <haveblue@us.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Valerie Aurora <vaurora@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: [PATCH mmotm] vfs: optimize touch_time too fix
Message-ID: <Pine.LNX.4.64.0908311558220.4384@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent mmotms give me WARNING: at fs/namespace.c:612 mntput_no_expire()+...
when unmounting: __mntput()'s WARN_ON(count_mnt_writers(mnt)).

That's because vfs-optimize-touch_time-too.patch inverted the sense
of mnt_want_write_file(), which is error-returning, not a boolean.

Presumably filetime updates went missing too, but I didn't notice those.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 fs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm/fs/inode.c	2009-08-28 10:07:56.000000000 +0100
+++ linux/fs/inode.c	2009-08-31 14:08:24.000000000 +0100
@@ -1481,7 +1481,7 @@ void file_update_time(struct file *file)
 		return;
 
 	/* Finally allowed to write? Takes lock. */
-	if (!mnt_want_write_file(file))
+	if (mnt_want_write_file(file))
 		return;
 
 	/* Only change inode inside the lock region */
