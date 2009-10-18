Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbZJRPGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbZJRPGF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 11:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbZJRPGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 11:06:04 -0400
Received: from ns.penguin.cz ([84.21.108.25]:36521 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbZJRPGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 11:06:03 -0400
Subject: Re: [PATCH] serial-core: resume serial hardware with
	no_console_suspend
From: Stanislav Brabec <utx@penguin.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, gregkh@suse.de,
       alan@lxorguk.ukuu.org.uk, s.hauer@pengutronix.de, saxena@laptop.org,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <20091005162741.599a1be9.akpm@linux-foundation.org>
References: <1253021938.6597.16.camel@hammer.suse.cz>
	 <20090924170503.37cbe4ed.akpm@linux-foundation.org>
	 <20090925073617.GA5856@n2100.arm.linux.org.uk>
	 <1253872547.13257.18.camel@hammer.suse.cz>
	 <20091005162741.599a1be9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 18 Oct 2009 17:05:58 +0200
Message-Id: <1255878358.4581.29.camel@utx.utx.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote in Mon Oct 05, 2009 at 16:27 -0700:
> On Fri, 25 Sep 2009 11:55:47 +0200
> Stanislav Brabec <utx@penguin.cz> wrote:
> 
> > Russell King - ARM Linux wrote:
> > > On Thu, Sep 24, 2009 at 05:05:03PM -0700, Andrew Morton wrote:
> > > > On Tue, 15 Sep 2009 15:38:58 +0200
> > > > Stanislav Brabec <utx@penguin.cz> wrote:
> > > > 
> > > > > Hardware may need re-initialization to get serial port working after
> > > > > resume. It does not happen with no_console_suspend. Attached patch
> > > > > attempts to fix it.
> > > > > 
> > > > > The patch attempts to keep hardware running before suspend and run
> > > > > hardware re-initialization after resume. Maybe simpler approach is
> > > > > possible.
> > > > 
> > > > The patch doesn't apply any more and seems like a rather hacky thing to do.
> > 
> > Yes, but no_console_suspend itself is a bit hacky. You need to save
> > console state but keep it running as long as possible afterwards and
> > resume it after return from the sleep.
> > 
> > I was not sure, what exactly should be skipped and what must be run, so
> > I experimented a bit.
> > 
> > Not calling hardware suspend/resume (current implementation) breaks
> > serial port in hardware that need resume.
> > 
> > Calling of resume without suspend seems to be dangerous. Not calling
> > suspend at all and standard initialization on resume would probably
> > reset the port setting and maybe cause memory leak.
> > 
> > > > It appears that you have specific serial hardware which doesn't resume
> > > > correctly?  If so, that's a bug, so how about we start with a bug
> > > > report/description?
> > 
> > The hardware resumes correctly. But no_console_suspend breaks its
> > resume.
> > 
> > > It's something that I did point out when the no_console_suspend patch
> > > appeared, but I was overruled/ignored.
> > > 
> > > The problem is that on ARM hardware, there is no BIOS to re-initialize
> > > hardware.  The kernel has to do restore the entire system hardware
> > > state upon resume.  Unfortunately, no_console_suspend not only prevents
> > > the console from being suspended but _also_ resumed.
> > > 
> > > The result of that is the console UART is left in a totally uninitialized
> > > state.
> > 
> > Exactly, my ARM hardware is PXA270 on Zaurus SL-C3200.
> 
> hm, well.  We can't go much further without a patch and the one you
> sent won't apply.  Can you please redo against current mainline and
> resend?

I am just working on a rebase, but (besides other minor changes) it
conflicts with ba15ab0e8de0d4439a91342ad52d55ca9e313f3d (mentioned
below).

I would be glad, if somebody would say me, whether it is correct and
whether it fixes all affected devices. I cannot actually test any of
them on my Zaurus: There is an independent regression that makes
impossible to initiate resume.

Both patches are trying to do the same: working serial after resume with
no_console_suspend, but they do it in a different way:

﻿- Deepak Saxena's patch skips suspend process and does reset on resume.

- My patch does tricky suspend: Some parts of suspend are called, state
is saved, but device is kept in a state that it thinks it is up.

It was based on experiments, just guessing what happens there. It was
done without deep knowledge of serial code. It attempts to:
- Save the hardware state
- Perform buffer flush in time of its suspend call
- Tell the driver that port is suspended
- But still accept new data
- And keep console hardware in state that allows to send them

Both patches have a the same problem:

There are no early resume messages. In difference to BIOS equipped
machines, serial port must be properly re-initialized to become working
again.

﻿It can be fixed either by changing suspend/resume order to wake serial
console early in the order, or by a non-standard hook in the early
resume process.

Very late suspend messages may be lost as well. (It is a generic problem
of all devices, not dependent on any of these patches.) It can be
prevented by using blocking write of messages or adding an extra sleep
after each message. I would afraid of blocking write. There is no
guarantee, that serial is still functional messages can be sent.

> Do you expect that my some miracle, your patch will also fix
> http://lkml.org/lkml/2009/9/30/164 ?

My original version of patch removed the early return from the resume,
where ﻿Deepak Saxena's added chunk resides. With my patch, code always
continues in resume, and skips just a minor part of the code.


________________________________________________________________________
Stanislav Brabec
http://www.penguin.cz/~utx

