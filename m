Return-Path: <linux-kernel-owner+w=401wt.eu-S1757911AbZKDTRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbZKDTRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 14:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757634AbZKDTR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 14:17:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756909AbZKDTR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 14:17:29 -0500
Date: Wed, 4 Nov 2009 14:17:09 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 18/20] blkio: arm idle timer even if think time is
	great then time slice left
Message-ID: <20091104191709.GJ2870@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com> <1257291837-6246-19-git-send-email-vgoyal@redhat.com> <x498wemt8ky.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x498wemt8ky.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 02:04:45PM -0500, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > o Now we plan to wait for a queue to get backlogged before we expire it. So
> >   we need to arm slice timer even if think time is greater than slice left.
> >   if process sends next IO early and time slice is left, we will dispatch it
> >   otherwise we will expire the queue and move on to next queue.
> 
> Should this be rolled into patch 17?  I'm just worried about breaking
> bisection runs.  What happens if this patch isn't applied?
> 

We don't wait for queue to get busy and expire it. That means we will not
get fairness numbers between groups even in simple case of sequential
readers.

So nothing catastrophic. Bisection will not be broken as such (kernel
compiles and boots).

In fact thinking more about it, I might have broken close cooperator logic
as I am waiting for queue to get busy irrespective of the fact whether
there is a close cooperating queue or not. I think need to check for
cooperating queue in cfqq_should_wait_busy() and if one is available,
don't busy wait. This should still maintain fairness at group level as
cooperating queues are not selected across groups and if one cooperating
queue is available in same group, that means expiry of this current queue
will not delete group from service tree and group will still get fair
share. 

Thanks
Vivek
