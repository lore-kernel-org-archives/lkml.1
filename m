Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbZA1GwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbZA1GwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 01:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbZA1GwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 01:52:06 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36966 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751714AbZA1GwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 01:52:05 -0500
Message-Id: <1233125523.19204.1297144311@webmail.messagingengine.com>
X-Sasl-Enc: Pjrf2NQlvNAnryxGK5/YDkjZogUdApBdI52DFHxZMBE6 1233125523
From: "Bron Gondwana" <brong@fastmail.fm>
To: "Davide Libenzi" <davidel@xmailserver.org>, "Greg KH" <gregkh@suse.de>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       stable@kernel.org, "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
In-Reply-To: <alpine.DEB.1.10.0901272135400.20262@alien.or.mcafeemobile.com>
References: <1232704065.25510.1296328851@webmail.messagingengine.com>
 <20090123170631.GB11566@suse.de> <20090124130334.GA8031@brong.net>
 <20090125110126.GA11598@brong.net> <20090125122039.GA16603@brong.net>
 <20090128003519.GA11395@suse.de><20090128033824.GA1662@brong.net>
 <alpine.DEB.1.10.0901271942270.20262@alien.or.mcafeemobile.com>
 <20090128035746.GA3351@brong.net>
 <alpine.DEB.1.10.0901272002180.20262@alien.or.mcafeemobile.com>
 <20090128052630.GA9512@suse.de>
 <alpine.DEB.1.10.0901272135400.20262@alien.or.mcafeemobile.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
Date: Wed, 28 Jan 2009 17:52:03 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 Jan 2009 22:38 -0800, "Davide Libenzi" <davidel@xmailserver.org> wrote:
> So today we have three groups of users:
>
> - Users that have been hit by the limit
>   * Those have probably bumped the value up to the wazzoo.

Yeah, pretty much.  But we've bumped things up to the wazzoo before
only to discover that our usage crept up there (file-max of 300,000
being a case on one machine recently.  Appears you can hit that
pretty easily when you change from smaller machines to 32Gb memory

That's why the first time we hit file-max, we added a check into
our monitoring system so we get warned before we hit it.  Any
fixed limit, I'd want one of these.  Makes me sleep much better
(literally, the bloody things SMS me if checks start failing)

> - Unaware users with machines having potential of hitting the current
> limit
>   * Those, monitor or not, being unaware, they won't notice it until
>   hits. 
>     And since rising it costs zero, they'd likely prefer to bump it to
>     the 
>     stars instead of monitoring an incrementing by small steps.

True.  After they spend a day and a half figuring out what's causing
them out-of-files errors.  They swear a lot and do the wazzoo thing.

>   * Applying a lomem-dependent max_instances default value like the two 
>     lines patch I posted, is probably the best choice even for stable.

Would probably still make me sad, since these are 32 bit machines.  Given
that 150 or so seems to be the steady state on the mxes, I wouldn't want
to know what it gets up to under a spam run.  Probably close to 1000, since
that's what we limit smtpds at.

[brong@mx1 ~]$ ps ax | grep smtpd | wc -l
122
[brong@mx1 ~]$ cat /proc/sys/fs/epoll/limits 
0	159	107	1451	4096	266555

Yeah, near enough.  159 is the interesting value here (old version of limits
file, the fields are in a different order)

> - Unaware users with low-load machines
>   * Those won't even notice it.

No, until their usage pattern changes and they become one of the middle bunch.

> The default value can be rised, bound to lomem sizes. I see no problems
> in 
> there. Or, like Willy said, make (for -stable) the default unlimited, and 
> let sysadmins to put the bounds if they feel the DoS can apply to them.

I'd be happy with a default of unlimited (my patch 2 plus a couple of zero
defaults would do it)

Bron ( and to think I was going to suggest a patch that would check the value
       you wrote to max_user_* to ensure it wasn't less than the current
       highest user so you didn't accidentally munt your box ;) )
-- 
  Bron Gondwana
  brong@fastmail.fm

