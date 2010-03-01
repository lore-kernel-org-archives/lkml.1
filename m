Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132Ab0CAKAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 05:00:03 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45032 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831Ab0CAJ77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 04:59:59 -0500
X-Sasl-enc: 5qDdngjtTjig8RfoF/AuEnKHF5vBKJdacBRyeRbH3Vdg 1267437598
Message-ID: <4B8B901E.4050302@ladisch.de>
Date: Mon, 01 Mar 2010 10:59:58 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Magnus Lynch <maglyx@gmail.com>
CC: venkatesh.pallipadi@intel.com, vojtech@suse.cz, bob.picco@hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hpet: factor timer allocate from open
References: <be233a491002282130m3c637cfbw6648a77548241a64@mail.gmail.com>
In-Reply-To: <be233a491002282130m3c637cfbw6648a77548241a64@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Magnus Lynch wrote:
> The current implementation of the /dev/hpet driver couples opening the
> device with allocating one of the (scarce) timers (aka comparators).
> This is a limitation in that the main counter may be valuable to
> applications seeking a high-resolution timer who have no use for the
> interrupt generating functionality of the comparators.
> 
> This patch alters the open semantics so that when the device is
> opened, no timer is allocated. Operations that depend on a timer being
> in context implicitly attempt allocating a timer, to maintain backward
> compatibility.

Many thanks; I had planned to do something like this, but never found
the time.

> I also have changes for adding IOCTLs to get the main counter
> value--which is more straightforward than mmaping and reading the
> registers directly, and possibly necessary if mmap is ifdef'd
> away--but have separated that logically into another patch.

This driver was written before the high-resolution timer API was
available, so the only actual use case, besides backwards compatibility,
is the ability to read the timer register directly without a syscall.

A ioctl to read the main counter would just duplicate clock_gettime(),
but I cannot see any benefit over that.

> diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c

Your mailer killed tabs and wrapped lines.

> @@ -438,6 +469,17 @@ hpet_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
>  {
>        struct hpet_dev *devp;
> 
> +       switch (cmd) {
> +       case HPET_INFO:
> +               break;
> +       default:
> +               {
> +                       int r = hpet_alloc_timer(file);

Applications might want to use HPET_INFO to find out which timer they
got, so I think the driver cannot avoid allocating a timer in this case.


Regards,
Clemens
