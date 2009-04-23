Return-Path: <linux-kernel-owner+w=401wt.eu-S1757462AbZDWK0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbZDWK0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 06:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbZDWK0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 06:26:03 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:49785 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbZDWK0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 06:26:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CjcMr6TaP3aPytKZ7V68jHSjq35sY5MuSPsuqGgomXNmQA4+pspvM1D3bJMZj5FnWj
         n2iALPUJNEepPDKbNaCRzscl9OzaQDDrPY3R6K6F6HSvMKGkcDVIaExi03kLLJ81DX02
         K4e6t755cvbDXGKZvF1RRUcvC0v1Ayb+xm9sk=
Date: Thu, 23 Apr 2009 12:25:52 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, Nauman Rafique <nauman@google.com>,
       fchecconi@gmail.com, paolo.valente@unimore.it,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] kiothrottled: throttle buffered (writeback) IO
Message-ID: <20090423102551.GB16768@linux>
References: <1240090712-1058-1-git-send-email-righi.andrea@gmail.com> <1240090712-1058-6-git-send-email-righi.andrea@gmail.com> <49F01E8F.80807@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F01E8F.80807@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 03:53:51PM +0800, Gui Jianfeng wrote:
> Andrea Righi wrote:
> > Together with cgroup_io_throttle() the kiothrottled kernel thread
> > represents the core of the io-throttle subsystem.
> > 
> > All the writeback IO requests that need to be throttled are not
> > dispatched immediately in submit_bio(). Instead, they are added into an
> > rbtree by iothrottle_make_request() and processed asynchronously by
> > kiothrottled.
> > 
> > A deadline is associated to each request depending on the bandwidth
> > usage of the cgroup it belongs. When a request is inserted into the
> > rbtree kiothrottled is awakened. This thread selects all the requests
> > with an expired deadline and submit the bunch of selected requests to
> > the underlying block devices using generic_make_request().
> 
>   Hi Andrea,
> 
>   What if an user issues "sync", will the bios still be buffered in the rb-tree?
>   Do we need to flush the whole tree?

Good question. From The sync(2) man page:

	According to the standard specification (e.g., POSIX.1-2001), sync()
	schedules the writes, but may return before the actual writing is done.
	However, since  version  1.3.20  Linux does  actually  wait.  (This
	still  does not guarantee data integrity: modern disks have large
	caches.)

It is not completely wrong looking at the standard. The writes are
actually scheduled, but pending in the rbtree. Anyway, if we immediately
dispatch them anyone can evade the IO controller simply issuing a lot of
sync while doing IO. OTOH dispatching the requests respecting the max
rate for each cgroup can cause the sync to wait for all the others' BW
limitations.

Honestly I don't have a good answer for this. Opinions?

-Andrea
