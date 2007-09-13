Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbXIMOsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbXIMOsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 10:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbXIMOse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 10:48:34 -0400
Received: from smtp.seznam.cz ([77.75.72.43]:35534 "HELO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750875AbXIMOsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 10:48:33 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Sep 2007 10:48:32 EDT
From: "Frantisek Rysanek" <Frantisek.Rysanek@post.cz>
To: linux-kernel@vger.kernel.org
Date: Thu, 13 Sep 2007 16:46:09 +0200
MIME-Version: 1.0
Subject: [newbie:] Bonnie++2 hangs recent 2.6 kernels? Bash keeps looping in waitpid(), eating 100% CPU
Message-ID: <46E96951.10344.29AE6546@localhost>
X-mailer: Pegasus Mail for Windows (4.21c)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Smtpd: 1.0.12@11920:11921
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear everyone,

apologies in advance for a silly question...

I'm using a homebrew stripped-down mini-distro based on Fedora 5, 
with various newer kernels, on a live CD, to test hardware with. 
The live CD is composed by means of scripted binary copy of the key 
necessary components (libc, init, bash, /dev/, /etc/, you know the 
rest...) - it's almost like rolling your own MS-DOS boot floppy.
A minimum system is about 4-10 MB, a neat firewall takes up
about 22 MB.

Recently I've stubled over what seems like a lasting bug
in the Linux kernel. Excuse me for that accusation, which is 
admittedly based on rather vague data, dated versions
of the user-space software (libc, bash...), and a homebrew
hackey distro.

First impression:
looped execution of Bonnie++2 makes bash go berserk.
There are two possible flawed behaviors:

1) the bash process that's waiting for Bonnie++2 to return, 
   starts looping inside the last waitpid() call I believe, 
   eating 100% CPU.
   At least that's what 'top' + 'strace -p <bash PID>' would 
   suggest. The top and strace have to be running beforehand,
   as the same happens to the bash process on any other virtual
   console, if you try to run any further command. (The further 
   command doesn't seem to get executed anymore.)

2) the bash processes don't start eating 100% CPU, but any further 
   command that you try to execute returns immediately with
   a segfault.

I boot the CD with just bare bash on all 6 virtual consoles.
I mount a previously created EXT3 FS (several hundred GB
to over 1 TB) on a mountpoint, `cd` into the mountpoint
on one or two consoles, and run 

 while true; do bonnie++2 -u root -s 4096; done

Then I run 'iostat 2', 'top' and 'strace -p <bash PID>' on the 
remaining consoles. I try running some other command now and then, to 
make the paging and block IO subsystems load some more blocks from 
the CD.

I believe the `top` output suggests that the Bonnie processes don't 
eat all that much RAM, but the kernel-space buffering eats almost all 
of it. Only about 50 Megs remain truly "free", most of the RAM gets 
"cached". The system stabilizes at this balance, and a few minutes 
later it hangs in the aforementioned way.

This happens without a swap. If I mkswap+swapon some free hard drive, 
the symptoms seem somewhat more difficult to reproduce, but do occur 
after a somewhat longer period of time.

The symptoms are fairly easily reproduced on 2.6.16.18 through 
2.6.16.48, as well as 2.6.18.8. On 2.6.22.6 it seems to take a bit 
more time to reproduce the problem.

I've reproduced the problem on three different dual Xeon
boxes, all of them SuperMicro of different sizes/generations,
all of them upgraded to the latest BIOS (now showing no more
IRQ routing mischiefs).
The hardware setups are along the lines of 
- Intel 7501 chipset, dual Xeon Northwood, 1 GB RAM,
   Adaptec 79xx HBA, external RAID (~80 MBps),
   internal Adaptec 2120 RAID (~50 MBps)
- Intel 7520 chipset, dual Xeon Irwindale, 2 GB RAM,
   several internal U320 SCSI drives via Adaptec 79xx HBA,
   an external RAID (~80 MBps) via LSI 20320 HBA (Fusion MPT)
- Intel 7520 chipset, dual Xeon Nocona, 1 GB RAM,
   internal LSI MegaRAID SATA150-6 with 6 disk drives.

I've never seen this before I started using bonnie++2 as a load 
generator :-) Both my hardware systems and my Linux CD are otherwise 
perfectly stable, under sequential IO, cpuburn, older versions of 
Bonnie on Linux 2.4 / FreeBSD etc. 
I know what it looks like when there's a hardware problem and I know 
how to prove/deny a hardware problem by selective A/B-style hardware 
replacements, I'm fairly good at shielding away hardware unstability.

Should I start from compiling a fresh libc + bash + whatever else?
Any ideas are welcome :-)

Frank Rysanek

