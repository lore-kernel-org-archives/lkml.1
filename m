Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbYCYLzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbYCYLzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 07:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbYCYLyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 07:54:55 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:54152 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbYCYLyy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 07:54:54 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation callbacks (rev. 3)
Date: Tue, 25 Mar 2008 12:55:30 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <Pine.LNX.4.44L0.0803241519090.24400-100000@iolanthe.rowland.org> <200803242318.21052.rjw@sisk.pl>
In-Reply-To: <200803242318.21052.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803251255.31482.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 24 März 2008 schrieb Rafael J. Wysocki:
> -/*
> +/**
> + * struct pm_ops - device PM callbacks
> + *
>   * Several driver power state transitions are externally visible, affecting
>   * the state of pending I/O queues and (for drivers that touch hardware)
>   * interrupts, wakeups, DMA, and other hardware state.  There may also be
> @@ -122,6 +124,254 @@ typedef struct pm_message {
>   * to the rest of the driver stack (such as a driver that's ON gating off
>   * clocks which are not in active use).
>   *
> + * The externally visible transitions are handled with the help of the following
> + * callbacks included in this structure:
> + *
> + * @prepare: Prepare the device for the upcoming transition, but do NOT change
> + *     its hardware state.  Prevent new children of the device from being
> + *     registered and prevent new calls to the probe method from being made

How is a driver supposed to prevent calls to probe()? You can block in probe()
or you can fail it, but how do you prevent it from being called? User space
can trigger probe via sysfs. To be useful to driver writers, this has
to be clarified.

> + *     after @prepare() returns.  If @prepare() detects a situation it cannot
> + *     handle (e.g. registration of a child already in progress), it may return
> + *     -EAGAIN, so that the PM core can execute it once again (e.g. after the
> + *     new child has been registered) to recover from the race condition. This
> + *     method is executed for all kinds of suspend transitions and is followed
> + *     by one of the suspend callbacks: @suspend(), @freeze(), or @poweroff().

This could be understood so that disconnect() cannot be called.

> + *     The PM core executes @prepare() for all devices before starting to
> + *     execute suspend callbacks for any of them, so drivers may assume all of
> + *     the other devices to be present and functional while @prepare() is being
> + *     executed.  However, they may NOT assume anything about the availability
> + *     of the user space at that time.

Probably it should be mentioned that this is the time to allocate memory
if you have to. And it is too late to request firmware.

	Regards
		Oliver
