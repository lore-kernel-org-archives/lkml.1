Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbYLaSJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbYLaSJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 13:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756128AbYLaSJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 13:09:24 -0500
Received: from relay1.sgi.com ([192.48.179.29]:58878 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757099AbYLaSJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 13:09:23 -0500
Date: Wed, 31 Dec 2008 12:09:17 -0600
From: Russ Anderson <rja@sgi.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Russ Anderson <rja@sgi.com>
Subject: Re: x86/mce merge, integration hickup + crash, design thoughts
Message-ID: <20081231180917.GA18061@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20081227155019.GA15493@elte.hu> <20081227225102.GA17822@elte.hu> <20081230211310.GA19653@sgi.com> <495B7457.1040605@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495B7457.1040605@linux.intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 02:32:07PM +0100, Andi Kleen wrote:
> Russ Anderson wrote:
> 
> >Summary ASCII information is useful, especially if the error
> >is clearly a hardware error.  Andi is right that decoding the
> >information to print the specific failing hardware (ie which 
> >DIMM) may be too dificult to decode on the way down.  It would
> >be great to identify the failing hardware component on the
> >way down, when possible.
> 
> This will hopefully happen in the future. In fact mcelog has support
> to decode using DMI tables, but it turns out this doesn't work
> very well in practice (both because of BIOS problems and because
> the DMI standard was not really designed for this). That is why
> I wouldn't advocate right now to move this code from mcelog
> into the kernel. This might change later.

Yes.  The way ia64 deals with this is the SAL (bios) does much of the
platform specific interpretation to identify the failing hardware
and passes that information up to linux.  That allows the kernel
to be more platform independent while the SAL (bios) deals with the
platform specifics.  

The problem of not having a spec, such as the ia64 SAL spec, is
that other interfaces end up getting overloaded, such as 
the DMI tables.  Should this be part of the EFI standard?
It really does need to be part of a standard specification.

> >>>It turns out that users don't really find this more enlightening (most 
> >>>users have no clue what a Northbridge is).  They think it's some kind of 
> >>>kernel bug even with the HARDWARE ERROR header.
> >>You should not assume that administrators/users reading kernel crash 
> >>messages are dumb. (an ordinary user wont see it most of the time anyway) 
> >>
> >>The usage patterns i see is that admins who get an MCE crash often fail 
> >>to write down the whole MCE message (not realizing that it is important) 
> >>and have to go back and reproduce the MCE crash once again before they 
> >>can get any meaningful information.
> >
> >This is why saving the error records to MVRAM is so useful.
> >After reboot the records can be read, formatted, and logged.
> 
> I've been looking at using EFI runtime services for this, but it's

I believe that is the right approach.  Error handling was one
of my primary motivations for getting in EFI runtime services
for UV.  Having a more standard interface, rather than platform
specific, would be good. 

> also somewhat problematic (e.g. getting the messages out again in
> a useful way without risking duplicating events)

In ia64, salinfo_decode looks for duplicate records when reading
from SAL (bios).  SGI SAL uses hardware timestamps when building 
error records to avoid duplicates.  There are still occasional
duplicate records in a few cases, but rare enough to not be a
problem.  

One case that always generates duplicate records is a recovered
MCA.  The MCA record is logged to NVRAM before linux tries to 
recover (in case the system crashes).  After recovery, the MCA
record is logged with a recovered status, making the record look
different than the record logged to NVRAM (to salinfo_decoded).
salinfo_decoded logs both the original MCA record and the MCA
record marked recovered (writing them to /var/log/salinfo/decoded).
It turned out to be useful to have both records when explaining
to customers how error recovery worked (in the case of an
application hitting a memory uncorrectable error).  When they
realize that each duplicate MCA record represents a time that the
system did not crash, they suddenly like those duplicate records. :-)

The bigger concern is not losing records (especially with a burst
of errors).  The issue is keeping the older (more significant)
error records and dropping the newer (less significant), not
to be confused with thresholding correctable errors...

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
