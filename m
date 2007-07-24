Return-Path: <linux-kernel-owner+w=401wt.eu-S1758944AbXGXPWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbXGXPWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 11:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbXGXPWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 11:22:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:54086 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbXGXPWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 11:22:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=QT7vUp9ReVoLBuvkEyMei0+No0KNAzbNtf2P14uPqmbHzBYXwCu15Fm6RcwCGMb8PHzYBE7103eozgx2Vs3nbm+2jZPcCS4BTOPUZjWic67l5YCC4N+rQX4STEuSEs/h0MpB1fAHnCKDZ2G08tUB5bliMtDMKb0PRTDDllqzcIs=
Message-ID: <2c0942db0707240822g35d13bb3r5acd2f361275fd06@mail.gmail.com>
Date: Tue, 24 Jul 2007 08:22:39 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Michael Kerrisk" <mtk-manpages@gmx.net>
Subject: Re: Problems with timerfd()
Cc: drepper@redhat.com, davidel@xmailserver.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <20070724074032.298410@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46A44B7D.3030700@gmx.net>
	 <2c0942db0707230955l20f7aeeenfc481d89e5a80d4b@mail.gmail.com>
	 <20070724074032.298410@gmx.net>
X-Google-Sender-Auth: 12d71c8cb8e08a22
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/07, Michael Kerrisk <mtk-manpages@gmx.net> wrote:
> > On 7/22/07, Michael Kerrisk <mtk-manpages@gmx.net> wrote:
> > > The value returned by read(2)ing from a timerfd file descriptor is
> > > the
> > > number of timer overruns.  In 2.6.22, this value is 4 bytes, limiting
> > > the overrun count  to 2^32.  Consider an application where the timer
> > > frequency
> > > was 100 kHz (feasible in the not-too-distant future, I would guess),
> > > then
> > > the overrun counter would cycle after ~40000 seconds (~11 hours).
> > > Furthermore returning 4 bytes from the read() is inconsistent with
> > > eventfd
> > > file descriptors, which return 8 byte integers from a read().
> >
> > I'm feeling slow, and think I'm missing something. Why is this an
> > issue? Wouldn't userspace just keep track of the last overrun count,
> > and subtract the two to get the overruns-since-last-read?
>
> The value returned by read() is the number of overruns since
> the last read().

Okay, and this is an application local count, yes? (Not system-wide.)

> > That makes
> > it oblivious to rollovers, unless it can't manage to do a read once
> > every 11 hours.
>
> That's the point that the change is meant to address.

Once every 11 hours isn't a terrible price to pay. Once every 11
seconds would be another matter. It doesn't seem unreasonable to
expect an application that is already actively dealing with timers to
go and take a look at things every hour to see if there have been more
overruns.

> > (This is the same sort of thing we already have to deal with in
> > certain situations, such as network stat counters on 32 bit
> > platforms.)
>
> But userspace can't deal with the condition accurately,

Okay, perhaps this is where I'm missing something? If userspace wakes
up once every hour, checks the overrun counter against the previous
(new-old), and goes back to sleep, that'd be good enough, right?

> so why
> require userspace to worry about this when we could just use
> a 64-bit value instead?

<shrug> I don't have strong feelings either way. It just seemed like
something that could already be taken care of with today's interface.
Given that the discussion was about an API change between 2.6.22 and
2.6.23, I was looking for options to avoid that.
