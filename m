Return-Path: <linux-kernel-owner+w=401wt.eu-S1762170AbZEGSW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762170AbZEGSW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZEGSWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:22:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35295 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbZEGSWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:22:44 -0400
Date: Thu, 7 May 2009 20:21:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>, Jake Edge <jake@lwn.net>,
       security@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Roland McGrath <roland@redhat.com>, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Dave Jones <davej@redhat.com>
Subject: Re: [Security] [PATCH] proc: avoid information leaks to
	non-privileged processes
Message-ID: <20090507182104.GA30659@elte.hu>
References: <m14ow0ynjm.fsf@fess.ebiederm.org> <20090505195246.GC21973@elte.hu> <20090505202219.GL31071@waste.org> <20090506103034.GA25203@elte.hu> <20090506162543.GT31071@waste.org> <alpine.LFD.2.01.0905060942340.4983@localhost.localdomain> <20090506175717.GY31071@waste.org> <20090507005016.GJ31071@waste.org> <20090507150231.GB2344@elte.hu> <20090507181434.GL31071@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507181434.GL31071@waste.org>
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


* Matt Mackall <mpm@selenic.com> wrote:

> >  aldebaran:~/l> ./lat_proc fork
> >  Process fork+exit: 61.7865 microseconds
> 
> Uh, what? There's no exec() involved in fork+exit, so hopefully 
> ASLR doesn't decide to make an appearance.

We use it to seed the per task stackprotector secret. Look for 
get_random_int() in kernel/fork.c.

(
  Now, if get_random_int() slows down we could certainly water that 
  down and have a system-wide secret and some easy and fast 
  long-cycle permutation code to make it not so easy to figure out 
  the core secret from a kernel crash signature.

  [ Alas, that might be worth doing in any case - to not have 
    get_random_int() in the clone() / pthread_create() fastpath. ]

  We really need a design decision there - if get_random_int() is 
  supposed to be a mathematically safe hash, ignoring the physics of 
  the world, then we need a separate get_random_int_fast() API or 
  so. All current users of get_random_int() will evaporate as well. 
)

	Ingo
