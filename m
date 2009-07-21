Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbZGUMth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbZGUMth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 08:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbZGUMtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 08:49:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51673 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750904AbZGUMtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 08:49:35 -0400
Date: Tue, 21 Jul 2009 13:49:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, dmitry.torokhov@gmail.com,
       dtor@mail.ru, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
Message-ID: <20090721124933.GA5668@rakim.wolfsonmicro.main>
References: <20090714100634.GA4054@elf.ucw.cz>
 <5d5443650907140320w334864f4uc1ee13ed32fdb874@mail.gmail.com>
 <20090715133627.GA2538@elf.ucw.cz>
 <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com>
 <20090721105924.GK4133@elf.ucw.cz>
 <20090721113642.GC13286@sirena.org.uk>
 <5d5443650907210518i6ee4df1evdc04d9ae9453707c@mail.gmail.com>
 <5d5443650907210530x4aaa03d6gd47ef5f79a3ef8a4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d5443650907210530x4aaa03d6gd47ef5f79a3ef8a4@mail.gmail.com>
X-Cookie: Huh?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 06:00:07PM +0530, Trilok Soni wrote:

> Hopefully, this thread can give all details about threaded irq discussion.

> http://lkml.org/lkml/2009/2/27/255

Yes, I'm aware of that - I read it at the time.  It seemed to peter out
without any satisfactory solution, unfortunately.  There's two separate
issues here:

 - Ordinary devices on interrupt driven or slow buses like I2C.  These
   need something along the lines of request_threaded_irq() that's allows
   them to schedule the main IRQ handler outside hardirq context so
   that they can interact with the device.  They need to do something in
   hardirq context to disable the interrupt if it's level triggered but
   most of the time the only option they've got is to disable the IRQ
   and reenable it when the worker thread is done.  This is the issue
   here.

   My immediate thought when I noticed this was that we should probably
   fix request_threaded_irq() so that it's useful for them; I'd been
   intending to do some digging and try to understand why it is
   currently implemented as it is.

 - Multi-function devices like the twl4030 which have an interrupt
   controller on them and would like to expose that interrupt controller
   via the generic IRQ subsystem.  This was a large part of the
   discussion in the thread above is a much trickier problem.

I've added the folks from Samsung posting the MELFAS MCS-5000 driver to
the thread since they're running into the same issue.
