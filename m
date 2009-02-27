Return-Path: <linux-kernel-owner+w=401wt.eu-S1761297AbZB0W4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761297AbZB0W4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 17:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758212AbZB0W4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 17:56:34 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:48772 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757527AbZB0W4d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 17:56:33 -0500
MIME-Version: 1.0
In-Reply-To: <200902272155.42010.rjw@sisk.pl>
References: <200902192215.18365.rjw@sisk.pl> <200902271522.41915.rjw@sisk.pl>
	 <20090227204053.GB1387@ucw.cz> <200902272155.42010.rjw@sisk.pl>
Date: Fri, 27 Feb 2009 14:56:30 -0800
Message-ID: <d6200be20902271456w77951afata1d5f378ddbe6b84@mail.gmail.com>
Subject: Re: [RFD] Automatic suspend
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
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

On Fri, Feb 27, 2009 at 12:55 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday 27 February 2009, Pavel Machek wrote:
>> On Fri 2009-02-27 15:22:39, Rafael J. Wysocki wrote:
>> > On Friday 27 February 2009, Pavel Machek wrote:
>> > > Hi!
>> > >
>> > > > > > Then, the decision making logic will be able to use /sys/power/sleep whenever
>> > > > > > it wishes to and the kernel will be able to refuse to suspend if it's not
>> > > > > > desirable at the moment.
>> > > > > >
>> > > > > > It seems to be flexible enough to me.
>> > > > >
>> > > > > This seems flexible enough to avoid race conditions, but it forces the
>> > > > > user space power manager to poll when the kernel refuse suspend.
>> > > >
>> > > > And if the kernel is supposed to start automatic suspend, it has to monitor
>> > > > all of the wakelocks.  IMO, it's better to allow the power manager to poll the
>> > > > kernel if it refuses to suspend.
>> > >
>> > > polling is evil -- it keeps CPU wake up => wastes power.
>> > >
>> > > Wakelocks done right are single atomic_t... and if you set it to 0,
>> > > you just unblock "sleeper" thread or something. Zero polling and very
>> > > simple...
>> >
>> > Except that you have to check all of the wakelocks periodically in a loop =>
>> > polling.  So?
>>
>> No. I want to have single atomic_t for all the wakelocks... at least
>> in non-debug version. Debug version will be slower. I believe you
>> originally suggested that.
>
> I did, but please don't call it "wakelocks".  It's confusing.

What you are talking about here is mostly an optimization of the
wakelock api. You have removed timeout support and made each wakelock
reference counted. If you ignore wakelocks with timeouts, the current
wakelock interface can be implemented with a global atomic_t to
prevent suspend, and a per wakelock atomic_t to prevent a single
client from changing the global reference count by more than one.

There are a couple of reasons that I have not done this. It removes
the ability to easily inspect the system when it is not suspending. I
do provide an option to turn off the wakelock stats, which makes
wake_lock/unlock significantly faster, but we never run with wakelock
stats off. Also, it pushes timeout handling to the drivers. I know may
of you don't like timeout support, but ignoring the problem is not a
solution. If each driver that needs timeouts uses its own timer, then
you will often wakeup from idle just to unlock a wakelock that will
not trigger suspend. This wakeup is a thousand times as costly on the
msm platform as a wakelock/unlock pair (with wakelock stats enabled).

I just checked my phone, and over a 24 hour awake time (370 hours
uptime) period, it acquired about 5 million wakelocks (mostly for
input events). If these were cache hits, and took as long as my
benchmark did, that accounts for 20 seconds of overhead (0.023% of
awake, 0.1% of not-idle (5.5h).

-- 
Arve Hjønnevåg
