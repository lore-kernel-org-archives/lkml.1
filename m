Return-Path: <linux-kernel-owner+w=401wt.eu-S1758680AbXH1IeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680AbXH1IeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 04:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755352AbXH1IeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 04:34:13 -0400
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:41355 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbXH1IeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 04:34:10 -0400
Message-Id: <200708280832.AA00252@paprika.lab.ntt.co.jp>
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Date: Tue, 28 Aug 2007 17:32:36 +0900
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [BUG] problem with nfs_invalidate_page
In-Reply-To: <1188221412.6701.45.camel@heimdal.trondhjem.org>
References: <1188221412.6701.45.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
X-Mailer: AL-Mail32 Version 1.13
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007 09:30:12 -0400, Trond Myklebust wrote:
>It looks as if ecryptfs is dropping the page lock between the calls to
>prepare_write() and commit_write(). That would be a bug.

No, ecryptfs is holding the page lock between the calls to 
nfs_prepare_write() and nfs_commit_write().
This is a regression since kernel 2.6.20;  kernel 2.6.19 does not 
yield the BUG.

Please look at truncate_complete_page() and nfs_wb_page_priority() 
which is called from nfs_invalidate_page().

The recent truncate_complete_page() clears the dirty flag from a page
before calling a_ops->invalidatepage(),
^^^^^^
static void
truncate_complete_page(struct address_space *mapping, struct page *page)
{
        ...
	cancel_dirty_page(page, PAGE_CACHE_SIZE);  <--- Inserted here at kernel 2.6.20

	if (PagePrivate(page))
		do_invalidatepage(page, 0);   ---> will call a_ops->invalidatepage()
        ...
}

and this is disturbing nfs_wb_page_priority() from calling 
nfs_writepage_locked() that is expected to handle the pending
request (=nfs_page) associated with the page.

int nfs_wb_page_priority(struct inode *inode, struct page *page, int how)
{
	...
	if (clear_page_dirty_for_io(page)) {
		ret = nfs_writepage_locked(page, &wbc);
		if (ret < 0)
			goto out;
	}
 	...
}

Since truncate_complete_page() will get rid of the page after
a_ops->invalidatepage() returns, the request (=nfs_page) associated
with the page becomes a garbage in nfs_inode->nfs_page_tree.

This causes the collision of nfs_page and yields the BUG.


Cheers,
Ryusuke Konishi


