Return-Path: <linux-kernel-owner+w=401wt.eu-S1767558AbXCIV7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767558AbXCIV7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:59:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767555AbXCIV7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:59:00 -0500
Received: from yvrmail01.intrinsyc.com ([209.139.192.246]:3416 "EHLO
	yvrmail01.intrinsyc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766792AbXCIV67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:58:59 -0500
Subject: Re: [PATCH] Software Suspend: Fix suspend when console is in
	VT_AUTO/KD_GRAPHICS mode
From: Andrew Johnson <ajohnson@intrinsyc.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070309211330.GC6374@ucw.cz>
References: <1173394485.28589.17.camel@localhost.localdomain>
	 <20070309090805.GA5822@atrey.karlin.mff.cuni.cz>
	 <20070309153456.GA28664@srcf.ucam.org>
	 <DBC923D919FAB345973A94E6E194E849043808E0@yvrmail01.itc.intrinsyc.com>
	 <20070309211330.GC6374@ucw.cz>
Content-Type: text/plain
Date: Fri, 09 Mar 2007 13:58:10 -0800
Message-Id: <1173477490.30345.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Mar 2007 21:59:12.0615 (UTC) FILETIME=[2BFFCF70:01C76296]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-03 at 21:13 +0000, Pavel Machek wrote:
> Hi!
> 
> > > > So... if current console is graphical, we leave X accessing the
> > > > console... That's bad, because video state is not going to be
> > > > restored...?
> > > 
> > > A graphical console is not necessarily X. Is there any requirement for
> > > there to be a single VT that isn't in text mode? The vt switching is
> > > a hack, we shouldn't make life difficult for people who have their own
> > > userspace code that's entirely capable of restoring video state on its
> > > own.
> > 
> > The problem actually comes about when using Qtopia Phone Edition (QPE)
> > on a PXA270. QPE puts the console into VT_AUTO+KD_GRAPHICS mode and
> > writes directly to the framebuffer from then on.  In this mode the
> > kernel correctly disallows a console change, as QPE is not getting
> > notification of a console change and thus does not know when to repaint
> > the screen. 
> 
> Fix qpe to use vt_process, instead?

The real issue seems to be the assumption in pm_prepare_console() that
set_console() will succeed.  set_console() may fail (resulting in
vt_waitactive waiting for a console switch that can never happen or a
break) for two currently unchecked reasons:

- console is in VT_AUTO+KD_GRAPHICS mode
- vt_dont_switch is set

> ...how does qpe know when to repaint the screen, anyway?

QPE doesn't need to repaint the screen after wake-up - the framebuffer
memory is retained so the PXA270 lcd controller simply displays what was
last on the screen when it is re-enabled.

-- Andrew








