Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbYANSRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbYANSRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 13:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbYANSQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 13:16:51 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:17144 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYANSQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 13:16:50 -0500
Date: Mon, 14 Jan 2008 13:14:54 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: Zach Brown <zach.brown@oracle.com>, Erez Zadok <ezk@cs.sunysb.edu>,
       linux-kernel@vger.kernel.org, ext3-users@redhat.com,
       Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org
Subject: Re: lockdep warning with LTP dio test (v2.6.24-rc6-125-g5356f66)
Message-ID: <20080114131454.37eb7c12@think.oraclecorp.com>
In-Reply-To: <20080114170609.GH4214@duck.suse.cz>
References: <200712242302.lBON2O8s011190@agora.fsl.cs.sunysb.edu>
	<477BF72B.4000608@oracle.com>
	<20080114170609.GH4214@duck.suse.cz>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2008 18:06:09 +0100
Jan Kara <jack@suse.cz> wrote:

> On Wed 02-01-08 12:42:19, Zach Brown wrote:
> > Erez Zadok wrote:
> > > Setting: ltp-full-20071031, dio01 test on ext3 with Linus's
> > > latest tree. Kernel w/ SMP, preemption, and lockdep configured.
> > 
> > This is a real lock ordering problem.  Thanks for reporting it.
> > 
> > The updating of atime inside sys_mmap() orders the mmap_sem in the
> > vfs outside of the journal handle in ext3's inode dirtying:
> > 

[ lock inversion traces ]
 
> > Two fixes come to mind:
> > 
> > 1) use something like Peter's ->mmap_prepare() to update atime
> > before acquiring the mmap_sem.
> > ( http://lkml.org/lkml/2007/11/11/97 ).  I don't know if this would
> > leave more paths which do a journal_start() while holding the
> > mmap_sem.
> > 
> > 2) rework ext3's dio to only hold the jbd handle in
> > ext3_get_block(). Chris has a patch for this kicking around
> > somewhere but I'm told it has problems exposing old blocks in
> > ordered data mode.
> > 
> > Does anyone have preferences?  I could go either way.  I certainly
> > don't like the idea of journal handles being held across the
> > entirety of fs/direct-io.c.  It's yet another case of O_DIRECT
> > differing wildly from the buffered path :(.
>   I've looked more into it and I think that 2) is the only way to go
> since transaction start ranks below page lock (standard buffered
> write path) and page lock ranks below mmap_sem. So we have at least
> one more dependency mmap_sem must go before transaction start...

Just to clarify a little bit:

If ext3's DIO code only touches transactions in get_block, then it can
violate data=ordered rules.  Basically the transaction that allocates
the blocks might commit before the DIO code gets around to writing them.

A crash in the wrong place will expose stale data on disk.

-chris
