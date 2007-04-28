Return-Path: <linux-kernel-owner+w=401wt.eu-S1161479AbXD1HBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161479AbXD1HBx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 03:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161508AbXD1HBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 03:01:53 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161206AbXD1HBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 03:01:49 -0400
Date: Sat, 28 Apr 2007 00:01:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
Message-Id: <20070428000142.2acab38a.akpm@linux-foundation.org>
In-Reply-To: <1177741953.6268.18.camel@Homer.simpson.net>
References: <1177660767.6567.41.camel@Homer.simpson.net>
	<alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
	<1177734305.6266.7.camel@Homer.simpson.net>
	<1177741953.6268.18.camel@Homer.simpson.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007 08:32:32 +0200 Mike Galbraith <efault@gmx.de> wrote:

> On Sat, 2007-04-28 at 06:25 +0200, Mike Galbraith wrote:
> > On Fri, 2007-04-27 at 08:18 -0700, Linus Torvalds wrote:
> > 
> > > Actually, you don't need to apply the patch - just do
> > > 
> > > 	echo 5 > /proc/sys/vm/dirty_background_ratio
> > > 	echo 10 > /proc/sys/vm/dirty_ratio
> > 
> > That seems to have done the trick.  Amarok and GUI aren't exactly speed
> > demons while writeout is happening, but they are not hanging for
> > eternities.
> 
> As promised, I tested with a kernel that I know for fact that I have
> tested heavy IO on previously, and behavior was identically horrid, so
> it's not something new that snuck in ~recently, my disk just got a _lot_
> fuller in the meantime (12k mp3s munch a lot).

Just to clarify here - you're saying that some older kernel is as sucky as
2.6.21, and that (presumably) dropping the dirty ratios makes things a bit
better on the old kernel as well?

> I also verified that I don't need to use the dirty data restrictions
> with ext2, all is just peachy using stock settings.  Amarok switches
> songs quickly, and GUI doesn't hang.  Behavior is that expected of a
> heavily loaded IO subsystem, and is 1000% better than ext3 with my very
> full disk.

Yes, the very full disk could explain why things are _so_ bad.  Not only
does fsync() force vast amounts of writeout, it's also seeky writeout.

> Journaling is very nice, but I think I'll be much better off without it
> responsiveness wise.

Well, physical journalling with ordered data is bad here.  Other forms of
journalling which don't introduce this great contention point shouldn't be
as bad.


Actually, I'm surprised that data=writeback didn't help much.  If the
present theories are correct it should have helped quite a lot, because in
data=writeback mode fsync(small-file) will not cause
fdatasync(everything-else).

