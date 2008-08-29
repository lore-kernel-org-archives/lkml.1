Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbYH2Kp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbYH2Kp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 06:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbYH2KpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 06:45:16 -0400
Received: from lazybastard.de ([212.112.238.170]:37413 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbYH2KpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 06:45:14 -0400
Date: Fri, 29 Aug 2008 12:45:00 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] nilfs2: continuous snapshotting file system
Message-ID: <20080829104459.GB27647@logfs.org>
References: <20080827181904.GD1371@logfs.org> <200808290629.AA00218@capsicum.lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200808290629.AA00218@capsicum.lab.ntt.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 August 2008 15:29:35 +0900, Ryusuke Konishi wrote:
> On Wed, 27 Aug 2008 20:19:04 +0200,  Jorn Engel wrote:
> 
> >Do you do wear leveling or scrubbing?
> 
> NILFS does not support scrubbing. (as you guessed)
> Under the current GC daemon, it writes logs sequentially and circularly
> in the partition, and as you know, this leads to the wear levelling
> except for superblock.

I am a bit confused here.  My picture of log-structured filesystems was
always that writes go round-robin _within_ a segment, but new segments
can be picked in any order.  So there is a good chance of some segments
simply never being picked and others constantly being reused.

If nilfs works in the same way, it will by design spread the writes
somewhat better than ext3, to pick an example, but can still lead to
local wear-out if f.e. 98% of the filesystem is full and the remaining
2% receive a high write load.

True wear leveling requires a bit more work.  Either some probabilistic
garbage collection of any random segment, as jffs2 does, or storing some
write counters and keeping them roughly level as logfs does.

> >How does garbage collection work?  In particular, when the filesystem
> >runs out of free space, do you depend on the userspace daemon to make
> >some policy decisions or can the kernel make progress on its own?
> 
> The GC of NILFS depends on the userspace daemon to make policy decisions.
> NILFS cannot reclaim disk space on its own though it can work 
> (i.e. read, write, or do other operations) without the daemon.
> After it runs out of free space, disk full errors will be returned
> until GC makes new space.

This looks problematic.  In logfs I was very careful to define a
"filesystem full" condition that is independent of GC.  So with a single
writer, -ENOSPC always means the filesystem is full and the only way to
gain some free space is by deleting data again.

In nilfs it appears possible that a single writer received -ENOSPC and
can simply continue writing until - magically - there is space again
because the GC daemon woke up and freed some more.  That is unexpected,
to say the least.

Which is also one of the reasons why I don't like the userspace daemon
approach very much.  Decent behaviour now requires that you block the
writes, wake up the userspace daemon and wait for it to do its job.  Or
you would have to implement a backup-daemon in kernelspace which gets
called into whenever -ENOSPC would be returned otherwise.

> But, usually the GC will make enough disk space in the background
> before that occurs.

Usually, yes.  You just have to make sure that in the unusual cases the
filesystem continues to behave correctly. ;)

Jörn

-- 
Homo Sapiens is a goal, not a description.
-- unknown
