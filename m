Return-Path: <linux-kernel-owner+w=401wt.eu-S933624AbZLFA25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933624AbZLFA25 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 19:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933291AbZLFA2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 19:28:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36291 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932971AbZLFA2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 19:28:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
Date: Sun, 6 Dec 2009 01:29:19 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200912052216.19540.rjw@sisk.pl> <alpine.LFD.2.00.0912051334461.3649@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912051334461.3649@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912060129.19245.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 December 2009, Linus Torvalds wrote:
> 
> On Sat, 5 Dec 2009, Rafael J. Wysocki wrote:
> > 
> > * Asynchronous suspend and resume infrastructure.  For now, PCI, ACPI and
> >   serio devices are enabled to suspend and resume asynchronously.
> 
> I really think this is totally and utterly broken. Both from an 
> implementation standpoint _and_ from a pure conceptual one.
> 
> Why isn't the suspend/resume async stuff just done like the init async 
> stuff?
> 
> We don't need that crazy per-device flag for initialization, neither do we 
> need drivers "enabling" any async code at all. They just do some things 
> asynchronously, and then at the end of init time we wait for all those 
> async events.
> 
> So why does suspend/resume need to do crazy sh*t instead?

Because it can run entire suspend and resume callbacks in parallel and not
just some stuff inside of them.  The flag is to tell it which callbacks not to
execute in parallel, but it essentially should not be necessary as soon as we
know all dependences between devices (ie. the ones that are not encoded in
the structure of the device tree).

The problem is there are dependences between devices we're not aware of,
which are not documented anywhere and not reflected by the device tree
structure and we need some time to figure them out.

> It all looks terminally broken: you force async suspend for all PCI 
> drivers, even when it makes no sense.

I'm not exactly sure what you're referring to.  The async suspend is not
forced, it just tells the PM core that it can execute PCI suspend/resume
callbacks in parallel as long as the devices in question don't depend on each
other.

> Rather than let the drivers that already know how to do things like disk
> spinup asynchronously just do it that way.

This isn't just about disk spin up and things like that.  If we can run entire
suspend/resume callbacks in parallel, why not to do that?

> The "timing" routines are also just crazy. What is the excuse for 
> dpm_show_time() taking both start and stop times,

This is a mistake, although really easily fixable in a followup patch.

> since there is never any valid situation when it shouldn't have that
> do_gettimgofday(&stop) just before it? IOW - the whole end-time thing should
> be _inside_ dpm_show_time, rather than being done by the caller. No?

Yes, you're right.

> In other words - I'm not pulling this crazy thing. You'd better explain 
> why it was done that way, when we already have done the same things better 
> before in different ways.

I'm not sure we have, but whatever.

As I said before, if the rest of the changes in my pull request are fine with
you, I'll just drop the async changes, although I'm not really convinced
they're so bad.  They've been discussed a lot and they've been in linux-next
for a few months without any objection from anyone.

Thanks,
Rafael
