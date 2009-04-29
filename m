Return-Path: <linux-kernel-owner+w=401wt.eu-S1759132AbZD2TL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759132AbZD2TL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757587AbZD2TLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:11:18 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:49470 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757499AbZD2TLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:11:17 -0400
MIME-Version: 1.0
In-Reply-To: <437908170904291000s10fe6a92q8a595e0bbbd159a6@mail.gmail.com>
References: <ac3eb2510903290936tc80e904o2266108bd6c04cf2@mail.gmail.com> 
	<437908170904271023k3eefd4c1ma0cacdb78ad7acd7@mail.gmail.com> 
	<20090428101020.0e4c2b0c@hyperion.delvare> <20090428173929.GA5006@sysman-doug.us.dell.com> 
	<ac3eb2510904281046i6e9899acg89f7606da783f72c@mail.gmail.com> 
	<20090428215844.GA1396@sysman-doug.us.dell.com> <ac3eb2510904281842i785ee135h98502522f242f3f6@mail.gmail.com> 
	<437908170904282019h6a10ef9dg594002e22842b366@mail.gmail.com> 
	<ac3eb2510904290330r563f3717ue72029cbe24b39bb@mail.gmail.com> 
	<437908170904291000s10fe6a92q8a595e0bbbd159a6@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 29 Apr 2009 21:10:56 +0200
Message-ID: <ac3eb2510904291210y6d0a4199gc1800d0d02d0d7c6@mail.gmail.com>
Subject: Re: Class device namespaces
To: Michael Brown <mebrown@michaels-house.net>
Cc: Doug Warzecha <Douglas_Warzecha@dell.com>,
       Jean Delvare <khali@linux-fr.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Matt Domsch <Matt_Domsch@dell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 19:00, Michael Brown <mebrown@michaels-house.net> wrote:
> On Wed, Apr 29, 2009 at 5:30 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:

>> Yeah, maybe you can not use the in-kernel firmware-request filled
>> memory. But you can copy it just fine, once it is in the kernel. There
>> is no reason to fiddle around with chunks here in userspace.
>
> Pretty much describes exactly what dell_rbu does, except that the
> in-kernel packetizing code was rejected on our first submission, so we
> moved it into userspace.

That's the wrong reason to reject anything like that. I mean, you
should not use that interface at all for stuff like that, but
rejecting it for that reason seem wrong.

>> How do you make sure udev does not handle the request at the same
>> time? This interface is not public at all, on a general system. As
>> long as udev is active you can not use it at all. Udev will run at the
>> same time and write to the same files, and even cancel the request if
>> the requested file is not found. How does your software cope with
>> that?
>
> That is a very interesting question, as I've never seen udev do
> anything to interfere with our process. We dont do anything special to
> disable udev. Like I said above, we scribble some values to one file,
> wait for the request_firmware() files to appear and write stuff to
> them when they do. Udev hasnt ever tried to handle this that I have
> seen, especially since we dont have any appropriate files sitting
> around that udev would ever have access to in order to feed
> request_firmware().

Udev runs exactly at the time you create the device, and is not
unlikely faster than your polling, at least not predictable slower.
And it will cancel all requests which can not be fulfilled by udev
itself.

I strongly recommend switching to a different solution, you can not
use the firmware_class interface on any udev system, the interface is
already taken, and it's a single-user interface the way it is
implemented today. That it seems to work for you, is pure luck, I
guess. :)

Thanks,
Kay
