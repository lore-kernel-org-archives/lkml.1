Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbYE2PBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbYE2PBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 11:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbYE2PBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 11:01:41 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51636 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752522AbYE2PBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 11:01:40 -0400
Subject: Re: MMIO and gcc re-ordering issue
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jes Sorensen <jes@sgi.com>
Cc: Roland Dreier <rdreier@cisco.com>, benh@kernel.crashing.org,
       Arjan van de Ven <arjan@infradead.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, tpiepho@freescale.com,
       linuxppc-dev@ozlabs.org, scottwood@freescale.com,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <yq0iqwxrwuh.fsf@jaguar.mkp.net>
References: <1211852026.3286.36.camel@pasglop>
	 <20080526.184047.88207142.davem@davemloft.net>
	 <1211854540.3286.42.camel@pasglop>
	 <20080526.192812.184590464.davem@davemloft.net>
	 <20080526204233.75b71bb8@infradead.org> <1211872130.3286.64.camel@pasglop>
	 <adaprr721c6.fsf@cisco.com> <1211922696.3286.82.camel@pasglop>
	 <adaiqwzsa83.fsf@cisco.com>  <yq0iqwxrwuh.fsf@jaguar.mkp.net>
Content-Type: text/plain
Date: Thu, 29 May 2008 10:01:29 -0500
Message-Id: <1212073289.3428.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-29 at 10:47 -0400, Jes Sorensen wrote:
> >>>>> "Roland" == Roland Dreier <rdreier@cisco.com> writes:
> 
> >> This is a different issue. We deal with it on powerpc by having
> >> writel set a per-cpu flag and spin_unlock() test it, and do the
> >> barrier if needed there.
> 
> Roland> Cool... I assume you do this for mutex_unlock() etc?
> 
> Roland> Is there any reason why ia64 can't do this too so we can kill
> Roland> mmiowb and save everyone a lot of hassle?  (mips, sh and frv
> Roland> have non-empty mmiowb() definitions too but I'd guess that
> Roland> these are all bugs based on misunderstandings of the mmiowb()
> Roland> semantics...)
> 
> Hi Roland,
> 
> Thats not going to solve the problem on Altix. On Altix the issue is
> that there can be multiple paths through the NUMA fabric from cpuX to
> PCI bridge Y. 
> 
> Consider this uber-cool<tm> ascii art - NR is my abbrevation for NUMA
> router:
> 
>         -------         -------
>         |cpu X|         |cpu Y|
>         -------         -------
>          |   \____  ____/    |
>          |        \/         |
>          |    ____/\____     |
>          |   /          \    |
>          -----          ------
>          |NR 1|         |NR 2|
>          ------         ------
>               \         /
>                \       /
>                 -------
>                 | PCI |
>                 -------
> 
> The problem is that your two writel's, despite being both issued on
> cpu X, due to the spin lock, in your example, can end up with the
> first one going through NR 1 and the second one going through NR 2. If
> there's contention on NR 1, the write going via NR 2 may hit the PCI
> bridge prior to the one going via NR 1.
> 
> Of course, the bigger the system, the worse the problem....
> 
> The only way to guarantee ordering in the above setup, is to either
> make writel() fully ordered or adding the mmiowb()'s inbetween the two
> writel's. On Altix you have to go and read from the PCI brige to
> ensure all writes to it have been flushed, which is also what mmiowb()
> is doing. If writel() was to guarantee this ordering, it would make
> every writel() call extremely expensive :-(

So if a read from the bridge achieves the same effect, can't we just put
one after the writes within the spinlock (an unrelaxed one).  That way
this whole sequence will look like a well understood PCI posting flush
rather than have to muck around with little understood (at least by most
driver writers) io barriers?

James


