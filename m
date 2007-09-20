Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbXITGMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbXITGMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 02:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXITGMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 02:12:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58182 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754135AbXITGMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 02:12:21 -0400
Date: Wed, 19 Sep 2007 23:11:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: Chuck Ebbert <cebbert@redhat.com>, tilman@imap.cc,
       linux-kernel@vger.kernel.org, gregkh@suse.de, a.zummo@towertech.it
Subject: Re: 2.6.23-rc6-mm1
Message-Id: <20070919231121.e481445c.akpm@linux-foundation.org>
In-Reply-To: <200709192143.14635.david-b@pacbell.net>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<20070919234448.8E87D2319AA@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<20070919170604.f7e82f19.akpm@linux-foundation.org>
	<200709192143.14635.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 21:43:14 -0700 David Brownell <david-b@pacbell.net> wrote:

> On Wednesday 19 September 2007, Andrew Morton wrote:
> > On Wed, 19 Sep 2007 16:44:48 -0700
> > David Brownell <david-b@pacbell.net> wrote:
> > 
> > > > > <4>[   21.211942] Duplicate file names "rtc" detected
> > > >
> > > > Nah, that's an rtc-specific problem.
> > > 
> > > RTC-related ... but it's a procfs bug, since it's procfs which doesn't
> > > even bother to check for duplicate names before it registers files.
> > 
> > So you keep on claiming, but I don't think I've yet seen a description of
> > the *reason* why two copies of this file are being created,
> 
> Yes you did .... most recently in http://lkml.org/lkml/2007/9/19/18 is:
> 
> > > The missing step seems to be that proc_register() doesn't bother
> > > to check whether there's already an entry for that file.  Which
> > > is what the appended *UNTESTED* patch does (it compiles though).
> 
> Although maybe you meant me to parse that differently ... as in,
> not "why is procfs doing this broken thing?" but rather "how is it
> that procfs fault (non)handling code ended up getting used?".
> 
> That's always seemed self-evident:  the RTC framework was creating
> it for /dev/rtc0 (presumably, rtc-cmos), while at the same time the
> legacy drivers/char/rtc.c was creating it for /dev/rtc.
> 
> Workaround by configuring just one, and the problem goes away.
> (Although it *ought* to be OK to configure both, with all the normal
> resource exclusions kicking in to ensure only one will run.)

Head still spinning.

a) "rtc0" != "rtc" ??

b) The kernel is trying to register two procfs files of the same name! 
   If that's a configuration error then we have a Kconfiguration bug.

> 
> > and a 
> > description of why that is an OK thing for the kernel to be doing.
> 
> It's not a wrong thing, at any rate.  This is a fairly basic task
> in any filesystem:  mutual exclusion.  Code is allowed to rely on
> filesystems acting correctly...
> 

We're relying on procfs behaviour to prevent registration of two rtc
devices?  That's a strange means of arbitration.   And what happens
when CONFIG_PROC_FS=n?

> 
> > > > From: Chuck Ebbert <cebbert@redhat.com>
> > > >
> > > > AFAICT the rtc problem is caused by misconfiguration: both the new
> > > > and old rtc driver have been built and they are both trying to load.
> > > 
> > > That _shouldn't_ be a problem at all; only one of them should be
> > > able to bind to that hardware.
> > > 
> > > The only problem I see in these messages is that procfs bug.
> > > 
> > 
> > It's not obvious that this is only a procfs bug.  If some part of the
> > kernel tries to add a procfs file which is already there, that's often a
> > bug in the caller.
> 
> Not really; procfs is supposed to not create it if it's already there!!
> Reasonable callers will cope with "it didn't get created", and that's
> all they should really need to do.
> 
> 
> > Yes, procfs should have been checking for this.  But it is too late now for
> > us to just fail out of the procfs registration code.  Because this can
> > cause previously buggy-but-works-ok code to now fail completely.
> 
> What do you mean by too late "now" ... just-before-2.6.23?

No.

What I mean is that we cannot change procfs as you propose until we have
located and fixed all places in the kernel which can cause duplicated
procfs names.  (Good luck with that).

Because we've had this happening before, and *the driver kept working*
(apart from, presumably, some of their procfs features which, presumably,
nobody used much). 

With the change which you propose, these drivers will probably stop
working, because they will newly find their procfs registration failed.

> I'm a bit puzzled why this issue cropped up suddenly, when the
> "two RTC drivers" configs have been behaving fine (presumably
> failing properly, but at least not generating problem reports)
> for some time.  One of the procfs changes must have caused this
> trouble.

I'm not sure that anything _has_ changed.  It's just that a few people have
suddenly noticed duplicated rtc entris in /proc.  Perhaps theye were there
for some time.

> And what would an example be of buggy-but-works code, which would
> then be broken if the procfs stopped being buggy?
> 

A driver which checks the return value from procfs registration and which
then errors out (as it should) if that registration fails.

> 
> > So I think the best we can do now is to retain the runtime warning and to
> > continue to "succeed" and to identify all the problematic codesites and to
> > either fix them or to convince ourselves that they really are working as
> > intended. 
> 
> At a micro level, both the relevant call sites already have code
> to tolerate the "couldn't create that file" error, which looked
> correct at a quick reading.
> 
> - Dave
