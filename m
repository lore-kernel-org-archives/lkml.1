Return-Path: <linux-kernel-owner+w=401wt.eu-S1752966AbXDXPuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbXDXPuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 11:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbXDXPuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 11:50:12 -0400
Received: from pat.uio.no ([129.240.10.15]:39588 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbXDXPuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 11:50:10 -0400
Subject: Re: NFS: Unable to handle kernel NULL pointer dereference at
	nfs_set_page_dirty+0xd/0x5d in 2.6.21rc7-git6
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <200704241605.45353.ak@suse.de>
References: <200704241605.45353.ak@suse.de>
Content-Type: text/plain
Date: Tue, 24 Apr 2007 11:57:55 -0700
Message-Id: <1177441075.5498.6.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=1.0, required=12.0, autolearn=disabled, AWL=-1.030,DATE_IN_FUTURE_03_06=2.061)
X-UiO-Spam-Score: s
X-UiO-Scanned: 8975B5453F3A9B8851389CA3DADE59F776DD3568
X-UiO-Ratelimit-Test: Ratelimit
X-UiO-SPAM-Test: UIO-RATELIMIT remote_host: 129.240.10.9 spam_score: 10 maxlevel 200 minaction 2 bait 0 mail/h: 1070 total 1302829 max/h 8345 blacklist 0 greylist 0 ratelimit 1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-24 at 16:05 +0200, Andi Kleen wrote:
> 
> Another issue hit during LTP testing over nfsroot; this time
> on a larger box (4 cores; 6GB RAM; x86-64) 
> 
> NFS doesn't seem to be in a good shape for .21
> 
> -Andi
> 
> Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP:
>  [<ffffffff8031076b>] nfs_set_page_dirty+0xd/0x5d
> PGD 115735067 PUD 11a60a067 PMD 0
> Oops: 0000 [1] SMP
> CPU 1
> Modules linked in:
> Pid: 8476, comm: doio Not tainted 2.6.21-rc7-git6 #20
> RIP: 0010:[<ffffffff8031076b>]  [<ffffffff8031076b>] nfs_set_page_dirty+0xd/0x5d
> RSP: 0000:ffff8101157b7d98  EFLAGS: 00010292
> RAX: 0000000000000000 RBX: ffff81011f9462d8 RCX: 0000000000000004
> RDX: ffff810117840430 RSI: 0000000000000004 RDI: ffff81011f9462d8
> RBP: ffff81011f9462d8 R08: ffff81011c03f205 R09: ffff81011c03f202
> R10: ffff81011a41f228 R11: ffffffff8031075e R12: 0000000114a6cc40
> R13: ffff810117840430 R14: ffff81011b3bdb88 R15: ffff81011fd847b0
> FS:  00002af288f0bb00(0000) GS:ffff81011c03f0c0(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000117297000 CR4: 00000000000006e0
> Process doio (pid: 8476, threadinfo ffff8101157b6000, task ffff81011b8c8240)
> Stack:  ffff81011f9462d8 ffff81011f9462d8 ffff81011f9462d8 ffffffff8025a0bc
>  ffff810114a6cc40 ffffffff80260b75 ffff81011fd77f78 000000011fef0340
>  00002af289388714 ffff81011a4f04c0 0000000000000c40 ffff81011a952248
> Call Trace:
>  [<ffffffff8025a0bc>] set_page_dirty_balance+0x9/0x39
>  [<ffffffff80260b75>] __handle_mm_fault+0x43e/0x9e1
>  [<ffffffff80544f7e>] do_page_fault+0x42b/0x7ad
>  [<ffffffff80265815>] do_mmap_pgoff+0x619/0x785
>  [<ffffffff8027b951>] sys_newfstat+0x20/0x29
>  [<ffffffff805433ad>] error_exit+0x0/0x84
> 
> 
> Code: 48 8b 28 48 8d 7d a8 e8 eb 26 23 00 48 89 df e8 e9 e6 ff ff
> RIP  [<ffffffff8031076b>] nfs_set_page_dirty+0xd/0x5d
>  RSP <ffff8101157b7d98>
> CR2: 0000000000000000

Does this patch fix it?

Cheers
  Trond

--------
commit 0a3f1babc525d217df045bd4d1150d1338f053b3
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Tue Apr 24 11:55:16 2007 -0700

    NFS: Fix nfs_set_page_dirty()
    
    Be more careful about testing page->mapping.
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 7975589..8593965 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1531,10 +1531,18 @@ int nfs_wb_page(struct inode *inode, struct page* page)
 
 int nfs_set_page_dirty(struct page *page)
 {
-	spinlock_t *req_lock = &NFS_I(page->mapping->host)->req_lock;
+	struct address_space *mapping = page->mapping;
+	struct inode *inode;
+	spinlock_t *req_lock;
 	struct nfs_page *req;
 	int ret;
 
+	if (!mapping)
+		goto out_raced;
+	inode = mapping->host;
+	if (!inode)
+		goto out_raced;
+	req_lock = &NFS_I(inode)->req_lock;
 	spin_lock(req_lock);
 	req = nfs_page_find_request_locked(page);
 	if (req != NULL) {
@@ -1547,6 +1555,8 @@ int nfs_set_page_dirty(struct page *page)
 	ret = __set_page_dirty_nobuffers(page);
 	spin_unlock(req_lock);
 	return ret;
+out_raced:
+	return !TestSetPageDirty(page);
 }
 
 


