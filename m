Return-Path: <linux-kernel-owner+w=401wt.eu-S932462AbZLMBP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462AbZLMBP6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932321AbZLMBPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:15:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40332 "HELO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932261AbZLMBPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:15:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Sat, 12 Dec 2009 23:34:08 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912121848.33062.rjw@sisk.pl> <alpine.LFD.2.00.0912121049390.3526@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912121049390.3526@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912122334.08367.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 December 2009, Linus Torvalds wrote:
> 
> On Sat, 12 Dec 2009, Rafael J. Wysocki wrote:
> > 
> > I'd like to put it into my tree in this form, if you don't mind.
> 
> This version still has a major problem, which is not related to 
> completions vs rwsems, but simply to the fact that you wanted to do this 
> at the generic device layer level rather than do it at the actual 
> low-level suspend/resume level.
> 
> Namely that there's no apparent sane way to say "don't wait for children".
> 
> PCI bridges that don't suspend at all - or any other device that only 
> suspends in the 'suspend_late()' thing, for that matter - don't have any 
> reason what-so-ever to wait for children, since they aren't actually 
> suspending in the first place. But you make them wait regardless, which 
> then serializes things unnecessarily (for example, two unrelated USB 
> controllers).

This is a problem that needs to be solved.

One solution that we have discussed on linux-pm is to start a bunch of async
threads searching for async devices that can be suspended and suspending
them (assuming suspend is considered) out of order with respect to dpm_list.
For example, leaf async devices can always be suspended at the same time
regardless of their positions in dpm_list.  This way we could get almost the
entire gain resulting from suspending or resuming devices in parallel without
bothering drivers with the problem of dependencies that need to be honoured.

That's something we can add on top of this patch, though, not to complicate
things from the start and it surely requires more discussion.

> And no, making _everything_ be async is _not_ the answer.

I'm not sure what you mean, really.

Speaking of PCI bridges, even though they don't "suspend" in the sense of
being put into low power states or something, we still need to save their
registers on suspend and restore them on resume, and that restore has to
be done before we start to access devices below the bridge.

There are devices with totally null suspend and resume routines that even
the bus type doesn't really handle, but those can be marked as "async" from
the start and they won't really get in the way any more (this creates another
issue to solve, namely that we shouldn't really start a new async thread for
each of them; we have considered that too).

Even if we move that all to drivers, the constraints won't go away and someone
will have to take care of them.  Now, since _we_ have problems with reaching
an agreement about how to do it, the driver writers will be even less likely to
figure that out.

Rafael
