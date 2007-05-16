Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbXEPNHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbXEPNHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 09:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbXEPNHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 09:07:08 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:45259 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752203AbXEPNHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 09:07:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=rKGqmJbVbXKl6rtpAfDLLqWQfq+MdxeX9hJHr1dBB1KaZ67RurAalTyrJa3P1hf7z+CaKwrUfqMRw9okSHBjlSjPEpHI73r/Ox4VPA/mqzhpfd5W5FI5A8pqf/BSGJEafFRVtfJ3IxheKz4gwScEU8QT76mcPmJmBjlNspctBvg=  ;
X-YMail-OSG: tb262yoVM1k3MZRdNwLkAMVMPspROS1qKyMi872B_2g9VZv2zsSeAsEWrCANdznwFJOHi2HNAQ--
Message-ID: <464B01F3.5000306@yahoo.com.au>
Date: Wed, 16 May 2007 23:06:59 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: (NFS) BUG: at page-writeback.c:829 [Was: 2.6.22-rc1-mm1]
References: <20070515201914.16944e04.akpm@linux-foundation.org>	 <464AF4A6.5060000@gmail.com>  <464AFB81.5050109@yahoo.com.au> <1179320457.6521.16.camel@heimdal.trondhjem.org>
In-Reply-To: <1179320457.6521.16.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote:
> On Wed, 2007-05-16 at 22:39 +1000, Nick Piggin wrote:
> 
>>> =======================
>>>BUG: at /local/xslaby/xxx/mm/page-writeback.c:829 __set_page_dirty_nobuffers()
>>> [<c010531e>] dump_trace+0x1ce/0x200
>>> [<c010536a>] show_trace_log_lvl+0x1a/0x30
>>> [<c0106012>] show_trace+0x12/0x20
>>> [<c0106086>] dump_stack+0x16/0x20
>>> [<c015566d>] __set_page_dirty_nobuffers+0x11d/0x130
>>> [<f8b1fc5b>] nfs_updatepage+0x7b/0x200 [nfs]
>>> [<f8b156df>] nfs_commit_write+0x2f/0x50 [nfs]
>>> [<c0150911>] generic_file_buffered_write+0x2a1/0x660
>>> [<c0150f52>] __generic_file_aio_write_nolock+0x282/0x520
>>> [<c0151252>] generic_file_aio_write+0x62/0xd0
>>> [<f8b15def>] nfs_file_write+0xef/0x1c0 [nfs]
>>> [<c01715e0>] do_sync_write+0xd0/0x110
>>> [<c0171e04>] vfs_write+0x94/0x130
>>> [<c017248d>] sys_write+0x3d/0x70
>>> [<c01040e8>] syscall_call+0x7/0xb
>>> [<b7eb7b3e>] 0xb7eb7b3e
>>> =======================
>>
>>This one is NFS, setting the page dirty while it is not uptodate. Trond,
>>is this because NFS keeps track of dirty regions of the page with private
>>data? It might make sense to avoid this warning if PagePrivate is set...
>>would that fix the NFS case?
> 
> 
> Ah... You put an extra WARN_ON(!PageUptodate(page)). err=-ENOCOFFEE, I
> missed that...
> 
> 
> So yes, in order to avoid having to read the page in when we just want
> to write data, NFS does this kind of tracking. I dunno if your fix to
> change it to !PagePrivate(page) && !PageUptodate(page) is right though.
> It will indeed fix the NFS case, but the block system uses PagePrivate()
> pretty extensively for its own nefarious ends (tracking page buffers).

I think that's OK: the block layer is similarly happy to mark a !uptodate
page dirty if it has buffers, for similar reasons... Anyway, it won't use
this particular path when buffers are attached, and I've put similar
debugging stuff in the set_page_dirty_buffers part.

-- 
SUSE Labs, Novell Inc.
