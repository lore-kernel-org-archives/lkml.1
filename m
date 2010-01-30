Return-Path: <linux-kernel-owner+w=401wt.eu-S1752417Ab0A3HgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab0A3HgX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 02:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755Ab0A3HgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 02:36:22 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:48643 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab0A3HgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 02:36:21 -0500
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
Date: Sat, 30 Jan 2010 02:36:11 -0500
Message-Id: <1264836971.7499.4.camel@tonnant>
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
> 
> Could you try changing
> 
> 
> net/netfilter/nf_conntrack_core.c:57:unsigned int nf_conntrack_htable_size __read_mostly;
> to
> net/netfilter/nf_conntrack_core.c:57:unsigned int nf_conntrack_htable_size ;

I'll play later. Right now, I'm looking over every iptables/ip call
libvirt makes - it explicitly plays with the netns for the loopback,
which looks interesting. Supposing it does cause the hashtables to get
unintentionally zereod or the sizing to get wiped out, we should also
nonetheless catch the case that the hash function generates a whacko
number or that the hash size is set to zero when we want to use it.

Amazing more people aren't talking about this, happens on several Fedora
boxes that I know of, and I'm sure many more too using KVM+nf.

Jon.


