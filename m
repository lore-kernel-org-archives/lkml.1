Return-Path: <linux-kernel-owner+w=401wt.eu-S1756291AbYGLXbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291AbYGLXbg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 19:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbYGLXb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 19:31:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36541 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbYGLXb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 19:31:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andy Lutomirski <luto@myrealbox.com>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
Date: Sun, 13 Jul 2008 01:33:11 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>,
       public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@lo.gmane.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
References: <200807010148.02135.rjw@sisk.pl> <200807122253.32382.rjw@sisk.pl> <48793A0E.3050803@myrealbox.com>
In-Reply-To: <48793A0E.3050803@myrealbox.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807130133.12324.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 13 of July 2008, Andy Lutomirski wrote:
> Rafael J. Wysocki wrote:
> > On Saturday, 12 of July 2008, Andy Lutomirski wrote:
> >> Rafael J. Wysocki wrote:
> >>> On Saturday, 12 of July 2008, Andy Lutomirski wrote:
> >>>> My Lenovo X61s fails to resume if I suspend it from within X, on both 
> >>>> 2.6.26-rc9 and recent wireless-testing.  2.6.26-rc8 is fine, as is 
> >>>> wireless-testing with 4b4f7280 reverted.  My in-progress bisect between 
> >>>> -rc8 and -rc9 is also consistent with this being the problem.
> >>>>
> >>>> The symptom is that, when I push the power button to resume, the hard 
> >>>> drive light turns on, the fan turns on, then the hard drive light turns 
> >>>> off, the sleep light stays on, and the fan keeps running.  Sometimes the 
> >>>> battery light will blink off very briefly (1/4 sec, maybe) every few 
> >>>> seconds.  The system is locked hard at this point.
> >>>>
> >>>> I'm using Ubuntu Hardy userspace.
> >>> Well, that's bad.
> >>>
> >>> There is the bugzilla entry at http://bugzilla.kernel.org/show_bug.cgi?id=11064
> >>> for this bug and you've just confirmed my suspicion that this particular
> >>> commit is to blame.
> >>>
> >>> Can you please see if the appended patch changes anything?
> >> More correctly:
> >>
> >> If I suspend by typing pm-suspend or echo mem >/sys/power/state, then it 
> >> resumes just fine.  If I log in to Gnome and push the suspend button, 
> >> then it does not resume.  This seems to be the case with or without your 
> >> patch.
> > 
> > Is there an Intel graphics in your box?
> 
> Yes.
> 
> > 
> >> -rc8 and -rc9 with the original patch 4b4f7280 resume fine no matter how 
> >> I suspend.
> > 
> > That's _really_ strange.
> > 
> > In fact I have only one explanation, which is that the Gnome suspend button
> > causes some user-space quirks to be applied, which are harmful and break the
> > resume.  Also, without commit 4b4f7280 those quirks might have not been really
> > executed.  Peter, does it sound reasonable?
> 
> Bingo.  It's a HAL quirk.
> 
> Testing from the console (not X):
> 
> With 4b4f7280:
> # echo mem >/sys/power/state -- works fine
> 
> # echo 3 >/proc/sys/kernel/acpi_video_flags
> # echo mem >/sys/power state -- fails to resume
> 
> Without 4b4f7280:
> # echo mem >/sys/power/state -- works fine
> 
> # echo 3 >/proc/sys/kernel/acpi_video_flags
> # echo mem >/sys/power state -- works fine
> 
> So HAL contains an apparently unnecessary quirk for my laptop, and 
> 4b4f7280 breaks that quirk.  Of course, it's entirely possible that 
> 4b4f7280 is 100% correct, but that the quirk only worked by accident and 
> 4b4f7280 broke the call into video BIOS.

We've had reports from users of Intel graphics and the i915 driver that
previously working quirks started to break their systems with 2.6.26-rc, but
instead the plain "echo mem > /sys/power/state" started to work for them.
Your system may be one of these, but I wonder what the effect of commit
4b4f7280 is.

The first possibility is that the quirks actually didn't work on your system
with 2.6.26-rc before commit 4b4f7280 at all for some obscure reason and
that commit made them work again which in turn resulted in the breakage.

The second possibility is that commit 4b4f7280 actually broke those quirks.

I'm not sure if it's worth the effort to check which of the above really
happened.  After all, you can suspend and resume the box without any quirks
now. ;-)

Thanks,
Rafael
