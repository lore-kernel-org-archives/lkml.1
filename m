Return-Path: <linux-kernel-owner+w=401wt.eu-S1759091AbZBMNvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759091AbZBMNvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 08:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbZBMNvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 08:51:15 -0500
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:28277 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752793AbZBMNvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 08:51:15 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jHPsgfSr46dzxgPl1QM6R+1/Fqh/PQJFsd9s00lnPY6qLJ1kngDE4SVcUCieyh6vmvypkX+wA5aFKcmNaosN+Py30M55CoTJ/ov0r3rkNJrLfPFokzogGRK1LQYvH6ULWNlLxE2rcBOVb1xgsuFw6Sdl1mJCHGoKAwt4/LdXoLk=  ;
X-YMail-OSG: XHnxR1UVM1lu2mty34iAjmebvT4N9cBROtsQPVZR9aRlh8SEqT2hhb4GAH9fKmnECWT.pKmtb_s7uIgQ5bCu5pXO8YVrWZERoO9fvLajIJQdGw5dyppjaY7Wu5JLzsrtKMxJHj_7koih.e4QPK92_D5wTAmSfAqb38vNXzT.Q7SmTkjc88wpocLp4q4pxQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux (repost)
Date: Sat, 14 Feb 2009 00:50:43 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>, uclinux-dist-devel@blackfin.uclinux.org
References: <20090212023308.GA21157@linux.vnet.ibm.com> <alpine.LFD.2.00.0902121247040.3099@localhost.localdomain> <20090212215959.GN6759@linux.vnet.ibm.com>
In-Reply-To: <20090212215959.GN6759@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902140050.44550.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 February 2009 08:59:59 Paul E. McKenney wrote:
> On Thu, Feb 12, 2009 at 01:15:08PM -0800, Linus Torvalds wrote:
> > On Thu, 12 Feb 2009, Paul E. McKenney wrote:
> > > In other words, you are arguing for using ACCESS_ONCE() in the loops,
> > > but keeping the old ACCESS_ONCE() definition, and declaring BF hardware
> > > broken?
> >
> > Well, I _also_ argue that if you have a busy loop, you'd better have a
> > cpu_relax() in there somewhere anyway. If you don't, you have a bug.
> >
> > So I think the BF approach is "borderline broken", but I think it should
> > work, if BF just has whatever appropriate cache flush in its cpu_relax.
>
> OK, got it.  Keep ACCESS_ONCE() as is, make sure any busy-wait
> loops contain a cpu_relax().  A given busy loop might or might not
> need ACCESS_ONCE(), but that decision is independent of hardware
> considerations.
>
> Ah, and blackfin's cpu_relax() does seem to have migrated from barrier()
> to smp_mb() recently, so sounds good to me!!!


Interesting. I don't know if you would say it is not cache coherent.
Does anything in cache coherency definition require timeliness? Only
causality I think.

However I think "infinite write buffering delay", or requiring "cache
barriers" is insane to teach any generic code about. BF would be free
to optimise arch functions, but for correctness surely it must also
have a periodic interrupt that will expose stores to other CPUs.

