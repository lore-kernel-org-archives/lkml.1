Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbZBTL0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbZBTL0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 06:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbZBTL0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 06:26:38 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:18152 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbZBTL0h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 06:26:37 -0500
MIME-Version: 1.0
In-Reply-To: <200902201149.37921.rjw@sisk.pl>
References: <200902192215.18365.rjw@sisk.pl>
	 <Pine.LNX.4.44L0.0902191659020.7953-100000@iolanthe.rowland.org>
	 <d6200be20902191839w1f74a962h30e859c8b2434f59@mail.gmail.com>
	 <200902201149.37921.rjw@sisk.pl>
Date: Fri, 20 Feb 2009 03:26:36 -0800
Message-ID: <d6200be20902200326g6caa211ai388d4aa9fc270a28@mail.gmail.com>
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

On Fri, Feb 20, 2009 at 2:49 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday 20 February 2009, Arve Hjønnevåg wrote:
>> On Thu, Feb 19, 2009 at 2:08 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> >> > It might have to be platform-specific.  The Android people seem to have a
>> >> > pretty good idea of what criteria will work for them.
>> >>
>> >> I'd really like to know in what situations Androind is supposed to suspend
>> >> automatically.
>> >
>> > It might be better to ask in what situations Android is _not_ supposed
>> > to sleep automatically.  In other words, in what situations is a
>> > wakelock acquired?  Since the whole system is only a phone, this
>> > question should have a reasonably well-defined answer.
>>
>> On an android phone, any code that needs to run when the screen is off
>> must hold a wakelock (directly or indirectly). In general if an
>> application or the system is processing an event that may cause a user
>> notification (new email, incoming phone call, alarm, etc.) it needs to
>> prevent suspend. But, we also use wakelocks to upload stats or
>> download system updates in the background, and for media player or
>> (gps) data logging applications.
>
> All of this doesn't seem to require wakelocks acuired from kernel space.
> What do you need those wakelocks for?

Most events do not originate in user-space. Alarms start in our alarm
driver which locks a wakelock when its timer interrupt occurs. This
wakelock stays locked until the user-space alarm manager calls the
driver to wait for the next alarm. I've described how input events are
handled before. Without kernel wakelocks, if the user space power
manager had already turned off the screen and decided to suspend right
before a wakeup key is pressed, then that key could sit in the
in-kernel input queue until another key is pressed. Even if the
user-space thread read the key event before being frozen, it cannot
abort the suspend operation that was already started.

-- 
Arve Hjønnevåg
