Return-Path: <linux-kernel-owner+w=401wt.eu-S1758549AbYABN0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbYABN0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 08:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbYABN00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 08:26:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41401 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbYABN0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 08:26:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/4] PM: Do not destroy/create devices while suspended (rev. 2)
Date: Wed, 2 Jan 2008 14:28:23 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Greg KH <gregkh@suse.de>, David Brownell <david-b@pacbell.net>
References: <200801020032.45529.rjw@sisk.pl> <200801021356.59865.rjw@sisk.pl> <20080102131529.GA32160@elte.hu>
In-Reply-To: <20080102131529.GA32160@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801021428.25164.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 2 of January 2008, Ingo Molnar wrote:
> 
> (David Brownell Cc:-ed too)
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > Well, we have the following test script in the userland suspend 
> > package that is supposed to work right now:
> > 
> > #!/bin/bash
> > date
> > cd /sys/class/rtc/rtc0
> > echo $(( $(cat since_epoch) + 20 )) > wakealarm
> > s2ram
> > date
> > 
> > provided that the new rtc driver code is compiled (and the old one is not).
> 
> ok, will try that. A stupid question. The old RTC driver is in 
> drivers/char/rtc.c, and maps to:
> 
>   crw-r--r-- 1 root root  10, 135 Oct 25 18:02 /dev/rtc
> 
> the new driver is in drivers/rtc/*, and maps to:
> 
>   crw-r--r-- 1 root root 254,   0 Dec 12 02:30 /dev/rtc0
> 
> but all the x86 distro boxes i have access to make use of /dev/rtc. 
> There's no symlink set up from /dev/rtc to /dev/rtc0 either. So it 
> appears to me that the new RTC driver isnt actually utilized on most 
> distributions.

I think so.

> shouldnt we provide a Kconfig way of replacing dev 10:135 with the new 
> driver's 254:0 device? (while keeping all the current modes of operation 
> as well, of course.) It's all supposed to be 100% ioctl ABI compatible 
> with the old driver, right? That way distros could start migrating to it 
> as well, without depending on any udev hackery.

Question for Dave. ;-)

> > > That way any suspend breakage would be detectable (and bisectable) 
> > > in automated testing - if the resume does not come back after 10-20 
> > > seconds then the test failed.
> > 
> > Yes, but please note that some systems require user space 
> > manipulations of the graphics adapter for suspend to work and to 
> > detect a breakage of such a system you need to boot it into X and use 
> > s2ram to suspend.
> 
> yeah, i wouldnt expect graphics mode to come back without quirks. But it 
> should still work fine over the network, right? (which is my main mode 
> of testing anyway)

Well, if the graphics is sufficiently broken, it won't resume at all.

The "echo core > /sys/power/pm_test && echo mem > /sys/power/state" thing
should always work, though (IOW, if this doesn't work, we cartainly have a
bug).

Rafael
