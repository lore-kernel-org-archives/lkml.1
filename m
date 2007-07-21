Return-Path: <linux-kernel-owner+w=401wt.eu-S1761276AbXGUSNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761276AbXGUSNo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 14:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbXGUSNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 14:13:36 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:49024 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbXGUSNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 14:13:36 -0400
To: jbms@cmu.edu
CC: nigel@nigel.suspend2.net, miklos@szeredi.hu, rjw@sisk.pl, miltonm@bga.com,
       stern@rowland.harvard.edu, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, david@lang.hm,
       linux-pm@lists.linux-foundation.org
In-reply-to: <87lkd9ohtn.fsf@jbms.ath.cx> (message from Jeremy Maitin-Shepard
	on Sat, 21 Jul 2007 12:13:56 -0400)
Subject: Re: [linux-pm] Re: Hibernation considerations
References: <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm>
	<200707202302.07116.rjw@sisk.pl>
	<E1ICDNw-0008HC-00@dorka.pomaz.szeredi.hu>
	<200707212243.35602.nigel@nigel.suspend2.net> <87lkd9ohtn.fsf@jbms.ath.cx>
Message-Id: <E1ICJRG-0000OG-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 21 Jul 2007 20:12:22 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It seems that you could still potentially get a failure to freeze if one
> FUSE process depends on another, and the one that is frozen second just
> happens to be waiting on the one that is frozen first when it is frozen.
> I admit that this situation is unlikely, and perhaps acceptable.

It isn't all that unlikely.  There's sshfs for example, that depends
on a separate ssh process for transport.

Oh, there are also userspace network transports, like tun/tap,
nfqueue, etc.  They could block any network filesystem (not just fuse)
if frozen first, making the freezer fail.

Hmm, wonder why this isn't affecting people with VPNs?  Probably
network mounts over VPN are rare, and ever rarer to have fs activity
on them during suspend.

Anyway, I think it's long overdue to stop thinking about how to "fix"
fuse, and concentrate on fixing the underlying problem instead ;)

> A larger concern is that it seems that freezing FUSE processes at all
> _will_ generate deadlocks if a non-synchronous or memory-map-supporting
> filesystem is loopback mounted from a FUSE filesystem.  In that case, if
> you attempt to sync or free memory once FUSE is frozen, you are sure to
> get a deadlock.

Well, it would deadlock, if

 a) memory reclaim was synchronous, or
 b) large part of the memory was used for dirty file data

I can't remember if (a) was ever true.  And now the dirty ratio is 10%
by default, so if we go OOM because that 10% can't be reclaimed, there
is a more serious problem.

Swap over loop over fuse would be problematic, but that won't work for
some time yet ;)

Miklos
