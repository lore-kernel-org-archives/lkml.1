Return-Path: <linux-kernel-owner+w=401wt.eu-S1760592AbXIUPiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760592AbXIUPiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 11:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbXIUPiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 11:38:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43513 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbXIUPiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 11:38:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "huang ying" <huang.ying.caritas@gmail.com>
Subject: Re: [linux-pm] Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
Date: Fri, 21 Sep 2007 17:50:16 +0200
User-Agent: KMail/1.9.5
Cc: linux-pm@lists.linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Nigel Cunningham" <nigel@nigel.suspend2.net>, nigel@suspend2.net,
       "Kexec Mailing List" <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jeremy Maitin-Shepard" <jbms@cmu.edu>, "Len Brown" <lenb@kernel.org>
References: <1190266447.21818.17.camel@caritas-dev.intel.com> <200709211631.19130.rjw@sisk.pl> <851fc09e0709210802o3be2789s8e93410fa07f7066@mail.gmail.com>
In-Reply-To: <851fc09e0709210802o3be2789s8e93410fa07f7066@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709211750.17238.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 21 September 2007 17:02, huang ying wrote:
> On 9/21/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, 21 September 2007 15:14, huang ying wrote:
> > > On 9/21/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > On Friday, 21 September 2007 05:33, Eric W. Biederman wrote:
> > > > > Nigel Cunningham <nigel@nigel.suspend2.net> writes:
> > [--snip--]
> > > > >
> > > > > No one has yet attacked the hard problem of coming up with separate
> > > > > hibernate methods for drivers.
> > > >
> > > > Well, I've been playing a bit with that for some time, but it's not easy by any
> > > > means.
> > > >
> > > > In short, I'm seeing some problems related to the handling of ACPI that seem to
> > > > shatter the entire idea of having separate hibernate methods, at least as far
> > > > as ACPI systems are concerned.
> > >
> > > So sadly to hear this. Can you details it a little? Or a link?
> >
> > Well, the problem is that apparently some systems (eg. my HP nx6325) expect us
> > to execute the _PTS ACPI global control method before creating the image _and_
> > to execute acpi_enter_sleep_state(ACPI_STATE_S4) in order to finally put the
> > system into the sleep state.  In particular, on nx6325, if we don't do that,
> > then after the restore the status of the AC power will not be reported
> > correctly (and if you replace the battery while in the sleep state, the
> > battery status will not be updated correctly after the restore).  Similar
> > issues have been reported for other machines.
> >
> > Now, the ACPI specification requires us to put devices into low power states
> > before executing _PTS and that's exactly what we're doing before a suspend to
> > RAM.  Thus, it seems that in general we need to do the same for hibernation on
> > ACPI systems.
> 
> Then, is it possible to separate device quiesce from device suspend.

It surely is possible, but I'm not sure if it's going to be useful.

I mean, if we need to do exactly the same thing before a suspend to RAM and
before a hibernation (ie. to put devices into low power states), why would we
want to use different methods for that in both cases?

> Perhaps not for swsusp, but for kexec based hibernation?

Frankly, I don't know.

Generally, changing the way in which device drivers handle suspend (to RAM)
and hibernation is a huge task.  After considering this issue for some time
I think that we really should start from hardening suspend (to RAM) so that it
doesn't need the freezer any more, because _that_ would require us to change
the suspend-related drivers' callbacks anyway.

When we are sure how we are going to eliminate the freezer from suspend
(to RAM), we'll know how that affects hibernation and what to do about it.

Greetings,
Rafael
