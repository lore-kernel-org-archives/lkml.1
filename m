Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab0BYLAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 06:00:53 -0500
Received: from cantor.suse.de ([195.135.220.2]:55245 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473Ab0BYLAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 06:00:50 -0500
Date: Thu, 25 Feb 2010 12:00:47 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: Oliver Neukum <oliver@neukum.org>,
       =?ISO-8859-15?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
       linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Nicu Pavel <npavel@ituner.com>
Subject: Re: [PATCH 1/3] picolcd: driver for PicoLCD HID device
In-Reply-To: <ffb352764fc5a0da5cca6f3da7fc2603.squirrel@intranet.cs.nmsu.edu>
Message-ID: <alpine.LNX.2.00.1002251157500.30967@pobox.suse.cz>
References: <20100221002001.0a7e05a7@neptune.home>    <20100224170049.0d04af3c@neptune.home>    <201002241927.53532.oliver@neukum.org> <ffb352764fc5a0da5cca6f3da7fc2603.squirrel@intranet.cs.nmsu.edu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Feb 2010, Rick L. Vinyard, Jr. wrote:

> >> +static int picolcd_raw_event(struct hid_device *hdev,
> >> +               struct hid_report *report, u8 *raw_data, int size)
> >> +{
> >> +       struct picolcd_data *data = hid_get_drvdata(hdev);
> >> +       char hexdata[25];
> >> +       int i;
> >> +
> >> +       if (data == NULL)
> >> +               return 1;
> >> +
> >> +       for (i = 0; i < sizeof(hexdata) / 2; i++)
> >> +               sprintf(hexdata+2*i, "%02hhx", raw_data[i]);
> >> +       if (size >= sizeof(hexdata)/2) {
> >> +               hexdata[sizeof(hexdata)-4] = '.';
> >> +               hexdata[sizeof(hexdata)-3] = '.';
> >> +               hexdata[sizeof(hexdata)-2] = '.';
> >> +               hexdata[sizeof(hexdata)-1] = '\0';
> >> +       } else
> >> +               hexdata[size*2] = '\0';
> >> +
> >> +       switch (report->id) {
> >> +       case REPORT_KEYPAD:
> >> +               if (size == 3 && raw_data[0] == 0x11 &&
> >> data->input_keys) {
> >> +                       return picolcd_raw_keypad(hdev, report,
> >> raw_data+1, size-1);
> >> +               } else {
> >> +                       dbg_hid(PICOLCD_NAME " unsupported key event (%d
> >> bytes): 0x%s\n", size, hexdata);
> >> +                       break;
> >> +               }
> >> +               break;
> >> +       case REPORT_VERSION:
> >> +               if (size == 3)
> >> +                       dev_info(&hdev->dev, "Firmware version is
> >> %hd.%hd\n", raw_data[1], raw_data[2]);
> >> +
> >> +               spin_lock(&data->lock);
> >
> > If I recall correctly raw_event is called in interrupt. 

Yes, that is correct.

> The issue, as I understand it is that non-interrupt code may obtain the 
> lock and then the interrupt code is executed... hence the deadlock and 
> the need to use spin_lock_irqsave() and spin_unlock_irqrestore().

Exactly. All the spinlocks that are aquired in interrupt code-paths must 
be acquired with _irqsave()/_irqrestore() from the non-interrupt code to 
prevent exactly this kind of deadlock.
> 
> The key difference is the replacement of spin_lock() with spin_trylock()
> such that if the non-interrupt code has already obtained the lock, the
> interrupt will not deadlock but instead take the else path and schedule a
> framebuffer update at the next interval.

Why is _irqsave() and/or deferred work not enough? The aproach with 
_trylock() seems to be overly complicated for no good reason (I personally 
become very suspicious every time I see code that is using _trylock()).

[ by the way, Rick, are you planning to resubmit the G13 driver with 
incorporated feedback from the last review round? ]

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
