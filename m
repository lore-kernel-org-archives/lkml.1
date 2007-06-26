Return-Path: <linux-kernel-owner+w=401wt.eu-S1758903AbXFZRNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903AbXFZRNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 13:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757072AbXFZRNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 13:13:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:4490 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796AbXFZRNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 13:13:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=bWWiwhOGUNIkZk7A2wbOiR0mu3pSlkQVI7hi8Bs1GgjhCuumqe8dPo5zWBegEQ0Rk7ihwny/gH+6PbRBxHECqASa9A58Ji5Mkr1akzFolRog1zOej94DLbaM63H1y7cE/AP/R+RsAO/liztUUjsw/HVIVQllXBVf27U/Rk0TlYk=
Message-ID: <2c0942db0706261013pd1010b5iebfa912e7c9f8c9c@mail.gmail.com>
Date: Tue, 26 Jun 2007 10:13:31 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Andrea Arcangeli" <andrea@suse.de>
Subject: Re: [patch, v2.6.22-rc6] sys_time() speedup
Cc: "Ingo Molnar" <mingo@elte.hu>, "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Roman Zippel" <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "John Stultz" <johnstul@us.ibm.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070626164907.GF7059@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070625200601.GA18980@elte.hu>
	 <200706252309.47467.zippel@linux-m68k.org>
	 <9a8748490706251417v10b3f24bwdf7ebd44093eaddf@mail.gmail.com>
	 <Pine.LNX.4.64.0706252356400.1817@scrub.home>
	 <9a8748490706251520g24ff7a9dk716d73e7dbfd9ec3@mail.gmail.com>
	 <20070626161857.GA7178@elte.hu> <20070626164907.GF7059@v2.random>
X-Google-Sender-Auth: 1dcf881aa5d7bbde
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/07, Andrea Arcangeli <andrea@suse.de> wrote:
> On Tue, Jun 26, 2007 at 06:18:57PM +0200, Ingo Molnar wrote:
> > My patch improves MySQL wall-clock performance by ~10% on a dual-core
> > box [see the numbers i cited in my initial mail, they were ran on a T60
> > with a 1.83 GHz Core2Duo] and by 7% on an 8-way box:
>
> mysql isn't froznen in stone like some commercial db, you can look into its
> source, the testsuite isn't either I guess. Did you ask yourself at
> least once why it's calling time() so many times per second? The
> timestamp sql type should always trigger gettimeofday calls AFIK.
>
> If there's a good reason to call time so frequently in an important
> app like mysql, then your patch sure is a good idea, but at first
> glance it looks fishy that time is so performance critical.

It's not an unreasonable expectation (from userspace's point of view)
that the simpler sys_time() system call would run faster than
gettimeofday. I suspect that this may be the case on other platforms.

However, your entire argument seems to be "It helps userspace run
faster? Weird. It shouldn't. They must be doing something wrong,
therefore the patch is stupid."

If that is your argument, then it's bogus. The bottom line is that
code, deployed today, significantly and impressively benefits from the
patch. And it's not a microbenchmark, that ignores the effect on the
rest of the system. Ingo said that both MySQL and X are improved by
this, so between the two of them that covers most every desktop system
and many servers.

> I'm not objecting the patch itself, if there's a legitimate reason to
> call time so frequently that's sure a fine optimization despite the
> branch in gettimeofday, but I'm asking why time is called so many
> times on this specific workload, because I'm fairly certain that in
> average (desktop and server) gettimeofday is called much more
> frequently

You're absolutely correct, gettimeofday *is* called much more
frequently. But not enough to outweigh the gains from sys_time
improvements.

> and if it was up to me to tell, I would expect time
> microoptimizations to result in irrelevant performance
> differences. Infact I seem to recall that even other commercial dbs
> calls tends to call floods of gettimeofday while I can't recall any
> time in the strace output. So unless there is a legitimate reason to
> call time() dozen thousand times per second,

(Why does this argument always rear its head on topics in timekeeping?)

Userspace does, whether you or I think it is legitimate or not, and
that's the reality we need to deal with. Further, I'd argue that it
*does* make sense, as sys_time() should be as cheap or cheaper than
gettimeofday(), and bottom line, userspace code needs to know the time
for lots of reasonable reasons.

> if it was my choice, I
> would prefer to have gettimeofday as fast as it can be. Not that a
> branch will make any measurable difference, but still that would be my
> choice.

Then you'd be penny-wise and pound-foolish, as the saying goes. Said
un-idiomatically, you're optimizing from a microbenchmark point of
view, which is not guaranteed to always be a win.

Ray
