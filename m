Return-Path: <linux-kernel-owner+w=401wt.eu-S1763959AbXGQLRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763959AbXGQLRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 07:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbXGQLRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 07:17:10 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43006 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755211AbXGQLRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 07:17:08 -0400
X-Sasl-enc: FWc3m+IJu6bJHUDREdrvqHPW8tcLn5hD4roMiM3rubk1 1184671026
Subject: Re: [patch] CFS scheduler, -v19
From: Ian Kent <raven@themaw.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Chuck Ebbert <cebbert@redhat.com>, Bill Davidsen <davidsen@tmr.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20070717074537.GA13539@elte.hu>
References: <20070706173319.GA2356@elte.hu>
	 <1184054902.12336.19.camel@Homer.simpson.net> <469512C1.6090406@tmr.com>
	 <20070711205556.GA27266@elte.hu> <4697EC49.4070303@tmr.com>
	 <469BE462.9030004@redhat.com> <20070716215541.GA27171@elte.hu>
	 <1184648474.3188.33.camel@raven.themaw.net>
	 <20070717074537.GA13539@elte.hu>
Content-Type: text/plain
Date: Tue, 17 Jul 2007 19:17:00 +0800
Message-Id: <1184671021.3188.51.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-17 at 09:45 +0200, Ingo Molnar wrote:
> * Ian Kent <raven@themaw.net> wrote:
> 
> > Yes it does and I have two reported bugs so far.
> > 
> > In several places I have code similar to:
> > 
> > wait.tv_sec = time(NULL) + 1;
> > wait.tv_nsec = 0;
> > 
> > signaled = 0;
> > while (!signaled) {
> >         status = pthread_cond_timedwait(&cond, &mutex, &wait);
> >        if (status) {
> >              if (status == ETIMEDOUT)
> >                   break;
> >              fatal(status);
> >       }
> > }
> 
> ah! It passes in a low-res time source into a high-res time interface 
> (pthread_cond_timedwait()). Could you change the time(NULL) + 1 to 
> time(NULL) + 2, or change it to:
> 
> 	gettimeofday(&wait, NULL);
> 	wait.tv_sec++;

OK, I'm with you, hi-res timer.
But even so, how is the time in the past after adding a second.

Is it because I'm not setting tv_nsec when it's close to a second
boundary, and hence your recommendation above?

> 
> does this solve the spinning?

I don't have a system to test this on so I'll try to get one of the
people that logged the problem to test a patch.

> 
> i'm wondering how widespread this is. If automount is the only app doing 
> this then _maybe_ we could get away with it by changing automount?

I'm happy to change automount but that could cause odd version specific
problems for people updating their kernel on an older installed base.

Aaah .. and they'll all blame me!! ;)

Ian


