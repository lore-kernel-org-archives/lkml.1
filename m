Return-Path: <linux-kernel-owner+w=401wt.eu-S933124AbXGYPzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124AbXGYPzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 11:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761661AbXGYPzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 11:55:09 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:27553 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760122AbXGYPzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 11:55:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=HiY/rswMU24LLNUdZYJhD1sNcNoR157suHEAOLTgggrY8AHOHbuBE7k4mpHBu7OCDWPzKQRoEfVCYxHrquNNbF74u6Gsn4WMsPvuvm2c9nl62XQ3JB2qMn545Vwx+3J7QKhpvHbh900oHCCNyJk3QxA+egeDUc+0glilkdW3H9A=
Message-ID: <2c0942db0707250855v414cd72di1e859da423fa6a3a@mail.gmail.com>
Date: Wed, 25 Jul 2007 08:55:03 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "david@lang.hm" <david@lang.hm>, "Al Boldi" <a1426z@gawab.com>
Subject: Re: -mm merge plans for 2.6.23
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "ck list" <ck@vds.kolivas.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Paul Jackson" <pj@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0707242130470.2229@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <200707102015.44004.kernel@kolivas.org>
	 <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>
	 <46A57068.3070701@yahoo.com.au>
	 <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>
	 <46A58B49.3050508@yahoo.com.au>
	 <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>
	 <Pine.LNX.4.64.0707242130470.2229@asgard.lang.hm>
X-Google-Sender-Auth: 36c8297e03b4930d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hoo boy, lots of messages this morning.

(Al? I've added you to the CC: because of your swap-in vs swap-out
speed report from January. See below -- half-way down or so -- for
more detals.)

On 7/24/07, david@lang.hm <david@lang.hm> wrote:
> On Tue, 24 Jul 2007, Ray Lee wrote:
>
> > On 7/23/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> >>  Ray Lee wrote:
> >
> >>  Looking at your past email, you have a 1GB desktop system and your
> >>  overnight updatedb run is causing stuff to get swapped out such that
> >>  swap prefetch makes it significantly better. This is really
> >>  intriguing to me, and I would hope we can start by making this
> >>  particular workload "not suck" without swap prefetch (and hopefully
> >>  make it even better than it currently is with swap prefetch because
> >>  we'll try not to evict useful file backed pages as well).
> >
> > updatedb is an annoying case, because one would hope that there would
> > be a better way to deal with that highly specific workload. It's also
> > pretty stat dominant, which puts it roughly in the same category as a
> > git diff. (They differ in that updatedb does a lot of open()s and
> > getdents on directories, git merely does a ton of lstat()s instead.)
> >
> > Anyway, my point is that I worry that tuning for an unusual and
> > infrequent workload (which updatedb certainly is), is the wrong way to
> > go.
>
> updatedb pushing out program data may be able to be improved on with drop
> behind or similar.

Hmm, I thought drop-behind wasn't going to be able to target metadata?

> however another scenerio that causes a similar problem is when a user is
> busy useing one of the big memory hogs and then switches to another (think
> switching between openoffice and firefox)

Yes, and that was the core of my original report months ago. I'm
working for a while on one task, go to openoffice to view a report, or
gimp to tweak the colors on a photo before uploading it, and then go
back to my email and... and... and... there we go. The faults that
occur when I context switch is what's most annoying.

> >>  After that we can look at other problems that swap prefetch helps
> >>  with, or think of some ways to measure your "whole day" scenario.
> >>
> >>  So when/if you have time, I can cook up a list of things to monitor
> >>  and possibly a patch to add some instrumentation over this updatedb
> >>  run.
> >
> > That would be appreciated. Don't spend huge amounts of time on it,
> > okay? Point me the right direction, and we'll see how far I can run
> > with it.
>
> you could make a synthetic test by writing a memory hog that allocates 3/4
> of your ram then pauses waiting for input and then randomly accesses the
> memory for a while (say randomly accessing 2x # of pages allocated) and
> then pausing again before repeating

Con wrote a benchmark much like that. It showed measurable improvement
with swap prefetch.

> by the way, I've also seen comments on the Postgres performance mailing
> list about how slow linux is compared to other OS's in pulling data back
> in that's been pushed out to swap (not a factor on dedicated database
> machines, but a big factor on multi-purpose machines)

Yeah, akpm and... one of the usual suspects, had mentioned something
such as 2.6 is half the speed of 2.4 for swapin. (Let's see if I can
find a reference for that, it's been a year or more...) Okay,
misremembered. Swap in is half the speed of swap out (
http://lkml.org/lkml/2007/1/22/173 ). Al Boldi (added to the CC:, poor
sod), is the one who knows how to measure that, I'm guessing.

Al? How are you coming up with those figures? I'm interested in
reproducing it. It could be due to something stupid, such as the VM
faulting things out in reverse order or something...

> >>  Anyway, I realise swap prefetching has some situations where it will
> >>  fundamentally outperform even the page replacement oracle. This is
> >>  why I haven't asked for it to be dropped: it isn't a bad idea at all.
> >
> > <nod>
> >
> >>  However, if we can improve basic page reclaim where it is obviously
> >>  lacking, that is always preferable. eg: being a highly speculative
> >>  operation, swap prefetch is not great for power efficiency -- but we
> >>  still want laptop users to have a good experience as well, right?
> >
> > Absolutely. Disk I/O is the enemy, and the best I/O is one you never
> > had to do in the first place.
>
> almost always true, however there is some amount of I/O that is free with
> todays drives (remember, they read the entire track into ram and then
> give you the sectors on the track that you asked for). and if you have a
> raid array this is even more true.

Yeah, I knew I'd get called on that one :-). It's the seeks that'll
really kill you, and as you say once you're on the track the rest is
practically free (which is why the VM should prefer to evict larger
chunks at a time rather than lots of small things, see
http://lkml.org/lkml/2007/7/23/214 for something that's heading the
right direction, though the side-effects are unfortunate.

> if you read one sector in from a raid5 array you have done all the same
> I/O that you would have to do to read in the entire stripe, but I don't
> believe that the current system will keep it all around if it exceeds the
> readahead limit.

Fengguang Wu is doing lots of active work on making the readahead suck
less. Ping him and he'll likely take an active interest in the RAID
stuff.

Ray
