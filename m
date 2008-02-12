Return-Path: <linux-kernel-owner+w=401wt.eu-S1764102AbYBLQs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764102AbYBLQs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760708AbYBLQsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:48:20 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57570 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758749AbYBLQsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:48:19 -0500
Date: Tue, 12 Feb 2008 08:46:51 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v10
In-Reply-To: <20080212152846.GC3078@elte.hu>
Message-ID: <alpine.LFD.1.00.0802120829410.2920@woody.linux-foundation.org>
References: <20080211015321.GA27376@one.firstfloor.org> <y0mhcgf4ig1.fsf@ton.toronto.redhat.com> <20080211162141.GA31434@elte.hu> <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org>
 <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <20080212135027.GA1343@one.firstfloor.org> <20080212152846.GC3078@elte.hu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Feb 2008, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > Stopping all CPUs for indefinite time very much seems like "breaking a 
> > correctly working system" to me. [...]
> 
> well, this is a small detail, but still you are wrong, and on a 
> correctly working system this will not occur. (if yes, tell me how)

Quite frankly, I don't see why the kernel kgdb layer should have *any* 
code like this at all.

The one who is actually debugging is the one who should decide which CPU's 
get stopped, and which don't.

I realize that the gdb remote protocol is probably a piece of crap and 
cannot handle that, but hey, that's not my problem, and more importantly, 
I don't think it's even a *remotely* valid reason for making bad decisions 
in the kernel. gdb was still open source last time I saw, and I think it's 
reasonable to just say:

 - the kgdb commands should always act on the *current* CPU only
 - add one command that says "switch over to CPU #n" which just releases 
   the current CPU and sends an IPI to that CPU #n (no timeouts, no 
   synchronous waiting, no nothing - it's like a "continue", but with a 
   "try to get the other CPU to stop"

Yes, other CPU's will obviously often end up stopping due to waiting for 
some spinlock or other if we stop one, but that's a separate issue, and 
quite often it might be sufficient - and what we want.

And yes, you'd likely have to add some support to gdb to make this 
_usable_, but now all that usability crap, all those timeouts for "stop 
all CPU's" are now in user space on the _debugger_ side. That can be as 
fancy as it wants to be.

And maybe this isn't realistic. I'm not saying "we _must_ do it this way", 
I just want to say that the kernel kgdb layer should be as thin ass 
humanly possible, and maybe the right thing to do is to simply totally 
punt on the whole "stop other cpu's" issue and make it a debugger-side 
question.

In other words, is it perhaps possible to just *get*rid*of* that 
"kgdb_active" and "nmicallback" and the whole multi-CPU roundup? Just use 
a kgdb spinlock around the stuff that actually sends and receives 
individual packets, and expect the debugger side to sort them out (yeah, I 
suspect this involves having to add the CPU ID to each packet).

			Linus
