Return-Path: <linux-kernel-owner+w=401wt.eu-S1755181AbZDUObq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbZDUObq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 10:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbZDUObg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 10:31:36 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:40942 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZDUObg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 10:31:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OAu4apWPAHErfljsQXv0WZ6bTjaVz2jSrzU55JZ6D0TtMksxdLZe5EDFahjOEFUl7t
         lkFyPk6PF8PCsC+Dd543Bwl1FlJeHMCeJFEuzJZijsf9ZvVir7mHZjvBiaxofqmtvmK9
         TVHBk6GZ7K4GAyMds4wgyuffgtPK8oKhXIU3U=
Date: Tue, 21 Apr 2009 16:31:31 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Jens Axboe <jens.axboe@oracle.com>, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] ext3: do not throttle metadata and journal IO
Message-ID: <20090421143130.GA22626@linux>
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com> <1239740480-28125-10-git-send-email-righi.andrea@gmail.com> <20090417123805.GC7117@mit.edu> <20090417125004.GY4593@kernel.dk> <20090417143903.GA30365@linux> <20090421001822.GB19186@mit.edu> <20090421083001.GA8441@linux> <20090421140631.GF19186@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421140631.GF19186@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 10:06:31AM -0400, Theodore Tso wrote:
> On Tue, Apr 21, 2009 at 10:30:02AM +0200, Andrea Righi wrote:
> > 
> > We're trying to address also this issue, setting max dirty pages limit
> > per cgroup, and force a direct writeback when these limits are exceeded.
> > 
> > In this case dirty ratio throttling should happen automatically because
> > the process will be throttled by the IO controller when it tries to
> > writeback the dirty pages and submit IO requests.
> 
> The challenge here will be the accounting; consider that you may have
> a file that had some of its pages in its page cache dirtied by a
> process in cgroup A.  Now another process in cgroup B dirties some
> more pages.  This could happen either via a mmap'ed file or via the
> standard read/write system calls.  How do you track which dirty pages
> should be charged against which cgroup?
> 
> 							- Ted

Some months ago I posted a proposal to account, track and limit per
cgroup dirty pages in the memory cgroup subsystem:

https://lists.linux-foundation.org/pipermail/containers/2008-September/013140.html

At the moment I'm reworking on a similar and updated version. I know
that Kamezawa is also implementing something to account per cgroup dirty
pages in memory cgroup.

Moreover, io-throttle v14 already uses the page_cgroup structure to
encode into page_cgroup->flags the cgroup ID (io-throttle css_id()
actually) that originally dirtied the page.

This should be enough to track dirty pages and charge the right cgroup.

-Andrea
