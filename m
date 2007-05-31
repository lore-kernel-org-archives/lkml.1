Return-Path: <linux-kernel-owner+w=401wt.eu-S1760894AbXEaKvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760894AbXEaKvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 06:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758742AbXEaKvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 06:51:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38512 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758694AbXEaKvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 06:51:47 -0400
Date: Thu, 31 May 2007 12:50:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Ulrich Drepper <drepper@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
Message-ID: <20070531105048.GA19796@elte.hu>
References: <20070530084252.GA15708@elte.hu> <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org> <465DE992.6070803@redhat.com> <alpine.LFD.0.98.0705301422230.26602@woody.linux-foundation.org> <Pine.LNX.4.64.0705301443340.6272@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0705301457350.26602@woody.linux-foundation.org> <20070531061303.GA4436@elte.hu> <20070531090252.GA29817@elte.hu> <20070531124129.31c14ddd.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531124129.31c14ddd.dada1@cosmosbay.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> I tried your bench and found two problems :
> - You scan half of the bitmap
[...]
> Try to close not a 'middle fd', but a really low one (10 for example), 
> and latencie is doubled.

that was intentional. I really didnt want to fabricate a worst-case 
result but something more representative: in real apps the bitmap isnt 
fully filled all the time and most of the find-bit sequences are short. 
Hence the two fds and one of them goes from the middle of the range.

> - You incorrectlty divide best_delta and worst_delta by LOOPS (5)

ah, indeed, that's a bug - victim of a last minute edit :) Since the 
divident is constant it doesnt really matter to the validity of the 
relative nature of the slowdown (which is what i was intested in), but 
you are right - i have fixed the download and have redone the numbers. 
Here are the correct results from my box:

 # ./fd-scale-bench 1000000 0
 checking the cache-hot performance of open()-ing 1000000 fds.
 num_fds: 1, best cost: 6.00 us, worst cost: 8.00 us
 num_fds: 2, best cost: 6.00 us, worst cost: 7.00 us
 ...
 num_fds: 31586, best cost: 7.00 us, worst cost: 8.00 us
 num_fds: 39483, best cost: 8.00 us, worst cost: 8.00 us
 num_fds: 49354, best cost: 7.00 us, worst cost: 9.00 us
 num_fds: 61693, best cost: 8.00 us, worst cost: 10.00 us
 num_fds: 77117, best cost: 8.00 us, worst cost: 13.00 us
 num_fds: 96397, best cost: 9.00 us, worst cost: 11.00 us
 num_fds: 120497, best cost: 10.00 us, worst cost: 14.00 us
 num_fds: 150622, best cost: 11.00 us, worst cost: 13.00 us
 num_fds: 188278, best cost: 12.00 us, worst cost: 15.00 us
 num_fds: 235348, best cost: 14.00 us, worst cost: 20.00 us
 num_fds: 294186, best cost: 16.00 us, worst cost: 22.00 us
 num_fds: 367733, best cost: 19.00 us, worst cost: 35.00 us
 num_fds: 459667, best cost: 22.00 us, worst cost: 37.00 us
 num_fds: 574584, best cost: 26.00 us, worst cost: 40.00 us
 num_fds: 718231, best cost: 31.00 us, worst cost: 62.00 us
 num_fds: 897789, best cost: 37.00 us, worst cost: 54.00 us
 num_fds: 1000000, best cost: 41.00 us, worst cost: 59.00 us

and cache-cold:

 # ./fd-scale-bench 1000000 1
 checking the cache-cold performance of open()-ing 1000000 fds.
 num_fds: 1, best cost: 24.00 us, worst cost: 32.00 us
 ...
 num_fds: 49354, best cost: 26.00 us, worst cost: 28.00 us
 num_fds: 61693, best cost: 25.00 us, worst cost: 30.00 us
 num_fds: 77117, best cost: 27.00 us, worst cost: 30.00 us
 num_fds: 96397, best cost: 27.00 us, worst cost: 31.00 us
 num_fds: 120497, best cost: 31.00 us, worst cost: 43.00 us
 num_fds: 150622, best cost: 31.00 us, worst cost: 34.00 us
 num_fds: 188278, best cost: 33.00 us, worst cost: 36.00 us
 num_fds: 235348, best cost: 35.00 us, worst cost: 42.00 us
 num_fds: 294186, best cost: 36.00 us, worst cost: 41.00 us
 num_fds: 367733, best cost: 40.00 us, worst cost: 43.00 us
 num_fds: 459667, best cost: 44.00 us, worst cost: 46.00 us
 num_fds: 574584, best cost: 48.00 us, worst cost: 65.00 us
 num_fds: 718231, best cost: 54.00 us, worst cost: 59.00 us
 num_fds: 897789, best cost: 60.00 us, worst cost: 62.00 us
 num_fds: 1000000, best cost: 65.00 us, worst cost: 68.00 us

> with a corrected bench; cache-cold numbers are > 100 us on this Intel 
> Pentium-M
> 
> num_fds: 1000000, best cost: 120.00 us, worst cost: 131.00 us
> 
> On an Opteron x86_64 machine, results are better :)
> 
> num_fds: 1000000, best cost: 28.00 us, worst cost: 106.00 us

yeah. I quoted the full range because i was really more interested of 
our current 'limit' range (which is somewhere between 50K and 100K open 
fds) where the scanning cost becomes directly measurable, and the nature 
of slowdown.

	Ingo
