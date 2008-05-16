Return-Path: <linux-kernel-owner+w=401wt.eu-S1761509AbYEPW66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761509AbYEPW66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 18:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755902AbYEPW6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 18:58:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755368AbYEPW6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 18:58:46 -0400
Date: Fri, 16 May 2008 15:58:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Remove BKL from FAT/VFAT/MSDOS (v1) (was Re: Fw: Regression
 caused by bf726e "semaphore: fix,")
In-Reply-To: <alpine.LFD.1.10.0805161514570.3020@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805161552510.3020@woody.linux-foundation.org>
References: <20080510121020.f33c83f7.akpm@linux-foundation.org> <20080511075522.GA18214@elte.hu> <Pine.LNX.4.64.0805111150250.32758@titan.stealer.net> <20080511125731.GA28174@elte.hu> <alpine.LFD.1.10.0805110941540.3330@woody.linux-foundation.org>
 <20080511111210.77858eb4.akpm@linux-foundation.org> <alpine.LFD.1.10.0805111221070.3188@woody.linux-foundation.org> <alpine.LFD.1.10.0805111243250.3188@woody.linux-foundation.org> <20080511235112.GA16101@elte.hu> <alpine.LFD.1.10.0805120155490.3514@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0805120723440.3188@woody.linux-foundation.org> <alpine.LFD.1.10.0805121659470.3514@apollo.tec.linutronix.de> <alpine.LFD.1.10.0805121324410.3019@woody.linux-foundation.org> <alpine.LFD.1.10.0805161025510.3255@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0805160906580.2941@woody.linux-foundation.org> <alpine.LFD.1.10.0805160950180.2941@woody.linux-foundation.org> <alpine.LFD.1.10.0805161514570.3020@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 16 May 2008, Linus Torvalds wrote:
>
> 				[...] but I do think this is at 
> least an interesting starting point, and it's at least not "totally 
> obviously broken".

To clarify: lock_super() is actually a much *stronger* lock than 
lock_kernel(), which is why testing is actually interesting: the locking 
hasn't been weakened, it's actually become much stricter (because unlike 
the kernel lock, the superblock lock is kept over scheduling events, and 
doesn't silently nest).

So the most likely failure case is not that some locking went away and 
you'd race on the data structures, it's that something deadlocks on itself 
if the locking isn't right.

There could be some implicit kernel lock I missed (ie something that acts 
like the "ioctl" callback I already mentioned), of course, so I'm not 
going to swear myself blue in the face that there isn't a new race, but on 
the whole this patch should be pretty safe from the angle that at least 
the obvious locking bugs should cause deadlocks, not race conditions.

And if you enable lockdep, the deadlocks aren't silent deaths, but clear 
"this is where you took it, and here is where you deadlocked due to 
nesting" reports in dmesg. So this should be eminently debuggable even by 
almost total newbies that are just interested in BKL removal.

		Linus
