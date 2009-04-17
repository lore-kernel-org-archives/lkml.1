Return-Path: <linux-kernel-owner+w=401wt.eu-S1758657AbZDQMkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657AbZDQMkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 08:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbZDQMkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 08:40:19 -0400
Received: from THUNK.ORG ([69.25.196.29]:33004 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809AbZDQMkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 08:40:17 -0400
Date: Fri, 17 Apr 2009 08:38:05 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, Jens Axboe <jens.axboe@oracle.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] ext3: do not throttle metadata and journal IO
Message-ID: <20090417123805.GC7117@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrea Righi <righi.andrea@gmail.com>,
	Paul Menage <menage@google.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
	baramsori72@gmail.com, Carl Henrik Lunde <chlunde@ping.uio.no>,
	dave@linux.vnet.ibm.com, Divyesh Shah <dpshah@google.com>,
	eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
	Hirokazu Takahashi <taka@valinux.co.jp>,
	Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
	dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
	roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
	Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
	yoshikawa.takuya@oss.ntt.co.jp, Jens Axboe <jens.axboe@oracle.com>,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com> <1239740480-28125-10-git-send-email-righi.andrea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239740480-28125-10-git-send-email-righi.andrea@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 10:21:20PM +0200, Andrea Righi wrote:
> Delaying journal IO can unnecessarily delay other independent IO
> operations from different cgroups.
> 
> Add BIO_RW_META flag to the ext3 journal IO that informs the io-throttle
> subsystem to account but not delay journal IO and avoid potential
> priority inversion problems.

So this worries me for two reasons.  First of all, the meaning of
BIO_RW_META is not well defined, but I'm concerned that you are using
the flag in a manner that in a way that wasn't its original intent.
I've included Jens on the cc list so he can comment on that score.

Secondly, there are many more locations than these which can end up
causing I/O which will ending up causing the journal commit to block
until they are completed.  I've done a lot of work in the past few
weeks to make sure those writes get marked using BIO_RW_SYNC.  In
data=ordered mode, the journal commit will block waiting for data
blocks to be written out, and that implies you really need to treat as
high priority all of the block writes that are marked with the
BIO_RW_SYNC flag.

The flip side of this is it may end up making your I/O controller to
leaky; that is, someone might be able to evade your I/O controller's
attempt to impose limits by using fsync() all the time.  This is a
hard problem, though, because filesystem I/O is almost always
intertwined.

What sort of scenarios and workloads are you envisioning might use
this I/O controller?  And can you say more about the specifics about
the priority inversion problem you are concerned about?

Regards,

						- Ted
