Return-Path: <linux-kernel-owner+w=401wt.eu-S1750740AbXBUXB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750740AbXBUXB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbXBUXB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:01:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52683 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbXBUXB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:01:57 -0500
Date: Wed, 21 Feb 2007 23:57:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070221225711.GB32031@elte.hu>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -3.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-3.8 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael K. Edwards <medwards.linux@gmail.com> wrote:

> 3) Reworked threadlet scheduling to allow tens of thousands of blocked 
> threadlets to be dispatched efficiently in a controlled, throttled, 
> non-cache-and-MMU-thrashing manner, immediately following the softirq 
> that unblocks the I/O they're waiting on; and

threadlets, when they dont block, are just regular user-space function 
calls - so no need to schedule or throttle them. [*]

threadlets, when they block, are regular kernel threads, so the regular 
O(1) scheduler takes care of them. If MMU trashing is of any concern 
then syslets should be used to implement the most performance-critical 
events: under Linux a kernel thread that does not exit out to user-space 
does not do any TLB switching at all. (even if there are multiple 
processes active and their syslets intermix)

throttling of outstanding async contexts is most easily done by 
user-space - you can see an example in threadlet-test.c, but there's 
also fio/engines/syslet-rw.c. v2 had a kernel-space throttling mechanism 
as well, i'll probably reintroduce that in later versions.

	Ingo

[*] although certain more advanced scheduling tactics like the detection 
    of frequently executed threadlet functions and their pushing out to 
    separate contexts is possible too - but this is an optional add-on 
    and for later.

