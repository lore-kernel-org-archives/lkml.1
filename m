Return-Path: <linux-kernel-owner+w=401wt.eu-S1757421AbZEKBeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbZEKBeQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 21:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756869AbZEKBeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 21:34:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64583 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756379AbZEKBeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 21:34:00 -0400
Message-ID: <4A078051.5060702@cn.fujitsu.com>
Date: Mon, 11 May 2009 09:33:05 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Nauman Rafique <nauman@google.com>
CC: Vivek Goyal <vgoyal@redhat.com>, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com,
       snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
Subject: Re: [PATCH] io-controller: Add io group reference handling for 	request
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com>	 <4A03FF3C.4020506@cn.fujitsu.com> <20090508135724.GE7293@redhat.com> <e98e18940905081041r386e52a5q5a2b1f13f1e8c634@mail.gmail.com>
In-Reply-To: <e98e18940905081041r386e52a5q5a2b1f13f1e8c634@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nauman Rafique wrote:
> On Fri, May 8, 2009 at 6:57 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> On Fri, May 08, 2009 at 05:45:32PM +0800, Gui Jianfeng wrote:
>>> Hi Vivek,
>>>
>>> This patch adds io group reference handling when allocating
>>> and removing a request.
>>>
>> Hi Gui,
>>
>> Thanks for the patch. We were thinking that requests can take a reference
>> on io queues and io queues can take a reference on io groups. That should
>> make sure that io groups don't go away as long as active requests are
>> present.
>>
>> But there seems to be a small window while allocating the new request
>> where request gets allocated from a group first and then later it is
>> mapped to that group and queue is created. IOW, in get_request_wait(),
>> we allocate a request from a particular group and set rq->rl, then
>> drop the queue lock and later call elv_set_request() which again maps
>> the request to the group saves rq->iog and creates new queue. This window
>> is troublesome because request can be mapped to a particular group at the
>> time of allocation and during set_request() it can go to a different
>> group as queue lock was dropped and group might have disappeared.
>>
>> In this case probably it might make sense that request also takes a
>> reference on groups. At the same time it looks too much that request takes
>> a reference on queue as well as group object. Ideas are welcome on how
>> to handle it...
> 
> IMHO a request being allocated on the wrong cgroup should not be a big
> problem as such. All it means is that the request descriptor was
> accounted to the wrong cgroup in this particular corner case. Please
> correct me if I am wrong.
> 
> We can also get rid of rq->iog pointer too. What that means is that
> request is associated with ioq (rq->ioq), and we can use
> ioq_to_io_group() function to get the io_group. So the request would
> only be indirectly associated with an io_group i.e. the request is
> associated with an io_queue and the io_group for the request is the
> io_group associated with io_queue. Do you see any problems with that
> approach?

  That sounds reasonable to get rid of rq->iog, and rq->rl is also dead.
  Hope to see the patch soon. ;)

-- 
Regards
Gui Jianfeng

