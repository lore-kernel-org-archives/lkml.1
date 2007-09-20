Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbXITEnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbXITEnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 00:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbXITEnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 00:43:18 -0400
Received: from smtp114.sbc.mail.re2.yahoo.com ([68.142.229.91]:37220 "HELO
	smtp114.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750718AbXITEnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 00:43:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=KMZp0CAeaH+5bs+skmyObunCqPLTSpJZrIzQquZNoWK9crtuj7pwYSyB97fdHnh783gzZqE3g9MHTvWdn27IR9YhsLU7R1uIRl6vwpgz9rgRkbiUMIZtREomkJSpvUDWPuaXzwPTBwNKiJ2/reQwM4BKSB+QaJh1aojgXMBP1tA=  ;
X-YMail-OSG: FOZ_f1gVM1konM_tEWYQp3cvw1Uw2g8Nrx9298NEvGfbHKARHVAH5n0jDo499_1BtaPmy.ZxPWloAMNMFpF937W89P_OdKidAwKzLp92VglyfMKJYcc-
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc6-mm1
Date: Wed, 19 Sep 2007 21:43:14 -0700
User-Agent: KMail/1.9.6
Cc: Chuck Ebbert <cebbert@redhat.com>, tilman@imap.cc,
       linux-kernel@vger.kernel.org, gregkh@suse.de, a.zummo@towertech.it
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <20070919234448.8E87D2319AA@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20070919170604.f7e82f19.akpm@linux-foundation.org>
In-Reply-To: <20070919170604.f7e82f19.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200709192143.14635.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 September 2007, Andrew Morton wrote:
> On Wed, 19 Sep 2007 16:44:48 -0700
> David Brownell <david-b@pacbell.net> wrote:
> 
> > > > <4>[   21.211942] Duplicate file names "rtc" detected
> > >
> > > Nah, that's an rtc-specific problem.
> > 
> > RTC-related ... but it's a procfs bug, since it's procfs which doesn't
> > even bother to check for duplicate names before it registers files.
> 
> So you keep on claiming, but I don't think I've yet seen a description of
> the *reason* why two copies of this file are being created,

Yes you did .... most recently in http://lkml.org/lkml/2007/9/19/18 is:

> > The missing step seems to be that proc_register() doesn't bother
> > to check whether there's already an entry for that file.  Which
> > is what the appended *UNTESTED* patch does (it compiles though).

Although maybe you meant me to parse that differently ... as in,
not "why is procfs doing this broken thing?" but rather "how is it
that procfs fault (non)handling code ended up getting used?".

That's always seemed self-evident:  the RTC framework was creating
it for /dev/rtc0 (presumably, rtc-cmos), while at the same time the
legacy drivers/char/rtc.c was creating it for /dev/rtc.

Workaround by configuring just one, and the problem goes away.
(Although it *ought* to be OK to configure both, with all the normal
resource exclusions kicking in to ensure only one will run.)


> and a 
> description of why that is an OK thing for the kernel to be doing.

It's not a wrong thing, at any rate.  This is a fairly basic task
in any filesystem:  mutual exclusion.  Code is allowed to rely on
filesystems acting correctly...


> > > From: Chuck Ebbert <cebbert@redhat.com>
> > >
> > > AFAICT the rtc problem is caused by misconfiguration: both the new
> > > and old rtc driver have been built and they are both trying to load.
> > 
> > That _shouldn't_ be a problem at all; only one of them should be
> > able to bind to that hardware.
> > 
> > The only problem I see in these messages is that procfs bug.
> > 
> 
> It's not obvious that this is only a procfs bug.  If some part of the
> kernel tries to add a procfs file which is already there, that's often a
> bug in the caller.

Not really; procfs is supposed to not create it if it's already there!!
Reasonable callers will cope with "it didn't get created", and that's
all they should really need to do.


> Yes, procfs should have been checking for this.  But it is too late now for
> us to just fail out of the procfs registration code.  Because this can
> cause previously buggy-but-works-ok code to now fail completely.

What do you mean by too late "now" ... just-before-2.6.23?

I'm a bit puzzled why this issue cropped up suddenly, when the
"two RTC drivers" configs have been behaving fine (presumably
failing properly, but at least not generating problem reports)
for some time.  One of the procfs changes must have caused this
trouble.

And what would an example be of buggy-but-works code, which would
then be broken if the procfs stopped being buggy?


> So I think the best we can do now is to retain the runtime warning and to
> continue to "succeed" and to identify all the problematic codesites and to
> either fix them or to convince ourselves that they really are working as
> intended. 

At a micro level, both the relevant call sites already have code
to tolerate the "couldn't create that file" error, which looked
correct at a quick reading.

- Dave

