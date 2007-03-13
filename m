Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbXCMPVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbXCMPVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 11:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbXCMPVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 11:21:52 -0400
Received: from MAIL.13thfloor.at ([213.145.232.33]:47421 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbXCMPVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 11:21:51 -0400
Date: Tue, 13 Mar 2007 16:21:50 +0100
From: Herbert Poetzl <herbert@13thfloor.at>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelianov <xemul@sw.ru>, containers@lists.osdl.org,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/7] Resource counters
Message-ID: <20070313152150.GK8755@MAIL.13thfloor.at>
Mail-Followup-To: "Eric W. Biederman" <ebiederm@xmission.com>,
	Pavel Emelianov <xemul@sw.ru>, containers@lists.osdl.org,
	Paul Menage <menage@google.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <45ED7DEC.7010403@sw.ru> <45ED7F69.60108@sw.ru> <45EE39A5.7010804@in.ibm.com> <45EE6769.9060701@sw.ru> <20070309163711.GA3647@MAIL.13thfloor.at> <m1fy8bwqps.fsf@ebiederm.dsl.xmission.com> <20070312011612.GD21861@MAIL.13thfloor.at> <m1bqixtsr1.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bqixtsr1.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 03:09:06AM -0600, Eric W. Biederman wrote:
> Herbert Poetzl <herbert@13thfloor.at> writes:
> 
> > On Sun, Mar 11, 2007 at 01:00:15PM -0600, Eric W. Biederman wrote:
> >> Herbert Poetzl <herbert@13thfloor.at> writes:
> >> 
> >> >
> >> > Linux-VServer does the accounting with atomic counters,
> >> > so that works quite fine, just do the checks at the
> >> > beginning of whatever resource allocation and the
> >> > accounting once the resource is acquired ...
> >> 
> >> Atomic operations versus locks is only a granularity thing.
> >> You still need the cache line which is the cost on SMP.
> >> 
> >> Are you using atomic_add_return or atomic_add_unless or 
> >> are you performing you actions in two separate steps 
> >> which is racy? What I have seen indicates you are using 
> >> a racy two separate operation form.
> >
> > yes, this is the current implementation which
> > is more than sufficient, but I'm aware of the
> > potential issues here, and I have an experimental
> > patch sitting here which removes this race with
> > the following change:
> >
> >  - doesn't store the accounted value but
> >    limit - accounted (i.e. the free resource)
> >  - uses atomic_add_return() 
> >  - when negative, an error is returned and
> >    the resource amount is added back
> >
> > changes to the limit have to adjust the 'current'
> > value too, but that is again simple and atomic
> >
> > best,
> > Herbert
> >
> > PS: atomic_add_unless() didn't exist back then
> > (at least I think so) but that might be an option
> > too ...
> 
> I think as far as having this discussion if you can remove that race
> people will be more willing to talk about what vserver does.

well, shouldn't be a big deal to brush that patch up
(if somebody actually _is_ interested)

> That said anything that uses locks or atomic operations (finer grained
> locks) because of the cache line ping pong is going to have scaling
> issues on large boxes.

right, but atomic ops have much less impact on most
architectures than locks :)

> So in that sense anything short of per cpu variables sucks at scale.
> That said I would much rather get a simple correct version without the
> complexity of per cpu counters, before we optimize the counters that
> much.

actually I thought about per cpu counters quite a lot, and
we (Llinux-VServer) use them for accounting, but please
tell me how you use per cpu structures for implementing 
limits

TIA,
Herbert


> Eric
