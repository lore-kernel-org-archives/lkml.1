Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbZCBXs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbZCBXs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757371AbZCBXsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:48:47 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:59085 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463AbZCBXsq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:48:46 -0500
MIME-Version: 1.0
In-Reply-To: <200903020017.52390.rjw@sisk.pl>
References: <200902192215.18365.rjw@sisk.pl> <200902282353.39763.rjw@sisk.pl>
	 <d6200be20902281538g1dd6aec4q1b42b610d3ea15d1@mail.gmail.com>
	 <200903020017.52390.rjw@sisk.pl>
Date: Mon, 2 Mar 2009 15:48:44 -0800
Message-ID: <d6200be20903021548h11f57283t6d6a9053f3feb3fd@mail.gmail.com>
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

On Sun, Mar 1, 2009 at 3:17 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday 01 March 2009, Arve Hjønnevåg wrote:
>> On Sat, Feb 28, 2009 at 2:53 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Saturday 28 February 2009, Arve Hjønnevåg wrote:
>> >> Can you summarize what the problems with my current api are? I get the
>> >> impression that you think the overhead of using a list is too high,
>> >> and that timeout support should be removed because you think all
>> >> drivers that use it are broken.
>> >
>> > In no particular order:
>> > 1. One user space process can create an unlimited number of wakelocks.  This
>> >   shouldn't be possible.  Moreover, it is not even necessary for any process
>> >   to have more than one wakelock held at any time.
>>
>> This has been addressed. A user space process cannot create more
>> wakelocks than it has filedescriptors.
>>
>> > 2. Timeouts are wrong, because they don't really _solve_ any problem.  They are
>> >   useful for working around the fact that you can't or you don't want to
>> >   modify every piece of code that in principle should take a wakelock and
>> >   that's it.
>>
>> Yes, timeouts are sometimes wrong, but they are not always wrong. I
>> gave two examples where the use of timeouts was not incorrect.
>
> There still is a problem that the same operation can take time X on one
> platform and time Y on another, so how are you going to determine the timeouts
> that will be suitable for all platforms?

This only applies to the timeouts that fall into the wrong category.
The timeout used when a driver returns -EBUSY is arbitrary, but any
value is technically correct. The one second timeout in the alarm
driver is not platform specific. It is one second because the
resolution of the rtc api is only one second.

For the timeouts that do fall into the wrong category (use a timeout
when passing data to a unmodified subsystem), the drivers are mostly
(if not all) platform specific.

>
>> >  However,  entire concept of having one code path acting on
>> >   behalf of another one on a hunch that it might be doing something making
>> >   suspend undesirable is conceptually broken IMO.
>>
>> OK. Do you have an alternative?
>
> Well, IMO every code path doing something that makes automatic suspend
> undesirable should use a suspend blocker of some sort.  I'm afraid any other
> approach will be unreliable and racy.

I agree with this, but I cannot change every code path at once. I also
don't know if every code path can be easily fixed. Using a timeout in
this case is a compromise. It is not as good as protecting every code
path, but it is much better than doing nothing. The race condition you
have when preventing suspend with a timeout is the same as every code
using a timeout. If the system is busy it can fail. The race condition
that you have with no protection happens with any load. If the system
decides to go to sleep at the same time as a wakeup event occur, the
system will sleep.

-- 
Arve Hjønnevåg
