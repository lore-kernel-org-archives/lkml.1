Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbYDMVcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbYDMVcm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 17:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYDMVcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 17:32:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:58629 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbYDMVcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 17:32:33 -0400
Date: Sun, 13 Apr 2008 23:33:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc6 regression - hang on resume
Message-ID: <20080413213310.GB29396@elf.ucw.cz>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <pdYe6zNQVl.A.fp.nEW9HB@albercik> <1207290689.4511.1.camel@localhost> <20080411210400.GA1533@elf.ucw.cz> <1207985262.4372.3.camel@localhost> <20080413085343.GD8949@elf.ucw.cz> <1208088344.4839.60.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208088344.4839.60.camel@localhost>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > /sys/bus/pci/devices/0000:00:1b.0/irq
> > 
> > contains 21 in one case and 22 in another... as do other
> > interrupts. Is that expected? Can you post /proc/interrupts for both
> > versions?
> 
> It might be that configs are slightly different - if you think this
> gives a clue I will post them, but your discovery below looks
> promising:

Yep... any chance to do git bisect to see where it broke?

> > Error: something went wrong performing real mode call
> > open("/sys/class/graphics",
> > O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|0x80000) = -1 ENOENT (No
> > such file or directory)
> > open("/dev/tty", O_RDWR|O_LARGEFILE)    = 6
> > ioctl(6, KDGKBTYPE, 0xbfae8887)         = 0
> > 
> > ...can you perhaps add printf-s to s2ram to find out what changed?
> 
> OK, I searched for ???"something went wrong performing real mode call" in
> the s2ram source and found this function:
> 
> int do_real_post(unsigned pci_device)
> {
>     int error = 0;
>     struct LRMI_regs r;
>     memset(&r, 0, sizeof(r));
> 
>     /* Several machines seem to want the device that they're POSTing in
>        here */
>     r.eax = pci_device;
> 
>     /* 0xc000 is the video option ROM.  The init code for each
>        option ROM is at 0x0003 - so jump to c000:0003 and start running
> */
>     r.cs = 0xc000;
>     r.ip = 0x0003;
> 
>     /* This is all heavily cargo culted but seems to work */
>     r.edx = 0x80;
>     r.ds = 0x0040;
> 
>     if (!LRMI_call(&r)) {
>         fprintf(stderr,
>             "Error: something went wrong performing real mode call\n");
>         error = 1;

Sweet, so the problem is inside X86EMU_exec(), right? ...and that's
bytecode interpretter. You could add printfs() all over it, to see
where the execution differs.

> so either the graphics adapter is somehow not ready yet or a wrong
> address is used for posting?

Or something goes wrong in the interpretter...

> Do you already now have an idea? Or which things should I print out?

It starts to look like git bisect is the easier way to get some
results...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
