Return-Path: <linux-kernel-owner+w=401wt.eu-S1758902AbZD2ULh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbZD2ULh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 16:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbZD2UL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 16:11:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33627 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbZD2UL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 16:11:27 -0400
Date: Wed, 29 Apr 2009 22:11:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: sfr@canb.auug.org.au, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com
Subject: Re: [PATCH 5/5] ring-buffer: fix printk output
Message-ID: <20090429201104.GD17021@elte.hu>
References: <20090429054359.GA6148@elte.hu> <20090428225541.9ca61a12.akpm@linux-foundation.org> <20090429060955.GD6148@elte.hu> <20090428232000.6c3d4ce1.akpm@linux-foundation.org> <20090429072208.GA22129@elte.hu> <20090429004141.5f0565c9.akpm@linux-foundation.org> <20090429095625.GE31185@elte.hu> <20090429080907.efb8ba2f.akpm@linux-foundation.org> <20090429194546.GA17021@elte.hu> <20090429125203.dd2e1095.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429125203.dd2e1095.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 29 Apr 2009 21:45:46 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Wed, 29 Apr 2009 11:56:25 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > 
> > > > > > My larger point remains, about possibly embedding linux-next 
> > > > > > into lkml. I couldnt think of a single linux-next mail that isnt 
> > > > > > relevant to lkml. It's all about commits that are destined for 
> > > > > > upstream in 0-2.5 months.
> > > > > 
> > > > > Sure, I'd be OK with zapping the linux-next list.
> > > > 
> > > > Another, less drastic solution would be to keep it as an _alias_ 
> > > > list. All mails posted to it also go to lkml, but it would still be 
> > > > subscribe-able separately.
> > > 
> > > That would work, although I wonder about the potential for 
> > > duplicates turning up somewhere.
> > 
> > The potential for duplicates is inherent in Cc: lines to begin with.
> 
> But if someone does reply-to-all to linux-next and linux-kernel, 
> and the linux-next email gets redirected to linux-kernel, badness 
> might happen.  Bearing in mind the screwiness of the mail clients 
> whcih some people use..

Hm, what badness would happen? Today, if i send a mail to linux-next 
and lkml, it shows up on both lists. If i'm subscribed to both, i 
get two mails - one from lkml and one from linux-next.

Auto-aliasing the lists means adding an implicit Cc: lkml to all 
mails that the linux-next list server gets. Two mails are generated 
- and if someone is subscribed to both lists, two mails are 
received. How would mail clients have a problem with that? It's 
already happening.

> > > > ( This has come up before and this would be useful for a number of 
> > > >   other things - such as tracing/instrumentation. Someone who is 
> > > >   only interested in instrumentation related discussions could 
> > > >   subscribe to that list. )
> > > > 
> > > > > > > printk_once() is racy on smp and preempt btw ;)
> > > > > > 
> > > > > > Like WARN_ONCE() and WARN_ON_ONCE(). It's really an "oh crap" 
> > > > > > facility, not for normal kernel messages.
> > > > > > 
> > > > > > Do we want to complicate them with locking and preemption - or 
> > > > > > should we just concentrate on getting the "oh crap" message out 
> > > > > > to the syslog (before it's possibly too late to get anything 
> > > > > > out)?
> > > > > > 
> > > > > > I have no strong opinion about it - but i tend to like the 
> > > > > > simpler method most. printk + stack dumps themselves arent 
> > > > > > atomic to begin with.
> > > > > 
> > > > > Well, it's hardly likely to be a problem.  otoh, if two CPUs _do_ 
> > > > > hit the thing at the same time, the resulting output will be all 
> > > > > messed up and we'd really like to see it.
> > > > > 
> > > > > Easily fixed with test_and_set_bit()?
> > > > 
> > > > but if two CPUs hit it at once then the printk+stack-dump itself is 
> > > > already mixed up. So if we do any atomicity it should be done for 
> > > > all the print-once APIs. (note, lockdep does such message-atomicity 
> > > > already, in its own facility)
> > > 
> > > Confused.
> > > 
> > > <gets distracted by FW_BUG and friends.  ytf are they in kernel.h?>
> > > 
> > > #define printk_once(x...) ({				\
> > > 	static unsigned long __print_once;		\
> > > 							\
> > 
> > hm, this doubles the flag size on 32-bit kernels.
> 
> Well yeah.  I was wondering whether __print_once should be a char 
> anyway.  Will that hurt text size on any arch?  Will gcc dtrt with 
> such things?  It might go and 4-byte align the chars anwyay.

a char would make sense - since they are all rare codepaths 
compression is important - and this should be done for the other 
_ONCE APIs as well.

gcc does the right thing and will compress adjacent char's - but the 
problem is that these char's are unlikely to be adjacent - te 
adjacent variables will likely be larger so the chars will take up 4 
or 8 bytes in practice.

So to achieve compression we'd have to put them into a separate data 
section and have a per arch linker script detail for that. Is that 
worth the trouble? How many flags are we talking about?

	Ingo
