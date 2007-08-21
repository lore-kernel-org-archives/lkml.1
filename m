Return-Path: <linux-kernel-owner+w=401wt.eu-S1759512AbXHULgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512AbXHULgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 07:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbXHULgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 07:36:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55556 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbXHULgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 07:36:23 -0400
Date: Tue, 21 Aug 2007 13:36:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [accounting regression since rc1]  scheduler updates
Message-ID: <20070821113611.GB2390@elte.hu>
References: <20070812163225.GA11996@elte.hu> <200708141037.48001.borntraeger@de.ibm.com> <20070820154529.GA300@elte.hu> <200708211017.02998.borntraeger@de.ibm.com> <20070821084243.GB1144@elte.hu> <1187687476.7623.8.camel@localhost> <20070821093434.GB12025@elte.hu> <1187692696.24279.7.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187692696.24279.7.camel@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4972]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> > Wouldnt it be more consistent if a virtual box would not show any 
> > dependency on external load? (i.e. it would slow down all of its 
> > internal functionality transparently, without exposing it via /proc. 
> > The only way to observe that would be the TOD interfaces: 
> > gettimeofday and real-time clock driven POSIX timers. Even 
> > timer_list could be driven via virtual time - although that would 
> > probably break user expectations, right?) Or would 
> > accounting-in-virtual-time break user expectations too? (most of the 
> > other hypervisors let guests account in virtual time.
> 
> No, imho it is less consistent if the virtual box shows virtual time. 
> If you look at the top output as a user and it shows that some process 
> used x% of cpu what does it tell you? [...]

it tells me something really important: that the virtual box's scheduler 
gave this task as much CPU time as it could.

> [...] With virtual cpus next to nothing, you have to normalize the 
> numbers with the %steal while the process was running. But even then 
> it still is not a good number because the %steal changes while a 
> process is running. The only good solution is to use virtual time for 
> all cputime values.

the steal percentage is really a concept one step higher in the 
scheduling hierarchy. You should be running top (or an equivalent tool) 
in the _hypervisor_ context if you want to know about how much time each 
virtual box gets. 'mixing' that information with the 'internal' task 
statistics of the virtual box is less consistent IMO and leads to the 
loss of information. (with the 'mixing' method there's no way to tell 
whether a task got all CPU time it asked for - and _that_ is which an 
admin is interested in just as much as the time allocation between 
virtual boxes.)

so in say KVM you determine the steal percentage by looking at 'top' 
output in the hypervisor context. (or looking at steal% in the internal 
top output) Looking at 'top' in the guest tells you everything internal 
to that guest, without mixing external scheduling information into it.

	Ingo
