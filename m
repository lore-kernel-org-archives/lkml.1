Return-Path: <linux-kernel-owner+w=401wt.eu-S1757951AbXI3PS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbXI3PS4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 11:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbXI3PSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 11:18:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57428 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456AbXI3PSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 11:18:47 -0400
Date: Sun, 30 Sep 2007 17:18:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] robust futex thread exit race
Message-ID: <20070930151827.GB23127@elte.hu>
References: <1191164539.4047.5.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191164539.4047.5.camel@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.1.7-deb
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0717]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> Hi Ingo,
> I finally found the bug that causes tst-robust8 from the glibc to fail
> on s390x. Turned out to be a common code problem with the processing of
> the robust futex list. The patch below fixes the bug for me.

good catch! A quick preliminary review of your patch indicates it's fine 
- and it might be v2.6.23 material.

Acked-by: Ingo Molnar <mingo@elte.hu>

> Calling handle_futex_death in exit_robust_list for the different 
> robust mutexes of a thread basically frees the mutex. Another thread 
> might grab the lock immediately which updates the next pointer of the 
> mutex. fetch_robust_entry over the next pointer might therefore branch 
> into the robust mutex list of a different thread. This can cause two 
> problems: 1) some mutexes held by the dead thread are not getting 
> freed and 2) some mutexs held by a different thread are freed. The 
> next point need to be read before calling handle_futex_death.

nasty race... Ulrich, Thomas, do you concur?

	Ingo
