Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbYJVKLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbYJVKLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbYJVKK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:10:58 -0400
Received: from lazybastard.de ([212.112.238.170]:40545 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbYJVKK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:10:57 -0400
Date: Wed, 22 Oct 2008 12:10:13 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roland Dreier <rdreier@cisco.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>
Subject: Re: [announce] new tree: "fix all build warnings, on all configs"
Message-ID: <20081022101013.GA25283@logfs.org>
References: <ada3aiv9k6j.fsf@cisco.com> <20081017180523.GA11590@elte.hu> <adatzbbrrcf.fsf@cisco.com> <20081017191202.GA5396@elte.hu> <adaiqrrrp2h.fsf@cisco.com> <20081018082209.GA24220@elte.hu> <alpine.LFD.2.00.0810200933470.3518@nehalem.linux-foundation.org> <20081020192110.GA28736@elte.hu> <20081021064144.GC30563@logfs.org> <20081022094759.GH12453@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081022094759.GH12453@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 October 2008 11:47:59 +0200, Ingo Molnar wrote:
> * Jörn Engel <joern@logfs.org> wrote:
> > On Mon, 20 October 2008 21:21:10 +0200, Ingo Molnar wrote:
> > >  
> > >  /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
> > >  #define fops_get(fops) \
> > > -	(((fops) && try_module_get((fops)->owner) ? (fops) : NULL))
> > > +	(((fops != NULL) && try_module_get((fops)->owner) ? (fops) : NULL))
> > >  #define fops_put(fops) \
> > > -	do { if (fops) module_put((fops)->owner); } while(0)
> > > +	do { if (fops != NULL) module_put((fops)->owner); } while(0)
> > 
> > This, I would argue, makes the code worse.
> 
> In this specific case the issue is that the 'fops' parameter can 
> occasionally be a constant pointer (turning the test into always-true) 
> so the compiler is at least minimally correct at asking the "are you 
> sure you want this" question - which we answer in the affirmative via 
> the explicit NULL check. But these are really nuances.

#define fops_put(fops) do {			\
	if (fops != NULL)			\
		module_put((fops)->owner);	\
} while 0

If the code was written like this, I wouldn't mind your patch at all.
But in the one-liner form, the ' != NULL' makes the difference between
fluent reading and having to actively sort out which piece belongs
where.

And I bet that if it hadn't been a macro but an inline function, you
and checkpatch would have complained about the formatting long ago. ;)

Jörn

-- 
To announce that there must be no criticism of the President, or that we
are to stand by the President, right or wrong, is not only unpatriotic
and servile, but is morally treasonable to the American public.
-- Theodore Roosevelt, Kansas City Star, 1918
