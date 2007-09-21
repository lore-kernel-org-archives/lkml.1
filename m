Return-Path: <linux-kernel-owner+w=401wt.eu-S1762085AbXIUTHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762085AbXIUTHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760314AbXIUTHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:07:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43961 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013AbXIUTHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:07:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when booted, USB-related WARNING
Date: Fri, 21 Sep 2007 21:20:01 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, miklos@szeredi.hu,
       Len Brown <len.brown@intel.com>,
       David Shaohua Li <shaohua.li@intel.com>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <200709211620.53794.rjw@sisk.pl> <1190392033.2935.11.camel@chaos>
In-Reply-To: <1190392033.2935.11.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709212120.03044.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 21 September 2007 18:27, Thomas Gleixner wrote:
> Rafael,
> 
> On Fri, 2007-09-21 at 16:20 +0200, Rafael J. Wysocki wrote:
> > > > If you need any help from me with that, please let me know.
> > > 
> > > I'm zooming in. It seems, that the ACPI idle code plays tricks with us.
> > > After debugging the swsusp_suspend() code path I figured out, that we
> > > end up in C2 or deeper power states while we run the suspend code. The
> > > same happens when we come back on resume. It looks like we disable stuff
> > > in the ACPI BIOS, which makes the C2 and deeper power states misbehave.
> > 
> > Hm, can you please run the test I've suggested in another branch of the
> > thread, ie.
> > 
> > # echo shutdown > /sys/power/disk
> > # echo disk > /sys/power/state
> > 
> > without your debugging code in disk.c?
> > 
> > This makes the hibernation code omit the major ACPI hooks, so if it works,
> > we'll know that these hooks are responsible for the problem.
> 
> Yes, this works fine. We still go into C3, but this seems not longer to
> brick the box.
> 
> > > I hacked the idle loop arch code to use halt() right before we call
> > > device_suspend() and switch back to the acpi idle code right after
> > > device_resume(). This solves the problem as well.
> > 
> > Well, that seems less intrusive than changing the code ordering right before
> > the major kernel release, but I think we should do our best to understand what
> > _exactly_ is happening here.
> 
> I found some other subtle thinko in the clock events code while I was
> heading down the swsusp_suspend code path. I wait for confirmation that
> it does not brick some endangered boxen, though. Still with this change
> in the clock events code, my VAIO goes into C2 or C3 and causes the box
> to wait for a helping keystroke.
> 
> The correct solution would be, that the ACPI code ignores the lower
> C-states during suspend / resume.

Yes, certainly.

> I simply rmmod'ed the processor module before suspend and the problem is
> solved as well. The cpuidle patches make this problem more prominent due
> to the possible more direct switch into lower power states, when we wait for
> a long time on something. 

So, perhaps we can add a .suspend()/.resume() routines to the processor driver
and use them to disable/enable the cpuidle functionality during a
suspend/resume?

> I think we really should not fiddle with the various cpu states during
> the critical parts of suspend / resume. Let's keep it simple. We have
> the same policy during boot and I think the suspend / resume critical
> parts have similar constraints.

I completely agree.

Greetings,
Rafael
