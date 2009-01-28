Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbZA1GV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbZA1GV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 01:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbZA1GVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 01:21:20 -0500
Received: from 1wt.eu ([62.212.114.60]:1859 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbZA1GVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 01:21:20 -0500
Date: Wed, 28 Jan 2009 07:20:21 +0100
From: Willy Tarreau <w@1wt.eu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Greg KH <gregkh@suse.de>, Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
Message-ID: <20090128062021.GA32360@1wt.eu>
References: <20090125110126.GA11598@brong.net> <20090125122039.GA16603@brong.net> <20090128003519.GA11395@suse.de> <20090128033824.GA1662@brong.net> <alpine.DEB.1.10.0901271942270.20262@alien.or.mcafeemobile.com> <20090128035746.GA3351@brong.net> <alpine.DEB.1.10.0901272002180.20262@alien.or.mcafeemobile.com> <20090128052630.GA9512@suse.de> <20090128053642.GL5038@1wt.eu> <alpine.DEB.1.10.0901272142530.20262@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901272142530.20262@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 09:48:07PM -0800, Davide Libenzi wrote:
> On Wed, 28 Jan 2009, Willy Tarreau wrote:
> 
> > On Tue, Jan 27, 2009 at 09:26:30PM -0800, Greg KH wrote:
> > > On Tue, Jan 27, 2009 at 08:10:41PM -0800, Davide Libenzi wrote:
> > > > In my servers, I know if they are going to be loaded, and I bump NFILES 
> > > > (and a few other things) to the correct place. Since many of those 
> > > > limits do not actually pre-allocate any resource, I don't need to wait and 
> > > > monitor the values, before taking proper action.
> > > 
> > > But what about people who want to know what the current usages are, so
> > > that they _can_ monitor things and adjust them on the fly if things are
> > > about to go boom?
> > > 
> > > I see no reason why we can't leave the value where it is today, and add
> > > the ability to both turn the limits off entirely, and also report our
> > > current usage.  That keeps the DOS from happening on "default" systems,
> > > and lets admins have an idea if they need to bump up the values on their
> > > systems as well.
> > > 
> > > I don't understand your objection to allowing the usage to be monitored.
> > 
> > Agreed. If sysadmins get trapped by the upgrade, the fix for an
> > hypotethical DoS is a 100%-certain DoS by itself. The general sense
> > that "if it's not broken, don't fix it" applies here as well. The
> > server's sysadmin should not be bothered by a security upgrade (anyway,
> > after a few minutes of havoc in prod, he will revert to previous version
> > without trying to understand any further). But the campus sysadmin having
> > trouble with local users already spends a lot of time tweaking limits.
> > Now we offer them a new limit they can tune, they'll happily use it.
> > Anyway, even at 128 they'll probably lower it down a lot. So basically
> > we're with a medium value which does not fit any usage.
> 
> You know, it's not me that decides what goes of certain trees or not ;) 
> I've been pinged about the problem, and a patch was sent with values that 
> seemed appropriate for typical epoll usages. Epoll is a multiplexing 
> interface, so the thought was that not too many instances were lingering 
> around. Probably the default max_instances should have been made lomem 
> dependent like max_user_watches in the first place, leading to higher 
> max_instances values, with respect of the potential DoS.

Davide, I know it's not you who decide. I mean, one patch was proposed
with one arbitrary limit. I've seen it in advance too and I too thought
it would be more than enough. Now people are reporting breakage from
common applications which work in a funny way (I think that using epoll
to poll for one single FD in a multi-process architecture can be called
funny). But those people are not expected to understand the internals,
and most likely their application's behaviour might not be more precisely
described than "it broke since upgrade to 2.6.27.13".

I think we should accept the fact that the fix is causing problems
for people while it was not expected to do so. One of the solutions
would be to increase the arbitrary ratio from 1% to more than that,
but it will still break big setups. Another solution is to accept
that the patch provides a tunable that admins might act on to stop
local users' nasty activities if required, but leave the limit off
by default. And I think that's a saner approach, especially for a
stable series.

Regards,
Willy

