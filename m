Return-Path: <linux-kernel-owner+w=401wt.eu-S1759338AbYEOW2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338AbYEOW2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 18:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbYEOW2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 18:28:38 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38928 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752638AbYEOW2h (ORCPT
	<rfc822;@sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 18:28:37 -0400
Date: Fri, 16 May 2008 08:27:53 +1000
From: David Chinner <dgc@sgi.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: David Chinner <dgc@sgi.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, pvp-lsts@fs.ru.acad.bg,
       kernel-testers@vger.kernel.org,
       kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       peterz@infradead.org, xfs@oss.sgi.com
Subject: Re: 2.6.26-rc1: possible circular locking dependency with xfs filesystem
Message-ID: <20080515222753.GV155679365@sgi.com>
References: <a4423d670805101005x113c4813w2b95c1fb535cf080@mail.gmail.com> <4825DF71.1030209@linux.vnet.ibm.com> <48266C77.3040102@linux.vnet.ibm.com> <20080511231002.GN103491721@sgi.com> <a4423d670805151045k4d2f9459geaeeff7418957487@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670805151045k4d2f9459geaeeff7418957487@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 09:45:55PM +0400, Alexander Beregalov wrote:
> 2008/5/12 David Chinner <dgc@sgi.com>:
> > On Sun, May 11, 2008 at 09:18:07AM +0530, Kamalesh Babulal wrote:
> >> Kamalesh Babulal wrote:
> >> > Adding the cc to kernel-list, Ingo Molnar and Peter Zijlstra
> >> >
> >> > Alexander Beregalov wrote:
> >> >> [ INFO: possible circular locking dependency detected ]
> >> >> 2.6.26-rc1-00279-g28a4acb #13
> >> >> -------------------------------------------------------
> >> >> nfsd/3087 is trying to acquire lock:
> >> >>  (iprune_mutex){--..}, at: [<c016f947>] shrink_icache_memory+0x38/0x19b
> >> >>
> >> >> but task is already holding lock:
> >> >>  (&(&ip->i_iolock)->mr_lock){----}, at: [<c0210b83>] xfs_ilock+0xa2/0xd6

[snip]

> > Oh, yeah, that. Direct inode reclaim through memory pressure.
> >
> > Effectively memory reclaim inverts locking order w.r.t. iprune_mutex
> > when it recurses into the filesystem. False positive - can never
> > cause a deadlock on XFS. Can't be solved from the XFS side of things
> > without effectively turning off lockdep checking for xfs inode
> > locking.
> Yes, it is not a deadlock, but machine hangs for few seconds.
> It still happens about once a day for me. Every kernel report looks
> similar to the above.

That hang is just memory reclaim running, I think you'll find.
It can take some time for reclaim to find pages to use, and meanwhile
everything in the machine will back up behind it....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
