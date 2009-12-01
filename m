Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbZLARPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbZLARPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZLARPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:15:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187AbZLARPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:15:44 -0500
Date: Tue, 1 Dec 2009 09:15:05 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Arnd Bergmann <arnd@arndb.de>
cc: Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] "fair" rw spinlocks
In-Reply-To: <200912011803.24664.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.0912010908590.2872@localhost.localdomain>
References: <20091123145409.GA29627@wotan.suse.de> <20091130171333.GG21639@wotan.suse.de> <alpine.LFD.2.00.0911300914240.2872@localhost.localdomain> <200912011803.24664.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Dec 2009, Arnd Bergmann wrote:
> On Monday 30 November 2009, Linus Torvalds wrote:
> > The best option really would be to try to make it all use RCU, rather than 
> > paper over things. That really should improve performance.
> 
> Are there any writers at interrupt time?

No, there can't be. That would already be a deadlock, since we take the 
read lock without irq protection (exactly because many of the read-lockers 
are pretty performance-sensitive).

> If not, another option might be to first convert all the readers that 
> can happen from interrupts to RCU, which lets us get rid of the irq 
> disable in the write path.

If you convert the irq readers, you generally really need to convert the 
rest too. In particular, you still need to convert the write-side to use 
the RCU versions of the insert/remove code, and to free the things from 
RCU in order for it all to be safe (think: irq reader on another CPU than 
the writer, now without any locking).

So you really don't win all that much. At a minimum, you always have to 
convert all the writers to use RCU (even if you then keep the rwlock as 
the exclusion model), and since that involves a large portion of the 
complexity (including at least the RCU freeing side), what you end up with 
is that you can avoid converting _some_ of the readers.

So I do agree that you can do things in two stages, but I suspect the irq 
disable on the write path part is the least of our problems.

				Linus
