Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbYJUWWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbYJUWWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 18:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbYJUWWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 18:22:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751127AbYJUWWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 18:22:03 -0400
Date: Tue, 21 Oct 2008 15:21:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Piel <eric.piel@tremplin-utc.net>
Cc: linux-kernel@vger.kernel.org, pavel@suse.cz, burman.yan@gmail.com,
       pau@eslack.org
Subject: Re: [PATCH] LIS3LV02Dx Accelerometer driver (take 4)
Message-Id: <20081021152142.9a535e0e.akpm@linux-foundation.org>
In-Reply-To: <48FE5416.9070402@tremplin-utc.net>
References: <48FA3368.1040605@tremplin-utc.net>
	<20081021114121.5144841c.akpm@linux-foundation.org>
	<48FE5416.9070402@tremplin-utc.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 00:13:42 +0200
Eric Piel <eric.piel@tremplin-utc.net> wrote:

> Andrew Morton schreef:
> >> +static void lis3lv02d_poweroff_timeout(unsigned long data)
> >> +{
> >> +	struct acpi_lis3lv02d *dev = (void *)data;
> >> +
> >> +	up(&dev->poff_sem);
> >> +	lis3lv02d_poweroff(dev->device->handle);
> >> +	down(&dev->poff_sem);
> > 
> > eek, no, we cannot down a semaphore from a timer handler!  It will lead
> > to might_sleep() warnings, scheduling-in-atomic warnings and kernel
> > deadlocks.
> Ooh... What happened is that I wrote the other functions first. They
> indirectly use acpi_evaluate_integer(), which can sleep. So I avoided
> spin_locks, and decided to use a semaphore. But now there is a semaphore
> in a timer (which is not allowed to sleep).
> 
> It seems the semaphore usage is compulsory due to acpi, so I'm planning
> to change the timer into a scheduled work on a workqueue (with
> queue_delayed_work(),  and cancel_delayed_work_sync()). This workqueue
> could be the same as the one for the joystick input. Does that look the
> right way to do it?

yep, that's generally a safe transformation.

You might also be able to use keventd, via scheule_delayed_work().
