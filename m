Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbYGTHVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbYGTHVk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 03:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756016AbYGTHVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 03:21:25 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:48341 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452AbYGTHVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 03:21:24 -0400
Message-ID: <4882E7F3.8060605@keyaccess.nl>
Date: Sun, 20 Jul 2008 09:23:31 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch 1/3] fastboot: Create a "asynchronous" initlevel
References: <20080718151524.5ef9e29b@infradead.org>	<20080718151608.46dc17c0@infradead.org>	<48819D92.8050904@keyaccess.nl>	<4881A161.7050902@keyaccess.nl> <20080719084448.7859afd0@infradead.org>
In-Reply-To: <20080719084448.7859afd0@infradead.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19-07-08 17:44, Arjan van de Ven wrote:

> On Sat, 19 Jul 2008 10:10:09 +0200
> Rene Herman <rene.herman@keyaccess.nl> wrote:

>>> I'm not sure about this comment, being not very sure about the
>>> semantics of late_initcall but shouldn't late_initcall (level 7)
>>> wait for 6s to have completed?
>> 
>> Following up on this myself -- see for example kernel/power/disk.c:
>> power_suspend(). It's a late intitcall so that, as it comments,
>> "all devices are discovered and initialized". However, your first
>> followup patch makes the USB HCI init async meaning that any USB
>> storage device might not be ready yet when it runs, no?
> 
> good spotting/comment.
> 
> you would have a valid point... if it weren't for the case where much
> of this actual "end device" probing is in various cases already
> asynchronous... what you do have found is a bug in the suspend code.
> Unless code does:
>         /* wait for the known devices to complete their probing */
>         while (driver_probe_done() != 0)
>                 msleep(100);
> (taken from init/do_mounts.c)
> 
> ... the assertion in the comment that probing is done is absolutely
> false, with or without my patches.

Yes, I see. Unfortunately, WITH your patches, driver_probe_done() would 
also no longer be safe when run from a late_initcall() it would appear.

driver_probe_done() tests a variable that's incremented just before the 
driver model calls into the driver .probe method and decremented on 
return from it (really_probe).

However, if the entire module_init() is async the probing may not even 
have _started_ yet let alone finished. Let's take ehci_hcd_init() as an 
example both since you changed that one and since it'll fairly often be 
en route to mass storage devices.

Only after ehci_init() calls foo_register_driver() is the driver model 
aware of it and will it start calling the probe methods meaning the 
driver_probe_done() would be racing.

I have the sneaking suspicion that this is a bit of a fundamental issue. 
Turning some of the driver level (6) async basicaly removes the ordering 
between drivers and late_initcall (level 7).

I trust it will completely and utterly destroy the point of this patch 
to flush level 6a before starting level 7?

> (Not that I want the suspend/resume code to call this, because that
> would make the boot even longer ;( )

Well, yes, but bugs are bugs. CCing Pavel and Rafael as well :-)

Rene.
