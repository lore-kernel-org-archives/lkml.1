Return-Path: <linux-kernel-owner+w=401wt.eu-S1755397AbYDPWoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbYDPWoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 18:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbYDPWob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 18:44:31 -0400
Received: from dell.benran.ru ([83.149.196.126]:40335 "EHLO ari.home"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751921AbYDPWob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 18:44:31 -0400
Date: Thu, 17 Apr 2008 02:44:33 +0400 (MSD)
From: "Lev A. Melnikovsky" <melnikovsky@mail.ru>
To: David Brownell <david-b@pacbell.net>
cc: Rene Herman <rene.herman@keyaccess.nl>,
       Alessandro Suardi <alessandro.suardi@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ehci-hcd affects hda speed
In-Reply-To: <200804151617.23012.david-b@pacbell.net>
Message-ID: <alpine.LFD.1.10.0804170224590.8464@nev.ubzr>
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr> <47E1B062.4060709@keyaccess.nl> <alpine.LFD.1.10.0804152220560.6429@nev.ubzr> <200804151617.23012.david-b@pacbell.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  On Wed, 16 Apr 2008 at 3:17am, David Brownell wrote:

DB> Which you *know* is aggravating the problem.  What numbers
DB> do you observe with a generic 2.6.25-rc9 kernel?  (That is,
DB> without that abusive 1 usec setting ... that kernel includes
DB> the patch switching to a more customary 10 usec value.)
~29.5 MB/s with ehci_hcd unloaded,
~26.0 MB/s with ehci_hcd loaded + USB hub is connected

The machine is mostly idle.

LM> #0. Nothing is connected to USB, no ehci-hcd loaded
LM>       hda throughput 28+-1MB/s
LM> #1. ehci-hcd loaded, still no USB peripherals
LM>       hda throughput 28+-1 MB/s
LM> #2. Something (USB hub and FLASH drive tested) is attached
LM>       hda throughput 15+-1 MB/s
LM> #3. All USB peripherals are removed
LM>       hda throughput 15+-1 MB/s
LM> #4. ehci-hcd is rmmod'ed
LM>       hda throughput 28+-1MB/s
DB> > The oddest peculiarity for me is the hysteretic difference between #1 and 
DB> > #3 states. I mean experimental data (hda throughput) depends not on the 
DB> > state (hardware/loaded modules), but on the path we followed.
DB> > 
DB> > Interestingly enough, sampling registers (via /sys) often shows Async bit 
DB> > set of the status register in the state #3. It is always cleared in #1.
DB> 
DB> With 2.6.25-rc9's default setting for async sleep time?
Yes. Async bit is oscillating and the frequency I see it set is much lower 
than that with 1us sleep time, but it is possible to catch the bit set 
high anyway. Here's one sample:

$ cat /sys/class/usb_host/usb_host4/registers 

bus pci, device 0000:00:09.2 (driver 10 Dec 2004)
EHCI Host Controller
EHCI 1.00, hcd state 1
ownership 00000001
SMI sts/enable 0xc0080000
structural params 0x00002204
capability params 0x00006872
status a008 Async Recl FLR
command 010009 (park)=0 ithresh=1 period=256 RUN
intrenable 37 IAA FATAL PCD ERR INT
uframe 28e0
port 1 status 001000 POWER sig=se0
port 2 status 001000 POWER sig=se0
port 3 status 001000 POWER sig=se0
port 4 status 001000 POWER sig=se0
irq normal 18 err 0 reclaim 4 (lost 0)
complete 18 unlink 1

DB> Means "none at all".  So if the "Async" status bit is set
DB> while the "Async" command is clear, it means the hardware
DB> is clearly misbehaving.  That status bit is supposed to
DB> turn itself off after the command bit is cleared ... within
DB> a couple milliseconds.
Yes, I understand that, but... I am not going to defend VIA, the chip does 
misbehave. I just wonder what is the difference between the states #1 and 
#3? Command register is the same, hardware is the same. If we know the 
difference, can we benefit from our understanding?

Namely: is it possible that an (empty) schedule is different?

DB> One hopes that when http://linux.via.com.tw finally appears,
OK, two hope :-)

-L
