Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbZFGINm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbZFGINm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 04:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZFGINc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 04:13:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51154 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203AbZFGINa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 04:13:30 -0400
Date: Sun, 7 Jun 2009 10:13:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linus Torvalds <torvalds@linux-foundation.org>, lethal@linux-sh.org,
       just.for.lkml@googlemail.com, hancockrwd@gmail.com,
       jens.axboe@oracle.com, bharrosh@panasas.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
Message-ID: <20090607081305.GA12497@elte.hu>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp> <20090605104132.GE24836@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090605104132.GE24836@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> 
> On Fri, Jun 05, 2009 at 05:33:14PM +0900, FUJITA Tomonori wrote:
> > dma-debugs wrongly assumes that no multiple DMA transfers are
> > performed against the same dma address on one device at the same
> > time. However it's true only with hardware IOMMUs. For example, an
> > application can easily send the same buffer twice with different
> > lengths to one device by using DIO and AIO. If these requests are not
> > unmapped in the same order in which they were mapped,
> > hash_bucket_find() finds a wrong entry and gives a false warning.
> > 
> > We should fix this before 2.6.30 release. Seems that there is no
> > easy way to fix it. I think that it's better to just disable
> > dma-debug for now.
> > 
> > Torsten Kaiser found this bug with the RAID1 configuration:
> > 
> > http://marc.info/?t=124336541900008&r=1&w=2
> > 
> 
> Argh, I never thought that this can happen. But its not explicitly 
> forbidden so we have to handle this situation. Thanks for tracking 
> down the bug to this issue.
>
> However, I think there is a somehow simple fix for the issue. 
> Patch is attached. Its the least intrusive way I can think of to 
> fix this problem.
>
> But its up to Linus/Ingo to decide if it can be accepted at this 
> very late point in the cycle. Since dma-debug is new with 2.6.30 
> it will at least not introduce any regression. [...]

I think it's too late for v2.6.30 to do any of the changes - and the 
DMA debug facility is off by default.

Also, i think such DMA patterns, while 'allowed' can be quite 
dangerous as its such a rare usage combination really. AIO and DIO 
are crazy to begin with, mixing AIO and DIO for the same buffer is 
madness square two. (It can result in 3 agents for the same memory 
address: CPU, dma1 and dma2. How many interesting chipset erratums 
could there be related to such scenarios?)

But it is certainly not the task of a debug facility to restrict 
existing user-visible ABIs, so fixing the false positive is correct.

So i've applied your fix to the iommu branch for v2.6.31 and marked 
it for -stable backporting, that way 2.6.30.1 will be able to pick 
the patch up (if it remains problem-free in testing).

Thanks,

	Ingo
