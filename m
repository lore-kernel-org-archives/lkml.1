Return-Path: <linux-kernel-owner+w=401wt.eu-S1759543AbZD0TH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543AbZD0TH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 15:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758139AbZD0THJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 15:07:09 -0400
Received: from mail.vyatta.com ([76.74.103.46]:35747 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873AbZD0THF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 15:07:05 -0400
Date: Mon, 27 Apr 2009 12:06:58 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Eric Dumazet <dada1@cosmosbay.com>, David Miller <davem@davemloft.net>,
       Jarek Poplawski <jarkao2@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, paulmck@linux.vnet.ibm.com,
       Evgeniy Polyakov <zbr@ioremap.net>, kaber@trash.net,
       jeff.chua.linux@gmail.com, laijs@cn.fujitsu.com, jengelh@medozas.de,
       r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-CPU r**ursive lock {XV}
Message-ID: <20090427120658.35a858bb@nehalam>
In-Reply-To: <20090427185423.GC23862@elte.hu>
References: <20090423210938.1501507b@nehalam>
	<49F146FF.5050200@cosmosbay.com>
	<20090424091839.6e13ebec@nehalam>
	<49F22465.80305@gmail.com>
	<20090425133052.4cb711f5@nehalam>
	<49F4A6E3.7080102@cosmosbay.com>
	<20090426185646.GB29238@Krystal>
	<20090426145746.1184aeba@nehalam>
	<1240854297.7620.65.camel@twins>
	<20090427113010.5e3f1700@nehalam>
	<20090427185423.GC23862@elte.hu>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009 20:54:23 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Stephen Hemminger <shemminger@vyatta.com> wrote:
> 
> > > non of the linux kernel locking primitives have this -- with the 
> > > possible exception of the cpu-hotplug lock.
> > > 
> > > What rwlock_t has, is reader bias to the point where you can 
> > > utterly starve writers, with the side effect that you can obtain 
> > > multiple read ownerships without causing a deadlock.
> > 
> > But what happens when this side effect disappears?
> 
> Then well written code works, badly written code breaks.
> 
> > > [...]
> > >
> > > This is all common and well understood terminology, not 
> > > something Linus invented just to harras you with.
> > 
> > In Documentation/ ?  online ?  Where is the definition? The only 
> > reference I se is indirectly in DocBook/kernel-locking.tmpl.
> 
> Sure, see:
> 
>     http://tinyurl.com/c6fakc

All those references support my argument that the lock is being
used recursively in this case. It is being acquired multiple
times by the same CPU. This is not new, it has always been
acquired multiple times, so my change does not break anything.

If other implementations of reader locks to not nest the same
way, then on those system iptables can deadlock. Nothing was
changed by this.

> > > Generally speaking we do not condone recursive locking 
> > > strategies -- and afaik reiserfs (as per the BKL) and the 
> > > network code (as per abusing rwlock_t unfairness) are the only 
> > > offenders.
> > > 
> > > Like Linus stated, recursive locking is generally poor taste and 
> > > indicates you basically gave up on trying to find a proper 
> > > locking scheme. We should very much work towards getting rid of 
> > > these abberations instead of adding new ones.
> > 
> > The people complaining about naming never seem to be the ones 
> > providing workable suggestions or patches.
> 
> The thing is, while you now have named your locking primitive 
> correctly, you are still abusing it by using it recursively.
> 
> So it's not 'just about naming'. You should not use read-locks as 
> recursive locks. It's poor code.

If you don't like the proposal please, think of a better alternative.
Not just pseudo code that is broken with handwaving arguments.
