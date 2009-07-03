Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbZGCOsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbZGCOsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 10:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbZGCOsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 10:48:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58074 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593AbZGCOsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 10:48:04 -0400
Date: Fri, 3 Jul 2009 16:47:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vt: add an event interface
Message-ID: <20090703144754.GA13246@elte.hu>
References: <20090703064518.GA30674@elte.hu> <20090703100834.6cb241b6@lxorguk.ukuu.org.uk> <20090703091655.GB3902@elte.hu> <20090703104459.1d9d0bbf@lxorguk.ukuu.org.uk> <20090703095432.GC21141@elte.hu> <20090703110620.64fd1283@lxorguk.ukuu.org.uk> <20090703102234.GA32128@elte.hu> <20090703114431.37abd528@lxorguk.ukuu.org.uk> <20090703131727.GA3207@elte.hu> <20090703143746.0379b2ee@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703143746.0379b2ee@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > Its called engineering and good practice. The old code was 
> > > correct. The paste of it is therefore most likely to be 
> > > correct. Furthermore patches shouldn't mix clean up with other 
> > > changes. So doing it as one is most definitely bad practice.
> > 
> > So you cannot do such trivial cleanups safely and validate the 
> > result?
> 
> What part of not mixing clean-up with other changes didn't you 
> understand ? [...]

It's an argument you made on false premises.

The thing is, my review wasnt about old code being moved around. It 
was about new code being introduced by you:

+       if (copy_from_user(&vw.event, (void __user *)arg, sizeof(struct vt_event)))
+               return -EFAULT;
+       /* Highest supported event for now */
+       if(vw.event.event > VT_MAX_EVENT)
+               return -EINVAL;

Same pattern as in the old commit: you used differing styles just 3 
lines apart in new code and apparently didnt even notice it. So i 
dont buy your argument at all that you will do 'cleanups later' as 
your patch shows ignorance of the whole concept.

Compromising on quality only results in crap being ingrained, it 
results in procrastinating and it results in you submitting new code 
with basic problems - the very patch here i commented on.

Nor is you assertion correct that fixing basic issues in it has to 
degrade it reliability: it can be done safely. In my experience 
striving for quality in such a way improves the end result. (the 
exception is when moving around whole files or significant chunks of 
code - then we preserve the old one, then move it.)

> > I came across this patch of yours on lkml and noticed a few 
> > problems - checkpatch noticed a few more. Is the reviewing of 
> > patches and the commenting on unclean patches a 'bogus 
> > standard'? Do we have some separate standard just for you?
> 
> checkpatch is a tool, not a religion. [...]

The thing is, you didnt really answer my question whether you 
consider yourself to be accountable to the same standards of quality 
as other upstream kernel contributors?

Obviously checkpatch is not a religion - in fact in my reply i gave 
a specific example where checkpatch would complain but that 
complaint is wrong. Checkpatch is a tool, and the problem is not 
that you are not making use of that tool - the problem is that you 
are producing unclean code. If you wrote clean code there would be 
no reason for anyone to complain.

So just like the religious application of checkpatch is not 
acceptable, is the religious avoidance of checkpatch not acceptable 
either ;-)

> [...] Quite frankly the way some people behave with it is a 
> disgrace and it puts people off contributing to the kernel when 
> their 500 line driver gets nothing but emails from people saying 
> "that space is wrong". At least in your case you can actually 
> program and your opinion comes from real practise and experience - 
> which is more than a lot of the self appointed codingstyle police 
> can say.

But you are not a newbie driver submitter, are you? Do you consider 
yourself exempt from accepted rules of cleanliness, for new code you 
submit?

[...]

> > Anyway ... all i did was to comment on a somewhat deficient 
> > patch that you submitted to lkml. If you dont want review 
> > feedback and if you feel embarrased and defensive by getting it 
> > then please dont send out slightly-messy signed-off patches to 
> > lkml, it's simple as that.
> 
> The message I thought was quite clear about what I was asking for. 
> The fact you complained about spaces and missed the fact it 
> couldn't even work was "enlightening" in terms of code review.

Here, in support of advancing a false argument you materially 
distort the review i gave you, which, in part, said:

| [...]
|
|   The cast to void __user * should be done in the ioctl 
|   demultiplexer vt_ioctl(), and the ioctl ugliness should not 
|   invade cleaner child functions such as vt_event_wait_ioctl().
|
| - same for vt_event_wait_ioctl() - it passes in a type damaged by
|   ioctl's limitations. Such type limitations and ioctl demuxing 
|   artifacts should be kept local to vt_ioctl().

This goes beyond 'spaces'. Type cleanliness is the first and most 
important thing when designing new interfaces - and you just added a 
new unclean interface in form of vt_event_wait_ioctl().

	Ingo
