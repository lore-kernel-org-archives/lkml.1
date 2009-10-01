Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbZJAS6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbZJAS6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 14:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbZJAS6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 14:58:14 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44376 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbZJAS6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 14:58:13 -0400
Date: Thu, 1 Oct 2009 20:58:16 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Vivek Goyal <vgoyal@redhat.com>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
Subject: Re: IO scheduler based IO controller V10
Message-ID: <20091001185816.GU14918@kernel.dk>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com> <4ABC28DE.7050809@datenparkplatz.de> <20090925202636.GC15007@redhat.com> <1253976676.7005.40.camel@marge.simson.net> <1254034500.7933.6.camel@marge.simson.net> <20090927164235.GA23126@kernel.dk> <1254340730.7695.32.camel@marge.simson.net> <1254341139.7695.36.camel@marge.simson.net> <20090930202447.GA28236@redhat.com> <1254382405.7595.9.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254382405.7595.9.camel@marge.simson.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01 2009, Mike Galbraith wrote:
> > CIC_SEEK_THR is 8K jiffies so that would be 8seconds on 1000HZ system. Try
> > using one "slice_idle" period of 8 ms. But it might turn out to be too
> > short depending on the disk speed.
> 
> Yeah, it is too short, as is even _400_ ms.  Trouble is, by the time
> some new task is determined to be seeky, the damage is already done.
> 
> The below does better, though not as well as "just say no to overload"
> of course ;-)

So this essentially takes the "avoid impact from previous slice" to a
new extreme, but idling even before dispatching requests from the new
queue. We basically do two things to prevent this already - one is to
only set the slice when the first request is actually serviced, and the
other is to drain async requests completely before starting sync ones.
I'm a bit surprised that the former doesn't solve the problem fully, I
guess what happens is that if the drive has been flooded with writes, it
may service the new read immediately and then return to finish emptying
its writeback cache. This will cause an impact for any sync IO until
that cache is flushed, and then cause that sync queue to not get as much
service as it should have.

Perhaps the "set slice on first complete" isn't working correctly? Or
perhaps we just need to be more extreme.

-- 
Jens Axboe

