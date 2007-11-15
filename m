Return-Path: <linux-kernel-owner+w=401wt.eu-S1760226AbXKOPQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760226AbXKOPQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 10:16:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757360AbXKOPPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 10:15:53 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:59637 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989AbXKOPPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 10:15:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ViFMf4ZWi7ephrb6nMFvUjLupf2Wu22D5M1zkWo4Lmo/XlNfRW5qvTjIQ7nXi+ZYswryrhKv3E1X/qX87Uk4SeDxn1E2SeENt0vq75IDC8ElZ6VPohIPTq8yOak1OLGGbziL0DRYDwlTYQJELR1g8o2e9H6LtfbU3mhZQqLEulk=
Message-ID: <d120d5000711150715h67209747w8bce5749d072f545@mail.gmail.com>
Date: Thu, 15 Nov 2007 10:15:50 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Tomas Carnecky" <tom@dbservice.com>
Subject: Re: statically allocated input_dev
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <473C5EA3.7020101@dbservice.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071115094309.innulage80owccko@www.neopsis.com>
	 <d120d5000711150556r18842b09o2ed5ef3db7abd3d9@mail.gmail.com>
	 <473C5595.3010403@dbservice.com>
	 <d120d5000711150630n538a78e3sd3676a19eb051327@mail.gmail.com>
	 <473C5EA3.7020101@dbservice.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 15, 2007 9:58 AM, Tomas Carnecky <tom@dbservice.com> wrote:
> CC: lkml, because that's a question anyone familiar with the driver
> subsystem can answer.
>
> Dmitry Torokhov wrote:
> > On Nov 15, 2007 9:20 AM, Tomas Carnecky <tom@dbservice.com> wrote:
> >> Dmitry Torokhov wrote:
> >>> No, sorry. Current object lifetime rules require input devices (as
> >>> well as platform devices) to be dynamically allocated.
> >>>
> >> Interesting, especially the 'platform device' bit, because, from
> >> ./drivers/block/floppy.c:
> >>
> >>    floppy_device[drive].name = floppy_device_name;
> >>    floppy_device[drive].id = drive;
> >>    floppy_device[drive].dev.release = floppy_device_release;
> >>
> >>    err = platform_device_register(&floppy_device[drive]);
> >>
> >> where 'floppy_device' is a static array defined as follows:
> >>
> >>    static struct platform_device floppy_device[N_DRIVE];
> >>
> >> So is that code incorrect?
> >>
> >
> > I would not look at floopy code when searching for examples ;)
> >
>
> Statically allocating platform devices works, I can register those just
> fine and I don't see any oops when loading/removing the module.

The oops will not happen when you remove the module but later.
Consider you have a process connected to /dev/input/eventX
corresponding to your input device. Opening evdev node pins in memory
(kref is taken) underlying input_dev which in turn pins parent
platform device. This does not increase your module's reference count
so it still can be unloaded. When you unload the module memory
occupied by tyou module is freed and may be reused for something else.

Now the process that had event device opened decides to close it. This
causes krefs dropped from parent input device and platform device
structures. Cleanup routines will run trying to scrub everything
clean, writing either into freed memory, or, even worse, into memory
now occupied by somethign else. BOOM!

> Even
> though there are no signs of breakage, should I change my code anyway?
>

Yes.

> I'm trying to keep the code as simple as possible. The platform device,
> platform driver and the input device will live only as long as the
> module is loaded. There is nothing else that would rely or depend on my
> driver. Any advices you can give? Or is there nothing that I could use
> to keep the code simple?
>

Make the structures dynamically alloocated and feel safe from any
changes in refcounting between underlying objects.

-- 
Dmitry
