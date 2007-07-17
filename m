Return-Path: <linux-kernel-owner+w=401wt.eu-S936264AbXGQVMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936264AbXGQVMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbXGQVMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:12:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50368 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756240AbXGQVMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:12:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: david@lang.hm
Subject: Re: Hibernation considerations
Date: Tue, 17 Jul 2007 23:20:14 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
References: <Pine.LNX.4.44L0.0707171416120.3728-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707172320.16279.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 17 July 2007 22:27, david@lang.hm wrote:
> On Tue, 17 Jul 2007, Alan Stern wrote:
> 
> > On Tue, 17 Jul 2007, Rafael J. Wysocki wrote:
> >
> >> I'm afraid of one thing, though.
> >>
> >> If we create a framework without ACPI (well, ACPI needs to be enabled in the
> >> kernel anyway for other reasons, like the ability to suspend to RAM) and then
> >> it turns out that we have to add some ACPI hooks to it, that might be difficult
> >> to do cleanly.
> >>
> >> Thus, it seems reasonable to think of the ACPI handling in advance.
> >
> > Absolutely.  This needs to be done in such a way that it will work:
> >
> > 	On platforms without ACPI;
> >
> > 	On platforms with ACPI where we do a non-ACPI type of shutdown
> > 	to whatever extent it is possible (or perhaps an ACPI-aware
> > 	shutdown rather than change to S4);
> >
> > 	On platforms with ACPI where we do an ACPI-aware transition
> > 	to S4.
> >
> > Rafael, for those of us who aren't thoroughly familiar with all the ins
> > and outs of the ACPI spec, could you please summarize a list of the
> > ACPI calls needed in the second and third cases above?  Indicate which
> > ones need to be done from within the original kernel and which should
> > be done from within a kexec'd hibernation kernel.
> >
> 
> there was just a link on slashdot toa primer on the subject of power 
> management
> 
> http://www.techarp.com/showarticle.aspx?artno=420
> 
> >
> > I'm still not entirely clear on how "suspend-to-both" ought to be
> > handled.  Presumably it will start off as a normal hibernation.  But
> > instead of shutting down, wouldn't the kexec'd kernel return to the
> > original kernel?  After all, the original kernel knows about all the
> > devices and can put them into a low-power state, while the kexec'd
> > kernel might not have sufficient information.
> 
> this is what I'm thinking, but the issue here is that the original kernel 
> needs to go into suspend-to-ram mode instead of resuming operation. per 
> the e-mail I got from Ying last night this should not be hard to 
> implement.
> 
> > But what about the freezer?  The original reason for using kexec was to
> > avoid the need for the freezer.  With no freezer, while the original
> > kernel is busy powering down its devices, user tasks will be free to
> > carry out I/O -- which will make the memory snapshot inconsistent with
> > the on-disk data structures.
> 
> no, user tasks just don't get scheduled during shutdown.
> 
> the big problem with the freezer isn't stopping anything from happening, 
> it's _selectivly_ stopping things.

It's selectively stopping kernel threads, which is just about right.  If you
that _this_ is a main problem with the freezer, then think again.

> with kexec you don't need to let any portion of the origional kernel or 
> userspace operate so you don't have a problem.

In fact, the main problem with the freezer is that it is a coarse-grained
solution.  Therefore, what I believe we should do is to evolve in the directoin
of more fine-grained solutions and gradually phase out the freezer.

The kexec-based approach is an attempt to replace one coarse-grained solution
(the freezer) with even more coarse-grained solution (stopping the entire
kernel with everything), which IMO doesn't address the main problem.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
