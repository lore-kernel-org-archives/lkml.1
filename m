Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbXKEAQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbXKEAQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 19:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbXKEAQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 19:16:19 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53242 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751480AbXKEAQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 19:16:18 -0500
Date: Sun, 4 Nov 2007 16:15:21 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Mikael Pettersson <mikpe@it.uu.se>,
       linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH] fix i486 boot failure due to stale %ds
In-Reply-To: <472E5AB6.40509@zytor.com>
Message-ID: <alpine.LFD.0.999.0711041600280.15101@woody.linux-foundation.org>
References: <200711042158.lA4Lwv9S014628@harpo.it.uu.se> <472E50C5.5020201@goop.org>
 <472E5AB6.40509@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 4 Nov 2007, H. Peter Anvin wrote:
> 
> Joy.  Apparently the Intel documentation is actually self-inconsistent.
> Section 9.9.1, page 9-17 does indeed have the "far jump or call" injunction,
> whereas the sample code in section 9.10.1, page 9-27, line 180 does a near
> jump!

See the older code. There's literally two different issues:

 - flushing the pipeline. Using a regular short jump is not only 
   sufficient, but is a good idea because the byte sequence has no 
   dependency on any modes, so it is guaranteed to flush any pipeline 
   without itself having any behavioural differences.

   This part is a no-op for later CPU's: they simply won't care, since 
   they serialize the pipeline on their own (and the have to, since a 
   correctly predicted branch no longer flushes it anyway).

   So this is purely a i386/i486 thing (and *maybe* Pentium, but 
   definitely not PPro and later)

 - setting up the proper protected mode bits in CS. This obviously changes
   the CS itself, and anything that depends on any shadow state in CS will 
   need this to happen first. In practice, very few things really depend 
   on the CS bits, of course.

Doing them back-to-back is obviously the best situation, and leaves the 
minimum footprint for any dubious undocumented behaviour. That said, while 
the whole thing with shadow segment table is strictly speaking probably 
"undocumented" behaviour, it's certainly a reality, and lots of code has 
depended on the fact that even though you haven't reloaded a segment, the 
segment continues to work across mode switches thanks to the shadow table. 

So it's not like there's any real secret to what happens until the 
longjump has been executed: we continue running with the CS shadow table 
entry being in "real mode", and the effect of that tends to be minimal. 
But in theory, the CS table entry could affect how instructions actually 
act, even though in practice I don't think it really has any real effect 
outside of the actual segment access check (and certainly did not in the 
i386/i486 timeframe).

So I'd suggest having both jumps back-to-back, but realistically, the 
first regular short jump is actually the one that is more important. 
That's the one that really matters on i386/i486 class machines, and later 
CPU's will generally do the right thing even with _neither_ jump there.

			Linus
