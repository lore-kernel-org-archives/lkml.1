Return-Path: <linux-kernel-owner+w=401wt.eu-S1762865AbXIMQMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762865AbXIMQMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 12:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757767AbXIMQMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 12:12:38 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:44669 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754950AbXIMQMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 12:12:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gNzhHF8kjgf3aDk0aoM+7SBMorpOa37X6+PNUIckFrrlQqd1OR4VoHkCJ8/bKMXW3J3PYOUwGiOjOFnzRC9lV/6xrP1HMr6cRVaFyBFjoy9r50EjkhOvspDgWBpW/nDU8f6vz7YijhmhSbINYkC+oUDwUhJOtVCprnsDeq2DwEw=  ;
X-YMail-OSG: iWyPcZgVM1m_TQCOtgg0.3FvqD39QcqRGMu9SzTlEftqWlPb8aPnaQkJz8_SQg7tE7UCUZr1Zg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Frantisek Rysanek" <Frantisek.Rysanek@post.cz>
Subject: Re: [newbie:] Bonnie++2 hangs recent 2.6 kernels? Bash keeps looping in waitpid(), eating 100% CPU
Date: Thu, 13 Sep 2007 10:30:55 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <46E96951.10344.29AE6546@localhost>
In-Reply-To: <46E96951.10344.29AE6546@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709131030.55247.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 September 2007 00:46, Frantisek Rysanek wrote:
> Dear everyone,
>
> apologies in advance for a silly question...
>
> I'm using a homebrew stripped-down mini-distro based on Fedora 5,
> with various newer kernels, on a live CD, to test hardware with.
> The live CD is composed by means of scripted binary copy of the key
> necessary components (libc, init, bash, /dev/, /etc/, you know the
> rest...) - it's almost like rolling your own MS-DOS boot floppy.
> A minimum system is about 4-10 MB, a neat firewall takes up
> about 22 MB.
>
> Recently I've stubled over what seems like a lasting bug
> in the Linux kernel. Excuse me for that accusation, which is
> admittedly based on rather vague data, dated versions
> of the user-space software (libc, bash...), and a homebrew
> hackey distro.
>
> First impression:
> looped execution of Bonnie++2 makes bash go berserk.
> There are two possible flawed behaviors:
>
> 1) the bash process that's waiting for Bonnie++2 to return,
>    starts looping inside the last waitpid() call I believe,
>    eating 100% CPU.
>    At least that's what 'top' + 'strace -p <bash PID>' would
>    suggest. The top and strace have to be running beforehand,
>    as the same happens to the bash process on any other virtual
>    console, if you try to run any further command. (The further
>    command doesn't seem to get executed anymore.)
>
> 2) the bash processes don't start eating 100% CPU, but any further
>    command that you try to execute returns immediately with
>    a segfault.
>
> I boot the CD with just bare bash on all 6 virtual consoles.
> I mount a previously created EXT3 FS (several hundred GB
> to over 1 TB) on a mountpoint, `cd` into the mountpoint
> on one or two consoles, and run
>
>  while true; do bonnie++2 -u root -s 4096; done
>
> Then I run 'iostat 2', 'top' and 'strace -p <bash PID>' on the
> remaining consoles. I try running some other command now and then, to
> make the paging and block IO subsystems load some more blocks from
> the CD.
>
> I believe the `top` output suggests that the Bonnie processes don't
> eat all that much RAM, but the kernel-space buffering eats almost all
> of it. Only about 50 Megs remain truly "free", most of the RAM gets
> "cached". The system stabilizes at this balance, and a few minutes
> later it hangs in the aforementioned way.
>
> This happens without a swap. If I mkswap+swapon some free hard drive,
> the symptoms seem somewhat more difficult to reproduce, but do occur
> after a somewhat longer period of time.
>
> The symptoms are fairly easily reproduced on 2.6.16.18 through
> 2.6.16.48, as well as 2.6.18.8. On 2.6.22.6 it seems to take a bit
> more time to reproduce the problem.
>
> I've reproduced the problem on three different dual Xeon
> boxes, all of them SuperMicro of different sizes/generations,
> all of them upgraded to the latest BIOS (now showing no more
> IRQ routing mischiefs).
> The hardware setups are along the lines of
> - Intel 7501 chipset, dual Xeon Northwood, 1 GB RAM,
>    Adaptec 79xx HBA, external RAID (~80 MBps),
>    internal Adaptec 2120 RAID (~50 MBps)
> - Intel 7520 chipset, dual Xeon Irwindale, 2 GB RAM,
>    several internal U320 SCSI drives via Adaptec 79xx HBA,
>    an external RAID (~80 MBps) via LSI 20320 HBA (Fusion MPT)
> - Intel 7520 chipset, dual Xeon Nocona, 1 GB RAM,
>    internal LSI MegaRAID SATA150-6 with 6 disk drives.
>
> I've never seen this before I started using bonnie++2 as a load
> generator :-) Both my hardware systems and my Linux CD are otherwise
> perfectly stable, under sequential IO, cpuburn, older versions of
> Bonnie on Linux 2.4 / FreeBSD etc.
> I know what it looks like when there's a hardware problem and I know
> how to prove/deny a hardware problem by selective A/B-style hardware
> replacements, I'm fairly good at shielding away hardware unstability.
>
> Should I start from compiling a fresh libc + bash + whatever else?
> Any ideas are welcome :-)

Can you see if it is looping in userspace or kernel? Can you kill -9
the process?

Are you able to test with the latest 2.6.23-rc kernel? If not (or if it
still has the same problem), then can you get the output of sysrq+T
and three sysrq+P calls, please? (this might help work out where in
kernel it is spinning).
