Return-Path: <linux-kernel-owner+w=401wt.eu-S932096AbXBQSkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbXBQSkh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 13:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932704AbXBQSkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 13:40:37 -0500
Received: from lazybastard.de ([212.112.238.170]:40894 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096AbXBQSkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 13:40:36 -0500
Date: Sat, 17 Feb 2007 18:36:46 +0000
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Juan Piernas Canovas <piernas@ditec.um.es>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, sfaibish <sfaibish@emc.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
Message-ID: <20070217183646.GE301@lazybastard.org>
References: <op.tnkdlbgsrwwil4@brcsmondepl2c.corp.emc.com> <op.tnrbrocsunckof@usensfaibisl2e.eng.emc.com> <Pine.LNX.4.61.0702142251460.19368@yvahk01.tjqt.qr> <Pine.LNX.4.61.0702151910370.19998@ditec.inf.um.es> <20070215200922.GB24643@lazybastard.org> <Pine.LNX.4.61.0702152353060.19998@ditec.inf.um.es> <20070216091321.GA28092@lazybastard.org> <45D642A4.5010009@tmr.com> <20070217151108.GA301@lazybastard.org> <45D7450F.6090309@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45D7450F.6090309@tmr.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 February 2007 13:10:23 -0500, Bill Davidsen wrote:
> >  
> I missed that. Which corner case did you find triggers this in DualFS?

This is not specific to DualFS, it applies to any log-structured
filesystem.

Garbage collection always needs at least one spare segment to collect
valid data into.  Regular writes may require additional free segments,
so GC has to kick in and free those when space is getting tight.  (1)

GC frees segments by writing all valid data in it into the spare
segment.  If there is remaining space in the spare segment, GC can move
more data from further segment.  Nice and simple.

The requirement is that GC *always* frees more segments than it uses up
doing so.  If that requirement is not fulfilled, GC will simply use up
its last spare segment without freeing a new one.  We have a deadlock.

Now imagine your filesystem is 90% full and all data is spread perfectly
across all segments.  The best segment you could pick for GC is 90%
full.  One would imagine that GC would only need to copy those 90% into
a spare segment and have freed 100%, making overall progress.

But more log-structured filesystems maintain a tree of some sorts on the
medium.  If you move data elsewhere, you also need to update the
indirect block pointing to it.  So that has to get written as well.  If
you have doubly or triply indirect blocks, those need to get written.
So you can end up writing 180% or more to free 100%.  Deadlock.

And if you read the documentation of the original Sprite LFS or any
other of the newer log-structured filesystems, you usually won't see a
solution to this problem, or even an acknowledgement that the problem
exists in the first place.  But there is no shortage of log-structured
filesystem projects that were abandoned years ago and have "cleaner" or
"garbage collector" as their top item on the todo-list.  Coincidence?


(1) GC may also kick in earlier, but that is just an optimization and
doesn't change the worst case, so that bit is irrelevant here.


Btw, the deadlock problem is solvable and I definitely don't want to
discourage further work in this area.  DualFS does look interesting.
But my solution for this problem will likely eat up all the performance
DualFS has gained and more, as it isn't aimed at hard disks.  So someone
has to come up with a different idea.

Jörn

-- 
To recognize individual spam features you have to try to get into the
mind of the spammer, and frankly I want to spend as little time inside
the minds of spammers as possible.
-- Paul Graham
