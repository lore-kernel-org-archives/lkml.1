Return-Path: <linux-kernel-owner+w=401wt.eu-S1761220AbXIUQ1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761220AbXIUQ1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 12:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759482AbXIUQ1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 12:27:19 -0400
Received: from www.osadl.org ([213.239.205.134]:56176 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755079AbXIUQ1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 12:27:18 -0400
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when
	booted, USB-related WARNING
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, miklos@szeredi.hu,
       Len Brown <len.brown@intel.com>,
       David Shaohua Li <shaohua.li@intel.com>
In-Reply-To: <200709211620.53794.rjw@sisk.pl>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	 <200709210030.20662.rjw@sisk.pl> <1190379599.3213.8.camel@chaos>
	 <200709211620.53794.rjw@sisk.pl>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 18:27:13 +0200
Message-Id: <1190392033.2935.11.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

On Fri, 2007-09-21 at 16:20 +0200, Rafael J. Wysocki wrote:
> > > If you need any help from me with that, please let me know.
> > 
> > I'm zooming in. It seems, that the ACPI idle code plays tricks with us.
> > After debugging the swsusp_suspend() code path I figured out, that we
> > end up in C2 or deeper power states while we run the suspend code. The
> > same happens when we come back on resume. It looks like we disable stuff
> > in the ACPI BIOS, which makes the C2 and deeper power states misbehave.
> 
> Hm, can you please run the test I've suggested in another branch of the
> thread, ie.
> 
> # echo shutdown > /sys/power/disk
> # echo disk > /sys/power/state
> 
> without your debugging code in disk.c?
> 
> This makes the hibernation code omit the major ACPI hooks, so if it works,
> we'll know that these hooks are responsible for the problem.

Yes, this works fine. We still go into C3, but this seems not longer to
brick the box.

> > I hacked the idle loop arch code to use halt() right before we call
> > device_suspend() and switch back to the acpi idle code right after
> > device_resume(). This solves the problem as well.
> 
> Well, that seems less intrusive than changing the code ordering right before
> the major kernel release, but I think we should do our best to understand what
> _exactly_ is happening here.

I found some other subtle thinko in the clock events code while I was
heading down the swsusp_suspend code path. I wait for confirmation that
it does not brick some endangered boxen, though. Still with this change
in the clock events code, my VAIO goes into C2 or C3 and causes the box
to wait for a helping keystroke.

The correct solution would be, that the ACPI code ignores the lower
C-states during suspend / resume. I simply rmmod'ed the processor module
before suspend and the problem is solved as well. The cpuidle patches
make this problem more prominent due to the possible more direct switch
into lower power states, when we wait for a long time on something.

I think we really should not fiddle with the various cpu states during
the critical parts of suspend / resume. Let's keep it simple. We have
the same policy during boot and I think the suspend / resume critical
parts have similar constraints.

	tglx






