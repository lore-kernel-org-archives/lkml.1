Return-Path: <linux-kernel-owner+w=401wt.eu-S1758662AbZDXGhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbZDXGhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 02:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbZDXGhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 02:37:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60080 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbZDXGhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 02:37:06 -0400
Message-ID: <49F15DF2.30200@cn.fujitsu.com>
Date: Fri, 24 Apr 2009 14:36:34 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Andrea Righi <righi.andrea@gmail.com>
CC: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
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
References: <1240090712-1058-1-git-send-email-righi.andrea@gmail.com> <1240090712-1058-6-git-send-email-righi.andrea@gmail.com> <49F01E8F.80807@cn.fujitsu.com> <20090423102551.GB16768@linux>
In-Reply-To: <20090423102551.GB16768@linux>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> On Thu, Apr 23, 2009 at 03:53:51PM +0800, Gui Jianfeng wrote:
>> Andrea Righi wrote:
>>> Together with cgroup_io_throttle() the kiothrottled kernel thread
>>> represents the core of the io-throttle subsystem.
>>>
>>> All the writeback IO requests that need to be throttled are not
>>> dispatched immediately in submit_bio(). Instead, they are added into an
>>> rbtree by iothrottle_make_request() and processed asynchronously by
>>> kiothrottled.
>>>
>>> A deadline is associated to each request depending on the bandwidth
>>> usage of the cgroup it belongs. When a request is inserted into the
>>> rbtree kiothrottled is awakened. This thread selects all the requests
>>> with an expired deadline and submit the bunch of selected requests to
>>> the underlying block devices using generic_make_request().
>>   Hi Andrea,
>>
>>   What if an user issues "sync", will the bios still be buffered in the rb-tree?
>>   Do we need to flush the whole tree?
> 
> Good question. From The sync(2) man page:
> 
> 	According to the standard specification (e.g., POSIX.1-2001), sync()
> 	schedules the writes, but may return before the actual writing is done.
> 	However, since  version  1.3.20  Linux does  actually  wait.  (This
> 	still  does not guarantee data integrity: modern disks have large
> 	caches.)
> 
> It is not completely wrong looking at the standard. The writes are
> actually scheduled, but pending in the rbtree. Anyway, if we immediately
> dispatch them anyone can evade the IO controller simply issuing a lot of
> sync while doing IO. OTOH dispatching the requests respecting the max
> rate for each cgroup can cause the sync to wait for all the others' BW
> limitations.
> 
> Honestly I don't have a good answer for this. Opinions?

  IMHO, buffered bios should be submitted immediately even if this
  regards as evading when an user issues "sync". Restricting an user
  from issuing "sync" also helps, but seems not easy.


-- 
Regards
Gui Jianfeng

