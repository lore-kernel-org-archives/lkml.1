Return-Path: <linux-kernel-owner+w=401wt.eu-S1161815AbXDXQM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161815AbXDXQM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 12:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161816AbXDXQM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 12:12:57 -0400
Received: from tapsys.com ([72.36.178.242]:39864 "EHLO tapsys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161815AbXDXQM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 12:12:56 -0400
X-Greylist: delayed 1340 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Apr 2007 12:12:56 EDT
Message-ID: <462E273C.7050607@madrabbit.org>
Date: Tue, 24 Apr 2007 08:50:20 -0700
From: Ray Lee <ray@madrabbit.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
Cc: ray-gmail@madrabbit.org, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Renice X for cpu schedulers
References: <20070417062621.GL2986@holomorphy.com> <20070418221432.e4dbcf4f.akpm@linux-foundation.org> <20070419063810.GA22418@elte.hu> <200704192159.35546.kernel@kolivas.org> <2c0942db0704191226t21d3dae1lb0fa99bcd9714cf2@mail.gmail.com> <20070420040933.GA2392@wotan.suse.de>
In-Reply-To: <20070420040933.GA2392@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Thu, Apr 19, 2007 at 12:26:03PM -0700, Ray Lee wrote:
>> On 4/19/07, Con Kolivas <kernel@kolivas.org> wrote:
>>> The one fly in the ointment for
>>> linux remains X. I am still, to this moment, completely and utterly stunned
>>> at why everyone is trying to find increasingly complex unique ways to 
>>> manage
>>> X when all it needs is more cpu[1].
>> [...and hence should be reniced]
>>
>> The problem is that X is not unique. There's postgresql, memcached,
>> mysql, db2, a little embedded app I wrote... all of these perform work
>> on behalf of another process. It's just most *noticeable* with X, as
>> pretty much everyone is running that.
> 
> But for most of those apps, we don't actually care if they do fairly
> degrade in performance as other loads on the system ramp up.

(Who's this 'we' kemosabe? I do. Desktop systems are increasingly using
databases for their day-to-day tasks. As they should, a db is not
something that should be reinvented poorly.)

> However
> the user prefers X to be given priority in these situations. Whether
> that is the design of X, x clients, or the human condition really
> doesn't matter two hoots to the scheduler.

Hmm, let's try this again. Anything that communicates out of process
as part of its normal usage for Getting Work Done gets impacted by the
scheduler. That means pipelines in the shell, d-bus on the desktop, and
lots of other things that follow the unix philosophy of lots of little
programs communicating.

>> If we had some way for the scheduler to decide to donate part of a
>> client process's time slice to the server it just spoke to (with an
>> exponential dampening factor -- take 50% from the client, give 25% to
>> the server, toss the rest on the floor), that -- from my naive point
>> of view -- would be a step toward fixing the underlying issue. Or I
>> might be spouting crap, who knows.
> 
> Firstly, lots of clients in your list are remote. X usually isn't.

They really aren't, unless you happen to work somewhere that can afford
to dedicate a box to a db, which suddenly makes the scheduler a dull
topic.

For example, I have a db and web server installed on my laptop, so
that the few times that I have to do web app programming (while wearing
a mustache and glasses so that I don't have to admit to it in polite
company), I can be functional with just one computer.

> However for X, a syscall or something to donate time might not be
> such a bad idea...

We have one already, it's called write(). We have another called
read(), too. Okay, so they have some data related side-effects other
than the scheduler hints, but I claim the scheduler hint is already
implicitly there.

> but given a couple of X clients and a server
> against a parallel make, this is probably just going to make the
> clients slow down as well without giving enough priority to the
> server.

Do you have data, or at least a theory to back up that hypothesis?

> X isn't special so much because it does work on behalf of others
> (as you said, lots of things do that). It is special simply because
> we _want_ rendering to have priority of the CPU

Really not. I'm trying to get across that this is a general problem
with interprocess communication, or any systems that rely on multiple
processes to make forward progress on a problem. Sure, let the clients
make forward progress until they can't any more. If they stop making
forward progress by blocking on a read or sleeping after a write to
another process, then there's a big hint there as to who should get
focus next.

> (if you shifed CPU
> intensive rendering to the clients, you'd most likely want to give
> them priority to); nice, right?

They'd have it automatically, if they were spending their time computing
rather than rendering.

Ray
