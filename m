Return-Path: <linux-kernel-owner+w=401wt.eu-S1759053AbYDMMGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759053AbYDMMGN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 08:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758931AbYDMMFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 08:05:53 -0400
Received: from nn7.de ([85.214.94.156]:34686 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758904AbYDMMFv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 08:05:51 -0400
Subject: Re: 2.6.25-rc6 regression - hang on resume
From: Soeren Sonnenburg <kernel@nn7.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J\. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080413085343.GD8949@elf.ucw.cz>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
	 <pdYe6zNQVl.A.fp.nEW9HB@albercik> <1207290689.4511.1.camel@localhost>
	 <20080411210400.GA1533@elf.ucw.cz> <1207985262.4372.3.camel@localhost>
	 <20080413085343.GD8949@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Date: Sun, 13 Apr 2008 12:05:44 +0000
Message-Id: <1208088344.4839.60.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-04-13 at 10:53 +0200, Pavel Machek wrote:
> On Sat 2008-04-12 09:27:42, Soeren Sonnenburg wrote:
> > On Fri, 2008-04-11 at 23:04 +0200, Pavel Machek wrote:
> > > On Fri 2008-04-04 08:31:29, Soeren Sonnenburg wrote:
> > > > On Fri, 2008-04-04 at 01:22 +0200, Rafael J. Wysocki wrote:
> > > > > The following report is on the current list of known regressions
> > > > > from 2.6.24.  Please verify if the issue is still present in the
> > > > > mainline.
> > > > > 
> > > > > 
> > > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10319
> > > > > Subject		: 2.6.25-rc6 regression - hang on resume
> > > > > Submitter	: Soeren Sonnenburg <kernel@nn7.de>
> > > > > Date		: 2008-03-25 04:44 (10 days old)
> > > > 
> > > > Yes. The machine resumes and display stays black using s2ram -f -p
> > > > (blindly typing reboot etc on keyboard does what is expected). However
> > > > display comes back on 2.6.24.
> > > 
> > > Could you get us any debugging output from s2ram? Or maybe even strace
> > > it in both working and broken case, and comparing them? (You may want
> > > to disable randomization so that results are comparable).
> > 
> > I did on 2.6.24
> > 
> > strace -ff s2ram >s2ram24.trace 2>&1
> > 
> > and .25
> > 
> > ???strace -ff s2ram >s2ram25.trace 2>&1
> > 
> > with the .24 bringing the display back and .25 not. Files are here
> > 
> > http://nn7.de/debugging/s2ram24.trace.bz2
> > ???http://nn7.de/debugging/s2ram25.trace.bz2
> 
> Hmm: 
> 
> /sys/bus/pci/devices/0000:00:1b.0/irq
> 
> contains 21 in one case and 22 in another... as do other
> interrupts. Is that expected? Can you post /proc/interrupts for both
> versions?

It might be that configs are slightly different - if you think this
gives a clue I will post them, but your discovery below looks promising:

> Hmm, big part of trace is:
> 
> vm86old(0xb7f76c8c)                     = -1 ENOSYS (Function not
> implemented)
> vm86old(0xb7f76c8c)                     = -1 ENOSYS (Function not
> implemented)
> 
> ...I wonder why we do it so many times?
> 
> And here's the difference. .25 says:
> 
> vm86old(0xb809ac8c)                     = -1 ENOSYS (Function not
> implemented)
> vm86old(0xb809ac8c)                     = -1 ENOSYS (Function not
> implemented)
> Error: something went wrong performing real mode call
> open("/sys/class/graphics",
> O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|0x80000) = -1 ENOENT (No
> such file or directory)
> open("/dev/tty", O_RDWR|O_LARGEFILE)    = 6
> ioctl(6, KDGKBTYPE, 0xbfae8887)         = 0
> 
> ...can you perhaps add printf-s to s2ram to find out what changed?

OK, I searched for ﻿"something went wrong performing real mode call" in
the s2ram source and found this function:

int do_real_post(unsigned pci_device)
{
    int error = 0;
    struct LRMI_regs r;
    memset(&r, 0, sizeof(r));

    /* Several machines seem to want the device that they're POSTing in
       here */
    r.eax = pci_device;

    /* 0xc000 is the video option ROM.  The init code for each
       option ROM is at 0x0003 - so jump to c000:0003 and start running
*/
    r.cs = 0xc000;
    r.ip = 0x0003;

    /* This is all heavily cargo culted but seems to work */
    r.edx = 0x80;
    r.ds = 0x0040;

    if (!LRMI_call(&r)) {
        fprintf(stderr,
            "Error: something went wrong performing real mode call\n");
        error = 1;
    }

    return error;
}

which is obviously called from

int do_post(void)
{
    struct pci_dev *p;
    unsigned int c;
    unsigned int pci_id;
    int error;

    pci_scan_bus(pacc);

    for (p = pacc->devices; p; p = p->next) {
        c = pci_read_word(p, PCI_CLASS_DEVICE);
        if (c == 0x300) {
            pci_id =
                (p->bus << 8) + (p->dev << 3) +
                (p->func & 0x7);
            error = do_real_post(pci_id);
            if (error != 0) {
                return error;
            }
        }
    }
    return 0;
}

so either the graphics adapter is somehow not ready yet or a wrong
address is used for posting?

Do you already now have an idea? Or which things should I print out?

Soeren
