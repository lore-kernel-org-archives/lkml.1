Return-Path: <linux-kernel-owner+w=401wt.eu-S1759357AbXIUOIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357AbXIUOIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758140AbXIUOIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:08:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43170 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758102AbXIUOIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:08:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when booted, USB-related WARNING
Date: Fri, 21 Sep 2007 16:20:52 +0200
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
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <200709210030.20662.rjw@sisk.pl> <1190379599.3213.8.camel@chaos>
In-Reply-To: <1190379599.3213.8.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709211620.53794.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Friday, 21 September 2007 14:59, Thomas Gleixner wrote:
> Rafael,
> 
> On Fri, 2007-09-21 at 00:30 +0200, Rafael J. Wysocki wrote:
> > > -ETOOTIRED led me too a wrong conclusion, but still it is a valuable
> > > hint that this change is making things work again.
> > 
> > Yes, it is.
> > 
> > > I need to go down into the details of the swsusp_suspend() code path to
> > > figure out, what's the root cause. 
> > 
> > If you need any help from me with that, please let me know.
> 
> I'm zooming in. It seems, that the ACPI idle code plays tricks with us.
> After debugging the swsusp_suspend() code path I figured out, that we
> end up in C2 or deeper power states while we run the suspend code. The
> same happens when we come back on resume. It looks like we disable stuff
> in the ACPI BIOS, which makes the C2 and deeper power states misbehave.

Hm, can you please run the test I've suggested in another branch of the
thread, ie.

# echo shutdown > /sys/power/disk
# echo disk > /sys/power/state

without your debugging code in disk.c?

This makes the hibernation code omit the major ACPI hooks, so if it works,
we'll know that these hooks are responsible for the problem.

> I hacked the idle loop arch code to use halt() right before we call
> device_suspend() and switch back to the acpi idle code right after
> device_resume(). This solves the problem as well.

Well, that seems less intrusive than changing the code ordering right before
the major kernel release, but I think we should do our best to understand what
_exactly_ is happening here.

Greetings,
Rafael
