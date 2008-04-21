Return-Path: <linux-kernel-owner+w=401wt.eu-S1760245AbYDUQYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760245AbYDUQYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 12:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbYDUQYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 12:24:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35569 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155AbYDUQYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 12:24:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Mon, 21 Apr 2008 18:24:41 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
References: <200804191522.54334.rjw@sisk.pl> <20080421054729.GA19864@linux.vnet.ibm.com> <alpine.LFD.1.10.0804210850100.2779@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804210850100.2779@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804211824.42732.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 21 of April 2008, Linus Torvalds wrote:
> 
> On Sun, 20 Apr 2008, Paul E. McKenney wrote:
> > 
> > And it passes.
> 
> Ok, I applied it, with hopefully an understandable commit message.
> 
> That said, now we just need to figure out what actually caused the bug in 
> question.
> 
> Rafael: if it's a too-early free of the dentry (which could be because 
> somebody didn't do a proper rcu read-lock, or maybe the rcu grace period 
> logic itself got broken?), then enabling SLUB/SLAB debugging should catch 
> it much more quickly (and hopefully we'd see the signature of a 
> use-after-free - the poisoning byte pattern rather than the -1).
> 
> The other alternative is simply memory corruption. Ie the -1 may well be 
> somebody *else* overwritin the ->next pointer because they did a 
> use-after-free and maybe the dentry_cache is shared with some other 
> allocation of the same size (SLUB does that, no?)
> 
> Rafael: your last oops does seem to imply that there is some strange 
> memory corruption going on, because in that case the invalid pointer is 
> different: instead of being all-ones, it is "fff0810023444c98", which is 
> not a possible pointer. It very much looks like a single nybble got 
> cleared (because ffff810023444c98 _would_ be a valid pointer, notice the 
> "fff0" vs "ffff" prefix).
> 
> So I do suspect it's *some* kind of use-after-free thing. But nothing in 
> fs/ has changed, so it's not a dentry bug, I think. Which is why my 
> "preferred" suspect is that "somebody else also does allocations of the 
> same size as the dentry code, and shares the same SLUB alloc space, and 
> does something bad".
> 
> So Rafael - are you using SLUB, and if you are, can you enable SLUB_DEBUG, 
> and then use the "slub_debug" kernel command line to enable it?

Sure, I have SLUB_DEBUG on already, rebooting with "slub_debug".

Thanks,
Rafael
