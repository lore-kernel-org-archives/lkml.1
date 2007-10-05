Return-Path: <linux-kernel-owner+w=401wt.eu-S1761149AbXJEQ1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761149AbXJEQ1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 12:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756929AbXJEQ05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 12:26:57 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:59959
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754572AbXJEQ04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 12:26:56 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [RFC][PATCH] New message-logging API (kprint)
Date: Fri, 5 Oct 2007 11:05:27 -0500
User-Agent: KMail/1.9.6
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Michael Holzheu" <holzheu@linux.vnet.ibm.com>,
       "Joe Perches" <joe@perches.com>,
       "Dick Streefland" <dick.streefland@altium.nl>,
       "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Arnd Bergmann" <arnd@arndb.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Emil Medve" <Emilian.Medve@freescale.com>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "linux@horizon.com" <linux@horizon.com>,
       "Miguel Ojeda" <maxextreme@gmail.com>
References: <1191528247.13580.11.camel@grianne> <200710042059.25721.rob@landley.net> <19f34abd0710050613y62fe6417lb47dc2bc7ad69b28@mail.gmail.com>
In-Reply-To: <19f34abd0710050613y62fe6417lb47dc2bc7ad69b28@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200710051105.27731.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 October 2007 8:13:09 am Vegard Nossum wrote:
> On 10/5/07, Rob Landley <rob@landley.net> wrote:
> > On Thursday 04 October 2007 3:17:03 pm Randy Dunlap wrote:
> > > On Thu, 04 Oct 2007 22:04:07 +0200 Vegard Nossum wrote:
> > > > Description: This patch largely implements the kprint API as
> > > > previously posted to the LKML and described in
> > > > Documentation/kprint.txt (see patch).
> > > >
> > > > The main purpose of this change is provide a unified logging API to
> > > > the kernel and at the same time make it easy to add extensions, now
> > > > and later.
> > > >
> > > > My changes and additions are as follows:
> > >
> > > $ diffstat -p1 -w70 kprint.patch
> >
> > ...
> >
> > >  40 files changed, 1660 insertions(+), 72 deletions(-)
> >
> > I started this thread by posting an idea I had for shrinking the kernel
> > by allowing more code to be configured out.  The API change was exactly
> > one new parameter, with a direct 1->1 mapping from the old API to the new
> > one, which was trivial to convert and which the compiler would catch if
> > you missed one.
> >
> > The result of the discussion is a patch adding 1600 lines to the kernel,
> > without removing anything.
>
> Of course. If you look at the diffstat, as kindly posted by Randy,
> you'll notice that about 500-600 of those lines are documentation,
> configuration files, and headers.

Yay documentation, and I read it, but it's still adding complexity:

  > 6. Calling syslog (in glibc, klogctl()) with a (type|0x10) will access the
  >    new kprint buffer instead of the regular log buffer. The kprint buffer
  >    is different in that it doesn't record the actual formatted message,
  >    but the format string and the (formatted) arguments. Example:

This adds a new buffer in parallel with the old buffer.  The new one is 
significantly more complex to use from userspace, and has no advantages for 
the _current_ uses of it, therefore the old one will never _stop_ being used, 
and thus can probably never be removed.

But it's not bloat.  Right.

> What's really a concern (and a valid argument) is the overhead
> introduced for each call to printk(); the defconfig kernel on x86
> increases with about 210K. I will try to improve this.
>
> > Last I checked, the current prink() worked just fine.  Why is this _not_
> > the dreaded "infrastructure in search of a use"?  What exactly can we
> > _not_ do with the current code?  What does this allow us to remove and
> > simplify?
>
> With the current code, localisation is not possible to do in a sane
> way.

Run dmesg through a filter in userspace using lots of regular expressions.  
Your average perl junkie could knock out a basic prototype in 20 minutes.

This also gives you the option of _not_ using the filter to get the raw dmesg 
output in english, which is the only thing this list can diagnose.

If you think that's going to break when kernel guys change the code each 
release, explain how your new one _wouldn't_.

> My change is a "catch all" in desired features -- not just 
> removing some unwanted printks.

That's a good thing?  It's infrastructure in search of a use, implementing 
things that might, at some future date, be interesting, and complicating the 
code to do it in both the kernel and userspace.

I'm missing the "advantage" part.  I'm not close to perfect so I could just be 
failing to see its obvious greatness, but I continue to fail to see it...

> Vegard

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
