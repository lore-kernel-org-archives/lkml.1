Return-Path: <linux-kernel-owner+w=401wt.eu-S965025AbXBQFWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965025AbXBQFWE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 00:22:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946411AbXBQFWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 00:22:04 -0500
Received: from tapsys.com ([72.36.178.242]:54110 "EHLO tapsys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965025AbXBQFWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 00:22:03 -0500
X-Greylist: delayed 1586 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Feb 2007 00:22:03 EST
Message-ID: <45D68A73.90707@madrabbit.org>
Date: Fri, 16 Feb 2007 20:54:11 -0800
From: Ray Lee <ray-lk@madrabbit.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
References: <20070215163704.GA32609@2ka.mipt.ru> <Pine.LNX.4.64.0702150920130.20368@woody.linux-foundation.org> <20070215181059.GC20997@2ka.mipt.ru> <Pine.LNX.4.64.0702151019210.20368@woody.linux-foundation.org> <20070215190413.GA23953@2ka.mipt.ru> <Pine.LNX.4.64.0702151120260.20368@woody.linux-foundation.org> <20070216085706.GA22868@2ka.mipt.ru> <Pine.LNX.4.64.0702160753120.20368@woody.linux-foundation.org> <20070216160525.GA21160@2ka.mipt.ru> <2c0942db0702160853s18f650ccsa7270c047d94a41b@mail.gmail.com> <20070216165854.GA18522@2ka.mipt.ru>
In-Reply-To: <20070216165854.GA18522@2ka.mipt.ru>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> On Fri, Feb 16, 2007 at 08:53:30AM -0800, Ray Lee (madrabbit@gmail.com) wrote:
>> On 2/16/07, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
>>> if its design is good, then
>>> interface can be changed in a moment without any problem
>> This isn't always the case. Sometimes the interface puts requirements
>> (contract-like) upon the implementation. Case in point in the kernel,
>> dnotify versus inotify. dnotify is a steaming pile of worthlessness,
>> because it's userspace interface is so bad (meaning inefficient) as to
>> be nearly unusable.
>>
>> inotify has a different interface, one that supplies details about
>> events rather that mere notice that an event occurred, and therefore
>> has different requirements in implementation. dnotify probably was a
>> good design, but for a worthless interface.
>>
>> The interface isn't always important, but it's certainly something
>> that has to be understood before putting the finishing touches on the
>> behind-the-scenes implementation.
> 
> Absolutely.
> And if overall system design is good,

dnotify was a good system design for a stupid (or misunderstood) problem.

> there is no problem to change
> (well, for those who fail to read to the end and understand my english
> replace 'to change' with 'to create and commit') interface to the state
> where it will satisfy all (majority of) users.

You might be right, but the point I (and others) are trying to make is
that there are some cases where you *really* need to understand the
users of the interface first. You might have everything else right
(userspace wants to know when filesystem changes occur, great), but if
you don't know what form those notifications have to look like, you'll
end up doing a lot of wasted work on a worthless piece of code that no
one will ever use.

Sometimes the interface really is the most important thing. Just like a
contract between people.

(This is probably why, by the way, most people are staying silent on
your excellent kevent work. The kernel side is, in some ways, the easy
part. It's getting an interface that will handle all users [ users ==
producers and consumers of kevents ], that is the hard bit.)

Or, let me put it yet another way: How do you prove to the rest of us
that you, or Ingo, or whomever, are not building another dnotify? (Maybe
you're smart enough in this problem space that you know you're not --
that's actually the most likely possibility. But you still have to prove
it to the rest of us. Sucks, I know.)

> Situations when system is designed from interface down to system ends up
> with one thread per IO and huge limitations on how system is going to be
> used at all.

The other side is you start from the goal in mind and get Ingo's state
machines with loops and conditionals and marmalade in syslets which
appear a bit baroque and overkill for the majority of us userspace folk.

(No offense intended to Ingo, he's obviously quite a bit more conversant
on the needs of high speed interfaces than I am. However, I suspect I
have a bit more clarity on what us normal folk would actually use, and
kernel driven FSMs ain't it. Userspace often makes a lot of contextual
decisions that I would absolutely *hate* to write and debug as a state
machine that gets handed off to the kernel. I'll happily take a 10% hit
in efficiency that Moore's law will get me back in a few months, instead
of spending a bunch of time debugging difficult heisenbugs due to the
syslet FSM reading a userspace variable at a slightly different time
once in a blue moon. OTOH, I'm also not Oracle, so what do I know?)

The truth of this lies somewhere in the middle. It isn't kernel driven,
or userspace interface driven, but a tradeoff between the two.

So:

> Userspace_API_is_the_ever_possible_last_thing_to_ever_think_about.
> Period

Please listen to those of us who are saying that this might not be the
case. Maybe we're idiots, but then again maybe we're not, okay?
Sometimes the API really *DOES* change the underlying implementation.

Ray
