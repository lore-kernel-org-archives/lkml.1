Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbXIVVii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbXIVVii (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 17:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbXIVVia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 17:38:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47017 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbXIVVi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 17:38:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [linux-pm] Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
Date: Sat, 22 Sep 2007 23:51:30 +0200
User-Agent: KMail/1.9.5
Cc: Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>, nigel@suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       linux-pm@lists.linux-foundation.org,
       huang ying <huang.ying.caritas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.44L0.0709211540100.5816-100000@iolanthe.rowland.org> <200709221234.18426.rjw@sisk.pl> <3BCF760C-D77D-417A-809A-B20D04DD01D3@mac.com>
In-Reply-To: <3BCF760C-D77D-417A-809A-B20D04DD01D3@mac.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709222351.32137.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 22 September 2007 20:00, Kyle Moffett wrote:
> On Sep 22, 2007, at 06:34:17, Rafael J. Wysocki wrote:
> > On Saturday, 22 September 2007 01:19, Kyle Moffett wrote:
> >> On Sep 21, 2007, at 17:16:59, Jeremy Maitin-Shepard wrote:
> >>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >>>> The ACPI platform firmware is allowed to preserve information  
> >>>> accross the hibernation-resume cycle, so this need not be the same.
> >>>
> >>> All of my comments related to the case where S4 is not being used  
> >>> (instead the system is just powered off normally), and a boot  
> >>> kernel that does not initialize ACPI is used.  In that case, the  
> >>> ACPI platform firmware should not be able to distinguish a normal  
> >>> boot from a resume from hibernation.
> >>
> >> I think that in order for this to work, there would need to be  
> >> some ABI whereby the resume-ing kernel can pass its entire ACPI  
> >> state and a bunch of other ACPI-related device details to the  
> >> resume-ed kernel, which I believe it does not do at the moment.
> >
> > In fact we don't need to do this.
> >
> > The solution is not to touch ACPI in the boot kernel (ie. the one  
> > that loads the image) and pass control to the image kernel.  This  
> > is how it's supposed to work according to the spec, more or less  
> > (well, there are some ugly details  that need handling, like the  
> > restoration of the NVS area).
> 
> First of all, we will need to make the resumed kernel throw away  
> *ALL* of its ACPI state on S5 and completely reinitialize ACPI as  
> though it was booting for the first time on resume.

Yes, if we entered S5 in the last step of the hibernation sequence, the right
thing to do would be to make the resumed kernel reinitialize ACPI from
scratch.

> From what I can tell, we "throw away" all the ACPI state in the boot kernel
> and reinitialize it there, but then the reinitialized state is  
> overwritten with the resumed kernel's state and the two don't always  
> happen to be the same.  (Like if a battery got replaced or AC status  
> changed).

Usually it goes like that.  Still, you can pass "acpi=off" to the boot kernel,
in which case it won't reinitialize ACPI.

> Umm, I don't see how that can possibly work properly.  For a laptop,  
> for example, the restore kernel will need to access the disk, the LCD  
> display, and possibly the AC/battery and current CPU frequency.  From  
> what I understand of ACPI, both of the former may need ACPI code to  
> operate properly (Isn't there an ATA taskfile object of some kind?)  
> and the latter two almost definitely need ACPI.

Well, this is not the case on any systems that I have access to, including
two quite modern notebooks.  Apparently, everything works without ACPI on
these machines.

Besides, in theory, it's possible to use an "intelligent" boot loader to read
the hibernation image and that doesn't need ACPI for anything.

> Ergo the boot kernel may need to initialize and use ACPI just to run an ATA
> taskfile so it can read from the HDD efficiently.

It is possible, but I haven't seen that yet.
 
> >> I believe that what causes problems is the ACPI state data that  
> >> the kernel stores is *different* between identical sequential  
> >> boots, especially when you add/remove/replace batteries, AC, etc.
> >
> > Rather the ACPI state data that the platform firmware stores may be  
> > different, depending on whether you enter S4 or S5 during "power  
> > off" and that determines the interactions between the kernel and  
> > the firmware after the next boot.
> 
> That's not what he was talking about.  The problem discussed was:
>    (A) You hibernate your box, entering S5 (IE: power off)
>    (B) You resume the box and the boot kernel inits all the ACPI stuff.
>    (C) The boot kernel's ACPI state is completely replaced by the  
> resumed kernel's state.
>    (D) Hardware stops working mysteriously because of ACPI problems.
> 
> The only possible conclusion is that the state between the boot  
> kernel and the resume kernel was *different* and so the device failed  
> because the ACPI state in the resume kernel doesn't match the actual  
> state of the hardware.

I think it's even more complicated.  The ACPI state of the resumed kernel
has to match whatever is preserved by the platform.

Well, my impression is that our current ACPI resume code actually expects
the platform to preserve something and if that's missing the devices in
question are not handled properly.  If that really is the case, there is the
question whether we can do something about it in a reasonable way and I can't
answer it right now.

Besides, I really think that we should use the ACPI S4 state, because machines
generally support that.

Greetings,
Rafael
