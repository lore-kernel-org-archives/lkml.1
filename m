Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbZJEMZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbZJEMZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 08:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbZJEMZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 08:25:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44517 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436AbZJEMZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 08:25:38 -0400
Date: Mon, 5 Oct 2009 14:24:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Anirban Sinha <ani@anirban.org>,
       linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>,
       Kaz Kylheku <kaz@zeugmasystems.com>,
       Anirban Sinha <asinha@zeugmasystems.com>
Subject: Re: futex question
Message-ID: <20091005122436.GA5626@elte.hu>
References: <DDFD17CC94A9BD49A82147DDF7D545C501FD8409@exchange.ZeugmaSystems.local> <4AC68F13.8050601@us.ibm.com> <alpine.LFD.2.00.0910041031330.2646@localhost.localdomain> <DDFD17CC94A9BD49A82147DDF7D545C501F457C5@exchange.ZeugmaSystems.local> <4AC8CF32.8060108@anirban.org> <alpine.LFD.2.00.0910041853180.2646@localhost.localdomain> <1254738974.26976.24.camel@twins> <1254743934.26976.42.camel@twins> <alpine.LFD.2.00.0910051358060.2646@localhost.localdomain> <1254745119.26976.43.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254745119.26976.43.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2009-10-05 at 13:59 +0200, Thomas Gleixner wrote:
>
> > Stared at the same place a minute ago :) But still I wonder if it's 
> > a good idea to silently release locks and set the state to OWNERDEAD 
> > instead of hitting the app programmer with a big clue stick in case 
> > the app holds locks when calling execve().
> 
> Agreed, I rather like the feedback. With regular exit like things 
> there's just not much we can do to avoid the mess, but here we can 
> actually avoid it, seems a waste not to do so.

Well, exec() has been a 'exit() + boot-strap next process' kind of thing 
from the get go - with little state carried over into the new task. This 
has security and robustness reasons as well.

So i think exec() should release all existing state, unless told 
otherwise. Making it behave differently for robust futexes sounds 
assymetric to me.

It might make sense though - a 'prevent exec because you are holding 
locks!' thing. Dunno.

Cc:-ed a few execve() semantics experts who might want to chime in.

If a (buggy) app calls execve() with a (robust) futex still held should 
we auto-force-release robust locks held, or fail the exec with an error 
code? I think the forced release is a 'anomalous exit' thing mostly, 
while calling exec() is not anomalous at all.

	Ingo
