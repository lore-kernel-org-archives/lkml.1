Return-Path: <linux-kernel-owner+w=401wt.eu-S1765400AbYCTAdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765400AbYCTAdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937093AbYCTAHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 20:07:39 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:17166 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940453AbYCTAHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 20:07:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=skWxa6Gl0N+WEkZW1wYU98/ry4VArFFogQO8PqNtMvPtNq8l/yxc6kfDcV299XuRENWbfTCbYHtKsOH7cCIKsubJiZXBjpvrzLqCHh4G9Qch799otreNzakx52c4zS0O93mstShqu75HtvZJxn6eib0zwJUnWOhscS/OqjN0XFk=
Message-ID: <170fa0d20803191707y1591d389y898b34ba7b30e7be@mail.gmail.com>
Date: Wed, 19 Mar 2008 20:07:32 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Daniel Phillips" <phillips@phunq.net>
Subject: Re: [ANNOUNCE] ddtree: A git kernel tree for storage servers
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200803191633.20922.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803190102.25491.phillips@phunq.net>
	 <170fa0d20803191323o65bd9738j80511de2c9f6a03c@mail.gmail.com>
	 <200803191633.20922.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 7:33 PM, Daniel Phillips <phillips@phunq.net> wrote:
> On Wednesday 19 March 2008 13:23, Mike Snitzer wrote:
>
> > >   * Block layer deadlock fixes (Status: production)
>  >
>  > Do you happen to have a pointer to where these block layer deadlock
>  > fixes are?  Or will you be committing them shortly?
>
>  Hi Mike,
>
>  OK, this is committed now, but caveat: improved, untested except for
>  booting.  But what could possibly go wrong? :-/
>
>  http://phunq.net/ddtree?p=ddtree/.git;a=blob;f=patches/bio-throttle
>
>  The production version is sitting in the code.google.com svn repository
>  in ddsnap/patches/2.6.23.8.  That one has a known bug that has somehow
>  escaped being stomped with a new commit, since it only manifests if you
>  stack one stacking block device on top of another one.  I will post here
>  when we have an official, torture tested version of the patch.

You mean like LVM2 LV ontop of MD?  Or stacking purely DM-based
stacked devices (Maybe LVM2 LV ontop of mpath? or dm-crypt on LVM2?).

>  The patch above is improved from the most recently posted version by
>  using using the ->bi_max_vecs field for throttle accounting instead of
>  calling out to a per-driver metric.  This works nicely because the
>  max_vecs field cannot change during the life of the bio, and it gives
>  a decent upper bound on the resource consumption of the bio, better
>  than simply counting bios in flight.  The queue->metric() method is
>  still in there as a stub, some more cleanup to do there (and further
>  shrinking of the patch).  It does no harm.
>
>  This improvement shrinks the throttled version of struct bio by 4
>  bytes.

Cool, so I looked briefly at the ddsnap DM target some time ago and
saw that it needed to take special care to leverage this particular
throttle (I think this was the per-driver metric?).  My memory is
fuzzy on that but what I'm wondering is how "general" is this new
patch?  Do additional steps need to be taken to be able to _really_
guarantee devices won't deadlock?

I typically use dm-linear devices built on MD (raid1 w/ one member
being remote via nbd).  The per-bdi dirty writeback accounting has
proven useful but I've recently hit a nasty livelock when the bdi
accounting for a device no longer enables writeback progress to be
made, e.g:

BdiWriteback:            0 kB
BdiReclaimable:     321408 kB
BdiDirtyThresh:     316364 kB
DirtyThresh:        381284 kB
BackgroundThresh:   190640 kB

With an all too familiar trace like the following:
..
 [<ffffffff8044cda6>] io_schedule_timeout+0x4b/0x79
 [<ffffffff80271371>] congestion_wait+0x66/0x80
 [<ffffffff802457bd>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8026c64d>] balance_dirty_pages_ratelimited_nr+0x21d/0x2b1
 [<ffffffff80268191>] generic_file_buffered_write+0x5f3/0x711

I'm _hoping_ your simple/elegant patch can enable me to drop my 2.6.22
per-bdi backport and all will be right with the world.

What do you think?

Mike
