Return-Path: <linux-kernel-owner+w=401wt.eu-S1946662AbXBQLi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946662AbXBQLi0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 06:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946663AbXBQLiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 06:38:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45051 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946662AbXBQLiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 06:38:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH] Documentation: Ask driver writers to provide suspend/resume support
Date: Sat, 17 Feb 2007 12:32:59 +0100
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       Nigel Cunningham <ncunningham@linuxmail.org>
References: <200702171128.54492.rjw@sisk.pl> <20070217105946.GA9120@elf.ucw.cz>
In-Reply-To: <20070217105946.GA9120@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702171233.00440.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday, 17 February 2007 11:59, Pavel Machek wrote:
> Hi!
> 
> > Add a paragraph in Documentation/SubmittingDrivers requesting that the
> > susped/resume support be provided by new device drivers.
> > 
> > Add the document Documentation/power/drivers-testing.txt giving general
> > instructions for the testing of suspend/resume support in device drivers.
> > 
> > ---
> >  Documentation/SubmittingDrivers         |   10 ++
> >  Documentation/power/drivers-testing.txt |  146 ++++++++++++++++++++++++++++++++
> >  2 files changed, 156 insertions(+)
> > 
> > Index: linux-2.6.20-git13/Documentation/SubmittingDrivers
> > ===================================================================
> > --- linux-2.6.20-git13.orig/Documentation/SubmittingDrivers
> > +++ linux-2.6.20-git13/Documentation/SubmittingDrivers
> > @@ -87,6 +87,16 @@ Clarity:	It helps if anyone can see how 
> >  		driver that intentionally obfuscates how the hardware works
> >  		it will go in the bitbucket.
> >  
> > +PM support:	Since Linux is used on many portable and desktop systems, your
> > +		driver is likely to be used on such a system and therefore it
> > +		should support basic power management by implementing, if
> > +		necessary, the .suspend and .resume methods used during the
> > +		system-wide suspend and resume transitions.  You should verify
> > +		that your driver correctly handles the suspend and resume, but
> > +		if you are unable to ensure that, please at least define the
> > +		.suspend method returning the -ENOSYS ("Function not
> > +		implemented") error.
> 
> Perhaps pointer to Documentation/power/drivers-testing.txt would be
> useful here?

Okay, maybe something like this:

"Please see Documentation/power/drivers-testing.txt for the driver testing
instructions."

as the last sentence?
 
> >  Control:	In general if there is active maintainance of a driver by
> >  		the author then patches will be redirected to them unless
> >  		they are totally obvious and without need of checking.
> > Index: linux-2.6.20-git13/Documentation/power/drivers-testing.txt
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6.20-git13/Documentation/power/drivers-testing.txt
> > @@ -0,0 +1,146 @@
> > +Testing suspend and resume support in drivers
> > +	(C) 2007 Rafael J. Wysocki <rjw@sisk.pl>
> 
> If you add copyright, maybe specify license, too? (", GPL" should be enough).

OK

> > +Unfortunately, to effectively test the support for the system-wide suspend and
> > +resume transitions in a driver, it is necessary to suspend and resume a fully
> > +functional system with this driver loaded.  Moreover, that should be done many
> > +times, preferably many times in a row, and separately for the suspend to disk
> > +(STD) and the suspend to RAM (STR) transitions, because each of these cases
> > +involves different ordering of operations and different interactions with the
> > +machine's BIOS.
> 
> Hmm, actually it is nice to mix STR + STD, too... and not sure if
> "many" is right word... It sounds scary :-).

"a couple of"?
 
> > +To verify that the STD works, you can try to suspend in the "reboot" mode:
> > +
> > +# echo reboot > /sys/power/disk
> > +# echo disk > /sys/power/state
> > +
> > +and the system should suspend, reboot, resume and get back to the command prompt
> > +where you have started the transition.  If that happens, the STD is most likely
> > +to work correctly, but you need to repeat the test at least a couple of times in
> > +a row for confidence.  This is necessary because some problems only
> 
> , because?

OK

> > +c) Advanced debugging
> 
> Actually, those debugging instructions look really cool. Perhaps we
> should split them into separate file, as it is also interesting for
> users trying to get suspend working on their machine?

OK

basic-pm-debugging.txt and driver-testing.txt ?
 
> > +II. Testing the driver
> > +
> > +Once you have resolved the suspend/resume-related problems with your test system
> > +without the new driver, you are ready to test it:
> > +
> > +1. Build the driver as a module, load it and try the STD in the test mode
> > +(cf. 1a)).
> > +
> > +2. Compile the driver directly into the kernel and try the STD in the test mode
> > +(cf. 1a)).
> > +
> > +3. Build the driver as a module, load it and attempt to suspend to disk in the
> > +"reboot", "shutdown" and "platform" modes (cf. 1).
> > +
> > +4. Compile the driver directly into the kernel and attempt to suspend to disk in
> > +the "reboot", "shutdown" and "platform" modes (cf. 1).
> > +
> > +5. Build the driver as a module, load it and attempt to run s2ram (cf. 2).
> > +
> > +6. Compile the driver directly into the kernel and attempt to run s2ram (cf. 2).
> > +
> > +Each of the above tests should be repeated several times and if any of them
> > +fails, the driver cannot be regarded as suspend/resume-safe.
> 
> Maybe reorder the tests so that poor submitter will not have to do 3
> kernel compiles?

I thought he would figure out that there's more efficient way. ;-)

Greetings,
Rafael
