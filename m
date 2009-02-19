Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbZBSUst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbZBSUst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 15:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbZBSUsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 15:48:41 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:40317 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbZBSUsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 15:48:40 -0500
MIME-Version: 1.0
In-Reply-To: <ac3eb2510902190341y7eb4e938nf5f28ac094a68818@mail.gmail.com>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
	 <200902182227.14686.rusty@rustcorp.com.au>
	 <ac3eb2510902180557p3b65fad5i933eed9d3e3d0b3b@mail.gmail.com>
	 <200902192145.10616.rusty@rustcorp.com.au>
	 <ac3eb2510902190341y7eb4e938nf5f28ac094a68818@mail.gmail.com>
Date: Thu, 19 Feb 2009 21:48:38 +0100
Message-ID: <ac3eb2510902191248w26f1d1c0o95d68aaa3be097a1@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
From: Kay Sievers <kay.sievers@vrfy.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andreas Robinson <andr345@gmail.com>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19, 2009 at 12:41, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Thu, Feb 19, 2009 at 12:15, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> On Thursday 19 February 2009 00:27:58 Kay Sievers wrote:
>>> some modules wait for 200-500 milliseconds to
>>> get the lock released, some larger modules spend 50 milliseconds in
>>> load_module(), many of them around 20 milliseconds.
>>
>> OK, this is an untested hack (don't try unloading modules, not sure symbol
>> resolution isn't racy now I've killed the lock).  Does it change the numbers?
>
> That changes it dramatically. The numbers from the sycall until the
> linked-in module are now down to 15-25 milliseconds, and for a few
> large modules 50-100.
>
> (One crazy exception is ipv6, which takes 620 milliseconds to link, no
> idea what it needs to do.)

Sorry, this was caused by I/O wait from disk for that huge module, and
gets to reasonable numbers by putting all modules into RAM before
loading them.

> I'll compare a few bootup times with and without the patch, and come
> back later today with the real numbers.

The whole massive parallel modprobe happens during udev coldplug. I
tried a 2GHz Dual Core laptop, and a setup without initramfs here,
which loads ~40 modules. All the kernel modules are copied to a ramfs
mount before the coldplug is started.

I measured the time from the first modprobe that happened in the
kernel to the loading of "dummy", which I manually trigger from the
udev boot script, and which gets called right after udev has settled
and handled all events.

With the mutex it takes 1.8 seconds, without it, it takes 1.3 seconds.
If I comment out the creation of the stop_machine() threads, it gets
down to 1.1 seconds.

With the mutex, I see code waiting for up to 180 milliseconds waiting
for the mutex, the average between 20-40 milliseconds.

Without the mutex the largest time to link is 30 milliseconds, and
most of them are around 5-10 milliseconds.

Without the mutex and the stop_machine() creation, the flow of tracing
output looks like real work and, depending on the actual module, they
spend time in various stages of linking, relocation and so on, there
are no long delays for any of the modules, like I see with the current
code.

It would be great, if we can safely minimize the time spent in the mutex.

Thanks,
Kay
