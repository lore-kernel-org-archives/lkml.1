Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbYJVJtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbYJVJtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 05:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbYJVJtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 05:49:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51540 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbYJVJs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 05:48:59 -0400
Date: Wed, 22 Oct 2008 11:47:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roland Dreier <rdreier@cisco.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>
Subject: Re: [announce] new tree: "fix all build warnings, on all configs"
Message-ID: <20081022094759.GH12453@elte.hu>
References: <20081017171139.GA1792@elte.hu> <ada3aiv9k6j.fsf@cisco.com> <20081017180523.GA11590@elte.hu> <adatzbbrrcf.fsf@cisco.com> <20081017191202.GA5396@elte.hu> <adaiqrrrp2h.fsf@cisco.com> <20081018082209.GA24220@elte.hu> <alpine.LFD.2.00.0810200933470.3518@nehalem.linux-foundation.org> <20081020192110.GA28736@elte.hu> <20081021064144.GC30563@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081021064144.GC30563@logfs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jörn Engel <joern@logfs.org> wrote:

> On Mon, 20 October 2008 21:21:10 +0200, Ingo Molnar wrote:
> >  
> >  /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
> >  #define fops_get(fops) \
> > -	(((fops) && try_module_get((fops)->owner) ? (fops) : NULL))
> > +	(((fops != NULL) && try_module_get((fops)->owner) ? (fops) : NULL))
> >  #define fops_put(fops) \
> > -	do { if (fops) module_put((fops)->owner); } while(0)
> > +	do { if (fops != NULL) module_put((fops)->owner); } while(0)
> 
> This, I would argue, makes the code worse.

Have a look at:

   $ git log -p --grep="NULL noise"

for example:

        for (i = 0; i < MAX_FEB_SIZE; i++)
-               if (tb->FEB[i] != 0)
+               if (tb->FEB[i] != NULL)
                        break;

so checking for != NULL is a valid way of testing a pointer's existence. 
The "if (tb->FEB[i])" is a valid shortcut for the same thing as well.

In this specific case the issue is that the 'fops' parameter can 
occasionally be a constant pointer (turning the test into always-true) 
so the compiler is at least minimally correct at asking the "are you 
sure you want this" question - which we answer in the affirmative via 
the explicit NULL check. But these are really nuances.

	Ingo
