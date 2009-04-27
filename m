Return-Path: <linux-kernel-owner+w=401wt.eu-S1760046AbZD0Sze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760046AbZD0Sze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759675AbZD0SzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:55:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41571 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759954AbZD0SzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:55:05 -0400
Date: Mon, 27 Apr 2009 20:54:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Hemminger <shemminger@vyatta.com>
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
Message-ID: <20090427185423.GC23862@elte.hu>
References: <20090423210938.1501507b@nehalam> <49F146FF.5050200@cosmosbay.com> <20090424091839.6e13ebec@nehalam> <49F22465.80305@gmail.com> <20090425133052.4cb711f5@nehalam> <49F4A6E3.7080102@cosmosbay.com> <20090426185646.GB29238@Krystal> <20090426145746.1184aeba@nehalam> <1240854297.7620.65.camel@twins> <20090427113010.5e3f1700@nehalam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090427113010.5e3f1700@nehalam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Hemminger <shemminger@vyatta.com> wrote:

> > non of the linux kernel locking primitives have this -- with the 
> > possible exception of the cpu-hotplug lock.
> > 
> > What rwlock_t has, is reader bias to the point where you can 
> > utterly starve writers, with the side effect that you can obtain 
> > multiple read ownerships without causing a deadlock.
> 
> But what happens when this side effect disappears?

Then well written code works, badly written code breaks.

> > [...]
> >
> > This is all common and well understood terminology, not 
> > something Linus invented just to harras you with.
> 
> In Documentation/ ?  online ?  Where is the definition? The only 
> reference I se is indirectly in DocBook/kernel-locking.tmpl.

Sure, see:

    http://tinyurl.com/c6fakc

> > Generally speaking we do not condone recursive locking 
> > strategies -- and afaik reiserfs (as per the BKL) and the 
> > network code (as per abusing rwlock_t unfairness) are the only 
> > offenders.
> > 
> > Like Linus stated, recursive locking is generally poor taste and 
> > indicates you basically gave up on trying to find a proper 
> > locking scheme. We should very much work towards getting rid of 
> > these abberations instead of adding new ones.
> 
> The people complaining about naming never seem to be the ones 
> providing workable suggestions or patches.

The thing is, while you now have named your locking primitive 
correctly, you are still abusing it by using it recursively.

So it's not 'just about naming'. You should not use read-locks as 
recursive locks. It's poor code.

	Ingo
