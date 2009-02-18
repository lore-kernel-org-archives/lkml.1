Return-Path: <linux-kernel-owner+w=401wt.eu-S1755107AbZBRErA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbZBRErA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 23:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbZBREqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 23:46:47 -0500
Received: from rv-out-0506.google.com ([209.85.198.226]:15688 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683AbZBREqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 23:46:43 -0500
MIME-Version: 1.0
In-Reply-To: <200902180022.00239.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0902162156380.24097-100000@netrider.rowland.org>
	 <200902180022.00239.rjw@sisk.pl>
Date: Tue, 17 Feb 2009 20:46:39 -0800
Message-ID: <d6200be20902172046sf00599ckc6710c6132d6b92f@mail.gmail.com>
Subject: Re: [RFD] Automatic suspend
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
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

On Tue, Feb 17, 2009 at 3:21 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday 17 February 2009, Alan Stern wrote:
>> On Tue, 17 Feb 2009, Rafael J. Wysocki wrote:
>>
>> > Phase 1: I agree that system-auto-suspend-on, system-auto-suspend-off would be
>> > useful, but I don't like the wakelocks interface.  Do you think there is an
>> > alternative way/mechanism of doing this?
>>
>> I rather like the suggestions Matthew Garrett has been making.  They
>> show how to improve the wakelock interface without losing any function.
>>
>> Really, the idea behind wakelocks comes down to the question of how to
>> determine when the system is sufficiently idle to go into auto-suspend.
>> There may be occasions when no task is runnable but userspace knows
>> that the system should not go to sleep because some work will be done
>> in the near future.  (Arve's example of a non-empty input buffer is
>> such a case.)  How should userspace let the kernel know whether it's
>> okay to suspend at these times?  That is the problem userspace
>> wakelocks are meant to solve.
>
> Still, do we really need multiple user space wakelocks (I'd prefer to call them
> sleeplocks)?  It seems that one such lock and a user space manager controlling
> it should be sufficient.

Yes, we could have a user space manager that all userspace wakelocks
go through, but it would have to start before any other processes that
need wakelocks and it would need a blocking ipc mechanism. The
wakelock api that is provided to android applications does all this,
but it is only available to java code. Supporting multiple userspace
wakelocks in the kernel is simpler than adding another userspace
wakelock layer.

>> Kernel wakelocks are a separate matter.  They are more like a form of
>> optimization, preventing the kernel from starting an auto-suspend when
>> some driver knows beforehand that it will return -EBUSY.
>
> I think kernel-side autosuspend (or rather autosleep) should only happen
> after certain subset of devices have been suspended using a per-device
> run-time autosuspend mechanism.

When the last wakelock is released the task that we woke up to perform
has finished. Why wait to re-enter suspend.

>
>> > Phase 3: Probably explicit control left to open/close.
>>
>> While that's generally a good idea, it's important to recognize that
>> some devices should be runtime-suspended even while they are open.
>
> From the kernel side, yes (and that should be transparent to the user space
> having them open).  By the user space, no.

Allowing user space to suspend input devices while they are still open
is useful. The user-space code that reads from the input devices does
not need to know if the device is suspended or not, and the kernel
cannot auto suspend input devices based on inactivity.

-- 
Arve Hjønnevåg
