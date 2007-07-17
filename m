Return-Path: <linux-kernel-owner+w=401wt.eu-S934165AbXGQTnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934165AbXGQTnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757947AbXGQTnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:43:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49708 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758032AbXGQTnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:43:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: david@lang.hm
Subject: Re: Hibernation considerations
Date: Tue, 17 Jul 2007 21:50:42 +0200
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
References: <Pine.LNX.4.44L0.0707171010490.3551-100000@iolanthe.rowland.org> <200707171802.30903.rjw@sisk.pl> <Pine.LNX.4.64.0707170959160.2467@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707170959160.2467@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707172150.44417.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 17 July 2007 19:06, david@lang.hm wrote:
> On Tue, 17 Jul 2007, Rafael J. Wysocki wrote:
> 
> > On Tuesday, 17 July 2007 17:29, david@lang.hm wrote:
> >> On Tue, 17 Jul 2007, Rafael J. Wysocki wrote:
> >>
> >>> On Tuesday, 17 July 2007 16:15, Alan Stern wrote:
> >>>> On Mon, 16 Jul 2007 david@lang.hm wrote:
> >>>>
> >>>>>> I agree, it would be good to have a non-ACPI-specific hibernation mode,
> >>>>>> something which would look to ACPI like a normal shutdown.  But I'm not
> >>>>>> so sure this is possible.
> >>>>>
> >>>>> why would it not be possible?
> >>>>
> >>>>> I can't think of anything much more frustrating then thinking that I
> >>>>> suspended a system and then discovering that becouse the battery went dead
> >>>>> (a complete power loss) that the system wouldn't boot up properly. to me
> >>>>> this would be a fairly common condition (when I'm mobile I use the machine
> >>>>> until I am out of battery, then stop and it may be a long time (days)
> >>>>> before I can charge the thing up again) this would not be a reliable
> >>>>> suspend as far as I'm concerned.
> >>>>>
> >>>>> for suspend-to-ram you have to worry about ACPI states and what you are
> >>>>> doing with them, for suspend-to-disk you can ignore them and completely
> >>>>> power the system off instead.
> >>>>
> >>>> If the only problem with doing this would be lack of wakeup support
> >>>> then I'm all for it.  There must be a lot of people who would like
> >>>> their computers to hibernate with power drain as close to 0 as possible
> >>>> and who don't care about remote wakeup.  In fact they might even prefer
> >>>> not to have wakeup support, so the computer doesn't resume at
> >>>> unexpected times.
> >>>
> >>> I'm afraid of one thing, though.
> >>>
> >>> If we create a framework without ACPI (well, ACPI needs to be enabled in the
> >>> kernel anyway for other reasons, like the ability to suspend to RAM) and then
> >>> it turns out that we have to add some ACPI hooks to it, that might be difficult
> >>> to do cleanly.
> >>
> >> doing suspend-to-ram should be orthoginal to doing hibernate-to-disk. some
> >> people will want both, some won't.
> >>
> >> at the moment kexec doesn't work with ACPI, that is a limitation that
> >> should be fixed, but makeing it able to work with ACPI enabled doesn't
> >> mean that it needs to be changed to depend on ACPI and it especially
> >> doesn't mean that it should pick up the limitations of the existing ACPI
> >> based hibernation approaches.
> >>
> >> if there is no ACPI on the system it should work, if ther is ACPI on the
> >> system it should still work.
> >>
> >>> Thus, it seems reasonable to think of the ACPI handling in advance.
> >>
> >> but don't become dependant on ACPI.
> >
> > Not dependent, but with the possibility of ACPI support taken into account.
> >
> > Arguably you can create a framework that, for example, will not allow the user
> > to adjust the size of the image, but then adding such a functionality may
> > require you to change the entire design.  Same thing with ACPI.
> >
> > I would rather avoid such pitfalls, if I could.
> 
> Ok, what is it that you think ACPI fundamentally changes in this process?
> 
> keep in mind that we are not makeing the assumption that the hardware 
> will remain powered (even a little bit), or the assumption that nothing 
> else will run on the hardware (eliminating any possibility that the 
> hardware is in a known ACPI state)

Well, first, the fact is that _some_ systems _will_ be powered while in
hibernation (the majority of notebooks, for example) and you should assume
that the platform _may_ retain some information accross the hibernation/restore
cycle.  In that case you _should_ _not_ trash the information retained by the
platform.

Now, with that in mind, ACPI requires us to make the system enter the S4 sleep
state as a result of the hibernation procedure.  In my opinion this may be done
after saving the image, but still this means, for example, that the
image-saving kernel needs to support ACPI.

Next, during the restore, we should first check if the image is present (and
valid) _without_ turning ACPI on (note that this is not done by the current
hibernation code and that leads to strange problems on some systems).  Then,
if the image is present (and valid), we should first load it, jump to the
hibernated kernel and _then_ turn ACPI on and execute the _BFS and
_WAK ACPI global methods (again, this is not done by the current code in that
order, which is wrong).  Only after that is the hibernated kernel supposed to
continue.

[Please refer to section 15.3 of the 3.0b ACPI spec for details.]

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
