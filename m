Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbXDML5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbXDML5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 07:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbXDML5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 07:57:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46737 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413AbXDML5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 07:57:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Jiri Slaby" <jirislaby@gmail.com>, Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: 2.6.21-rc5: swsusp: Not enough free memory
Date: Fri, 13 Apr 2007 14:00:11 +0200
User-Agent: KMail/1.9.5
Cc: "Linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, pavel@suse.cz
References: <460B6E4B.3060004@gmail.com> <200704122336.57600.rjw@sisk.pl> <4af2d03a0704130314s78d0d831ja52fe8f92efe097a@mail.gmail.com>
In-Reply-To: <4af2d03a0704130314s78d0d831ja52fe8f92efe097a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704131400.12021.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 13 April 2007 12:14, Jiri Slaby wrote:
> On 4/12/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Wednesday, 11 April 2007 17:02, Jiri Slaby wrote:
> > > Rafael J. Wysocki napsal(a):
> > > > On Wednesday, 11 April 2007 12:45, Jiri Slaby wrote:
> > > >> Rafael J. Wysocki napsal(a):
> > > >>> On Wednesday, 11 April 2007 09:36, Jiri Slaby wrote:
> > > >>>> Rafael J. Wysocki napsal(a):
> > > >>>>> On Monday, 9 April 2007 22:07, Jiri Slaby wrote:
> > > >>>>>> I have bad news for you :(. I thought I had unpatched kernel, but it happens
> > > >>>>>> in -rc6 too.
> > > >>>>> I guess you mean you're still seeing the 'not enough memory to suspend'
> > > >>>>> problem?
> > > >>>> Yes:
> > > >>>> Disabling non-boot CPUs ...
> > > >>>> kvm: disabling virtualization on CPU1
> > > >>>> Breaking affinity for irq 9
> > > >>>> CPU 1 is now offline
> > > >>>> SMP alternatives: switching to UP code
> > > >>>> CPU1 is down
> > > >>>> swsusp: critical section:
> > > >>>> swsusp: Need to copy 158309 pages
> > > >>>> swsusp: Not enough free memory
> > > >>>> Error -12 suspending
> > > >>>> Enabling non-boot CPUs ...
> > > >>>> SMP alternatives: switching to SMP code
> > > >>>> Booting processor 1/2 APIC 0x1
> > > >>>> Initializing CPU#1
> > > >>> How reproducible is it?  I'm going to try to reproduce it on one of my boxes.
> > > >> My tip is one of three cases: after some work on fresh boot -- some
> > > >> consumers such as thunderbird, firefox, 10 or so terminals with
> > > >> gnome-session. Single xterm + gnome-session semms not to be a problem.
> > > >
> > > > Does the workaround with setting the image size below 1/2 of RAM work for you?
> > >
> > > Yes. Yesterday I must set the value to 350M -- 400M was not enough.
> >
> > Well, I can't reproduce it.
> >
> > Can you please try to reproduce it with the appended patch applied and send
> > the output of dmesg to me?
> >
> > Greetings,
> > Rafael
> >
> > ---
> >  kernel/power/snapshot.c |    4 ++--
> >  kernel/power/swsusp.c   |   16 ++++++++++++----
> >  2 files changed, 14 insertions(+), 6 deletions(-)
> 
> Shrinking memory...  Pages needed: 128103 normal, 0 highmem
> Pages needed: 125226 normal, 0 highmem
> Pages needed: -5757 normal, 0 highmem
> Pages needed: -5757 normal, 0 highmem
> Pages needed: -5757 normal, 0 highmem
> Pages needed: -5757
> Pages needed: 127953 normal, 0 highmem
> Pages needed: 125076 normal, 0 highmem
> Pages needed: -6043 normal, 0 highmem
> Pages needed: -6043 normal, 0 highmem
> Pages needed: -6043 normal, 0 highmem
> Pages needed: -6043
> done (200 pages freed)
> Freed 800 kbytes in 0.16 seconds (5.00 MB/s)
> Suspending console(s)
> ...
> CPU1 is down
> swsusp: critical section:
> swsusp: Need to copy 131358 pages
> swsusp: Normal pages needed: 131358
> swsusp: Normal pages needed: 131358 + 1024 + 22, available pages: 130607

Well, it looks like someone allocated about 6000 pages after we had freed
enough memory for suspending.

I suspect one of the device drivers plays some dirty tricks in its .suspend()
routine.  Now the question is which one.

I wonder if setting PAGES_FOR_IO in include/linux/suspend.h to eg. 8192 will
help.

> swsusp: Not enough free memory
> Error -12 suspending
> Enabling non-boot CPUs ...
> SMP alternatives: switching to SMP code
> Booting processor 1/2 APIC 0x1
> Not responding.
> Inquiring remote APIC #1...
> ... APIC #1 ID: failed
> ... APIC #1 VERSION: failed
> ... APIC #1 SPIV: failed
> kvm: disabling virtualization on CPU1
> Error taking CPU1 up: -5
> PCI: Setting latency timer of device 0000:00:01.0 to 64
> 
> Please note the CPU#1 bring up problem too.

Yes, and this seems to be related to the APIC.

Gautham, can you please tell me who's the right person to ask about it?

Rafael
