Return-Path: <linux-kernel-owner+w=401wt.eu-S1765399AbXGRGrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765399AbXGRGrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 02:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbXGRGrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 02:47:36 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59556 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752351AbXGRGrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 02:47:35 -0400
X-Sasl-enc: xebAMcZaOhlcQjFiD4S2zchIIiBgQ2yQGgBDFEaJolF8 1184739577
Subject: Re: [patch] CFS scheduler, -v19
From: Ian Kent <raven@themaw.net>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Ingo Molnar <mingo@elte.hu>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <469D6BD8.8050703@tmr.com>
References: <20070706173319.GA2356@elte.hu>
	 <1184054902.12336.19.camel@Homer.simpson.net> <469512C1.6090406@tmr.com>
	 <20070711205556.GA27266@elte.hu> <4697EC49.4070303@tmr.com>
	 <469BE462.9030004@redhat.com> <20070716215541.GA27171@elte.hu>
	 <1184648474.3188.33.camel@raven.themaw.net>
	 <20070717074537.GA13539@elte.hu>
	 <1184671021.3188.51.camel@raven.themaw.net> <20070717171643.GB7905@elte.hu>
	 <469D6BD8.8050703@tmr.com>
Content-Type: text/plain
Date: Wed, 18 Jul 2007 14:19:32 +0800
Message-Id: <1184739572.4178.39.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-17 at 21:24 -0400, Bill Davidsen wrote:
> Ingo Molnar wrote:
> > * Ian Kent <raven@themaw.net> wrote:
> >
> >   
> >>> ah! It passes in a low-res time source into a high-res time interface 
> >>> (pthread_cond_timedwait()). Could you change the time(NULL) + 1 to 
> >>> time(NULL) + 2, or change it to:
> >>>
> >>> 	gettimeofday(&wait, NULL);
> >>> 	wait.tv_sec++;
> >>>       
> >> OK, I'm with you, hi-res timer.
> >> But even so, how is the time in the past after adding a second.
> >>
> >> Is it because I'm not setting tv_nsec when it's close to a second 
> >> boundary, and hence your recommendation above?
> >>     
> >
> > yeah, it looks a bit suspicious: you create a +1 second timeout out of a 
> > 1 second resolution timesource. I dont yet understand the failure mode 
> > though that results in that looping and in the 30% CPU time use - do you 
> > understand it perhaps? (and automount is still functional while this is 
> > happening, correct?)
> >   
> 
> Can't say, I have automount running because I get it by default, but I 
> have nothing using at on my test machine. Why is it looping so fast when 
> there are no mount points defined? If the config changes there's no 
> requirement to notice right away, is there?

There are two threads where this mistake is made.

One is used to trigger expire events for all automounted filesystems
which happen all the time since I need to run the expire to check if
anything is mounted and whether it needs to be umounted. The alarm
handler sleeps on a condition until the alarm list in not empty and then
sleeps on a condition until the next alarm in the list expires or an
alarm is added to the list, in which case it then checks the list again.
Since the autofs timeout granularity is one second this is a problem and
will be fixed. This isn't the source of the problem that's been
reported.

The second is the state queue handler which runs tasks such as expires,
map re-reads, shutdowns etc. for all automounted filesystems. While the
check interval could be longer it causes autofs to be slugish in
situations such as shutdowns where there are a largish number of mounts
present and I need to cancel such things as expires and the like. It's
possible I could improve this but, in fact, once the timespec is set
correctly as Ingo suggests it works fine and uses very little resource.

Ian

