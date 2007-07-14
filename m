Return-Path: <linux-kernel-owner+w=401wt.eu-S1765056AbXGNUkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765056AbXGNUkg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 16:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762325AbXGNUk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 16:40:29 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:37048
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762205AbXGNUk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 16:40:28 -0400
Date: Sat, 14 Jul 2007 13:34:23 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
In-Reply-To: <200707142200.17515.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0707141257290.14672@asgard.lang.hm>
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
 <200707131341.35801.rjw@sisk.pl> <Pine.LNX.4.64.0707140017560.25614@asgard.lang.hm>
 <200707142200.17515.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

in the past, Rafael J. Wysocki wrote:

> BTW, please read this message and tell me what you think:
>
> http://lkml.org/lkml/2007/7/13/265
>
> Greetings,
> Rafael
>
>
>

since I've deleted this message here's the relavent portion of it

>Okay, I have thought it through and I think that, as an initial step, we
>can do something like this:
>
>- preload the image-saving kernel before hibernation
>- in the hibernation code path replace device_suspend() with the shutting 
>down of all devices without unregistering them (not very nice, but should be 
>sufficient for a while)
>- when we've called device_power_down() and save_processor_state(), jump 
>to the image-saving kernel and let it run
>- make the image-saving kernel set up everything, save the image without
>  starting any user space (we may use the existing image-saving code for 
>this purpose, with some modifications) and power off the system (or make it 
>enter S4)
>- use the existing restoration code to load the image and jump to the
>  hibernated kernel
>- in the restore code patch replace device_resume() with the reprobing of 
>all devices.
>
>Comments?

I think this is far more complicated then it needs to be.

it sounds like it should be possible to do the following

1. figure out what pages should be backed up (creating a data structure to 
hold them)

2. kexec into the hibernate kernel (this step handles all device 
transitions today)

3. have the hibernate userspace find the data structures created in step 
#1

4. have the hibernate userspace write the pages somewhere in the suspend 
format.

5. have the hibernate kernel power down the box.

the only things here that sounds like they're not available in stock 
kernels are steps #1 and #3.

now this won't do the fancier suspend-to-ram-and-disk and it won't let you 
go back from the hibernate kernel to the main kernel, but it should be 
enough to let you do the suspend safely and reliably.

for the restore, as I understand it the process is

1. boot a kernel, any working kernel.

2. read the suspend formatted data from wherever it was saved and feed it 
to /dev/suspend

David Lang
