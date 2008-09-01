Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbYIAUp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbYIAUp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 16:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbYIAUpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 16:45:19 -0400
Received: from www.tglx.de ([62.245.132.106]:54668 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbYIAUpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 16:45:18 -0400
Date: Mon, 1 Sep 2008 22:45:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
In-Reply-To: <48BC4F3A.9020608@lwfinger.net>
Message-ID: <alpine.LFD.1.10.0809012226080.3243@apollo.tec.linutronix.de>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <48BC444D.5030601@lwfinger.net>
 <alpine.LFD.1.10.0809012208010.3243@apollo.tec.linutronix.de> <48BC4F3A.9020608@lwfinger.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008, Larry Finger wrote:
> Thomas Gleixner wrote:
> > On Mon, 1 Sep 2008, Larry Finger wrote:
> > > The timed sleep is as accurate as I can measure.
> > > 
> > > I put in some test prints. The value of pm2 is zero when the else branch
> > > of
> > > the "if (hpet)" is entered; however, pm1 is 15768471. When we reach the
> > > do_div(tsc2, tsc1) statement, tsc2 is zero, which I think means that the
> > > two
> > > calls to tsc_read_refs() are returning the same junk value.
> > 
> > Ok, so the pmtimer is probably detected later as unusable and disabled.
> > Please check your logs for: "PM-Timer had inconsistent results:"
> 
> Booting 2.6.26, the dmesg output has a line that says:
> 
> PM-Timer running at invalid rate: 200% of normal - aborting.
> 
> Amazing that it should be exactly 200%. Why is the CPU running at half speed
> when the PM-Timer rate is measured?

The kernel assumes that the PM timer frequency is normal, so it does:

    read pm-timer start value, read TSC start value
    wait for a some time
    read pm-timer end value, read TSC end value

And the TSC frequency is calculated via:

                  TSC-End - TSC-Start
TSC-Frequency =  -------------------- * PM-Frequency
                   PM-End - PM-Start

So if your PM-Timer runs at the double frequency for reasons only
known to the Chip Manufacturer the kernel miscalculates the TSC
frequency by factor 0.5.

Simple rule of three.

Thanks,

	tglx
