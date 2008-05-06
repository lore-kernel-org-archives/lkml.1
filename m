Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbYEFKcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbYEFKcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 06:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbYEFKcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 06:32:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32869 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbYEFKcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 06:32:20 -0400
Date: Tue, 6 May 2008 07:31:34 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: Robin Holt <holt@sgi.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc1
Message-ID: <20080506073134.424780a3@gaivota>
In-Reply-To: <200805060902.25835.alistair@devzero.co.uk>
References: <alpine.LFD.1.10.0805031205330.2971@woody.linux-foundation.org>
	<20080504160904.GF19717@sgi.com>
	<Pine.LNX.4.64.0805051656180.3218@bombadil.infradead.org>
	<200805060902.25835.alistair@devzero.co.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 09:02:25 +0100
Alistair John Strachan <alistair@devzero.co.uk> wrote:

> On Monday 05 May 2008 22:04:17 Mauro Carvalho Chehab wrote:
> > Alistair,
> >
> > Sorry for not answering earlier, I got some days off (I still didn't read
> > all messages from you - I'm flooded of messages here).
> >
> > >> I have DVB_CORE=n and VIDEO_DEV=y. VIDEO_DEV is:
> > >>
> > >> config VIDEO_DEV
> > >>         tristate "Video For Linux"
> > >>
> > >> So if you enable Video For Linux, the tuner-core is automatically built,
> > >> even if no tuners are selected? Surely that's wrong..
> > >
> > > That is probably correct.  Video For Linux is used for capturing video
> > > streams.  The fact that you can get this invalid config to fail to build
> > > should be reported to the v4l folks and let them fix it up.
> >
> > Yes, this is correct, if you select a board that supports tuner (for
> > example, bttv, or cx88).
> >
> > The error is that most tuners are dependent of I2C. The right fix seems to
> > do this:
> >
> >
> > config MEDIA_TUNER
> >          tristate
> >          default (DVB_CORE || VIDEO_DEV) && I2C
> >          depends on (DVB_CORE || VIDEO_DEV) && I2C
> 
> This still seems imperfect -- if I have I2C=y and VIDEO_DEV=y, but DVB_CORE=n 
> (and no board types selected), it'll still build at least some of the tuner 
> code into the V4L core.

Yes. The complete fix seems to have a separate Kconfig item for tuner-core.

> This is still true even if I set MEDIA_TUNER_CUSTOMIZE=y and set all of the 
> tuners to 'n'. I'd assumed that this was an artefact of the complex Kconfig 
> logic here, and was not intentional.

I agree. the Kconfig logic for V4L/DVB is complex. It tries to address two
different issues:
	- an easy board selection for the end-user (just selecting CX88 should
allow his board to work);
	- an advanced selection for embedded set-top-boxes, where you can
select just what you really need.

Due to that, there are several "select" clauses, that don't consider the
"depends on". So, it is very easy to break it, unfortunately.

Also, since 2.6.24, all tuner modules are shared by analog and digital support
(there are two different, independent API's and core utilities for analog and
for digital).

We need to redesign Kconfig/Makefile's to simplify the logic and remove the
hidden dependencies.



Cheers,
Mauro
