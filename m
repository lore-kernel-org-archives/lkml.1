Return-Path: <linux-kernel-owner+w=401wt.eu-S1751403AbXBOAHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbXBOAHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 19:07:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbXBOAHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 19:07:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48748 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbXBOAHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 19:07:11 -0500
Date: Thu, 15 Feb 2007 01:04:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
Message-ID: <20070215000447.GA23707@elte.hu>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org> <20070214220948.GA3790@elte.hu> <Pine.LNX.4.64.0702141504140.20368@woody.linux-foundation.org> <20070214234417.GA16332@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214234417.GA16332@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > You are not counting the whole setup cost there, then, because your 
> > setup cost is going to be at a minimum more expensive than the null 
> > system call.
> 
> hm, this one-time cost was never on my radar. [ It's really dwarved by 
> other startup costs (a single fork() takes 100 usecs, an exec() takes 
> 800 usecs.) ]

i really count this into the category of 'application startup', and thus 
it's is another type of 'cachemiss': the cost of having to bootstrap a 
new context. (Even though obviously we want this to go as fast as 
possible too.) Library startups, linking (even with prelink), etc., is 
quite expensive already - goes into the tens of milliseconds.

or if it's a new thread startup - where this cost would indeed be 
visible, if the thread exits straight after being startup up, and where 
this thread would want to do a single AIO, then shareable async heads 
(see my mail to Alan) ought to solve this. (But short-lifetime threads 
are not really a good idea in themselves.)

but the moment it's some fork()ed context, or even an exec()ed context, 
this cost is very small in comparisno. And who in their right mind 
starts up a whole new process just to do a single IO and then exit 
without doing any other processing? (so that the async setup cost would 
show up)

but, short-lived contexts, where this cost would be visible, are 
generally a really bad idea.

	Ingo
