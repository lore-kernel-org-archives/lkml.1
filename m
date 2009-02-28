Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbZB1XiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbZB1XiW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 18:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276AbZB1XiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 18:38:05 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:1056 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbZB1XiC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 18:38:02 -0500
MIME-Version: 1.0
In-Reply-To: <200902282353.39763.rjw@sisk.pl>
References: <200902192215.18365.rjw@sisk.pl> <200902281118.14595.rjw@sisk.pl>
	 <d6200be20902281357r2d3a0075q77055c1781f174d7@mail.gmail.com>
	 <200902282353.39763.rjw@sisk.pl>
Date: Sat, 28 Feb 2009 15:38:00 -0800
Message-ID: <d6200be20902281538g1dd6aec4q1b42b610d3ea15d1@mail.gmail.com>
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

On Sat, Feb 28, 2009 at 2:53 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday 28 February 2009, Arve Hjønnevåg wrote:
>> Can you summarize what the problems with my current api are? I get the
>> impression that you think the overhead of using a list is too high,
>> and that timeout support should be removed because you think all
>> drivers that use it are broken.
>
> In no particular order:
> 1. One user space process can create an unlimited number of wakelocks.  This
>   shouldn't be possible.  Moreover, it is not even necessary for any process
>   to have more than one wakelock held at any time.

This has been addressed. A user space process cannot create more
wakelocks than it has filedescriptors.

> 2. Timeouts are wrong, because they don't really _solve_ any problem.  They are
>   useful for working around the fact that you can't or you don't want to
>   modify every piece of code that in principle should take a wakelock and
>   that's it.

Yes, timeouts are sometimes wrong, but they are not always wrong. I
gave two examples where the use of timeouts was not incorrect.

>  However,  entire concept of having one code path acting on
>   behalf of another one on a hunch that it might be doing something making
>   suspend undesirable is conceptually broken IMO.

OK. Do you have an alternative?

I my opinion this is how the entire system works if you do autosuspend
without a mechanism like wakelocks.

> 3. The overhead of using a list is unnecessary and _therefore_ too high (not
>   just too high).

It is only unnecessary if you do not want accounting or timeouts. The
overhead of a timer going off when it is not needed (if you push
timeouts to the drivers) is way higher then the overhead putting
wakelocks on a list.

> 4. There seems to be a race between user space wakelocks and the freezer
>   (perhaps I overlooked something, in which case please disregard this item).

You are missing something. Wakelocks overlap.

> 5. The name "wakelocks" is confusing, because they aren't locks and they
>   affect suspend, not wake.

I can change the name. Currently suspend_blocker seems to be
acceptable many people, but some don't like this name either.

> 6. Last time I saw the patches they were barely commented and the changelogs
>   didn't describe the code well (if at all).

I have not added many inline comments, but I did add the kerneldoc
comments you requested, and a lot of documentation since the first
patches.

> 7. There's no clear distinction between debug/stats code and the basic
>   functionality.

I don't think this is still true.

-- 
Arve Hjønnevåg
