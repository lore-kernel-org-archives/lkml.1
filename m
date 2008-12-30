Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbYL3VNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbYL3VNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 16:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbYL3VNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 16:13:21 -0500
Received: from relay3.sgi.com ([192.48.171.31]:52655 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752135AbYL3VNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 16:13:20 -0500
Date: Tue, 30 Dec 2008 15:13:10 -0600
From: Russ Anderson <rja@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       rja@sgi.com
Subject: Re: x86/mce merge, integration hickup + crash, design thoughts
Message-ID: <20081230211310.GA19653@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20081227155019.GA15493@elte.hu> <20081227225102.GA17822@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227225102.GA17822@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2008 at 11:51:02PM +0100, Ingo Molnar wrote:
> * Andi Kleen <ak@linux.intel.com> wrote:
> 
> >> A far more useful design for handling MCE events would be to feed them 
> >> into printk logging.
> >
> > If there's ASCII logging it should be separate from normal printk.
> 
> Well, why? Sure, MCE exceptions themselves cannot generally printk 
> [because they are in essence non-maskable contexts] unless they get a 
> fatal MCE [in which case we have no other choice but to try to printk and 
> hope for the best]. But they can sprintf into a buffer which then gets 
> printk-d (or passed to whatever ASCII based facility).

FWIW, that is how ia64 MCA messages are handled.  The messages are 
written to a pre-allocated buffer.  If the mca is recovered, the
buffer gets printked from a safe context.  If the mca is fatal,
the buffer is printked immediately because the system is going down.
The message is short summary information (that ends up in
/var/log/messages).

See mprintk() in arch/ia64/kernel/mca.c .

Formatting of ia64 MCA/CMCI/CPE/INIT records is done by the salinfo
daemon process.  The records are written to NVRAM, so if the
system crashes after reboot salinfo reads the records and writes
them to /var/log/salinfo/decoded.  This is the full ASCII error
record.

> 'struct mce' is pointless complexity and a pointless restriction - and so 
> is /dev/mcelog.

I agree with Andi.  In general that type interface is needed, though
some of the specifics could change.  (ie Ying's new mcelog
implementation uses a per CPU buffer.)

> >> So instead of printing such rather cryptic error messages:
> >>
> >>    MCE 0
> >>    HARDWARE ERROR. This is *NOT* a software problem!
> >>    Please contact your hardware vendor
> >>    CPU 0 BANK 6 MISC 202d ADDR ffeef740
> >>    This is not a software problem!
> >>    Run through mcelog --ascii to decode and contact your hardware vendor
> >>
> >> and expecting people to run mcelog, we should print plain-text 
> >> something like:
> >>
> >>    MCE 0
> >>    HARDWARE ERROR. This is *NOT* a software problem!
> >>    Please contact your hardware vendor
> >>    CPU 1 4 northbridge TSC 89a560bb249
> >>    ADDR 1dfa49690
> >>      Northbridge Chipkill ECC error

Summary ASCII information is useful, especially if the error
is clearly a hardware error.  Andi is right that decoding the
information to print the specific failing hardware (ie which 
DIMM) may be too dificult to decode on the way down.  It would
be great to identify the failing hardware component on the
way down, when possible.

> > It turns out that users don't really find this more enlightening (most 
> > users have no clue what a Northbridge is).  They think it's some kind of 
> > kernel bug even with the HARDWARE ERROR header.
> 
> You should not assume that administrators/users reading kernel crash 
> messages are dumb. (an ordinary user wont see it most of the time anyway) 
> 
> The usage patterns i see is that admins who get an MCE crash often fail to 
> write down the whole MCE message (not realizing that it is important) and 
> have to go back and reproduce the MCE crash once again before they can get 
> any meaningful information.

This is why saving the error records to MVRAM is so useful.
After reboot the records can be read, formatted, and logged.

> Printing out cryptic hexadecimal error codes, requiring people to write 
> them down and decode them in user-space is the technology of the 80s - i 
> didnt think i'd have to argue too much about this ;-)

I agree.  Printing out the failing hardware component in
human readable form, when possible, is the best thing.

> Reducing the amount of information presented to the user in such a crash 
> situation is a dumb idea. (especially here where the MCE information is 
> rather dense and single-screen anyway - so there's no screen real estate 
> considerations.)

On ia64 a summary message indicating a fatal MCA is printed.
The full useful information is written to NVRAM.

> > The only people who really care about the micro architectural details in 
> > full are chip developers, and those typically decode using other methods 
> > anyways.
> 
> People do care about getting meaningful crash information from the kernel. 

I agree with Andi.  Full error info needs to be captured at the
time of the crash.  On ia64, MCA records from crashes have been used
by chip developers to identify problems.

> This is a basic principle in the Linux kernel. We try to print out as 
> useful information as possible - and only cut down on it if the 
> information physically does not fit on the screen. (which is not a problem 
> here)

As long as the info is catpured and available on reboot, I
do not think the full information needs to be printed
on the way down.

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
