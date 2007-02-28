Return-Path: <linux-kernel-owner+w=401wt.eu-S1752089AbXB1JJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbXB1JJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 04:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbXB1JJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 04:09:22 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:52261 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbXB1JJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 04:09:20 -0500
Date: Wed, 28 Feb 2007 10:07:50 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: A quick fio test (was Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3)
Message-ID: <20070228090750.GQ3733@kernel.dk>
References: <20070223162508.GA16782@kernel.dk> <20070223171348.GA27838@in.ibm.com> <20070226135736.GF3822@kernel.dk> <20070226141315.GA15631@in.ibm.com> <20070226144548.GH3822@kernel.dk> <20070227043331.GA29942@in.ibm.com> <20070227094211.GR3822@kernel.dk> <20070227123932.GA8720@in.ibm.com> <20070228083100.GM3733@kernel.dk> <20070228083805.GB9705@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228083805.GB9705@elte.hu>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 28 2007, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > Engine                Depth      Batch	Bw (KiB/sec)
> > libaio		20000	   8		21,125
> > syslet		20000	   8		19,610
> 
> i'd like to do something more about this to be more in line with libaio 
> - if nothing else then for the bragging rights ;-) It seems to me that a 
> drop of ~7% in throughput cannot be explained with any CPU overhead, it 
> must be some sort of queueing + IO scheduling effect - right?

syslet shows a slightly higher overhead, but nothing that will account
for any bandwidth change in this test. The box is obviously mostly idle
when running this test, it's not very CPU consuming. The IO pattern
issued is not the same, since libaio would commit IO [0..7], then
[8..15] and so on, where syslet would expose [0,8,16,24,32,40,48,56] and
then [1,9,17,25,33,41,49,57] etc. If iodepth_batch is set to 1 you'd
get a closer match wrt io pattern, but at a higher cost (increased
system calls, and 8 times as many pending async threads). That gets it
to 20,253KiB/s here with ~1000 as many context switches.

So in short, it's harder to compare with real storage, as access
patterns don't translate very easily

-- 
Jens Axboe

