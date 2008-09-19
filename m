Return-Path: <linux-kernel-owner+w=401wt.eu-S1754071AbYISOss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbYISOss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 10:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbYISOsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 10:48:41 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:34575 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbYISOsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 10:48:40 -0400
Date: Fri, 19 Sep 2008 16:47:57 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Anti Sullin <anti.sullin@artecdesign.ee>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AT91 Serial: update the powersave handler to match
 serial core
Message-ID: <20080919164757.2ee78a09@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080919161625.360e514d@hskinnemo-gx745.norway.atmel.com>
References: <48CE42C8.1090608@artecdesign.ee>
	<20080919150938.08b2c7be@hskinnemo-gx745.norway.atmel.com>
	<48D3AE78.207@artecdesign.ee>
	<20080919161625.360e514d@hskinnemo-gx745.norway.atmel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 19 Sep 2008 14:47:47.0359 (UTC) FILETIME=[AE8332F0:01C91A66]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> > > Are both of these checks necessary? It doesn't look like
> > > atmel_console_putchar() can be called from anywhere else than
> > > atmel_console_write().  
> > Actually, not so much. I added them for protection so that we wouldn't run into
> > a deadlock loop if something changes again. Those while() loops make me cautious.
> > And I didn't have the time to look up if the suspend code is thread-safe without this.  
> 
> I don't think it's much safer with that extra check if suspend can be
> called in parallel with this. In that case, the only way to make
> _absolutely_ sure would be to move the test inside the while loops.
> 
> And I only think this actually matters if console suspend is disabled,
> which should probably never happen on a production system. So I'm
> wondering if we really need any of those checks.

After looking at the serial core code, I don't think they are needed.
The serial core shuts down the port completely before changing the pm
state, and it also calls console_stop() which ensures that
atmel_console_write() will never get called.

And I think this is by far the best way to deal with this. As long as
the console is disabled at a higher level, we don't need those
potentially racy checks in the low-level code. So I think I'm going to
remove them before submitting this patch upstream.

If no_console_suspend is set, none of this will happen, and the clock
will keep running until it eventually gets cut off when entering slow
clock mode. This could have potential issues, but I'm not sure if it's
worth dealing with them since no_console_suspend is purely a debugging
aid.

I also suspect that disabling interrupts is unnecessary since the
serial core calls ->shutdown() which will also disable interrupts. But
it's probably safest to keep that part since the pm state may get
changed by other things than suspend.

Haavard
