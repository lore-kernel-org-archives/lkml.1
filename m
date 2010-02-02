Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab0BBEgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 23:36:54 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:53069 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab0BBEgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 23:36:52 -0500
Subject: Re: [PATCH] netfilter: per netns nf_conntrack_cachep
From: Jon Masters <jonathan@jonmasters.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Patrick McHardy <kaber@trash.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       netfilter-devel <netfilter-devel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1265035970.2848.50.camel@edumazet-laptop>
References: <1264813832.2793.446.camel@tonnant>
	 <1264816634.2793.505.camel@tonnant> <1264816777.2793.510.camel@tonnant>
	 <1264834704.2919.3.camel@edumazet-laptop>
	 <1265016745.7499.144.camel@tonnant>
	 <b6fcc0a1002010136k7e78a998p31a9e7464c2e8d44@mail.gmail.com>
	 <1265019160.2848.14.camel@edumazet-laptop>
	 <b6fcc0a1002010225u4e74f9f0q633d73038234dc37@mail.gmail.com>
	 <1265023437.2848.30.camel@edumazet-laptop>
	 <1265035970.2848.50.camel@edumazet-laptop>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Mon, 01 Feb 2010 23:36:31 -0500
Message-Id: <1265085391.2861.106.camel@tonnant>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 15:52 +0100, Eric Dumazet wrote:

> [PATCH] netfilter: per netns nf_conntrack_cachep
> 
> nf_conntrack_cachep is currently shared by all netns instances, but
> because of SLAB_DESTROY_BY_RCU special semantics, this is wrong.
> 
> If we use a shared slab cache, one object can instantly flight between
> one hash table (netns ONE) to another one (netns TWO), and concurrent
> reader (doing a lookup in netns ONE, 'finding' an object of netns TWO)
> can be fooled without notice, because no RCU grace period has to be
> observed between object freeing and its reuse.
> 
> We dont have this problem with UDP/TCP slab caches because TCP/UDP
> hashtables are global to the machine (and each object has a pointer to
> its netns).
> 
> If we use per netns conntrack hash tables, we also *must* use per netns
> conntrack slab caches, to guarantee an object can not escape from one
> namespace to another one.
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

You're totally right, I'd missed this (RCU behavior wrt SLAB caches was
one of these black magic voodoo things until Peter Z. set me straight
with his explanation that it only applies to the freeing of the cache
itself, not the objects - that makes sense in the grand scheme of what
RCU is trying to achieve, and so in theory, yeah we could just verify
the ct object we get back out of the cache is from the same ns, should
work just as well as doing per-ns caches, but not as clean IMO). I'm
still not sure it explains the specific corruption I'm seeing, but I
just made some coffee and put on some T. Rex to help me think.

Jon.

P.S. What's up with all the "Welcome, Mr. Bond" and "i_see_dead_people"
and other comments in that code anyway? If you're going to use movie
references, perhaps standardize on one particular genre :)


