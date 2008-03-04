Return-Path: <linux-kernel-owner+w=401wt.eu-S1762736AbYCDPNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762736AbYCDPNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 10:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757395AbYCDPN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 10:13:26 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:30703 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756251AbYCDPNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 10:13:25 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mark McLoughlin <markmc@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080304143324.GA2713@elte.hu>
References: <47C22568.1010405@zytor.com>
	 <1203958478.20033.1239002461@webmail.messagingengine.com>
	 <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com>
	 <20080228131341.GA25213@mailshack.com>
	 <20080228132822.GA25278@mailshack.com>
	 <1204233131.28798.12.camel@cthulhu.hellion.org.uk>
	 <47C72432.3010606@zytor.com>
	 <1204240609.28798.33.camel@cthulhu.hellion.org.uk>
	 <1204630906.16613.4.camel@muff>  <20080304143324.GA2713@elte.hu>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 15:12:57 +0000
Message-Id: <1204643577.3483.121.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.46.209.99
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [RFC] use realmode code to reserve end-of-conventional-memory
	to 1MB
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-03-04 at 15:33 +0100, Ingo Molnar wrote:
> * Mark McLoughlin <markmc@redhat.com> wrote:
> 
> > > The patch below seems like the right thing to do. It certainly boots 
> > > in a domU without the DMI problem (without any of the other related 
> > > patches such as Alexander's).
> > 
> > Yep, this patch on its own fixes 2.6.25-rc3 DomU boot for me here.
> 
> thanks - i picked it up for v2.6.25 merging.

Thanks, I'd been planning to resend once I got the ddcprobe thing sorted
but I've been a bit snowed under (deadlines :-|). This patch is
independently correct though and turns the ddcprobe failure from a domU
kernel crash into a userspace hang.

ddcprobe hangs because the page at pfn 0 is comprised entirely 0xc2
bytes (the Xen memory scrub poison value -- I'm running a debug
hypervisor) which causes lrmi to try and jump to 0xc2c2*16+0xc2c2 to
implement int $0xXX. gdb won't let me actually examine that address for
some reason so I don't actually know what it's hitting to cause the
loop/hang but no good can come of jumping to that address in any case...

Sanest solution seems to me to be to explicitly zero PFN 0 -- I have a
patch I just haven't had a chance to clean it up for submission yet.

> i'm wondering, what triggered this bug, and why didnt we have these 
> problems in the past?

Did someone make the boot allocator start at the bottom instead of the
top of memory or something?

Ian.

-- 
Ian Campbell
Current Noise: Nile - Even The Gods Must Die

There is a natural hootchy-kootchy to a goldfish.
		-- Walt Disney

