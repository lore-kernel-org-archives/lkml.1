Return-Path: <linux-kernel-owner+w=401wt.eu-S1758696AbYDMQTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696AbYDMQTT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 12:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbYDMQTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 12:19:11 -0400
Received: from nn7.de ([85.214.94.156]:41201 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371AbYDMQTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 12:19:10 -0400
Subject: Re: 2.6.25-rc6 regression - hang on resume
From: Soeren Sonnenburg <kernel@nn7.de>
To: "Rafael J\. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200804131553.15573.rjw@sisk.pl>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
	 <1207985262.4372.3.camel@localhost> <20080413085343.GD8949@elf.ucw.cz>
	 <200804131553.15573.rjw@sisk.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 13 Apr 2008 16:18:59 +0000
Message-Id: <1208103539.4839.92.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-04-13 at 15:53 +0200, Rafael J. Wysocki wrote:
> On Sunday, 13 of April 2008, Pavel Machek wrote:
> > On Sat 2008-04-12 09:27:42, Soeren Sonnenburg wrote:
> > > On Fri, 2008-04-11 at 23:04 +0200, Pavel Machek wrote:
> > > > On Fri 2008-04-04 08:31:29, Soeren Sonnenburg wrote:
> > > > > On Fri, 2008-04-04 at 01:22 +0200, Rafael J. Wysocki wrote:
> > > > > > The following report is on the current list of known regressions
> > > > > > from 2.6.24.  Please verify if the issue is still present in the
> > > > > > mainline.
> > > > > > 
> > > > > > 
> > > > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10319
> > > > > > Subject		: 2.6.25-rc6 regression - hang on resume
> > > > > > Submitter	: Soeren Sonnenburg <kernel@nn7.de>
> > > > > > Date		: 2008-03-25 04:44 (10 days old)
> > > > > 
> > > > > Yes. The machine resumes and display stays black using s2ram -f -p
> > > > > (blindly typing reboot etc on keyboard does what is expected). However
> > > > > display comes back on 2.6.24.
> > > > 
> > > > Could you get us any debugging output from s2ram? Or maybe even strace
> > > > it in both working and broken case, and comparing them? (You may want
> > > > to disable randomization so that results are comparable).
> > > 
> > > I did on 2.6.24
> > > 
> > > strace -ff s2ram >s2ram24.trace 2>&1
> > > 
> > > and .25
> > > 
> > > ???strace -ff s2ram >s2ram25.trace 2>&1
> > > 
> > > with the .24 bringing the display back and .25 not. Files are here
> > > 
> > > http://nn7.de/debugging/s2ram24.trace.bz2
> > > ???http://nn7.de/debugging/s2ram25.trace.bz2
> > 
> > Hmm: 
> > 
> > /sys/bus/pci/devices/0000:00:1b.0/irq
> > 
> > contains 21 in one case and 22 in another... as do other
> > interrupts. Is that expected? Can you post /proc/interrupts for both
> > versions?
> > 
> > Hmm, big part of trace is:
> > 
> > vm86old(0xb7f76c8c)                     = -1 ENOSYS (Function not
> > implemented)
> > vm86old(0xb7f76c8c)                     = -1 ENOSYS (Function not
> > implemented)
> > 
> > ...I wonder why we do it so many times?
> > 
> > And here's the difference. .25 says:
> > 
> > vm86old(0xb809ac8c)                     = -1 ENOSYS (Function not
> > implemented)
> > vm86old(0xb809ac8c)                     = -1 ENOSYS (Function not
> > implemented)
> > Error: something went wrong performing real mode call
> > open("/sys/class/graphics",
> > O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|0x80000) = -1 ENOENT (No
> > such file or directory)
> > open("/dev/tty", O_RDWR|O_LARGEFILE)    = 6
> > ioctl(6, KDGKBTYPE, 0xbfae8887)         = 0
> > 
> > ...can you perhaps add printf-s to s2ram to find out what changed?
> 
> Well, that looks suspiciously similar to
> http://bugzilla.kernel.org/show_bug.cgi?id=10155 .

Hmmhh the only difference is that I don't have a core 2 duo but only a
core 1 duo but hmmmhh the flag down there looks like it does nx, or
should I see something like nx enabled in dmesg?

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 14
model name	: Genuine Intel(R) CPU            1600  @ 2.16GHz
stepping	: 8
cpu MHz		: 1000.000
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc bts
pni monitor vmx est tm2 xtpr
bogomips	: 4333.82
clflush size	: 64


Anyway I will try noexec=off ...

Soeren
