Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab0BAJci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 04:32:38 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:54530 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab0BAJcg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 04:32:36 -0500
Subject: Re: debug: nt_conntrack and KVM crash
From: Jon Masters <jonathan@jonmasters.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       netfilter-devel <netfilter-devel@vger.kernel.org>,
       Patrick McHardy <kaber@trash.net>
In-Reply-To: <1264834704.2919.3.camel@edumazet-laptop>
References: <1264813832.2793.446.camel@tonnant>
	 <1264816634.2793.505.camel@tonnant>  <1264816777.2793.510.camel@tonnant>
	 <1264834704.2919.3.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Mon, 01 Feb 2010 04:32:25 -0500
Message-Id: <1265016745.7499.144.camel@tonnant>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8BIT
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-30 at 07:58 +0100, Eric Dumazet wrote:
> Le vendredi 29 janvier 2010 à 20:59 -0500, Jon Masters a écrit :
> > On Fri, 2010-01-29 at 20:57 -0500, Jon Masters wrote:
> > 
> > > Ah so I should have realized before but I wasn't looking at valid values
> > > for the range of the hashtable yet, nf_conntrack_htable_size is getting
> > > wildly out of whack. It goes from:
> > > 
> > > (gdb) print nf_conntrack_hash_rnd
> > > $1 = 2688505299
> > > (gdb) print nf_conntrack_htable_size
> > > $2 = 16384
> > > 
> > > nf_conntrack_events: 1
> > > nf_conntrack_max: 65536
> > > 
> > > Shortly after booting, before being NULLed shortly after starting some
> > > virtual machines (the hash isn't reset, whereas it is recomputed if the
> > > hashtable is re-initialized after an intentional resizing operation):
> > 
> > I mean the *seed* isn't changed, so I don't think it was resized
> > intentionally. I wonder where else htable_size is fiddled with.

> This rings a bell here, since another crash analysis on another problem
> suggested to me a potential problem with read_mostly and modules, but I
> had no time to confirm the thing yet.

It gets more interesting, and this occurs with the code builtin anyway
(I build in to make it easier to kgdb the result conveniently), so I
don't think that's an issue...but...

I hacked up a per-namespace version of hashtables (this needs doing
anyway, since the global stuff is just waiting to break) but then
noticed that the built kernel always ends up linked roughly (the
nf_conntrack_default_htable_size is a direct rename of the existing
htable_size and is now simply the initial size for new hashtables - they
can then have their own sizes independently of this global):

00000000000074c8 l     O .data.read_mostly      0000000000000008
nf_conntrack_cachep
00000000000074d0 g     O .data.read_mostly      0000000000000198
nf_conntrack_untracked
0000000000007668 g     O .data.read_mostly      0000000000000004
nf_conntrack_default_htable_size
000000000000766c g     O .data.read_mostly      0000000000000004
nf_conntrack_default_max

In some of my runs, I've been seeing nf_conntrack_default_htable_size
get corrupted with a value that just happens to be the address of
nf_conntrack_cachep. I looked over the RCU handling and the cache
allocation/de-allocation, but didn't see anything yet. And then I'm not
sure why this address would happen to get written there? It immediately
follows nf_conntrack_untracked so I looked over what happens to that
struct (including the memset, etc.) and didn't see anything either.

Like I said, I dumped the memory with kgdb in a number of runs both
"before" and "after" for the entire page surrounding the corruption and
the only real difference is this change to the value immediately
following nf_conntrack_untracked. There was also a decrement of the
reference count on untracked (I think that's normal? It's like a
catchall for when a connection isn't being tracking anywhere else) so
I'm still looking to weird freeing.

Anyway. It looks like we have a few issues:

1). The conntrack code needs to be looked at for namespaces. I have some
work in progress patches for hashing I can send along later. But that's
just a start really for someone who knows that piece a little better.

2). Some other weird memory corruption of that specific address. Most of
the other people who've had this problem don't have dumps or kgdb.

Jon.


