Return-Path: <linux-kernel-owner+w=401wt.eu-S1752738AbYKDMES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbYKDMES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 07:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYKDMEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 07:04:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60146 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbYKDMEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 07:04:04 -0500
Date: Tue, 4 Nov 2008 13:03:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: use raw spinlocks instead of spinlocks
Message-ID: <20081104120355.GA19969@elte.hu>
References: <490E3F73.1000405@gmail.com> <alpine.DEB.1.10.0811021940030.32371@gandalf.stny.rr.com> <20081103064647.GA4826@elte.hu> <c62985530811031803o6909518ax137d42189dcff0de@mail.gmail.com> <20081104094341.GO23790@elte.hu> <c62985530811040314o13394d43t201ae3fc2f1304be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530811040314o13394d43t201ae3fc2f1304be@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/11/4 Ingo Molnar <mingo@elte.hu>:
> > lockdep works via a completely different principle: it instruments all
> > the actual lock acquire/release calls and builds a graph of lock
> > dependencies in the system, as it happens.
> >
> > It also guarantees that all the observed locking rules are followed
> > (i.e. it proves that as long as you dont get any messages from
> > lockdep, all the locking patterns are mathematically safe).
> >
> > So a lockdep message will most of the time occur much easier than a
> > real lockup would occur - as lockdep only needs to observe
> > inconsistent locking patterns to prove that a lockup _could_ occur.
> 
> 
> Ok, so if there is such an error, I could (hopefully) see it with
> early_printk....
> 
> 
> > The NMI watchdog just observes the system and complains if it sees
> > hardirqs not progressing (i.e. a hard lockup). It will detect anything
> > that causes a hard lockup. (assuming that the NMI watchdog itself is
> > not locked up)
> >
> > Regarding your lockup ... it's quite hard. Maybe you can get more
> > output out of the system by using:
> >
> >  earlyprintk=vga,keep
> >
> > plus disablig regular tty output. (i.e. not passing any 'console=tty'
> > line to the kernel bootup.)
> >
> > this way you wont get any normal printk activities (which might lock
> > up), you should only get the very simple early-printk output.
> 
> 
> 
> Good idea. After reading your mail, I had a look on early_printk and 
> it shoudn't cause any tracing recursion after your patch: the 
> strings are directly writed to the vga. Great.

just make sure normal printk is totally silent. (otherwise you get 
double lines on the console plus no reduction in recursion risk)

i usually add a return; hack to kernel/printk.c:printk(), to make sure 
it never executes anything. (and add a notrace to it as well) Maybe we 
could even make this dependent on early_printk=...,keep.

	Ingo
