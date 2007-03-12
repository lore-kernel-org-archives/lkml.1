Return-Path: <linux-kernel-owner+w=401wt.eu-S1751663AbXCLBQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbXCLBQP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 21:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbXCLBQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 21:16:15 -0400
Received: from MAIL.13thfloor.at ([213.145.232.33]:38185 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbXCLBQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 21:16:14 -0400
Date: Mon, 12 Mar 2007 02:16:13 +0100
From: Herbert Poetzl <herbert@13thfloor.at>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelianov <xemul@sw.ru>, containers@lists.osdl.org,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/7] Resource counters
Message-ID: <20070312011612.GD21861@MAIL.13thfloor.at>
Mail-Followup-To: "Eric W. Biederman" <ebiederm@xmission.com>,
	Pavel Emelianov <xemul@sw.ru>, containers@lists.osdl.org,
	Paul Menage <menage@google.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <45ED7DEC.7010403@sw.ru> <45ED7F69.60108@sw.ru> <45EE39A5.7010804@in.ibm.com> <45EE6769.9060701@sw.ru> <20070309163711.GA3647@MAIL.13thfloor.at> <m1fy8bwqps.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1fy8bwqps.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2007 at 01:00:15PM -0600, Eric W. Biederman wrote:
> Herbert Poetzl <herbert@13thfloor.at> writes:
> 
> >
> > Linux-VServer does the accounting with atomic counters,
> > so that works quite fine, just do the checks at the
> > beginning of whatever resource allocation and the
> > accounting once the resource is acquired ...
> 
> Atomic operations versus locks is only a granularity thing.
> You still need the cache line which is the cost on SMP.
> 
> Are you using atomic_add_return or atomic_add_unless or 
> are you performing you actions in two separate steps 
> which is racy? What I have seen indicates you are using 
> a racy two separate operation form.

yes, this is the current implementation which
is more than sufficient, but I'm aware of the
potential issues here, and I have an experimental
patch sitting here which removes this race with
the following change:

 - doesn't store the accounted value but
   limit - accounted (i.e. the free resource)
 - uses atomic_add_return() 
 - when negative, an error is returned and
   the resource amount is added back

changes to the limit have to adjust the 'current'
value too, but that is again simple and atomic

best,
Herbert

PS: atomic_add_unless() didn't exist back then
(at least I think so) but that might be an option
too ...

> >> If we'll remove failcnt this would look like
> >>    while (atomic_cmpxchg(...))
> >> which is also not that good.
> >> 
> >> Moreover - in RSS accounting patches I perform page list
> >> manipulations under this lock, so this also saves one atomic op.
> >
> > it still hasn't been shown that this kind of RSS limit
> > doesn't add big time overhead to normal operations
> > (inside and outside of such a resource container)
> >
> > note that the 'usual' memory accounting is much more
> > lightweight and serves similar purposes ...
> 
> Perhaps....
> 
> Eric
> _______________________________________________
> Containers mailing list
> Containers@lists.osdl.org
> https://lists.osdl.org/mailman/listinfo/containers