>
>On Fri, 2007-08-24 at 16:43 +0900, Ryusuke Konishi wrote:
>> Hi,
>> 
>> I got the following BUG in nfs_inode_add_request() when I was using
>> eCryptfs on NFS. (Don't ask me why I was doing that)
>> 
>> ------------[ cut here ]------------
>> kernel BUG at fs/nfs/write.c:387!
>> invalid opcode: 0000 [#1]
>> PREEMPT SMP
>> Modules linked in: cbc md5 aes ecb blkcipher cryptomgr crypto_algapi ecryptfs
>> nfs iscsi_tcp libiscsi scsi_transport_iscsi nfsd exportfs lockd nfs_acl sunrpc
>> nbd md_mod dm_snapshot dm_mirror dm_mod video output
>> CPU:    5
>> EIP:    0060:[<f90113e2>]    Not tainted VLI
>> EFLAGS: 00010246   (2.6.23-rc3 #5)
>> EIP is at nfs_writepage_setup+0xc8/0x305 [nfs]
>> eax: ffffffef   ebx: ffffffef   ecx: 00000000   edx: f776a6c8
>> esi: f776a700   edi: f3392680   ebp: f6489c04   esp: f6489bc4
>> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
>> Process dd (pid: 4260, ti=f6488000 task=f5719500 task.ti=f6488000)
>> Stack: 00000000 00001000 dd751a4f 730e4905 00000000 c404e0c0 f5a86a80 f33927e4
>>        f3392774 00000000 f6489bf4 c029e298 00000000 f6812780 00000000 c404e0c0
>>        f6489c44 f9011b8c 00001000 00001000 00000010 fff2b000 f6489d08 00000246
>> Call Trace:
>>  [<c01082d6>] show_trace_log_lvl+0x1a/0x2f
>>  [<c0108388>] show_stack_log_lvl+0x9d/0xa5
>>  [<c0108581>] show_registers+0x1f1/0x332
>>  [<c01087dd>] die+0x11b/0x250
>>  [<c0480cd0>] do_trap+0x8a/0xa3
>>  [<c0108bd1>] do_invalid_op+0x88/0x92
>>  [<c0480a9a>] error_code+0x72/0x78
>>  [<f9011b8c>] nfs_updatepage+0x14d/0x1b3 [nfs]
>>  [<f9008f93>] nfs_commit_write+0x29/0x39 [nfs]
>>  [<f8fe0ae5>] ecryptfs_commit_lower_page+0x26/0x6b [ecryptfs]
>>  [<f8fe2675>] ecryptfs_write_out_page+0x28/0x73 [ecryptfs]
>>  [<f8fe32ac>] ecryptfs_encrypt_page+0x3a4/0x419 [ecryptfs]
>>  [<f8fe12e0>] ecryptfs_commit_write+0x1ba/0x31f [ecryptfs]
>>  [<c015c1ab>] generic_file_buffered_write+0x3a6/0x54e
>>  [<c015c793>] __generic_file_aio_write_nolock+0x440/0x493
>>  [<c015c83c>] generic_file_aio_write+0x56/0xb4
>>  [<c0178a7c>] do_sync_write+0xc5/0x102
>>  [<c017923e>] vfs_write+0xaf/0x138
>>  [<c0179806>] sys_write+0x3d/0x61
>>  [<c010719a>] syscall_call+0x7/0xb
>>  =======================
>> Code: 00 00 00 f0 0f ba 6e 28 00 19 c0 8b 7d e0 81 ef f4 00 00 00 8b 56
>> 14 8b 45 e0 83 e8 1c 89 f1 e8 50 db 29 c7 89 c3 83 f8 ef 75 04 <0f> 0b
>> eb fe 85 c0 75 4e 83 bf e8 00 00 00 00 75 10 8b 45 e0 e8
>> EIP: [<f90113e2>] nfs_writepage_setup+0xc8/0x305 [nfs] SS:ESP 0068:f6489bc4
>> 
>> As you may have guessed, the BUG shows a collision of nfs_page in a nfs
>> page tree.  That is, there is a case that nfs_page remains even if 
>> the requested page is removed from page cache.
>> 
>> static int nfs_inode_add_request(struct inode *inode, struct nfs_page *req)
>> {
>>         struct nfs_inode *nfsi = NFS_I(inode);
>>         int error;
>> 
>>         error = radix_tree_insert(&nfsi->nfs_page_tree, req->wb_index, req);
>>         BUG_ON(error == -EEXIST);
>>         ...
>> }
>> 
>> By some tests, it turned out to be a discordance between 
>> nfs_invalidate_page() and truncate_inode_pages() in recent kernels.
>> 
>> In kernel 2.6.20, truncate_complete_page() was changed to clear dirty flag
>> from the removing page just before calling a_ops->invalidatepage().
>> As a result, nfs_wb_page_priority(), which is called from nfs_invalidate_page(),
>> get to skip nfs_writepage_locked() that starts to write dirty pages.
>> 
>> int nfs_wb_page_priority(struct inode *inode, struct page *page, int how)
>> {
>> 	...
>> 	if (clear_page_dirty_for_io(page)) {
>> 		ret = nfs_writepage_locked(page, &wbc);
>> 		if (ret < 0)
>> 			goto out;
>> 	}
>> 	if (!PagePrivate(page))
>> 		return 0;
>> 	ret = nfs_sync_mapping_wait(page->mapping, &wbc, how);
>>  	...
>> }
>> 
>> Since nfs_sync_mapping_wait() does not care for non-dirty, unwritten,
>> and uncommitted pages, their nfs_page get into orphans.
>> It seems to need some sort of change to handle unwritten non-dirty
>> pages.
>> 
>> For reference, I will show the way to reproduce the BUG using
>> eCryptfs below.  I tried other way, but I couldn't find simpler
>> way not requiring eCryptfs so far.
>> 
>>  # mount -t nfs server:/pub /nfs
>>  # mount -t ecryptfs -o cipher=aes,ecryptfs_key_bytes=16 /nfs /secret
>>  # dd if=/dev/zero of=/secret/aaa bs=4096 count=1
>>  # dd if=/dev/zero of=/secret/aaa bs=4096 count=1
>> 
>> These procedures do truncate an unwritten NFS page.
>> Note that overwritting without use of eCryptfs doesn't reproduce 
>> the problem because it calls nfs_setattr() and forces the pages 
>> to be written back.
>> 
>> Cheers,
>> Ryusuke Konishi
>
>
