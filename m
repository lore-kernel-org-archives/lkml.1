Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbZDWMtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbZDWMtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757022AbZDWMtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:49:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:4353 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757113AbZDWMs5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:48:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,235,1239001200"; 
   d="scan'208";a="684264646"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Leech, Christopher" <christopher.leech@intel.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Thu, 23 Apr 2009 13:48:50 +0100
Subject: RE: [RFC][PATCH v3 6/6] fix wrong get_user_pages usage in iovlock.c
Thread-Topic: [RFC][PATCH v3 6/6] fix wrong get_user_pages usage in iovlock.c
Thread-Index: AcnA66MnMpg/MOUhRuG1P38wELQzYQDJY/jA
Message-ID: <129600E5E5FB004392DDC3FB599660D79A253143@irsmsx504.ger.corp.intel.com>
References: <20090415174658.AC4F.A69D9226@jp.fujitsu.com>
 <129600E5E5FB004392DDC3FB599660D792A39DCE@irsmsx504.ger.corp.intel.com>
 <20090419202447.FFC2.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090419202447.FFC2.A69D9226@jp.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>> KOSAKI Motohiro wrote:
>>>>> I would perhaps not fold gup_fast conversions into the same patch as
>>>>> the fix.
>>>> 
>>>> OK. I'll fix.
>>> 
>>> Done.
>>> 
>>> 
>>> 
>>> ===================================
>>> Subject: [Untested][RFC][PATCH] fix wrong get_user_pages usage in iovlock.c
>>> 
>>> 	down_read(mmap_sem)
>>> 	get_user_pages()
>>> 	up_read(mmap_sem)
>>> 
>>> is fork unsafe.
>>> fix it.
>>> 
>>> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>> Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
>>> Cc: David S. Miller <davem@davemloft.net>
>>> Cc: Chris Leech <christopher.leech@intel.com>
>>> Cc: netdev@vger.kernel.org
>>> ---
>>>  drivers/dma/iovlock.c |    4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>> 
>>> Index: b/drivers/dma/iovlock.c
>>> ===================================================================
>>> --- a/drivers/dma/iovlock.c	2009-04-13 22:58:36.000000000 +0900
>>> +++ b/drivers/dma/iovlock.c	2009-04-14 20:27:16.000000000 +0900
>>> @@ -104,8 +104,6 @@ struct dma_pinned_list *dma_pin_iovec_pa  			0,	/* force */
>>>  			page_list->pages,
>>>  			NULL);
>>> -		up_read(&current->mm->mmap_sem);
>>> -
>>>  		if (ret != page_list->nr_pages)
>>>  			goto unpin;
>>> 
>>> @@ -127,6 +125,8 @@ void dma_unpin_iovec_pages(struct dma_pi  	if (!pinned_list)
>>>  		return;
>>> 
>>> +	up_read(&current->mm->mmap_sem);
>>> +
>>>  	for (i = 0; i < pinned_list->nr_iovecs; i++) {
>>>  		struct dma_page_list *page_list = &pinned_list->page_list[i];
>>>  		for (j = 0; j < page_list->nr_pages; j++) {
>> 
>> I have tried it with net_dma and here is what I've got.
> 
> Thanks.
> Instead, How about this?
> 

Unfortuantelly still does not look good.

Regards,
Maciej

 =============================================
 [ INFO: possible recursive locking detected ]
 2.6.30-rc2 #14
 ---------------------------------------------
 iperf/9932 is trying to acquire lock:
  (&mm->mmap_sem){++++++}, at: [<ffffffff804e3d5e>] do_page_fault+0x170/0

 
 but task is already holding lock:
  (&mm->mmap_sem){++++++}, at: [<ffffffff80488722>] tcp_recvmsg+0x3a/0xa7

 
 other info that might help us debug this:
 2 locks held by iperf/9932:
  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff80488722>] tcp_recvmsg+0x3a

  #1:  (sk_lock-AF_INET){+.+.+.}, at: [<ffffffff80450965>] sk_wait_data+0

 
 stack backtrace:
 Pid: 9932, comm: iperf Tainted: G        W  2.6.30-rc2 #14
 Call Trace:
  [<ffffffff8025b861>] ? validate_chain+0x55a/0xc7c
  [<ffffffff8025c6e6>] ? __lock_acquire+0x763/0x7ec
  [<ffffffff8025c835>] ? lock_acquire+0xc6/0xea
  [<ffffffff804e3d5e>] ? do_page_fault+0x170/0x29d
  [<ffffffff804e0693>] ? down_read+0x46/0x77
  [<ffffffff804e3d5e>] ? do_page_fault+0x170/0x29d
  [<ffffffff804e3d5e>] ? do_page_fault+0x170/0x29d
  [<ffffffff804e1ebf>] ? page_fault+0x1f/0x30
  [<ffffffff803580ed>] ? copy_user_generic_string+0x2d/0x40
  [<ffffffff804562cc>] ? memcpy_toiovec+0x36/0x66
  [<ffffffff804569eb>] ? skb_copy_datagram_iovec+0x133/0x1f0
  [<ffffffff80490199>] ? tcp_rcv_established+0x297/0x71a
  [<ffffffff804953f8>] ? tcp_v4_do_rcv+0x2c/0x1d5
  [<ffffffff8024ebb3>] ? autoremove_wake_function+0x0/0x2e
  [<ffffffff80486239>] ? tcp_prequeue_process+0x6b/0x7e
  [<ffffffff80488b31>] ? tcp_recvmsg+0x449/0xa70
  [<ffffffff8025c704>] ? __lock_acquire+0x781/0x7ec
  [<ffffffff8044f5d5>] ? sock_common_recvmsg+0x30/0x45
  [<ffffffff8044d81b>] ? sock_recvmsg+0xf0/0x10f
  [<ffffffff80259c3c>] ? trace_hardirqs_on_caller+0x11d/0x148
  [<ffffffff8024ebb3>] ? autoremove_wake_function+0x0/0x2e
  [<ffffffff8020c43c>] ? restore_args+0x0/0x30
  [<ffffffff802b553c>] ? fget_light+0xd5/0xdf
  [<ffffffff802b54b0>] ? fget_light+0x49/0xdf
  [<ffffffff8044e8ef>] ? sys_recvfrom+0xbc/0x119
  [<ffffffff802331cd>] ? try_to_wake_up+0x2ae/0x2c0
  [<ffffffff802718f7>] ? audit_syscall_entry+0x192/0x1bd
  [<ffffffff8020b96b>] ? system_call_fastpath+0x16/0x1b
