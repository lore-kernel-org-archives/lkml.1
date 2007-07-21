Return-Path: <linux-kernel-owner+w=401wt.eu-S938577AbXGUAdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938577AbXGUAdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 20:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759016AbXGUAdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 20:33:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:50350 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbXGUAdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 20:33:18 -0400
Subject: Re: [git patches] two warning fixes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ak@suse.de, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net
In-Reply-To: <m3644e2abd.fsf@maximus.localdomain>
References: <20070718235504.GA9601@havoc.gtf.org>
	 <alpine.LFD.0.999.0707181834070.27353@woody.linux-foundation.org>
	 <469ECD29.2010909@garzik.org> <m3r6n4bjgg.fsf@maximus.localdomain>
	 <alpine.LFD.0.999.0707191100480.27353@woody.linux-foundation.org>
	 <m3644e2abd.fsf@maximus.localdomain>
Content-Type: text/plain
Date: Sat, 21 Jul 2007 10:32:53 +1000
Message-Id: <1184977973.5439.45.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-20 at 20:34 +0200, Krzysztof Halasa wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> > More people *should* generally ask themselves: "was the warning worth it?" 
> > and then, if the answer is "no", they shouldn't add code, they should 
> > remove the thing that causes the warning in the first place.
> 
> Sure. If a routine uses must_check yet its return value may be
> safely ignored then that must_check is simply misplaced and should
> be removed. It does not mean all must_checks are bad - each of them
> isn't bad unless one can demonstrate it is.
> 
> Back to sysfs_create_bin_file() - if one can demonstrate a caller
> can safely ignore the return value (which, it seems, is the
> case), then exactly this very must_check should be removed

Typically, the EDID creation in radeonfb :-)

In fact, I'm not even sure there's -any- user of those sysfs files. I
added them back then to allow distros to extract the EDID infos that
were probed by radeonfb to properly configure the X server (because on
some machines, the EDID is coming from the firmware/BIOS, not from DDC,
and X can't get at it). I don't know if they ever used them.

In any case, it doesn't make sense to abort initialization of the driver
if for some reasons those files can't be created (for example, the core
fbdev starts exposing EDID files, radeonfb isn't properly updated, name
clash, error). Aborting the initialization will make sure that on some
machines such as powermacs with radeon, whatever error is displayed will
never be seen by the user.

That's a typical, but I have plenty more.

For example, the powermac thermal control drivers. They work pretty well
by themselves. They also expose via sysfs all the current values, fan
speeds, temps ,etc... for the sake of whoever wants to do a GUI or
"monitor" what's going on, but that is not critical to the operation of
the driver. Thus, failure to create those files is not critical.

I have plenty other examples.

Thus, we have two choices here:

 - The simple one: sysfs_create_blah() displays a warning when it fails
and has no must_check

 - The one that adds code everywhere (the current one):
sysfs_create_blah() returns an error, has much_check, and thus all
callers like I described abvoe need to add code to test it and print a
warning. Lots of added .text and .data for little benefit.

Cheers,
Ben.


