Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbXD3BhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbXD3BhH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 21:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbXD3BhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 21:37:06 -0400
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:41107 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbXD3BhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 21:37:04 -0400
Date: Sun, 29 Apr 2007 18:37:00 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Uwe Bugla <uwe.bugla@gmx.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mchehab@infradead.org, mkruky@linuxtv.org,
       linux-dvb@linuxtv.org
Subject: Re: Critical points about kernel 2.6.21 and pseudo-authorities
In-Reply-To: <alpine.LFD.0.98.0704291147530.9964@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0704291753370.315@shell2.speakeasy.net>
References: <20070429182209.267430@gmx.net>
 <alpine.LFD.0.98.0704291147530.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Apr 2007, Linus Torvalds wrote:
> On Sun, 29 Apr 2007, Uwe Bugla wrote:
>
> > BUT: This 2.6.21-git2 is unusable in so far as it contains regressive code
> > in the dvb-section, authored by Trent Piepho, acked by Michael Krufky, and signed-off-by Mauro Carvalho Chehab:
>
> You never explained what the problem even was, apart from compiling in
> some code that you didn't need to before. Didn't it work in the end?
>
> If it worked, I don't see what the big issue was. You are getting a _lot_
> of other code in the kernel that you probably never use, you may not even
> have realized.

I'd like to explain this a bit, for people seeing these messages who haven't
been following this part of dvb development.

dvb-pll is a simple driver for a number of I2C tuners, which are used in
many many TV cards.

These are simple devices, and drivers for host controllers (which usually
support quite a few different models of tv card based on the same core chip)
often didn't use dvb-pll.  They would just re-implement an I2C tuner driver,
sometimes more than once in the same file!

The dvb tree ended up with over a dozen different re-implementations of the
same basic tuner driver.  Of course each implementation would have different
bugs, quirks, and missing features.

So we've been removing this code and using dvb-pll.  If you look at some of
my patches to do this:

 14 files changed, 14 insertions(+), 199 deletions(-)
 1 files changed, 4 insertions(+), 34 deletions(-)
 4 files changed, 17 insertions(+), 204 deletions(-)

These patches fixed bugs and added features, yet are very much net negative
when if comes to lines of code in the kernel.

> any chance to deselect the compilation of the dvb-pll.c-module, as its
> deselection only works for VIDEO_V4L1_COMPAT, NOT for VIDEO_V4L1.

dvb-pll has nothing to do with VIDEO_V4L1_COMPAT or VIDEO_V4L1.  Uwe is just
confused about what is causing what.

> All the almost excellent work that Michael Krufky has offered for that
> issue at the transition from 2.6.18 to 2.6.19 or 2.6.20 (do not remeber
> exactly) is being wiped out and rolled back with his acknowledgement!

Uwe is probably talking about the dvb_attach() system, written mainly by
Andrew de Quincey and myself, which went into 2.6.18.  The basic concept is
that a core driver uses symbol_request() to avoid any strong references to
its helper drivers.  This way only the helper drivers that are actually
needed must be loaded.  We want to make dvb-pll use this system too, but it
doesn't fully work yet.  I have several ideas about how to solve the
problem, but it's not a high priority.
