Return-Path: <linux-kernel-owner+w=401wt.eu-S1756618AbZB1DEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbZB1DEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 22:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbZB1DEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 22:04:15 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:54521 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbZB1DEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 22:04:14 -0500
MIME-Version: 1.0
In-Reply-To: <20090227234458.GB2089@elf.ucw.cz>
References: <200902192215.18365.rjw@sisk.pl> <200902271522.41915.rjw@sisk.pl>
	 <20090227204053.GB1387@ucw.cz> <200902272155.42010.rjw@sisk.pl>
	 <d6200be20902271456w77951afata1d5f378ddbe6b84@mail.gmail.com>
	 <20090227234458.GB2089@elf.ucw.cz>
Date: Fri, 27 Feb 2009 19:04:12 -0800
Message-ID: <d6200be20902271904t4500e59eld7ea3cebef75cfad@mail.gmail.com>
Subject: Re: [RFD] Automatic suspend
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 3:44 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> >> > > Wakelocks done right are single atomic_t... and if you set it to 0,
>> >> > > you just unblock "sleeper" thread or something. Zero polling and very
>> >> > > simple...
>> >> >
>> >> > Except that you have to check all of the wakelocks periodically in a loop =>
>> >> > polling.  So?
>> >>
>> >> No. I want to have single atomic_t for all the wakelocks... at least
>> >> in non-debug version. Debug version will be slower. I believe you
>> >> originally suggested that.
>> >
>> > I did, but please don't call it "wakelocks".  It's confusing.
>>
>> What you are talking about here is mostly an optimization of the
>> wakelock api. You have removed timeout support and made each wakelock
>> reference counted. If you ignore wakelocks with timeouts, the current
>> wakelock interface can be implemented with a global atomic_t to
>> prevent suspend, and a per wakelock atomic_t to prevent a single
>> client from changing the global reference count by more than one.
>
> Actually I'd go to global atomic_t to prevent suspend, and make sure
> single client only changes it once by design.

If you go with only a global atomic_t then you automatically allow
clients to change the count by more than one. Our userland api calls
this a reference counted wakelock, and reference counted wakelocks
have been a frequent source of bugs. We have code that calls wake_lock
every time an item is added to a queue and wake_unlock when it gets a
notification that item was removed. If you miss a notification the
lock is never released. With non reference counted wakelocks, can
unlock every time the queue is empty, and lock either when adding the
first item or every time you add an item (useful when combined with
timeouts).

I could extend the wakelock api to allow reference counted wakelocks,
but I have not come across any drivers where it would be beneficial
(to the driver, not the wakelock implementation), and causes conflicts
with timeouts.

>> There are a couple of reasons that I have not done this. It removes
>> the ability to easily inspect the system when it is not suspending. I
>> do provide an option to turn off the wakelock stats, which makes
>> wake_lock/unlock significantly faster, but we never run with wakelock
>> stats off.
>
> It seems wrong to design for the "debugging" case. ... even if you run
> with debugging enabled.

I'm not sure I would call wakelock stats purely a debugging feature.
Either way, designing the api to pass in an object, allows stats and
debugging features to be implemented. Designing the api to be a global
reference count without an object prevents both.

I realize that some of the proposed alternatives allow the same stats
and debugging information to be added to other kernel objects (tasks
and devices), but I prefer a separate wakelock object. We have drivers
that use more then one wakelock per device, and many wakelocks do not
have any association with a task either.

>
>> Also, it pushes timeout handling to the drivers. I know
>> may
>> of you don't like timeout support, but ignoring the problem is not a
>> solution. If each driver that needs timeouts uses its own timer, then
>> you will often wakeup from idle just to unlock a wakelock that will
>> not trigger suspend. This wakeup is a thousand times as costly on the
>> msm platform as a wakelock/unlock pair (with wakelock stats
>> enabled).
>
> Well, you are free to have a library (or something) those broken
> drivers can use. But you have to understand that those drivers are
> broken... and please don't make it part of core API.

I don't agree. Not all the timeout uses are broken. The unknown-wakeup
wakelock that is used if suspend fails preserved compatibility with
existing drivers without introducing any race conditions. I also use a
wakelock with a one second timeout if the alarm driver is suspended
less than a second before the alarm is supposed to expire. I could
probably rewrite this driver to not use a timeout, but the current
implementation is not broken.

> It should also make the merging easier; merge non-contraversial parts
> first (single atomic_t), then add debugging infrastructure, then maybe
> add timeout handling if those drivers can really not be fixed in a
> nicer way...

Why is a single atomic_t less controversial? It is just as invasive as
the wakelock interface and it provides no help in interacting with
unmodified subsystems.

I'm more interested in getting code merged that can easily be used in
a fully functional system, than code that only works for test systems,
but if the implementation details of the wakelock interface is the
only thing that prevents it from being merged, I can change it. I do
find it odd that this is what is objectionable though, as it is
already more efficient than the pm_qos interface that people want us
to use instead of idle wakelocks.

-- 
Arve Hjønnevåg
