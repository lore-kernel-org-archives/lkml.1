Return-Path: <linux-kernel-owner+w=401wt.eu-S1753712AbYCOUwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbYCOUwK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 16:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbYCOUv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 16:51:59 -0400
Received: from phunq.net ([64.81.85.152]:47004 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752625AbYCOUv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 16:51:58 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Sat, 15 Mar 2008 12:51:39 -0800
User-Agent: KMail/1.9.5
Cc: david@lang.hm, David Newall <davidn@davidnewall.com>,
       Chris Friesen <cfriesen@nortel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803130216.03230.phillips@phunq.net> <20080315201815.GB4193@ucw.cz>
In-Reply-To: <20080315201815.GB4193@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803151351.40467.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Saturday 15 March 2008 13:18, Pavel Machek wrote:
> Hmm, what happens if applications keep dirtying so much data you miss
> your 17minute deadline?

Ramback is supposed to prevent that by allowing only a limited amount
of application IO during flush mode.  Currently this is accomplished
by making each application write wait synchronously on the one before
it, until flushing completes.  This allows only a small amount of
application traffic, something like 5% bandwidth.  This solution is
admittedly crude, and over time it will be improved to look more like
a realtime scheduler, because this is in fact a realtime scheduling
problem.

Once flushing completes, application writes are still serialized and
thus slow, which is a stronger condition than necessary to maintain
transactional integrity for the filesystem.  Eventually this will be
optimized.

For now, the maximum flush is only a few hundred MB on my workstation,
which leaves a huge safety margin even with my $100 UPS.  And the risk,
however small, of having to run a lossy e2fsck because the battery got
old and the power did run out, is mitigated by the fact that ramback
runs on my kernel hacking partition, and everything unique there just
gets uploaded to the internet regularly anyway.  This serves as my
replication algorithm.  Note: I strongly recommend that any critical
data entrusted to ramback be replicated to mitigate the risk of system
failure, however small.

> Anyway...
>  ext2
>  + lots of memory
>  + tweaked settings of kflushd (only write data older than 10 years)
>  + just not using sync/fsync except during shutdown
>  + find / | xargs cat 
>  
> ...is ramback, right? Should have same performance, and you can still
> read/write during that 17+17 minutes.

No, you are missing some essential pieces.  Ramback has two operating
modes:

  1) writeback (when ups-backed line power is available)
  2) writethrough (when running on ups power)

Plus, it has the daemon driven flushing for ups mode, and daemon driven
one-pass populating for startup mode.  That is all ramback is, but you
do not quite get there with your solution above.

Also, ramback works with generic block devices, opening up a wide range
of applications that your proposal does not.

> Ok, find | xargs might be slower... but we probably want to fix that
> anyway....

We sure do.  Readahead sucks enormously in Linux.

> It has big advantage: if you only tell kflushd to hold up writes for
> an hour, you loose a little in performance and gain a lot in
> reliability...
> 
> (If ext2+tweaks is slower than ramback, we have a bug to fix, I'm
> afraid).

I hope that my work inspires other people like you to go in and work
on some of the VM/VFS/BIO brokenness that helps make ramback such a
big win.  In the meantime, it is useful to be clear on just what we
have here, and why some people care about it a lot.

Daniel
