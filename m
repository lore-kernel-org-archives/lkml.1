Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbYBRPDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbYBRPDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 10:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYBRPDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 10:03:42 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:42118 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752658AbYBRPDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:03:41 -0500
Date: Mon, 18 Feb 2008 10:03:33 -0500
From: Theodore Tso <tytso@mit.edu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: very poor ext3 write performance on big filesystems?
Message-ID: <20080218150333.GA25098@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	LKML <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <47B980AC.2080806@wpkg.org> <p7363wmxsxr.fsf@bingen.suse.de> <20080218141640.GC12568@mit.edu> <20080218151823.GA26622@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218151823.GA26622@one.firstfloor.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 04:18:23PM +0100, Andi Kleen wrote:
> On Mon, Feb 18, 2008 at 09:16:41AM -0500, Theodore Tso wrote:
> > ext3 tries to keep inodes in the same block group as their containing
> > directory.  If you have lots of hard links, obviously it can't really
> > do that, especially since we don't have a good way at mkdir time to
> > tell the filesystem, "Psst!  This is going to be a hard link clone of
> > that directory over there, put it in the same block group".
> 
> Hmm, you think such a hint interface would be worth it?

It would definitely help ext2/3/4.  An interesting question is whether
it would help enough other filesystems that's worth adding.  

> > necessarily removing the dir_index feature.  Dir_index speeds up
> > individual lookups, but it slows down workloads that do a readdir
> 
> But only for large directories right? For kernel source like
> directory sizes it seems to be a general loss.

On my todo list is a hack which does the sorting of directory inodes
by inode number inside the kernel for smallish directories (say, less
than 2-3 blocks) where using the kernel memory space to store the
directory entries is acceptable, and which would speed up dir_index
performance for kernel source-like directory sizes --- without needing
to use the spd_readdir LD_PRELOAD hack.

But yes, right now, if you know that your directories are almost
always going to be kernel source like in size, then omitting dir_index
is probably goint to be a good idea.  

						- Ted
