Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbYGTXTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbYGTXTn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 19:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbYGTXTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 19:19:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:42455 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbYGTXTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 19:19:31 -0400
Date: Sun, 20 Jul 2008 16:19:31 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Simon Arlott <simon@fire.lp0.eu>, Daniel Walker <dwalker@mvista.com>,
       Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 3/4] fastboot: make the raid autodetect code wait for
 all devices to init
Message-ID: <20080720161931.7dfde74f@infradead.org>
In-Reply-To: <18563.50428.659101.868745@notabene.brown>
References: <20080720151140.4aa7c682@infradead.org>
	<20080720151339.6f4a83d8@infradead.org>
	<18563.50428.659101.868745@notabene.brown>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008 09:06:36 +1000
Neil Brown <neilb@suse.de> wrote:

> > +		/*
> > +		 * Since we don't want to detect and use half a
> > raid array, we
> > +		 * need to wait for the known devices to complete
> > their probing
> > +		 */
> > +		while (driver_probe_done() != 0)
> > +			msleep(100);
> >  		int fd = sys_open("/dev/md0", 0, 0);
> >  		if (fd >= 0) {
> >  			sys_ioctl(fd, RAID_AUTORUN, raid_autopart);
> 
> I must say that I think this is pretty horrible.   But then it is a
> pretty horrible problem and I don't think there is a clean solution.

it's also the existing solution, just moved around to the only place
that needs it.

> 
> If md in a module, this code won't run so there will be no change.  If
> md is compiled in, this code will silently slow down boot even if
> there are no raid arrays to assemble. 

it's not slower than it is is today for *everyone*. All that this does
is move it to the MD code rather than having it 1 line before calling
the MD code (the removal of the global wait is in the next patch)
Waiting twice is the same cost as waiting once; the moment everything
is done it'll stay done.

> I think the "silently" is a
> problem.  I'm not looking forward to "my computer boots slower if I
> compile md into the kernel" reports on linux-raid@vger.

I *am* looking forward to "my computer boots faster" reports though ;-)

> 
> What would you think of
> 
>     if (driver_probe_done() != 0) {
> 	printk("md: Waiting for all devices to be available before
> autodetect\n" "md:  If you don't boot off raid, use
> raid=noautodetect\n"); do
>            msleep(100);
> 	while (driver_probe_done() != 0);
>     }

not sure we need the outer if for this (it'll basically always hit, and
even if by some miracle, everything is done, it's no big deal, you
tried to wait and were done immediately).
Adding a printk like this makes total sense to me; I'll add a patch for
that.

Maybe it's worth introducing a config option for the raid autodetect
thing; but I'll leave that up to you.


> Also, the "driver_probe_done() != 0" bothers me.

it's the existing form just moved; I wanted to make the change to be as
simple as possible.

> 
> The "real" solution here involves assembling arrays in userspace using
> "mdadm --incremental" from udevd, and using write-intent-bitmaps so
> that writing to an array before all the component devices are
> available can be done without requiring a full resync.  There is still
> a bit more code needed to make that work really smoothly.

if you use an initrd, the code above doesn't run...
totally different method of booting.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
