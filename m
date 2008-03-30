Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbYC3Wo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbYC3Wo4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 18:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756582AbYC3WmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 18:42:08 -0400
Received: from mail.gmx.net ([213.165.64.20]:36158 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755629AbYC3WmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 18:42:07 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1+eqcdnAGKerUt7ZJGoQ9eQSrvCzwPFlR6MwMS7hj
	MB0RqzjG3yy13X
Date: Mon, 31 Mar 2008 00:42:03 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] evdev: Release eventual input device grabs when
	getting disconnected
Message-ID: <20080330224203.GA22498@atjola.homenet>
References: <20080330184259.GB21375@atjola.homenet> <alpine.LFD.1.00.0803301448190.14670@woody.linux-foundation.org> <20080330222228.GA2419@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080330222228.GA2419@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008.03.30 15:22:28 -0700, Greg KH wrote:
> On Sun, Mar 30, 2008 at 02:51:02PM -0700, Linus Torvalds wrote:
> > On Sun, 30 Mar 2008, Bj?rn Steinbrink wrote:
> > > I can't reproduce the bug on my UP box and currently can't afford
> > > crashing my SMP box (all the oopses seem to come from SMP kernels, so I
> > > guess it needs SMP to crash), so while this doesn't show any new
> > > problems, I can't tell whether it actually fixes anything. Testers
> > > welcome!
> > 
> > Ok, I applied this because I will do an -rc8 today or tomorrow, but I 
> > really really hope somebody can figure out what made this all start to 
> > trigger. It does smell like some core device layer change, because we do 
> > not seem to have a lot of changes since 2.6.24 in evdev.c and input.c that 
> > seem relevant.
> > 
> > Greg, are there any refcounting changes that would cause the input devices 
> > to be free'd earlier or something?
> 
> Earlier?  No, not that I know of at all, as long as the reference
> counting logic was correct originally.  All of the problems we have been
> fixing were ones where we accidentally were grabbing too many references
> and then wondering why things were not getting cleaned up properly as
> the kobject rework exposed these problems making them more obvious.

Not freeing the input device at all would of course also hide any
access-after-free problems :-) So if that's the case, that might explain
the sudden exposure of the problem. IMHO, my patch is the right thing to
do anyway, because releasing a grab on the underlying input device from
within evdev clearly needs to happen before we release that device. So
AFAICT we're really just looking for "why do we see that bug now?" and
"is there another bug?"

> I haven't heard of the opposite happening.  Anything that I can try to
> test for here, I have a lot of removable input devices to test with.

Sorry, forgot to set the In-Reply-To header when sending the patch. The
original thread, with a reproducing recipe is here:
http://lkml.org/lkml/2008/3/28/442
Message-Id: <1206742499.22530.90.camel@johannes.berg>

Björn
