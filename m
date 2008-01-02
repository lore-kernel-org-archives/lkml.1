Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbYABNRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbYABNRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 08:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbYABNQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 08:16:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41925 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924AbYABNQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 08:16:57 -0500
Date: Wed, 2 Jan 2008 14:15:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Greg KH <gregkh@suse.de>, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 0/4] PM: Do not destroy/create devices while suspended
	(rev. 2)
Message-ID: <20080102131529.GA32160@elte.hu>
References: <200801020032.45529.rjw@sisk.pl> <20080102105217.GA14731@elte.hu> <200801021356.59865.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801021356.59865.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(David Brownell Cc:-ed too)

* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Well, we have the following test script in the userland suspend 
> package that is supposed to work right now:
> 
> #!/bin/bash
> date
> cd /sys/class/rtc/rtc0
> echo $(( $(cat since_epoch) + 20 )) > wakealarm
> s2ram
> date
> 
> provided that the new rtc driver code is compiled (and the old one is not).

ok, will try that. A stupid question. The old RTC driver is in 
drivers/char/rtc.c, and maps to:

  crw-r--r-- 1 root root  10, 135 Oct 25 18:02 /dev/rtc

the new driver is in drivers/rtc/*, and maps to:

  crw-r--r-- 1 root root 254,   0 Dec 12 02:30 /dev/rtc0

but all the x86 distro boxes i have access to make use of /dev/rtc. 
There's no symlink set up from /dev/rtc to /dev/rtc0 either. So it 
appears to me that the new RTC driver isnt actually utilized on most 
distributions.

shouldnt we provide a Kconfig way of replacing dev 10:135 with the new 
driver's 254:0 device? (while keeping all the current modes of operation 
as well, of course.) It's all supposed to be 100% ioctl ABI compatible 
with the old driver, right? That way distros could start migrating to it 
as well, without depending on any udev hackery.

> > That way any suspend breakage would be detectable (and bisectable) 
> > in automated testing - if the resume does not come back after 10-20 
> > seconds then the test failed.
> 
> Yes, but please note that some systems require user space 
> manipulations of the graphics adapter for suspend to work and to 
> detect a breakage of such a system you need to boot it into X and use 
> s2ram to suspend.

yeah, i wouldnt expect graphics mode to come back without quirks. But it 
should still work fine over the network, right? (which is my main mode 
of testing anyway)

	Ingo
