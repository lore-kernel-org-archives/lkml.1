Return-Path: <linux-kernel-owner+w=401wt.eu-S1759069AbXGIDYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759069AbXGIDYX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 23:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758558AbXGIDYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 23:24:15 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:37445 "EHLO
	asav10.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758555AbXGIDYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 23:24:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkZAG1HkUZKhRO4R2dsb2JhbACBTIVdiAQBARsNBhEB
From: Dmitry Torokhov <dtor@insightbb.com>
To: Shem Multinymous <multinymous@gmail.com>
Subject: Re: [Hdaps-devel] [PATCH] hdaps - switch to using input-polldev
Date: Sun, 8 Jul 2007 23:24:08 -0400
User-Agent: KMail/1.9.3
Cc: hdaps-devel@lists.sourceforge.net, rlove@rlove.org,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Michael Riepe <michael@mr511.de>,
       Henrique de Moraes Holschuh <hmh@debian.org>
References: <200705252354.43730.dtor@insightbb.com> <41840b750707081800g1465eeeet12365fed84241c29@mail.gmail.com>
In-Reply-To: <41840b750707081800g1465eeeet12365fed84241c29@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707082324.11315.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 July 2007 21:00, Shem Multinymous wrote:
> On 5/25/07, Dmitry Torokhov <dtor@insightbb.com> wrote:
> > HWMON: hdaps - convert to use input-polldev.
> >
> > Switch to using input-polldev skeleton instead of implementing
> > polling loop by itself. This also fixes problem with trylock
> > on a mutex in atomic context.
> >
> > Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> 
> There's a couple of inherent problems with this patch (now in -mm).
> 
> First, the hdaps driver regularly polls the embedded controller, which
> in turns regularly polls the hardware. If the two polling rates differ
> or fluctuate, we lose events.

That was the case with the original driver as well bit instead of
rearming workqueue it was using rearming timer.

> AFAICT, the delayed workqueues used by 
> input-polldev can get very laggy under load. That's very bad for
> sensitive clients like hdapsd (the hard disk shock protection daemon).
>

input-polldev uses a separate workqueue, not keventd, and so should not
suffer from other workqueue users loading keventd. But if entire box
is under stress then workqueue vs timer context does not matter much -
your daemon which is in userspace may not get to run in a timely manner
anyway.

However I am open to bumping up priority of ipolldevd a little.
 
> Second, this is incompatible with the much-needed addition of a 2nd
> input device relying on the same data. The existing hdaps input device
> does "joystick emulation", i.e., reports values after calibration and
> fuzzing. Userspace programs that need the raw data, like hdapsd,
> currently have to poll the sysfs attribute, which is inefficient,
> lag-prone and induces unnecessary interrupts on tickless sytems. To
> solve this we'll have to add a 2nd input device to hdaps, for
> reporting the raw accelerometer data. (Michael Riepe and me are now
> working on such a patch.) But these two input devices need to share
> their polling of the underlying EC hardware, and this is impossible
> using input-polldev.

I am curious why you can't use the current device, since the calibration
done in hdaps does not alter the scale but merely moves '0' point around.
And fuzz should only remove small jitters, not rapidly changing data
that you shoudl get when your box is falling.
 
However nothing stops you from generating events for the 2nd input
device from the same polling function that generates events for the
first device.

> 
> Since this patch will  degrade accuracy and will eventually be
> reverted anyway, I suggest retracting it.

I have not seen anything in your mail that would warrant reverting
the patch.

> 
> As for the mutex in atomic context issue, isn't it best addressed by
> making mutex_trylock() do the sensible thing in softirqt?
> 
>   Shem
> 

-- 
Dmitry
