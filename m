Return-Path: <linux-kernel-owner+w=401wt.eu-S1762118AbXEPQ6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762118AbXEPQ6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbXEPQ6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:58:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:25837 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbXEPQ6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:58:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=XVmdrsbQT9+q7MooWbQyLtaVwErgnOL/mzzE/7M1WxHzPC/bTdJjUifxYY82RHe9yXpEOcrBM+w6dtvkD1R8tfYX+3oTgUlmRWNUdy1N3uN2Mmk44tahh0Di1TgTCv+O41Lw1ttcqDJKs1W+VXe/xOrndFBXZ/5/FQUZMyYNt0M=
Message-ID: <464B382F.3090307@gmail.com>
Date: Wed, 16 May 2007 18:58:23 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: 2.6.22-rc1-mm1
References: <20070515201914.16944e04.akpm@linux-foundation.org>	 <464B159B.6060902@googlemail.com> <464B1719.9030606@yahoo.com.au> <6bffcb0e0705160935r1767a764hce72f24f9eee6c1e@mail.gmail.com>
In-Reply-To: <6bffcb0e0705160935r1767a764hce72f24f9eee6c1e@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski napsal(a):
> On 16/05/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
>> Michal Piotrowski wrote:
>> > Andrew Morton napisał(a):
>> >
>> >>ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/
>>
>> >>
>> >>
>> >>- I found some time to look into some writeback problems in
>> >>  fs/fs-writeback.c.
>> >
>> >
>> > This might be related
>> >
>> > [   97.740021] BUG: at /home/devel/linux-mm/mm/page-writeback.c:829
>> __set_page_dirty_nobuffers()
>> > [   97.748632]  [<c0105276>] dump_trace+0x63/0x1eb
>> > [   97.753275]  [<c0105418>] show_trace_log_lvl+0x1a/0x30
>> > [   97.758521]  [<c010605a>] show_trace+0x12/0x14
>> > [   97.763042]  [<c01060f7>] dump_stack+0x16/0x18
>> > [   97.767590]  [<c01677b3>] __set_page_dirty_nobuffers+0xfe/0x16e
>> > [   97.773598]  [<c0167833>] redirty_page_for_writepage+0x10/0x12
>> > [   97.779491]  [<c01a473a>] __block_write_full_page+0x1dc/0x335
>> > [   97.785328]  [<c01a495c>] block_write_full_page+0xc9/0xd1
>> > [   97.790799]  [<c01a781a>] blkdev_writepage+0x12/0x14
>> > [   97.795829]  [<c01674ea>] __writepage+0xe/0x29
>> > [   97.800350]  [<c01679b8>] write_cache_pages+0x183/0x29a
>> > [   97.805683]  [<c0167af1>] generic_writepages+0x22/0x2a
>> > [   97.810929]  [<c0167b1c>] do_writepages+0x23/0x34
>> > [   97.815702]  [<c019f0a3>] __writeback_single_inode+0x245/0x472
>> > [   97.821632]  [<c019f7e6>] generic_sync_sb_inodes+0x347/0x4cc
>> > [   97.827379]  [<c019f98b>] sync_sb_inodes+0x20/0x24
>> > [   97.832247]  [<c019fb93>] writeback_inodes+0x79/0xc2
>> > [   97.837296]  [<c0168173>] wb_kupdate+0x7a/0xdb
>> > [   97.841833]  [<c01686a0>] pdflush+0xf1/0x189
>> > [   97.846173]  [<c0137d41>] kthread+0x3b/0x62
>> > [   97.850461]  [<c0104e3f>] kernel_thread_helper+0x7/0x10
>>
>> No, that's a debugging patch I put in that missed a couple of corner
>> cases
>> (oops, you live and learn!).
>>
>> Actually I worked out what this one is too: just a case of a page with
>> buffers (so the page itself may be dirty && !uptodate), which is calling
>> __set_page_dirty_nobuffers via redirty_page_for_writepages.
>>
>> The patch I sent out earlier to fix Jiri's NFS warnings should take care
>> of this one as well.
> 
> Problem fixed, thanks.

For me too.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
