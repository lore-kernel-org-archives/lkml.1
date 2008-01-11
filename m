Return-Path: <linux-kernel-owner+w=401wt.eu-S1760311AbYAKOVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760311AbYAKOVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 09:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756150AbYAKOVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 09:21:07 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33058 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbYAKOVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 09:21:06 -0500
Subject: Re: [RFC][PATCH] per-task I/O throttling
From: Peter Zijlstra <peterz@infradead.org>
To: righiandr@users.sourceforge.net
Cc: Bill Davidsen <davidsen@tmr.com>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <478744D7.2070802@users.sourceforge.net>
References: <47869FFE.1050000@users.sourceforge.net>
	 <4786CB57.9060000@tmr.com>  <478744D7.2070802@users.sourceforge.net>
Content-Type: text/plain
Date: Fri, 11 Jan 2008 15:20:59 +0100
Message-Id: <1200061259.29498.64.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-11 at 11:28 +0100, Andrea Righi wrote:
> Bill Davidsen wrote:
> > Andrea Righi wrote:
> >> Allow to limit the bandwidth of I/O-intensive processes, like backup
> >> tools running in background, large files copy, checksums on huge files,
> >> etc.
> >>
> >> This kind of processes can noticeably impact the system responsiveness
> >> for some time and playing with tasks' priority is not always an
> >> acceptable solution.
> >>
> >> This patch allows to specify a maximum I/O rate in sectors per second
> >> for each single process via /proc/<PID>/io_throttle (default is zero,
> >> that specify no limit).
> >>
> > It would seem to me that this would be vastly more useful in the real 
> > world if there were a settable default, so that administrators could 
> > avoid having to find and tune individual user processes. And it would 
> > seem far less common that the admin would want to set the limit *up* for 
> > a given process, and it's likely to be one known to the admin, at least 
> > by name.
> > 
> > Of course if you want to do the effort to make it fully tunable, it 
> > could have a default by UID or GID. Usful on machines shared by students 
> > or managers.
> 
> At the moment I'm simply using it to backup my PC by this wrapper:
> 
> $ cat iothrottle
> #!/bin/sh
> [ $# -lt 2 ] && echo "usage: $0 RATE CMD" && exit 1
> rate=$1
> shift
> $* &
> trap "kill -9 $!" SIGINT SIGTERM
> [ -e /proc/$!/io_throttle ] && echo $rate >/proc/$!/io_throttle
> wait %1
> $ ./iothrottle 100 tar ...
> 
> But I totally agree with you that setting the limits per-UID/per-GID,
> instead of per-task, would be actually more useful.
> 
> Maybe a nice approach would be to define the UID/GID upper bounds via
> configfs (for example) and allow the users to tune the max I/O rate of
> their single tasks according to the defined ranges. In this way it could
> be even possible to define I/O shaping policies, i.e. give a bandwidth
> of 10MB/s to user A, 20MB/s to user B, 30MB/s to group X, etc.
> 
> Anyway, I'm wondering if it's possible (and how) to already do this with
> process containers...

I think there is an IO controller somewhere based on CFQ.

I don't like this patch, because it throttles requests/s, and that
doesn't say much. If a task would generate a very seeky load it could
still tie up the disk even with a relatively low setting.


