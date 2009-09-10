Return-Path: <linux-kernel-owner+w=401wt.eu-S1752037AbZIJPt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbZIJPt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 11:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbZIJPt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 11:49:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:58710 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbZIJPt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 11:49:27 -0400
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Chris Mason <chris.mason@oracle.com>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, "Theodore Ts'o" <tytso@mit.edu>,
       Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <20090909142315.GA7949@duck.suse.cz>
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com>
	 <1252401791-22463-9-git-send-email-jens.axboe@oracle.com>
	 <4AA633FD.3080006@gmail.com> <1252425983.7746.120.camel@twins>
	 <20090908162936.GA2975@think> <1252428983.7746.140.camel@twins>
	 <20090908172842.GC2975@think> <1252431974.7746.151.camel@twins>
	 <1252432501.7746.156.camel@twins> <1252434746.7035.7.camel@laptop>
	 <20090909142315.GA7949@duck.suse.cz>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 17:49:10 +0200
Message-Id: <1252597750.7205.82.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 16:23 +0200, Jan Kara wrote:
>   Well, what I imagined we could do is:
> Have a per-bdi variable 'pages_written' - that would reflect the amount of
> pages written to the bdi since boot (OK, we'd have to handle overflows but
> that's doable).
> 
> There will be a per-bdi variable 'pages_waited'. When a thread should sleep
> in balance_dirty_pages() because we are over limits, it kicks writeback thread
> and does:
>   to_wait =  max(pages_waited, pages_written) + sync_dirty_pages() (or
> whatever number we decide)
>   pages_waited = to_wait
>   sleep until pages_written reaches to_wait or we drop below dirty limits.
> 
> That will make sure each thread will sleep until writeback threads have done
> their duty for the writing thread.
> 
> If we make sure sleeping threads are properly ordered on the wait queue,
> we could always wakeup just the first one and thus avoid the herding
> effect. When we drop below dirty limits, we would just wakeup the whole
> waitqueue.
> 
> Does this sound reasonable?

That seems to go wrong when there's multiple tasks waiting on the same
bdi, you'd count each page for 1/n its weight.

Suppose pages_written = 1024, and 4 tasks block and compute their to
wait as pages_written + 256 = 1280, then we'd release all 4 of them
after 256 pages are written, instead of 4*256, which would be
pages_written = 2048.



