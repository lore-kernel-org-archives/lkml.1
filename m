Return-Path: <linux-kernel-owner+w=401wt.eu-S1759395AbZGCV3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395AbZGCV3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 17:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757983AbZGCV3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 17:29:17 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:41168 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757740AbZGCV3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 17:29:16 -0400
Date: Fri, 3 Jul 2009 22:35:22 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Borislav Petkov <borislav.petkov@amd.com>, Greg KH <gregkh@suse.de>,
       x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Kurt Garloff <garloff@suse.de>,
       linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] x86: sysctl to allow panic on IOCK NMI error
In-Reply-To: <20090702075305.GC19187@elte.hu>
Message-ID: <alpine.LFD.2.00.0907031526570.13862@eddie.linux-mips.org>
References: <20090624213211.GA11291@kroah.com> <alpine.LFD.2.00.0906302324350.23134@eddie.linux-mips.org> <20090630223040.GA3802@suse.de> <alpine.LFD.2.00.0907010148490.23134@eddie.linux-mips.org> <20090701111003.GC15958@elte.hu>
 <alpine.LFD.2.00.0907011816070.18056@eddie.linux-mips.org> <20090702075305.GC19187@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jul 2009, Ingo Molnar wrote:

> >  Well, that's just a fast track to become a veteran, isn't it? ;)
> 
> No, that's just a fast track to quickly make it into the list of our 
> Fallen Heroes :-/ The fast track to become a kernel veteran is to, 
> if possible, not challenge a tank with a hand-grenade. But i 
> digress.

 What doesn't kill you will make you stronger, ;) but otherwise I digress 
too.

> > That shouldn't be a problem if we were about to panic().  For a 
> > more sophisticated attempt of recovery -- yes, that would have to 
> > be addressed.
> 
> We are only panic-ing if the sysctl is set. The diagnostics would be 
> useful anyway. The proper approach would be to defer it a bit in the 
> non-panic case an read it out from some friendlier context - such as 
> the EDAC core.

 Hmm, my concern is in the case of a PCI SERR the system may not 
necessarily be in a recoverable state.  For example if a master abort 
happened due to a timeout (which is outside the PCI spec I'm told, but the 
only way to avoid holding the bus undefinitely) and the target finally 
responded, then it may have corrupted a subsequent transaction.  My point 
is thus any diagnostic output should be produced as soon as possible and 
involving as little system resources as absolutely necessary.  This being 
enough to identify the device triggering the SERR -- so that if an error 
is fatal and recurs, then the possible offender can be determined.

 Deferring such initial diagnostic to a softirq or suchlike does not sound 
as a terribly good idea to me.  I think this is also the right place to 
disable the device's master access to the bus (and possibly target address 
space decoders too -- the device may have started misdecoding and 
interfering with transactions meant to involve other devices) -- till the 
recovery procedure has been completed.

 Then further processing, such as signalling the involved device's driver 
that the error happened and letting it attempt to recover is something 
that should happen in less restricted a context.  It is the driver only 
that could further determine the cause based on the state of the device's 
registers (e.g. what was the target when the reporting device acted as a 
master) and the knowledge of how it operates, reset the device, etc.  
Once the situation has been rectified and the device determined to be 
capable to continue operating (e.g. the built-in to the firmware self-test 
-- if available -- was run and reported success) the device can be 
reconfigured and put on the bus again.

  Maciej
