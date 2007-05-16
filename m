Return-Path: <linux-kernel-owner+w=401wt.eu-S1758888AbXEPOh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888AbXEPOh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 10:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbXEPOhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 10:37:21 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:33141 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754605AbXEPOhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 10:37:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type;
  b=tJ+fGqlxoqrswreXilmAn3tdTUHL5XxiqBJM3ME7F01MsIdVzPsMerQPAhncfmR6uHvA9Wsshw1WGFJcH7axQp/z0CkV2Mr2C06X8K9OXNJMyfIgafOlhFoiAJxj9Uv9/Apo8QRdJrzAQQnw9uMNC1xtj/7Hy+8tRGGG0ObNYvw=  ;
X-YMail-OSG: bCfUEmIVM1mI_8IQffWdbhI4fCknboohAOhEV.1rEcpJUDpR9MK.eMbT.aAyv6qSNNTAaoUUfSvMzJfnCVEfh8G5PxF5ocUT4VCW_bvWwwMzCviUSQygnEpQilK9DA--
Message-ID: <464B1719.9030606@yahoo.com.au>
Date: Thu, 17 May 2007 00:37:13 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.22-rc1-mm1
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464B159B.6060902@googlemail.com>
In-Reply-To: <464B159B.6060902@googlemail.com>
Content-Type: multipart/mixed;
 boundary="------------070404040009020801040003"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070404040009020801040003
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Michal Piotrowski wrote:
> Andrew Morton napisał(a):
> 
>>ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/
>>
>>
>>- I found some time to look into some writeback problems in
>>  fs/fs-writeback.c.
> 
> 
> This might be related
> 
> [   97.740021] BUG: at /home/devel/linux-mm/mm/page-writeback.c:829 __set_page_dirty_nobuffers()
> [   97.748632]  [<c0105276>] dump_trace+0x63/0x1eb
> [   97.753275]  [<c0105418>] show_trace_log_lvl+0x1a/0x30
> [   97.758521]  [<c010605a>] show_trace+0x12/0x14
> [   97.763042]  [<c01060f7>] dump_stack+0x16/0x18
> [   97.767590]  [<c01677b3>] __set_page_dirty_nobuffers+0xfe/0x16e
> [   97.773598]  [<c0167833>] redirty_page_for_writepage+0x10/0x12
> [   97.779491]  [<c01a473a>] __block_write_full_page+0x1dc/0x335
> [   97.785328]  [<c01a495c>] block_write_full_page+0xc9/0xd1
> [   97.790799]  [<c01a781a>] blkdev_writepage+0x12/0x14
> [   97.795829]  [<c01674ea>] __writepage+0xe/0x29
> [   97.800350]  [<c01679b8>] write_cache_pages+0x183/0x29a
> [   97.805683]  [<c0167af1>] generic_writepages+0x22/0x2a
> [   97.810929]  [<c0167b1c>] do_writepages+0x23/0x34
> [   97.815702]  [<c019f0a3>] __writeback_single_inode+0x245/0x472
> [   97.821632]  [<c019f7e6>] generic_sync_sb_inodes+0x347/0x4cc
> [   97.827379]  [<c019f98b>] sync_sb_inodes+0x20/0x24
> [   97.832247]  [<c019fb93>] writeback_inodes+0x79/0xc2
> [   97.837296]  [<c0168173>] wb_kupdate+0x7a/0xdb
> [   97.841833]  [<c01686a0>] pdflush+0xf1/0x189
> [   97.846173]  [<c0137d41>] kthread+0x3b/0x62
> [   97.850461]  [<c0104e3f>] kernel_thread_helper+0x7/0x10

No, that's a debugging patch I put in that missed a couple of corner cases
(oops, you live and learn!).

Actually I worked out what this one is too: just a case of a page with
buffers (so the page itself may be dirty && !uptodate), which is calling
__set_page_dirty_nobuffers via redirty_page_for_writepages.

The patch I sent out earlier to fix Jiri's NFS warnings should take care
of this one as well.

-- 
SUSE Labs, Novell Inc.

--------------070404040009020801040003
Content-Type: text/plain;
 name="nfs-invariant-fix.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="nfs-invariant-fix.patch"

SW5kZXg6IGxpbnV4LTIuNi9tbS9wYWdlLXdyaXRlYmFjay5jCj09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0t
IGxpbnV4LTIuNi5vcmlnL21tL3BhZ2Utd3JpdGViYWNrLmMKKysrIGxpbnV4LTIuNi9tbS9w
YWdlLXdyaXRlYmFjay5jCkBAIC04MjYsNyArODI2LDcgQEAgaW50IF9fc2V0X3BhZ2VfZGly
dHlfbm9idWZmZXJzKHN0cnVjdCBwYQogCQltYXBwaW5nMiA9IHBhZ2VfbWFwcGluZyhwYWdl
KTsKIAkJaWYgKG1hcHBpbmcyKSB7IC8qIFJhY2Ugd2l0aCB0cnVuY2F0ZT8gKi8KIAkJCUJV
R19PTihtYXBwaW5nMiAhPSBtYXBwaW5nKTsKLQkJCVdBUk5fT04oIVBhZ2VVcHRvZGF0ZShw
YWdlKSk7CisJCQlXQVJOX09OKCFQYWdlUHJpdmF0ZShwYWdlKSAmJiAhUGFnZVVwdG9kYXRl
KHBhZ2UpKTsKIAkJCWlmIChtYXBwaW5nX2NhcF9hY2NvdW50X2RpcnR5KG1hcHBpbmcpKSB7
CiAJCQkJX19pbmNfem9uZV9wYWdlX3N0YXRlKHBhZ2UsIE5SX0ZJTEVfRElSVFkpOwogCQkJ
CXRhc2tfaW9fYWNjb3VudF93cml0ZShQQUdFX0NBQ0hFX1NJWkUpOwo=
--------------070404040009020801040003--
