Return-Path: <linux-kernel-owner+w=401wt.eu-S1760160AbXEPNBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760160AbXEPNBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 09:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbXEPNBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 09:01:04 -0400
Received: from pat.uio.no ([129.240.10.15]:60497 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbXEPNBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 09:01:03 -0400
Subject: Re: (NFS) BUG: at page-writeback.c:829 [Was: 2.6.22-rc1-mm1]
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <464AFB81.5050109@yahoo.com.au>
References: <20070515201914.16944e04.akpm@linux-foundation.org>
	 <464AF4A6.5060000@gmail.com>  <464AFB81.5050109@yahoo.com.au>
Content-Type: text/plain
Date: Wed, 16 May 2007 09:00:57 -0400
Message-Id: <1179320457.6521.16.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.143)
X-UiO-Scanned: 1EB45BAE29DC6B6464CF288E1C91C8C2A2A123D1
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 25 total 1774783 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-16 at 22:39 +1000, Nick Piggin wrote:
> >  =======================
> > BUG: at /local/xslaby/xxx/mm/page-writeback.c:829 __set_page_dirty_nobuffers()
> >  [<c010531e>] dump_trace+0x1ce/0x200
> >  [<c010536a>] show_trace_log_lvl+0x1a/0x30
> >  [<c0106012>] show_trace+0x12/0x20
> >  [<c0106086>] dump_stack+0x16/0x20
> >  [<c015566d>] __set_page_dirty_nobuffers+0x11d/0x130
> >  [<f8b1fc5b>] nfs_updatepage+0x7b/0x200 [nfs]
> >  [<f8b156df>] nfs_commit_write+0x2f/0x50 [nfs]
> >  [<c0150911>] generic_file_buffered_write+0x2a1/0x660
> >  [<c0150f52>] __generic_file_aio_write_nolock+0x282/0x520
> >  [<c0151252>] generic_file_aio_write+0x62/0xd0
> >  [<f8b15def>] nfs_file_write+0xef/0x1c0 [nfs]
> >  [<c01715e0>] do_sync_write+0xd0/0x110
> >  [<c0171e04>] vfs_write+0x94/0x130
> >  [<c017248d>] sys_write+0x3d/0x70
> >  [<c01040e8>] syscall_call+0x7/0xb
> >  [<b7eb7b3e>] 0xb7eb7b3e
> >  =======================
> 
> This one is NFS, setting the page dirty while it is not uptodate. Trond,
> is this because NFS keeps track of dirty regions of the page with private
> data? It might make sense to avoid this warning if PagePrivate is set...
> would that fix the NFS case?

Ah... You put an extra WARN_ON(!PageUptodate(page)). err=-ENOCOFFEE, I
missed that...


So yes, in order to avoid having to read the page in when we just want
to write data, NFS does this kind of tracking. I dunno if your fix to
change it to !PagePrivate(page) && !PageUptodate(page) is right though.
It will indeed fix the NFS case, but the block system uses PagePrivate()
pretty extensively for its own nefarious ends (tracking page buffers).

Trond

