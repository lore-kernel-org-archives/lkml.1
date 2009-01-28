Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbZA1Kpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbZA1Kpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 05:45:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbZA1Kpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 05:45:33 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50349 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777AbZA1Kpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 05:45:32 -0500
Date: Wed, 28 Jan 2009 21:45:29 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Bron Gondwana <brong@fastmail.fm>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
Message-ID: <20090128104529.GA29864@brong.net>
References: <20090124130334.GA8031@brong.net> <20090125110126.GA11598@brong.net> <20090125122039.GA16603@brong.net> <alpine.DEB.1.10.0901271942270.20262@alien.or.mcafeemobile.com> <20090128035746.GA3351@brong.net> <alpine.DEB.1.10.0901272002180.20262@alien.or.mcafeemobile.com> <20090128052630.GA9512@suse.de> <alpine.DEB.1.10.0901272135400.20262@alien.or.mcafeemobile.com> <1233125523.19204.1297144311@webmail.messagingengine.com> <alpine.DEB.1.10.0901272323240.20262@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901272323240.20262@alien.or.mcafeemobile.com>
Organization: brong.net
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 11:34:14PM -0800, Davide Libenzi wrote:
> On Wed, 28 Jan 2009, Bron Gondwana wrote:
> 
> > On Tue, 27 Jan 2009 22:38 -0800, "Davide Libenzi" <davidel@xmailserver.org> wrote:
> > > So today we have three groups of users:
> > >
> > > - Users that have been hit by the limit
> > >   * Those have probably bumped the value up to the wazzoo.
> > 
> > Yeah, pretty much.  But we've bumped things up to the wazzoo before
> > only to discover that our usage crept up there (file-max of 300,000
> > being a case on one machine recently.  Appears you can hit that
> > pretty easily when you change from smaller machines to 32Gb memory
> > 
> > That's why the first time we hit file-max, we added a check into
> > our monitoring system so we get warned before we hit it.  Any
> > fixed limit, I'd want one of these.  Makes me sleep much better
> > (literally, the bloody things SMS me if checks start failing)
> 
> Why are you wasting your time in tail-chasing a value? If your load is so 
> unpredictable that you can't find a proper upper bound (and it almost 
> never is), make it unlimited (or redicoulously high enough).

I've been here nearly 5 years.  Over that time our rediculously high
enough values have been too small a couple of times, once when we moved
to two external drive units per imap server, and the second time when we
had a stack of 1Tb drives attached to a machine with 32Gb of RAM, and it
managed to handle so much more than previous machines.

Which is why we set it crazy higher than our previous limits, but we
also monitor.  We want it sane enough that it catches totally
out-of-bound behaviour, but monitorable so when our hardware gets
progressively upgraded the previously ludicrous value isn't suddenly
just a little too low.

(the case recently was because a drive in another unit had failed, so I
pre-emptively shifted about 10 more masters to that machine in one
managed failover.  Replicas use significantly fewer file descriptors
since all access is single threaded)

> Warned, by which assumption? That the value rises just as much to hit the 
> warn, but not to pass the current limit? How about *fail*, if the burst is 
> high enough to hit your inexplicably constrained value?
> All this in oder to keep as-close-as-the-peak a value that costs no 
> resources in pre-allocation terms.

It tends to grow slowly enough that with well spaced warn values we can
get email warnings well in advance to double check things, then we get
paged with a supposed 20 minute maximum response time.

I haven't ever seen a crazy fast peak, but I'm assuming that would most
likely be cause by actual misbehaving software rather than a slow change
in usage patterns.

> > True.  After they spend a day and a half figuring out what's causing
> > them out-of-files errors.  They swear a lot and do the wazzoo thing.
> 
> And, since they didn't know about the new limit, an even less known 
> "monitor" would have help in ...?

Yeah, sure.  I added that more for the same reason we monitor file-nr.
If I have a tunable knob that I have to tune, then I want to be able to
check my actual usage so I can tell how well it's tuned.  Otherwise it's
a "stab-in-the-dark" knob.

Bron ( but based on this discussion, I'm going to go make the file-max
       values crazy-higher while keeping the same warnings - no real
       downside, and I see your point.  I kind of inherited this setup,
       and have stuck with it out of inertia as much as anythin )
