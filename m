Return-Path: <linux-kernel-owner+w=401wt.eu-S1757319AbZBWWMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbZBWWMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 17:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZBWWMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 17:12:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42019 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444AbZBWWMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 17:12:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during suspend-resume
Date: Mon, 23 Feb 2009 23:11:34 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200902221837.49396.rjw@sisk.pl> <20090223171630.GA28651@elte.hu> <alpine.LFD.2.00.0902230926030.3111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902230926030.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902232311.36133.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 February 2009, Linus Torvalds wrote:
> 
> On Mon, 23 Feb 2009, Ingo Molnar wrote:
> > 
> > Linus, do you have a strong opinion about which variant we 
> > should use?
> 
> Strong? No. I think mine is better just because _if_ another CPU is busy 
> handling an interrupt that we're just now disabling, we'll just go on to 
> the next interrupt. Waiting for them all at the end is always more 
> efficient.
> 
> But does it really matter? No. In this case I think we've shut down all 
> other CPU's anyway, so the whole "serialize_irq()" should probably not 
> even be needed. 

But we're going to move the shutting down of the other CPUs after this point.

Finally, the sequence is going to be:
- "normal" suspend of devices
- disable device interrupts
- "late" suspend of devices
- _PTS
- disable nonboot CPUs
- local_irq_disable
- sysdev_suspend
[This is because ACPI wants us to put devices into low power states before
doing the _PTS, which in turn is supposed to be done before the disabling of
nonboot CPUs, and we want to put devices into low power states during "late"
suspend.  Of course, analogously for the resume part.]

So, I think your version is _really_ better. :-)

Thanks,
Rafael
