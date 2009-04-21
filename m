Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbZDUUtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbZDUUtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 16:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbZDUUtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 16:49:14 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45474 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbZDUUtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 16:49:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NCHfL993dAUDsyoPRcUSNYET7spAoArCHYb9wS1J5vcBdCVftLkagrx9ElsOU3nbge
         u4WSdCi4hHdUXmzjhITH2Cja5dMzcv/3nAwSrwa9tkpjuMZyt55eX2VaYbWeTOzASGtS
         l8gbtFlUxxqvn7UbXT5UUD9hyIoB7r0aIdiL8=
Date: Tue, 21 Apr 2009 22:49:06 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>, Paul Menage <menage@google.com>,
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
Message-ID: <20090421204905.GA5573@linux>
References: <20090417143903.GA30365@linux> <20090421001822.GB19186@mit.edu> <20090421083001.GA8441@linux> <20090421140631.GF19186@mit.edu> <20090421143130.GA22626@linux> <20090421163537.GI19186@mit.edu> <20090421172317.GM19637@balbir.in.ibm.com> <20090421174620.GD15541@mit.edu> <20090421181429.GO19637@balbir.in.ibm.com> <20090421191401.GF15541@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421191401.GF15541@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 03:14:01PM -0400, Theodore Tso wrote:
> On Tue, Apr 21, 2009 at 11:44:29PM +0530, Balbir Singh wrote:
> > 
> > That would be true in general, but only the process writing to the
> > file will dirty it. So dirty already accounts for the read/write
> > split. I'd assume that the cost is only for the dirty page, since we
> > do IO only on write in this case, unless I am missing something very
> > obvious.
> 
> Maybe I'm missing something, but the (in development) patches I saw
> seemed to use the existing infrastructure designed for RSS cost
> tracking (which is also not yet in mainline, unless I'm mistaken ---
> but I didn't see page_get_page_cgroup() in the mainline tree yet).

page_get_page_cgroup() is the old page_cgroup interface, now it has been
replaced by lookup_page_cgroup(), that is in the mainline.

> 
> Right?  So if process A in cgroup A reads touches the file first by
> reading from it, then the pages read by process A will be assigned as
> being "owned" by cgroup A.   Then when the patch described at
> 
>       http://lkml.org/lkml/2008/9/9/245

And this patch must be completely reworked.

> 
> ... tries to charge a write done by process B in cgroup B, the code
> will call page_get_page_cgroup(), see that it is "owned" by cgroup A,
> and charge the dirty page to cgroup A.  If process A and all of the
> other processes in cgroup A only access this file read-only, and
> process B is updating this file very heavily --- and it is a large
> file --- then cgroup B will get a completely free pass as far as
> dirtying pages to this file, since it will be all charged 100% to
> cgroup A, incorrectly.

yep! right. Anyway, it's not completely wrong to account dirty pages in
this way. The dirty pages actually belong to cgroup A and providing per
cgroup upper limits of dirty pages could help to equally distribute
dirty pages, that are hard/slow to reclaim, among cgroups.

But this is definitely another problem.

And it doesn't help for the problem described by Ted, expecially for the
IO controller. The only way I see to correctly handle that case is to
limit the rate of dirty pages per cgroup, accounting the dirty activity
to the cgroup that firstly touched the page (and not the owner as
intended by the memory controller).

And this should be probably strictly connected to the IO controller. If
we throttle or delay the dispatching/submission of some IO requests
without throttling the dirty pages rate a cgroup could completely waste
its own available memory with dirty (hard and slow to reclaim) pages.

That is in part the approach I used in io-throttle v12, adding a hook in
balance_dirty_pages_ratelimited_nr() to throttle the current task when
cgroup's IO limit are exceeded. Argh!

So, another proposal could be to re-add in io-throttle v14 the old hook
also in balance_dirty_pages_ratelimited_nr().

In this way io-throttle would:

- use page_cgroup infrastructure and page_cgroup->flags to encode the
  cgroup id that firstly dirtied a generic page
- account and opportunely throttle sync and writeback IO requests in
  submit_bio()
- at the same time throttle the tasks in
  balance_dirty_pages_ratelimited_nr() if the cgroup they belong has
  exhausted the IO BW (or quota, share, etc. in case of proportional BW
  limit)

-Andrea
