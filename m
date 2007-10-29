Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbXJ2Tsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbXJ2Tsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756827AbXJ2Trg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:47:36 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:22463 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811AbXJ2Trd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:47:33 -0400
Date: Mon, 29 Oct 2007 15:46:57 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Mike Waychison <mikew@google.com>
Cc: Zach Brown <zab@zabbo.net>, Anton Altaparmakov <aia21@cam.ac.uk>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/6][RFC] Cleanup FIBMAP
Message-ID: <20071029154657.04ddd13b@think.oraclecorp.com>
In-Reply-To: <472631FE.9070003@google.com>
References: <20071026233732.568575496@crlf.corp.google.com>
	<E579083F-FED3-4990-8E24-275ED38E9E3B@cam.ac.uk>
	<20071029101001.4378a7cf@think.oraclecorp.com>
	<47260AB1.9000003@zabbo.net>
	<472631FE.9070003@google.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007 12:18:22 -0700
Mike Waychison <mikew@google.com> wrote:

> Zach Brown wrote:
> >>> And another of my pet peeves with ->bmap is that it uses 0 to
> >>> mean "sparse" which causes a conflict on NTFS at least as block
> >>> zero is part of the $Boot system file so it is a real, valid
> >>> block...  NTFS uses -1 to denote sparse blocks internally.
> >> Reiserfs and Btrfs also use 0 to mean packed.  It would be nice if
> >> there was a way to indicate your-data-is-here-but-isn't-alone.
> >> But that's more of a feature for the FIEMAP stuff.
> > 
> > And maybe we can step back and see what the callers of FIBMAP are
> > doing with the results they're getting.
> > 
> > One use is to discover the order in which to read file data that
> > will result in efficient IO.
> > 
> > If we had an interface specifically for this use case then perhaps a
> > sparse block would be better reported as the position of the inode
> > relative to other data blocks.  Maybe the inode block number in
> > ext* land.
> > 
> 
> Can you clarify what you mean above with an example?  I don't really
> follow.

This is a larger topic of helping userland optimize access to groups of
files.  For example, during a readdir if we knew the next step was to
delete all the files found, we could do one top of readahead (or even
ordering the returned values).

If we knew the next step would be to read all the files found, a
different type of readahead would be useful.

But, we shouldn't inflict all of this on fibmap/fiemap....we'll get
lost trying to make the one true interface for all operations.

For grouping operations on files, I think a read_tree syscall with
hints for what userland will do (read, stat, delete, list
filenames), and a better cookie than readdir should do it.

-chris
