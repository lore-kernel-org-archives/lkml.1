Return-Path: <linux-kernel-owner+w=401wt.eu-S1756165AbZG1X5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbZG1X5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbZG1XuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:50:08 -0400
Received: from kroah.org ([198.145.64.141]:35792 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373AbZG1XuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:04 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:56 2009
Message-Id: <20090728234156.607583909@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [patch 35/71] nilfs2: fix incorrect KERN_CRIT messages in case of write failures
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=nilfs2-fix-incorrect-kern_crit-messages-in-case-of-write-failures.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

commit 4a52df779700080de4afb0436d9dd9188514a69b upstream.

In case of write-failure retries, the following KERN_CRIT level
messages are mistakenly output by nilfs_dat_commit_start() function:

nilfs_dat_commit_start: vbn = 408463, start = 12506, end = 18446744073709551615, pbn = 530210
nilfs_dat_commit_start: vbn = 408515, start = 12506, end = 18446744073709551615, pbn = 530211
nilfs_dat_commit_start: vbn = 408464, start = 12506, end = 18446744073709551615, pbn = 530212
...

This suppresses these messages.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nilfs2/dat.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -149,15 +149,6 @@ void nilfs_dat_commit_start(struct inode
 	entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
 					     req->pr_entry_bh, kaddr);
 	entry->de_start = cpu_to_le64(nilfs_mdt_cno(dat));
-	if (entry->de_blocknr != cpu_to_le64(0) ||
-	    entry->de_end != cpu_to_le64(NILFS_CNO_MAX)) {
-		printk(KERN_CRIT
-		       "%s: vbn = %llu, start = %llu, end = %llu, pbn = %llu\n",
-		       __func__, (unsigned long long)req->pr_entry_nr,
-		       (unsigned long long)le64_to_cpu(entry->de_start),
-		       (unsigned long long)le64_to_cpu(entry->de_end),
-		       (unsigned long long)le64_to_cpu(entry->de_blocknr));
-	}
 	entry->de_blocknr = cpu_to_le64(blocknr);
 	kunmap_atomic(kaddr, KM_USER0);
 


