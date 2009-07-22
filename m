Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbZGVXaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbZGVXaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 19:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbZGVXaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 19:30:17 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:47553 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbZGVXaQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 19:30:16 -0400
MIME-Version: 1.0
In-Reply-To: <200907221515.07835.david-b@pacbell.net>
References: <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com>
	 <alpine.LFD.2.00.0907222226270.2813@localhost.localdomain>
	 <d6200be20907221457r4e2f6d29g57146586fd13776a@mail.gmail.com>
	 <200907221515.07835.david-b@pacbell.net>
Date: Wed, 22 Jul 2009 16:30:15 -0700
Message-ID: <d6200be20907221630j67677654tbec5f27824ab3a96@mail.gmail.com>
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: David Brownell <david-b@pacbell.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       Daniel Ribeiro <drwyrm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/22 David Brownell <david-b@pacbell.net>:
> On Wednesday 22 July 2009, Arve Hjønnevåg wrote:
>> It would also be useful to mask an edge triggered interrupt until the
>> thread handler has finished. The touchscreen on the G1 is connected to
>> an edge triggered interrupt, and the touchscreen may toggle the
>> interrupt line while reading its registers.
>
> To clarify:  if it does toggle, do you want that event to be
> queued up so the IRQ is re-issued -- or not?  That "oneshot"
> mechanism does some of that, though it's for level triggers.

For this driver yes the event should normally be queued up. If there
is an error detected though, there is no need to queue up interrupts
that are generated during the reinit.

Also, if you implement a keypad matrix driver using a threaded
interrupt handler, you will not want the interrupt to be re-issues
unless it occured after the last key was released since the scan
itself always generated more interrupts. This is not specific to
threaded interrupt handlers though, and could be handled by adding a
clear-interrupt function.

>
> Parts of that might be appropriate to handle in the threaded
> IRQ handler itself.  It seems a bit device-specific.

Yes, the driver could request a threaded one-shot interrupt so that it
will work when it is connected to a level triggered interrupt, and
also call disable_interrupt/enable_interrrupt in the handler to avoid
extra interrupts when it is connected to an edge triggered source.
But, it would be nicer if requesting a one-shot interrupt always
works. Also, waiting until the threaded handler runs before masking
the interrupt would not work well if the interrupt line needs software
debouncing.

-- 
Arve Hjønnevåg
